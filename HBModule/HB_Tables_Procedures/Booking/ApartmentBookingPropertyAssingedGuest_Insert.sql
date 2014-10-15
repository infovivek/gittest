SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ApartmentBookingPropertyAssingedGuest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ApartmentBookingPropertyAssingedGuest_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: (2/06/2014)  >
Section  	: Apartment Booking Property Assinged Guest Insert
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
CREATE PROCEDURE [dbo].[SP_ApartmentBookingPropertyAssingedGuest_Insert](
@BookingId BIGINT,
@EmpCode NVARCHAR(100),
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@GuestId BIGINT,
@ApartmentType NVARCHAR(100),
@ServicePaymentMode NVARCHAR(100),
@TariffPaymentMode NVARCHAR(100),
@Tariff DECIMAL(27,2),
@ApartmentId BIGINT,
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
 DECLARE @PtyChkInTime INT=0,@PtyChkOutTime INT=0;
 DECLARE @PtyChkInAMPM NVARCHAR(100)='',@PtyChkOutAMPM NVARCHAR(100)='';
 DECLARE @PtyGraceTime INT=0;
 SELECT @PtyChkInTime=ISNULL(CheckIn,0),@PtyChkInAMPM=ISNULL(CheckInType,''),
 @PtyChkOutTime=ISNULL(CheckOut,0),@PtyChkOutAMPM=ISNULL(CheckOutType,''),
 @PtyGraceTime=ISNULL(GraceTime,0)
 FROM WRBHBProperty WHERE Id=@BookingPropertyId;
 --
 DECLARE @RackTariff DECIMAL(27,2)=0;
 SELECT @RackTariff=ISNULL(RackTariff,0) FROM WRBHBPropertyApartment 
 WHERE Id=@ApartmentId;
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
 INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
 FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
 BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
 TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
 CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
 RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
 PtyGraceTime,CurrentStatus,Title)
 VALUES(@BookingId,@EmpCode,@FirstName,@LastName,@GuestId,@ApartmentType,
 @Tariff,@ApartmentId,@SSPId,@BookingPropertyId,@BookingPropertyTableId,
 @ServicePaymentMode,@TariffPaymentMode,@ChkInDt,@ChkOutDt,@ExptTime,
 @AMPM,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
 @RackTariff,@PtyChkInTime,@PtyChkInAMPM,@PtyChkOutTime,@PtyChkOutAMPM,
 @PtyGraceTime,'Booked',@Title);
 SELECT Id,RowId FROM WRBHBApartmentBookingPropertyAssingedGuest 
 WHERE Id=@@IDENTITY;
END