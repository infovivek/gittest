SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatus_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatus_Insert

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (28/06/2014)  >
Section  	: PETTYCASH STATUS HELP
Purpose  	: PETTYCASH STATUS HELP
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

CREATE PROCEDURE Sp_PettyCashStatus_Insert
(
@ExpenseHead NVARCHAR(100),
@Status		 NVARCHAR(100),
@Description		 NVARCHAR(100),
@Amount         DECIMAL(27,2),
@Paid		DECIMAL(27,2),
--@PropertyId BIGINT,
@Id			 BIGINT,
@UserId		 BIGINT
)
AS

BEGIN

	UPDATE WRBHBPettyCashStatus SET ExpenseHead=@ExpenseHead,Status=@Status,
	 Description=@Description,Amount=@Amount,Paid=@Paid,Modifiedby=@UserId,
	 ModifiedDate=GETDATE()
	 WHERE Id=@Id 
	
	
SELECT Id,RowId FROM WRBHBPettyCashStatus WHERE Id=@Id;
END