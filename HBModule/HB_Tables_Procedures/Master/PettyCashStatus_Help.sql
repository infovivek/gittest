SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatus_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatus_Help

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (2/04/2014)  >
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

CREATE PROCEDURE Sp_PettyCashStatus_Help
(
@Action		NVARCHAR(100),
@Str        NVARCHAR(100), 
@Id			BIGINT,
@UserId		BIGINT,
@ExpenseId   BIGINT
)
AS
BEGIN
	IF @Action='PAGELOAD'
	BEGIN
		SELECT DISTINCT P.PropertyName AS Property,P.Id AS PropertyId
		FROM WRBHBPropertyUsers PU
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.UserId=@UserId AND 
		P.Category IN('Internal Property','Managed G H') AND
		PU.IsActive=1 AND PU.IsDeleted=0 AND PU.UserType IN('Resident Managers' ,'Assistant Resident Managers')

	END
	IF @Action='PROPERTYLOAD'
	BEGIN
		CREATE TABLE #Temp(Date NVARCHAR(100),Amount DECIMAL(27,2),FinanceStatus NVARCHAR(100),PropertyId INT)
		
		INSERT INTO #Temp(Date,Amount,FinanceStatus,PropertyId)
		SELECT DISTINCT RequestedOn As Date,RequestedAmount AS Amount,
		ProcessedStatus AS FinanceStatus,PD.PropertyId
		FROM WRBHBPettyCashApprovalDtl PD
		WHERE PD.IsActive=1 AND PD.IsDeleted=0 AND PD.PropertyId=@Id AND PD.RequestedUserId=@UserId
		AND PD.ProcessedStatus='Acknowledged'  AND PD.Process=1
		
		INSERT INTO #Temp(Date,Amount,FinanceStatus,PropertyId)
		SELECT Status As Date,SUM(Amount) AS Amount,
		'Acknowledged' AS FinanceStatus,PD.PropertyId
		FROM WRBHBPettyCashStatus PD
		JOIN WRBHBPettyCashStatusHdr P ON PD.PettyCashStatusHdrId=P.Id AND PD.PropertyId=P.PropertyId AND
		P.IsActive=1 AND P.IsDeleted=0
		WHERE PD.IsActive=1 AND PD.IsDeleted=0 AND PD.PropertyId=@Id AND PD.UserId=@UserId
		AND PD.Flag=0 AND P.Flag=0
		GROUP BY Status,PD.PropertyId
		
		SELECT Date,Amount,FinanceStatus,PropertyId FROM #Temp
		
	END
	IF @Action='Action'
    BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Comments NVARCHAR(100),Processedon NVARCHAR(100))
			
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon		
		From WRBHBNewPettyCashApprovalDtl PC
		JOIN WRBHBNewPettyCashApprovalHdr PCH ON PC.PettyCashApprovalHdrId=PCH.Id AND PCH.IsActive=1 AND PCH.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND 
		PC.PropertyId=@Id AND  PC.IsActive=1 AND PC.IsDeleted=0 AND
		PC.RequestedOn=@Str
		;
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT	(U.FirstName+' '+U.LastName) AS UserName,P.Status AS Status,'' AS Comments,
		CONVERT(NVARCHAR(100),PC.Date,103) AS Processedon
	    FROM WRBHBPettyCash P
	    JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND	
		PC.PropertyId=@Id AND P.IsActive=1 AND P.IsDeleted=0 AND
		CONVERT(date,PC.Date,103)=CONVERT(date,@Str,103)
		
		SELECT UserName,Status,Comments,Processedon FROM #User ORDER BY Processedon DESC
	END
	IF @Action='EXPENSELOAD'
	BEGIN
		CREATE TABLE #Final(ExpenseHead NVARCHAR(100),Description NVARCHAR(100),Status NVARCHAR(100),
		Amount DECIMAL(27,2),Paid DECIMAL(27,2),Id INT,TotalAmount DECIMAL(27,2),
		ExpenseId INT,FilePath NVARCHAR(Max),BillDate NVARCHAR(100),BillNo NVARCHAR(100))
		
		INSERT INTO #Final(ExpenseHead,Description,Status,Amount,Paid,Id,TotalAmount,ExpenseId,FilePath,
		BillDate,BillNo)
		
		SELECT ExpenseHead,Description,CONVERT(NVARCHAR,PC.Date,103) AS Status,ApprovedAmount,0 AS Paid,
		0 AS Id,TotalAmount,P.Id AS ExpenseId,'' AS FilePath,'' As BillDate,'' AS BillNo
		FROM WRBHBPettyCash	P
		JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND PC.ExpenseReport=0 AND CONVERT(date,PC.Date,103)=CONVERT(date,@Str,103)
		
		INSERT INTO #Final(ExpenseHead,Description,Status,Amount,Paid,Id,TotalAmount,ExpenseId,FilePath,
		BillDate,BillNo)
		SELECT ExpenseHead,Description,Status,Amount,Paid,
		P.Id,Amount,P.Id AS ExpenseId,BillLogo AS FilePath,BillDate,BillNo
		FROM WRBHBPettyCashStatus	P
		JOIN WRBHBPettyCashStatusHdr PC ON P.PettyCashStatusHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND PC.Flag=0 AND CONVERT(NVARCHAR,P.Status,103)=CONVERT(NVARCHAR,@Str,103)
			
		SELECT ExpenseHead,Description,Status,Amount,Paid,Id,TotalAmount,ExpenseId,FilePath,BillDate,
		BillNo
		FROM #Final
				
		--Expense
		SELECT HeaderName,Id AS ExpenseId FROM WRBHBExpenseHeads
		Where Status='Active'
		
		SELECT OpeningBalance AS ClosingBalance FROM WRBHBPettyCashHdr 
		WHERE UserId=@UserId AND PropertyId=@Id AND CONVERT(date,Date,103)=CONVERT(date,@Str,103)
		AND IsActive=1 AND IsDeleted=0
		
		SELECT Id AS HId FROM WRBHBPettyCashStatusHdr
		WHERE IsActive=1 AND IsDeleted=0 AND PropertyId=@Id AND UserId=@UserId
		AND Flag=0 
	END
	IF @Action='EXPENSEUPLOAD'
	BEGIN
		CREATE TABLE #Expense (ExpenseHead NVARCHAR(100),Description NVARCHAR(1000),Id INT,
		BillDate NVARCHAR(100))
		
		INSERT INTO #Expense(ExpenseHead,Description,Id,BillDate)
		SELECT ExpenseHead,Description,P.Id,'' AS BillDate
		FROM WRBHBPettyCash	P
		JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND P.Id=@ExpenseId
		
		INSERT INTO #Expense(ExpenseHead,Description,Id,BillDate)
		SELECT ExpenseHead,Description,P.Id,BillDate
		FROM WRBHBPettyCashStatus	P
		JOIN WRBHBPettyCashStatusHdr PC ON P.PettyCashStatusHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND P.Id=@ExpenseId
		
		SELECT ExpenseHead,Description,Id,BillDate FROM #Expense
		
		
	END
	IF @Action='IMAGEUPLOAD'
	BEGIN
		UPDATE WRBHBPettyCashStatus SET BillLogo=@Str WHERE Id=@Id
		
	END
END



