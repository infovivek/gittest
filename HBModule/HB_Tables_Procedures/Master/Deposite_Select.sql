SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Deposite_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_Deposite_Select
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (25/07/2014)  >
Section  	: Deposite Select
Purpose  	: Deposite Select
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
CREATE PROCEDURE Sp_Deposite_Select
(
@Mode		NVARCHAR(100),
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@Id			INT,
@UserId		INT
)
AS
BEGIN
IF @Mode='Cash'
	BEGIN
	IF @FromDate='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cash' AND D.IsActive=1	AND D.IsDeleted=0  AND MONTH(D.DepositedDate) = MONTH(GETDATE())
		END	
	IF @FromDate!='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cash' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate>=CONVERT(NVARCHAR(103),@FromDate,103)
		END	
	IF @FromDate!='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cash' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate BETWEEN CONVERT(DATETIME,@FromDate,103) AND CONVERT(DATETIME,@ToDate,103)
		END
	IF @FromDate='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cash' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate < CONVERT(DATETIME,@ToDate,103)
		END
	END
	IF @Mode='Cheque'
	BEGIN
	IF @FromDate='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cheque' AND D.IsActive=1	AND D.IsDeleted=0  AND MONTH(D.DepositedDate) = MONTH(GETDATE())
		END	
	IF @FromDate!='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cheque' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate>=CONVERT(NVARCHAR(103),@FromDate,103)
		END	
	IF @FromDate!='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cheque' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate BETWEEN CONVERT(DATETIME,@FromDate,103) AND CONVERT(DATETIME,@ToDate,103)
		END
	IF @FromDate='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='Cheque' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate < CONVERT(DATETIME,@ToDate,103)
		END	
	END
	IF @Mode='BTC'
	BEGIN
	IF @FromDate='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,D.BTCTo,BTCMode,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='BTC' AND D.IsActive=1	AND D.IsDeleted=0  AND MONTH(D.DepositedDate) = MONTH(GETDATE())
		END	
	IF @FromDate!='' AND @ToDate=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,D.BTCTo,BTCMode,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='BTC' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate>=CONVERT(NVARCHAR(103),@FromDate,103)
		END	
	IF @FromDate!='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,D.BTCTo,BTCMode,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='BTC' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate BETWEEN CONVERT(DATETIME,@FromDate,103) AND CONVERT(DATETIME,@ToDate,103)
		END
	IF @FromDate='' AND @ToDate!=''
		BEGIN
			SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,Amount,D.BTCTo,BTCMode,
			Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
			JOIN WRBHBUser U ON U.Id=D.DepositedBy
			where Mode='BTC' AND D.IsActive=1	AND D.IsDeleted=0  AND 
			D.DepositedDate < CONVERT(DATETIME,@ToDate,103)
		END	
END		
END

