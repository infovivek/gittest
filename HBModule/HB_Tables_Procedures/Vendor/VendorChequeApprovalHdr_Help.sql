SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_VendorChequeApprovalHdr_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_VendorChequeApprovalHdr_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (30/05/2014)  >
Section  	: VendorChequeApproval HELP
Purpose  	: VendorChequeApproval HELP
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

CREATE PROCEDURE dbo.[SP_VendorChequeApprovalHdr_Help]
(
@Action NVARCHAR(100),
@UserId		BIGINT,
@CreatedById BIGINT,
@Str		NVARCHAR(100)
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
		CREATE TABLE #Request(Requestedby NVARCHAR(100),RequestedOn NVARCHAR(100),
		RequestedAmount DECIMAL(27,2),PropertyName NVARCHAR(100),Status NVARCHAR(100),Process BIT,
		Processedby NVARCHAR(100),Processedon NVARCHAR(100),Id INT,RequestedUserId INT,PropertyId INT,UserId INT)
		
		INSERT INTO #Request(Requestedby,RequestedOn,
		RequestedAmount,PropertyName,Status,Process,Processedby,Processedon,Id,RequestedUserId,PropertyId,UserId)
		
		SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,
		CONVERT(NVARCHAR(100),VC.RequestedOn,103) AS RequestedOn,VC.RequestedAmount AS RequestedAmount,
		P.PropertyName,
		VC.Status AS Status,0 AS Process,(US.FirstName+' '+US.LastName) AS Processedby,
		CONVERT(NVARCHAR(100),VC.Processedon,103) AS Processedon, VC.Id,VC.RequestedUserId AS RequestedUserId,
		VC.PropertyId,VC.UserId
		From WRBHBVendorChequeApprovalDtl VC
		JOIN WRBHBProperty P ON VC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  VC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON VC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND PU.UserId=@UserId 
		AND VC.Process=1 AND
		VC.Status !='Acknowledged' AND
		P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')	
		
		INSERT INTO #Request(Requestedby,RequestedOn,RequestedAmount,PropertyName,Status,Process,Processedon,
		Processedby,Id,RequestedUserId,PropertyId,UserId)
		
		SELECT (U.FirstName+' '+U.LastName) AS Requestedby,CONVERT(NVARCHAR(100),VC.Date,103) AS RequestedOn,
		SUM(VC.Amount) AS RequestAmount,P.PropertyName,'Waiting For Operation Manager Approval' AS Status,0 AS Process,
		CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,'Process' AS Processedby,
		0 AS Id,VC.UserId AS RequestedUserId,VC.PropertyId,0 AS UserId
		FROM WRBHBVendorRequest VC
		JOIN WRBHBProperty P ON VC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON VC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.Flag=1 AND VC.Partial=0
		AND PU.UserId=@UserId AND VC.Partial=0
		AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')
		GROUP BY U.FirstName,U.LastName,P.PropertyName,VC.Date,VC.UserId,VC.PropertyId
		
				
		SELECT  Requestedby,RequestedOn,sum(RequestedAmount) AS RequestedAmount,PropertyName AS Property,Status,
		Process,Processedon,Processedby,Id,RequestedUserId,PropertyId 
		FROM #Request
		group by  Requestedby,RequestedOn,PropertyName,Status,
		Process,Processedon,Processedby,Id,RequestedUserId,PropertyId 
		
END
 IF @Action='History'
 BEGIN
        --table1
        SELECT CONVERT(NVARCHAR(100),GETDATE(),103) AS BillDate,
		VR.Service AS ExpenseHead,VR.VendorName AS VendorName,
		P.PropertyName AS Property,VR.Duedate AS DueDate,VR.Type,'Cheque' AS PaymentMode,VR.BillNo,SUM(VR.Amount) AS RequestedAmount,VR.UserId,
		VR.PropertyId,VR.Id
		FROM WRBHBVendorRequest VR
		JOIN WRBHBProperty P ON VR.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE VR.UserId=@UserId AND VR.PropertyId=@CreatedById AND 
		VR.IsActive=1 AND VR.IsDeleted=0 AND VR.Partial=0
		AND VR.Date=CONVERT(Date,@Str,103)
		group by VR.Service,VR.VendorName,P.PropertyName,VR.Duedate ,VR.Type,VR.BillNo,VR.UserId,VR.PropertyId,VR.Id
		
		
			
		SELECT DISTINCT(U.FirstName+' '+U.LastName) AS Requestedby,CONVERT(NVARCHAR(100),GETDATE(),103) AS
		RequestedOn
		FROM WRBHBVendorRequest VR
		JOIN WRBHBUser U ON VR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE VR.UserId=@UserId AND VR.PropertyId=@CreatedById AND U.IsActive=1 AND U.IsDeleted=0 
       
       
        CREATE TABLE #Final(BillDate NVARCHAR(100),ExpenseHead NVARCHAR(100),VendorName NVARCHAR(100),
        Property NVARCHAR(100),Duedate NVARCHAR(100),Type NVARCHAR(100),PaymentMode NVARCHAR(100),BillNo NVARCHAR(100),
        RequestedAmount NVARCHAR(100),UserId NVARCHAR(100),PropertyId NVARCHAR(100),Id NVARCHAR(100))
        
        INSERT INTO #Final(BillDate,ExpenseHead,VendorName,Property,Duedate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id)
        
        SELECT CONVERT(NVARCHAR(100),GETDATE(),103) AS BillDate,
		VR.Service AS ExpenseHead,VR.VendorName AS VendorName,
		P.PropertyName AS Property,VR.Duedate,VR.Type,'Cheque' AS PaymentMode,VR.BillNo,SUM(VR.Amount) AS RequestedAmount,VR.UserId,
		VR.PropertyId,VR.Id
		FROM WRBHBVendorRequest VR
		JOIN WRBHBProperty P ON VR.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE VR.UserId=@UserId AND VR.PropertyId=@CreatedById AND 
		VR.IsActive=1 AND VR.IsDeleted=0 AND VR.Partial=0
		AND VR.Date=CONVERT(Date,@Str,103)
		group by VR.Service,VR.VendorName,P.PropertyName,VR.Duedate,VR.Type,VR.BillNo,VR.UserId,VR.PropertyId,VR.Id
		
		INSERT INTO #Final(BillDate,ExpenseHead,VendorName,Property,Duedate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id)
        
        SELECT '' AS BillDate,
		'' AS ExpenseHead,'' AS VendorName,'' AS Property,'','','' AS PaymentMode,'',
		CONVERT(NVARCHAR(100),'',103) AS RequestedAmount,CONVERT(NVARCHAR(100),'',103),
		CONVERT(NVARCHAR(100),'',103),CONVERT(NVARCHAR(100),'',103)
		
		INSERT INTO #Final(BillDate,ExpenseHead,VendorName,Property,Duedate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id)
        
        SELECT '' AS BillDate,
		'' AS ExpenseHead,'' AS VendorName,'' AS Property,'','','' AS PaymentMode,'',CONVERT(NVARCHAR(100),'',103) AS RequestedAmount,CONVERT(NVARCHAR(100),'',103),
		CONVERT(NVARCHAR(100),'',103),CONVERT(NVARCHAR(100),'',103)
		
		INSERT INTO #Final(BillDate,ExpenseHead,VendorName,Property,Duedate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id)
		
		SELECT '' AS BillDate,
		'' AS ExpenseHead,'' AS VendorName,'' AS Property,'','','' AS PaymentMode,'',CONVERT(NVARCHAR(100),'',103) AS RequestedAmount,CONVERT(NVARCHAR(100),'',103),
		CONVERT(NVARCHAR(100),'',103),CONVERT(NVARCHAR(100),'',103)
		
		INSERT INTO #Final(BillDate,ExpenseHead,VendorName,Property,Duedate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id)
        SELECT 'Resident Manager' AS BillDate,
		'Operations Manager' AS ExpenseHead,'Head Operations' AS VendorName,'Account Manager' AS Property,'',
		'Total' AS Type,SUM(Amount) AS PaymentMode,'',CONVERT(NVARCHAR(100),'',103) AS RequestedAmount,CONVERT(NVARCHAR(100),'',103),
		CONVERT(NVARCHAR(100),'',103),CONVERT(NVARCHAR(100),'',103) 
		FROM WRBHBVendorRequest WHERE UserId=@UserId AND PropertyId=@CreatedById AND 
		IsActive=1 AND IsDeleted=0 AND Partial=0
		AND Date=CONVERT(Date,@Str,103)
		
		
		
		SELECT CONVERT(NVARCHAR(100),BillDate,105) AS BillDate,ExpenseHead,
		VendorName,Property,Duedate AS DueDate,Type,PaymentMode,BillNo,RequestedAmount,
        UserId,PropertyId,Id FROM #Final		
		
 END
 IF @Action='Action'
 BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Processedon NVARCHAR(100))
			
		INSERT INTO #User(UserName,Status,Processedon)
		
		SELECT DISTINCT (US.FirstName+' '+US.LastName) AS UserName, VC.Status,
		CONVERT(NVARCHAR(100),VC.Processedon,103) AS Processedon		
		From WRBHBVendorChequeApprovalNewDtl VC
		JOIN WRBHBUser US ON  VC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE VC.RequestedUserId=@UserId AND VC.PropertyId=@CreatedById AND  VC.IsActive=1 AND VC.IsDeleted=0
		AND VC.RequestedOn=CONVERT(NVARCHAR,@Str,103)
				
		INSERT INTO #User(UserName,Status,Processedon)
		
		SELECT DISTINCT(U.FirstName+' '+U.LastName) AS UserName,
		'Waiting' AS Status,CONVERT(NVARCHAR(100),VR.Date,103) AS Processedon
		FROM WRBHBVendorRequest VR
		JOIN WRBHBUser U ON VR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE VR.UserId=@UserId AND VR.PropertyId=@CreatedById AND VR.IsActive=1 AND VR.IsDeleted=0 
		AND VR.Date=CONVERT(Date,@Str,103)
		
		SELECT UserName,Status,Processedon 
		FROM #User ORDER BY Processedon ASC
	END
	IF(@Action='DownloadReport')
	BEGIN
			SELECT VendorBill FROM WRBHBVendorRequest  
			WHERE PropertyId=@CreatedById AND UserId=@UserId AND Id=CAST(@Str AS BIGINT) 
			AND IsActive=1 AND IsDeleted=0
			--http:sstage.in/Client_images/Gas_1. Gas cylinder 1760.jpg    
	END
	
	IF @Action='Delete'
	BEGIN
		 UPDATE WRBHBVendorRequest SET Partial=1,ModifiedBy=@UserId,ModifiedDate=GETDATE()
		 WHERE UserId=@UserId AND Id=@CreatedById;
	END
	
 END
 




