SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatus_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatus_Update

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

CREATE PROCEDURE Sp_PettyCashStatus_Update
(
@PettyCashStatusHdrId INT,
@ExpenseHead    NVARCHAR(100),
@Status		    NVARCHAR(100),
@Description	NVARCHAR(100),
@Amount         DECIMAL(27,2),
@Paid		    DECIMAL(27,2),
@PropertyId     BIGINT,
@BillLogo       NVARCHAR(1000),
@ExpenseId		BIGINT,
@BillDate       NVARCHAR(1000),
@UserId		    BIGINT,
@Id				INT
)
AS

BEGIN

	UPDATE WRBHBPettyCashStatus SET PettyCashStatusHdrId=@PettyCashStatusHdrId,
	ExpenseHead=@ExpenseHead,Status=@Status,PropertyId=@PropertyId,UserId=@UserId,
	Description=@Description,Amount=@Amount,Paid=@Paid,BillDate=@BillDate,BillLogo=@BillLogo,
	Modifiedby=@UserId,ModifiedDate=GETDATE()
	WHERE Id=@Id 
	
	
SELECT Id,RowId FROM WRBHBPettyCashStatus WHERE Id=@Id;
END