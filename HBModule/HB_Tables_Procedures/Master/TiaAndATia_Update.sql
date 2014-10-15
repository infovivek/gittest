
GO
/****** Object:  StoredProcedure [dbo].[Sp_Tia&ATia_Update]    Script Date: 07/07/2014 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TiaAndATia_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TiaAndATia_Update
GO

/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TiaAndATia_Update
		Purpose  	: TiaAndATia_Update
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
CREATE PROCEDURE [dbo].[Sp_TiaAndATia_Update]
(
@PropertyId			BIGINT,
@OwnerId			BIGINT,
@AdjustmentAmount	BIGINT,
@Description		NVARCHAR(MAX),
@AdjustmentType     NVARCHAR(100),
@AdjustmentCategory	NVARCHAR(100),
@AdjustmentMonth	NVARCHAR(100),
@CreatedBy			INT,
@Flag				BIT,
@Id					BIGINT
) 
AS
BEGIN
UPDATE WRBHBTiaAndNTia SET PropertyId=@PropertyId,OwnerId=@OwnerId,AdjustmentAmount=@AdjustmentAmount,
		Description=@Description,AdjustmentType=@AdjustmentType,AdjustmentCategoryId=@AdjustmentCategory,
		AdjustmentMonth=@AdjustmentMonth,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Flag=@Flag
		WHERE Id=@Id
		
 SELECT Id,RowId FROM WRBHBTiaAndNTia WHERE Id=@Id;		
END
