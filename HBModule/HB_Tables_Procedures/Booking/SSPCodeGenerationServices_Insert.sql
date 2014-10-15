SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGenerationServices_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGenerationServices_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGenerationServices  Insert 
Purpose  	: SSPCodeGenerationServices  Insert
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGenerationServices_Insert](
@SSPCodeGenerationId	BIGINT,
@ProductId				BIGINT,
@Complimentary			BIT,
@ServiceName			NVARCHAR(100),
@Price					DECIMAL(22,7),
@Enable					BIT,
@TypeService			NVARCHAR(100),
@CreatedBy				BIGINT) 
AS
BEGIN
 --INSERT
 
	INSERT INTO dbo.WRBHBSSPCodeGenerationServices(SSPCodeGenerationId,Complimentary,ServiceName,
	Price,Enable,ProductId,TypeService,CreatedBy,CreatedDate,
	ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId) 
	VALUES
	(@SSPCodeGenerationId,@Complimentary,@ServiceName,
	@Price,@Enable,@ProductId,@TypeService,
	@CreatedBy,GETDATE(),@CreatedBy, GETDATE(),1,0,NEWID())
 
	SELECT Id,RowId FROM WRBHBSSPCodeGenerationServices WHERE Id=@@IDENTITY
 
END
GO


