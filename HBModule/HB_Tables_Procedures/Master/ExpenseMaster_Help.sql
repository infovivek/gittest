SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExpenseMaster_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ExpenseMaster_Help]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: EXPENSE MASTER HELP
Purpose  	: EXPENSE HELP
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
CREATE PROCEDURE [dbo].[Sp_ExpenseMaster_Help]
(
@Action NVARCHAR(100),
--@Str NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT
)
AS
BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	--Expanse Group
  SELECT Id as Id,ExpenseHead as ExpenseGroup FROM WRBHBExpenseGroup
	
	
	---GridLoad
	
select HG.ExpenseHead as ExpenseGroup,HeaderName,Status,H.Id from WRBHBExpenseHeads H
JOIN WRBHBExpenseGroup HG ON H.ExpenseGroupId=HG.Id
 END
END
