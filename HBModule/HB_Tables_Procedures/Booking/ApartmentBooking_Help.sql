-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ApartmentBooking_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ApartmentBooking_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:2-Jun-2014
-- Description:	BOOKING
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_ApartmentBooking_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'Apartment_Property'
 BEGIN
  IF @Id2 = 123
   BEGIN
    UPDATE WRBHBBooking SET IsActive = 0,IsDeleted = 1 WHERE Id=@Id1;
    UPDATE WRBHBBookingGuestDetails SET IsActive = 0,IsDeleted = 1 
    WHERE BookingId=@Id1;
    UPDATE WRBHBApartmentBookingProperty SET IsActive = 0,IsDeleted = 1 
    WHERE BookingId=@Id1;
    UPDATE WRBHBApartmentBookingPropertyAssingedGuest 
    SET IsActive = 0,IsDeleted = 1 WHERE BookingId=@Id1;    
   END
  -- Existing Begin
  CREATE TABLE #BookedApartment(ApartmentId BIGINT,BookingLevel NVARCHAR(100));
  -- Booked Room Begin
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'ROOM' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId = P.Id
  WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND P.IsActive = 1 AND 
  P.IsDeleted = 0 AND CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId = @CityId GROUP BY PG.RoomId);
  -- 
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'ROOM' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId = P.Id
  WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND P.IsActive = 1 AND 
  P.IsDeleted = 0 AND 
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId);
  -- 
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'ROOM' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId);
  -- 
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'ROOM' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId GROUP BY PG.RoomId);
  -- Room Booked Data END  
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'BED' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG 
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId != 0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId = @CityId);
  --
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'BED' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG 
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId != 0 AND 
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId);
  --
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'BED' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG 
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId != 0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId);
  -- 
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT ApartmentId,'BED' FROM WRBHBPropertyRooms WHERE Id IN 
  (SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG 
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId != 0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId);
  -- Bed Booked Data END  
  -- Apartment Booked Data BEGIN
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT PG.ApartmentId,'APARTMENT' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId
  GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT PG.ApartmentId,'APARTMENT' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId
  GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT PG.ApartmentId,'APARTMENT' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  -- 
  INSERT INTO #BookedApartment(ApartmentId,BookingLevel)
  SELECT PG.ApartmentId,'APARTMENT' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId
  GROUP BY PG.ApartmentId;
  -- Apartment Booked Data END
  -- Existing End
  CREATE TABLE #ApartmentNonDedandInternalandDdp(PropertyId BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),Tariff DECIMAL(27,2),
  Per BIT,Rs BIT,DiscountAllowed DECIMAL(27,2),
  SellableApartmentType NVARCHAR(100));
 -- Dedicated Begin
  -- In Dedicated Room Getting Apartment
  CREATE TABLE #Dedicated(ApartmentId BIGINT)
  INSERT INTO #Dedicated(ApartmentId)
  SELECT ApartmentId FROM WRBHBPropertyRooms WHERE Id IN
  (SELECT T.RoomId FROM WRBHBContractManagementTariffAppartment T
  WHERE T.IsActive=1 AND T.IsDeleted=0 AND T.RoomId != 0);
  -- Dedicated Apartment Data
  
  INSERT INTO #Dedicated(ApartmentId)
  SELECT ApartmentId FROM WRBHBContractManagementAppartment 
  WHERE IsActive=1 AND IsDeleted=0 AND ApartmentId != 0;
  -- Avaliable Dedicated Apartment
  INSERT INTO #ApartmentNonDedandInternalandDdp(PropertyId,GetType,
  PropertyType,Tariff,Per,Rs,DiscountAllowed,SellableApartmentType)
  SELECT P.Id,'Contract','DdP',0,0,0,0,'' FROM WRBHBProperty P 
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.ApartmentId=A.Id AND R.PropertyId=P.Id  
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND  
  A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND 
  A.IsDeleted=0 AND A.Status = 'Active' AND R.IsActive=1 AND 
  R.IsDeleted=0 AND R.RoomStatus='Active' AND
  A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
  LEFT OUTER JOIN WRBHBContractManagementAppartment D
  WITH(NOLOCK)ON D.ContractId=H.Id
  WHERE D.IsActive = 1 AND D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND
  H.ContractType=' Dedicated Contracts ' AND H.ClientId = @ClientId) AND
  A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
  GROUP BY P.Id;
-- Dedicated End
-- Non Dedicated Begin
 
  -- Get Non Dedicated Apartment Data 
  INSERT INTO #ApartmentNonDedandInternalandDdp(PropertyId,GetType,
  PropertyType,Tariff,Per,Rs,DiscountAllowed,SellableApartmentType)
  SELECT D.PropertyId,'Contract','InP',D.ApartTarif,0,0,0,'' 
  FROM WRBHBContractNonDedicated H
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
  D.NondedContractId=H.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=D.PropertyId
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.ApartmentId=A.Id AND R.PropertyId=P.Id
  WHERE H.IsDeleted=0 AND H.IsActive=1 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND P.IsActive = 1 AND P.IsDeleted = 0 AND 
  P.Category='Internal Property' AND A.SellableApartmentType != 'HUB' AND 
  A.IsActive=1 AND A.IsDeleted=0 AND A.Status = 'Active' AND 
  R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active' AND
  H.ClientId=@ClientId AND P.CityId=@CityId AND
  A.Id NOT IN (SELECT ApartmentId FROM #Dedicated) AND
  A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
  GROUP BY D.PropertyId,D.ApartTarif;
-- Non Dedicated End
-- Internal Property Begin 
  -- Get Internal Property Data
  INSERT INTO #ApartmentNonDedandInternalandDdp(PropertyId,GetType,
  PropertyType,Tariff,Per,Rs,DiscountAllowed,SellableApartmentType)
  SELECT P.Id,'Property','InP',A.RackTariff,A.DiscountModePer,
  A.DiscountModeRS,A.DiscountAllowed,A.SellableApartmentType 
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.ApartmentId=A.Id AND R.PropertyId=P.Id 
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND P.Category='Internal Property' AND 
  A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType != 'HUB' AND 
  A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
  R.RoomStatus='Active' AND
  P.Id NOT IN (SELECT D.PropertyId FROM WRBHBContractNonDedicated H
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
  D.NondedContractId=H.Id WHERE H.IsActive=1 AND H.IsDeleted=0 AND 
  D.IsActive=1 AND D.IsDeleted=0 AND H.ClientId=@ClientId 
  AND D.PropertyId NOT IN (SELECT PropertyId 
  FROM #ApartmentNonDedandInternalandDdp WHERE GetType='Contract' AND 
  PropertyType='InP' AND Tariff = 0)) 
  AND P.CityId=@CityId AND 
  A.Id NOT IN (SELECT ApartmentId FROM #Dedicated) AND
  A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
  GROUP BY P.Id,A.RackTariff,A.DiscountModePer,A.DiscountModeRS,
  A.DiscountAllowed,A.SellableApartmentType;
-- Internal Property End
-- Delete From Agreed Tariff Zero in ND Property
  DELETE FROM #ApartmentNonDedandInternalandDdp 
  WHERE GetType='Contract' AND PropertyType='InP' AND Tariff = 0;
  -- Final Select
  SELECT CASE WHEN A.SellableApartmentType != '' THEN
  P.PropertyName+' - '+A.SellableApartmentType
  ELSE P.PropertyName END AS PropertyName,
  A.PropertyId,A.GetType,A.PropertyType,A.Tariff,'' AS Discount,
  A.Tariff AS DiscountedTariff,A.Per,A.Rs,A.DiscountAllowed,
  ISNULL(P.Phone,'') AS Phone,ISNULL(P.Email,'') AS Email,L.Locality,
  L.Id AS LocalityId,0 AS Tick,1 AS Chk,0 AS Id,
  CASE WHEN T.PropertyType = '1 Star' THEN '1'
       WHEN T.PropertyType = '2 Star' THEN '2'
       WHEN T.PropertyType = '3 Star' THEN '3'
       WHEN T.PropertyType = '4 Star' THEN '4'
       WHEN T.PropertyType = '5 Star' THEN '5'
       WHEN T.PropertyType = '6 Star' THEN '6'
       WHEN T.PropertyType = '7 Star' THEN '7'
       WHEN T.PropertyType = '7+ Star' THEN '7+'
       WHEN T.PropertyType = 'Serviced Appartments' THEN 'S A'
       ELSE T.PropertyType END AS StarRating
  FROM #ApartmentNonDedandInternalandDdp A
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=A.PropertyId
  LEFT OUTER JOIN WRBHBPropertyApartment PA WITH(NOLOCK)ON
  PA.PropertyId=A.PropertyId
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
  R.ApartmentId=PA.Id AND R.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId
  LEFT OUTER JOIN WRBHBPropertyType T WITH(NOLOCK)ON T.Id=P.PropertyType
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND PA.IsActive=1 AND 
  PA.IsDeleted=0 AND PA.SellableApartmentType != 'HUB' AND
  PA.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
  R.RoomStatus='Active'
  GROUP BY P.PropertyName,A.PropertyId,A.GetType,A.PropertyType,A.Tariff,
  A.Tariff,A.Per,A.Rs,A.DiscountAllowed,P.Phone,P.Email,L.Locality,L.Id,
  T.PropertyType,A.SellableApartmentType;  
 END
IF @Action = 'Apartment_Tab2_to_Tab3_Dtls'
 BEGIN
  SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1);
  SET @CityId=(SELECT CityId FROM WRBHBBooking WHERE Id=@Id1);
  SET @PropertyId=(SELECT TOP 1 PropertyId FROM WRBHBApartmentBookingProperty 
  WHERE BookingId=@Id1);
  DECLARE @PropertyType NVARCHAR(100),@Tariff DECIMAL(27,2);
  DECLARE @RackTariff DECIMAL(27,2);
  DECLARE @GetType NVARCHAR(100) = '';
  SELECT TOP 1 @PropertyType = PropertyType,@GetType = GetType
  FROM WRBHBApartmentBookingProperty WHERE BookingId=@Id1;
  SET @Tariff=(SELECT TOP 1 DiscountedTariff 
  FROM WRBHBApartmentBookingProperty WHERE BookingId=@Id1);
  SET @RackTariff=(SELECT TOP 1 Tariff 
  FROM WRBHBApartmentBookingProperty WHERE BookingId=@Id1);
  --
	-- Apartment Booked Data BEGIN
	CREATE TABLE #BokedApartment(ApartmentId BIGINT,BookingLevel NVARCHAR(100));
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel)    
	SELECT PG.ApartmentId,'APARTMENT' 
	FROM WRBHBApartmentBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
	PG.BookingPropertyId=@PropertyId
	GROUP BY PG.ApartmentId;
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel)    
	SELECT PG.ApartmentId,'APARTMENT' 
	FROM WRBHBApartmentBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	/*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
	CONVERT(DATE,@ChkOutDt,103) AND */	
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
	PG.BookingPropertyId=@PropertyId
	GROUP BY PG.ApartmentId;
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel)    
	SELECT PG.ApartmentId,'APARTMENT' 
	FROM WRBHBApartmentBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel)    
	SELECT PG.ApartmentId,'APARTMENT' 
	FROM WRBHBApartmentBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	/*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
	PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND*/
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
	CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
	CAST(@ChkInDt AS DATETIME) AND
	CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
	CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
	GROUP BY PG.ApartmentId;
	-- Apartment Booked Data END
	-- Room Booked Data BEGIN
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'ROOM' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT RoomId FROM WRBHBBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND    
    PG.BookingPropertyId=@PropertyId);
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'ROOM' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT RoomId FROM WRBHBBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId);
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'ROOM' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT RoomId FROM WRBHBBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId);
	-- 
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'ROOM' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT RoomId FROM WRBHBBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
	CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
	CAST(@ChkInDt AS DATETIME) AND
	CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
	CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId);
	-- Room Booked Data END
	-- Bed Booked Data BEGIN
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'BED' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId);
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'BED' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId);
	--
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'BED' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId);
	-- 
	INSERT INTO #BokedApartment(ApartmentId,BookingLevel) 
	SELECT R.ApartmentId,'BED' FROM WRBHBPropertyRooms R WHERE Id IN
	(SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
	WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
	CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
	CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
	CAST(@ChkInDt AS DATETIME) AND
	CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
	CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId);
	-- Bed Booked Data END
	-- In Dedicated Room Getting Apartment
  CREATE TABLE #Ded(ApartmentId BIGINT)
  INSERT INTO #Ded(ApartmentId)
  SELECT ApartmentId FROM WRBHBPropertyRooms WHERE Id IN (
  SELECT T.RoomId FROM WRBHBContractManagementTariffAppartment T
  WHERE T.IsActive=1 AND T.IsDeleted=0 AND T.RoomId != 0);
  -- Dedicated Apartment Data
  
  INSERT INTO #Ded(ApartmentId)
  SELECT ApartmentId FROM WRBHBContractManagementAppartment 
  WHERE IsActive=1 AND IsDeleted=0 AND ApartmentId != 0;
 -- Booking Property Data
  SELECT TOP 1 PropertyType+' - '+PropertyName AS label,PropertyId,Id,
  PropertyType FROM WRBHBApartmentBookingProperty WHERE BookingId=@Id1;
  -- Avaliable Apartments
  IF @PropertyType = 'DdP'
   BEGIN    
    -- Avaliable Dedicated Apartment    
    CREATE TABLE #Tabl(ApartmentId BIGINT);
    INSERT INTO #Tabl(ApartmentId)
    SELECT D.ApartmentId FROM WRBHBContractManagement H
    LEFT OUTER JOIN WRBHBContractManagementAppartment D
    WITH(NOLOCK)ON D.ContractId=H.Id
    WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
    D.IsDeleted=0 AND H.ClientId=@ClientId AND
    H.ContractType=' Dedicated Contracts ' AND
    D.ApartmentId NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
    D.PropertyId=@PropertyId; 
    --
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+A.SellableApartmentType AS label,
    A.Id AS ApartmentId,@Tariff AS Tariff FROM WRBHBPropertyBlocks B
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
    A.BlockId=B.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
    R.ApartmentId=A.Id
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND A.IsActive=1 AND 
    A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
    A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
    R.RoomStatus='Active' AND 
    A.Id IN (SELECT ApartmentId FROM #Tabl)
    GROUP BY B.BlockName,A.ApartmentNo,A.SellableApartmentType,A.Id
    ORDER BY B.BlockName,A.ApartmentNo;
   END
  IF @PropertyType = 'InP' AND @GetType = 'Property' 
   BEGIN
    
    -- Avaliable Apartment
    SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+A.SellableApartmentType AS label,
    A.Id AS ApartmentId,@Tariff AS Tariff FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
    A.PropertyId=P.Id AND A.BlockId=PB.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId = A.Id 
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
    PB.IsDeleted=0 AND P.Category='Internal Property' AND 
    A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND 
    A.IsDeleted=0 AND A.Status='Active' AND
    R.IsDeleted = 0 AND R.IsActive = 1 AND R.RoomStatus = 'Active' AND
    P.Id=@PropertyId AND A.RackTariff=@RackTariff AND
    A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
    A.Id NOT IN (SELECT ApartmentId FROM #Ded)
    GROUP BY PB.BlockName,A.ApartmentNo,A.SellableApartmentType,A.Id
    ORDER BY PB.BlockName,A.ApartmentNo;
   END
   IF @PropertyType = 'InP' AND @GetType = 'Contract' 
   BEGIN
    -- Avaliable Apartment
    SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+A.SellableApartmentType AS label,
    A.Id AS ApartmentId,@Tariff AS Tariff FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
    A.PropertyId=P.Id AND A.BlockId=PB.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId = A.Id 
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
    PB.IsDeleted=0 AND P.Category='Internal Property' AND 
    A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND 
    A.IsDeleted=0 AND A.Status='Active' AND
    R.IsDeleted = 0 AND R.IsActive = 1 AND R.RoomStatus = 'Active' AND
    P.Id=@PropertyId AND 
    A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
    A.Id NOT IN (SELECT ApartmentId FROM #Ded)
    GROUP BY PB.BlockName,A.ApartmentNo,A.SellableApartmentType,A.Id
    ORDER BY PB.BlockName,A.ApartmentNo;
   END   
  -- Booking Guest Tab 3
  SELECT GuestId,EmpCode,FirstName,LastName,0 AS Tick,1 AS Chk,
  FirstName+'  '+LastName AS Name
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  -- SSP Begin
  DECLARE @sspcnt INT;
  SET @sspcnt=(SELECT COUNT(*) FROM WRBHBSSPCodeGeneration S
  WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Apartment' AND 
  S.ClientId=@ClientId AND S.PropertyId=@PropertyId);
  CREATE TABLE #SSP11(label NVARCHAR(100),Id BIGINT,Tariff DECIMAL(27,2));
  IF @sspcnt != 0
   BEGIN
    INSERT INTO #SSP11(label,Id,Tariff)
    SELECT 'Please Select SSP',0,0;
    INSERT INTO #SSP11(label,Id,Tariff)
    SELECT S.SSPName AS label,S.Id,S.SingleTariff FROM WRBHBSSPCodeGeneration S
    WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Apartment' AND 
    S.ClientId=@ClientId AND S.PropertyId=@PropertyId;
   END  
  SELECT label,Id,Tariff FROM #SSP11;
  -- SSP End
  -- Payment Mode Begin
  DECLARE @BTC BIT;
  CREATE TABLE #PAYMENT11(label NVARCHAR(100));
  SET @BTC=(SELECT BTC FROM WRBHBClientManagement WHERE Id=@ClientId);
  IF @BTC = 1
   BEGIN
    INSERT INTO #PAYMENT11(label) SELECT 'Bill to Company (BTC)';
    INSERT INTO #PAYMENT11(label) SELECT 'Direct';
   END
  ELSE
   BEGIN
    INSERT INTO #PAYMENT11(label) SELECT 'Direct';
   END
  SELECT label FROM #PAYMENT11; 
  -- Payment Mode End
 END
/*IF @Action = 'BeforeSave_Validation'
 BEGIN
  CREATE TABLE #BookedAprtmnt(ApartmentId BIGINT,Sts NVARCHAR(100));
  -- Apartment Booked Data BEGIN
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT PG.ApartmentId,'Apartment' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT PG.ApartmentId,'Apartment' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT PG.ApartmentId,'Apartment' 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT PG.ApartmentId,'Apartment'
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) GROUP BY PG.ApartmentId;
  -- Apartment Booked Data END
  -- Room Booked Data BEGIN
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Room' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Room' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Room' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  -- 
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Room' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) GROUP BY R.ApartmentId;
  -- Room Booked Data END
  -- Bed Booked Data BEGIN
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Bed' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND R.ApartmentId != 0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Bed' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Bed' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY R.ApartmentId;
  --
  INSERT INTO #BookedAprtmnt(ApartmentId,Sts)
  SELECT R.ApartmentId,'Bed' FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.RoomId=R.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  R.ApartmentId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) GROUP BY R.ApartmentId;
  -- Bed Booked Data END
  SELECT * FROM #BookedAprtmnt;
 END*/
IF @Action = 'BookingDtls'
 BEGIN
  IF @Str1 = ''
   BEGIN
    SET @Str1=CONVERT(VARCHAR(100),DATEADD(DAY,-1,GETDATE()),103);
    SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt,@Str1 AS FrmDt;
    SELECT ClientName,Id FROM WRBHBClientManagement 
    WHERE IsActive=1 AND IsDeleted=0;
    EXEC [dbo].[SP_ApartmentBooking_Help] 'BookingDtls1',@Str1,@Str1,@ChkInDt,
    @ChkOutDt,@StateId,@CityId,@ClientId,@PropertyId,@GradeId,@Id1,@Id2;    
   END
  ELSE
   BEGIN
    EXEC [dbo].[SP_ApartmentBooking_Help] 'BookingDtls1',@Str1,@Str2,@ChkInDt,
    @ChkOutDt,@StateId,@CityId,@ClientId,@PropertyId,@GradeId,@Id1,@Id2;   
   END 
   END
 IF @Action = 'BookingDtls1'
 BEGIN 
  CREATE TABLE #TMP(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt DATE,
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),EmpCode NVARCHAR(100),
  Markup DECIMAL(27,2),BaseTariff DECIMAL(27,2));
  --
  CREATE TABLE #TariffDivision(RoomCapturedCnt INT,RoomCaptured BIGINT,
  BookingId BIGINT,BookingCode BIGINT,Tariff DECIMAL(27,2),
  DividedTariff DECIMAL(27,2));
  --
  CREATE TABLE #Result(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt DATE,
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),EmpCode NVARCHAR(100),
  Markup DECIMAL(27,2),BaseTariff DECIMAL(27,2),SNo BIGINT IDENTITY(1,1));
  IF @ClientId = 0
   BEGIN
    -- Property & Contract - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
   0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType NOT IN('ExP','CPP','MMT') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND 
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Single' AND
    ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	
	
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff+
    (BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+BG.Tariff*ISNULL(BG.STonAgreed,0)/100
    +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Single' AND
    ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack
	
	   
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND  BG.Occupancy='Double' AND
    ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff+(BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+ BG.Tariff*ISNULL(BG.STonAgreed,0)/100
   +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND  BG.Occupancy='Double' AND
     ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack;
    
     INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Triple' AND
     ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BP.TripleandMarkup1,BP.TripleTariff,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
   
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff+(BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+ BG.Tariff*ISNULL(BG.STonAgreed,0)/100
   +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Triple' AND
     ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BP.TripleandMarkup1,BP.TripleTariff,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack;
    
     -- Property & Contract - Canceled & No Show - Room
     INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BP.PropertyType NOT IN('ExP','CPP','MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
	
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('ExP','CPP') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('ExP','CPP') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('ExP','CPP') AND CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
    
    -- Property & Contract - CheckOut,Booked & CheckIn - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode;
    -- Property & Contract - Canceled & No Show - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)  
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
   
   
    -- Property & Contract - CheckOut,Booked & CheckIn - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) 
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    -- Property & Contract - Canceled & No Show - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND 
    BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    -- API - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BP.PropertyType NOT IN('ExP','CPP','MMT') AND CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-Bp.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,Bp.DoubleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
    
    -- API - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BP.PropertyType IN('External','C P P','MMT') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.EmpCode;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-Bp.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,Bp.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup;
    
    -- Tariff Division
    INSERT INTO #TariffDivision(RoomCapturedCnt,RoomCaptured,BookingId,BookingCode,
    Tariff,DividedTariff)
    SELECT COUNT(RoomCaptured),RoomCaptured,BookingId,BookingCode,Tariff,
    ROUND(Tariff / CAST(COUNT(RoomCaptured) AS INT),0)
    FROM #TMP GROUP BY RoomCaptured,BookingId,BookingCode,Tariff;
  
    --
    INSERT INTO #Result(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,StayDays,TotTarif,TariffPaymentMode,
    RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode,
    Markup,BaseTariff)
   
    SELECT T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,CASE
    WHEN T.PropertyType = 'ExP' THEN 'External'
    WHEN T.PropertyType = 'InP' THEN 'Internal'
    WHEN T.PropertyType = 'MGH' THEN 'G H'
    WHEN T.PropertyType = 'CPP' THEN 'C P P'
    WHEN T.PropertyType = 'DdP' THEN 'Dedicated'
    WHEN T.PropertyType = 'MMT' THEN 'M M T' END AS PropertyType,
    T.PropertyId,T.CityName,T.CityId,T.GuestName,T.GuestId,T.ChkInDt,T.ChkOutDt,
    T1.DividedTariff,DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS StayDays,
    T1.DividedTariff * DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS TotTarif,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel,T.EmpCode,
    T.Markup,T.BaseTariff
    FROM #TMP T
	LEFT OUTER JOIN #TariffDivision T1 WITH(NOLOCK)ON 
    T.BookingId = T1.BookingId AND T.BookingCode = T1.BookingCode AND
    T.RoomCaptured = T1.RoomCaptured
    GROUP BY T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,T.PropertyType,T.PropertyId,T.CityName,T.CityId,
    T.GuestName,T.GuestId,T.ChkInDt,T.ChkOutDt,T1.DividedTariff,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel,T.EmpCode,
    T.Markup,T.BaseTariff;
    
   END  
   ELSE
   BEGIN
     -- Property & Contract - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
   0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType NOT IN('ExP','CPP','MMT') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND 
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)  AND B.ClientId = @ClientId 
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Single' AND
    ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),(BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+ BG.Tariff*ISNULL(BG.STonAgreed,0)/100
    +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Single' AND
    ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack;
    
     INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND  BG.Occupancy='Double' AND
    ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),(BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+ BG.Tariff*ISNULL(BG.STonAgreed,0)/100
    +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND  BG.Occupancy='Double' AND
    ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack;
    
     INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Triple' AND
    ISNULL(BP.ExpWithTax,0)=0 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup;
   
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),(BG.Tariff*ISNULL(BG.LTonAgreed,0)/100+ BG.Tariff*ISNULL(BG.STonAgreed,0)/100
    +BG.Tariff*ISNULL(BG.LTonRack,0)/100) AS Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	(Bp.BaseTariff+Bp.Markup) AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND BP.PropertyType IN('ExP','CPP') AND
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND BG.Occupancy='Triple' AND
    ISNULL(BP.ExpWithTax,0)=1 AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup,BG.LTonAgreed,BG.STonAgreed,BG.LTonRack;
    
     -- Property & Contract - Canceled & No Show - Room
     INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BP.PropertyType NOT IN('ExP','CPP','MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
	
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('ExP','CPP') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('ExP','CPP') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,BP.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('ExP','CPP') AND CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup;
	
    -- Property & Contract - CheckOut,Booked & CheckIn - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
     AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode;
    
    -- Property & Contract - Canceled & No Show - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND 
     CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
     AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    -- Property & Contract - CheckOut,Booked & CheckIn - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
     AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
    -- Property & Contract - Canceled & No Show - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND 
    BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
     AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
    
   -- API - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),0,0 FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BP.PropertyType NOT IN('ExP','CPP','MMT') AND CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-Bp.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,Bp.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup;
    
    -- API - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),0,0
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BP.PropertyType IN('External','C P P','MMT') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
     CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Single' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.SingleandMarkup1,BP.SingleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.DoubleandMarkup1-Bp.DoubleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Double' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.DoubleandMarkup1,Bp.DoubleTariff,
	Bp.BaseTariff,Bp.Markup;
	
	 INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel,EmpCode,Markup,BaseTariff)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel,ISNULL(BG.EmpCode,''),
    (BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
	Bp.BaseTariff+Bp.Markup AS BasePrice FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    BG.Occupancy='Triple' AND BP.PropertyType IN('MMT') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
    B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel,BG.EmpCode,BP.TripleandMarkup1,BP.TripleTariff,
	Bp.BaseTariff,Bp.Markup;
	
    -- Tariff Division
    INSERT INTO #TariffDivision(RoomCapturedCnt,RoomCaptured,BookingId,BookingCode,
    Tariff,DividedTariff)
    SELECT COUNT(RoomCaptured),RoomCaptured,BookingId,BookingCode,Tariff,
    ROUND(Tariff / CAST(COUNT(RoomCaptured) AS INT),0)
    FROM #TMP GROUP BY RoomCaptured,BookingId,BookingCode,Tariff;
    
    INSERT INTO #Result(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,StayDays,TotTarif,TariffPaymentMode,
    RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode,
    Markup,BaseTariff)
   
    SELECT T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,CASE
    WHEN T.PropertyType = 'ExP' THEN 'External'
    WHEN T.PropertyType = 'InP' THEN 'Internal'
    WHEN T.PropertyType = 'MGH' THEN 'G H'
    WHEN T.PropertyType = 'CPP' THEN 'C P P'
    WHEN T.PropertyType = 'DdP' THEN 'Dedicated'
    WHEN T.PropertyType = 'MMT' THEN 'M M T' END AS PropertyType,
    T.PropertyId,T.CityName,T.CityId,T.GuestName,T.GuestId,T.ChkInDt,T.ChkOutDt,
    T1.DividedTariff,DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS StayDays,
    T1.DividedTariff * DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS TotTarif,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel,T.EmpCode,
    T.Markup,T.BaseTariff FROM #TMP T
	LEFT OUTER JOIN #TariffDivision T1 WITH(NOLOCK)ON 
    T.BookingId = T1.BookingId AND T.BookingCode = T1.BookingCode AND
    T.RoomCaptured = T1.RoomCaptured
    GROUP BY T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,T.PropertyType,T.PropertyId,T.CityName,T.CityId,
    T.GuestName,T.GuestId,T.ChkInDt,T.ChkOutDt,T1.DividedTariff,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel,T.EmpCode,
    T.Markup,T.BaseTariff;
    
   END

  --CREATE TABLE #Final(BookingCode BIGINT,BookingId BIGINT,
  --MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  --CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  --PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  --GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  --Tariff DECIMAL(27,2),Markup DECIMAL(27,2),BasePrice DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  --TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  --CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt NVARCHAR(100),
  --Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  --Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  --Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  --Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),EmpCode NVARCHAR(100))
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,R.Markup AS Markup,
  --R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  
  --WHERE R.PropertyType IN ('Dedicated','Internal','M M T','G H') 
  --ORDER BY BookingCode,RoomCaptured;
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,R.Markup AS Markup,
  --R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  --JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Dirct'
  --ORDER BY BookingCode,RoomCaptured;
   
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,
  --(R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100+R.Tariff*BG.STonAgreed/100),
  --R.Markup,R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Single' AND ISNULL(BP.ExpWithTax,0)=0
  --ORDER BY BookingCode,RoomCaptured;
  
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,
  --R.Tariff,R.Markup,R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Single' AND ISNULL(BP.ExpWithTax,0)=1
  --ORDER BY BookingCode,RoomCaptured;

  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100
  --+R.Tariff*BG.STonAgreed/100 AS Tariff,
  --R.Markup,R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Double' AND ISNULL(BP.ExpWithTax,0)=0
  --AND R.RoomCaptured=BG.RoomCaptured
  --ORDER BY BookingCode,RoomCaptured;
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff
  --,R.Markup,R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Double' AND ISNULL(BP.ExpWithTax,0)=1
  --AND R.RoomCaptured=BG.RoomCaptured
  --ORDER BY BookingCode,RoomCaptured;
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100
  --+R.Tariff*BG.STonAgreed/100 AS Tariff,R.Markup,R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Triple' AND ISNULL(BP.ExpWithTax,0)=0
  --AND R.RoomCaptured=BG.RoomCaptured
  --ORDER BY BookingCode,RoomCaptured;
  

  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
   
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,R.Markup,R.BaseTariff BasePrice,
  --StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Triple' AND ISNULL(BP.ExpWithTax,0)=1
  --AND R.RoomCaptured=BG.RoomCaptured
  --ORDER BY BookingCode,RoomCaptured;
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+ 
  --R.Tariff*ISNULL(BG.LTonAgreed,0)/100+ R.Tariff*ISNULL(BG.STonAgreed,0)/100
  --+R.Tariff*ISNULL(BG.LTonRack,0)/100 AS Tariff,0 AS Markup,
  --R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode FROM #Result R
  --JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId --AND BG.IsActive=1
  --JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType --AND BP.IsActive=1
  --WHERE R.PropertyType='C P P' AND ISNULL(BP.ExpWithTax,0)=0
  --ORDER BY BookingCode,RoomCaptured;
  
  --INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  --CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  --GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  --RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  --Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  --SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  --MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  --CRMName AS CRMName,R.PropertyName AS PropertyName,
  --R.PropertyType,R.PropertyId,CityName AS City,CityId,
  --ISNULL(GuestName,'') AS GuestName,R.GuestId,
  --R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,0 AS Markup,
  --R.BaseTariff BasePrice,StayDays AS StayDays,TotTarif AS TotalTariff,
  --R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  --BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  --R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  --BookingLevel AS BookingLevel,R.EmpCode  FROM #Result R
  --JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  --JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  --WHERE R.PropertyType='C P P' AND ISNULL(BP.ExpWithTax,0)=1
  --ORDER BY BookingCode,RoomCaptured;
  
 
    
  CREATE TABLE #FinalResult(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),Markup DECIMAL(27,2),BasePrice DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt NVARCHAR(100),
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),SNo BIGINT IDENTITY(1,1),EmpCode NVARCHAR(100))
  
  
  INSERT INTO #FinalResult(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,BasePrice,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,Markup*StayDays AS Markup,BaseTariff BasePrice,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,R.EmpCode FROM #Result R
  GROUP BY BookingCode,R.BookingId,MasterClientName,ClientName,ClientId,
  R.CRMName,R.PropertyName,R.PropertyType,R.PropertyId,R.CityName,R.CityId,
  R.GuestName,R.GuestId,R.ChkInDt,R.ChkOutDt,R.Markup,R.StayDays,R.TotTarif,R.Tariff,
  R.TariffPaymentMode,R.RoomCaptured,R.CurrentStatus,R.BookerName,R.BookedDt,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel,R.EmpCode,R.BaseTariff
  ORDER BY BookingCode,RoomCaptured;
  
  SELECT SNo AS SNo,ISNULL(BookingCode,0) AS BookingCode,ISNULL(R.BookingId,0) AS BookingId,
  ISNULL(MasterClientName,'') AS MasterClientName,ISNULL(ClientName,'') AS ClientName,ISNULL(ClientId,0) AS ClientId,
  ISNULL(CRMName,'') AS CRMName,ISNULL(R.PropertyName,'') AS PropertyName,
  ISNULL(R.PropertyType,'') AS PropertyCategory,ISNULL(R.PropertyId,0) AS PropertyId,ISNULL(CityName,'') AS City,ISNULL(CityId,0) AS CityId,
  ISNULL(GuestName,'') AS GuestName,ISNULL(R.GuestId,0) AS GuestId,
  ISNULL(CONVERT(NVARCHAR,R.ChkInDt,103),'') AS CheckInDt,ISNULL(CONVERT(NVARCHAR,R.ChkOutDt,103),'') AS CheckOutDt,ISNULL(ROUND(R.Tariff,0),0) AS Tariff,
  ISNULL(Markup,0) AS MarkUp,ISNULL(BasePrice,0) AS BasePrice,ISNULL(StayDays,0) AS StayDays,ISNULL(ROUND(R.Tariff,0)*R.StayDays,0) AS TotalTariff,
  ISNULL(R.TariffPaymentMode,'') AS TariffPaymentMode,ISNULL(R.RoomCaptured,0) AS RoomCaptured,ISNULL(R.CurrentStatus,'') AS Status,
  ISNULL(BookerName,'') AS UserName,ISNULL(CONVERT(VARCHAR(100),BookedDt,103),'') AS BookingDate,
  ISNULL(R.Column1,'') AS Column1,ISNULL(R.Column2,'') AS Column2,ISNULL(R.Column3,'') AS Column3,ISNULL(R.Column4,'') AS Column4,ISNULL(R.Column5,'') AS Column5,
  ISNULL(R.Column6,'') AS Column6,ISNULL(R.Column7,'') AS Column7,ISNULL(R.Column8,'') AS Column8,ISNULL(R.Column9,'') AS Column9,ISNULL(R.Column10,'') AS Column10,
  ISNULL(BookingLevel,'') AS BookingLevel,ISNULL(EmpCode,'') AS EmpCode FROM #FinalResult R 
  
 -- GROUP BY BookingCode,R.BookingId,MasterClientName,ClientName,ClientId,
 -- CRMName,R.PropertyName,R.PropertyType,R.PropertyId,CityName,CityId,
 --GuestName,R.GuestId,R.ChkInDt,R.ChkOutDt,R.Tariff,MarkUp,StayDays ,
 -- R.TariffPaymentMode ,R.RoomCaptured,R.CurrentStatus ,BookerName,BookedDt,
 -- R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
 -- BookingLevel,EmpCode
  
  ORDER BY SNo;
  
  
 ---For dynamic change header
 IF(@ClientId !=0)
 BEGIN 
  SELECT ISNULL(Column1,'') Column1,ISNULL(Column2,'') Column2,ISNULL(Column3,'') Column3,
  ISNULL(Column4,'') Column4,ISNULL(Column5,'') Column5,ISNULL(Column6,'') Column6,
  ISNULL(Column7,'') Column7,ISNULL(Column8,'') Column8,ISNULL(Column9,'') Column9,ISNULL(Column10,'') Column10
  FROM WRBHBClientColumns 
  WHERE ClientId=@ClientId AND IsActive=1 AND IsDeleted=0
 END
 ELSE
 BEGIN
  SELECT 'Column1','Column2','Column3','Column4','Column5','Column6','Column7','Column8','Column9','Column10'
 END
END
	IF @Action = 'ExternalVendorPOPageLoad'
	 BEGIN
	  -- Date
	  SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt,
	  CONVERT(VARCHAR(100),DATEADD(DAY,-1,GETDATE()),103) AS FrmDt;
	  -- Property (Vendor)
	  SELECT PropertyName,Id AS ZId FROM WRBHBProperty
	  WHERE IsActive=1 AND IsDeleted=0 AND Category='External Property';
	 END
	IF @Action = 'POBased'
	 BEGIN
	  Exec [dbo].[SP_ExternalVendorPaymentOutstandingReport_Help]
	  @Action,'','',@ChkInDt,@ChkOutDt,0,0,0,@PropertyId;
	 END
	IF @Action = 'StayBased'
	 BEGIN
	  Exec [dbo].[SP_ExternalVendorPaymentOutstandingReport_Help]
	  @Action,'','',@ChkInDt,@ChkOutDt,0,0,0,@PropertyId;
	 END
END
