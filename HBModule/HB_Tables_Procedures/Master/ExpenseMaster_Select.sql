SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExpenseMaster_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ExpenseMaster_Select]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (22/04/2014)  >
Section  	: Expense MASTER SELECT
Purpose  	: Expense MASTER SELECT
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
CREATE PROCEDURE Sp_ExpenseMaster_Select
(
@Id BIGINT
)
AS
BEGIN
--IF(@Id=0)
--BEGIN
  
--END

IF(@Id!=0)
BEGIN
	select HG.ExpenseHead as ExpenseGroup,HeaderName as ExpenseHead,Status,H.Id,H.ExpenseGroupId as ExpenseGroupId
	from WRBHBExpenseHeads H
JOIN WRBHBExpenseGroup HG ON H.ExpenseGroupId=HG.Id WHERE H.Id=@Id
END
END

