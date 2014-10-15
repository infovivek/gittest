-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help_SSP]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help_SSP]
GO 
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
Section  	: Booking  Insert 
Purpose  	: Booking  help SSP
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
CREATE PROCEDURE [dbo].[SP_Booking_Help_SSP](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'SpecialSalesPromotionProperty'
 BEGIN
  SELECT P.PropertyName AS label,P.Id,'SSP' AS GetType FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBSSPCodeGeneration C WITH(NOLOCK)ON P.Id=C.PropertyId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND C.IsActive=1 AND C.IsDeleted=0 AND
  C.ClientId=@ClientId AND P.CityId=@CityId;
 END
IF @Action = 'SpecialSalesPromotionCode'
 BEGIN
  CREATE TABLE #TMP(label NVARCHAR(1000),BlockId BIGINT,RoomId BIGINT,
  ApartmentId BIGINT,TariffId BIGINT);
  INSERT INTO #TMP(label,BlockId,RoomId,ApartmentId,TariffId)   
  SELECT SSPName AS label,Id AS BlockId,Id AS RoomId,Id AS ApartmentId,
  Id AS TariffId FROM WRBHBSSPCodeGeneration WHERE IsActive=1 AND 
  IsDeleted=0 AND ClientId=@ClientId AND PropertyId=@PropertyId;
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