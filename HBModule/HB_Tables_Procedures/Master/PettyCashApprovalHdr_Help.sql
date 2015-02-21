SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PettyCashApprovalHdr_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PettyCashApprovalHdr_Help]

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

CREATE PROCEDURE dbo.[SP_PettyCashApprovalHdr_Help]
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
 		CREATE TABLE #Request(Requestedby NVARCHAR(100),PCAccount NVARCHAR(100),RequestedStatus NVARCHAR(100),
		ProcessedStatus NVARCHAR(100),Comments NVARCHAR(100),RequestedOn NVARCHAR(100),Process BIT,
		RequestedAmount DECIMAL(27,2),Processedon NVARCHAR(100),Processedby NVARCHAR(100),RequestedUserId INT,Id INT,PropertyId INT)
		
		
		BEGIN
		INSERT INTO #Request(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
		
		SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,PC.RequestedStatus AS RequestedStatus,
		PC.ProcessedStatus AS ProcessedStatus,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.RequestedOn,103) AS RequestedOn,0 AS Process,
		PC.RequestedAmount AS RequestedAmount,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon,(US.FirstName+' '+US.LastName) AS Processedby,
		PC.RequestedUserId AS RequestedUserId, PC.Id,
		PC.PropertyId
		From WRBHBPettyCashApprovalDtl PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PU.UserId=@UserId AND ProcessedStatus !='Acknowledged '
		AND PC.Process=1 AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')	
		
				
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
		AND PC.Remark=0 AND PU.UserId=@UserId 
		AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')
		group by  U.FirstName,U.LastName,P.PropertyName,PC.Status,PH.Date,PH.UserId,PH.PropertyId
		
		END
		
		SELECT Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId 
		FROM #Request
     
END
 IF @Action='History'
 BEGIN
        --table1
        SELECT DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR(100),PH.Date,103) AS RequestedOn,PC.Status AS Status,SUM(PC.Amount) AS RequestedAmount,
		SUM(PC.ApprovedAmount) AS ApprovedAmount,ISNULL(PH.OpeningBalance,0) AS OpeningBalance
		From WRBHBPettyCash PC
		JOIN WRBHBPettyCashHdr PH  ON PC.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
		JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PH.UserId=@UserId AND 
		PH.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PH.Date=CONVERT(Date,@Str,103)
		group by  U.FirstName,U.LastName,P.PropertyName,PC.Status,PH.Date,PH.UserId,PH.PropertyId,PH.OpeningBalance
		
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
		PH.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0 
		AND PH.Date=CONVERT(Date,@Str,103) 
 END 
 IF @Action='Action'
 BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Comments NVARCHAR(100),Processedon NVARCHAR(100))
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS UserName,P.Status AS Status,'' AS Comments,
		CONVERT(NVARCHAR(100),PC.Date,103) AS Processedon
	    FROM WRBHBPettyCash P
	    JOIN WRBHBPettyCashHdr PC ON P.PettyCashHdrId=PC.Id AND PC.IsActive=1  AND PC.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		AND PC.Date=CONVERT(Date,@Str,103)
		
		
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon	
		From WRBHBNewPettyCashApprovalDtl PC
		JOIN WRBHBNewPettyCashApprovalHdr PCH ON PC.PettyCashApprovalHdrId=PCH.Id AND PCH.IsActive=1 AND PCH.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@PropertyId AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103)
		ORDER BY PC.CreatedDate
		
		SELECT UserName,Status,Comments,Processedon FROM #User 
		GROUP BY UserName,Status,Comments,Processedon
		ORDER BY CONVERT(date,Processedon,103) ASC
	END
	--IF @Action='Delete'
	-- BEGIN
	--		 UPDATE WRBHBPettyCash SET Flag=1,ModifiedBy=@UserId,ModifiedDate=GETDATE()
	--		 WHERE Id=@PropertyId;
	-- END
 END
 


