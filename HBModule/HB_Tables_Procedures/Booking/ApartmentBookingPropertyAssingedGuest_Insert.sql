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
@SSPId BIGINT,
@Column1 NVARCHAR(100),
@Column2 NVARCHAR(100),
@Column3 NVARCHAR(100),
@Column4 NVARCHAR(100),
@Column5 NVARCHAR(100),
@Column6 NVARCHAR(100),
@Column7 NVARCHAR(100),
@Column8 NVARCHAR(100),
@Column9 NVARCHAR(100),
@Column10 NVARCHAR(100),
@RoomCaptured INT,
@BTCFilePath NVARCHAR(500))
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
 PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
 Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
 BTCFilePath)
 VALUES(@BookingId,@EmpCode,@FirstName,@LastName,@GuestId,@ApartmentType,
 @Tariff,@ApartmentId,@SSPId,@BookingPropertyId,@BookingPropertyTableId,
 @ServicePaymentMode,@TariffPaymentMode,@ChkInDt,@ChkOutDt,@ExptTime,
 @AMPM,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
 @RackTariff,@PtyChkInTime,@PtyChkInAMPM,@PtyChkOutTime,@PtyChkOutAMPM,
 @PtyGraceTime,'Booked',@Title,@Column1,@Column2,@Column3,@Column4,@Column5,
 @Column6,@Column7,@Column8,@Column9,@Column10,@RoomCaptured,0,@BTCFilePath);
 SELECT Id,RowId FROM WRBHBApartmentBookingPropertyAssingedGuest 
 WHERE Id=@@IDENTITY;
 --
 DECLARE @CltId BIGINT = (SELECT ClientId FROM WRBHBBooking 
 WHERE Id = @BookingId);
 DECLARE @UpdateChkColumn1 BIT = 0,@UpdateChkColumn2 BIT = 0;
 DECLARE @UpdateChkColumn3 BIT = 0,@UpdateChkColumn4 BIT = 0;
 DECLARE @UpdateChkColumn5 BIT = 0,@UpdateChkColumn6 BIT = 0;
 DECLARE @UpdateChkColumn7 BIT = 0,@UpdateChkColumn8 BIT = 0;
 DECLARE @UpdateChkColumn9 BIT = 0,@UpdateChkColumn10 BIT = 0;
 IF EXISTS(SELECT NULL FROM WRBHBClientColumns WHERE ClientId = @CltId AND
 IsActive = 1 AND IsDeleted = 0)
  BEGIN
   SELECT @UpdateChkColumn1 = ISNULL(UpdateChkColumn1,0),
   @UpdateChkColumn2 = ISNULL(UpdateChkColumn2,0),
   @UpdateChkColumn3 = ISNULL(UpdateChkColumn3,0),
   @UpdateChkColumn4 = ISNULL(UpdateChkColumn4,0),
   @UpdateChkColumn5 = ISNULL(UpdateChkColumn5,0),
   @UpdateChkColumn6 = ISNULL(UpdateChkColumn6,0),
   @UpdateChkColumn7 = ISNULL(UpdateChkColumn7,0),
   @UpdateChkColumn8 = ISNULL(UpdateChkColumn8,0),
   @UpdateChkColumn9 = ISNULL(UpdateChkColumn9,0),
   @UpdateChkColumn10 = ISNULL(UpdateChkColumn10,0) FROM WRBHBClientColumns 
   WHERE ClientId = @CltId AND IsActive = 1 AND IsDeleted = 0;
   -- Update Columns
   IF @Column1 != '' AND @UpdateChkColumn1 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column1 = @Column1
     WHERE Id = @GuestId;
    END
   IF @Column2 != '' AND @UpdateChkColumn2 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column2 = @Column2
     WHERE Id = @GuestId;
    END
   IF @Column3 != '' AND @UpdateChkColumn3 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column3 = @Column3
     WHERE Id = @GuestId;
    END
   IF @Column4 != '' AND @UpdateChkColumn4 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column4 = @Column4
     WHERE Id = @GuestId;
    END
   IF @Column5 != '' AND @UpdateChkColumn5 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column5 = @Column5
     WHERE Id = @GuestId;
    END
   IF @Column6 != '' AND @UpdateChkColumn6 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column6 = @Column6
     WHERE Id = @GuestId;
    END
   IF @Column7 != '' AND @UpdateChkColumn7 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column7 = @Column7
     WHERE Id = @GuestId;
    END
   IF @Column8 != '' AND @UpdateChkColumn8 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column8 = @Column8
     WHERE Id = @GuestId;
    END
   IF @Column9 != '' AND @UpdateChkColumn9 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column9 = @Column9
     WHERE Id = @GuestId;
    END
   IF @Column10 != '' AND @UpdateChkColumn10 = 1
    BEGIN
     UPDATE WRBHBClientManagementAddClientGuest SET Column10 = @Column10
     WHERE Id = @GuestId;
    END
  END
END