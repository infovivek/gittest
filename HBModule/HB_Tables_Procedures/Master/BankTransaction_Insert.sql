 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BankTransaction_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BankTransaction_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: COMPANY MASTER INSERT
		Purpose  	: LOGO INSERT
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
CREATE PROCEDURE [dbo].[Sp_BankTransaction_Insert]
(
@AccountNumber		NVARCHAR(100),
@TransactionDate	NVARCHAR(100),
--@ValueDate			NVARCHAR(100),
@Description		NVARCHAR(MAX),
@RefNo				NVARCHAR(100),
--@BranchCode			NVARCHAR(100),
@Credit				DECIMAL(27,2),
@CreatedBy			BIGINT
) 
AS
BEGIN
	IF(@Credit!=0.00)
	BEGIN
	
	 IF EXISTS(SELECT Id FROM WRBHBBankTransaction WHERE IsActive=1 AND 
              TransactionDate=@TransactionDate AND RefNo=@RefNo and Description= @Description)
       Begin
			-- SELECT 'Already Exists.' AS Msg;
			Update WRBHBBankTransaction set ModifiedDate= GETDATE()
			 WHERE IsActive=1 AND TransactionDate=@TransactionDate AND RefNo=@RefNo and Description= @Description  
		End
		Else
		Begin
			INSERT INTO WRBHBBankTransaction(AccountNumber,TransactionDate,Description,RefNo,Credit,
				IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,BalanceAmount)
			VALUES (@AccountNumber,@TransactionDate,@Description,@RefNo,@Credit,1,0,@CreatedBy,GETDATE(),
			@CreatedBy,GETDATE(),NEWID(),0.00)
		End
		--SELECT Id,RowId FROM WRBHBBankTransaction WHERE Id=@@IDENTITY;		
	END 
END		