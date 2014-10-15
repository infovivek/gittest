-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help_Dedicated]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help_Dedicated]
GO 
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
Section  	: Booking  Help 
Purpose  	: Booking  Help Dedicated
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
CREATE PROCEDURE [dbo].[SP_Booking_Help_Dedicated](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'DedicatedProperty'
 BEGIN
  CREATE TABLE #ManagedGH(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100));
  ---  
  INSERT INTO #ManagedGH(PropertyName,Id,GetType)
  SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D WITH(NOLOCK)ON
  P.Id=D.PropertyId
  LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON 
  H.Id=D.ContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND  
  H.ContractType=' Dedicated Contracts '
  AND P.CityId=@CityId AND H.ClientId=@ClientId;
/*  -- property
  INSERT INTO #ManagedGH(PropertyName,Id,GetType)
  SELECT P.PropertyName,P.Id,'Property' AS GetType FROM WRBHBProperty P
  WHERE P.IsDeleted=0 AND P.IsActive=1 AND P.Category='Managed G H' AND
  P.CityId=@CityId AND
  P.Id NOT IN (SELECT D.PropertyId FROM WRBHBContractManagement H
  LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D
  WITH(NOLOCK)ON H.Id=D.ContractId
  WHERE H.IsDeleted=0 AND H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1
  AND H.ContractType=' Managed Contracts ')
  GROUP BY P.PropertyName,P.Id;
*/  ----
  SELECT PropertyName AS label,Id,GetType FROM #ManagedGH 
  ORDER BY PropertyName ASC;
 END
IF @Action = 'DedicatedPropertyRooms'
 BEGIN
/*  IF @Str1 = 'Property'
   BEGIN    
    SELECT 'Property'+' - '+B.BlockName+' - '+R.RoomNo+' - '+R.RoomCategory
    +''+R.RoomType AS label,B.Id AS BlockId,R.Id AS RoomId 
    FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
    B.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id
    WHERE P.Id=@PropertyId;
   END
*/
  IF @Str1 = 'Contract'
   BEGIN
    CREATE TABLE #TMP(label NVARCHAR(100),ApartmentId BIGINT,RoomId BIGINT,
    BlockId BIGINT,TariffId INT);
    INSERT INTO #TMP(label,ApartmentId,RoomId,BlockId,TariffId)
    SELECT 'Contract'+' - '+B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo
    AS label,A.Id AS ApartmentId,R.Id AS RoomId,B.Id AS BlockId,
    0 AS TariffId FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractManagementTariffAppartment T WITH(NOLOCK)ON
    T.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON H.Id=T.ContractId
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.Id=T.RoomId    
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.Id=T.ApartmentId
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.Id=A.BlockId
    WHERE P.Id=@PropertyId AND H.ContractType=' Dedicated Contracts ' AND 
    H.ClientId=@ClientId AND P.IsDeleted=0 AND P.IsActive=1 AND 
    T.IsDeleted=0 AND T.IsActive=1 AND H.IsActive=1 AND H.IsDeleted=0 AND 
    R.IsDeleted=0 AND R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
   END
    --
    SELECT label,ApartmentId,RoomId,BlockId,TariffId FROM #TMP
    WHERE RoomId NOT IN (SELECT RoomId FROM WRBHBBooking
    WHERE PropertyId=@PropertyId AND CheckInDate=CONVERT(DATE,@ChkInDt,103)
    AND CheckOutDate=CONVERT(DATE,@ChkOutDt,103));
  -- PROPERTY ROOM DISCOUNT
  SELECT DiscountModePer,DiscountModeRS,DiscountAllowed 
  FROM WRBHBPropertyRooms
  WHERE IsActive=0 AND IsDeleted=0 AND PropertyId=@PropertyId;
 END
END