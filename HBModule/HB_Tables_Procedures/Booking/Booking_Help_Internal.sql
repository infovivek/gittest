-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help_Internal]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help_Internal]
GO 
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
Section  	: Booking  Help 
Purpose  	: Booking  Help Internal
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_Booking_Help_Internal](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
-----------------------------
DECLARE @MinValue DECIMAL(27,2),@MaxValue DECIMAL(27,2),@Cnt INT;
SET @Cnt=(SELECT COUNT(*) FROM WRBHBClientGradeValue G
LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
G.Id=GV.ClientGradeValueId
WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND GV.IsDeleted=0
AND G.GradeId=@GradeId AND GV.CityId=@CityId);
IF @Cnt = 0
 BEGIN
  SET @MinValue=0;
 END
ELSE
 BEGIN
  SELECT @MinValue=MinValue,@MaxValue=MaxValue FROM WRBHBClientGradeValue G
  LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
  G.Id=GV.ClientGradeValueId
  WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND GV.IsDeleted=0
  AND G.GradeId=@GradeId AND GV.CityId=@CityId;    
 END
-----------------------------
IF @Action = 'InternalProperty'
 BEGIN
  CREATE TABLE #Internal(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100));
  IF @MinValue = 0
   BEGIN
    -- Non Dedicated
    INSERT INTO #Internal(PropertyName,Id,GetType)
    SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
    P.Id=D.PropertyId
    LEFT OUTER JOIN WRBHBContractNonDedicated H WITH(NOLOCK)ON 
    H.Id=D.NondedContractId
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
    D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
    P.CityId=@CityId AND H.ClientId=@ClientId AND 
    P.Category='Internal Property'
    GROUP BY P.PropertyName,P.Id;
    -- property
    INSERT INTO #Internal(PropertyName,Id,GetType)
    SELECT P.PropertyName,P.Id,'Property' AS GetType FROM WRBHBProperty P
    WHERE P.IsDeleted=0 AND P.IsActive=1 AND P.Category='Internal Property' AND
    P.CityId=@CityId AND
    P.Id NOT IN (SELECT PropertyId FROM WRBHBContractNonDedicatedApartment
    WHERE PropertyCategory='Internal Property' AND IsDeleted=0 AND IsActive=1)
    GROUP BY P.PropertyName,P.Id;
   END
  ELSE
   BEGIN
    -- Non Dedicated
    SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
    P.Id=D.PropertyId
    LEFT OUTER JOIN WRBHBContractNonDedicated H WITH(NOLOCK)ON 
    H.Id=D.NondedContractId
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
    D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
    P.CityId=@CityId AND H.ClientId=@ClientId AND 
    P.Category='Internal Property' AND 
    D.RoomTarif BETWEEN @MinValue AND @MaxValue
    GROUP BY P.PropertyName,P.Id;
    -- property
    INSERT INTO #Internal(PropertyName,Id,GetType)
    SELECT P.PropertyName,P.Id,'Property' AS GetType FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id
    WHERE P.IsDeleted=0 AND P.IsActive=1 AND P.Category='Internal Property' AND
    P.CityId=@CityId AND R.IsActive=1 AND R.IsDeleted=0 AND
    R.RackTariff BETWEEN @MinValue AND @MaxValue AND 
    P.Id NOT IN (SELECT PropertyId FROM WRBHBContractNonDedicatedApartment
    WHERE PropertyCategory='Internal Property' AND IsDeleted=0 AND IsActive=1)
    GROUP BY P.PropertyName,P.Id;
   END
  ----
  SELECT PropertyName AS label,Id,GetType FROM #Internal 
  ORDER BY PropertyName ASC;
 END
IF @Action = 'InternalPropertyRooms'
 BEGIN
  CREATE TABLE #TMP(label NVARCHAR(1000),BlockId BIGINT,ApartmentId BIGINT,
  RoomId BIGINT,TariffId BIGINT);
  IF @Str1 = 'Property'
   BEGIN
    IF @Str2 = 'Single'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Property'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo
      +' - '+CAST(R.RackTariff AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,R.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
      A.PropertyId=P.Id AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id 
      AND R.ApartmentId=A.Id WHERE P.Id=@PropertyId AND 
      R.Id NOT IN(SELECT ISNULL(RoomId,0) 
      FROM WRBHBContractManagementTariffAppartment 
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo,R.RackTariff;
     END
    IF @Str2 = 'Double'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Property'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo
      +' - '+CAST(R.DoubleOccupancyTariff AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,R.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
      A.PropertyId=P.Id AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id AND
      R.ApartmentId=A.Id
      WHERE P.Id=@PropertyId AND 
      R.Id NOT IN(SELECT ISNULL(RoomId,0) 
      FROM WRBHBContractManagementTariffAppartment 
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo,R.RackTariff;
     END
    IF @Str2 = 'Triple'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Property'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo
      +' - '+CAST(R.DoubleOccupancyTariff AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,R.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
      A.PropertyId=P.Id AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id AND
      R.ApartmentId=A.Id
      WHERE P.Id=@PropertyId AND 
      R.Id NOT IN(SELECT ISNULL(RoomId,0) 
      FROM WRBHBContractManagementTariffAppartment 
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo,R.RackTariff;
     END
/*  SELECT 'Property'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo
    +' - '+CAST(R.RackTariff AS VARCHAR) AS label,B.Id AS BlockId,
    A.Id AS ApartmentId,R.Id AS RoomId,R.Id AS TariffId FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
    B.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id
    WHERE P.Id=@PropertyId AND 
    R.Id NOT IN(SELECT ISNULL(RoomId,0) 
    FROM WRBHBContractManagementTariffAppartment WHERE PropertyId=@PropertyId);
*/
   END
  IF @Str1 = 'Contract'
   BEGIN
    IF @Str2 = 'Single'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Contract'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+
      R.RoomNo+' - '+CAST(T.RoomTarif AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,T.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.PropertyId=P.Id
      AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id AND
      R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBContractNonDedicatedApartment T WITH(NOLOCK)ON
      T.PropertyId=P.Id
      WHERE P.Id=@PropertyId AND
      R.Id NOT IN(SELECT RoomId FROM WRBHBContractManagementTariffAppartment
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
     END
    IF @Str2 = 'Double'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Contract'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+
      R.RoomNo+' - '+CAST(T.DoubleTarif AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,T.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.PropertyId=P.Id
      AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id AND
      R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBContractNonDedicatedApartment T WITH(NOLOCK)ON
      T.PropertyId=P.Id
      WHERE P.Id=@PropertyId AND
      R.Id NOT IN(SELECT RoomId FROM WRBHBContractManagementTariffAppartment
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
     END
    IF @Str2 = 'Triple'
     BEGIN
      INSERT INTO #TMP(label,BlockId,ApartmentId,RoomId,TariffId)
      SELECT 'Contract'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+
      R.RoomNo+' - '+CAST(T.DoubleTarif AS VARCHAR) AS label,B.Id AS BlockId,
      A.Id AS ApartmentId,R.Id AS RoomId,T.Id AS TariffId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.PropertyId=P.Id
      AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id AND
      R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBContractNonDedicatedApartment T WITH(NOLOCK)ON
      T.PropertyId=P.Id
      WHERE P.Id=@PropertyId AND
      R.Id NOT IN(SELECT RoomId FROM WRBHBContractManagementTariffAppartment
      WHERE PropertyId=@PropertyId)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
     END
   END
  --
  SELECT label,BlockId,ApartmentId,RoomId,TariffId FROM #TMP
  WHERE RoomId NOT IN (SELECT RoomId FROM WRBHBBooking
  WHERE PropertyId=@PropertyId AND CheckInDate=CONVERT(DATE,@ChkInDt,103)
  AND CheckOutDate=CONVERT(DATE,@ChkOutDt,103));
  -- PROPERTY ROOM DISCOUNT
  SELECT DiscountModePer,DiscountModeRS,DiscountAllowed 
  FROM WRBHBPropertyRooms
  WHERE IsActive=0 AND IsDeleted=0 AND PropertyId=@PropertyId;
 END
END