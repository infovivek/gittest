SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRooms_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PropertyRooms_Help]
GO 
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: PROPERTY ROOMS Help
Purpose  	: PROPERTY ROOMS
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
CREATE PROCEDURE [dbo].[Sp_PropertyRooms_Help](@PAction NVARCHAR(100),
@PropertyId BIGINT,@Pram1 BIGINT,@Pram2 NVARCHAR(100),@UserId BIGINT)
AS
BEGIN
 IF @PAction ='APARTMENT'
  BEGIN
   SELECT ApartmentNo AS label,Id, SellableApartmentType 
   FROM WRBHBPropertyApartment 
   WHERE PropertyId=@PropertyId AND BlockId=@Pram1 AND IsActive=1;
  END
  IF @PAction ='SelectApartment'
  BEGIN
  DECLARE @Id BIGINT,@ApartmentType NVARCHAR(100) ;
  SELECT @ApartmentType=SellableApartmentType FROM WRBHBPropertyApartment WHERE Id=@Pram1
  
  IF @ApartmentType!='Villa'
  BEGIN
	  SELECT COUNT(*)RoomCount FROM WRBHBPropertyRooms R 
	  WHERE ApartmentId=@Pram1 AND PropertyId=@PropertyId AND IsDeleted=0 AND IsActive=1;
  END
  ELSE
  BEGIN
	SELECT 'Villa' RoomCount
  END
   --SELECT B.BlockName,R.BlockId,A.ApartmentNo,R.ApartmentId,R.RoomType,
   --R.RoomNo,R.RackTariff,R.DoubleOccupancyTariff,R.RoomCategory,
   --R.DiscountModePer,R.DiscountModeRS,R.DiscountAllowed,R.Id,A.SellableApartmentType
   --FROM WRBHBPropertyRooms R
   --LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON R.BlockId=B.Id
   --LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON R.ApartmentId=A.Id
   --WHERE R.Id=@Id;
   
   --SELECT B.BedRackTarrif,B.DiscountAllowed,B.DiscountModePer,
   --B.DiscountModeRS,B.Id FROM WRBHBPropertyRoomBeds B
   --WHERE RoomId=@Id;
  END 
END 