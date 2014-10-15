-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help_ManagedGH]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help_ManagedGH]
GO 
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
Section  	: Booking  Help 
Purpose  	: Booking  Help Managed GH
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
CREATE PROCEDURE [dbo].[SP_Booking_Help_ManagedGH](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'ManagedGuestHouseProperty'
 BEGIN
  CREATE TABLE #ManagedGH(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100));
  --- contract managed GH  
  INSERT INTO #ManagedGH(PropertyName,Id,GetType)
  SELECT P.PropertyName,P.Id,'Contract' AS GetType FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D WITH(NOLOCK)ON
  P.Id=D.PropertyId
  LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON 
  H.Id=D.ContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND  
  P.Category='Managed G H' AND H.ContractType=' Managed Contracts '
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
IF @Action = 'ManagedGuestHousePropertyRooms'
 BEGIN
  CREATE TABLE #TMP(label NVARCHAR(1000),BlockId BIGINT,RoomId BIGINT,
  ApartmentId BIGINT,TariffId BIGINT);
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
    INSERT INTO #TMP(label,BlockId,RoomId,ApartmentId,TariffId)
    SELECT 'Contract'+' - '+B.BlockName+' - '+R.RoomNo+' - '+R.RoomCategory
    +''+R.RoomType AS label,B.Id AS BlockId,R.Id AS RoomId,
    0 AS ApartmentId,0 AS TariffId 
    FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
    B.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.PropertyId=P.Id
    WHERE P.Id=@PropertyId;    
   END
  --
  SELECT label,BlockId,RoomId,ApartmentId,TariffId FROM #TMP
  WHERE RoomId NOT IN (SELECT RoomId FROM WRBHBBooking
  WHERE PropertyId=@PropertyId AND CheckInDate=CONVERT(DATE,@ChkInDt,103)
  AND CheckOutDate=CONVERT(DATE,@ChkOutDt,103));
  -- PROPERTY ROOM DISCOUNT
  SELECT DiscountModePer,DiscountModeRS,DiscountAllowed 
  FROM WRBHBPropertyRooms
  WHERE IsActive=0 AND IsDeleted=0 AND PropertyId=@PropertyId;
 END
END