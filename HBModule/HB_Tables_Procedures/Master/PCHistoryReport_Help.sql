SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PCHistoryReport_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PCHistoryReport_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (30/05/2014)  >
Section  	: PETTYCASH REQUESTED HELP
Purpose  	: PETTYCASH REQUESTED HELP
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

CREATE PROCEDURE dbo.[SP_PCHistoryReport_Help]
(
@Action NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT,
@Str    NVARCHAR(100),
@Str1    NVARCHAR(100))
 AS
 BEGIN
 IF @Action='Pageload'
	BEGIN
		--table property
		SELECT DISTINCT PU.UserId as UserId,P.PropertyName AS Property,P.Id AS PropertyId
		FROM WRBHBPropertyUsers  PU 
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPettyCashApprovalHdr PC on P.Id=Pc.PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		WHERE PU.UserId=@UserId	AND PU.IsActive=1 AND PU.IsDeleted=0 
		AND P.Category IN('Internal Property','Managed G H')
	
    	--table gridload
		SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		PC.RequestedStatus AS RequestedStatus,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.RequestedOn,105) AS RequestedOn,0 AS Process,
		PC.RequestedAmount AS RequestedAmount,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,105) AS Processedon,(US.FirstName+' '+US.LastName) AS ProcessedBy,
		PC.RequestedUserId AS RequestedUserId, PC.Id,
		PC.PropertyId
		From WRBHBPettyCashApprovalDtl PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PU.UserId=@UserId
		
		
		
	END
IF(@Action='USERLOAD')
	BEGIN
	SELECT DISTINCT UserName,UserId AS Id FROM WRBHBPropertyUsers 
	WHERE PropertyId=@Id AND IsActive=1 AND IsDeleted=0
END

IF(@Action='GRIDLOAD')
	BEGIN
		CREATE TABLE #Request(Requestedby NVARCHAR(100),PCAccount NVARCHAR(100),RequestedStatus NVARCHAR(100),
		ProcessedStatus NVARCHAR(100),Comments NVARCHAR(100),RequestedOn NVARCHAR(100),Process BIT,
		RequestedAmount DECIMAL(27,2),Processedon NVARCHAR(100),Processedby NVARCHAR(100),RequestedUserId INT,Id INT,PropertyId INT)
		
		IF(@Id !=0)
		BEGIN	
			INSERT INTO #Request(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
			RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
			
			SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,PC.RequestedStatus AS RequestedStatus,
			PC.ProcessedStatus,PC.Comments AS Comments,
			CONVERT(NVARCHAR(100),PC.RequestedOn,105) AS RequestedOn,0 AS Process,
			PC.RequestedAmount AS RequestedAmount,
			CONVERT(NVARCHAR(100),PC.LastProcessedon,105) AS Processedon,(US.FirstName+' '+US.LastName) AS ProcessedBy,
			PC.RequestedUserId AS RequestedUserId, PC.Id,
			PC.PropertyId
			From WRBHBPettyCashApprovalDtl PC
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
			WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PC.PropertyId=@Id AND PC.RequestedUserId=@UserId
			AND  PC.ProcessedStatus=@Str
			
			INSERT INTO #Request(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
			RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
			
			SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount
			,PC.Status AS RequestedStatus,'Waiting For Operation Manager Approval' AS ProcessedStatus,'Processing' AS Comments,
			CONVERT(NVARCHAR(100),PH.Date,103) AS RequestedOn,0 AS Process,
			SUM(PC.ApprovedAmount) AS RequestedAmount,CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,
			(U.FirstName+' '+U.LastName) AS Processedby,PH.UserId AS RequestedUserId, 0 AS Id,
			PH.PropertyId
			From WRBHBPettyCash PC
			JOIN WRBHBPettyCashHdr PH ON PC.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
			JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBPropertyUsers PU ON PH.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
			JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
			WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PH.Flag=0 
			AND PC.Remark=0 AND PU.UserId=@UserId AND PH.PropertyId=@Id AND PC.Status='Submitted' 
			AND P.Category IN('Internal Property','Managed G H')
			AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
			'Ops Head','Finance')
			group by  U.FirstName,U.LastName,P.PropertyName,PC.Status,PH.Date,PH.UserId,PH.PropertyId
		END
		ELSE
		BEGIN
			INSERT INTO #Request(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
			RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
			
			SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,PC.RequestedStatus AS RequestedStatus,
			PC.ProcessedStatus,PC.Comments AS Comments,
			CONVERT(NVARCHAR(100),PC.RequestedOn,105) AS RequestedOn,0 AS Process,
			PC.RequestedAmount AS RequestedAmount,
			CONVERT(NVARCHAR(100),PC.LastProcessedon,105) AS Processedon,(US.FirstName+' '+US.LastName) AS ProcessedBy,
			PC.RequestedUserId AS RequestedUserId, PC.Id,
			PC.PropertyId
			From WRBHBPettyCashApprovalDtl PC
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
			WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND  PC.ProcessedStatus=@Str
			
		
			INSERT INTO #Request(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
			RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
			
			SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount
			,PC.Status AS RequestedStatus,'Waiting For Operation Manager Approval' AS ProcessedStatus,'Processing' AS Comments,
			CONVERT(NVARCHAR(100),PH.Date,103) AS RequestedOn,0 AS Process,
			SUM(PC.ApprovedAmount) AS RequestedAmount,CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,
			(U.FirstName+' '+U.LastName) AS Processedby,PH.UserId AS RequestedUserId, 0 AS Id,
			PH.PropertyId
			From WRBHBPettyCash PC
			JOIN WRBHBPettyCashHdr PH ON PC.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
			JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN WRBHBPropertyUsers PU ON PH.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
			JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
			WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PH.Flag=0 
			AND PC.Remark=0 AND PC.Status='Submitted' AND @Str='Waiting For Operation Manager Approval'
			AND P.Category IN('Internal Property','Managed G H')
			AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
			'Ops Head','Finance')
			group by  U.FirstName,U.LastName,P.PropertyName,PC.Status,PH.Date,PH.UserId,PH.PropertyId
		 
		END
		
		SELECT Requestedby,PCAccount,RequestedStatus,ProcessedStatus AS Status,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby AS ProcessedBy,RequestedUserId,Id,PropertyId
		FROM #Request
		
		
	END
IF @Action='History'
 BEGIN
        --table1
        SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR(100),PH.Date,103) AS RequestedOn,PC.Status AS Status,SUM(PC.Amount) AS Amount,
		SUM(PC.ApprovedAmount) AS ApprovedAmount
		From WRBHBPettyCash PC
		JOIN WRBHBPettyCashHdr PH  ON PC.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
		JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PH.UserId=@UserId AND PH.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		AND CONVERT(Date,PH.Date,105)=CONVERT(Date,@Str,105)
		group by  U.FirstName,U.LastName,P.PropertyName,PC.Status,PH.Date,PH.UserId,PH.PropertyId
		
		--table2
		Select  DISTINCT 
		CONVERT(NVARCHAR(100),PH.Date,103) AS RequestedOn,
		PC.Amount AS RequestedAmount,PC.ApprovedAmount AS ApprovedAmount,ExpenseHead,Description,
		PC.Id AS Id,PH.PropertyId,PH.UserId,
		PH.ExpenseGroupId,ISNULL(PC.Comments,'') AS Comments
		From WRBHBPettyCash PC
		JOIN WRBHBPettyCashHdr PH ON PC.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
		JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE PH.UserId=@UserId AND 
		PH.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0 
		AND CONVERT(Date,PH.Date,105)=CONVERT(Date,@Str,105) 
		
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
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103);
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT	(U.FirstName+' '+U.LastName) AS UserName,P.Status AS Status,'' AS Comments,
		CONVERT(NVARCHAR(100),PC.Date,103) AS Processedon
	    FROM WRBHBPettyCash P
	    JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1  AND PC.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@Id AND P.IsActive=1 AND P.IsDeleted=0
		AND PC.Date=CONVERT(Date,@Str,103)
		
		SELECT UserName,Status,Comments,Processedon FROM #User ORDER BY CONVERT(date,Processedon,103) ASC
	END

	
END