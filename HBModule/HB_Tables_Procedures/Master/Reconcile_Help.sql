SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Reconcile_Help]')
 AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Reconcile_Help]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: REGISTRATION HELP
Purpose  	: REGISTRATION HELP
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/************************************************************************* 
*				AMENDMENT BLOCK
**************************************************************************** 
'Name			Date			Signature			Description of Changes
**************************************************************************** 
**************************************************************************** 
*/
CREATE PROCEDURE Sp_Reconcile_Help
(
@Action         NVARCHAR(100),
@Datefrom		NVARCHAR(100),
@DateTo			NVARCHAR(100),
@TransactionId	NVARCHAR(100),
@ChequeNo		NVARCHAR(100),
@PropertyId				INT,
@ClientId				INT,
@Type			NVARCHAR(100),
@Mode			NVARCHAR(100)
)
AS 
BEGIN 
IF @Action='PAGELOAD'
BEGIN
		SELECT  ClientName AS Client, Id as Id FROM WRBHBClientManagement WHERE IsActive=1 AND IsDeleted=0
		order by ClientName
		
		SELECT DISTINCT PropertyName as Property,Id as Id FROM WRBHBProperty WHERE IsActive=1 AND IsDeleted=0
		order by PropertyName
END
IF @Action ='CASHSEARCH'
BEGIN 
IF @Mode='Bank' 
BEGIN 
	 Create Table #BankTransact(NumberDate nvarchar(100),TransId Nvarchar(100),Amount Decimal(27,2),
	                        ChequeNo nvarchar(200),TransactionID Bigint,ReconcileAmt Decimal(27,2),
	                        AmttobeReconciled Decimal(27,2),Billchecks nvarchar(100))
		 
	IF @Datefrom='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo=''
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0)  as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction
		WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END 
	IF @Datefrom !='' AND @DateTo !='' AND @TransactionId='' AND @ChequeNo=''
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0)  as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction
		WHERE CONVERT(DATETIME,TransactionDate,103) between CONVERT(DATETIME,@Datefrom,103) and
		CONVERT(DATETIME,@DateTo,103) AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END
	IF @Datefrom ='' AND @DateTo='' AND @TransactionId !='' AND @ChequeNo=''
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0)  as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction
		WHERE Id=@TransactionId AND IsActive=1 AND IsDeleted=0 AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END
	IF @Datefrom ='' AND @DateTo='' AND @TransactionId ='' AND @ChequeNo !=''
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0)  as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction WHERE RefNo=@ChequeNo AND IsActive=1 
		AND IsDeleted=0 AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END
	 
	IF @Datefrom ='' AND @DateTo ='' AND @TransactionId !='' AND @ChequeNo !='' 
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0) as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction
		WHERE IsActive=1 AND IsDeleted=0 AND Id=@TransactionId AND @ChequeNo=@ChequeNo
		AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END
	 	IF @Datefrom !='' AND @DateTo !='' AND @TransactionId !='' AND @ChequeNo !='' 
	BEGIN
	 Insert into #BankTransact(NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,Billchecks)
		SELECT TransactionDate NumberDate,Convert(NVARCHAR,Id)+'-'+TransactionDate AS TransId,
		Credit AS Amount,RefNo as ChequeNo,Id as TransactionID,
		isnull(BalanceAmount,0) as  ReconcileAmt,
		isnull(Credit,0)-(isnull(BalanceAmount,0)) as AmttobeReconciled,0 as Bankchecks
		FROM WRBHBBankTransaction
		WHERE IsActive=1 AND IsDeleted=0 AND Id=@TransactionId AND @ChequeNo=@ChequeNo
		and  CONVERT(DATETIME,TransactionDate,103) between CONVERT(DATETIME,@Datefrom,103) and
		CONVERT(DATETIME,@DateTo,103)
		AND ISNULL(Credit,0)!= ISNULL(BalanceAmount,0)
	END
	UPDATE #BankTransact SET AmttobeReconciled=0 WHERE AmttobeReconciled<=0;
	 SELECT NumberDate,TransId,Amount,ChequeNo,TransactionID,ReconcileAmt,AmttobeReconciled,0 Bankchecks
	  FROM #BankTransact
	 
END
IF @Mode='Bill'
BEGIN
	IF(@Type='BTC')
	BEGIN

			--SELECT isnull(D.ChequeNo,0) Chkrefno,D.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			--D.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			--convert(nvarchar(50),getdate(),103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			--join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			--WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='BTC'
			
--SELECT ISNULL(p.InvoiceNo,''),TransactionID,TransactionNo,PayType,InvoiceAmount,TransactionAmt,TotalAmt 
--FROM WRBHBReconcilePayment P 
--WHERE P.IsActive=1 AND P.IsDeleted=0 and p.InvoiceNo like '%,%'
	 
	 Create Table #BtcChk(ChequeNo nvarchar(100),Amount Decimal(27,2),InVoiceNo Nvarchar(100),
						  AmttobeReconciled Decimal(27,2),Billchecks nvarchar(100),AmountReconcil Decimal(27,2),
						  InvoiceDate nvarchar(100),Chkrefno nvarchar(100),ClientId Bigint)
		  
		Insert into #BtcChk(ChequeNo,Amount,InVoiceNo,AmttobeReconciled,Billchecks,AmountReconcil,InvoiceDate,Chkrefno,ClientId)
		 select isnull(c.ChequeNo,0) Chkrefno,c.Amount Amount,ISNULL(H.InVoiceNo,0) AS InVoiceNo,
			c.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),SubmittedOnDate,103) InvoiceDate, 0 as Chkrefno ,H.ClientId
			FROM   WRBHBBTCSubmission H 
			join  WRBHBBTCSubmissionDetails D ON H.Id=D.BTCSubmissionId and d.IsActive=1 and d.IsDeleted=0
			join  WRBHBBTCSubmissionCheque C on c.id=H.Modeid and c.IsActive=1 and c.IsDeleted=0
			where h.CollectionStatus='Submitted' and h.IsActive=1 and H.IsDeleted=0;
			
		Insert into #BtcChk(ChequeNo,Amount,InVoiceNo,AmttobeReconciled,Billchecks,AmountReconcil,InvoiceDate,Chkrefno,ClientId)
		select isnull(c.ReferenceNo,0) Chkrefno,c.Amount Amount,ISNULL(H.InVoiceNo,0) AS InVoiceNo,
			c.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),SubmittedOnDate,103) InvoiceDate, 0 as Chkrefno ,H.ClientId
			FROM   WRBHBBTCSubmission H 
			join  WRBHBBTCSubmissionDetails D ON H.Id=D.BTCSubmissionId and d.IsActive=1 and d.IsDeleted=0
			join  WRBHBBTCSubmissionNEFT C on c.id=H.Modeid and c.IsActive=1 and c.IsDeleted=0
			where h.CollectionStatus='Submitted' and h.IsActive=1 and H.IsDeleted=0;
			
		Insert into #BtcChk(ChequeNo,Amount,InVoiceNo,AmttobeReconciled,Billchecks,AmountReconcil,InvoiceDate,Chkrefno,ClientId)
		select isnull(c.CardNumber,0) Chkrefno,c.Amount Amount,ISNULL(H.InVoiceNo,0) AS InVoiceNo,
			c.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),SubmittedOnDate,103) InvoiceDate, 0 as Chkrefno ,H.ClientId
			FROM   WRBHBBTCSubmission H 
			join  WRBHBBTCSubmissionDetails D ON H.Id=D.BTCSubmissionId and d.IsActive=1 and d.IsDeleted=0
			join  WRBHBBTCSubmissionCard C on c.id=H.Modeid and c.IsActive=1 and c.IsDeleted=0
			where h.CollectionStatus='Submitted' and h.IsActive=1 and H.IsDeleted=0;
			
		Insert into #BtcChk(ChequeNo,Amount,InVoiceNo,AmttobeReconciled,Billchecks,AmountReconcil,InvoiceDate,Chkrefno,ClientId)
		select isnull(0,0) Chkrefno,c.Amount Amount,ISNULL(H.InVoiceNo,0) AS InVoiceNo,
			c.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),SubmittedOnDate,103) InvoiceDate, 0 as Chkrefno ,H.ClientId
			FROM   WRBHBBTCSubmission H 
			join  WRBHBBTCSubmissionDetails D ON H.Id=D.BTCSubmissionId and d.IsActive=1 and d.IsDeleted=0
			join  WRBHBBTCSubmissionCash C on c.id=H.Modeid and c.IsActive=1 and c.IsDeleted=0
			where h.CollectionStatus='Submitted' and h.IsActive=1 and H.IsDeleted=0;
			 
			
	 IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			 Select ChequeNo,Amount,InVoiceNo,AmttobeReconciled,0 as Billchecks,AmountReconcil,InvoiceDate,Chkrefno
			 from #BtcChk
			 where    InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		End
	 IF @Datefrom! ='' AND @DateTo!='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			 Select ChequeNo,Amount,InVoiceNo,AmttobeReconciled,0 Billchecks,AmountReconcil,InvoiceDate,Chkrefno
			 from #BtcChk where 
			 CONVERT(DATE,InvoiceDate,103) between CONVERT(nvarchar(50),@Datefrom,103) and
			CONVERT(nvarchar(50),@DateTo,103)
			AND  InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		End
		IF @Datefrom ='' AND @DateTo=''   AND @ClientId!='' AND @ChequeNo=''
		BEGIN
			 Select ChequeNo,Amount,InVoiceNo,AmttobeReconciled,0 Billchecks,AmountReconcil,InvoiceDate,Chkrefno
			 from #BtcChk where  ClientId=@ClientId
			AND  InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		End
		IF @Datefrom !='' AND @DateTo!=''   AND @ClientId!='' AND @ChequeNo=''
		BEGIN
			 Select ChequeNo,Amount,InVoiceNo,AmttobeReconciled,0 Billchecks,AmountReconcil,InvoiceDate,Chkrefno
			 from #BtcChk where  ClientId=@ClientId and
			 CONVERT(DATE,InvoiceDate,103) between CONVERT(nvarchar(50),@Datefrom,103) and
			CONVERT(nvarchar(50),@DateTo,103)
			AND  InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		End
		IF @Datefrom !='' AND @DateTo!=''   AND @ClientId !='' AND @ChequeNo!=''
		BEGIN
			 Select ChequeNo,Amount,InVoiceNo,AmttobeReconciled,0 Billchecks,AmountReconcil,InvoiceDate,Chkrefno
			 from #BtcChk where  ClientId=@ClientId and
			 CONVERT(DATE,InvoiceDate,103) between CONVERT(nvarchar(50),@Datefrom,103) and
			CONVERT(nvarchar(50),@DateTo,103)  and ChequeNo=@ChequeNo 
			AND  InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		End
		END
		 
	IF(@Type='CASH')
	BEGIN
		IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN 
			SELECT isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0 
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			 Dt.InVoiceNo NOT IN( SELECT isnull(InvoiceNo,'') FROM WRBHBReconcilePaymentRef  
			where isnull(InvoiceNo,'')!='' )
		END
	   IF @Datefrom !='' AND @DateTo!='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND PropertyId=@PropertyId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo=''
		BEGIN
			 SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash'  AND ChequeNo =@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo =''
		BEGIN
		SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash'  AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND PropertyId=@PropertyId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo =''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash'  AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(DATETIME,@Datefrom,103) and
			CONVERT(DATETIME,@DateTo,103) AND  ChequeNo=@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId !='' AND @ChequeNo =''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT( nvarchar(100) ,@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND PropertyId=@PropertyId AND Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND 
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND PropertyId=@PropertyId AND ChequeNo=@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND Dt.ClientId=@ClientId AND ChequeNo=@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
			SELECT  isnull(Dt.BIllType,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cash' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND Dt.ClientId=@ClientId AND ChequeNo =@ChequeNo
			AND PropertyId=@PropertyId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
	END

	IF(@Type='CHEQUE')
	BEGIN
		IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque'  
			AND Dt.InVoiceNo  NOT IN(  SELECT isnull(InvoiceNo,'') FROM WRBHBReconcilePaymentRef  
			where isnull(InvoiceNo,'')!=''  )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)AND Dt.InVoiceNo
			  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END 
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) and PropertyId=@PropertyId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND  Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND  Dt.InVoiceNo=@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)  AND PropertyId=@PropertyId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)  AND Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId='' AND @ChequeNo !=''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND ChequeNo=@ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId!='' AND @ChequeNo =''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND  PropertyId=@PropertyId and Dt.ClientId=@ClientId
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId! ='' AND @ClientId !='' AND @ChequeNo! =''
		BEGIN
			SELECT isnull(D.ChequeNo,0) Chkrefno,Dt.Amount Amount,ISNULL(Dt.InVoiceNo,0) AS InVoiceNo,
			Dt.Amount AS AmttobeReconciled, 0 as Billchecks,0 as AmttobeReconciled ,
			convert(nvarchar(50),DepositedDate,103) InvoiceDate, 0 as Chkrefno FROM  WRBHBDeposits D 
			join WRBHBDepositsDlts dt on D.Id=Dt.DepHdrId AND Dt.IsActive=1 AND Dt.IsDeleted=0
			WHERE D.IsActive=1 AND D.IsDeleted=0 and Mode='Cheque' AND
			CONVERT(DATE,DepositedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND  Dt.ClientId=@ClientId  
			AND  PropertyId=@PropertyId  and ChequeNo= @ChequeNo
			AND Dt.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		 
	END

	IF(@Type='CREDITCARD')
	BEGIN
	Create table #CreditCardDtls(Chkrefno nvarchar(100),Amount Decimal(27,2),InvoiceDate nvarchar(50),
	 InVoiceNo nvarchar(100),AmttobeReconciled Decimal(27,2),Billchecks int,CardType Nvarchar(100))
	 
	 Create table #CreditCardDtlsF(Chkrefno nvarchar(100),Amount Decimal(27,2),InvoiceDate nvarchar(50),
	 InVoiceNo nvarchar(100),AmttobeReconciled Decimal(27,2),Billchecks int,CardType Nvarchar(100))
	 
		IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN 
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 
			AND CH.InVoiceNo  NOT IN( SELECT isnull(InvoiceNo,'') FROM WRBHBReconcilePaymentRef  
			where isnull(InvoiceNo,'')!='' )
		END
		 
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND CH.PropertyId=@PropertyId
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND B.ClientId=@ClientId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		 
		 
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),GETDATE(),103) AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		 
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo =''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId !='' AND @ChequeNo =''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.PropertyId=@PropertyId AND B.ClientId=@ClientId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks ,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.PropertyId=@PropertyId AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId AND Ch.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
		Insert into #CreditCardDtls(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
			SELECT ISNULL(CI.SOCBatchCloseNo ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks,CI.CCBrand
			FROM WRBHBChechkOutPaymentCard CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId AND Ch.InVoiceNo=@ChequeNo
			AND CH.PropertyId=@PropertyId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		Insert into #CreditCardDtlsF(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
		Select Chkrefno,Amount,InvoiceDate,
		InVoiceNo,AmttobeReconciled-(Amount/100)*(1.79),Billchecks, CardType 
		from #CreditCardDtls
		WHERE CardType IN (UPPER('VISACard'),UPPER('MasterCard'),UPPER('AmericanExpress'),UPPER('MaestroCard'))
		
		Insert into #CreditCardDtlsF(Chkrefno,Amount,InvoiceDate,InVoiceNo,AmttobeReconciled,Billchecks,CardType)
		Select Chkrefno,Amount,InvoiceDate,InVoiceNo,
		AmttobeReconciled-(Amount/100)*(2.79),Billchecks, CardType 
		from #CreditCardDtls
		WHERE CardType LIKE '%VISACard%'
		 
		Select Chkrefno, (Amount) Amount,InvoiceDate,InVoiceNo,
		 (AmttobeReconciled) AmttobeReconciled,Billchecks, CardType 
		from #CreditCardDtlsF
		
	END

	IF(@Type='NEFT')
	BEGIN
		IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 
			AND CH.InVoiceNo  NOT IN(  SELECT isnull(InvoiceNo,'') FROM WRBHBReconcilePaymentRef  
			where isnull(InvoiceNo,'')!=''  )
		END
		 
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103)
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND CH.PropertyId=@PropertyId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND B.ClientId=@ClientId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		  
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId='' AND @ChequeNo =''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.PropertyId=@PropertyId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ! ='' AND @ClientId !='' AND @ChequeNo =''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		 
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId ='' AND @ChequeNo !=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND CH.PropertyId=@PropertyId AND CH.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId ='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId AND Ch.InVoiceNo=@ChequeNo
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
		IF @Datefrom !='' AND @DateTo!='' AND @PropertyId !='' AND @ClientId !='' AND @ChequeNo !=''
		BEGIN
			SELECT ISNULL(CI.ReferenceNumber ,0) AS Chkrefno,CI.AmountPaid Amount,
			CONVERT(Nvarchar(100),CI.CreatedDate,103) AS InvoiceDate,ISNULL(CH.InVoiceNo,0) AS InVoiceNo,
			CI.AmountPaid AS AmttobeReconciled , 0 as Billchecks
			FROM WRBHBChechkOutPaymentNEFT CI
			JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
			JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			JOIN WRBHBBooking B ON BP.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
			WHERE CI.IsActive=1 AND CI.IsDeleted=0 AND
			CONVERT(DATE ,CI.CreatedDate,103) between CONVERT(nvarchar(100),@Datefrom,103) and
			CONVERT(nvarchar(100),@DateTo,103) AND B.ClientId=@ClientId AND Ch.InVoiceNo=@ChequeNo
			AND CH.PropertyId=@PropertyId
			AND CH.InVoiceNo  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
									WHERE P.IsActive=1 AND P.IsDeleted=0 )
		END
	END

	IF(@Type='Contract')
	Begin
	 
	 
	IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			AND ISNULL(InvoiceNo,0)  NOT IN(  SELECT isnull(InvoiceNo,'') FROM WRBHBReconcilePaymentRef  
			where isnull(InvoiceNo,'')!=''  )
		 
	END		
	 IF @Datefrom !='' AND @DateTo! ='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			 and   CONVERT(DATE,c.RentDate,103) between CONVERT(nvarchar(100),@Datefrom,103)
			 and CONVERT(nvarchar(100),@DateTo,103)
			AND ISNULL(InvoiceNo,0)  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
								   WHERE P.IsActive=1 AND P.IsDeleted=0 )
		 
	END		 
	 IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId!='' AND @ChequeNo=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			 and  ClientId=@ClientId
			AND ISNULL(InvoiceNo,0)  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
								   WHERE P.IsActive=1 AND P.IsDeleted=0 )
		 
	END		 
	IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId ='' AND @ChequeNo!=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			 and  ISNULL(InvoiceNo,0)=@ChequeNo
			AND ISNULL(InvoiceNo,0)  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
								   WHERE P.IsActive=1 AND P.IsDeleted=0 )
		 
	END	
	IF @Datefrom ='' AND @DateTo ='' AND @PropertyId ='' AND @ClientId! ='' AND @ChequeNo!=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			 and  ISNULL(InvoiceNo,0)=@ChequeNo  and  ClientId=@ClientId
			AND ISNULL(InvoiceNo,0)  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
								   WHERE P.IsActive=1 AND P.IsDeleted=0 )
		 
	END	
	IF @Datefrom !='' AND @DateTo !='' AND @PropertyId ='' AND @ClientId! ='' AND @ChequeNo!=''
	BEGIN
		   SELECT ISNULL(C.ReferenceNo ,0) AS Chkrefno,isnull(C.TotalAmount,0) Amount,
			CONVERT(Nvarchar(100),C.RentDate,103) AS InvoiceDate,ISNULL(InvoiceNo,0) AS InVoiceNo,
			isnull(C.TotalAmount,0) AS AmttobeReconciled , 0 as Billchecks 
			from WRBHBInvoiceManagedGHAmount C WHERE IsActive=1 AND IsDeleted=0
			 and  ISNULL(InvoiceNo,0)=@ChequeNo  and  ClientId=@ClientId
			  and   CONVERT(DATE,c.RentDate,103) between CONVERT(nvarchar(100),@Datefrom,103)
			 and CONVERT(nvarchar(100),@DateTo,103)
			AND ISNULL(InvoiceNo,0)  NOT IN( SELECT P.InvoiceNo FROM WRBHBReconcilePayment P 
								   WHERE P.IsActive=1 AND P.IsDeleted=0 )
		 
	END	

		
	END

	END -- For Bill Begin end here
  END --Cash Search Begin End Here

 END --Final most End is done here

IF(@Type='INVOICE')
BEGIN
	IF @Datefrom ='' AND @DateTo='' AND @PropertyId='' AND @ClientId='' AND @ChequeNo=''
	BEGIN
		SELECT CI.AmountPaid,CONVERT(Nvarchar,CI.CreatedDate,103) AS InvoiceDate
		FROM WRBHBChechkOutPaymentCompanyInvoice CI
		JOIN WRBHBChechkOutHdr CH ON CI.ChkOutHdrId=CH.Id AND Ch.IsActive=1 AND CH.IsDeleted=0
		WHERE CI.IsActive=1 AND CI.IsDeleted=0 
	END
	 
END
--exec Sp_Reconcile_Help @Action=N'PAGELOAD',@Datefrom=N'',@DateTo=N'',@TransactionId=N'0', 
 --@ChequeNo=N'',@PropertyId=0,@ClientId=0,@Type=N'',@Mode=N''

--exec Sp_Reconcile_Help @Action=N'CASHSEARCH',@Datefrom=N'01/07/2014',@DateTo=N'31/07/2014',
--@TransactionId=N'',@ChequeNo=N'',@PropertyId=0,@ClientId=0,@Type=N'',@Mode=N'Bank'



--select * from WRBHBBTCSubmission
--Select * from WRBHBBTCSubmissionDetails
--Select * from WRBHBBTCSubmissionCheque
--Select * from WRBHBBTCSubmissionNEFT

--exec Sp_Reconcile_Help @Action=N'Report',@Datefrom=N'01/09/2014',@DateTo=N'15/09/2014',
--@TransactionId=N'dsads',@ChequeNo=N'New',@PropertyId=0,@ClientId=0,@Type=N'',@Mode=N''
IF @Action='Report'
BEGIN
CREATE TABLE #ReportData(Date Nvarchar(20),TransactionId Nvarchar(200),Refernce Nvarchar(200),
TransactionAmt Decimal(27,2),Amount Decimal(27,2),ReconcliledAmount Decimal(27,2),
AmounttobrReconciled Decimal(27,2),Status  Nvarchar(200),ReconcilId BIGINT,TransId BIGINT)

 
        insert into #ReportData(Date,TransactionId ,Refernce,TransactionAmt,Amount,
	    ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId)
		Select convert(nvarchar(100),Date,103) Date,TransactionNo TransactionId ,t.RefNo Refernce,
		TransactionAmt ,TotalAmt Amount,
		t.BalanceAmount ReconcliledAmount,t.BalanceAmount AmounttobrReconciled,
		'New' Status,p.Id ReconcilId,t.Id AS TransId
	    FROM WRBHBReconcilePayment p
        JOIN WRBHBBankTransaction T on p.TransactionID=t.Id and t.IsActive=1 and t.IsDeleted=0
        where p.IsActive=1 and p.IsDeleted=0 and isnull(t.BalanceAmount,0)=0;
        
        insert into #ReportData(Date,TransactionId ,Refernce,TransactionAmt,Amount,
	    ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId)
		Select convert(nvarchar(100),Date,103) Date,TransactionNo TransactionId ,t.RefNo  Refernce,
		TransactionAmt ,TotalAmt Amount,
		t.BalanceAmount ReconcliledAmount,t.BalanceAmount AmounttobrReconciled,
		'Reconciled' Status,p.Id ReconcilId,t.Id AS TransId
	    FROM WRBHBReconcilePayment p
        JOIN WRBHBBankTransaction T on p.TransactionID=t.Id and t.IsActive=1 and t.IsDeleted=0
        where p.IsActive=1 and p.IsDeleted=0 and isnull(t.BalanceAmount,0)<isnull(t.Credit,0);
        
        insert into #ReportData(Date,TransactionId ,Refernce,TransactionAmt,Amount,
	    ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId)
		Select convert(nvarchar(100),Date,103) Date,TransactionNo TransactionId ,t.RefNo  Refernce,
		TransactionAmt ,TotalAmt Amount,
		t.BalanceAmount ReconcliledAmount,t.BalanceAmount AmounttobrReconciled,
		'Partially Reconciled' Status,p.Id ReconcilId,t.Id AS TransId
	    FROM WRBHBReconcilePayment p
        JOIN WRBHBBankTransaction T on p.TransactionID=t.Id and t.IsActive=1 and t.IsDeleted=0
        where p.IsActive=1 and p.IsDeleted=0 and isnull(t.BalanceAmount,0)=isnull(t.Credit,0);
 IF @Datefrom ='' AND @DateTo='' AND @TransactionId='' AND @ChequeNo='' 
BEGIN
       SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData  
		group by Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
  END
  
IF @Datefrom! ='' AND @DateTo!='' AND @TransactionId='' AND @ChequeNo='' 
BEGIN
       SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103)
  END
IF @Datefrom! ='' AND @DateTo!='' AND @TransactionId!=''  AND @ChequeNo='' 
BEGIN
       SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103) and TransactionId=@TransactionId
  END 
IF @Datefrom! ='' AND @DateTo!='' AND @TransactionId!=''  AND @ChequeNo!='' 
BEGIN
if(@ChequeNo='All')
begin
        SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103) and TransactionId=@TransactionId  ;
end
else
begin
        SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103) and TransactionId=@TransactionId and Status=@ChequeNo
end
  END 
  IF @Datefrom! ='' AND @DateTo!='' AND @TransactionId=''  AND @ChequeNo!='' 
BEGIN
if(@ChequeNo='All')
begin
        SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103) 
end
else
begin	
		 SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId
		FROM #ReportData where
        CONVERT(DATE,Date  ,103) between CONVERT(date,@Datefrom,103) and
		CONVERT(date,@DateTo,103) and TransactionId=@TransactionId and Status=@ChequeNo
		end
  END 
END

--ReportBorder
IF @Action='ReportBorder'
BEGIN
--CREATE TABLE #ReportDatas(Date Nvarchar(20),TransactionId Nvarchar(200),Refernce Nvarchar(200),
--TransactionAmt Decimal(27,2),Amount Decimal(27,2),ReconcliledAmount Decimal(27,2),
--AmounttobrReconciled Decimal(27,2),Status  Nvarchar(200),ReconcilId BIGINT,TransId BIGINT)
 
       --insert into #ReportDatas(Date,TransactionId ,Refernce,TransactionAmt,Amount,
		--ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId)
		
		Select TransactionNo TransactionID,convert(nvarchar(100),Date,103) DATE, BalanceAmount  InvoiceAmount
	    FROM WRBHBReconcilePayment p
        JOIN WRBHBBankTransaction T on p.TransactionID=t.Id and t.IsActive=1 and t.IsDeleted=0
        where p.IsActive=1 and p.IsDeleted=0 and p.TransactionID=@TransactionId 
        group by TransactionNo,DATE, BalanceAmount   ;
		 
		Select InvoiceNo  Invoice,Billtype ,InvoiceAmount BillAmount, 
		t.BalanceAmount ReconciledAmount ,0 as ServiceCharge,0 as TDSAmount,t.Id AS TransId
	    FROM WRBHBReconcilePayment p
        JOIN WRBHBBankTransaction T on p.TransactionID=t.Id and t.IsActive=1 and t.IsDeleted=0
        where p.IsActive=1 and p.IsDeleted=0 and p.TransactionID=@TransactionId;
 
  --      SELECT Date,TransactionId ,Refernce,TransactionAmt,Amount,
		--ReconcliledAmount,AmounttobrReconciled,Status,ReconcilId,TransId FROM #ReportDatas
  
END
