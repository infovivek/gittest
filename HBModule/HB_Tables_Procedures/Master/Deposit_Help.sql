 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Deposit_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Deposit_Help]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: Deposite HELP
		Purpose  	: Deposite HELP
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
CREATE PROCEDURE [dbo].[Sp_Deposit_Help]
(
@Action		NVARCHAR(100),
@Str		NVARCHAR(100),
@Id			INT,
@Id2 int
)
AS
BEGIN						
	IF @Action='Pageload'
	BEGIN
	--Cash Deposits
	SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,P.PropertyName AS Property,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
	Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
	JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
	JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	JOIN WRBHBUser U ON U.Id=D.DepositedBy
	where Mode='Cash' AND D.IsActive=1	AND D.IsDeleted=0  AND MONTH(D.DepositedDate) = MONTH(GETDATE())
	
	--Cheque Deposits
	SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,P.PropertyName AS Property,Amount,BA.AccountDetails as DepositeTo,U.FirstName as DepositedBy,--DepositedBy,
	Comments,ChallanImage,D.Id FROM WRBHBDeposits D 
	JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
	JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	JOIN WRBHBUser U ON U.Id=D.DepositedBy
	where Mode='Cheque' AND D.IsActive=1	AND D.IsDeleted=0 AND MONTH(D.DepositedDate) = MONTH(GETDATE())
	
	--BTC Deposits
	SELECT Convert(NVARCHAR(100),DepositedDate,103) AS Date,P.PropertyName AS Property,D.TotalAmount AS Amount,D.Comments,BTCTo,BTCMode,D.Id
	FROM WRBHBDeposits D 
	JOIN WRBHBUser U ON U.Id=D.DepositedBy
	JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	where Mode='BTC' AND D.IsActive=1	AND D.IsDeleted=0 AND MONTH(D.DepositedDate) = MONTH(GETDATE())
	
	
	--Bank Accounts
	select BankAccountID as data,AccountDetails as label from WRBHBBankAccounts	
	
	select DISTINCT P.PropertyName AS Property,P.Id AS ZId 
	From WRBHBProperty P
	JOIN WRBHBChechkOutHdr COH ON P.Id=COH.PropertyId AND COH.IsActive=1 AND COH.IsDeleted=0
	JOIN WRBHBPropertyUsers PU ON COH.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
	WHERE PU.UserId=@Id AND P.IsActive=1 AND P.IsDeleted=0
	
	END
	
	IF @Action='Search'
	BEGIN
		SELECT convert(nvarchar(100),DepositedDate,103) as Date,Amount,BA.AccountDetails as AC,DepositeToId,
		Comments,ImageName,P.PropertyName as Property,D.TotalAmount as TotalAmount,D.InvoiceNo,D.Id,D.ChequeNo 
		FROM WRBHBDeposits D
		JOIN WRBHBBankAccounts BA ON BA.BankAccountID=D.DepositeToId
		JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE D.Id=@Id and D.IsActive=1 and D.IsDeleted=0
		
		SELECT DISTINCT D.BillType,D.InvoiceNo,Amount Total,ChkOutHdrId,D.ClientId,CM.ClientName AS Client,Tick,
		COH.CheckInDate AS CheckIn,COH.CheckOutDate AS CheckOut,COH.GuestName
		From WRBHBDepositsDlts D
		JOIN WRBHBClientManagement CM ON D.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
		JOIN WRBHBChechkOutHdr COH ON D.ChkOutHdrId=COH.Id AND COH.IsActive=1 AND COH.IsDeleted=0
		WHERE D.DepHdrId=@Id AND D.IsActive=1 AND D.IsDeleted=0
		
	END
	IF @Action='BTCSearch'
	BEGIN
	DECLARE @CId INT
	SET @CId=(SELECT ClientId FROM WRBHBDeposits WHERE Id=@Id)
		IF(@CId !=0)
		BEGIN
			SELECT convert(nvarchar(100),DepositedDate,103) as Date,TotalAmount AS Amount,Comments as Remarks,BTCMode,BTCTo,DoneBy,
			D.Id,P.PropertyName as Property,CM.ClientName FROM WRBHBDeposits D
			JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBClientManagement CM ON D.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE D.Id=@Id and D.IsActive=1 and D.IsDeleted=0 AND Mode='BTC'
		END
		ELSE
		BEGIN
			SELECT convert(nvarchar(100),DepositedDate,103) as Date,TotalAmount AS Amount,Comments as Remarks,BTCMode,BTCTo,DoneBy,
			D.Id,P.PropertyName as Property FROM WRBHBDeposits D
			JOIN WRBHBProperty P ON D.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE D.Id=@Id and D.IsActive=1 and D.IsDeleted=0 AND Mode='BTC'
		END
		
		SELECT D.BillType,D.InvoiceNo,Amount Total,ChkOutHdrId,D.ClientId,Tick,CM.ClientName AS Client,
		COH.CheckInDate AS CheckIn,COH.CheckOutDate AS CheckOut,COH.GuestName 
		from WRBHBDepositsDlts D
		JOIN WRBHBClientManagement CM ON D.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
		JOIN WRBHBChechkOutHdr COH ON D.ChkOutHdrId=COH.Id AND COH.IsActive=1 AND COH.IsDeleted=0
		WHERE D.DepHdrId=@Id
	END
	IF @Action='IMAGEUPLOAD'
	BEGIN
		UPDATE WRBHBDeposits SET ChallanImage=@Str WHERE Id=@Id
		SELECT @Str Logo
	END
	IF @Action='INVOICE'
			
			
	BEGIN	
			CREATE TABLE #TEMPCASH (BillType NVARCHAR(100),InvoiceNo NVARCHAR(100),Total DECIMAL(27,2),
			ChkOutHdrId BIGINT,Mode NVARCHAR(100),ClientId BIGINT,Property NVARCHAR(100),PId BIGINT,
			CheckIn NVARCHAR(100),CheckOut NVARCHAR(100),GuestName NVARCHAR(100))
			
			INSERT INTO #TEMPCASH(BillType,InvoiceNo,Total,ChkOutHdrId,Mode,ClientId,Property,PId,
			CheckIn,CheckOut,GuestName)
			
			SELECT DISTINCT Payment AS BillType,COH.InVoiceNo,SUM(AmountPaid) AS Total,COH.Id AS ChkOutHdrId,'Cash',
			CM.Id AS ClientId,COH.Property AS Property,COH.PropertyId AS PId,
			CheckInDate,CheckOutDate,COH.GuestName
			FROM WRBHBChechkOutPaymentCash PC
			JOIN WRBHBChechkOutHdr COH ON PC.ChkOutHdrId=COH.Id AND COH.IsActive=1 AND COH.IsDeleted=0
			JOIN WRBHBClientManagement CM ON COH.ClientName=CM.ClientName AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE COH.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
			GROUP BY Payment,COH.InVoiceNo,COH.Id,CM.Id,COH.Property,COH.PropertyId,
			CheckInDate,CheckOutDate,GuestName
			
			CREATE TABLE #TEMPCHEQUE (BillType NVARCHAR(100),InvoiceNo NVARCHAR(100),Total DECIMAL(27,2),
			ChkOutHdrId BIGINT,Mode NVARCHAR(100),ClientId BIGINT,Property NVARCHAR(100),PId BIGINT,
			CheckIn NVARCHAR(100),CheckOut NVARCHAR(100),GuestName NVARCHAR(100))
			
			INSERT INTO #TEMPCHEQUE(BillType,InvoiceNo,Total,ChkOutHdrId,Mode,ClientId,Property,PId,
			CheckIn,CheckOut,GuestName)
			
			SELECT DISTINCT Payment AS BillType,COH.InVoiceNo,SUM(AmountPaid) AS Total,COH.Id AS ChkOutHdrId,
			'Cheque',CM.Id AS ClientId,COH.Property AS Property,COH.PropertyId AS PId,
			CheckInDate,CheckOutDate,COH.GuestName
			FROM WRBHBChechkOutPaymentCheque PC
			JOIN WRBHBChechkOutHdr COH ON PC.ChkOutHdrId=COH.Id AND COH.IsActive=1 AND COH.IsDeleted=0
			JOIN WRBHBClientManagement CM ON COH.ClientName=CM.ClientName AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE COH.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
			GROUP BY Payment,COH.InVoiceNo,COH.Id,CM.Id,COH.Property,COH.PropertyId,
			CheckInDate,CheckOutDate,GuestName

			CREATE TABLE #TEMPBTC (BillType NVARCHAR(100),InvoiceNo NVARCHAR(100),Total DECIMAL(27,2),
			ChkOutHdrId BIGINT,Mode NVARCHAR(100),ClientId BIGINT,Property NVARCHAR(100),PId BIGINT,
			CheckIn NVARCHAR(100),CheckOut NVARCHAR(100),GuestName NVARCHAR(100))
			
			INSERT INTO #TEMPBTC(BillType,InvoiceNo,Total,ChkOutHdrId,Mode,ClientId,Property,PId,
			CheckIn,CheckOut,GuestName)
					
			SELECT DISTINCT Payment AS BillType,COH.InVoiceNo,SUM(AmountPaid) AS Total,COH.Id AS ChkOutHdrId,
			'BTC',CM.Id AS ClientId,COH.Property AS Property,COH.PropertyId AS PId,
			CheckInDate,CheckOutDate,COH.GuestName
			FROM WRBHBChechkOutPaymentCompanyInvoice PC
			JOIN WRBHBChechkOutHdr COH ON PC.ChkOutHdrId=COH.Id AND COH.IsActive=1 AND COH.IsDeleted=0
			JOIN WRBHBClientManagement CM ON COH.ClientName=CM.ClientName AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE COH.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
			GROUP BY Payment,COH.InVoiceNo,COH.Id,CM.Id,COH.Property,COH.PropertyId,
			CheckInDate,CheckOutDate,GuestName
			
		IF @Str='Cash'
		BEGIN
			SELECT 0 AS Tick,BillType,InvoiceNo,Total,ChkOutHdrId,ClientId,CheckIn,CheckOut,CM.ClientName AS Client,
			CM.Id AS ClientId,GuestName 
			FROM #TEMPCASH T
			JOIN WRBHBClientManagement CM ON T.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE Total!=0.00 AND InvoiceNo!=''	
			AND InVoiceNo NOT IN(SELECT InVoiceNo FROM WRBHBDepositsDlts WHERE IsActive=1)
			
			SELECT DISTINCT ClientId AS ZId,CM.ClientName AS Client FROM #TEMPCASH TC
			JOIN WRBHBClientManagement CM ON TC.ClientId=CM.Id WHERE CM.IsActive=1 AND CM.IsDeleted=0
		END	
		IF @Str='Cheque'
		BEGIN
			SELECT 0 AS Tick,BillType,InvoiceNo,Total,ChkOutHdrId,CheckIn,CheckOut,CM.ClientName AS Client,
			CM.Id AS ClientId,GuestName   
			FROM #TEMPCHEQUE T
			JOIN WRBHBClientManagement CM ON T.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
			WHERE Total!=0.00 AND InvoiceNo!=''
			AND InVoiceNo NOT IN(SELECT InVoiceNo FROM WRBHBDepositsDlts WHERE IsActive=1)
			
			SELECT DISTINCT ClientId AS ZId,CM.ClientName AS Client FROM #TEMPCHEQUE TCQ
			JOIN WRBHBClientManagement CM ON TCQ.ClientId=CM.Id WHERE CM.IsActive=1 AND CM.IsDeleted=0
		END	
		IF @Str='BTC'
		BEGIN
			SELECT 0 AS Tick,BillType,InvoiceNo,Total,ChkOutHdrId,CM.ClientName AS Client,TC.CheckIn,TC.CheckOut,
			CM.Id AS ClientId,GuestName  
			FROM #TEMPBTC TC
			JOIN WRBHBClientManagement CM ON TC.ClientId=CM.Id WHERE CM.IsActive=1 AND CM.IsDeleted=0
			AND Total!=0.00 AND InvoiceNo!='' AND InVoiceNo NOT IN(SELECT InVoiceNo FROM WRBHBDepositsDlts)
			
			SELECT DISTINCT ClientId AS ZId,CM.ClientName AS Client FROM #TEMPBTC TB
			JOIN WRBHBClientManagement CM ON TB.ClientId=CM.Id WHERE CM.IsActive=1 AND CM.IsDeleted=0
		END	
 	END
 	IF @Action='FILTER'
	BEGIN
		IF @Str='BTC'
		BEGIN
		
			CREATE TABLE #TEMPBTCC (BillType NVARCHAR(100),InvoiceNo NVARCHAR(100),Total DECIMAL(27,2),
			ChkOutHdrId BIGINT,Mode NVARCHAR(100),ClientId BIGINT,Property NVARCHAR(100),PId BIGINT,
			CheckIn NVARCHAR(100),CheckOut NVARCHAR(100),GuestName NVARCHAR(100))
			
			INSERT INTO #TEMPBTCC(BillType,InvoiceNo,Total,ChkOutHdrId,Mode,ClientId,Property,PId,
			CheckIn,CheckOut,GuestName)
					
			SELECT DISTINCT Payment AS BillType,COH.InVoiceNo,SUM(AmountPaid) AS Total,COH.Id AS ChkOutHdrId,
			'BTC',CM.Id AS ClientId,COH.Property AS Property,COH.PropertyId AS PId,
			CheckInDate,CheckOutDate,COH.GuestName
			FROM WRBHBChechkOutPaymentCompanyInvoice PC
			JOIN WRBHBChechkOutHdr COH ON PC.ChkOutHdrId=COH.Id
			JOIN WRBHBClientManagement CM ON COH.ClientName=CM.ClientName WHERE COH.PropertyId=@Id
			GROUP BY Payment,COH.InVoiceNo,COH.Id,CM.Id,COH.Property,COH.PropertyId,
			CheckInDate,CheckOutDate,GuestName
		
		
			SELECT BillType,InvoiceNo,Total,ChkOutHdrId,ClientId,CM.ClientName AS Client,CheckIn,CheckOut  
			FROM #TEMPBTCC TC
			JOIN WRBHBClientManagement CM ON TC.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0			
			WHERE ClientId=@Id2 AND 
			Total!=0.00 AND InvoiceNo!='' AND InVoiceNo NOT IN(SELECT InVoiceNo FROM WRBHBDepositsDlts 
			WHERE IsActive=1)
		END	
	END
END


