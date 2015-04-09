-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingConfirmation_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingConfirmation_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:16-Dec-2014
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BookingConfirmation_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@Id1 BIGINT,@Id2 BIGINT)			
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
--
DECLARE @ClientName NVARCHAR(100),@ClientName1 NVARCHAR(100);
SELECT @ClientName = ClientName FROM WRBHBClientManagement
WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @Id1);
CREATE TABLE #QAZXSW(Id INT,Name NVARCHAR(100));
INSERT INTO #QAZXSW(Id,Name)
SELECT * FROM dbo.Split(@ClientName,' ');
SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
--
IF @Action = 'RoomBookingConfirmed'
 BEGIN
  DECLARE @TotAmt NVARCHAR(100) = '';
  CREATE TABLE #TMP(DtTime INT,Dt INT,Tariff DECIMAL(27,2),RoomCaptured INT,Diff INT);
  INSERT INTO #TMP(DtTime,Dt,Tariff,RoomCaptured,Diff)
  SELECT DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)),
  DATEDIFF(HOUR,ChkInDt,ChkOutDt),PG.Tariff,PG.RoomCaptured,
  DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)) - 
  DATEDIFF(HOUR,ChkInDt,ChkOutDt)
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND PG.BookingId = @Id1
  GROUP BY RoomCaptured,ChkInDt,ChkOutDt,Tariff,ExpectChkInTime,AMPM;
  CREATE TABLE #Amt(Dayss DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #Amt(Dayss,Tariff)
  SELECT CASE WHEN Diff > 0 THEN (DtTime / 24) + 1 ELSE (Dt / 24) END,Tariff 
  FROM #TMP;
  SELECT @TotAmt = CAST(CAST(SUM(Dayss * Tariff) AS INT) AS VARCHAR) 
  FROM #Amt;
  --
  SELECT '<p style="font-size:10px;">System generated email. Please do not reply. Date : '+DATENAME(weekday, GETDATE())+', '+CONVERT(VARCHAR(12), GETDATE(), 107)+'</p>
  <p style="font-size:10px;">Dear '+B.ClientBookerName+'</p>
  <p style="font-size:10px;">This is to inform you that your travel request has been processed.</p>
  <p style="font-size:10px;">Your accommodation has been arranged at '+P.PropertyName+', '+P.Locality+', '+B.CityName+' from '+CONVERT(VARCHAR(12),B.CheckInDate,107)+' - '+CONVERT(VARCHAR(12),B.CheckOutDate,107)+'. To confirm the booking,kindly arrange to make advance payment of Rs. '+@TotAmt+'.Booking confirmation mail will be sent to you, once the payment is received.</p>
  <p style="font-size:10px;">To make payment, please <a href=http://www.staysimplyfied.com/paymentgateway/default.aspx?'+REPLACE(B.RowId,'-','')+'>click here</a>.</p>
  <p style="font-size:10px;color:red;font-weight:bold;">Experience the power of digital automation.</p>
  <p style="font-size:8.5px;color:orange;">Thanking You,<br>Team Stay Simplyfied</p>',
  'http://sstage.in/Company_Images/ss_logo.png' AS Logo,'staysimplyfied' as Alt,B.PaymentCode,
  'stay@hummingbirdindia.com'
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty P WITH(NOLOCK)ON P.BookingId = B.Id
  WHERE B.Id = @Id1;
  -- DATASET TABLE 1
  SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId = @Id1 AND ISNULL(EmailId,'') != '' AND GuestId IN
  (SELECT GuestId FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id1);
  -- DATASET TABLE 2
  SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id = @Id1;
  -- DATASET TABLE 3
  CREATE TABLE #BccEmail(Email NVARCHAR(100));
  INSERT INTO #BccEmail(Email) SELECT 'sakthi@warblerit.com';
  INSERT INTO #BccEmail(Email) SELECT 'vivek@warblerit.com';
  INSERT INTO #BccEmail(Email) SELECT 'booking_confirmation@staysimplyfied.com';
  INSERT INTO #BccEmail(Email) SELECT 'bookingbcc@staysimplyfied.com';
  INSERT INTO #BccEmail(Email) SELECT Email FROM WRBHBUSER WHERE Id in
  (select BookedUsrId from wrbhbbooking where Id = @Id1)
  SELECT Email FROM #BccEmail;  
  --<a href=http://www.staysimplyfied.com/paymentgateway/default.aspx?'+REPLACE(B.RowId,'-','')+'/>click here.<br> 
  /*-- Dataset Table 0
  CREATE TABLE #FFF(BookingId BIGINT,RoomId BIGINT,ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
  RoomCaptured INT);
  INSERT INTO #FFF(BookingId,RoomId,ChkInDt,ChkOutDt,Tariff,Occupancy,
  TariffPaymentMode,ServicePaymentMode,RoomCaptured)
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
       ELSE BG.ServicePaymentMode END AS ServicePaymentMode,BG.RoomCaptured 
  FROM WRBHBBookingPropertyAssingedGuest BG
  WHERE BG.IsActive=1 AND BG.IsDeleted=0 AND BG.BookingId=@Id1 AND
  ISNULL(BG.RoomShiftingFlag,0) = 0 
  GROUP BY BG.BookingId,BG.RoomId,BG.ChkInDt,BG.ExpectChkInTime,BG.AMPM,
  BG.ChkOutDt,BG.Tariff,BG.Occupancy,BG.TariffPaymentMode,
  BG.ServicePaymentMode,BG.RoomCaptured;
  CREATE TABLE #QAZ(Name NVARCHAR(100),ChkInDt NVARCHAR(100),
  ChkOutDt NVARCHAR(100),Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100));
  INSERT INTO #QAZ(Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
  ServicePaymentMode)
  SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
  FROM WRBHBBookingPropertyAssingedGuest BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND
  ISNULL(BA.RoomShiftingFlag,0) = 0
  FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt,
  B.Tariff,B.Occupancy,B.TariffPaymentMode,B.ServicePaymentMode
  FROM #FFF AS B;
  --
  DECLARE @Taxes NVARCHAR(100),@TypeofPtyy NVARCHAR(100),@TXADED NVARCHAR(100);
  DECLARE @BookingPropertyTableId BIGINT;
  --  
  IF EXISTS (SELECT NULL FROM WRBHBBookingProperty P
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK)ON
  G.BookingId=P.BookingId AND G.BookingPropertyTableId=P.Id
  WHERE G.BookingId=@Id1 AND P.PropertyType='ExP' AND P.TaxAdded = 'N' AND
  G.TariffPaymentMode = 'Bill to Company (BTC)')
   BEGIN    
    SELECT Name,ChkInDt,ChkOutDt,
    CAST(Tariff - ROUND(Tariff*19/100,0) AS DECIMAL(27,2)),Occupancy,
    TariffPaymentMode,ServicePaymentMode FROM #QAZ;
    SET @Taxes = 'Taxes as applicable';
   END
  ELSE
   BEGIN    
    SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
    ServicePaymentMode FROM #QAZ;
    --
    SELECT TOP 1 @TypeofPtyy = PropertyType,@TXADED = ISNULL(TaxAdded,'T') 
    FROM WRBHBBookingProperty WHERE Id IN (
    SELECT TOP 1 BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
    WHERE BookingId = @Id1);
    IF @TypeofPtyy = 'ExP' AND @TXADED = 'N'
     BEGIN
      SET @Taxes = 'Including Tax';
     END
    IF @TypeofPtyy = 'ExP' AND @TXADED = 'T'
     BEGIN
      SET @Taxes = 'Taxes as applicable';
     END
    IF @TypeofPtyy != 'ExP'
     BEGIN
      SET @Taxes = 'Taxes as applicable';
     END    
   END
  --
  SELECT TOP 1 @BookingPropertyId=BookingPropertyId 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
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
  B.PaymentCode,U.FirstName,U.Email,ISNULL(U.PhoneNumber,''),B.ClientBookerName,
  REPLACE(CONVERT(VARCHAR(11), B.CreatedDate, 106), ' ', '-'),
  B.SpecialRequirements,B.ClientBookerEmail,B.ExtraCCEmail
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=B.CreatedBy
  WHERE B.Id=@Id1;
  -- Get CPP & Property Mail
  DECLARE @MailStr NVARCHAR(1000)='';  
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id1 AND BP.PropertyType IN ('CPP'))
   BEGIN
    -- CPP Mail
    SET @MailStr=(SELECT TOP 1 ISNULL(D.Email,'') 
    FROM WRBHBContractClientPref_Header H
    LEFT OUTER JOIN WRBHBContractClientPref_Details D
    WITH(NOLOCK)ON D.HeaderId=H.Id
    WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND
    D.IsDeleted=0 AND ISNULL(D.Email,'') != '' AND    
    D.RoomType IN (SELECT RoomType
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id1) AND     
    H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1) AND
    D.PropertyId IN (SELECT BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id1));
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
  SELECT BP.PropertyName, ISNULL(U.UserName,'')UserName,
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
  WHERE G.BookingId=@Id1 GROUP BY G.BookingId;
  --
  SET @MobileNo = (SELECT TOP 1 ISNULL(MobileNo,'') FROM #GST);
  --
  DECLARE @TACPer DECIMAL(27,2) = 0;
  DECLARE @AgreedTariff NVARCHAR(1000) = '';
  IF EXISTS (SELECT NULL FROM WRBHBBookingProperty P
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK)ON
  G.BookingId=P.BookingId AND G.BookingPropertyTableId=P.Id
  WHERE G.BookingId=@Id1 AND P.GetType='Property' AND
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
    WHERE BookingId=@Id1);    
    --
    DECLARE @SingleCnt INT = 0;
    SELECT @SingleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1 AND
    Occupancy = 'Single';
    --
    DECLARE @DoubleCnt INT = 0;
    SELECT @DoubleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1 AND
    Occupancy = 'Double';
    --
    DECLARE @TripleCnt INT = 0;
    SELECT @TripleCnt = COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1 AND
    Occupancy = 'Triple';
    --
    DECLARE @SingleTariff DECIMAL(27,2) = 0;
    DECLARE @DoubleTariff DECIMAL(27,2) = 0;
    DECLARE @TripleTariff DECIMAL(27,2) = 0;
    DECLARE @SingleMarkup DECIMAL(27,2) = 0;
    DECLARE @DoubleMarkup DECIMAL(27,2) = 0;
    DECLARE @TripleMarkup DECIMAL(27,2) = 0;
    DECLARE @TACFlag BIT = 0;
    SELECT TOP 1 @SingleTariff = SingleTariff,@DoubleTariff = DoubleTariff,
    @TripleTariff = TripleTariff,@TACFlag = ISNULL(TAC,0),
    @SingleMarkup = (SingleandMarkup1 - SingleTariff),
    @DoubleMarkup = (DoubleandMarkup1 - DoubleTariff),
    @TripleMarkup = (TripleandMarkup1 - TripleTariff)
    FROM WRBHBBookingProperty P    
    WHERE P.BookingId=@Id1 AND P.PropertyId = @BookingPropertyId;
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
  WHERE BookingId = @Id1);
  DECLARE @PtyRefNo NVARCHAR(100) = '';
  DECLARE @PropertyRefNo NVARCHAR(100) = '';
  SELECT @PtyRefNo = ISNULL(PropertyRefNo,'') FROM WRBHBBooking WHERE Id=@Id1;
  IF @PtyRefNo = ''
   BEGIN
    SET @PropertyRefNo = 'booking number';
   END
  ELSE
   BEGIN
    SET @PropertyRefNo = 'reference number - '+@PtyRefNo;
   END
  --
  DECLARE @BTCTaxesContent NVARCHAR(100),@Stay NVARCHAR(100),@Uniglobe NVARCHAR(100);
  -- dataset table 4
  SELECT CAST(EmailtoGuest AS INT),
  'D:/Backend/flex_bin/Company_Images/Proof_of_Stay.pdf',
  --'D:/admonk/Backend/flex_bin/Company_Images/Proof_of_Stay.pdf',
  'Proof_of_Stay.pdf',@PName,@MobileNo,@SecurityPolicy,
  @CancelationPolicy,@Taxes,@TypeOfProperty,@PropertyRefNo,@CLogo,@CLogoAlt,
  @TypeOfRoom,@BTCTaxesContent,@Stay,@Uniglobe,
  'http://www.staysimplyfied.com/payu/default.aspx?'+REPLACE(RowId,'-','') 
  FROM WRBHBBooking WHERE Id=@Id1;
  -- dataset table 5
  SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id1;
  -- Dataset Table 6
  IF EXISTS (SELECT NULL FROM WRBHBClientwisePricingModel 
  WHERE IsActive=1 AND IsDeleted=0 AND 
  ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1))
   BEGIN
    SELECT ClientLogo,ClientName,@CLogo,@CLogoAlt FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0 AND
    Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1);    
   END
  ELSE
   BEGIN
    SELECT Logo,@CLogoAlt,@CLogo,@CLogoAlt FROM WRBHBCompanyMaster 
    WHERE IsActive=1 AND IsDeleted=0;
   END
  -- dataset table 7
  SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id1);
  -- Dataset Table 8
  --SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@Id1;
  DECLARE @RPId NVARCHAR(100) = 
  (SELECT TOP 1 CAST(ISNULL(BookingPropertyId,'') AS VARCHAR) 
  FROM WRBHBBookingPropertyAssingedGuest
  WHERE BookingId = @Id1 GROUP BY BookingPropertyId);
  SELECT B.ClientBookerEmail,BP.PropertyType,B.ExtraCCEmail,
  'http://sstage.in/qr/'+@RPId+'.png' FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP 
  WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingPropertyTableId=BP.Id 
  WHERE BG.BookingId=@Id1 
  GROUP BY B.ClientBookerEmail,BP.PropertyType,B.ExtraCCEmail;
  -- Dataset Table 9 Email Address Begin
  CREATE TABLE #Mail(Id INT,Email NVARCHAR(100));
  -- Guest Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(G.EmailId,'') FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails G WITH(NOLOCK)ON
  G.BookingId=B.Id
  WHERE B.EmailtoGuest=1 AND B.Id=@Id1;
  -- Booker Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(ClientBookerEmail,'') FROM WRBHBBooking 
  WHERE Id=@Id1 AND ISNULL(ClientBookerEmail,'') != '';
  -- Extra CC Email
  INSERT INTO #Mail(Id,Email)
  SELECT 0,ISNULL(Email,'') FROM dbo.WRBHBClientManagementAddNewClient 
  WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
  CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id1);    
  --
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id1 AND BP.PropertyType IN ('CPP'))
   BEGIN
    INSERT INTO #Mail(Id,Email)
    SELECT 0,ISNULL(D.Email,'') FROM WRBHBContractClientPref_Header H
    LEFT OUTER JOIN WRBHBContractClientPref_Details D
    WITH(NOLOCK)ON D.HeaderId=H.Id
    WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND
    D.IsDeleted=0 AND 
    H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1) AND
    D.PropertyId IN (SELECT BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id1); 
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
  SELECT Email FROM #Mail WHERE Email != '';
  -- Dataset Table 9 Email Address End
  -- Dataset Table 10 Begin
  SELECT MasterClientId FROM WRBHBClientSMTP
  WHERE IsActive=1 AND IsDeleted=0 AND
  MasterClientId=(SELECT MasterClientId FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 AND
  Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1));
  -- Dataset Table 10 End
  DECLARE @BelowTACcontent NVARCHAR(MAX) = 'Kindly arrange to pay the above TAC amount to HummingBird by CHEQUE or through Bank Transfer (NEFT).<br><b>CHEQUE</b> : Kindly issue the cheque in Favour of "Humming Bird Travel & Stay Pvt Ltd".<br><b>Bank Transfer (NEFT)</b> : <br>Payee Name : Humming Bird Travel & Stay Pvt. Ltd.<br>Bank Name : HDFC Bank<br>Account No. : 17552560000226<br>IFSC : HDFC0001755';
  -- Dataset Table 11 bEGIN
  CREATE TABLE #PropertyMailBTCChecking(Name NVARCHAR(100),
  ChkInDt NVARCHAR(100),ChkOutDt NVARCHAR(100),Tariff NVARCHAR(100),
  Occupancy NVARCHAR(100),TariffPaymentMode NVARCHAR(100),
  ServicePaymentMode NVARCHAR(100));
  INSERT INTO #PropertyMailBTCChecking(Name,ChkInDt,ChkOutDt,Tariff,
  Occupancy,TariffPaymentMode,ServicePaymentMode)
  SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
  FROM WRBHBBookingPropertyAssingedGuest BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND
  ISNULL(BA.RoomShiftingFlag,0) = 0
  FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt,
  B.Tariff,B.Occupancy,B.TariffPaymentMode,B.ServicePaymentMode
  FROM #FFF AS B;
  IF EXISTS(SELECT NULL FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
  BP.PropertyId=BG.BookingPropertyId
  WHERE BG.BookingId=@Id1 AND BG.TariffPaymentMode='Bill to Company (BTC)' AND
  BP.PropertyType IN ('ExP'))
   BEGIN
    DECLARE @Single DECIMAL(27,2),@Double DECIMAL(27,2),@Triple DECIMAL(27,2);
    SELECT @Single=SingleTariff,@Double=DoubleTariff,@Triple=TripleTariff
    FROM WRBHBBookingProperty BP
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BP.BookingId=BG.BookingId AND BP.Id=BG.BookingPropertyTableId AND
    BP.PropertyId=BG.BookingPropertyId
    WHERE BG.BookingId=@Id1;
    SELECT Name,ChkInDt,ChkOutDt,
    CASE WHEN Occupancy = 'Single' THEN @Single
         WHEN Occupancy = 'Double' THEN @Double
         WHEN Occupancy = 'Triple' THEN @Triple
         ELSE Tariff END,Occupancy,TariffPaymentMode,
    ServicePaymentMode,'BTC',@AgreedTariff,@BelowTACcontent 
    FROM #PropertyMailBTCChecking;
   END
  ELSE
   BEGIN
    SELECT Name,ChkInDt,ChkOutDt,Tariff,Occupancy,TariffPaymentMode,
    ServicePaymentMode,'NOTBTC',@AgreedTariff,@BelowTACcontent 
    FROM #PropertyMailBTCChecking;
   END
  -- Dataset Table 11 eND*/  
 END
IF @Action = 'PaymentStatusBooking'
 BEGIN
  SELECT PaymentCode,Id,0 AS Tick,1 AS Chk,'Paid' AS Remarks FROM WRBHBBooking
  WHERE IsActive = 1 AND IsDeleted = 0 AND PaymentCode != 0 AND
  PaymentFlag = 0 AND Status = 'Payment';
 END
IF @Action = 'BookingCodeGeneration'
 BEGIN
  DECLARE @@Cnt INT = 0,@BookingCode BIGINT = 0;
  SET @@Cnt = (SELECT COUNT(*) FROM WRBHBBooking WHERE IsDeleted = 0 AND
  IsActive = 1 AND BookingCode != 0);
  IF @@Cnt = 0 
   BEGIN 
    SET @BookingCode = 1; 
   END
  ELSE
   BEGIN
    SET @BookingCode = (SELECT TOP 1 BookingCode + 1 FROM WRBHBBooking
    WHERE IsDeleted = 0 AND IsActive = 1 AND BookingCode != 0
    ORDER BY BookingCode DESC);
   END
  DECLARE @Status NVARCHAR(100) = '',@StatusCnt BIGINT = 0;
  SELECT @StatusCnt = TrackingNo FROM WRBHBBooking WHERE Id = @Id1;
  IF @StatusCnt = 0
   BEGIN
    SET @Status = 'Direct Booked';
   END
  ELSE
   BEGIN
    SET @Status = 'Booked';
   END
  UPDATE WRBHBBooking SET BookingCode = @BookingCode,Status = @Status,
  PaymentFlag = 1,PaymentCodeRemarks = @Str1,--ModifiedBy = @Id2,
  ModifiedDate = GETDATE() WHERE Id = @Id1;
  --
  DECLARE @PropertyType NVARCHAR(100) = '';
  SELECT @PropertyType = PropertyType FROM WRBHBBookingProperty 
  WHERE Id IN (SELECT BookingPropertyTableId FROM 
  WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id1);
  --
  IF @PropertyType = 'ExP'
   BEGIN
    DECLARE @PONoId BIGINT = 0,@PONo NVARCHAR(100) = '';
    IF EXISTS (SELECT NULL FROM WRBHBBooking WHERE PONoId != 0)
     BEGIN
      SET @PONoId = (SELECT TOP 1 PONoId+1 FROM WRBHBBooking WHERE PONoId != 0
      ORDER BY PONoId DESC);
     END
    ELSE
     BEGIN
      SET @PONoId = 1;
     END
    IF EXISTS (SELECT NULL FROM WRBHBBooking 
    WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND
    YEAR(CreatedDate) = YEAR(GETDATE()) AND PONo != '')
     BEGIN
      SELECT TOP 1 @PONo = SUBSTRING(PONo,0,13) + '0' +
      CAST(CAST(SUBSTRING(PONo,13,LEN(PONo)) AS INT) + 1 AS VARCHAR)
      FROM WRBHBBooking WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND
      YEAR(CreatedDate) = YEAR(GETDATE()) AND PONo != '' ORDER BY PONoId DESC;
     END
    ELSE
     BEGIN
      SELECT @PONo = 'HBE/' + CAST(YEAR(GETDATE()) AS VARCHAR) + '-' +
      CAST(SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),4,2) AS VARCHAR) + '/01';
     END
    UPDATE WRBHBBooking SET PONo = @PONo,PONoId = @PONoId WHERE Id = @Id1;
   END
  IF @PropertyType = 'MMT'
   BEGIN
    DECLARE @MMTPONoId BIGINT = 0,@MMTPONo NVARCHAR(100) = '';
    IF EXISTS (SELECT NULL FROM WRBHBBooking WHERE MMTPONoId != 0)
     BEGIN
      SET @MMTPONoId = (SELECT TOP 1 MMTPONoId + 1 FROM WRBHBBooking 
      WHERE MMTPONoId != 0 ORDER BY MMTPONoId DESC);
     END
    ELSE
     BEGIN
      SET @MMTPONoId = 1; 
     END
    --
    IF EXISTS (SELECT NULL FROM WRBHBBooking
    WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND 
    YEAR(CreatedDate) = YEAR(GETDATE()) AND MMTPONo != '')
     BEGIN
      SELECT TOP 1 @MMTPONo = SUBSTRING(MMTPONo,0,13) + '0' +
      CAST(CAST(SUBSTRING(MMTPONo,13,LEN(MMTPONo)) AS INT) + 1 AS VARCHAR)
      FROM WRBHBBooking WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND
      YEAR(CreatedDate) = YEAR(GETDATE()) AND MMTPONo != ''
      ORDER BY MMTPONoId DESC;
     END
    ELSE
     BEGIN
      SELECT @MMTPONo = 'MMT/' + CAST(YEAR(GETDATE()) AS VARCHAR) + '-' +
      CAST(SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),4,2) AS VARCHAR) + '/01';
     END
    --
    UPDATE WRBHBBooking SET MMTPONo = @MMTPONo,MMTPONoId = @MMTPONoId
    WHERE Id = @Id1;
   END
  SELECT @Id1;
 END
IF @Action = 'BookingCodeDeactivated'
 BEGIN
  UPDATE WRBHBBooking SET BookingCode = 0,Status = 'Payment',
  PaymentFlag = 0 WHERE Id = @Id1;
 END
END