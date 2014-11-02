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
@BillLogo       NVARCHAR(1000),
@ExpenseId		BIGINT,
@BillDate       NVARCHAR(1000),
@BillNo			NVARCHAR(1000),
@UserId		    BIGINT,
@Id				INT
)
AS

BEGIN

	UPDATE WRBHBPettyCashStatus SET PettyCashStatusHdrId=@PettyCashStatusHdrId,
	ExpenseHead=@ExpenseHead,Status=@Status,UserId=@UserId,
	Description=@Description,Amount=@Amount,Paid=@Paid,BillDate=@BillDate,
	Balance=@Amount-@Paid,BillLogo=@BillLogo,Flag=1,
	BillNo=@Billno,Modifiedby=@UserId,ModifiedDate=GETDATE()
	WHERE Id=@Id 
	
	DECLARE @Pr INT
	SET @Pr=(SELECT PropertyId FROM WRBHBPettyCashStatusHdr
	WHERE Id=@PettyCashStatusHdrId)
	UPDATE WRBHBPettyCashStatus SET PropertyId=@Pr
	WHERE PettyCashStatusHdrId=@PettyCashStatusHdrId
	
	DECLARE @Bal DECIMAL(27,2)
	SET @Bal=(SELECT SUM(Balance)
	FROM WRBHBPettyCashStatus 
	WHERE PettyCashStatusHdrId=@PettyCashStatusHdrId AND IsActive=1 AND IsDeleted=0)
	UPDATE WRBHBPettyCashStatusHdr SET Balance=@Bal
	WHERE Id=@PettyCashStatusHdrId
	
	UPDATE WRBHBPettyCashHdr SET ClosingBalance=@Bal,ExpenseReport=1
	WHERE UserId=@UserId AND PropertyId=@Pr AND
	Convert(NVARCHAR(100),Date,103)=@Status
	
	UPDATE WRBHBPettyCashApprovalDtl SET Process=0
	WHERE RequestedUserId=@UserId AND PropertyId=@Pr AND 
	CONVERT(NVARCHAR,RequestedOn,103)=CONVERT(NVARCHAR,@Status,103)
		
	UPDATE WRBHBNewPettyCashApprovalDtl SET Process=0,IsActive=0,IsDeleted=1
	WHERE RequestedUserId=@UserId AND PropertyId=@Pr AND 
	CONVERT(NVARCHAR,RequestedOn,103)=CONVERT(NVARCHAR,@Status,103)
	
SELECT Id,RowId FROM WRBHBPettyCashStatus WHERE Id=@Id;
END



  