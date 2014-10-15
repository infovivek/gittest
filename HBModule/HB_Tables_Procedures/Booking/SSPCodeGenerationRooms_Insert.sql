SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGenerationRooms_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGenerationRooms_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGenerationRooms  Insert 
Purpose  	: SSPCodeGenerationRooms  Insert
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGenerationRooms_Insert](
@SSPCodeGenerationId		BIGINT,
@RoomNo						NVARCHAR(100),
@RoomId						BIGINT,
@SingleTariff				DECIMAL(22,7),
@DoubleTariff				DECIMAL(22,7),
@CreatedBy					BIGINT) 
AS
BEGIN
 --INSERT
 
	INSERT INTO dbo.WRBHBSSPCodeGenerationRooms(RoomId,SSPCodeGenerationId,RoomNo,
	SingleTariff,DoubleTariff,CreatedBy,CreatedDate,
	ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId) 
	VALUES
	(@RoomId,@SSPCodeGenerationId,@RoomNo,@SingleTariff,@DoubleTariff,
	@CreatedBy,GETDATE(),@CreatedBy, GETDATE(),1,0,NEWID())
 
	SELECT Id,RowId FROM WRBHBSSPCodeGenerationRooms WHERE Id=@@IDENTITY
 
END
GO


