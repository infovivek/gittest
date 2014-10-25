SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashreport_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashreport_Help
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (05/06/2014)  >
Section  	: PETTYCASH  SELECT
Purpose  	: PETTYCASH SELECT
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
CREATE PROCEDURE Sp_PettyCashreport_Help
(
@Action NVARCHAR(100),
@Id			INT,
@UserId		INT,
@Str		NVARCHAR(100),
@Str1		NVARCHAR(100)
)
AS
BEGIN
IF(@Action='PAGELOAD')
BEGIN
 --PROPERTY
  SELECT DISTINCT PropertyName AS Property,Id AS Id 
  FROM WRBHBProperty  
  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('Internal Property','Managed G H')
END

IF(@Action='USERLOAD')
BEGIN
	SELECT DISTINCT UserName,UserId AS Id FROM WRBHBPropertyUsers 
	WHERE PropertyId=@Id AND IsActive=1 AND IsDeleted=0
END
IF(@Action='GRIDLOAD')
BEGIN
		CREATE TABLE #Final(UserName NVARCHAR(100),ProcessedOn NVARCHAR(100),
		TransferredAmount DECIMAL(27,2),Fortnight NVARCHAR(100))
		
		IF(@Str ='First')
		BEGIN
		INSERT INTO #Final(UserName,ProcessedOn,TransferredAmount,Fortnight)
			SELECT (S.FirstName+''+S.LastName) AS UserName,
			CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103) AS ProcessedOn,U.Amount,1 
			FROM WRBHBPettyCashStatus U 
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			WHERE U.UserId=@UserId AND U.PropertyId=@Id AND U.IsActive=0 AND U.IsDeleted=1
			AND  CONVERT(date,CAST(DATEADD(mm, DATEDIFF(mm, 0, U.CreatedDate), 0) AS Date),103)=
			Convert(date,@Str1,103)
			group by S.FirstName,S.LastName,U.CreatedDate,U.Amount
		END
		ELSE IF(@Str ='Second')
		BEGIN
		INSERT INTO #Final(UserName,ProcessedOn,TransferredAmount,Fortnight)
			SELECT (S.FirstName+''+S.LastName) AS UserName,
			CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103) AS ProcessedOn,U.Amount,2 
			FROM WRBHBPettyCashStatus U 
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			WHERE U.UserId=@UserId AND U.PropertyId=@Id AND U.IsActive=0 AND U.IsDeleted=1
			AND CONVERT(date,CAST(DATEADD(mm, DATEDIFF(mm, 0, U.CreatedDate), 0) AS Date),103)=
			Convert(date,@Str1,103)
			group by S.FirstName,S.LastName,U.CreatedDate,U.Amount
		END
		ELSE IF(@Str ='All')
		BEGIN
		INSERT INTO #Final(UserName,ProcessedOn,TransferredAmount,Fortnight)
			SELECT (S.FirstName+''+S.LastName) AS UserName,
			CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103) AS ProcessedOn,U.Amount,3 
			FROM WRBHBPettyCashStatus U 
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			WHERE U.UserId=@UserId AND U.PropertyId=@Id AND U.IsActive=0 AND U.IsDeleted=1
			AND MONTH(CONVERT (date,U.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,U.CreatedDate,U.Amount
		END
		
		CREATE TABLE #FinalReport(UserName NVARCHAR(100),ProcessedOn NVARCHAR(100),
		TransferredAmount DECIMAL(27,2))
		
		INSERT #FinalReport(UserName,ProcessedOn,TransferredAmount)
		SELECT UserName,ProcessedOn,SUM(TransferredAmount)AS TransferredAmount
		FROM #Final
		WHERE (day(Convert(datetime,ProcessedOn)-1) / 15) + 1=1 AND Fortnight=1
		GROUP BY UserName,ProcessedOn
		
		
		INSERT #FinalReport(UserName,ProcessedOn,TransferredAmount)
		SELECT UserName,ProcessedOn,SUM(TransferredAmount)AS TransferredAmount
		FROM #Final
		WHERE (day(Convert(datetime,ProcessedOn)-1) / 15) + 1=2 AND Fortnight=2
		GROUP BY UserName,ProcessedOn
		
		INSERT #FinalReport(UserName,ProcessedOn,TransferredAmount)
		SELECT UserName,ProcessedOn,SUM(TransferredAmount)AS TransferredAmount
		FROM #Final
		WHERE  Fortnight=3
		GROUP BY UserName,ProcessedOn
		
		SELECT UserName,ProcessedOn,TransferredAmount FROM #FinalReport
END
IF @Action='Action'
 BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Comments NVARCHAR(100),Processedon NVARCHAR(100))
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		
		SELECT DISTINCT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon		
		From WRBHBNewPCExpenseApproval PC
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103);
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT	(U.FirstName+' '+U.LastName) AS UserName,P.Status AS Status,'' AS Comments,
		CONVERT(NVARCHAR(100),PH.Date,103) AS Processedon
	    FROM WRBHBPettyCash P
	    JOIN WRBHBPettyCashHdr PH ON P.PettyCashHdrId= PH.Id AND PH.IsActive=0 AND PH.IsDeleted=1
		JOIN WRBHBUser U ON  PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PH.UserId=@UserId AND PH.PropertyId=@Id AND P.IsActive=1 AND P.IsDeleted=0
		AND PH.Date=CONVERT(Date,@Str,103)
		
		SELECT UserName,Status,Comments,Processedon FROM #User 
		ORDER BY CONVERT(date,Processedon,103) ASC
	END

IF(@Action='SpendReport')
BEGIN
		CREATE TABLE #PettyCash(Id BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
		Date NVARCHAR(100),ExpenseHead NVARCHAR(100),Description NVARCHAR(100),
		ApprovedAmount DECIMAL(27,2),PaidAmount DECIMAL(27,2),
		Bill NVARCHAR(100),ExpenseId INT)
		
		INSERT INTO #PettyCash(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill,ExpenseId)
		SELECT CONVERT(NVARCHAR,CAST(CONVERT(Date,U.CreatedDate,103) AS Date),110),
		U.ExpenseHead,U.Description,U.Amount,U.Paid,'',U.Id
		FROM WRBHBPettyCashStatus U 
		JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
		WHERE U.UserId =@UserId AND U.PropertyId=@Id AND U.IsActive=0 AND U.IsDeleted=1
		AND CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103) 
		
		
		SELECT Id AS SNo,Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill,ExpenseId AS Id
		FROM #PettyCash  
		
		SELECT (FirstName+''+Lastname) AS UserName  FROM WRBHBUser 
		WHERE IsActive=1 AND IsDeleted=0 AND Id=@UserId
		
		SELECT Propertyname FROM WRBHBProperty
		WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id
		
		
		
		CREATE TABLE #PettyCash1(Id BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
		Date NVARCHAR(100),ExpenseHead NVARCHAR(100),Description NVARCHAR(100),
		ApprovedAmount NVARCHAR(100),PaidAmount NVARCHAR(100),
		Bill NVARCHAR(100))
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'UserName' AS ExpenseHead,(U.FirstName+''+U.LastName) AS Description,'Property' AS ApprovedAmount,
		P.PropertyName AS PaidAmount,'' AS Bill FROM WRBHBProperty P
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON PU.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE U.Id=@UserId AND P.Id=@Id AND P.IsActive=1 AND P.IsDeleted=0
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'OpeningBalance' AS ApprovedAmount,
		OpeningBalance AS PaidAmount,'' AS Bill FROM WRBHBPettyCashHdr
		WHERE UserId =@UserId AND PropertyId=@Id AND Date=CONVERT(Date,@Str,103) AND IsActive=0 AND IsDeleted=1
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'AmountReceived' AS ApprovedAmount,
		SUM(P.ApprovedAmount) AS PaidAmount,'' AS Bill FROM WRBHBPettyCashHdr PC
		JOIN WRBHBPettyCash P ON PC.Id=P.PettyCashHdrId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE UserId =@UserId AND PropertyId=@Id AND Date=CONVERT(Date,@Str,103) AND PC.IsActive=0 AND PC.IsDeleted=1
			
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT CONVERT(NVARCHAR,CONVERT(DATE,CAST(U.CreatedDate AS Date),103),110),
		U.ExpenseHead,U.Description,U.Amount,U.Paid,U.BillLogo
		FROM WRBHBPettyCashStatus U 
		JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
		WHERE U.UserId =@UserId AND U.PropertyId=@Id AND U.IsActive=0 AND U.IsDeleted=1
		AND CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
	
				
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'TotalAmount' AS Description,SUM(Amount) AS ApprovedAmount,SUM(Paid) AS PaidAmount,
		'' AS Bill
		FROM WRBHBPettyCashStatus 
		WHERE UserId =@UserId AND PropertyId=@Id AND IsActive=0 AND IsDeleted=1
		AND CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'ClosingBalance' AS ApprovedAmount,ClosingBalance AS PaidAmount,
		'' AS Bill FROM WRBHBPettyCashHdr
		WHERE UserId =@UserId AND PropertyId=@Id AND Date=CONVERT(Date,@Str,103) AND IsActive=0 AND IsDeleted=1
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'Resident Manager','Operations Manager','Head Operations','Account Manager',
		'' AS Bill 
		
		
		SELECT Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill
		FROM #PettyCash1
		
		SELECT OpeningBalance FROM WRBHBPettyCashHdr
		WHERE UserId =@UserId AND PropertyId=@Id AND IsActive=0 AND IsDeleted=1
		AND CONVERT(date,Date,103)=CONVERT(date,@Str,103)
		
		SELECT DISTINCT Balance FROM WRBHBPettyCashStatus
		WHERE UserId =@UserId AND PropertyId=@Id AND IsActive=0 AND IsDeleted=1
		AND CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
END
IF(@Action='DownloadReport')
BEGIN
		SELECT BillLogo FROM WRBHBPettyCashStatus  
		WHERE PropertyId=@Id AND UserId=@UserId AND Id=CAST(@Str AS BIGINT) AND IsActive=0 AND IsDeleted=1
		--http:sstage.in/Client_images/Gas_1. Gas cylinder 1760.jpg    
END
IF(@Action='PCNewReport')
BEGIN
		DECLARE @Cnt int
			
        CREATE TABLE #PCNEW(Requestedby NVARCHAR(100),RequestedOn NVARCHAR(100),
        ExpenseHead NVARCHAR(100),ExpenseItem NVARCHAR(100),Description NVARCHAR(100),Amount DECIMAL(27,2),
        BillDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),Property NVARCHAR(100),
        Id bigint IDENTITY(1,1)  NOT NULL PRIMARY KEY)
        
        
		INSERT INTO #PCNEW(Requestedby,RequestedOn,ExpenseHead,ExpenseItem,Description,Amount,
		BillDate,BillStartDate,BillEndDate,Property)
	
		SELECT (U.FirstName+''+U.LastName) AS Requestedby,Convert(VARCHAR(100),CONVERT(DATE,PH.Date,103),110) 
		AS RequestedOn,EG.ExpenseHead,PC.ExpenseHead AS ExpenseItem,PC.Description,ApprovedAmount AS Amount,
		CONVERT(NVARCHAR,CONVERT(DATE,PS.BillDate,103),110),CONVERT(NVARCHAR,CONVERT(Date,@Str,103),110) AS Startdate,
		CONVERT(NVARCHAR,CONVERT(Date,@Str1,103),110) AS EndDate,P.PropertyName 
		FROM WRBHBPettyCash PC  
		JOIN WRBHBPettyCashHdr PH ON PC.PettyCashHdrId= PH.Id AND PH.IsActive=0 AND PH.IsDeleted=1
		JOIN WRBHBPettyCashStatus PS ON PH.ClosingBalance=PS.Balance AND PS.IsActive=0 AND PS.IsDeleted=1
		JOIN WRBHBExpenseHeads EX ON PC.ExpenseHead=EX.HeaderName
		JOIN WRBHBExpenseGroup EG ON EX.ExpenseGroupId=EG.Id
		JOIN WRBHBUser U ON PH.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBProperty P ON PH.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 
		AND	PH.Date BETWEEN CONVERT(date,@Str,103) AND CONVERT(date,@Str1,103)
		GROUP BY U.FirstName,U.LastName,PH.Date,EG.ExpenseHead,PC.ExpenseHead,PC.Description,
		ApprovedAmount,PS.BillDate,P.PropertyName
		ORDER BY PH.Date
		
		SELECT Id as SNo,Requestedby,RequestedOn,ExpenseHead,ExpenseItem,Description,Amount,
		BillDate,BillStartDate,BillEndDate,Property	FROM #PCNEW 
			
		
END	
END



 
