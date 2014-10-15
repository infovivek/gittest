SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExpenseMaster_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ExpenseMaster_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: EXPENSE MASTER INSERT
Purpose  	: EXPENSE INSERT
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
CREATE PROCEDURE [dbo].[Sp_ExpenseMaster_Insert]
(
@ExpenseGroupId BIGINT,
@ExpenseHead    VARCHAR(100),
@Status			VARCHAR(100),
@CreatedBy		BIGINT
)
AS
BEGIN
DECLARE @Identity int
	INSERT INTO WRBHBExpenseHeads(HeaderName,HeaderType,ExpenseGroupId,Status,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@ExpenseHead,0,@ExpenseGroupId,@Status,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())

SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBExpenseHeads WHERE Id=@Identity;
END
