SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRooms_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PropertyRooms_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: PropertyRooms  Insert 
Purpose  	: PropertyRooms  Insert
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
CREATE PROCEDURE [dbo].[Sp_PropertyRooms_Insert](@PropertyId BIGINT,
@BlockId BIGINT,@ApartmentId BIGINT,@RoomType NVARCHAR(100),
@RoomNo NVARCHAR(100),@RackTariff DECIMAL(27,2),
@DoubleOccupancyTariff DECIMAL(27,2),@RoomCategory NVARCHAR(100),
@DiscountModePer BIT,@DiscountModeRS BIT,@DiscountAllowed DECIMAL(27,2),
@CreatedBy BIGINT,@RoomStatus NVARCHAR(100))--@BlockName NVARCHAR(100),@ApartmentNo NVARCHAR(100),
AS
BEGIN
IF EXISTS(SELECT NULL FROM  WRBHBPropertyRooms WHERE UPPER(RoomNo)=UPPER(@RoomNo) AND PropertyId =@PropertyId 
AND BlockId=@BlockId AND ApartmentId=@ApartmentId and IsActive=1 and IsDeleted=0)
BEGIN 
SELECT 'ALREADY EXISTS';
END 
ELSE
BEGIN
 INSERT INTO WRBHBPropertyRooms(PropertyId,BlockId,ApartmentId,
 --BlockName,ApartmentNo,
 RoomType,RoomNo,RackTariff,DoubleOccupancyTariff,RoomCategory,
 DiscountModePer,DiscountModeRS,DiscountAllowed,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,RoomStatus)
 VALUES(@PropertyId,@BlockId,@ApartmentId,--@BlockName,@ApartmentNo,
 @RoomType,@RoomNo,@RackTariff,@DoubleOccupancyTariff,@RoomCategory,
 @DiscountModePer,@DiscountModeRS,@DiscountAllowed,
 @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@RoomStatus);
 SELECT Id,RowId FROM WRBHBPropertyRooms WHERE Id=@@IDENTITY;
END 
END
GO
