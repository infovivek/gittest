 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmissionCheque_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmissionCheque_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/08/2014)  >
		Section  	: BTC SUBMISSION Cheque INSERT
		Purpose  	: Cheque INSERT
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
CREATE PROCEDURE [dbo].[Sp_BTCSubmissionCheque_Insert]
(
@Amount				DECIMAL(27,2),
@ChequeNo			NVARCHAR(100),
@Bank				NVARCHAR(100),
@IssueDate			DATETIME,
@Comments			NVARCHAR(100),
@CreatedBy			INT,
@Mode				NVARCHAR(100)
) 
AS
BEGIN
INSERT INTO WRBHBBTCSubmissionCheque(Amount,ChequeNo,BankName,DateIssued,Comments,IsActive,IsDeleted,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate,RowId,Mode)
VALUES (@Amount,@ChequeNo,@Bank,@IssueDate,@Comments,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode)
		
 SELECT Id,RowId FROM WRBHBBTCSubmissionCheque WHERE Id=@@IDENTITY;		
END		