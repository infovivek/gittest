SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExpenseMaster_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ExpenseMaster_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: EXPENSE MASTER Update
Purpose  	: EXPENSE Update
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
CREATE PROCEDURE [dbo].[Sp_ExpenseMaster_Update]
(
@ExpenseGroupId BIGINT,
@ExpenseHead    VARCHAR(100),
@Status			VARCHAR(100),
@CreatedBy		BIGINT,
@Id				BIGINT
)
AS
BEGIN

	Update WRBHBExpenseHeads SET HeaderName=@ExpenseHead,ExpenseGroupId=@ExpenseGroupId,Status=@Status,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() WHERE Id=@Id
	

SELECT Id,Rowid FROM WRBHBExpenseHeads WHERE Id=@Id;
END
