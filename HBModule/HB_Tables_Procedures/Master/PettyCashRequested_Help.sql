SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PettyCashRequested_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PettyCashRequested_Help]

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

CREATE PROCEDURE dbo.[SP_PettyCashRequested_Help]
(
@Action NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
   --Property
    SELECT DISTINCT PU.UserId as UserId,P.PropertyName Property,P.Id PropertyId
	FROM WRBHBPropertyUsers  PU JOIN WRBHBProperty P
	ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	WHERE PU.UserId=4
	AND PU.IsActive=1 AND PU.IsDeleted=0
	
	--SELECT RoleName FROM WRBHBRoles
	
	
 END
 IF @Action='Requested'
 BEGIN
		Select  DISTINCT U.UserName AS Requestedby,P.PropertyName AS PCAccount,PC.Status AS Status,
		CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn,
		PC.TotalAmount AS RequestedAmount,US.UserName AS LastProcessedby,
		CONVERT(NVARCHAR(100),PC.ModifiedDate,103) AS LastProcessedon,
		PC.ProcessStatus AS Comments,PC.PropertyId,PC.UserId 
		From WRBHBPettyCash PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser US ON  PC.UserId1=US.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		
 END
 IF @Action='History'
 BEGIN
        --table1
        SELECT DISTINCT U.UserName AS Requestedby,P.PropertyName AS PCAccount,
		CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn,PC.Status AS Status,
		PC.TotalAmount AS Amount From WRBHBPettyCash PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser US ON  PC.UserId1=US.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		--table2
		Select  DISTINCT 
		CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn,
		PC.Amount AS RequestedAmount,ExpenseHead,Description
		From WRBHBPettyCash PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser US ON  PC.UserId1=US.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		
 END
 IF @Action='Action'
 BEGIN
		--table1
		SELECT DISTINCT U.UserName AS Requestedby,PC.Status AS Status,
		CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn
		From WRBHBPettyCash PC
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON  PC.UserId1=US.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.UserId=@UserId AND  PC.IsActive=1 AND PC.IsDeleted=0
		--table2
		SELECT DISTINCT US.UserName AS LastProcessedby,PC.ProcessStatus AS Comments,
		CONVERT(NVARCHAR(100),PC.ModifiedDate,103) AS LastProcessedon
		From WRBHBPettyCash PC
		JOIN WRBHBUser US ON  PC.UserId1=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.UserId=@UserId AND  PC.IsActive=1 AND PC.IsDeleted=0
		--table3
		--SELECT  U.UserName AS Requestedby,PC.Status AS Status,CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn
		--From WRBHBPettyCash PC
		--JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		--JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		--JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		--JOIN WRBHBUser US ON  PC.UserId1=US.Id AND U.IsActive=1 AND U.IsDeleted=0
		--WHERE PC.UserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
 END
 END
 
 
 



