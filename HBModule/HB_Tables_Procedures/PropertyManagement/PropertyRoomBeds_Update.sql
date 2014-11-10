 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRoomBeds_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyRoomBeds_Update]
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
	arun			20/6/14			Histroy				History management for RoomBeds added		
	*******************************************************************************************************
*/
CREATE PROCEDURE [Sp_PropertyRoomBeds_Update] (
@DiscountAllowed		 DECIMAL(27,2),
@BedRackTarrif	        DECIMAL(27,2),  
@DiscountModePer		BIT,
@DiscountModeRS  		BIT, 
@RoomId                 BIGINT,
@CreatedBy				BIGINT,
@Id                     BIGINT ,
@BedName				NVARCHAR(100)
) 
AS
BEGIN
--DECLARE @BedName BIGINT;
--SET @BedName=(SELECT TOP 1 ISNULL(BedNO,0) FROM WRBHBPropertyRoomBeds WHERE RoomId=@RoomId ORDER BY Id DESC)
----select @BedName
--IF ISNULL(@BedName,0)=0
--BEGIN
--SET @BedName=1;
--END 
--ELSE
--BEGIN
--SET @BedName=@BedName+1
--END
--select @BedName
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=0,@IsDeleted=0;
--INSERT


INSERT INTO WRBHBPropertyRoomBedsHistory(RoomBedsId,DiscountModePer,DiscountModeRS,
 DiscountAllowed,BedRackTarrif,RoomId,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,BedNO)
 SELECT Id,DiscountModePer,DiscountModeRS,
 DiscountAllowed,BedRackTarrif,RoomId,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,BedNO 
 FROM WRBHBPropertyRoomBeds
 WHERE Id=@Id
 
UPDATE WRBHBPropertyRoomBeds SET  
DiscountModePer=@DiscountModePer,
DiscountModeRS=@DiscountModeRS,
DiscountAllowed=@DiscountAllowed,
BedRackTarrif=@BedRackTarrif,
RoomId=@RoomId,
BedNO=@BedName,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;


 
 SELECT Id,RowId FROM WRBHBPropertyRoomBeds WHERE Id = @RoomId;
 END

GO
