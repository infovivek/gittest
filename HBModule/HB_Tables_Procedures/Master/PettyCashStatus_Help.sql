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
		
		SELECT DISTINCT RequestedOn As Date,RequestedAmount AS Amount,
		ProcessedStatus AS FinanceStatus,PD.PropertyId
		FROM WRBHBPettyCashApprovalDtl PD
		JOIN WRBHBPettyCashHdr P ON PD.RequestedUserId=P.UserId AND PD.PropertyId=P.PropertyId AND
		P.IsActive=1 AND P.IsDeleted=0
		WHERE PD.IsActive=1 AND PD.IsDeleted=0 AND PD.PropertyId=@Id AND PD.RequestedUserId=@UserId
		AND PD.ProcessedStatus='Acknowledged' AND P.Flag=1 AND PD.Process=1
		
		
		
		
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
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@Id AND  PC.IsActive=1 AND PC.IsDeleted=0 AND
		PC.RequestedOn=@Str
		;
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT	(U.FirstName+' '+U.LastName) AS UserName,P.Status AS Status,'' AS Comments,
		CONVERT(NVARCHAR(100),PC.Date,103) AS Processedon
	    FROM WRBHBPettyCash P
	    JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND	PC.PropertyId=@Id AND P.IsActive=1 AND P.IsDeleted=0 AND
		CONVERT(date,PC.Date,103)=CONVERT(date,@Str,103)
		
		SELECT UserName,Status,Comments,Processedon FROM #User ORDER BY Processedon DESC
	END
	IF @Action='EXPENSELOAD'
	BEGIN
		CREATE TABLE #Final(ExpenseHead NVARCHAR(100),Description NVARCHAR(100),Status NVARCHAR(100),
		Amount DECIMAL(27,2),Paid DECIMAL(27,2),Id INT,TotalAmount DECIMAL(27,2),
		ExpenseId INT,FilePath NVARCHAR(100),BillDate NVARCHAR(100))
		
		INSERT INTO #Final(ExpenseHead,Description,Status,Amount,Paid,Id,TotalAmount,ExpenseId,FilePath,
		BillDate)
		
		SELECT ExpenseHead,Description,CONVERT(NVARCHAR,PC.Date,103) AS Status,ApprovedAmount,0 AS Paid,
		0 AS Id,TotalAmount,P.Id AS ExpenseId,'' AS FilePath,'' As BillDate
		FROM WRBHBPettyCash	P
		JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND PC.Flag=1 AND CONVERT(date,PC.Date,103)=CONVERT(date,@Str,103)
		
		SELECT ExpenseHead,Description,Status,Amount,Paid,Id,TotalAmount,ExpenseId,FilePath,BillDate
		FROM #Final
				
		--Expense
		SELECT ExpenseHead,Id AS ExpenseId FROM WRBHBExpenseGroup
		Where ItemType=1
		
		SELECT OpeningBalance AS ClosingBalance FROM WRBHBPettyCashHdr 
		WHERE UserId=@UserId AND PropertyId=@Id AND CONVERT(date,Date,103)=CONVERT(date,@Str,103)
		AND IsActive=1 AND IsDeleted=0
		
	END
	IF @Action='EXPENSEUPLOAD'
	BEGIN
		SELECT ExpenseHead,Description,P.Id
		FROM WRBHBPettyCash	P
		JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE P.IsActive=1 AND P.IsDeleted=0 AND PC.PropertyId=@Id AND PC.UserId=@UserId
		AND P.Id=@ExpenseId
	END
	IF @Action='IMAGEUPLOAD'
	BEGIN
		UPDATE WRBHBPettyCashStatus SET BillLogo=@Str WHERE Id=@Id
		
	END
END



