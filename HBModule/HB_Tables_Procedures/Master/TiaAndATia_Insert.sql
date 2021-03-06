
GO
/****** Object:  StoredProcedure [dbo].[Sp_Tia&ATia_Insert]    Script Date: 07/07/2014 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TiaAndATia_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TiaAndATia_Insert
GO

/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TiaAndATia_Insert
		Purpose  	: TiaAndATia_Insert
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
CREATE PROCEDURE [dbo].[Sp_TiaAndATia_Insert]
(
@PropertyId			BIGINT,
@OwnerId			BIGINT,
@AdjustmentAmount	BIGINT,
@Description		NVARCHAR(MAX),
@AdjustmentType     NVARCHAR(100),
@AdjustmentCategory	NVARCHAR(100),
@AdjustmentMonth	NVARCHAR(100),
@CreatedBy			INT,
@Flag				BIT
) 
AS
BEGIN
INSERT INTO WRBHBTiaAndNTia(PropertyId,OwnerId,AdjustmentAmount,Description,AdjustmentType,AdjustmentCategoryId,
							AdjustmentMonth,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Flag)
VALUES (@PropertyId,@OwnerId,@AdjustmentAmount,@Description,@AdjustmentType,@AdjustmentCategory,@AdjustmentMonth,
		1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Flag)
		
 SELECT Id,RowId FROM WRBHBTiaAndNTia WHERE Id=@@IDENTITY;		
END
