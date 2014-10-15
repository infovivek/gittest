SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BedBookingPropertyAssingedGuest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BedBookingPropertyAssingedGuest_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: (25/04/2014)  >
Section  	: Bed Booking Property Assinged Guest Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Description of Changes
********************************************************************************************************	
Sakthi          12 Jun 2014     Property ChkIn Type & Time,ChkOut Type & Time,Grace Time,Rack Tariff Added
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_BedBookingPropertyAssingedGuest_Insert](
@BookingId BIGINT,
@EmpCode NVARCHAR(100),
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@GuestId BIGINT,
@BedType NVARCHAR(100),
@ServicePaymentMode NVARCHAR(100),
@TariffPaymentMode NVARCHAR(100),
@Tariff DECIMAL(27,2),
@RoomId BIGINT,
@BedId BIGINT,
@BookingPropertyId BIGINT,
@BookingPropertyTableId BIGINT,
@UsrId BIGINT,
@SSPId BIGINT)
AS
BEGIN
 IF @SSPId != 0
  BEGIN
   UPDATE WRBHBSSPCodeGeneration SET IsActive=0,IsDeleted=0,
   ModifiedBy=@UsrId,ModifiedDate=GETDATE() WHERE Id=@SSPId;
  END
 -- CheckIn Date & CheckOut Date Data Get From Booking Table
 DECLARE @ChkInDt DATE,@ChkOutDt DATE;
 DECLARE @ExptTime NVARCHAR(100),@AMPM NVARCHAR(100);
 SELECT @ChkInDt=CheckInDate,@ChkOutDt=CheckOutDate,
 @ExptTime=ExpectedChkInTime,@AMPM=AMPM FROM WRBHBBooking 
 WHERE Id=@BookingId;
 -- CheckOut Type & Rack Tariff
 DECLARE @RackTariff DECIMAL(27,2)=0,@PtyGraceTime INT=0;
 DECLARE @PtyChkInTime INT=0,@PtyChkOutTime INT=0;
 DECLARE @PtyChkInAMPM NVARCHAR(100)='',@PtyChkOutAMPM NVARCHAR(100)='';
 SELECT @PtyChkInTime=ISNULL(CheckIn,0),@PtyChkInAMPM=ISNULL(CheckInType,''),
 @PtyChkOutTime=ISNULL(CheckOut,0),@PtyChkOutAMPM=ISNULL(CheckOutType,''),
 @PtyGraceTime=ISNULL(GraceTime,0)
 FROM WRBHBProperty WHERE Id=@BookingPropertyId;
 SELECT @RackTariff=ISNULL(BedRackTarrif,0) FROM WRBHBPropertyRoomBeds 
 WHERE Id=@BedId;
 -- Apartment Id
 DECLARE @ApartmentId BIGINT;
 SELECT @ApartmentId=ISNULL(ApartmentId,0) FROM WRBHBPropertyRooms 
 WHERE Id=@RoomId;
 -- TITLE
 DECLARE @Title NVARCHAR(100)='';
 SET @Title=(SELECT ISNULL(Title,'') FROM WRBHBBookingGuestDetails 
 WHERE GuestId=@GuestId AND BookingId=@BookingId);
 -- 
 DECLARE @Cnt INT=0,@BookingCode BIGINT=0;
 SET @BookingCode=(SELECT ISNULL(BookingCode,0) FROM WRBHBBooking 
 WHERE Id=@BookingId);
 IF @BookingCode = 0
  BEGIN
   SET @Cnt=(SELECT COUNT(*) FROM WRBHBBooking WHERE IsDeleted=0 AND 
   IsActive=1 AND BookingCode != 0);
   IF @Cnt = 0 
    BEGIN
     SET @BookingCode=1;
    END
   ELSE
    BEGIN
     SET @BookingCode=(SELECT TOP 1 BookingCode+1 FROM WRBHBBooking 
     WHERE IsDeleted=0 AND IsActive=1 AND BookingCode != 0 
     ORDER BY BookingCode DESC);
    END
   UPDATE WRBHBBooking SET BookingCode=@BookingCode WHERE Id=@BookingId;
  END 
 -- Insert 
 INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
 FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
 BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
 TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
 CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
 ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
 PtyChkOutTime,PtyGraceTime,CurrentStatus,Title)
 VALUES(@BookingId,@EmpCode,@FirstName,@LastName,@GuestId,@BedType,
 @Tariff,@RoomId,@BedId,@SSPId,@BookingPropertyId,@BookingPropertyTableId,
 @ServicePaymentMode,@TariffPaymentMode,@ChkInDt,@ChkOutDt,@ExptTime,
 @AMPM,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
 @ApartmentId,@RackTariff,@PtyChkInAMPM,@PtyChkOutAMPM,@PtyChkInTime,
 @PtyChkOutTime,@PtyGraceTime,'Booked',@Title);
 SELECT Id,RowId FROM WRBHBBedBookingPropertyAssingedGuest 
 WHERE Id=@@IDENTITY;
END