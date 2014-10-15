SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[Sp_PropertyRoomBeds_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PropertyRoomBeds_Insert]
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
arun			20/6/14			Histroy				BedNO Bug fixed		
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_PropertyRoomBeds_Insert]
(@DiscountAllowed DECIMAL(27,2),@BedRackTarrif DECIMAL(27,2),
@DiscountModePer BIT,@DiscountModeRS BIT,@RoomId BIGINT,@CreatedBy BIGINT) 
AS
BEGIN
DECLARE @BedName BIGINT;
SET @BedName=(SELECT TOP 1 ISNULL(BedNO,0) FROM WRBHBPropertyRoomBeds WHERE RoomId=@RoomId ORDER BY Id DESC)
--select @BedName
IF ISNULL(@BedName,0)=0
BEGIN
SET @BedName=1;
END
ELSE
BEGIN
SET @BedName=@BedName+1
END
--select @BedName
 INSERT INTO WRBHBPropertyRoomBeds(DiscountModePer,DiscountModeRS,
 DiscountAllowed,BedRackTarrif,RoomId,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,BedNO)
 VALUES(@DiscountModePer,@DiscountModeRS,@DiscountAllowed,@BedRackTarrif,
 @RoomId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@BedName);
 
 SELECT Id,RowId FROM WRBHBPropertyRoomBeds WHERE Id = @@IDENTITY;
END
GO
