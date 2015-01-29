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
    UPDATE WRBHBBooking SET IsActive = 0 WHERE Id=@Id1;
    UPDATE WRBHBBookingGuestDetails SET IsActive = 0 WHERE BookingId=@Id1;
    UPDATE WRBHBApartmentBookingProperty SET IsActive = 0 WHERE BookingId=@Id1;
    UPDATE WRBHBApartmentBookingPropertyAssingedGuest 
    SET IsActive = 0 WHERE BookingId=@Id1;    
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
    EXEC [dbo].[BookingReport] 'BookingDtls',@Str1,@Str1,@ClientId;    
   END
  ELSE
   BEGIN
    EXEC [dbo].[BookingReport] 'BookingDtls',@Str1,@Str2,@ClientId;
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
