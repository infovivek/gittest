-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help_ClientPrefered]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help_ClientPrefered]
GO 
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
Section  	: Booking  Help 
Purpose  	: Booking  Help ClientPrefered
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
CREATE PROCEDURE [dbo].[SP_Booking_Help_ClientPrefered](@Action NVARCHAR(100),
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
IF @Action = 'ClientPreferedProperty'
 BEGIN
  CREATE TABLE #ClientPrefered(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100));
  IF @MinValue = 0
   BEGIN
    INSERT INTO #ClientPrefered(PropertyName,Id,GetType)    
    SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
    P.Id=D.PropertyId
    LEFT OUTER JOIN WRBHBContractClientPref_Header H WITH(NOLOCK)ON 
    H.Id=D.HeaderId
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
    D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND  
    P.Category='Client Prefered' AND H.ClientId=@ClientId
    AND P.CityId=@CityId;
   END
  ELSE
   BEGIN
    INSERT INTO #ClientPrefered(PropertyName,Id,GetType)    
    SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
    P.Id=D.PropertyId
    LEFT OUTER JOIN WRBHBContractClientPref_Header H WITH(NOLOCK)ON 
    H.Id=D.HeaderId
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
    D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
    P.Category='Client Prefered' AND
    P.CityId=@CityId AND H.ClientId=@ClientId AND 
    D.TariffSingle BETWEEN @MinValue AND @MaxValue;
   END
  ----
  SELECT PropertyName AS label,Id,GetType FROM #ClientPrefered 
  ORDER BY PropertyName ASC;
 END
IF @Action = 'ClientPreferedPropertyRooms'
 BEGIN
  CREATE TABLE #TMP(label NVARCHAR(100),TariffId BIGINT,BlockId BIGINT,
  ApartmentId BIGINT,RoomId BIGINT);  
  IF @Str1 = 'Contract'
   BEGIN    
    IF @Str2 = 'Single'
     BEGIN
      INSERT INTO #TMP(label,TariffId,BlockId,ApartmentId,RoomId)
      SELECT 'Rs.'+CAST(D.TariffSingle AS VARCHAR) AS label,D.Id AS TariffId,
      0 AS BlockId,0 AS ApartmentId,0 AS RoomId
      FROM WRBHBContractClientPref_Details D
      WHERE D.IsActive=1 AND D.IsDeleted=0 AND D.PropertyId=@PropertyId;
     END
    IF @Str2 = 'Double'
     BEGIN
      INSERT INTO #TMP(label,TariffId,BlockId,ApartmentId,RoomId)
      SELECT 'Rs.'+CAST(D.TariffDouble AS VARCHAR) AS label,D.Id AS TariffId,
      0 AS BlockId,0 AS ApartmentId,0 AS RoomId 
      FROM WRBHBContractClientPref_Details D
      WHERE D.IsActive=1 AND D.IsDeleted=0 AND D.PropertyId=@PropertyId;
     END    
    IF @Str2 = 'Triple'
     BEGIN
      INSERT INTO #TMP(label,TariffId,BlockId,ApartmentId,RoomId)
      SELECT 'Rs.'+CAST(D.TariffDouble AS VARCHAR) AS label,D.Id AS TariffId,
      0 AS BlockId,0 AS ApartmentId,0 AS RoomId 
      FROM WRBHBContractClientPref_Details D
      WHERE D.IsActive=1 AND D.IsDeleted=0 AND D.PropertyId=@PropertyId;
     END
   END
    SELECT label,TariffId,BlockId,ApartmentId,RoomId FROM #TMP
    WHERE TariffId NOT IN (SELECT TariffId FROM WRBHBBooking
    WHERE PropertyId=@PropertyId AND CheckInDate=CONVERT(DATE,@ChkInDt,103)
    AND CheckOutDate=CONVERT(DATE,@ChkOutDt,103));
  -- PROPERTY ROOM DISCOUNT
  SELECT DiscountModePer,DiscountModeRS,DiscountAllowed 
  FROM WRBHBPropertyRooms
  WHERE IsActive=0 AND IsDeleted=0 AND PropertyId=@PropertyId;
 END
END