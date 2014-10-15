SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Reconcile_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_Reconcile_Select
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (27/06/2014)  >
Section  	: Reconcile SELECT
Purpose  	: Reconcile SELECT
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
CREATE PROCEDURE Sp_Reconcile_Select
(
@Datefrom		NVARCHAR(100),
@DateTo			NVARCHAR(100),
@TransactionId	NVARCHAR(100),
@ChequeNo		NVARCHAR(100),
@Id				INT,
@Type			NVARCHAR(100),
@Mode			NVARCHAR(100)
)
AS
BEGIN

IF @Mode='Bank'
BEGIN
	--For No Parameter Value
	IF @Datefrom='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo=''
	BEGIN
		SELECT ValueDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount,RefNo as ChequeNo
		FROM WRBHBBankTransaction
		WHERE IsActive=1 AND IsDeleted=0
	END

	--ONLY FROM DATE IS GIVEN
	IF @Datefrom!='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo=''
	BEGIN
		SELECT ValueDate,CONVERT(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount FROM WRBHBBankTransaction
		WHERE CONVERT(DATETIME,CreatedDate,103) between CONVERT(DATETIME,@Datefrom,103) and
		CONVERT(DATETIME,GETDATE(),103)
	END

	--ONLY TRANSACTION ID IS GIVEN
	IF @Datefrom='' AND @DateTo='' AND @TransactionId!='' AND @ChequeNo=''
	BEGIN
		SELECT ValueDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount FROM WRBHBBankTransaction
		--WHERE --Convert(NVARCHAR,Id)+'-'+TransactionDate 
		--ValueDate LIKE '1'
	END
	--ONLY CHEQUE NO IS GIVEN
	IF @Datefrom='' AND @DateTo='' AND @TransactionId!='' AND @ChequeNo!=''
	BEGIN
		SELECT ValueDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount,RefNo as ChequeNo 
		FROM WRBHBBankTransaction WHERE RefNo=@ChequeNo AND IsActive=1 AND IsDeleted=0
	END
END
IF @Mode='Bill'
	BEGIN
	IF(@Type='BTC')
	BEGIN
		SELECT AmountPaid FROM WRBHBChechkOutPaymentCompanyInvoice
		WHERE IsActive=1 AND IsDeleted=0
	END
	--For No Parameter Value
IF @Datefrom='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo=''
	--ONLY FROM DATE IS GIVEN
IF @Datefrom!='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo=''
	BEGIN
		SELECT CI.AmountPaid,Ch.CheckOutDate 
		FROM WRBHBChechkOutPaymentCompanyInvoice CI
		JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
		WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
		CONVERT(DATETIME,CI.CreatedDate,103) between CONVERT(DATETIME,@Datefrom,103) and
		CONVERT(DATETIME,GETDATE(),103)
	END

	--ONLY TRANSACTION ID IS GIVEN
IF @Datefrom='' AND @DateTo='' AND @TransactionId!='' AND @ChequeNo=''
	BEGIN
		SELECT ValueDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount FROM WRBHBBankTransaction
		--WHERE --Convert(NVARCHAR,Id)+'-'+TransactionDate 
		--ValueDate LIKE '1'
	END
	--ONLY CHEQUE NO IS GIVEN
	IF @Datefrom='' AND @DateTo='' AND @TransactionId!='' AND @ChequeNo!=''
	BEGIN
		SELECT ValueDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TxnDate,Credit AS Amount,RefNo as ChequeNo 
		FROM WRBHBBankTransaction WHERE RefNo=@ChequeNo AND IsActive=1 AND IsDeleted=0
	END
END
END


