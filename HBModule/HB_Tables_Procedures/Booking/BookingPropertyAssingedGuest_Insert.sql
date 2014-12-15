SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingPropertyAssingedGuest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: (25/04/2014)  >
Section  	: Room Level Booking Property Assinged Guest
Purpose  	: Room Level Booking Property Assinged Guest
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi          12 Jun 2014     Property ChkIn Type & Time,ChkOut Type & Time,Grace Time,Rack Tariff Added
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Insert](
@BookingId BIGINT,
@EmpCode NVARCHAR(100),
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@GuestId BIGINT,
@Occupancy NVARCHAR(100),
@RoomType NVARCHAR(100),
@ServicePaymentMode NVARCHAR(100),
@TariffPaymentMode NVARCHAR(100),
@Tariff DECIMAL(27,2),
@RoomId BIGINT,
@BookingPropertyId BIGINT,
@BookingPropertyTableId BIGINT,
@UsrId BIGINT,
@SSPId BIGINT,
@RoomCaptured INT,
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
@BTCFilePath NVARCHAR(500))
AS
BEGIN
 IF @SSPId != 0
  BEGIN
   UPDATE WRBHBSSPCodeGeneration SET IsActive=0,IsDeleted=0,
   ModifiedBy=@UsrId,ModifiedDate=GETDATE() WHERE Id=@SSPId;
  END 
 DECLARE @APIHdrId BIGINT=0;
 -- PropertyType & GetType
 DECLARE @PropertyType NVARCHAR(100),@GetType NVARCHAR(100);
 SELECT TOP 1 @PropertyType=PropertyType,@GetType=GetType,@APIHdrId=ISNULL(APIHdrId,0) 
 FROM WRBHBBookingProperty WHERE Id=@BookingPropertyTableId;
 /*IF @APIHdrId != 0
  BEGIN
   DELETE FROM WRBHBAPIHeader WHERE Id=@APIHdrId;
   DELETE FROM WRBHBAPIHotelHeader WHERE HeaderId=@APIHdrId;
   DELETE FROM WRBHBAPIRateMealPlanInclusionDtls WHERE HeaderId=@APIHdrId;
   DELETE FROM WRBHBAPIRoomRateDtls WHERE HeaderId=@APIHdrId;
   DELETE FROM WRBHBAPIRoomTypeDtls WHERE HeaderId=@APIHdrId;
   DELETE FROM WRBHBAPITariffDtls WHERE HeaderId=@APIHdrId;
  END*/
 -- CheckIn Date & CheckOut Date Data Get From Booking Table
 DECLARE @ChkInDt DATE,@ChkOutDt DATE,@ExpectChkInTime NVARCHAR(100);
 DECLARE @AMPM NVARCHAR(100);
 SELECT TOP 1 @ChkInDt=CheckInDate,@ChkOutDt=CheckOutDate,
 @ExpectChkInTime=ExpectedChkInTime,@AMPM=AMPM FROM WRBHBBooking 
 WHERE Id=@BookingId;
 -- CheckOut Type & Rack Tariff  
 DECLARE @PtyChkInTime INT,@PtyChkInAMPM NVARCHAR(100);
 DECLARE @PtyChkOutTime INT,@PtyChkOutAMPM NVARCHAR(100);
 DECLARE @PtyGraceTime INT;
 --
 SELECT TOP 1 @PtyChkInTime=ISNULL(CheckIn,0),@PtyChkInAMPM=ISNULL(CheckInType,''),
 @PtyChkOutTime=ISNULL(CheckOut,0),@PtyChkOutAMPM=ISNULL(CheckOutType,''),
 @PtyGraceTime=ISNULL(GraceTime,0)
 FROM WRBHBProperty WHERE Id=@BookingPropertyId;
 -- Rack Tariff
 DECLARE @ApartmentId BIGINT=0, @RackSingle DECIMAL(27,2)=0;
 DECLARE @RackDouble DECIMAL(27,2)=0,@RackTriple DECIMAL(27,2)=0;
 DECLARE @LTRack DECIMAL(27,2)=0,@STRack DECIMAL(27,2)=0;
 DECLARE @LTAgreed DECIMAL(27,2)=0,@STAgreed DECIMAL(27,2)=0;
 --
 IF @RoomId != 0 AND @PropertyType = 'InP'
  BEGIN
   SELECT TOP 1 @RackSingle=ISNULL(RackTariff,0),
   @RackDouble=ISNULL(DoubleOccupancyTariff,0),
   @RackTriple=0,@ApartmentId=ApartmentId
   FROM WRBHBPropertyRooms WHERE Id=@RoomId;
  END
 IF @PropertyType = 'ExP' AND @GetType = 'Property'
  BEGIN
   SELECT TOP 1 @RackSingle=ISNULL(R.Single,0),@RackDouble=ISNULL(R.RDouble,0),
   @RackTriple=ISNULL(R.Triple,0),@LTAgreed=ISNULL(R.LTAgreed,0),
   @LTRack=ISNULL(R.LTRack,0),@STAgreed=ISNULL(R.STAgreed,0),
   @STRack=ISNULL(R.STRack,0)
   FROM WRBHBPropertyAgreements A
   LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R
   WITH(NOLOCK)ON R.AgreementId=A.Id
   WHERE A.PropertyId=@BookingPropertyId AND R.RoomType=@RoomType;   
  END
 --
 IF EXISTS (SELECT NULL FROM WRBHBBooking 
 WHERE Id=@BookingId AND PONo='')
  BEGIN
   DECLARE @PONo NVARCHAR(100)='',@PONoId BIGINT=0;
   IF EXISTS (SELECT NULL FROM WRBHBBookingProperty 
   WHERE Id=@BookingPropertyTableId AND PropertyId=@BookingPropertyId AND
   BookingId=@BookingId AND PropertyType='ExP')
    BEGIN
     IF EXISTS (SELECT NULL FROM WRBHBBooking WHERE PONoId !=0)
      BEGIN
       SET @PONoId=(SELECT TOP 1 PONoId+1 FROM WRBHBBooking WHERE PONoId !=0
       ORDER BY PONoId DESC);
      END
     ELSE
      BEGIN
       SET @PONoId=1;
      END
     IF EXISTS (SELECT NULL FROM WRBHBBooking 
     WHERE MONTH(CreatedDate)=MONTH(GETDATE()) AND
     YEAR(CreatedDate)=YEAR(GETDATE()) AND PONo!='')
      BEGIN
       SELECT TOP 1 @PONo=SUBSTRING(PONo,0,13)+'0'+
       CAST(CAST(SUBSTRING(PONo,13,LEN(PONo)) AS INT)+1 AS VARCHAR)
       FROM WRBHBBooking
       WHERE MONTH(CreatedDate)=MONTH(GETDATE()) AND
       YEAR(CreatedDate)=YEAR(GETDATE()) AND PONo!='' 
       ORDER BY PONoId DESC;
      END
     ELSE
      BEGIN
       SELECT @PONo='HBE/'+CAST(YEAR(GETDATE()) AS VARCHAR)+'-'+
       CAST(SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),4,2) AS VARCHAR)+'/01';
      END
     UPDATE WRBHBBooking SET PONo=@PONo,PONoId=@PONoId
     WHERE Id=@BookingId;
    END   
  END
 -- TITLE
 DECLARE @Title NVARCHAR(100)='';
 SET @Title=(SELECT TOP 1 ISNULL(Title,'') FROM WRBHBBookingGuestDetails 
 WHERE GuestId=@GuestId AND BookingId=@BookingId);
 --
 IF @PropertyType != 'MMT'
  BEGIN
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
  END
 -- Insert
 INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
 FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
 BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
 ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
 ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
 AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
 PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
 LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,RoomShiftingFlag,
 Title,Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,
 Column9,Column10,BTCFilePath/*,ChkColumn1,ChkColumn2,ChkColumn3,ChkColumn4,ChkColumn5,
 ChkColumn6,ChkColumn7,ChkColumn8,ChkColumn9,ChkColumn10*/)
 VALUES(@BookingId,@EmpCode,@FirstName,@LastName,@GuestId,@Occupancy,
 @RoomType,@Tariff,@RoomId,@BookingPropertyId,@BookingPropertyTableId,
 @UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),@SSPId,
 @ServicePaymentMode,@TariffPaymentMode,@ChkInDt,@ChkOutDt,
 @ExpectChkInTime,@AMPM,@RoomCaptured,@ApartmentId,@RackSingle,@RackDouble,
 @RackTriple,@PtyChkInTime,@PtyChkInAMPM,@PtyChkOutTime,@PtyChkOutAMPM,
 @PtyGraceTime,@LTAgreed,@LTRack,@STAgreed,@STRack,'Booked',0,@Title,
 @Column1,@Column2,@Column3,@Column4,@Column5,@Column6,@Column7,@Column8,
 @Column9,@Column10,@BTCFilePath/*,@ChkColumn1,@ChkColumn2,@ChkColumn3,@ChkColumn4,
 @ChkColumn5,@ChkColumn6,@ChkColumn7,@ChkColumn8,@ChkColumn9,@ChkColumn10*/);
 SELECT Id,RowId FROM WRBHBBookingPropertyAssingedGuest 
 WHERE Id=@@IDENTITY;
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
 /*UPDATE WRBHBClientManagementAddClientGuest SET Column1 = @Column1,
 Column2 = @Column2,Column3 = @Column3,Column4 = @Column4,Column5 = @Column5,
 Column6 = @Column6,Column7 = @Column7,Column8 = @Column8,Column9 = @Column9,
 Column10 = @Column10 WHERE Id = @GuestId;*/
END