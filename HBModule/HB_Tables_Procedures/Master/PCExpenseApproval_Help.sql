SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PCExpenseApproval_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PCExpenseApproval_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (21/08/2014)  >
Section  	: PCExpenseApproval HELP
Purpose  	: PCExpenseApproval HELP
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

CREATE PROCEDURE dbo.[SP_PCExpenseApproval_Help]
(
@Action NVARCHAR(100),
@PropertyId		BIGINT,
@UserId         BIGINT,
@Id1			BIGINT,
@Str            NVARCHAR(100)
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
 		CREATE TABLE #Request(Requestedby NVARCHAR(100),PCAccount NVARCHAR(100),
		ProcessedStatus NVARCHAR(100),Comments NVARCHAR(100),RequestedOn NVARCHAR(100),Process BIT,
		ApprovedAmount DECIMAL(27,2),ExpenseAmount DECIMAL(27,2),
		Processedon NVARCHAR(100),Date NVARCHAR(100),OP DECIMAL(27,2),
		Processedby NVARCHAR(100),RequestedUserId INT,Id INT,PropertyId INT,PCId INT)
		--OpeningBalance DECIMAL(27,2)
		
		BEGIN
		INSERT INTO #Request(Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,ApprovedAmount,ExpenseAmount,Processedon,Date,OP,Processedby,
		RequestedUserId,Id,PropertyId,PCId)
		SELECT DISTINCT(U.FirstName+' '+U.LastName)AS Requestedby, PCAccount,
		PC.ProcessedStatus AS ProcessedStatus,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.RequestedOn,103) AS RequestedOn,0 AS Process,
		PC.ApprovedAmount AS ApprovedAmount,PC.ExpenseAmount AS ExpenseAmount,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon,'' AS Date,0 AS OP,
		(US.FirstName+' '+US.LastName) AS Processedby,
		PC.RequestedUserId AS RequestedUserId, PC.Id,
		PC.PropertyId,0 AS PCId
		From  WRBHBPCExpenseApproval PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PU.UserId=@UserId AND 
		PC.Process=1 AND
		ProcessedStatus !='Accounted and Closed by Finance Manager ' AND 
		P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')	
		
			
		INSERT INTO #Request(Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,ApprovedAmount,ExpenseAmount,Processedon,Date,OP,Processedby,
		RequestedUserId,Id,PropertyId,PCId)
		
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		'Waiting For Operation Manager Approval' AS ProcessedStatus,'Processing' AS Comments,
		CONVERT(NVARCHAR,CAST(H.ModifiedDate AS Date),103) AS RequestedOn,0 AS Process,
		(PC.Amount) AS ApprovedAmount,(PC.Paid) AS ExpenseAmount,
		CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,PC.Status AS Date,PH.ClosingBalance,
		(U.FirstName+' '+U.LastName) AS Processedby,
		PC.UserId AS RequestedUserId, 0 AS Id,PC.PropertyId,PC.Id AS PCId
		From WRBHBPettyCashStatus PC
		JOIN WRBHBPettyCashStatusHdr H ON PC.PettyCashStatusHdrId=H.Id AND H.IsActive=1 AND H.IsDeleted=0
		JOIN WRBHBPettyCashHdr PH ON H.UserId=PH.UserId AND H.PropertyId=PH.PropertyId 
		AND PH.Id = (SELECT MAX(Id)  FROM WRBHBPettyCashHdr WHERE UserId=PH.UserId AND PropertyId=PH.PropertyId)
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND H.NewEntry=0 AND H.Flag=1
		AND PU.UserId=@UserId 
		AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head')
				
	END
		SELECT Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,SUM(ApprovedAmount)+(OP) AS ApprovedAmount,SUM(ExpenseAmount) AS ExpenseAmount,
		Processedon,Processedby,RequestedUserId,R.Id,R.PropertyId 
		FROM #Request R
		group by Requestedby,PCAccount,ProcessedStatus,Comments,OP,
		RequestedOn,Process,Processedon,Processedby,RequestedUserId,R.Id,R.PropertyId
		
END
 IF @Action='History'
 BEGIN
        --table1
        CREATE TABLE #History(Requestedby NVARCHAR(100),PCAccount NVARCHAR(100),RequestedOn NVARCHAR(100),
        Closingbalance DECIMAL(27,2),Amount DECIMAL(27,2),OpeningBalance DECIMAL(27,2),PropertyId INT,UserId INT)
        
        INSERT #History(Requestedby,PCAccount,RequestedOn,Closingbalance,Amount,OpeningBalance,
        PropertyId,UserId)
        
        SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS RequestedOn,PH.ClosingBalance AS Closingbalance,
		SUM(PC.Amount) AS Amount,PH.OpeningBalance,PC.PropertyId,PC.UserId
		From WRBHBPettyCashStatus PC
		JOIN WRBHBPettyCashHdr PH ON PC.PropertyId=PH.PropertyId AND 
		PC.Status=CONVERT(NVARCHAR,PH.Date,103) AND PC.UserId=PH.UserId AND PH.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		group by  U.FirstName,U.LastName,P.PropertyName,CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103),
		PH.ClosingBalance,PC.UserId,PC.PropertyId,PH.OpeningBalance
		
		INSERT #History(Requestedby,PCAccount,RequestedOn,Closingbalance,Amount,OpeningBalance,
        PropertyId,UserId)
        
        SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS RequestedOn,PH.Balance AS Closingbalance,
		SUM(PC.Amount) AS Amount,PH.Balance+SUM(PC.Paid) AS OpeningBalance,PC.PropertyId,PC.UserId
		From WRBHBPettyCashStatus PC
		JOIN WRBHBPettyCashStatusHdr PH ON PC.PettyCashStatusHdrId=PH.Id AND PH.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.Status =''
		AND CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		group by  U.FirstName,U.LastName,P.PropertyName,CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103),
		PH.Balance,PC.UserId,PC.PropertyId,PH.Balance
		
		SELECT Requestedby,PCAccount,RequestedOn,Closingbalance,Amount,OpeningBalance,
        PropertyId,UserId FROM #History
		
		--table2
		Select  DISTINCT 
		CONVERT(NVARCHAR(100),PC.CreatedDate,103) AS RequestedOn,
		PC.Amount AS ApprovedAmount,PC.Paid AS ExpenseAmount,ExpenseHead,Description,PC.BillLogo As Bill,
		PC.Id AS Id
		From WRBHBPettyCashStatus PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0 
		AND CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103) 
		 END
		
		
		 
 IF @Action='Action'
 BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Comments NVARCHAR(100),Processedon NVARCHAR(100))
				
						
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT(U.FirstName+' '+U.LastName) AS UserName,'Submitted' AS Status,'' AS Comments,
		CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103) AS Processedon
	    FROM WRBHBPettyCashStatus P
		JOIN WRBHBUser U ON  P.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE P.UserId=@UserId AND P.PropertyId=@PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon		
		From WRBHBNewPCExpenseApproval PC
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103)
		ORDER BY PC.CreatedDate		
		
		SELECT UserName,Status,Comments,Processedon FROM #User ORDER BY Processedon DESC
	END
	IF @Action='Reject'
	BEGIN
		 UPDATE WRBHBPettyCashStatus SET Flag=0 
		 WHERE UserId=@UserId AND PropertyId=@PropertyId AND 
		 CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
	
		
		 UPDATE WRBHBPettyCashStatusHdr SET Flag=0
		 WHERE UserId=@UserId AND PropertyId=@PropertyId AND 
		 CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		 
		 DECLARE @Bt NVARCHAR(100)
		 SET @Bt=(SELECT DISTINCT CONVERT(NVARCHAR(100),Date,103) FROM WRBHBPettyCashHdr  P
		 JOIN WRBHBPettyCashStatus S ON P.PropertyId=S.PropertyId AND P.UserId=S.UserId AND
		 CONVERT(NVARCHAR(100),Date,103)=S.Status AND S.IsActive=1 AND S.IsDeleted=0
		 WHERE S.UserId=@UserId AND S.PropertyId=@PropertyId AND 
		 CONVERT(NVARCHAR,CAST(S.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103))
		 
		 
	END
	
 END
 
 




