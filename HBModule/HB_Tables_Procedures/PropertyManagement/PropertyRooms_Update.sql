 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRooms_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyRooms_Update]
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
	arun			20/6/14			Histroy				History management for Rooms added		
	*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_PropertyRooms_Update] (
@PropertyId			    BIGINT,
@BlockId				BIGINT,
--@BlockName				NVARCHAR(100), 
--@ApartmentNo		  	NVARCHAR(100),
@ApartmentId           BIGINT,
@RoomType            	NVARCHAR(100), 
@RoomNo    			    NVARCHAR(100),
@RackTariff				DECIMAL(27,2),
@DoubleOccupancyTariff	DECIMAL(27,2), 
@RoomCategory		    NVARCHAR(100),  
@DiscountModePer		BIT,
@DiscountModeRS			BIT, 
@DiscountAllowed        DECIMAL(27,2),
@CreatedBy				BIGINT,
@RoomStatus				NVARCHAR(100),
@Id                     BIGINT 
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=0,@IsDeleted=0;


--HISTORY MANAGEMENT
	INSERT INTO WRBHBPropertyRoomsHistory(RoomsId,PropertyId,BlockId,ApartmentId,
	--BlockName,ApartmentNo,
	RoomType,RoomNo,RackTariff,DoubleOccupancyTariff,RoomCategory,
	DiscountModePer,DiscountModeRS,DiscountAllowed,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
	SELECT Id,PropertyId,BlockId,ApartmentId,
	--BlockName,ApartmentNo,
	RoomType,RoomNo,RackTariff,DoubleOccupancyTariff,RoomCategory,
	DiscountModePer,DiscountModeRS,DiscountAllowed,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId 
	FROM WRBHBPropertyRooms
	WHERE Id=@Id
 
 --UPDATE
	UPDATE WRBHBPropertyRooms SET 
	PropertyId=@PropertyId,
	BlockId=@BlockId,
	ApartmentId=@ApartmentId,
	RoomType= @RoomType,
	RoomNo=@RoomNo,
	RackTariff=@RackTariff,
	DoubleOccupancyTariff=@DoubleOccupancyTariff,
	RoomCategory=@RoomCategory,
	DiscountModePer=@DiscountModePer,
	DiscountModeRS=@DiscountModeRS,
	DiscountAllowed=@DiscountAllowed,
	RoomStatus=@RoomStatus,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id

	SELECT Id,RowId FROM WRBHBPropertyRooms WHERE Id=@Id;

 END

GO
