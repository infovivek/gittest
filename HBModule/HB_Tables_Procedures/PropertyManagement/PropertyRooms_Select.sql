SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRooms_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PropertyRooms_Select]
GO 
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	:  PropertyRooms Select
Purpose  	: PROPERTY room SEARCH
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
CREATE PROCEDURE [dbo].[Sp_PropertyRooms_Select](@SelectId BIGINT,
@Pram1 BIGINT,@Pram2 NVARCHAR(100),@UserId BIGINT)
AS
BEGIN
 IF @Pram1 <> 0  
  BEGIN
   SELECT B.BlockName,R.BlockId,A.ApartmentNo,R.ApartmentId,R.RoomType,
   R.RoomNo,R.RackTariff,R.DoubleOccupancyTariff,R.RoomCategory,RoomStatus,
   R.DiscountModePer,R.DiscountModeRS,R.DiscountAllowed,R.Id,A.SellableApartmentType
   FROM WRBHBPropertyRooms R
   LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON R.BlockId=B.Id
   LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON R.ApartmentId=A.Id
   WHERE R.Id=@Pram1;
   
   SELECT B.BedRackTarrif,B.DiscountAllowed,B.DiscountModePer,
   B.DiscountModeRS,B.Id,B.BedNO BedName FROM WRBHBPropertyRoomBeds B
   WHERE RoomId=@Pram1;
      
  END	
 IF @Pram1 = 0
  BEGIN
   SELECT R.RoomType,R.RoomNo,R.RoomCategory,R.Id,A.ApartmentNo,b.BlockName,RoomStatus
   FROM WRBHBPropertyRooms R
   LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON R.BlockId=B.Id
   LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON R.ApartmentId=A.Id
   WHERE R.IsDeleted=0 AND R.IsActive=1 AND R.PropertyId=@SelectId;
  END
END
GO
