-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingCancel_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingCancel_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:28-03-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	BOOKING GRID HELP LOAD
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BookingCancel_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Id BIGINT,@UserId BIGINT,@Remarks NVARCHAR(100))			
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

DECLARE @PROPERTYID BIGINT,@ClientId BIGINT;
DECLARE @BookingId BIGINT,@GuestId BIGINT,@Cnt BIGINT,@BookingLevel NVARCHAR(100);
CREATE TABLE #TEMPPAYMODE1(PaymentMode NVARCHAR(100),Id BIGINT)
		CREATE TABLE #TEMPPAYMODEService1(PaymentMode NVARCHAR(100),Id BIGINT)
		DECLARE @CHECKIN NVARCHAR(100),@CHECKINStr NVARCHAR(100),@GradeId BIGINT,@ClientId1 BIGINT,
		@CHECKOut NVARCHAR(100); 
		
IF @Action = 'PaymentMode'
 BEGIN
 
	  CREATE TABLE #TEMPPAYMODE(PaymentMode NVARCHAR(100),Id BIGINT)
	  --Get Property Id
	  IF @Str1='Room'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END
	  IF @Str1='Bed'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END
	  IF @Str1='Apartment'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END					
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id  
			
	  INSERT INTO #TEMPPAYMODE(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODE(PaymentMode,Id)
	  SELECT 'Bill to Client',1 
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;	  
	  
	  INSERT INTO #TEMPPAYMODE(PaymentMode,Id)
	  SELECT 'Direct' ,2
	  
	  SELECT PaymentMode as Tariff,Id FROM #TEMPPAYMODE
	  
 END
 IF @Action = 'PaymentModeService'
 BEGIN
	  CREATE TABLE #TEMPPAYMODEService(PaymentMode NVARCHAR(100),Id BIGINT)
	  
	  --Get Property Id
	  IF @Str1='Room'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END
	  IF @Str1='Bed'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END
	  IF @Str1='Apartment'
	  BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
	  END
		
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id 
	  	
	  INSERT INTO #TEMPPAYMODEService(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODEService(PaymentMode,Id)
	  SELECT 'Bill to Client' ,1
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;
	  
	  INSERT INTO #TEMPPAYMODEService(PaymentMode,Id)
	  SELECT 'Direct' ,0
	  
	  SELECT PaymentMode as Service,Id  FROM #TEMPPAYMODEService
	  
 END
IF @Action = 'BookingCode'
 BEGIN
	  CREATE TABLE #BookingCode(BookingCode NVARCHAR(100),Id BIGINT,GuestName NVARCHAR(100),
	  PropertyName NVARCHAR(100),ClientNameId NVARCHAR(100),BookingLevelId NVARCHAR(100))	
	  
	  INSERT INTO #BookingCode(BookingCode,Id,GuestName,PropertyName,ClientNameId,BookingLevelId)
	  SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,BookingLevel 
	  FROM WRBHBBooking B
	  JOIN WRBHBBookingPropertyAssingedGuest A ON A.BookingId=B.Id AND  A.IsActive=1 AND A.IsDeleted=0
	  JOIN WRBHBProperty P ON A.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.Status IN ('Direct Booked','Booked') 
	  AND BookingCode !=0 
	  
	  INSERT INTO #BookingCode(BookingCode,Id,GuestName,PropertyName,ClientNameId,BookingLevelId)
	  SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName ,BookingLevel
	  FROM WRBHBBooking B
	  JOIN WRBHBBedBookingPropertyAssingedGuest A ON A.BookingId=B.Id AND  A.IsActive=1 AND A.IsDeleted=0
	  JOIN WRBHBProperty P ON A.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.Status IN ('Direct Booked','Booked') 
	  AND BookingCode !=0
	  
	  INSERT INTO #BookingCode(BookingCode,Id,GuestName,PropertyName,ClientNameId,BookingLevelId)
	  SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,BookingLevel 
	  FROM WRBHBBooking B
	  JOIN WRBHBApartmentBookingPropertyAssingedGuest A ON A.BookingId=B.Id AND  A.IsActive=1 AND A.IsDeleted=0
	  JOIN WRBHBProperty P ON A.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.Status IN ('Direct Booked','Booked') 
	  AND BookingCode !=0
	  
	  SELECT BookingCode,Id,GuestName,PropertyName,ClientNameId as ZClientNameId,
	  BookingLevelId as ZBookingLevelId FROM #BookingCode
	  WHERE Id NOT IN(SELECT B.Id FROM WRBHBBooking B
	  JOIN WRBHBCheckInHdr CH ON CH.BookingId=B.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
	  JOIN WRBHBChechkOutHdr CO ON CO.ChkInHdrId=CH.Id AND CO.IsActive=1 AND CO.IsDeleted=0
	  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled')
	  ORDER BY Id ASC
 END
 IF @Action = 'BookingCodeCancel'
  BEGIN
   CREATE TABLE #BookingCode1(BookingCode NVARCHAR(100),Id BIGINT,
   GuestName NVARCHAR(100),PropertyName NVARCHAR(100),ClientNameId NVARCHAR(100),
   BookingLevelId NVARCHAR(100),PropertyType NVARCHAR(100));
   IF @Str1 = 'HBStay'
    BEGIN
	-- ROOM LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBBookingPropertyAssingedGuest A WITH(NOLOCK) ON A.BookingId = B.Id 
	AND A.IsActive = 1 AND A.IsDeleted = 0 AND A.CurrentStatus ='Booked'
	JOIN WRBHBProperty P ON A.BookingPropertyId = P.Id AND P.IsActive = 1 AND 
	P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Room' AND
	B.Status IN ('Direct Booked','Booked') 
	AND B.ClientId = @Id AND B.HBStay='StayCorporateHB';
	-- ROOM LEVEL MMT
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT B.BookingCode,B.Id,BG.FirstName +' '+BG.LastName,P.HotalName,
	B.ClientName,B.BookingLevel,BP.PropertyType FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId = B.Id
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
	BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
	BG.BookingPropertyId = BP.PropertyId
	LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
	P.HotalId = BG.BookingPropertyId
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BP.IsActive = 1 AND
	BP.IsDeleted = 0 AND BG.IsActive = 1 AND BG.IsDeleted = 0 AND
	P.IsActive = 1 AND P.IsDeleted = 0 AND B.BookingLevel = 'Room' AND
	B.BookingCode != 0 AND BG.CurrentStatus = 'Booked' AND
	ISNULL(B.CancelStatus,'') = '' AND 
	BP.PropertyType = 'MMT' AND BP.GetType = 'API' AND
	B.Status IN ('Direct Booked','Booked') 
	AND B.ClientId = @Id AND B.HBStay='StayCorporateHB';
	-- BED LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBBedBookingPropertyAssingedGuest A WITH(NOLOCK)ON A.BookingId = B.Id 
	AND A.IsActive = 1 AND A.IsDeleted = 0 AND A.CurrentStatus = 'Booked'
	JOIN WRBHBProperty P WITH(NOLOCK)ON A.BookingPropertyId = P.Id AND 
	P.IsActive = 1 AND P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Bed' AND
	B.Status IN ('Direct Booked','Booked') 
	AND B.ClientId = @Id AND B.HBStay='StayCorporateHB';
	-- APARTMENT LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBApartmentBookingPropertyAssingedGuest A WITH(NOLOCK)ON 
	A.BookingId = B.Id AND A.IsActive = 1 AND A.IsDeleted = 0 AND 
	A.CurrentStatus = 'Booked'
	JOIN WRBHBProperty P WITH(NOLOCK)ON A.BookingPropertyId = P.Id AND 
	P.IsActive = 1 AND P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Apartment' AND 
	B.Status IN ('Direct Booked','Booked') 
	AND B.ClientId = @Id AND B.HBStay='StayCorporateHB';
	--
	SELECT BookingCode,Id,GuestName,PropertyName,ClientNameId as ZClientNameId,
	BookingLevelId as ZBookingLevelId,PropertyType AS ZPropertyTypeId 
	FROM #BookingCode1 ORDER BY Id ASC
    END
   ELSE
    BEGIN
	-- ROOM LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBBookingPropertyAssingedGuest A WITH(NOLOCK) ON A.BookingId = B.Id 
	AND A.IsActive = 1 AND A.IsDeleted = 0 AND A.CurrentStatus ='Booked'
	JOIN WRBHBProperty P ON A.BookingPropertyId = P.Id AND P.IsActive = 1 AND 
	P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Room' AND
	B.Status IN ('Direct Booked','Booked');
	-- ROOM LEVEL MMT
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT B.BookingCode,B.Id,BG.FirstName +' '+BG.LastName,P.HotalName,
	B.ClientName,B.BookingLevel,BP.PropertyType FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId = B.Id
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
	BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
	BG.BookingPropertyId = BP.PropertyId
	LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
	P.HotalId = BG.BookingPropertyId
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BP.IsActive = 1 AND
	BP.IsDeleted = 0 AND BG.IsActive = 1 AND BG.IsDeleted = 0 AND
	P.IsActive = 1 AND P.IsDeleted = 0 AND B.BookingLevel = 'Room' AND
	B.BookingCode != 0 AND BG.CurrentStatus = 'Booked' AND
	ISNULL(B.CancelStatus,'') = '' AND 
	BP.PropertyType = 'MMT' AND BP.GetType = 'API' AND
	B.Status IN ('Direct Booked','Booked');
	-- BED LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBBedBookingPropertyAssingedGuest A WITH(NOLOCK)ON A.BookingId = B.Id 
	AND A.IsActive = 1 AND A.IsDeleted = 0 AND A.CurrentStatus = 'Booked'
	JOIN WRBHBProperty P WITH(NOLOCK)ON A.BookingPropertyId = P.Id AND 
	P.IsActive = 1 AND P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Bed' AND
	B.Status IN ('Direct Booked','Booked');
	-- APARTMENT LEVEL
	INSERT INTO #BookingCode1(BookingCode,Id,GuestName,PropertyName,ClientNameId,
	BookingLevelId,PropertyType)
	SELECT BookingCode,B.Id,FirstName +' '+LastName,P.PropertyName,ClientName,
	BookingLevel,'' FROM WRBHBBooking B
	JOIN WRBHBApartmentBookingPropertyAssingedGuest A WITH(NOLOCK)ON 
	A.BookingId = B.Id AND A.IsActive = 1 AND A.IsDeleted = 0 AND 
	A.CurrentStatus = 'Booked'
	JOIN WRBHBProperty P WITH(NOLOCK)ON A.BookingPropertyId = P.Id AND 
	P.IsActive = 1 AND P.IsDeleted = 0
	WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BookingCode != 0 AND
	ISNULL(B.CancelStatus,'') != 'Canceled' AND B.BookingLevel = 'Apartment' AND 
	B.Status IN ('Direct Booked','Booked');
	--
	SELECT BookingCode,Id,GuestName,PropertyName,ClientNameId as ZClientNameId,
	BookingLevelId as ZBookingLevelId,PropertyType AS ZPropertyTypeId 
	FROM #BookingCode1 ORDER BY Id ASC
    END
  END
 IF @Action = 'BookingGuestMMT'
  BEGIN
   -- Table 0
   SELECT BP.PropertyName,'' AS CheckIn FROM WRBHBBookingProperty BP
   LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
   BG.BookingId = BP.BookingId AND BG.BookingPropertyTableId = BP.Id AND
   BG.BookingPropertyId = BP.PropertyId
   WHERE BP.BookingId = @Id;
   -- Table 1
   SELECT FirstName,LastName,Occupancy,RoomType,Tariff,
   CONVERT(NVARCHAR(100),ChkInDt,103) AS ChkInDt ,
   CONVERT(NVARCHAR(100),ChkOutDt,103) AS ChkOutDt,TariffPaymentMode,
   ServicePaymentMode,GuestId,RoomId,0 AS BookingPrTariffPaymentModeopertyId,
   0 AS Id,0 AS DateDiffs,0 AS Tick
   FROM WRBHBBookingPropertyAssingedGuest
   WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @Id;
  END  
 IF @Action = 'BookingGuest'
 BEGIN
		
		
		SELECT @CHECKIN=ISNULL(Id,0) FROM WRBHBCheckInHdr WHERE BookingId=@Id;
		
		SELECT @CHECKOut=ISNULL(Id,0) FROM WRBHBChechkOutHdr WHERE BookingId=@Id;
		
		SELECT top 1 @GradeId=GradeId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id AND GradeId!=0
		
		--SELECT GradeId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id 
		
		IF ISNULL(@CHECKIN,0)=0
		SELECT @CHECKINStr='Booking'
		ELSE
		SELECT @CHECKINStr='CheckIn'
		
		IF ISNULL(@CHECKOut,0)!=0
		SELECT @CHECKINStr='CheckOut'
		
		IF @Str1='Room'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,
			RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND CurrentStatus in ('Booked','CheckIn')
		END	
		IF @Str1='Bed'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,'Single'Occupancy,BedType RoomType,Tariff,
			RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBBedBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND CurrentStatus in ('Booked','CheckIn')
		
		END
		IF @Str1='Apartment'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,'Double'Occupancy,ApartmentType RoomType,Tariff,
			ApartmentId RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBApartmentBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id AND CurrentStatus in ('Booked','CheckIn')
		
		END
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id  
		
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Bill to Client',1 
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;	  
	  
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Direct' ,2
	  
	  --table 2
	  SELECT PaymentMode as Tariff,Id FROM #TEMPPAYMODE1	 
		
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id 
	  	
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Bill to Client' ,1
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;
	  
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Direct' ,0
	  --table 3
      SELECT PaymentMode Service,Id FROM #TEMPPAYMODEService1
      --table 4
      SELECT ISNULL(@ClientId,0) ClientId ,ISNULL(@GradeId,0) GradeId
     --table 5
     SELECT BookingCode,BookingLevel,ISNULL(C.ClientName,'') ClientName FROM WRBHBBooking B
     LEFT OUTER JOIN dbo.WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
	 WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.Id=@Id
	  
 END
 IF @Action = 'BookingGuestModified'
 BEGIN
				
		SELECT @CHECKIN=ISNULL(Id,0) FROM WRBHBCheckInHdr WHERE BookingId=@Id;
		
		SELECT @CHECKOut=ISNULL(Id,0) FROM WRBHBChechkOutHdr WHERE BookingId=@Id;
		
		SELECT top 1 @GradeId=GradeId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id AND GradeId!=0
		
		--SELECT GradeId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id 
		
		IF ISNULL(@CHECKIN,0)=0
		SELECT @CHECKINStr='Booking'
		ELSE
		SELECT @CHECKINStr='CheckIn'
		
		IF ISNULL(@CHECKOut,0)!=0
		SELECT @CHECKINStr='CheckOut'
		
		IF @Str1='Room'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,
			RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
		END	
		IF @Str1='Bed'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,'Single'Occupancy,BedType RoomType,Tariff,
			RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBBedBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
		
		END
		IF @Str1='Apartment'
		BEGIN
			SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
			--table 0
			SELECT PropertyName,@CHECKINStr CheckIn FROM WRBHBProperty 
			WHERE Id=@PROPERTYID 
			--table 1
			SELECT '' TariffId,'' ServiceId,'' DateDiffs,0 AS Tick,EmpCode,FirstName,LastName,GuestId,'Double'Occupancy,ApartmentType RoomType,Tariff,
			ApartmentId RoomId,BookingPropertyId,BookingPropertyTableId,SSPId,Id,ServicePaymentMode,
			TariffPaymentMode,CONVERT(NVARCHAR(100),ChkInDt,103) ChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)ChkOutDt,
			ExpectChkInTime,CONVERT(NVARCHAR(100),ChkInDt,103) OldChkInDt ,CONVERT(NVARCHAR(100),ChkOutDt,103)OldChkOutDt ,
			ServicePaymentMode OldServiceMode,TariffPaymentMode OldTariffMode,FirstName OldFirstname,LastName OldLastName,
			0 DateChange,GuestId OldGuestId
			FROM dbo.WRBHBApartmentBookingPropertyAssingedGuest 
			WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id 
		
		END
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id  
		
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Bill to Client',1 
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;	  
	  
	  INSERT INTO #TEMPPAYMODE1(PaymentMode,Id)
	  SELECT 'Direct' ,2
	  
	  --table 2
	  SELECT PaymentMode as Tariff,Id FROM #TEMPPAYMODE1	 
		
      --Get Client Id
	  SELECT @ClientId=ClientId FROM WRBHBBooking 
	  WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id 
	  	
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Bill to Company (BTC)' ,0
	  FROM dbo.WRBHBClientManagement 
	  WHERE Id=@ClientId AND IsActive=1 AND IsDeleted=0
	  AND BTC=1;
	  
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Bill to Client' ,1
	  FROM dbo.WRBHBContractClientPref_Details 
	  WHERE PropertyId=@PROPERTYID AND IsActive=1 AND IsDeleted=0;
	  
	  INSERT INTO #TEMPPAYMODEService1(PaymentMode,Id)
	  SELECT 'Direct' ,0
	  --table 3
      SELECT PaymentMode Service,Id FROM #TEMPPAYMODEService1
      --table 4
      SELECT ISNULL(@ClientId,0) ClientId ,ISNULL(@GradeId,0) GradeId
     --table 5
     SELECT BookingCode,BookingLevel,ISNULL(C.ClientName,'') ClientName FROM WRBHBBooking B
     LEFT OUTER JOIN dbo.WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
	 WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.Id=@Id
	  
 END
 IF @Action = 'GuestData'
 BEGIN
	  IF @Id!=0
	  BEGIN	
		  SELECT FirstName,LastName,Id FROM WRBHBClientManagementAddClientGuest WHERE
		  CltmgntId=CAST(@Str1 AS BIGINT) AND GradeId=@Id AND IsDeleted=0 and IsActive=1 
      END
      ELSE
      BEGIN
		SELECT FirstName,LastName,Id FROM WRBHBClientManagementAddClientGuest WHERE
		CltmgntId=CAST(@Str1 AS BIGINT) AND  IsDeleted=0 and IsActive=1 
      END
 END
 IF @Action = 'BookingDelete'
 BEGIN
		DECLARE @BookingLevel1 nvarchar(100),@Cnt1 INT; 	
		SELECT @BookingLevel1=BookingLevel FROM WRBHBBooking WHERE Id=@Id
		
		
		IF @BookingLevel1='Room'
		BEGIN
			UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
			WHERE BookingId=@Id; 
			
			UPDATE WRBHBBookingPropertyAssingedGuest SET IsDeleted=1 ,IsActive=0, 
			ModifiedBy=@UserId,ModifiedDate=GETDATE(),CancelRemarks=@Remarks,
			CancelModifiedFlag=0,CurrentStatus='Canceled'
			WHERE BookingId=@Id AND CurrentStatus NOT IN('CheckOut','CheckIn'); 
			
			SELECT @Cnt1=COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
			WHERE BookingId=@Id AND IsDeleted=0 AND IsActive=1
		END
		IF @BookingLevel1='Bed'
		BEGIN
			UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
			WHERE BookingId=@Id;  
		
			UPDATE dbo.WRBHBBedBookingPropertyAssingedGuest SET IsDeleted=1 ,
			IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelRemarks=@Remarks,CancelModifiedFlag=0,
			CurrentStatus='Canceled'
			WHERE  BookingId=@Id AND CurrentStatus NOT IN('CheckOut','CheckIn');   
			
			SELECT @Cnt1=COUNT(*) FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE BookingId=@Id AND IsDeleted=0 AND IsActive=1
		END
		IF @BookingLevel1='Apartment'
		BEGIN
			UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
			WHERE BookingId=@Id; 
		
			UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsDeleted=1,
			IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelRemarks=@Remarks,CancelModifiedFlag=0,
			CurrentStatus='Canceled'
			WHERE BookingId=@Id AND CurrentStatus NOT IN('CheckOut','CheckIn'); 
			
			SELECT @Cnt1=COUNT(*) FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE BookingId=@Id AND IsDeleted=0 AND IsActive=1
		END
		 
		
		IF @Cnt1=0
		BEGIN
			UPDATE WRBHBBooking SET  ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelStatus='Canceled',CancelRemarks=@Remarks		 
			WHERE Id=@Id
		END
		
		
		 
		
		--TABEL 0
		SELECT B.BookingCode,U.Email,B.CancelStatus,b.CancelRemarks,B.ClientName,CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,
		BookingLevel,EmailtoGuest
		FROM WRBHBBooking B
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UserId
		WHERE B.Id=@Id
		
		--TABEL 1
		SELECT Logo FROM dbo.WRBHBCompanyMaster;
		
		SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
		WHERE  BookingId=@Id 
		
		--TABEL 2
		IF ISNULL(@PROPERTYID,0)=0
		BEGIN
			SELECT '' AS PropertyName
		END
		ELSE
		BEGIN		
			SELECT ISNULL(PropertyName,'') FROM WRBHBProperty 
			WHERE Id=@PROPERTYID
		END
		 -- dataset table 3
		 SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
		 CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@Id);
	 
		-- Dataset Table 4
		SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@Id;
     
		-- dataset table 5
		SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@Id;
		--IsDeleted=1 ,IsActive=0,
		
		--dataset table 6
		SELECT ClientLogo FROM dbo.WRBHBClientManagement WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B
		JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId 
		AND P.IsActive=1 AND P.IsDeleted=0
		WHERE B.Id=@BookingId)
 END
 IF @Action = 'BookingGuestRoomDelete'
 BEGIN		
		
		
		SELECT @BookingId=BookingId,@GuestId=GuestId FROM WRBHBBookingPropertyAssingedGuest	WHERE Id=@Id
			
		UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
		WHERE BookingId=@BookingId AND GuestId=@GuestId 
		
		UPDATE WRBHBBookingPropertyAssingedGuest SET IsDeleted=1 ,IsActive=0, 
		ModifiedBy=@UserId,ModifiedDate=GETDATE(),CancelRemarks=@Remarks,
		CancelModifiedFlag=0,CurrentStatus='Canceled'
		WHERE Id=@Id AND BookingId=@BookingId; 
		
		SELECT @Cnt=COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
		WHERE BookingId=@BookingId AND IsDeleted=0 AND IsActive=1
		
		IF @Cnt=0
		BEGIN
			UPDATE WRBHBBooking SET  ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelStatus='Canceled',CancelRemarks=@Remarks		 
			WHERE Id=@BookingId
		END
		-- dataset table 0
		SELECT B.BookingCode,U.Email,ISNULL(B.CancelStatus,'')CancelStatus,b.CancelRemarks,B.ClientName,CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,
		BookingLevel,EmailtoGuest
		FROM WRBHBBooking B
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UserId
		WHERE B.Id=@BookingId
		
		-- dataset table 1
		SELECT Logo FROM dbo.WRBHBCompanyMaster;
		
		
		SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
		WHERE  BookingId=@BookingId 
		-- dataset table 2
		IF ISNULL(@PROPERTYID,0)=0
		BEGIN
			SELECT '' AS PropertyName
		END
		ELSE
		BEGIN		
			SELECT ISNULL(PropertyName,'') FROM WRBHBProperty 
			WHERE Id=@PROPERTYID
		END
		
		 -- dataset table 3
		 SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
		 CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);
	 
		-- Dataset Table 4
		SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@BookingId;
     
		-- dataset table 5
		SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@BookingId;
		
		--dataset table 6
		SELECT ClientLogo FROM dbo.WRBHBClientManagement WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B
		JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId 
		AND P.IsActive=1 AND P.IsDeleted=0
		WHERE B.Id=@BookingId)
 END
IF @Action='BookingGuestBedDelete'
BEGIN
		SELECT @BookingId=BookingId,@GuestId=GuestId FROM WRBHBBedBookingPropertyAssingedGuest	WHERE Id=@Id
		
		UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
		WHERE BookingId=@BookingId AND GuestId=@GuestId 
		
		UPDATE dbo.WRBHBBedBookingPropertyAssingedGuest SET IsDeleted=1 ,
		IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE(),
		CancelRemarks=@Remarks,CancelModifiedFlag=0,
		CurrentStatus='Canceled'
		WHERE Id=@Id AND BookingId=@BookingId;  
		
		SELECT @Cnt=COUNT(*) FROM WRBHBBedBookingPropertyAssingedGuest
		WHERE BookingId=@BookingId AND IsDeleted=0 AND IsActive=1
		
		
		
		IF @Cnt=0
		BEGIN
			UPDATE WRBHBBooking SET  ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelStatus='Canceled',CancelRemarks=@Remarks	 
			WHERE Id=@BookingId
		END
		-- dataset table 0
		SELECT B.BookingCode,U.Email,B.CancelStatus,b.CancelRemarks,B.ClientName,CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,
		BookingLevel,EmailtoGuest
		FROM WRBHBBooking B
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UserId
		WHERE B.Id=@BookingId
		
		-- dataset table 1
		SELECT Logo FROM dbo.WRBHBCompanyMaster;
		
		
		SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
		WHERE  BookingId=@BookingId 
		-- dataset table 2
		IF ISNULL(@PROPERTYID,0)=0
		BEGIN
			SELECT '' AS PropertyName
		END
		ELSE
		BEGIN		
			SELECT ISNULL(PropertyName,'') FROM WRBHBProperty 
			WHERE Id=@PROPERTYID
		END
		
		 -- dataset table 3
		 SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
		 CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);
	 
		-- Dataset Table 4
		SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@BookingId;
     
		-- dataset table 5
		SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@BookingId;
		
		--dataset table 6
		SELECT ClientLogo FROM dbo.WRBHBClientManagement WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B
		JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId 
		AND P.IsActive=1 AND P.IsDeleted=0
		WHERE B.Id=@BookingId)
END
IF @Action='BookingGuestApartmentDelete'
BEGIN
		SELECT @BookingId=BookingId,@GuestId=GuestId FROM WRBHBApartmentBookingPropertyAssingedGuest	WHERE Id=@Id
		
		UPDATE dbo.WRBHBBookingGuestDetails SET IsDeleted=1 ,IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE()
		WHERE BookingId=@BookingId AND GuestId=@GuestId 
		
		UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsDeleted=1,
		IsActive=0, ModifiedBy=@UserId,ModifiedDate=GETDATE(),
		CancelRemarks=@Remarks,CancelModifiedFlag=0,
		CurrentStatus='Canceled'
		WHERE Id=@Id AND BookingId=@BookingId;  
		
		SELECT @Cnt=COUNT(*) FROM WRBHBApartmentBookingPropertyAssingedGuest
		WHERE BookingId=@BookingId AND IsDeleted=0 AND IsActive=1
		
		IF @Cnt=0
		BEGIN
			UPDATE WRBHBBooking SET  ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			CancelStatus='Canceled',CancelRemarks=@Remarks		 
			WHERE Id=@BookingId
		END
		-- dataset table 0
		SELECT B.BookingCode,U.Email,B.CancelStatus,b.CancelRemarks,B.ClientName,
		CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest
		FROM WRBHBBooking B
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UserId
		WHERE B.Id=@BookingId
		
		-- dataset table 1
		SELECT Logo FROM dbo.WRBHBCompanyMaster;
		
		
		SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
		WHERE  BookingId=@BookingId 
		
		-- dataset table 2
		IF ISNULL(@PROPERTYID,0)=0
		BEGIN
			SELECT '' AS PropertyName
		END
		ELSE
		BEGIN		
			SELECT ISNULL(PropertyName,'') FROM WRBHBProperty 
			WHERE Id=@PROPERTYID
		END
		
		 -- dataset table 3
		 SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
		 CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);
	 
		-- Dataset Table 4
		SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@BookingId;
     
		-- dataset table 5
		SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@BookingId;
		
		--dataset table 6
		SELECT ClientLogo FROM dbo.WRBHBClientManagement WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B
		JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId 
		AND P.IsActive=1 AND P.IsDeleted=0
		WHERE B.Id=@BookingId)
END
 IF @Action = 'BookingCancelMMT'
  BEGIN
   SELECT BookHotelReservationIdvalue FROM WRBHBBookingProperty 
   WHERE BookingId = @Id AND Id IN (SELECT BookingPropertyTableId FROM 
   WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id);
  END
 IF @Action = 'MMTBookingCancelDataUpdate'
  BEGIN
   UPDATE WRBHBBookingProperty SET TotalCancelAmount = @Str1,
   CancellationMarkup = @Remarks,Errorcode = '',Description1 = '' 
   WHERE BookingId = @Id AND 
   Id IN (SELECT BookingPropertyTableId FROM 
   WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id);
  END
 IF @Action = 'MMTBookingCancelDataUpdateError'
  BEGIN
   UPDATE WRBHBBookingProperty SET Errorcode = @Str1,
   Description1 = @Remarks WHERE BookingId = @Id AND 
   Id IN (SELECT BookingPropertyTableId FROM 
   WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id);
  END
 IF @Action = 'MMTBookingCancelUpdate'
  BEGIN
   UPDATE WRBHBBooking SET CancelStatus = 'Canceled',
   CancelRemarks = @Remarks,ModifiedBy = @UserId,ModifiedDate = GETDATE()
   WHERE Id = @Id;
   --
   UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 1,
   ModifiedBy = @UserId,ModifiedDate = GETDATE(),CurrentStatus = 'Canceled' 
   WHERE BookingId = @Id;
   -- Mail data's
   SET @PROPERTYID = (SELECT TOP 1 BookingPropertyId 
   FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @Id);
   -- TABLE 0
   SELECT CAST(EmailtoGuest AS INT),ClientBookerEmail,BookingCode,
   CONVERT(VARCHAR(100),BookedDt,103),ClientName,BookingLevel
   FROM WRBHBBooking WHERE Id = @Id;
   -- TABLE 1
   SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId = @Id AND
   EmailId != '';
   -- TABLE 2
   SELECT Email FROM WRBHBUser WHERE Id = @UserId;
   -- TABLE 3
   SELECT Logo FROM WRBHBCompanyMaster WHERE IsActive = 1 AND IsDeleted = 0
   ORDER BY Id DESC;
   -- TABLE 4
   SELECT PropertyName FROM WRBHBBookingProperty WHERE Id IN 
   (SELECT BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
   WHERE BookingId = @Id);
   -- TABLE 5
   CREATE TABLE #MAILGUESTDATA(Name NVARCHAR(1000),ChkInDt DATE,ChkOutDt DATE);
   INSERT INTO #MAILGUESTDATA(Name,ChkInDt,ChkOutDt)
   SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
   FROM WRBHBBookingPropertyAssingedGuest BA 
   WHERE BA.BookingId = @Id AND BA.RoomCaptured=B.RoomCaptured
   FOR XML PATH('')),1,1,'') AS Name,B.ChkInDt,B.ChkOutDt
   FROM WRBHBBookingPropertyAssingedGuest AS B
   WHERE B.BookingId = @Id;
   --
   SELECT Name,CONVERT(VARCHAR(100),ChkInDt,103),
   CONVERT(VARCHAR(100),ChkOutDt,103),
   DATEDIFF(DAY,ChkInDt,ChkOutDt) FROM #MAILGUESTDATA;  
  END
 IF @Action = 'MMTCancelSuccess'
  BEGIN
   IF @Str1 = 'true'
    BEGIN
     SELECT 'Yes' AS Success,'' AS Msg;
    END
   IF @Str1 = 'false' AND @Id = 0
    BEGIN
     SELECT 'No' AS Success,'Booking is not Canceled. URL is Error.' AS Msg;
    END
   IF @Str1 = 'false' AND @Id != 0
    BEGIN
     SELECT 'No' AS Success,Description1 AS Msg FROM WRBHBBookingProperty 
     WHERE BookingId = @Id AND
     Id IN (SELECT BookingPropertyTableId FROM WRBHBBookingPropertyAssingedGuest 
     WHERE BookingId = @Id);
    END
  END
 IF @Action = 'ClientLoad'
  BEGIN
  --set @UserId = 31;
   -- MasterClient,Client
  DECLARE @TmpStr NVARCHAR(100) = '';
  SELECT TOP 1 @TmpStr = Designation,@ClientId = ClientId FROM WrbhbTravelDesk 
  WHERE IsActive = 1 AND IsDeleted = 0 AND Id = @UserId;
  SELECT @TmpStr AS TmpStr;  
  IF @TmpStr = 'MasterClient'
   BEGIN
    -- Client
    SELECT C.ClientName,C.BCity AS ClientPlace,C.Id
    FROM WRBHBClientManagement C WHERE C.IsDeleted = 0 AND C.IsActive = 1 AND
    C.MasterClientId = @ClientId ORDER BY C.ClientName ASC;
   END
  IF @TmpStr = 'Client'
   BEGIN
    SELECT ClientName,Id FROM WRBHBClientManagement 
    WHERE Id = @ClientId;
   END
  END
END
	 