SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingProperty_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingProperty_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: <Created Date (21/04/2014)  >
Section  	: Booking Property  Insert 
Purpose  	: Booking Property Details  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	
Sakthi          29 DEC 2014      LT,ST & Taxinclusive ADDED
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_BookingProperty_Insert](
@BookingId BIGINT,
@PropertyName NVARCHAR(100),
@PropertyId BIGINT,
@GetType NVARCHAR(100),
@PropertyType NVARCHAR(100),
@RoomType NVARCHAR(100),
@SingleTariff DECIMAL(27,2),
@DoubleTariff DECIMAL(27,2),
@TripleTariff DECIMAL(27,2),
@SingleandMarkup DECIMAL(27,2),
@DoubleandMarkup DECIMAL(27,2),
@TripleandMarkup DECIMAL(27,2),
@Markup DECIMAL(27,2),
@SingleandMarkup1 DECIMAL(27,2),
@DoubleandMarkup1 DECIMAL(27,2),
@TripleandMarkup1 DECIMAL(27,2),
@TAC BIT,
@Inclusions NVARCHAR(1000),
@DiscountModeRS BIT,
@DiscountModePer BIT,
@DiscountAllowed DECIMAL(27,2),
@Phone NVARCHAR(1000),
@Email NVARCHAR(1000),
@Locality NVARCHAR(100),
@LocalityId BIGINT,
@UsrId BIGINT,
@MarkupId BIGINT,
---
@APIHdrId BIGINT,
@RatePlanCode NVARCHAR(100),
@RoomTypeCode NVARCHAR(100),
@PropertyCnt INT,
@TaxAdded NVARCHAR(100),
@LTAgreed DECIMAL(27,2),
@LTRack DECIMAL(27,2),
@STAgreed DECIMAL(27,2),
@TaxInclusive BIT,
@BaseTariff DECIMAL(27,2),
@GeneralMarkup DECIMAL(27,2),
@SC DECIMAL(27,2)) 
AS
BEGIN
 --
 DECLARE @SingleRoomRate DECIMAL(27,2)=0,@SingleTaxes DECIMAL(27,2)=0;
 DECLARE @SingleRoomDiscount DECIMAL(27,2)=0,@DubRoomRate DECIMAL(27,2)=0;
 DECLARE @DubTaxes DECIMAL(27,2)=0,@DubRoomDiscount DECIMAL(27,2)=0;
 --
 IF @APIHdrId != 0 AND @RatePlanCode != '' AND @RoomTypeCode != ''
  BEGIN
   SELECT @SingleRoomRate=T11.Tariffamount,
   @SingleTaxes=ISNULL(T12.Tariffamount,0),
   @SingleRoomDiscount=ISNULL(T13.Tariffamount,0),
   @DubRoomRate=T21.Tariffamount,@DubTaxes=ISNULL(T22.Tariffamount,0),
   @DubRoomDiscount=ISNULL(T23.Tariffamount,0) FROM WRBHBAPIHotelHeader H
   LEFT OUTER JOIN WRBHBAPIRoomRateDtls RR WITH(NOLOCK)ON
   RR.HotelId=H.HotelId AND RR.RoomRateavailStatus='B' AND
   RR.HeaderId=H.HeaderId
   LEFT OUTER JOIN WRBHBAPITariffDtls T11
   WITH(NOLOCK)ON T11.RoomRateHdrId=RR.Id AND T11.RoomTariffroomNumber=1 AND
   T11.Tariffgroup='RoomRate' AND T11.HeaderId=H.HeaderId AND
   T11.HotelId=H.HotelId
   LEFT OUTER JOIN WRBHBAPITariffDtls T12
   WITH(NOLOCK)ON T12.RoomRateHdrId=RR.Id AND T12.RoomTariffroomNumber=1 AND
   T12.Tariffgroup='Taxes' AND T12.HeaderId=H.HeaderId AND
   T12.HotelId=H.HotelId
   LEFT OUTER JOIN WRBHBAPITariffDtls T13
   WITH(NOLOCK)ON T13.RoomRateHdrId=RR.Id AND T13.RoomTariffroomNumber=1 AND
   T13.Tariffgroup='RoomDiscount' AND T13.HeaderId=H.HeaderId AND
   T13.HotelId=H.HotelId
   LEFT OUTER JOIN WRBHBAPITariffDtls T21
   WITH(NOLOCK)ON T21.RoomRateHdrId=RR.Id AND T21.RoomTariffroomNumber=2 AND
   T21.Tariffgroup='RoomRate' AND T21.HeaderId=H.HeaderId AND
   T21.HotelId=H.HotelId
   LEFT OUTER JOIN WRBHBAPITariffDtls T22
   WITH(NOLOCK)ON T22.RoomRateHdrId=RR.Id AND T22.RoomTariffroomNumber=2 AND
   T22.Tariffgroup='Taxes' AND T22.HeaderId=H.HeaderId AND
   T22.HotelId=H.HotelId
   LEFT OUTER JOIN WRBHBAPITariffDtls T23
   WITH(NOLOCK)ON T23.RoomRateHdrId=RR.Id AND T23.RoomTariffroomNumber=2 AND
   T23.Tariffgroup='RoomDiscount' AND T23.HeaderId=H.HeaderId AND
   T23.HotelId=H.HotelId
   WHERE RR.RoomRateratePlanCode = @RatePlanCode AND
   RR.RoomRateroomTypeCode = @RoomTypeCode AND H.HeaderId=@APIHdrId;
  END
 ELSE
  BEGIN
   SET @SingleRoomRate=0;SET @SingleTaxes=0;SET @SingleRoomDiscount=0;
   SET @DubRoomRate=0;SET @DubTaxes=0;SET @DubRoomDiscount=0;
   SET @APIHdrId=0;
  END
 DECLARE @TACPer DECIMAL(27,2) = 0;
 IF @TAC = 1 AND @GetType = 'Property' AND @PropertyType = 'ExP'
  BEGIN
   SELECT TOP 1 @TACPer = ISNULL(TACPer,0) FROM WRBHBPropertyAgreements
   WHERE IsActive = 1 AND IsDeleted = 0 AND PropertyId = @PropertyId
   ORDER BY Id DESC;
  END
 ELSE
  BEGIN
   SET @TACPer = 0;
  END
 INSERT INTO WRBHBBookingProperty(BookingId,PropertyName,PropertyId,
 GetType,PropertyType,RoomType,SingleTariff,DoubleTariff,TripleTariff,
 SingleandMarkup,DoubleandMarkup,TripleandMarkup,Markup,TAC,Inclusions,
 DiscountModeRS,DiscountModePer,DiscountAllowed,Phone,Email,Locality,
 LocalityId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,
 IsDeleted,RowId,MarkupId,SingleandMarkup1,DoubleandMarkup1,TripleandMarkup1,
 APIHdrId,RatePlanCode,RoomTypeCode,SingleRoomRate,SingleTaxes,
 SingleRoomDiscount,DubRoomRate,DubTaxes,DubRoomDiscount,TACPer,TaxAdded,
 LTAgreed,LTRack,STAgreed,TaxInclusive,BaseTariff,GeneralMarkup,
 ExpWithTax,SC)
 VALUES(@BookingId,@PropertyName,@PropertyId,@GetType,@PropertyType,
 @RoomType,@SingleTariff,@DoubleTariff,@TripleTariff,@SingleandMarkup,
 @DoubleandMarkup,@TripleandMarkup,@Markup,@TAC,@Inclusions,
 @DiscountModeRS,@DiscountModePer,@DiscountAllowed,@Phone,@Email,@Locality,
 @LocalityId,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),@MarkupId,
 @SingleandMarkup1,@DoubleandMarkup1,@TripleandMarkup1,@APIHdrId,
 @RatePlanCode,@RoomTypeCode,@SingleRoomRate,@SingleTaxes,@SingleRoomDiscount,
 @DubRoomRate,@DubTaxes,@DubRoomDiscount,@TACPer,@TaxAdded,
 @LTAgreed,@LTRack,@STAgreed,@TaxInclusive,@BaseTariff,@GeneralMarkup,1,@SC);
 SELECT Id,RowId FROM WRBHBBookingProperty WHERE Id=@@IDENTITY;
END
GO
 --- API
/*DECLARE @Type NVARCHAR(100),@ChkInDt NVARCHAR(100),@ChkOutDt NVARCHAR(100);
 SELECT @Type=Status,
 @ChkInDt=CAST(CheckInDate AS VARCHAR)+' '+ExpectedChkInTime+' '+AMPM,
 @ChkOutDt=CAST(CheckOutDate AS VARCHAR)+' 11:59:00 AM'
 FROM WRBHBBooking 
 WHERE Id=@BookingId;
 IF @PropertyCnt = 1 AND @Type != 'RmdPty'
  BEGIN
   IF @PropertyType = 'MMT' AND @GetType = 'API'
    BEGIN
     SELECT C.CityCode,BP.PropertyId,BP.RatePlanCode,BP.RoomTypeCode,
     CAST(B.CheckInDate AS VARCHAR),CAST(B.CheckOutDate AS VARCHAR)
     FROM WRBHBBooking B
     LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
     LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=B.CityId
     WHERE B.Id=@BookingId AND BP.Id=@InsId;
    END   
   ELSE
    BEGIN
     -- Client Id
     DECLARE @ClientId BIGINT=0;
     SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId);
     -- GradeId
     DECLARE @GradeId BIGINT=0;
     SET @GradeId=(SELECT GradeId FROM WRBHBBooking WHERE Id=@BookingId);
     -- Payment Mode
     CREATE TABLE #PAYMENT(label NVARCHAR(100));
     DECLARE @BTC BIT=0;
     SET @BTC=(SELECT BTC FROM WRBHBClientManagement WHERE Id=@ClientId);
     IF @BTC = 1
      BEGIN
       INSERT INTO #PAYMENT(label) SELECT 'Bill to Company (BTC)';
       INSERT INTO #PAYMENT(label) SELECT 'Direct';
      END
     ELSE
      BEGIN
       INSERT INTO #PAYMENT(label) SELECT 'Direct';
      END
     IF @PropertyType = 'CPP'
      BEGIN
       INSERT INTO #PAYMENT(label) SELECT 'Bill to Client';
      END
     SELECT label FROM #PAYMENT;
     -- SSP START
     DECLARE @sspcnt INT=0;
     CREATE TABLE #SSP(label NVARCHAR(100),Id BIGINT,
     SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
     TripleTariff DECIMAL(27,2));
     SET @sspcnt=(SELECT COUNT(*) FROM WRBHBSSPCodeGeneration S
     WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Room' AND 
     S.ClientId=@ClientId AND S.PropertyId=@PropertyId);  
     IF @sspcnt != 0
      BEGIN
       INSERT INTO #SSP(label,Id,SingleTariff,DoubleTariff,TripleTariff)
       SELECT 'Please Select SSP',0,0,0,0;
       INSERT INTO #SSP(label,Id,SingleTariff,DoubleTariff,TripleTariff)
       SELECT S.SSPName AS label,S.Id,S.SingleTariff,S.DoubleTariff,
       S.TripleTariff FROM WRBHBSSPCodeGeneration S
       WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Room' AND 
       S.ClientId=@ClientId AND S.PropertyId=@PropertyId;
      END
     SELECT label,Id,SingleTariff,DoubleTariff,TripleTariff FROM #SSP;
     -- SSP END
     --SELECT @GetType,@PropertyType;RETURN;
     --
     IF @PropertyType = 'MGH'
      BEGIN
       CREATE TABLE #ExistingManagedGHProperty1(RoomId BIGINT);
       -- Booked Room Begin
       INSERT INTO #ExistingManagedGHProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       --
       INSERT INTO #ExistingManagedGHProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #ExistingManagedGHProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #ExistingManagedGHProperty1(RoomId)
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY PG.RoomId;
       -- Booked Room End
       -- Avaliable Rooms
       SELECT B.BlockName+' - '+R.RoomNo AS label,R.Id AS RoomId,
       BP.SingleandMarkup,BP.DoubleandMarkup,BP.TripleandMarkup  
       FROM WRBHBProperty P
       LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON
       B.PropertyId=P.Id
	   LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
	   R.BlockId=B.Id AND R.PropertyId=P.Id
	   LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
	   BP.PropertyId=P.Id 
	   WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND 
	   B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND 
	   P.Id=@PropertyId AND P.Category='Managed G H' AND 
	   BP.Id=@InsId AND
	   R.Id NOT IN (SELECT RoomId FROM #ExistingManagedGHProperty1);
	  END
     IF @PropertyType = 'DdP'
      BEGIN 
       CREATE TABLE #ExDdPApartmnt1(ApartmentId BIGINT);
       CREATE TABLE #ExistingDedicatedProperty1(RoomId BIGINT);
       -- Booked Room Begin
       INSERT INTO #ExistingDedicatedProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #ExistingDedicatedProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #ExistingDedicatedProperty1(RoomId) 
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #ExistingDedicatedProperty1(RoomId)
       SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY PG.RoomId;
       -- Booked Room End
       -- Booked Apartment Begin
       INSERT INTO #ExDdPApartmnt1(ApartmentId) 
       SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
       --
       INSERT INTO #ExDdPApartmnt1(ApartmentId) 
       SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
       --
       INSERT INTO #ExDdPApartmnt1(ApartmentId) 
       SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
       -- 
       INSERT INTO #ExDdPApartmnt1(ApartmentId) 
       SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY PG.ApartmentId;
       -- Booked Apartment End
       -- Avaliable Rooms
       CREATE TABLE #DdP(label NVARCHAR(100),RoomId BIGINT,
       SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
       TripleandMarkup DECIMAL(27,2));
       INSERT INTO #DdP(label,RoomId,SingleandMarkup,DoubleandMarkup,
       TripleandMarkup)
       SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
       R.Id AS RoomId,BP.SingleandMarkup,BP.DoubleandMarkup,
       BP.TripleandMarkup FROM WRBHBContractManagementTariffAppartment D
       LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
       R.PropertyId=D.PropertyId AND R.Id=D.RoomId    
       LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
       A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId
       LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
       B.PropertyId=D.PropertyId AND B.Id=A.BlockId
       LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
       BP.PropertyId=D.PropertyId
       WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND 
       R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND 
       A.IsActive=1 AND A.IsDeleted=0 AND 
       A.SellableApartmentType != 'HUB' AND
       A.Status='Active' AND R.RoomStatus='Active' AND
       BP.Id=@InsId AND D.PropertyId=@PropertyId AND
       R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND
       A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1) 
       ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
       --
       INSERT INTO #DdP(label,RoomId,SingleandMarkup,DoubleandMarkup,
       TripleandMarkup)
       SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
       R.Id AS RoomId,BP.SingleandMarkup,BP.DoubleandMarkup,
       BP.TripleandMarkup FROM WRBHBContractManagementAppartment D
       LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
       R.PropertyId=D.PropertyId
       LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
       A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId AND
       A.Id=D.ApartmentId
       LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
       B.PropertyId=D.PropertyId AND B.Id=A.BlockId
       LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
       BP.PropertyId=D.PropertyId
       WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND 
       R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND 
       A.IsActive=1 AND A.IsDeleted=0 AND 
       A.SellableApartmentType != 'HUB' AND
       A.Status='Active' AND R.RoomStatus='Active' AND
       BP.Id=@InsId AND D.PropertyId=@PropertyId AND
       R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND
       A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1) 
       ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
       --
       SELECT label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup 
       FROM #DdP 
       GROUP BY label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup
       ORDER BY label,RoomId;
      END  
     IF @PropertyType = 'InP'
      BEGIN
       -- Get Property All Rooms 
       CREATE TABLE #Tmp_InternalRoom(label NVARCHAR(100),RoomId BIGINT,
       SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
       TripleandMarkup DECIMAL(27,2));
       INSERT INTO #Tmp_InternalRoom(label,RoomId,SingleandMarkup,
       DoubleandMarkup,TripleandMarkup)
       SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
       R.RoomType AS label,R.Id AS RoomId,
       BP.SingleandMarkup+BP.Markup,BP.DoubleandMarkup+BP.Markup,
       CASE WHEN BP.TripleandMarkup > 0 THEN BP.TripleandMarkup+BP.Markup
       ELSE BP.TripleandMarkup END AS TripleandMarkup 
       FROM WRBHBProperty P
       LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
       LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
       A.PropertyId=P.Id AND A.BlockId=B.Id
       LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
       R.PropertyId=P.Id AND R.ApartmentId=A.Id
       LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
       BP.PropertyId=P.Id
       WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND 
       R.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
       B.IsActive=1 AND B.IsDeleted=0 AND 
       A.SellableApartmentType != 'HUB' AND
       A.Status='Active' AND R.RoomStatus='Active' AND
       P.Id=@PropertyId AND BP.Id=@InsId;
       -- Property Booked Rooms Begin
       CREATE TABLE #BookedRoomsInP(RoomId BIGINT,Sts NVARCHAR(100));
       -- Dedicated Rooms
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT RoomId,'Dedicated Room' 
       FROM WRBHBContractManagementTariffAppartment
       WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND
       PropertyId=@PropertyId;
       -- Dedicated Apartment
       INSERT INTO #BookedRoomsInP(RoomId,Sts)  
       SELECT R.Id,'Dedicated Apartment' FROM WRBHBPropertyRooms R
       LEFT OUTER JOIN WRBHBContractManagementAppartment T 
       WITH(NOLOCK)ON T.ApartmentId=R.ApartmentId
       WHERE R.IsActive=1 AND R.IsDeleted=0 AND T.IsActive=1 AND 
       T.IsDeleted=0 AND T.ApartmentId != 0 AND 
       R.ApartmentId=T.ApartmentId AND T.PropertyId=@PropertyId;
       -- Booked Rooms Begin
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       --
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY PG.RoomId;
       -- Booked Rooms End
       -- Booked Beds Begin
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Bed Booking' 
       FROM WRBHBBedBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       --
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Bed Booking'
       FROM WRBHBBedBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Bed Booking'
       FROM WRBHBBedBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
       -- 
       INSERT INTO #BookedRoomsInP(RoomId,Sts) 
       SELECT PG.RoomId,'Bed Booking'
       FROM WRBHBBedBookingPropertyAssingedGuest PG
       WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY PG.RoomId;
       -- Booked Beds End
       -- Booked Apartment Begin
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
       LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
       WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
       PG.ApartmentId=R.ApartmentId
       WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
       PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
       --
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
       LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
       WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
       PG.ApartmentId=R.ApartmentId
       WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
       PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
       --
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
       LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
       WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
       PG.ApartmentId=R.ApartmentId
       WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
       PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
       CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
       PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
       -- 
       INSERT INTO #BookedRoomsInP(RoomId,Sts)
       SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
       LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
       WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
       PG.ApartmentId=R.ApartmentId
       WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
       PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
       CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
       CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
       CAST(@ChkInDt AS DATETIME) AND
       CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
       CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
       GROUP BY R.Id;
       -- Booked Apartment End
       -- Property Booked Rooms End
       -- Avaliable Rooms
       --select * from #Tmp_InternalRoom;
       --select * from #BookedRoomsInP;RETURN;
       SELECT label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup 
       FROM #Tmp_InternalRoom
       WHERE RoomId NOT IN (SELECT RoomId FROM #BookedRoomsInP);
      END
     IF @PropertyType = 'CPP'
      BEGIN
       SELECT BP.RoomType AS label,0 AS RoomId,BP.SingleandMarkup,
       BP.DoubleandMarkup,BP.TripleandMarkup FROM WRBHBBookingProperty BP
       WHERE BP.IsActive=1 AND IsDeleted=0 AND BP.PropertyId=@PropertyId 
       AND BP.Id=@InsId;
      END
     IF @PropertyType = 'ExP'
      BEGIN
       SELECT BP.RoomType AS label,0 AS RoomId,
       BP.SingleandMarkup+BP.Markup AS SingleandMarkup,
       BP.DoubleandMarkup+BP.Markup AS DoubleandMarkup,
       CASE WHEN BP.TripleandMarkup > 0 THEN BP.TripleandMarkup+BP.Markup
       ELSE BP.TripleandMarkup END AS TripleandMarkup 
       FROM WRBHBBookingProperty BP
       WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND BP.PropertyId=@PropertyId
       AND BP.Id=@InsId;
      END
     -- Tab 3 Guest Details
     SELECT GuestId,EmpCode,FirstName,LastName,Id AS BookingGuestTableId,
     0 AS Tick,1 AS Chk,FirstName+'  '+LastName AS Name 
     FROM WRBHBBookingGuestDetails 
     WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@BookingId;
    END   
  END
 ELSE
  BEGIN
   SELECT Id,RowId FROM WRBHBBookingProperty WHERE Id=@@IDENTITY;
  END
END
GO*/
