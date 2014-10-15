SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGenerationServices_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGenerationServices_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGenerationServices  Update 
Purpose  	: SSPCodeGenerationServices  Update
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGenerationServices_Update](
@SSPCodeGenerationId	BIGINT,
@ProductId				BIGINT,
@Complimentary			BIT,
@ServiceName			NVARCHAR(100),
@Price					DECIMAL(22,7),
@Enable					BIT,
@TypeService			NVARCHAR(100),
@CreatedBy				BIGINT,
@Id						BIGINT) 
AS
BEGIN
 --Update
 
	UPDATE dbo.WRBHBSSPCodeGenerationServices SET
	SSPCodeGenerationId=@SSPCodeGenerationId,
	Complimentary=@Complimentary,
	ServiceName=@ServiceName,
	Price=@Price,
	Enable=@Enable,
	ProductId=@ProductId,
	TypeService=@TypeService,	
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id
	
 
	SELECT Id,RowId FROM WRBHBSSPCodeGenerationServices WHERE Id=@Id
 
END
GO


