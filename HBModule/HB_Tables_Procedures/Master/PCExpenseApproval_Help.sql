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
		ApprovedAmount DECIMAL(27,2),ExpenseAmount DECIMAL(27,2),OP DECIMAL(27,2),
		Processedon NVARCHAR(100),
		Processedby NVARCHAR(100),RequestedUserId INT,Id INT,PropertyId INT,PCId INT)
		--OpeningBalance DECIMAL(27,2)
		
		BEGIN
		INSERT INTO #Request(Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,ApprovedAmount,ExpenseAmount,OP,Processedon,Processedby,
		RequestedUserId,Id,PropertyId,PCId)
		SELECT DISTINCT(U.FirstName+' '+U.LastName)AS Requestedby, PCAccount,
		PC.ProcessedStatus AS ProcessedStatus,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.RequestedOn,103) AS RequestedOn,0 AS Process,
		PC.ApprovedAmount AS ApprovedAmount,PC.ExpenseAmount AS ExpenseAmount,0 AS OP,
		CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,(US.FirstName+' '+US.LastName) AS Processedby,
		PC.RequestedUserId AS RequestedUserId, PC.Id,
		PC.PropertyId,0 AS PCId
		From  WRBHBPCExpenseApproval PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PU.UserId=@UserId AND PC.Process=1 AND
		ProcessedStatus !='Accounted and Closed by Finance Manager ' AND 
		P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')	
		
				
		INSERT INTO #Request(Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,ApprovedAmount,ExpenseAmount,OP,Processedon,Processedby,
		RequestedUserId,Id,PropertyId,PCId)
		
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		'Waiting For Operation Manager Approval' AS ProcessedStatus,'Processing' AS Comments,
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS RequestedOn,0 AS Process,
		(PC.Amount) AS ApprovedAmount,(PC.Paid) AS ExpenseAmount,PH.OPeningBalance,
		CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,(U.FirstName+' '+U.LastName) AS Processedby,
		PC.UserId AS RequestedUserId, 0 AS Id,PC.PropertyId,PC.Id AS PCId
		From WRBHBPettyCashStatus PC
		JOIN WRBHBPettyCashHdr PH ON PC.PropertyId=PH.PropertyId AND PH.IsActive=1 AND PH.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PC.Flag=1 
		AND PU.UserId=@UserId 
		AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head')
		END
		
		SELECT Requestedby,PCAccount,ProcessedStatus,Comments,
		RequestedOn,Process,SUM(ApprovedAmount)+(OP) AS ApprovedAmount,SUM(ExpenseAmount) AS ExpenseAmount,
		Processedon,Processedby,RequestedUserId,Id,PropertyId 
		FROM #Request
		group by Requestedby,PCAccount,ProcessedStatus,Comments,OP,
		RequestedOn,Process,Processedon,Processedby,RequestedUserId,Id,PropertyId
		

END
 IF @Action='History'
 BEGIN
        --table1
        SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS RequestedOn,'Submitted' AS Status,
		SUM(PC.Amount) AS Amount,PH.OpeningBalance From WRBHBPettyCashStatus PC
		JOIN WRBHBPettyCashHdr PH ON PC.PropertyId=PH.PropertyId AND PC.UserId=PH.UserId AND PH.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		group by  U.FirstName,U.LastName,P.PropertyName,CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103),
		PC.Status,PC.UserId,PC.PropertyId,PH.OpeningBalance
		--table2
		Select  DISTINCT 
		CONVERT(NVARCHAR(100),PC.CreatedDate,103) AS RequestedOn,
		PC.Amount AS ApprovedAmount,PC.Paid AS ExpenseAmount,ExpenseHead,Description,PC.BillLogo As Bill,PC.Id AS Id
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
		
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon		
		From WRBHBNewPCExpenseApproval PC
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103);
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		
		SELECT DISTINCT	(U.FirstName+' '+U.LastName) AS UserName,'Submitted' AS Status,'' AS Comments,
		CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103) AS Processedon
	    FROM WRBHBPettyCashStatus P
		JOIN WRBHBUser U ON  P.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE P.UserId=@UserId AND P.PropertyId=@PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		
		SELECT UserName,Status,Comments,Processedon FROM #User ORDER BY Processedon DESC
	END
	
 END
 
 




