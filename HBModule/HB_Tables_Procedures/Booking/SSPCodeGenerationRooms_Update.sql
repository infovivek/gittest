SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGenerationRooms_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGenerationRooms_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGenerationRooms  Update 
Purpose  	: SSPCodeGenerationRooms  Update
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGenerationRooms_Update](
@SSPCodeGenerationId		BIGINT,
@RoomNo						NVARCHAR(100),
@RoomId						BIGINT,
@SingleTariff				DECIMAL(22,7),
@DoubleTariff				DECIMAL(22,7),
@CreatedBy					BIGINT,
@Id							BIGINT) 
AS
BEGIN
 --INSERT
 
	UPDATE dbo.WRBHBSSPCodeGenerationRooms SET 
	RoomId=@RoomId,
	SSPCodeGenerationId=@SSPCodeGenerationId,
	RoomNo=@RoomNo,
	SingleTariff=@SingleTariff,
	DoubleTariff=@DoubleTariff,	
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id
	SELECT Id,RowId FROM WRBHBSSPCodeGenerationRooms WHERE Id=@Id
 
END
GO


