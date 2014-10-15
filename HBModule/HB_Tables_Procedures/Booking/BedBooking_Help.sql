-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BedBooking_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BedBooking_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:May-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Bed Level Booking
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BedBooking_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'BedLevel_Property'
 BEGIN
  IF @Id2 = 123
   BEGIN
    DELETE FROM WRBHBBooking WHERE Id=@Id1;
    DELETE FROM WRBHBBookingGuestDetails WHERE BookingId=@Id1;
    DELETE FROM WRBHBBedBookingProperty WHERE BookingId=@Id1;
    DELETE FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId=@Id1;
   END
  -- Dedicated Rooms
  CREATE TABLE #ExstsDdpRoom(RoomId BIGINT);
  INSERT INTO #ExstsDdpRoom(RoomId)
  SELECT RoomId FROM WRBHBContractManagementTariffAppartment 
  WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0;
  -- Dedicated Apartment
  CREATE TABLE #ExstsApartment(ApartmentId BIGINT);
  INSERT INTO #ExstsApartment(ApartmentId)
  SELECT T.ApartmentId FROM WRBHBContractManagementAppartment T 
  WHERE T.IsActive=1 AND T.IsDeleted=0 AND T.ApartmentId != 0;
  -- Room Booked Begin
  CREATE TABLE #ExsInPRoom(RoomId BIGINT);
  INSERT INTO #ExsInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND  
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  --
  INSERT INTO #ExsInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExsInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  -- 
  INSERT INTO #ExsInPRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId
  GROUP BY PG.RoomId;
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  -- Room Booked End
  -- Bed Booked Begin
  CREATE TABLE #ExstsInPBed(BedId BIGINT);
  INSERT INTO #ExstsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.BedId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExstsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.BedId;
  --
  INSERT INTO #ExstsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.BedId;
  -- 
  INSERT INTO #ExstsInPBed(BedId)
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId
  GROUP BY PG.BedId;
  -- Bed Booked End
  -- Apartment Booked Begin
  CREATE TABLE #ExstsInPApartment(ApartmentId BIGINT);
  INSERT INTO #ExstsInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExstsInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  --
  INSERT INTO #ExstsInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  -- 
  INSERT INTO #ExstsInPApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId
  GROUP BY PG.ApartmentId;
  -- Apartment Booked End
  -- Non Dedicated Contract Property
  CREATE TABLE #BED(PropertyId BIGINT,Tariff DECIMAL(27,2));
  INSERT INTO #BED(PropertyId,Tariff)
  SELECT D.PropertyId,D.BedTarif FROM WRBHBContractNonDedicated H
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
  D.NondedContractId=H.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=D.PropertyId
  WHERE H.IsDeleted=0 AND H.IsActive=1 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND P.Category='Internal Property' AND
  H.ClientId=@ClientId AND P.CityId=@CityId;
  -- Avaliable Beds
  CREATE TABLE #BED1(PropertyId BIGINT,BlockId BIGINT,ApartmentId BIGINT,
  RoomId BIGINT,BedId BIGINT,Tariff DECIMAL(27,2),GetType NVARCHAR(100),
  PropertyType NVARCHAR(100),DiscountModePer BIT,DiscountModeRS BIT,
  DiscountAllowed DECIMAL(27,2));
  -- Non Dedicated Contract Property Avaliable Beds
  INSERT INTO #BED1(PropertyId,BlockId,ApartmentId,RoomId,BedId,Tariff,
  GetType,PropertyType,DiscountModePer,DiscountModeRS,
  DiscountAllowed)  
  SELECT P.Id,B.Id,A.Id,R.Id,B.Id,ND.Tariff,'Contract','InP',0,0,0 
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id AND A.BlockId=PB.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
  B.RoomId=R.Id
  LEFT OUTER JOIN #BED ND WITH(NOLOCK)ON ND.PropertyId=P.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
  PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND 
  R.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND
  P.Category='Internal Property' AND P.Id = ND.PropertyId AND
  A.SellableApartmentType != 'HUB' AND P.CityId=@CityId AND
  R.RoomStatus='Active' AND A.Status='Active' AND
  R.Id NOT IN (SELECT RoomId FROM #ExstsDdpRoom) AND
  B.Id NOT IN (SELECT BedId FROM #ExstsInPBed) AND
  R.Id NOT IN (SELECT RoomId FROM #ExsInPRoom) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExstsInPApartment) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExstsApartment)
  GROUP BY P.Id,B.Id,A.Id,R.Id,B.Id,ND.Tariff;  
  -- Property Avaliable Beds
  INSERT INTO #BED1(PropertyId,BlockId,ApartmentId,RoomId,BedId,Tariff,
  GetType,PropertyType,DiscountModePer,DiscountModeRS,
  DiscountAllowed)  
  SELECT P.Id,B.Id,A.Id,R.Id,B.Id,B.BedRackTarrif,'Property','InP',
  B.DiscountModePer,B.DiscountModeRS,B.DiscountAllowed
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id AND A.BlockId=PB.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
  B.RoomId=R.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
  PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND 
  R.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND
  P.Category='Internal Property' AND 
  P.Id NOT IN (SELECT PropertyId FROM #BED WHERE Tariff != 0) AND
  A.SellableApartmentType != 'HUB' AND P.CityId=@CityId AND
  R.RoomStatus='Active' AND A.Status='Active' AND
  R.Id NOT IN (SELECT RoomId FROM #ExstsDdpRoom) AND
  B.Id NOT IN (SELECT BedId FROM #ExstsInPBed) AND
  R.Id NOT IN (SELECT RoomId FROM #ExsInPRoom) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExstsInPApartment) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExstsApartment)
  GROUP BY P.Id,B.Id,A.Id,R.Id,B.Id,B.BedRackTarrif,
  B.DiscountModePer,B.DiscountModeRS,B.DiscountAllowed;
  -- Delete From Agreed Tariff Zero in ND Property
  DELETE FROM #BED1 WHERE GetType='Contract' AND 
  PropertyType='InP' AND Tariff=0;
  -- FINAL SELECT
  SELECT P.PropertyName,B.PropertyId,B.GetType,B.PropertyType,B.Tariff,
  P.Phone,P.Email,L.Locality AS Locality,P.LocalityId,0 AS Tick,1 AS Chk,
  0 AS Id,B.DiscountModePer AS Per,B.DiscountModeRS AS Rs,B.DiscountAllowed,
  '' AS Discount,B.Tariff AS DiscountTariff,
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
  FROM #BED1 B
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON B.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId
  LEFT OUTER JOIN WRBHBPropertyType T WITH(NOLOCK)ON T.Id=P.PropertyType 
  GROUP BY P.PropertyName,B.PropertyId,B.Tariff,P.Phone,P.Email,
  L.Locality,P.LocalityId,B.GetType,B.PropertyType,
  B.DiscountModePer,B.DiscountModeRS,B.DiscountAllowed,T.PropertyType;
 END
IF @Action = 'BedLevel_Tab2_to_Tab3_Dtls'
 BEGIN
  SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@Id1);
  SET @CityId=(SELECT CityId FROM WRBHBBooking WHERE Id=@Id1);
  SET @PropertyId=(SELECT TOP 1 PropertyId FROM WRBHBBedBookingProperty 
  WHERE BookingId=@Id1);
  DECLARE @Tariff DECIMAL(27,2);
  SET @Tariff=(SELECT TOP 1 DiscountTariff FROM WRBHBBedBookingProperty 
  WHERE BookingId=@Id1);
  -- DEDICATED ROOMS
  CREATE TABLE #ExistsDdpRoom(RoomId BIGINT);
  INSERT INTO #ExistsDdpRoom(RoomId)
  SELECT RoomId FROM WRBHBContractManagementTariffAppartment 
  WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND
  PropertyId=@PropertyId;
  -- DEDICATED APARTMENT
  CREATE TABLE #ExistsDdpApartment(ApartmentId BIGINT);
  INSERT INTO #ExistsDdpApartment(ApartmentId)
  SELECT T.ApartmentId FROM WRBHBContractManagementAppartment T 
  WHERE T.IsActive=1 AND T.IsDeleted=0 AND T.ApartmentId != 0 AND 
  T.PropertyId=@PropertyId;
  -- Room Booked Begin
  CREATE TABLE #ExInPRoom(RoomId BIGINT);
  INSERT INTO #ExInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  --
  INSERT INTO #ExInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
  --
  INSERT INTO #ExInPRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
  --
  INSERT INTO #ExInPRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
  PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  -- Room Booked End
  -- Bed Booked Begin
  CREATE TABLE #ExistsInPBed(BedId BIGINT);
  INSERT INTO #ExistsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  --
  INSERT INTO #ExistsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  --
  INSERT INTO #ExistsInPBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  -- 
  INSERT INTO #ExistsInPBed(BedId)
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
  PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.BedId;
  -- Bed Booked End
  -- Apartment Booked Begin
  CREATE TABLE #ExInPApartment(ApartmentId BIGINT);
  INSERT INTO #ExInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  --
  INSERT INTO #ExInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  --
  INSERT INTO #ExInPApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  -- 
  INSERT INTO #ExInPApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
  PG.BookingPropertyId=@PropertyId;*/
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.ApartmentId;
  -- Apartment Booked End
  -- Booking property
  SELECT TOP 1 PropertyType+' - '+PropertyName AS label,PropertyId,Id,
  PropertyType FROM WRBHBBedBookingProperty WHERE BookingId=@Id1;
  -- Beds Avaliable in Property
  SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
  CAST(B.BedNO AS VARCHAR) AS label,R.Id AS RoomId,B.Id AS BedId,
  @Tariff AS Tariff FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id AND A.BlockId=PB.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
  B.RoomId=R.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND 
  PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
  A.SellableApartmentType != 'HUB' AND A.Status='Active' AND 
  R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active' AND
  B.IsActive=1 AND B.IsDeleted=0 AND P.Category='Internal Property' AND   
  P.CityId=@CityId AND P.Id=@PropertyId AND
  R.Id NOT IN (SELECT RoomId FROM #ExistsDdpRoom) AND
  B.Id NOT IN (SELECT BedId FROM #ExistsInPBed) AND
  R.Id NOT IN (SELECT RoomId FROM #ExInPRoom) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExInPApartment) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExistsDdpApartment)
  ORDER BY PB.BlockName,A.ApartmentNo,R.RoomNo,B.Id;
  -- Booking Guest Tab 3
  SELECT GuestId,EmpCode,FirstName,LastName,0 AS Tick,1 AS Chk,
  FirstName+'  '+LastName AS Name
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  --SSP Begin
  DECLARE @sspcnt INT;
  SET @sspcnt=(SELECT COUNT(*) FROM WRBHBSSPCodeGeneration S
  WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Bed' AND 
  S.ClientId=@ClientId AND S.PropertyId=@PropertyId);
  CREATE TABLE #SSP1(label NVARCHAR(100),Id BIGINT,Tariff DECIMAL(27,2));
  IF @sspcnt != 0
   BEGIN
    INSERT INTO #SSP1(label,Id,Tariff)
    SELECT 'Please Select SSP',0,0;
    INSERT INTO #SSP1(label,Id,Tariff)
    SELECT S.SSPName AS label,S.Id,S.SingleTariff FROM WRBHBSSPCodeGeneration S
    WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Bed' AND 
    S.ClientId=@ClientId AND S.PropertyId=@PropertyId;
   END  
  SELECT label,Id,Tariff FROM #SSP1;
  --SSP End
  -- Payment Mode Begin
  DECLARE @BTC BIT;
  CREATE TABLE #PAYMENT1(label NVARCHAR(100));
  SET @BTC=(SELECT BTC FROM WRBHBClientManagement WHERE Id=@ClientId);
  IF @BTC = 1
   BEGIN
    INSERT INTO #PAYMENT1(label) SELECT 'Bill to Company (BTC)';
    INSERT INTO #PAYMENT1(label) SELECT 'Direct';
   END
  ELSE
   BEGIN
    INSERT INTO #PAYMENT1(label) SELECT 'Direct';
   END
  SELECT label FROM #PAYMENT1; 
  -- Payment Mode End
 END
/*IF @Action = 'BeforeSave_Validation'
 BEGIN  
  -- Room Booked Begin
  CREATE TABLE #BookedRoom(RoomId BIGINT);
  INSERT INTO #BookedRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId != 0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  --
  INSERT INTO #BookedRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId!=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  --
  INSERT INTO #BookedRoom(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId!=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  --
  INSERT INTO #BookedRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND PG.RoomId!=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  -- Room Booked End
  -- Bed Booked Begin
  CREATE TABLE #BookedBed(BedId BIGINT);
  INSERT INTO #BookedBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  --
  INSERT INTO #BookedBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  --
  INSERT INTO #BookedBed(BedId) 
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.BedId;
  -- 
  INSERT INTO #BookedBed(BedId)
  SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.BedId;
  -- Bed Booked End
  -- Apartment Booked Begin
  CREATE TABLE #BookedApartment(ApartmentId BIGINT);
  INSERT INTO #BookedApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  --
  INSERT INTO #BookedApartment(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
  -- 
  INSERT INTO #BookedApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.ApartmentId;
  -- Apartment Booked End
  -- Beds Avaliable in Property
  CREATE TABLE #AvaliableBed(BedId BIGINT);
  INSERT INTO #AvaliableBed(BedId)
  SELECT B.Id FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=P.Id AND A.BlockId=PB.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
  B.RoomId=R.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND 
  PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
  A.SellableApartmentType != 'HUB' AND A.Status='Active' AND 
  R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active' AND
  B.IsActive=1 AND B.IsDeleted=0 AND P.Category='Internal Property' AND   
  P.Id=@PropertyId AND
  R.Id NOT IN (SELECT RoomId FROM #BookedRoom) AND
  B.Id NOT IN (SELECT BedId FROM #BookedBed) AND
  A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
  GROUP BY B.Id;
  --
  SELECT * FROM #AvaliableBed;
 END*/
END