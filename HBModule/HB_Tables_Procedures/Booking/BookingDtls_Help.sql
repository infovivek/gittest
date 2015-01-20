-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingDtls_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingDtls_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:28-03-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	BOOKING GRID HELP LOAD
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BookingDtls_Help](@Action NVARCHAR(100),
@Str NVARCHAR(100),@Id BIGINT)			
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
DECLARE @PName NVARCHAR(100),@MobileNo NVARCHAR(100);
DECLARE @SecurityPolicy NVARCHAR(1000),@CancelationPolicy NVARCHAR(1000);
DECLARE @BookingPropertyId BIGINT,@ClientId1 BIGINT;
DECLARE @PropertyEmail NVARCHAR(100)='';
DECLARE @CLogo NVARCHAR(1000)='',@CLogoAlt NVARCHAR(100)='';
DECLARE @Cnt INT=0;
SET @CLogo=(SELECT TOP 1 Logo FROM WRBHBCompanyMaster 
WHERE IsActive=1 AND IsDeleted=0);
SET @CLogoAlt='Staysimplyfied';
-- PART OF CLIENT NAME
DECLARE @ClientName NVARCHAR(100),@ClientName1 NVARCHAR(100);
SELECT @ClientName = dbo.TRIM(ClientName) FROM WRBHBClientManagement
WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @Id);
CREATE TABLE #QAZXSW(Id INT,Name NVARCHAR(100));
INSERT INTO #QAZXSW(Id,Name)
SELECT * FROM dbo.Split(@ClientName,' ');
SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
-- CLIENT LOGO IN M G H
declare @cltlogoMGH nvarchar(100),@cltaltMGH nvarchar(100);
SELECT @cltlogoMGH = ISNULL(ClientLogo,''),@cltaltMGH = ISNULL(ClientName,'') 
FROM WRBHBClientManagement 
WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @Id);
--
DECLARE @Taxes NVARCHAR(100),@TypeofPtyy NVARCHAR(100),@TXADED NVARCHAR(100);
SELECT TOP 1 @TXADED = ISNULL(TaxAdded,'T'),@TypeofPtyy = PropertyType
FROM WRBHBBookingProperty WHERE Id IN (
SELECT TOP 1 BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest
WHERE BookingId = @Id);
--
DECLARE @Stay NVARCHAR(100),@Uniglobe NVARCHAR(100);
SET @Stay = 'stay@hummingbirdindia.com';
SET @Uniglobe = 'homestay@uniglobeatb.co.in';
--
/*SET @CLogoAlt=(SELECT TOP 1 LegalCompanyName FROM WRBHBCompanyMaster 
WHERE IsActive=1 AND IsDeleted=0);*/
IF @Action = 'TitleLoad'
 BEGIN
  CREATE TABLE #TITLE(Title NVARCHAR(100));
  INSERT INTO #TITLE(Title) SELECT 'Mr';
  INSERT INTO #TITLE(Title) SELECT 'Ms';
  INSERT INTO #TITLE(Title) SELECT 'Mrs';
  INSERT INTO #TITLE(Title) SELECT 'Dr';
  SELECT Title FROM #TITLE;
 END
IF @Action = 'HotelAvailability'
 BEGIN
  SELECT C.CityCode,BP.PropertyId,BP.RatePlanCode,BP.RoomTypeCode,
  CAST(B.CheckInDate AS VARCHAR),CAST(B.CheckOutDate AS VARCHAR)
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=B.CityId
  WHERE B.Id=@Id;
 END
IF @Action = 'ClientGuestLoad'
 BEGIN
  SELECT ISNULL(EmpCode,'') AS EmpCode,ISNULL(FirstName,'') AS FirstName,
  ISNULL(LastName,'') AS LastName,ISNULL(Grade,'') AS Grade,
  ISNULL(Designation,'') AS Designation,ISNULL(EmailId,'') AS Email,
  ISNULL(GMobileNo,'') AS MobileNo,Id,ISNULL(GradeId,0) AS GradeId,
  ISNULL(Nationality,'') AS NationalityId,ISNULL(Title,'') AS TitleId
  FROM WRBHBClientManagementAddClientGuest 
  WHERE IsDeleted = 0 AND IsActive = 1 AND CltmgntId = @Id
  ORDER BY FirstName ASC;
 END
 IF @Action = 'RecommendProperty'
 BEGIN
  -- dataset table 0
  CREATE TABLE #ASDS(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
  Locality NVARCHAR(100),RoomType NVARCHAR(100),SingleandMarkup1 NVARCHAR(100),
  Inclusions NVARCHAR(100),Id BIGINT,DoubleandMarkup1 NVARCHAR(100),
  CheckInType NVARCHAR(100),Typee NVARCHAR(100),BaseTariff DECIMAL(27,2));
  INSERT INTO #ASDS(CityName,PropertyName,Locality,RoomType,SingleandMarkup1,
  Inclusions,Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff)
  SELECT C.CityName,BP.PropertyName,BP.Locality,BP.RoomType,
  CASE WHEN BP.TaxAdded = 'N' THEN CAST(BP.SingleandMarkup1 AS VARCHAR) +' <SUP>#</SUP>'
       WHEN BP.TaxAdded = 'T' THEN CAST(BP.SingleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>'
       WHEN BP.TaxAdded = '' THEN CAST(BP.SingleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>'
       ELSE CAST(BP.SingleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>' END,
  BP.Inclusions,BP.Id,
  CASE WHEN BP.TaxAdded = 'N' THEN CAST(BP.DoubleandMarkup1 AS VARCHAR) +' <SUP>#</SUP>'
       WHEN BP.TaxAdded = 'T' THEN CAST(BP.DoubleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>'
       WHEN BP.TaxAdded = '' THEN CAST(BP.DoubleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>'
       ELSE CAST(BP.DoubleandMarkup1 AS VARCHAR) +' <SUP>&#9733;</SUP>' END,
  CAST(P.CheckIn AS VARCHAR)+' '+P.CheckInType,
  BP.PropertyType AS Typee,BP.BaseTariff
  FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = BP.PropertyId
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id = BP.LocalityId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId = C.Id
  WHERE BP.BookingId = @Id AND 
  BP.PropertyType IN ('ExP','CPP','InP','MGH','DdP');
  --
  INSERT INTO #ASDS(CityName,PropertyName,Locality,RoomType,SingleandMarkup1,
  Inclusions,Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff)
  SELECT B.CityName,BP.PropertyName,BP.Locality,BP.RoomType,
  CAST(BP.SingleandMarkup1 AS VARCHAR)+' <SUP>#</SUP>',BP.Inclusions,BP.Id,
  CAST(BP.DoubleandMarkup1 AS VARCHAR)+' <SUP>#</SUP>',SH.CheckInTime,
  'MMT',BP.BaseTariff FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON C.Id = B.CityId
  LEFT OUTER JOIN WRBHBStaticHotels SH WITH(NOLOCK)ON 
  SH.HotalId = BP.PropertyId AND SH.CityCode = C.CityCode  
  WHERE BP.BookingId = @Id AND BP.PropertyType IN ('MMT');
  --
  CREATE TABLE #TTEEMMPP(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
  Locality NVARCHAR(100),RoomType NVARCHAR(100),SingleandMarkup1 NVARCHAR(100),
  Inclusions NVARCHAR(100),Id NVARCHAR(100),DoubleandMarkup1 NVARCHAR(100),
  CheckInType NVARCHAR(100),Typee NVARCHAR(100),BaseTariff DECIMAL(27,2));
  INSERT INTO #TTEEMMPP(CityName,PropertyName,Locality,RoomType,
  SingleandMarkup1,Inclusions,Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff)
  SELECT CityName,PropertyName,Locality,RoomType,SingleandMarkup1,Inclusions,
  Id,DoubleandMarkup1,CheckInType,'Company Prefered',BaseTariff FROM #ASDS
  WHERE Typee = 'CPP';
  INSERT INTO #TTEEMMPP(CityName,PropertyName,Locality,RoomType,
  SingleandMarkup1,Inclusions,Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff)
  SELECT CityName,PropertyName,Locality,RoomType,SingleandMarkup1,Inclusions,
  Id,DoubleandMarkup1,CheckInType,'Guest House',BaseTariff FROM #ASDS
  WHERE Typee = 'MGH';
  INSERT INTO #TTEEMMPP(CityName,PropertyName,Locality,RoomType,
  SingleandMarkup1,Inclusions,Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff)
  SELECT CityName,PropertyName,Locality,RoomType,SingleandMarkup1,Inclusions,
  Id,DoubleandMarkup1,CheckInType,'Others',BaseTariff FROM #ASDS
  WHERE Typee NOT IN ('CPP','MGH');
  SELECT CityName,PropertyName,Locality,RoomType,SingleandMarkup1,Inclusions,
  Id,DoubleandMarkup1,CheckInType,Typee,BaseTariff FROM #TTEEMMPP;
  /*-- dataset table 0
  SELECT C.CityName,BP.PropertyName,BP.Locality,RoomType,
  SingleandMarkup1 AS Tariff,Inclusions,BP.Id,DoubleandMarkup1,
  CAST(CheckIn AS VARCHAR)+' '+CheckInType     FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id=BP.PropertyId
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
  WHERE BP.BookingId=@Id;*/
  -- dataset table 1
  SELECT ISNULL(ClientLogo,'') AS ClientLogo,B.ClientBookerEmail,
  B.TrackingNo,U.FirstName,U.Email,B.Note,C.ClientName FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id = B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON U.Id = B.CreatedBy
  WHERE B.Id = @Id;
  -- dataset table 2
  SELECT CAST(EmailtoGuest AS INT),@Stay,@Uniglobe FROM WRBHBBooking 
  WHERE Id=@Id;
  -- dataset table 3
  SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id;
  -- dataset table 4
  SELECT Status,CONVERT(VARCHAR(19),GETDATE()) FROM WRBHBBooking WHERE Id=@Id;  
  -- Dataset Table 5
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND 
  ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id))
   BEGIN
    SELECT ClientLogo,ClientName,@CLogo,@CLogoAlt FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND
    Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id);    
   END
  ELSE
   BEGIN
    SELECT Logo,@CLogoAlt,@CLogo,@CLogoAlt FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- dataset table 6
  SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);
  -- Dataset Table 7
  DECLARE @asd INT;
  SET @asd=(SELECT CAST(EmailtoGuest AS INT) FROM WRBHBBooking 
  WHERE Id=@Id);
  IF @asd = 0
   BEGIN
    SELECT ISNULL(ClientBookerName,'') FROM WRBHBBooking WHERE Id=@Id;
   END
  ELSE
   BEGIN
    SELECT TOP 1 ISNULL(FirstName,'') FROM WRBHBBookingGuestDetails 
    WHERE BookingId=@Id ORDER BY NEWID();
   END
  -- Dataset Table 8
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id)); 
 END
IF @Action = 'RoomBookingConfirmed'
 BEGIN  
  -- Dataset Table 0
  CREATE TABLE #FFF(BookingId BIGINT,RoomId BIGINT,ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
  RoomCaptured INT,RoomNo NVARCHAR(100));
  INSERT INTO #FFF(BookingId,RoomId,ChkInDt,ChkOutDt,Tariff,Occupancy,
  TariffPaymentMode,ServicePaymentMode,RoomCaptured,RoomNo)
  SELECT BG.BookingId,BG.RoomId,
  REPLACE(CONVERT(VARCHAR(11),BG.ChkInDt, 106), ' ', '-') +' / '+ 
  LEFT(BG.ExpectChkInTime, 5)+' '+BG.AMPM,
  REPLACE(CONVERT(VARCHAR(11), BG.ChkOutDt, 106), ' ', '-'),
  BG.Tariff,BG.Occupancy,
  CASE WHEN BG.TariffPaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.TariffPaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BG.TariffPaymentMode END AS TariffPaymentMode,
  CASE WHEN BG.ServicePaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.ServicePaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BG.ServicePaymentMode END AS ServicePaymentMode,BG.RoomCaptured,
       BG.RoomType 
  FROM WRBHBBookingPropertyAssingedGuest BG
  WHERE BG.IsActive=1 AND BG.IsDeleted=0 AND BG.BookingId=@Id AND
  ISNULL(BG.RoomShiftingFlag,0) = 0 
  GROUP BY BG.BookingId,BG.RoomId,BG.ChkInDt,BG.ExpectChkInTime,BG.AMPM,
  BG.ChkOutDt,BG.Tariff,BG.Occupancy,BG.TariffPaymentMode,
  BG.ServicePaymentMode,BG.RoomCaptured,BG.RoomType;
  CREATE TABLE #QAZ(Name NVARCHAR(100),ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
  RoomNo NVARCHAR(100));
  INSERT INTO #QAZ(Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
  ServicePaymentMode,RoomNo)
  SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
  FROM WRBHBBookingPropertyAssingedGuest BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND
  ISNULL(BA.RoomShiftingFlag,0) = 0
  FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt,
  B.Tariff,B.Occupancy,B.TariffPaymentMode,B.ServicePaymentMode,B.RoomNo
  FROM #FFF AS B;
  --
  SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
  ServicePaymentMode,RoomNo FROM #QAZ;
  --
  /*CREATE TABLE #Table0(Name NVARCHAR(100),ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
  RoomNo NVARCHAR(100));
  INSERT INTO #Table0(Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
  ServicePaymentMode,RoomNo)
  SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,
  CASE WHEN TariffPaymentMode = 'Bill to Company (BTC)' AND 
  @TypeofPtyy NOT IN ('MGH','InP','DdP') 
  THEN 'Bill to Company (BTC)<br>(7.42% Tax Extra)'
  ELSE TariffPaymentMode END,
  CASE WHEN ServicePaymentMode = 'Bill to Company (BTC)' AND 
  @TypeofPtyy NOT IN ('MGH','InP','DdP') 
  THEN 'Bill to Company (BTC)<br>(7.42% Tax Extra)'
  ELSE ServicePaymentMode END,RoomNo FROM #QAZ;
  --
  SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
  ServicePaymentMode,RoomNo FROM #Table0;*/
  --
  IF @TXADED = 'N'
   BEGIN
    SET @Taxes = 'Including Tax';
   END
  IF @TXADED = 'T'
   BEGIN
    SET @Taxes = 'Taxes as applicable';
   END  
  --
  SELECT TOP 1 @BookingPropertyId=BookingPropertyId 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id;
  -- dataset table 1
  SELECT Propertaddress+','+L.Locality+','+
  C.CityName+','+S.StateName+' - '+Postal AS ADDRESS,
  Phone,Directions,BookingPolicy,CancelPolicy,bp.PropertyName,BP.Category,
  ISNULL(BP.CheckOutType,'') CheckOutType,ISNULL(CheckIn,'') CheckIn,
  ISNULL(CheckInType,'') CheckInType,
  ISNULL(CheckOut,'') CheckOut,T.PropertyType
  FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
  LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId
  LEFT OUTER JOIN WRBHBPropertyType T WITH(NOLOCK) ON T.Id=BP.PropertyType
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  -- dataset table 2
  SELECT ISNULL(ClientLogo,'') AS ClientLogo,C.ClientName,
  B.BookingCode,U.FirstName,U.Email,ISNULL(U.PhoneNumber,''),B.ClientBookerName,
  REPLACE(CONVERT(VARCHAR(11), B.CreatedDate, 106), ' ', '-'),
  B.SpecialRequirements,B.ClientBookerEmail,B.ExtraCCEmail
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=B.CreatedBy
  WHERE B.Id=@Id;
  --
  --select 'df';return;
  -- Get CPP & Property Mail
  DECLARE @MailStr NVARCHAR(1000)='';  
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id AND BP.PropertyType IN ('CPP'))
   BEGIN
    -- CPP Mail
    SET @MailStr=(SELECT TOP 1 ISNULL(D.Email,'') 
    FROM WRBHBContractClientPref_Header H
    LEFT OUTER JOIN WRBHBContractClientPref_Details D
    WITH(NOLOCK)ON D.HeaderId=H.Id
    WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND
    D.IsDeleted=0 AND ISNULL(D.Email,'') != '' AND    
    D.RoomType IN (SELECT RoomType
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id) AND     
    H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id=@Id) AND
    D.PropertyId IN (SELECT BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id));
   END
  ELSE
   BEGIN
    -- Property Email
    SET @MailStr=(SELECT ISNULL(Email,'') FROM WRBHBProperty 
    WHERE Id=@BookingPropertyId AND ISNULL(Email,'') != '' AND
    IsActive=1 AND IsDeleted=0);
   END
  --
  -- dataset table 3
  SELECT BP.PropertyName, ISNULL(U.FirstName,'') as UserName,
  ISNULL(U.Email,'')Email,ISNULL(U.MobileNumber,'')PhoneNumber,
  ISNULL(@MailStr,'') --ISNULL(BP.Email,'') AS Email 
  FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id =PU.PropertyId 
  AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
  UserType in('Resident Managers','Assistant Resident Managers')
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  --
  SELECT @PName=(P.PropertyName+', '+L.Locality+', '+C.CityName),
  @SecurityPolicy=P.BookingPolicy,@CancelationPolicy=P.CancelPolicy
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=P.CityId
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId 
  WHERE P.Id = @BookingPropertyId;
  --
  CREATE TABLE #GST(MobileNo NVARCHAR(100));
  INSERT INTO #GST(MobileNo)
  SELECT STUFF((SELECT ', '+ISNULL(BA.MobileNo,'')
  FROM WRBHBBookingGuestDetails BA
  WHERE BA.BookingId=G.BookingId AND BA.GuestId=BA.GuestId AND
  BA.MobileNo != ''
  FOR XML PATH('')),1,1,'') AS MobileNo
  FROM WRBHBBookingPropertyAssingedGuest G
  WHERE G.BookingId=@Id GROUP BY G.BookingId;
  --
  SET @MobileNo = (SELECT TOP 1 ISNULL(MobileNo,'') FROM #GST);
  --
  DECLARE @TACPer DECIMAL(27,2) = 0;
  DECLARE @AgreedTariff NVARCHAR(1000) = '';
  IF EXISTS (SELECT NULL FROM WRBHBBookingProperty P
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK)ON
  G.BookingId=P.BookingId AND G.BookingPropertyTableId=P.Id
  WHERE G.BookingId=@Id AND P.GetType='Property' AND
  P.PropertyType='ExP')
   BEGIN    
    SELECT TOP 1 @TACPer = ISNULL(A.TACPer,0)
    /*SELECT TOP 1 @Taxes = (CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'Including Tax' 
    ELSE 'Taxes as applicable' END),@TACPer = ISNULL(A.TACPer,0)*/
    FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON 
    A.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
    R.AgreementId=A.Id
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND A.IsActive=1 AND 
    A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
    P.Id = @BookingPropertyId AND 
    R.RoomType = (SELECT TOP 1 RoomType FROM WRBHBBookingPropertyAssingedGuest
    WHERE BookingId=@Id);    
    --
    DECLARE @SingleCnt INT = 0;
    SELECT @SingleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND
    Occupancy = 'Single';
    --
    DECLARE @DoubleCnt INT = 0;
    SELECT @DoubleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND
    Occupancy = 'Double';
    --
    DECLARE @TripleCnt INT = 0;
    SELECT @TripleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND
    Occupancy = 'Triple';
    --
    DECLARE @SingleTariff DECIMAL(27,2) = 0;
    DECLARE @DoubleTariff DECIMAL(27,2) = 0;
    DECLARE @TripleTariff DECIMAL(27,2) = 0;
    DECLARE @SingleMarkup DECIMAL(27,2) = 0;
    DECLARE @DoubleMarkup DECIMAL(27,2) = 0;
    DECLARE @TripleMarkup DECIMAL(27,2) = 0;
    DECLARE @TACFlag BIT = 0;
    /*SELECT TOP 1 @SingleTariff = SingleTariff,@DoubleTariff = DoubleTariff,
    @TripleTariff = TripleTariff,@TACFlag = ISNULL(TAC,0),
    @SingleMarkup = (SingleandMarkup1 - SingleTariff),
    @DoubleMarkup = (DoubleandMarkup1 - DoubleTariff),
    @TripleMarkup = (TripleandMarkup1 - TripleTariff)
    FROM WRBHBBookingProperty P    
    WHERE P.BookingId=@Id AND P.PropertyId = @BookingPropertyId;*/
    SELECT TOP 1 @SingleTariff = (SingleandMarkup1 - (GeneralMarkup + Markup)),
    @DoubleTariff = (DoubleandMarkup1 - (GeneralMarkup + Markup)),
    @TripleTariff = (TripleandMarkup1 - (GeneralMarkup + Markup)),
    @TACFlag = ISNULL(TAC,0),
    @SingleMarkup = (GeneralMarkup + Markup),
    @DoubleMarkup = (GeneralMarkup + Markup),
    @TripleMarkup = (GeneralMarkup + Markup)
    FROM WRBHBBookingProperty P
    WHERE P.Id IN (SELECT BookingPropertyTableId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id);
    --
    IF @TACFlag = 0
     BEGIN
      IF @SingleCnt != 0 
       BEGIN 
        SET @AgreedTariff = 
        'Single - Tariff : ' + CAST(@SingleTariff AS VARCHAR) +
        ', TAC : ' + CAST(@SingleMarkup AS VARCHAR) + '.<br>';
       END
      IF @DoubleCnt != 0
       BEGIN
        IF @AgreedTariff != ''
         BEGIN
          SET @AgreedTariff = 
          @AgreedTariff + 'Double - Tariff : ' + CAST(@DoubleTariff AS VARCHAR) +
          ', TAC : ' + CAST(@DoubleMarkup AS VARCHAR) + '.<br>';
         END
        ELSE
         BEGIN
          SET @AgreedTariff = 
          'Double - Tariff : ' + CAST(@DoubleTariff AS VARCHAR) +
          ', TAC : ' + CAST(@DoubleMarkup AS VARCHAR) + '.<br>';
         END
       END
      IF @TripleCnt != 0
       BEGIN
        IF @AgreedTariff != ''
         BEGIN
          SET @AgreedTariff = 
          @AgreedTariff + 'Triple - Tariff : ' + CAST(@TripleTariff AS VARCHAR) +
          ', TAC : ' + CAST(@TripleMarkup AS VARCHAR) + '.<br>';
         END
        ELSE
         BEGIN
          SET @AgreedTariff = 
          'Triple - Tariff : ' + CAST(@TripleTariff AS VARCHAR) +
          ', TAC : ' + CAST(@TripleMarkup AS VARCHAR) + '.<br>';
         END
       END
     END
    ELSE
     BEGIN
      IF @SingleCnt != 0
       BEGIN
        SET @AgreedTariff = 
        'Tariff - Single : ' + CAST(@SingleTariff AS VARCHAR)+', ';
       END
      IF @DoubleCnt != 0
       BEGIN
        IF @AgreedTariff != ''
         BEGIN
          SET @AgreedTariff = 
          @AgreedTariff + 'Double : ' + CAST(@DoubleTariff AS VARCHAR)+ ', ';
         END
        ELSE
         BEGIN
          SET @AgreedTariff = 
          'Double : ' + CAST(@DoubleTariff AS VARCHAR) + ', ';
         END
       END
      IF @TripleCnt != 0
       BEGIN
        IF @AgreedTariff != ''
         BEGIN
          SET @AgreedTariff = 
          @AgreedTariff + 'Triple : ' + CAST(@TripleTariff AS VARCHAR) + ', ';
         END
        ELSE
         BEGIN
          SET @AgreedTariff = 
          'Triple : ' + CAST(@TripleTariff AS VARCHAR) + ', ';
         END
       END
      SET @AgreedTariff = @AgreedTariff + 'TAC : ' + CAST(@TACPer AS VARCHAR)+' %';
     END
   END
  ELSE
   BEGIN
    DECLARE @Taxes123 NVARCHAR(100) = 'Taxes as applicable';
   END
  --
  DECLARE @TypeOfProperty NVARCHAR(100) = '';
  DECLARE @TypeOfRoom NVARCHAR(100) = '';
  SELECT @TypeOfProperty = PropertyType,@TypeOfRoom = RoomType
  FROM WRBHBBookingProperty WHERE Id IN 
  (SELECT TOP 1 BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
  WHERE BookingId = @Id);
  DECLARE @PtyRefNo NVARCHAR(100) = '';
  DECLARE @PropertyRefNo NVARCHAR(100) = '';
  SELECT @PtyRefNo = ISNULL(PropertyRefNo,'') FROM WRBHBBooking WHERE Id=@Id;
  IF @PtyRefNo = ''
   BEGIN
    SET @PropertyRefNo = 'booking number';
   END
  ELSE
   BEGIN
    SET @PropertyRefNo = 'reference number - '+@PtyRefNo;
   END
  --
  DECLARE @BTCTaxesContent NVARCHAR(1000) = '';  
  IF @TypeofPtyy NOT IN ('MGH','InP','DdP')
   BEGIN
    SET @BTCTaxesContent = 'Inclusive of Property Taxes (LT & ST) & 7.42% extra ST.';
   END
  IF @TypeofPtyy IN ('MGH','InP','DdP')
   BEGIN
    SET @BTCTaxesContent = 'Taxes as applicable';
   END  
  -- dataset table 4
  SELECT CAST(EmailtoGuest AS INT),
  'D:/Backend/flex_bin/Company_Images/Proof_of_Stay.pdf',
  --'D:/admonk/Backend/flex_bin/Company_Images/Proof_of_Stay.pdf',
  'Proof_of_Stay.pdf',@PName,@MobileNo,@SecurityPolicy,
  @CancelationPolicy,@Taxes,@TypeOfProperty,@PropertyRefNo,@CLogo,@CLogoAlt,
  @TypeOfRoom,@BTCTaxesContent,@Stay,@Uniglobe 
  FROM WRBHBBooking WHERE Id=@Id;
  -- dataset table 5
  SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id;
  -- Dataset Table 6  
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND 
  ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id))
   BEGIN
    SELECT ClientLogo,ClientName,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH 
    FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND
    Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id);    
   END
  ELSE
   BEGIN
    SELECT Logo,@CLogoAlt,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH 
    FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- dataset table 7
  SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);
  -- Dataset Table 8
  --SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@Id;
  DECLARE @RPId NVARCHAR(100) = 
  (SELECT TOP 1 CAST(ISNULL(BookingPropertyId,'') AS VARCHAR) 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE BookingId = @Id GROUP BY BookingPropertyId);
  SELECT B.ClientBookerEmail,BP.PropertyType,B.ExtraCCEmail,
  'http://sstage.in/qr/'+@RPId+'.png' FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP 
  WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingPropertyTableId=BP.Id 
  WHERE BG.BookingId=@Id 
  GROUP BY B.ClientBookerEmail,BP.PropertyType,B.ExtraCCEmail;
  -- Dataset Table 9 Email Address Begin
  CREATE TABLE #Mail(Id INT,Email NVARCHAR(100));
  -- Guest Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(G.EmailId,'') FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails G WITH(NOLOCK)ON
  G.BookingId=B.Id
  WHERE B.EmailtoGuest=1 AND B.Id=@Id;
  -- Booker Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(ClientBookerEmail,'') FROM WRBHBBooking 
  WHERE Id=@Id AND ISNULL(ClientBookerEmail,'') != '';
  -- Extra CC Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(Email,'') FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);    
  --
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id AND BP.PropertyType IN ('CPP'))
   BEGIN
    INSERT INTO #Mail(Id,Email)
    SELECT 0,ISNULL(D.Email,'') FROM WRBHBContractClientPref_Header H
    LEFT OUTER JOIN WRBHBContractClientPref_Details D
    WITH(NOLOCK)ON D.HeaderId=H.Id
    WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND
    D.IsDeleted=0 AND 
    H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id=@Id) AND
    D.PropertyId IN (SELECT BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id); 
   END
  ELSE
   BEGIN
    -- Property Email
    SET @PropertyEmail=(SELECT ISNULL(Email,'') FROM WRBHBProperty 
    WHERE Id=@BookingPropertyId AND ISNULL(Email,'') != '');
    INSERT INTO #Mail(Id,Email)
    SELECT * FROM dbo.Split(@PropertyEmail, ',');
   END  
  -- Final Select
  SELECT Email FROM #Mail WHERE Email != '' GROUP BY Email;
  -- Dataset Table 9 Email Address End
  -- Dataset Table 10 Begin
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id));
  --
  --select 'df';return;
  -- Dataset Table 10 End
  DECLARE @BelowTACcontent NVARCHAR(MAX) = 'Kindly arrange to pay the above TAC amount to HummingBird by CHEQUE or through Bank Transfer (NEFT).<br><b>CHEQUE</b> : Kindly issue the cheque in Favour of "Humming Bird Travel & Stay Pvt Ltd".<br><b>Bank Transfer (NEFT)</b> : <br>Payee Name : Humming Bird Travel & Stay Pvt. Ltd.<br>Bank Name : HDFC Bank<br>Account No. : 17552560000226<br>IFSC : HDFC0001755';
  -- Dataset Table 11 bEGIN
  CREATE TABLE #PropertyMailBTCChecking(Name NVARCHAR(100),
  ChkInDt NVARCHAR(100),ChkOutDt NVARCHAR(100),Tariff NVARCHAR(100),
  Occupancy NVARCHAR(100),TariffPaymentMode NVARCHAR(100),
  ServicePaymentMode NVARCHAR(100),RoomNo NVARCHAR(100));
  INSERT INTO #PropertyMailBTCChecking(Name,ChkInDt,ChkOutDt,Tariff,
  Occupancy,TariffPaymentMode,ServicePaymentMode,RoomNo)
  SELECT B.Name,B.ChkInDt,B.ChkOutDt,B.Tariff,B.Occupancy,B.TariffPaymentMode,
  B.ServicePaymentMode,B.RoomNo FROM #QAZ B;
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id AND BG.TariffPaymentMode='Bill to Company (BTC)' AND
  BP.PropertyType IN ('ExP'))
   BEGIN
    DECLARE @Single DECIMAL(27,2),@Double DECIMAL(27,2),@Triple DECIMAL(27,2);
    SELECT @Single=SingleTariff,@Double=DoubleTariff,@Triple=TripleTariff
    FROM WRBHBBookingProperty BP
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
    BP.PropertyId=BG.BookingPropertyId
    WHERE BG.BookingId=@Id;
    SELECT Name,ChkInDt,ChkOutDt,
    CASE WHEN Occupancy = 'Single' THEN @Single
         WHEN Occupancy = 'Double' THEN @Double
         WHEN Occupancy = 'Triple' THEN @Triple
         ELSE Tariff END,Occupancy,TariffPaymentMode,
    ServicePaymentMode,'BTC',@AgreedTariff,@BelowTACcontent,RoomNo
    FROM #PropertyMailBTCChecking;
   END
  ELSE
   BEGIN
    SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
    ServicePaymentMode,'NOTBTC',@AgreedTariff,@BelowTACcontent,RoomNo 
    FROM #PropertyMailBTCChecking;
   END
  -- Dataset Table 11 eND 
 END
IF @Action = 'BedBookingConfirmed'
 BEGIN
  -- Dataset Table 0
  SELECT BA.Title+'. '+BA.FirstName+'  '+BA.LastName,
  REPLACE(CONVERT(VARCHAR(11),CheckInDate, 106), ' ', '-') +' / '+ 
  LEFT(ExpectedChkInTime, 5)+' '+BA.AMPM,
  REPLACE(CONVERT(VARCHAR(11), CheckOutDate, 106), ' ', '-'),
  BA.Tariff,
  CASE WHEN BA.TariffPaymentMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BA.TariffPaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BA.TariffPaymentMode END AS TariffPaymentMode,       
  CASE WHEN BA.ServicePaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BA.ServicePaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BA.ServicePaymentMode END AS ServicePaymentMode,
       BA.BedType
  --BA.TariffPaymentMode,BA.ServicePaymentMode
  FROM dbo.WRBHBBooking BP
  LEFT OUTER JOIN dbo.WRBHBBedBookingPropertyAssingedGuest BA 
  WITH(NOLOCK)ON BP.Id=BA.BookingId AND BA.IsActive=1 AND BA.IsDeleted=0
  WHERE BP.Id=@Id AND BP.IsActive=1 AND BP.IsDeleted=0;
  -- Get Booking Property Id
  SET @BookingPropertyId=(SELECT TOP 1 BookingPropertyId 
  FROM WRBHBBedBookingPropertyAssingedGuest WHERE IsActive=1 AND IsDeleted=0 
  AND BookingId=@Id);
  -- Dataset Table 1
  SELECT BP.Propertaddress+', '+L.Locality+', '+
  C.CityName+', '+S.StateName+' - '+BP.Postal,
  BP.Phone,BP.Directions,BP.BookingPolicy,BP.CancelPolicy,BP.PropertyName,
  BP.Category,ISNULL(BP.CheckOutType,'') CheckOutType,
  ISNULL(CheckIn,'') CheckIn,ISNULL(CheckInType,'') CheckInType,
  ISNULL(CheckOut,'') CheckOut,T.PropertyType FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
  LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId
  LEFT OUTER JOIN dbo.WRBHBPropertyType T WITH(NOLOCK) ON T.Id=BP.PropertyType  
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  -- Dataset Table 2
  SELECT ISNULL(ClientLogo,'') AS ClientLogo,C.ClientName,
  B.BookingCode,U.FirstName,U.Email,U.PhoneNumber,B.ClientBookerName,
  REPLACE(CONVERT(VARCHAR(11), B.CreatedDate, 106), ' ', '-'),
  B.SpecialRequirements,B.ClientBookerEmail FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=B.CreatedBy
  WHERE B.Id=@Id;
  -- Dataset Table 3
  SELECT BP.PropertyName,ISNULL(U.FirstName,''),ISNULL(U.Email,''),
  ISNULL(U.MobileNumber,''),ISNULL(BP.Email,'')
  FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id=PU.PropertyId
  AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
  UserType in('Resident Managers','Assistant Resident Managers')
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  --
  SELECT @PName=(P.PropertyName+', '+L.Locality+', '+C.CityName),
  @SecurityPolicy=P.BookingPolicy,@CancelationPolicy=P.CancelPolicy
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=P.CityId
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId 
  WHERE P.Id = @BookingPropertyId;
  --
  CREATE TABLE #GST1(MobileNo NVARCHAR(100));
  INSERT INTO #GST1(MobileNo)
  SELECT STUFF((SELECT ', '+ISNULL(BA.MobileNo,'')
  FROM WRBHBBookingGuestDetails BA
  WHERE BA.BookingId=G.BookingId AND BA.GuestId=BA.GuestId AND
  BA.MobileNo != ''
  FOR XML PATH('')),1,1,'') AS MobileNo
  FROM WRBHBBookingPropertyAssingedGuest G
  WHERE G.BookingId=@Id GROUP BY G.BookingId;
  --
  SET @MobileNo = (SELECT TOP 1 ISNULL(MobileNo,'') FROM #GST1);
  -- Dataset Table 4
  SELECT CAST(EmailtoGuest AS INT),@PName,@MobileNo,
  @SecurityPolicy,@CancelationPolicy,@Stay,@Uniglobe FROM WRBHBBooking 
  WHERE Id=@Id;
  --
  DECLARE @BedBookingPropertyType NVARCHAR(100) = '';
  SELECT TOP 1 @BedBookingPropertyType = PropertyType FROM WRBHBBedBookingProperty 
  WHERE Id IN (SELECT TOP 1 BookingPropertyTableId 
  FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId = @Id);
  -- Dataset Table 5
  SELECT EmailId,@BedBookingPropertyType FROM WRBHBBookingGuestDetails 
  WHERE BookingId=@Id;
  -- Dataset Table 6
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND 
  ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id))
   BEGIN
    SELECT ClientLogo,ClientName,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH 
    FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND
    Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id);    
   END
  ELSE
   BEGIN
    SELECT Logo,@CLogoAlt,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH
    FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- Dataset table 7
  SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);
  -- Dataset Table 8
  DECLARE @BPId NVARCHAR(100) = 
  (SELECT TOP 1 CAST(ISNULL(BookingPropertyId,'') AS VARCHAR) 
  FROM WRBHBBedBookingPropertyAssingedGuest
  WHERE BookingId = @Id GROUP BY BookingPropertyId);
  SELECT ClientBookerEmail,ExtraCCEmail,
  'http://sstage.in/qr/'+@BPId+'.png' FROM WRBHBBooking WHERE Id=@Id;
  -- Dataset Table 9 Email Address Begin
  CREATE TABLE #BedMail(Id INT,Email NVARCHAR(100));
  -- Guest Email
  INSERT INTO #BedMail(Id,Email)
  SELECT 0,ISNULL(G.EmailId,'') FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails G WITH(NOLOCK)ON
  G.BookingId=B.Id
  WHERE B.EmailtoGuest=1 AND B.Id=@Id;
  -- Booker Email
  INSERT INTO #BedMail(Id,Email)
  SELECT 0,ISNULL(ClientBookerEmail,'') FROM WRBHBBooking 
  WHERE Id=@Id AND ISNULL(ClientBookerEmail,'') != '';
  -- Extra CC Email
  INSERT INTO #BedMail(Id,Email)
  SELECT 0,ISNULL(Email,'') FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);  
  -- Property Email
  SET @PropertyEmail=(SELECT ISNULL(Email,'') FROM WRBHBProperty 
  WHERE Id=@BookingPropertyId AND ISNULL(Email,'') != '');
  INSERT INTO #BedMail(Id,Email)
  SELECT * FROM dbo.Split(@PropertyEmail, ',');
  -- Final Select
  SELECT Email FROM #BedMail WHERE Email != '';
  -- Dataset Table 9 Email Address End
  -- Dataset Table 10 Begin
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id));
  -- Dataset Table 10 End  
 END
IF @Action = 'ApartmentBookingConfirmed'
 BEGIN
  -- Dataset Table 0
  CREATE TABLE #Aprtmnt(BookingId BIGINT,ApartmentId BIGINT,
  ChkInDt NVARCHAR(100),ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100));
  INSERT INTO #Aprtmnt(BookingId,ApartmentId,ChkInDt,ChkOutDt,Tariff,
  TariffPaymentMode,ServicePaymentMode)
  SELECT BG.BookingId,BG.ApartmentId,
  REPLACE(CONVERT(VARCHAR(11),BG.ChkInDt, 106), ' ', '-') +' / '+ 
  LEFT(BG.ExpectChkInTime, 5)+' '+BG.AMPM,
  REPLACE(CONVERT(VARCHAR(11), BG.ChkOutDt, 106), ' ', '-'),
  BG.Tariff,
  CASE WHEN BG.TariffPaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.TariffPaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BG.TariffPaymentMode END AS TariffPaymentMode,
  CASE WHEN BG.ServicePaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.ServicePaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1       
       ELSE BG.ServicePaymentMode END AS ServicePaymentMode
  --BG.TariffPaymentMode,BG.ServicePaymentMode 
  FROM WRBHBApartmentBookingPropertyAssingedGuest BG
  WHERE BG.IsActive=1 AND BG.IsDeleted=0 AND BG.BookingId=@Id 
  GROUP BY BG.BookingId,BG.ApartmentId,BG.ChkInDt,BG.ExpectChkInTime,BG.AMPM,
  BG.ChkOutDt,BG.Tariff,BG.TariffPaymentMode,BG.ServicePaymentMode;
  SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
  FROM WRBHBApartmentBookingPropertyAssingedGuest BA 
  WHERE BA.BookingId=B.BookingId AND BA.ApartmentId=B.ApartmentId
  FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt,
  B.Tariff,B.TariffPaymentMode,B.ServicePaymentMode FROM #Aprtmnt AS B;
  /*SELECT BA.FirstName+'  '+BA.LastName,
  REPLACE(CONVERT(VARCHAR(11),CheckInDate, 106), ' ', '-') +' / '+ 
  LEFT(ExpectedChkInTime, 5)+' '+BA.AMPM,
  REPLACE(CONVERT(VARCHAR(11), CheckOutDate, 106), ' ', '-'),
  BA.Tariff,BA.TariffPaymentMode,BA.ServicePaymentMode
  FROM dbo.WRBHBBooking BP
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BA 
  WITH(NOLOCK)ON BP.Id=BA.BookingId AND BA.IsActive=1 AND BA.IsDeleted=0
  WHERE BP.Id=@Id AND BP.IsActive=1 AND BP.IsDeleted=0;*/
  -- Get Booking Property Id
  SET @BookingPropertyId=(SELECT TOP 1 BookingPropertyId 
  FROM WRBHBApartmentBookingPropertyAssingedGuest 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id);
  -- Dataset Table 1
  SELECT BP.Propertaddress+', '+L.Locality+', '+
  C.CityName+', '+S.StateName+' - '+BP.Postal,
  BP.Phone,BP.Directions,BP.BookingPolicy,BP.CancelPolicy,BP.PropertyName,
  BP.Category,ISNULL(BP.CheckOutType,'') CheckOutType,ISNULL(CheckIn,'') CheckIn,ISNULL(CheckInType,'') CheckInType,
  ISNULL(CheckOut,'') CheckOut,T.PropertyType FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
  LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId
  LEFT OUTER JOIN dbo.WRBHBPropertyType T WITH(NOLOCK) ON T.Id=BP.PropertyType
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  -- Dataset Table 2
  SELECT ISNULL(ClientLogo,'') AS ClientLogo,C.ClientName,
  B.BookingCode,U.FirstName,U.Email,U.PhoneNumber,B.ClientBookerName,
  REPLACE(CONVERT(VARCHAR(11), B.CreatedDate, 106), ' ', '-'),
  B.SpecialRequirements,B.ClientBookerEmail,B.ExtraCCEmail FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=B.CreatedBy
  WHERE B.Id=@Id;
  -- Dataset Table 3
  SELECT BP.PropertyName,ISNULL(U.FirstName,''),ISNULL(U.Email,''),
  ISNULL(U.MobileNumber,''),ISNULL(BP.Email,'')
  FROM dbo.WRBHBProperty BP
  LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id=PU.PropertyId
  AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
  UserType in('Resident Managers','Assistant Resident Managers')
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
  WHERE BP.Id=@BookingPropertyId  AND BP.IsActive=1 AND BP.IsDeleted=0;
  --
  SELECT @PName=(P.PropertyName+', '+L.Locality+', '+C.CityName),
  @SecurityPolicy=P.BookingPolicy,@CancelationPolicy=P.CancelPolicy
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=P.CityId
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId 
  WHERE P.Id = @BookingPropertyId;
  --
  CREATE TABLE #GST11(MobileNo NVARCHAR(100));
  INSERT INTO #GST11(MobileNo)
  SELECT STUFF((SELECT ', '+ISNULL(BA.MobileNo,'')
  FROM WRBHBBookingGuestDetails BA
  WHERE BA.BookingId=G.BookingId AND BA.GuestId=BA.GuestId AND
  BA.MobileNo != ''
  FOR XML PATH('')),1,1,'') AS MobileNo
  FROM WRBHBBookingPropertyAssingedGuest G
  WHERE G.BookingId=@Id GROUP BY G.BookingId;
  --
  SET @MobileNo = (SELECT TOP 1 ISNULL(MobileNo,'') FROM #GST11);
  -- Dataset Table 4
  SELECT CAST(EmailtoGuest AS INT),@PName,@MobileNo,
  @SecurityPolicy,@CancelationPolicy,@Stay,@Uniglobe FROM WRBHBBooking 
  WHERE Id=@Id;
  -- Dataset Table 5
  SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id;
  -- Dataset Table 6
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND 
  ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id))
   BEGIN
    SELECT ClientLogo,ClientName,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH 
    FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND
    Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id);    
   END
  ELSE
   BEGIN
    SELECT Logo,@CLogoAlt,@CLogo,@CLogoAlt,@cltlogoMGH,@cltaltMGH 
    FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- Dataset table 7
  SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);
  -- Dataset Table 8
  DECLARE @PId NVARCHAR(100) = 
  (SELECT TOP 1 CAST(ISNULL(BookingPropertyId,'') AS VARCHAR) 
  FROM WRBHBApartmentBookingPropertyAssingedGuest
  WHERE BookingId = @Id GROUP BY BookingPropertyId);
  SELECT ClientBookerEmail,ExtraCCEmail,
  'http://sstage.in/qr/'+@PId+'.png' FROM WRBHBBooking 
  WHERE Id = @Id;
  -- Dataset Table 9 Email Address Begin
  CREATE TABLE #AMail(Id INT,Email NVARCHAR(100));
  -- Guest Email
  INSERT INTO #AMail(Id,Email)
  SELECT 0,ISNULL(G.EmailId,'') FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails G WITH(NOLOCK)ON
  G.BookingId=B.Id
  WHERE B.EmailtoGuest=1 AND B.Id=@Id;
  -- Booker Email
  INSERT INTO #AMail(Id,Email)
  SELECT 0,ISNULL(ClientBookerEmail,'') FROM WRBHBBooking 
  WHERE Id=@Id AND ISNULL(ClientBookerEmail,'') != '';
  -- Extra CC Email
  INSERT INTO #AMail(Id,Email)
  SELECT 0,ISNULL(Email,'') FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);  
  -- Property Email
  SET @PropertyEmail=(SELECT ISNULL(Email,'') FROM WRBHBProperty 
  WHERE Id=@BookingPropertyId AND ISNULL(Email,'') != '');
  INSERT INTO #AMail(Id,Email)
  SELECT * FROM dbo.Split(@PropertyEmail, ',');
  -- Final Select
  SELECT Email FROM #AMail WHERE Email != '';
  -- Dataset Table 9 Email Address End
  -- Dataset Table 10 Begin
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id));
  -- Dataset Table 10 End  
 END
IF @Action = 'MMTBookingConfirmed'
 BEGIN
  ---
  --INSERT INTO MMTMailFlag(BookingId)VALUES(@Id);
  -- Dataset Table 0
  CREATE TABLE #FFF1(BookingId BIGINT,RoomId BIGINT,ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
  RoomCaptured INT);
  ---
  INSERT INTO #FFF1(BookingId,RoomId,ChkInDt,ChkOutDt,Tariff,Occupancy,
  TariffPaymentMode,ServicePaymentMode,RoomCaptured)
  ---
  SELECT BG.BookingId,BG.RoomId,
  REPLACE(CONVERT(VARCHAR(11),BG.ChkInDt, 106), ' ', '-') +' / '+ 
  LEFT(BG.ExpectChkInTime, 5)+' '+BG.AMPM,
  REPLACE(CONVERT(VARCHAR(11), BG.ChkOutDt, 106), ' ', '-'),
  BG.Tariff,BG.Occupancy,
  CASE WHEN BG.TariffPaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.TariffPaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1
       --WHEN BG.TariffPaymentMode = 'Bill to Company (BTC)' THEN
       --'Bill to Company (BTC)<br>(7.42% Tax Extra)'
       ELSE BG.TariffPaymentMode END AS TariffPaymentMode,
  CASE WHEN BG.ServicePaymentMode='Direct' THEN 'Direct<br>(Cash/Card)'
       WHEN BG.ServicePaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1
       --WHEN BG.ServicePaymentMode = 'Bill to Company (BTC)' THEN
       --'Bill to Company (BTC)<br>(7.42% Tax Extra)'
       ELSE BG.ServicePaymentMode END AS ServicePaymentMode,BG.RoomCaptured 
  FROM WRBHBBookingPropertyAssingedGuest BG
  WHERE BG.IsActive=1 AND BG.IsDeleted=0 AND BG.BookingId=@Id 
  GROUP BY BG.BookingId,BG.RoomId,BG.ChkInDt,BG.ExpectChkInTime,BG.AMPM,
  BG.ChkOutDt,BG.Tariff,BG.Occupancy,BG.TariffPaymentMode,
  BG.ServicePaymentMode,BG.RoomCaptured;
  --
  CREATE TABLE #MAILGUESTDATA(Name NVARCHAR(1000),ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100));
  INSERT INTO #MAILGUESTDATA(Name,ChkInDt,ChkOutDt,Tariff,Occupancy,
  TariffPaymentMode,ServicePaymentMode)
  SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
  FROM WRBHBBookingPropertyAssingedGuest BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured
  FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt,
  B.Tariff,B.Occupancy,B.TariffPaymentMode,B.ServicePaymentMode
  FROM #FFF1 AS B;
  -- DATASET TABLE 0
  SELECT Name,ChkInDt,ChkOutDt,Tariff,
  --CAST(Tariff - ROUND((Tariff * 19 / 100),0) AS DECIMAL(27,2)),
  Occupancy,TariffPaymentMode,ServicePaymentMode FROM #MAILGUESTDATA;  
  ---
  SELECT TOP 1 @BookingPropertyId=BookingPropertyId 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id;
  --
  SET @ClientId1=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id);
  --
  DECLARE @PtyId BIGINT = 0,@Rtpln NVARCHAR(100) = '';
  DECLARE @Rmtpe NVARCHAR(100) = '';
  SELECT @PtyId = PropertyId, @Rtpln = RatePlanCode,
  @Rmtpe = RoomTypeCode FROM WRBHBBookingProperty
  WHERE Id IN (SELECT BookingPropertyTableId 
  FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id);
  SELECT TOP 1 @CancelationPolicy = PenaltyDescription 
  FROM WRBHBAPIRoomRateDtls
  WHERE HotelId = @PtyId AND RoomRateroomTypeCode = @Rmtpe AND
  RoomRateratePlanCode = @Rtpln
  ORDER BY Id DESC;
  SELECT @CancelationPolicy = ISNULL(PenaltyDescription,'') 
  FROM WRBHBAPIRoomRateDtls
  WHERE HotelId=@PtyId AND RoomRateroomTypeCode=@Rmtpe AND
  RoomRateratePlanCode=@Rtpln ORDER BY Id DESC;
  --
  SET @SecurityPolicy = '<ul><li>A picture of the guest will be taken through webcam for records.</li><li> The guests mobile number and official e-mail address needs to be provided.</li><li> Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced.</li><li> A company business card or company ID card needs to be produced.</li></ul>';
  IF @CancelationPolicy = ''
  BEGIN
  SET @CancelationPolicy = '<ul><li> Email to <a href="mailto:stay@staysimplyfied.com" target="_blank">stay@staysimplyfied.com</a> and mention the booking ID no.</li><li>Cancellation less than 48 hrs &nbsp;&ndash; NIL. More than 48 hrs. &ndash; 100% refund.</li><li>1 day tariff will be charged for no-show without intimation.</li></ul>';
  END
  -- dataset table 1
  SELECT SH.HotalName,SH.Line1+', '+SH.Line2+', '+SH.Area+', '+SH.City+', '+
  SH.State+', '+SH.Pincode AS Propertaddress,SH.Phone,dbo.TRIM(SH.Description),
  ISNULL(SH.CheckInTime,'') CheckInType,
  ISNULL(SH.CheckOutTime,'') AS CheckOutType,'MMT' AS Category,
  @SecurityPolicy,@CancelationPolicy
  FROM WRBHBStaticHotels SH
  WHERE SH.HotalId=@BookingPropertyId AND SH.IsActive=1 AND SH.IsDeleted=0;
  -- dataset table 2
  DECLARE @MMTPId NVARCHAR(100) = '';
  SET @MMTPId = (SELECT TOP 1 CAST(ISNULL(BookingPropertyId,'') AS VARCHAR) 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE BookingId = @Id GROUP BY BookingPropertyId);
  SELECT B.BookingCode,U.FirstName,
  REPLACE(CONVERT(VARCHAR(11), B.CreatedDate, 106), ' ', '-') AS ReservationDt,
  C.ClientName,U.Email,B.SpecialRequirements,
  CAST(B.EmailtoGuest AS INT),B.ClientBookerEmail,
  BP.BookHotelReservationIdvalue,B.ExtraCCEmail,
  'http://sstage.in/qr/'+@MMTPId+'.png'
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=B.CreatedBy
  WHERE B.Id=@Id;
  -- dataset table 3 
  /*SELECT EmailId,'Including Tax' FROM WRBHBBookingGuestDetails 
  WHERE BookingId=@Id GROUP BY EmailId;*/
  --SELECT EmailId,'Taxes as applicable',@Stay,@Uniglobe 
  SELECT EmailId,'Including Tax',@Stay,@Uniglobe
  FROM WRBHBBookingGuestDetails 
  WHERE BookingId=@Id GROUP BY EmailId;
  -- Dataset Table 4
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND ClientId=@ClientId1)
   BEGIN
    SELECT ClientLogo,ClientName FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND Id=@ClientId1;
   END
  ELSE
   BEGIN
    SELECT Logo,'Staysimplyfied' AS CLogoAlt FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- Dataset Table 5 Begin
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id));
  -- Dataset Table 5 End  
  /*-- DELETE API DATA BEGIN
  DECLARE @TMPHeaderId BIGINT = 0;
  SELECT @TMPHeaderId=ISNULL(APIHdrId,0) FROM WRBHBBookingProperty 
  WHERE BookingId=@Id;
  IF @TMPHeaderId != 0
   BEGIN
    DELETE FROM WRBHBAPIHeader WHERE Id=@TMPHeaderId;
    DELETE FROM WRBHBAPIHotelHeader WHERE Id=@TMPHeaderId;
    DELETE FROM WRBHBAPIRateMealPlanInclusionDtls WHERE Id=@TMPHeaderId;
    DELETE FROM WRBHBAPIRoomRateDtls WHERE Id=@TMPHeaderId;
    DELETE FROM WRBHBAPIRoomTypeDtls WHERE Id=@TMPHeaderId;
    DELETE FROM WRBHBAPITariffDtls WHERE Id=@TMPHeaderId;
   END 
  -- DELETE API DATA END*/
 END
IF @Action = 'BookingConfirmedSMS'
 BEGIN
  DECLARE @BookingLevel NVARCHAR(100) = '';
  SET @BookingLevel = (SELECT BookingLevel FROM WRBHBBooking WHERE Id = @Id);
  IF @BookingLevel = 'Room'
   BEGIN
    SELECT TOP 1 @TXADED = ISNULL(TaxAdded,'T')
    FROM WRBHBBookingProperty WHERE Id IN (
    SELECT TOP 1 BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
    WHERE BookingId = @Id);
    IF @TXADED = 'N'
     BEGIN
      SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Nett. Contact:'+ BP.Phone +'&state=4',
      PAG.GuestId FROM WRBHBBooking B
      LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
      BG.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
      BP.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
      PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
      PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
      WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
     END
    IF @TXADED = 'T'
     BEGIN
      SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
      PAG.GuestId FROM WRBHBBooking B
      LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
      BG.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
      BP.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
      PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
      PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
      WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
     END
    /*IF EXISTS (SELECT NULL FROM WRBHBBookingProperty P
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK)ON
    G.BookingId=P.BookingId AND G.BookingPropertyTableId=P.Id
    WHERE G.BookingId=@Id AND P.PropertyType='ExP' AND P.TaxAdded = 'N' AND
    G.TariffPaymentMode = 'Bill to Company (BTC)')
     BEGIN
      SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(CAST(PAG.Tariff - ROUND(PAG.Tariff * 19 / 100,0) AS DECIMAL(27,2)) AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
      PAG.GuestId FROM WRBHBBooking B
      LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
      BG.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
      BP.BookingId = B.Id
      LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
      PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
      PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
      WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
     END
    ELSE
     BEGIN
      SELECT TOP 1 @TypeofPtyy = PropertyType,@TXADED = ISNULL(TaxAdded,'T')
      FROM WRBHBBookingProperty WHERE Id IN (
      SELECT TOP 1 BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
      WHERE BookingId = @Id);
      IF @TypeofPtyy = 'ExP' AND @TXADED = 'N'
       BEGIN
        SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Nett. Contact:'+ BP.Phone +'&state=4',
        PAG.GuestId FROM WRBHBBooking B
        LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
        BG.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
        BP.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
        PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
        PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
        WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
       END
      IF @TypeofPtyy = 'ExP' AND @TXADED = 'T'
       BEGIN
        SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
        PAG.GuestId FROM WRBHBBooking B
        LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
        BG.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
        BP.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
        PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
        PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
        WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
       END
      IF @TypeofPtyy = 'MMT'
       BEGIN
        SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(CAST(PAG.Tariff - ROUND(PAG.Tariff * 19 / 100,0) AS DECIMAL(27,2)) AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
        PAG.GuestId FROM WRBHBBooking B
        LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
        BG.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
        BP.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
        PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
        PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
        WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
       END
      IF @TypeofPtyy = 'InP' OR @TypeofPtyy = 'MGH' OR @TypeofPtyy = 'CPP' OR
      @TypeofPtyy = 'DdP'
       BEGIN
        SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
        PAG.GuestId FROM WRBHBBooking B
        LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
        BG.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
        BP.BookingId = B.Id
        LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
        PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
        PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
        WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
       END
     END*/
    /*SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day. MOP for Stay is '+ PAG.TariffPaymentMode +'&state=4',
    PAG.GuestId
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
    BG.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
    PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
    PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
    WHERE B.Id = @Id AND BG.MobileNo != '';*/
   END
  IF @BookingLevel = 'Apartment'
   BEGIN
    SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
    PAG.GuestId
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
    BG.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
    PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
    PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
    WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
   END
  IF @BookingLevel = 'Bed'
   BEGIN
    SELECT 'http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno='+ BG.MobileNo +'&msgtxt=Thank you for booking with HummingBird. Your booking no. '+CAST(B.BookingCode AS VARCHAR)+' at '+BP.PropertyName+','+B.CityName+' @ Rs.'+CAST(PAG.Tariff AS VARCHAR)+'/day Taxes Extra. Contact:'+ BP.Phone +'&state=4',
    PAG.GuestId
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
    BG.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK)ON
    PAG.BookingId = B.Id AND PAG.BookingPropertyTableId = BP.Id AND
    PAG.BookingPropertyId = BP.PropertyId AND PAG.GuestId = BG.GuestId
    WHERE B.Id = @Id AND BG.MobileNo != '' AND PAG.GuestId != 0;
   END
  --http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=shiv@hummingbirdindia.com:HBsmsconf&senderID=HBCONF&receipientno=" + MobileNo + "&msgtxt=" + MsgTxt + "&state=4";
 END
IF @Action = 'BookingStatus'
 BEGIN
  SELECT PropertyType FROM WRBHBBookingProperty WHERE Id IN
  (SELECT BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
  WHERE BookingId = @Id);
 END
END