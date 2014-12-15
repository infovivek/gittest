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
@Str1		NVARCHAR(100),
@Str2		NVARCHAR(100)
)
AS
BEGIN
IF(@Action='PAGELOAD')
BEGIN
 --PROPERTY
		SELECT DISTINCT P.PropertyName Property,P.Id Id	
		FROM WRBHBPropertyUsers  PU 
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.UserId=@UserId AND P.Category IN('Internal Property','Managed G H') AND PU.IsActive=1 AND PU.IsDeleted=0 
		ORDER BY P.Id ASC
		
		
		SELECT (S.FirstName+''+S.LastName) AS Submittedby,P.PropertyName AS Property,
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS SubmittedOn,SUM(U.Paid) AS Amount,
		'1st FortNight' AS FortNight,MONTH(CONVERT(date,PC.CreatedDate,103)) AS Month,
		PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS LastProcessedBy,'Submitted',
		CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn   
		FROM WRBHBPettyCashStatusHdr  PC
		JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
		JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
		JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE  U.IsActive=1 AND U.IsDeleted=0 
		AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,GETDATE(),103))
		group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
		
		SELECT DISTINCT PU.UserName,PU.UserId AS Id	
		FROM WRBHBPropertyUsers  PU 
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE P.Category IN('Internal Property','Managed G H') AND PU.IsActive=1 AND PU.IsDeleted=0 
	
END
IF @Action='UserLoad'
BEGIN
		SELECT DISTINCT PU.UserName,PU.UserId AS Id	
		FROM WRBHBPropertyUsers  PU 
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.PropertyId=@Id AND 
		P.Category IN('Internal Property','Managed G H') AND PU.IsActive=1 AND PU.IsDeleted=0 
		
END
IF(@Action='GRIDLOAD')
BEGIN
CREATE TABLE #Final(UserName NVARCHAR(100),Property NVARCHAR(100),ProcessedOn NVARCHAR(100),
TransferredAmount DECIMAL(27,2),Fortnight NVARCHAR(100),PropertyId INT,UserId INT,Processedby NVARCHAR(100),
Status NVARCHAR(100),LastProcessedOn NVARCHAR(100))
IF(@Id !=0)
BEGIN
IF(@UserId=0)
	BEGIN
	 IF(@Str ='First')
	 BEGIN
	 
	 		INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,1, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.PropertyId=@Id AND PC.ProcessedStatus=@Str2
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,
			PC.RequestedUserId,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon  
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,1, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn   
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND U.PropertyId=@Id AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	  END
	  ELSE IF(@Str ='Second')
	  BEGIN
	 		INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,2, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.PropertyId=@Id AND PC.ProcessedStatus=@Str2
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon   
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,2, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn    
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND U.PropertyId=@Id AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	 END
 END
 END
   
 IF(@Id !=0)
 BEGIN
 
 IF(@UserId !=0)
 BEGIN
  
	 IF(@Str ='First')
	 BEGIN
	
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,1, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.PropertyId=@Id AND PC.ProcessedStatus=@Str2
			AND PC.RequestedUserId=@UserId 
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon  
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,1, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn   
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND U.PropertyId=@Id AND PC.UserId=@UserId 
			AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	  END
	  ELSE IF(@Str ='Second')
	  BEGIN
		
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,2, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.PropertyId=@Id AND PC.ProcessedStatus=@Str2
			AND PC.RequestedUserId=@UserId 
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon   
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,
			2,PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn    
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND U.PropertyId=@Id AND PC.UserId=@UserId 
			AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	  END
END
END  
 
IF(@Id =0)
BEGIN
IF(@UserId !=0)
BEGIN
	IF(@Str ='First')
	BEGIN
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,1, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.ProcessedStatus=@Str2
			AND PC.RequestedUserId=@UserId 
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon  
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,1, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn   
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND PC.UserId=@UserId 
			AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	  END
	  ELSE IF(@Str ='Second')
	  BEGIN
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,2, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.ProcessedStatus=@Str2
			AND PC.RequestedUserId=@UserId 
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon   
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,2, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn    
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND PC.UserId=@UserId 
			AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	END
End 
ELSE
BEGIN
  
	 IF(@Str ='First')
	 BEGIN
	
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,1, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.ProcessedStatus=@Str2
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon   
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,1, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn    
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	END
    IF(@Str ='Second')
	BEGIN
			 
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,PC.RequestedOn,103) AS ProcessedOn,PC.ExpenseAmount,2, 
			PC.PropertyId,PC.RequestedUserId,(US.FirstName+''+US.LastName) AS Processedby,PC.ProcessedStatus,
			PC.LastProcessedon
			FROM WRBHBPCExpenseApproval PC
			JOIN WRBHBUser S ON PC.RequestedUserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBUser US ON PC.UserId=US.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  PC.IsActive=1 AND PC.IsDeleted=0 AND PC.ProcessedStatus=@Str2
			AND MONTH(CONVERT(date,PC.RequestedOn,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.RequestedOn,PC.ExpenseAmount,PC.PropertyId,PC.RequestedUserId
			,US.FirstName,US.LastName, PC.ProcessedStatus,PC.LastProcessedon  
			
			INSERT INTO #Final(UserName,Property,ProcessedOn,TransferredAmount,Fortnight,PropertyId,UserId,
			Processedby,Status,LastProcessedOn)
			SELECT (S.FirstName+''+S.LastName) AS UserName,P.PropertyName,
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS ProcessedOn,SUM(U.Paid) AS TransferredAmount,2, 
			PC.PropertyId,PC.UserId,(S.FirstName+''+S.LastName) AS Processedby,'Submitted',
			CONVERT(NVARCHAR,CAST(PC.CreatedDate AS Date),103) AS LastProcessedOn    
			FROM WRBHBPettyCashStatusHdr  PC
			JOIN WRBHBPettyCashStatus U ON PC.Id=U.PettyCashStatusHdrId  AND PC.IsActive=1 AND PC.IsDeleted=0
			JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
			JOIN WRBHBProperty P ON U.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			WHERE  U.IsActive=1 AND U.IsDeleted=0 AND  PC.Flag=1 AND PC.NewEntry=0
			AND MONTH(CONVERT (date,PC.CreatedDate,103))=MONTH(Convert(date,@Str1,103))
			group by S.FirstName,S.LastName,P.PropertyName,PC.CreatedDate,PC.PropertyId,PC.UserId
	 END
END
END	
	
		CREATE TABLE #FinalReport(UserName NVARCHAR(100),Property NVARCHAR(100),ProcessedOn NVARCHAR(100),
		TransferredAmount DECIMAL(27,2),PropertyId INT,UserId INT,Fort NVARCHAR(100),Mon NVARCHAR(100),
		Processedby NVARCHAR(100),Status NVARCHAR(100),LastProcessedOn NVARCHAR(100))
		
		INSERT #FinalReport(UserName,Property,ProcessedOn,TransferredAmount,PropertyId,UserId,Fort,Mon,
		Processedby,Status,LastProcessedOn)
		SELECT UserName,Property,ProcessedOn,SUM(TransferredAmount)AS TransferredAmount, 
		PropertyId,UserId,'1st FortNight',MONTH(CONVERT(date,ProcessedOn,103)),Processedby,Status,
		LastProcessedOn
		FROM #Final
		WHERE (day(Convert(datetime,ProcessedOn,103)-1) / 15) + 1=1 AND Fortnight=1
		GROUP BY UserName,Property,ProcessedOn,PropertyId,UserId,Processedby,Status,
		LastProcessedOn
		
		INSERT #FinalReport(UserName,Property,ProcessedOn,TransferredAmount,PropertyId,UserId,Fort,Mon,
		Processedby,Status,LastProcessedOn)
		SELECT UserName,Property,ProcessedOn,SUM(TransferredAmount)AS TransferredAmount, 
		PropertyId,UserId,'2nd FortNight',MONTH(CONVERT(date,ProcessedOn,103)),Processedby,Status,
		LastProcessedOn
		FROM #Final
		WHERE (day(Convert(datetime,ProcessedOn,103)-1) / 15) + 1=2 AND Fortnight=2
		GROUP BY UserName,Property,ProcessedOn,PropertyId,UserId,Processedby,Status,
		LastProcessedOn
				
		SELECT UserName AS Submittedby,Property,ProcessedOn AS SubmittedOn,TransferredAmount AS Amount,
		PropertyId,UserId,Fort AS FortNight,Mon AS Month
		,Processedby AS LastProcessedBy,Status,LastProcessedOn FROM #FinalReport
END
IF @Action='Action'
 BEGIN
		CREATE TABLE #User (UserName NVARCHAR(100),Status NVARCHAR(100),Comments NVARCHAR(100),Processedon NVARCHAR(100))
				
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT DISTINCT(U.FirstName+' '+U.LastName) AS UserName,'Submitted' AS Status,'' AS Comments,
		CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103) AS Processedon
	    FROM WRBHBPettyCashStatus P
		JOIN WRBHBUser U ON  P.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE P.UserId=@UserId AND P.PropertyId=@Id AND P.IsActive=1 AND P.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(P.CreatedDate AS Date),103)=CONVERT(NVARCHAR,@Str,103)
		
		INSERT INTO #User(UserName,Status,Comments,Processedon)
		SELECT (U.FirstName+' '+U.LastName) AS UserName,PC.ProcessedStatus AS Status,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.LastProcessedon,103) AS Processedon		
		From WRBHBNewPCExpenseApproval PC
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.RequestedUserId=@UserId AND PC.PropertyId=@Id AND PC.IsActive=1 AND PC.IsDeleted=0
		AND PC.RequestedOn=CONVERT(NVARCHAR,@Str,103)
		ORDER BY PC.CreatedDate	
		
		SELECT UserName,Status,Comments,Processedon FROM #User 
		ORDER BY CONVERT(date,Processedon,103) ASC
	END

IF(@Action='SpendReport')
BEGIN
		CREATE TABLE #PettyCash(Id BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
		Date NVARCHAR(100),ExpenseHead NVARCHAR(100),Description NVARCHAR(100),
		ApprovedAmount DECIMAL(27,2),PaidAmount DECIMAL(27,2),
		Bill NVARCHAR(1000),ExpenseId INT)
		
		INSERT INTO #PettyCash(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill,ExpenseId)
		
		SELECT CONVERT(NVARCHAR,CAST(CONVERT(Date,U.CreatedDate,103) AS Date),110),
		U.ExpenseHead,U.Description,U.Amount,U.Paid,U.BillLogo,U.Id
		FROM WRBHBPettyCashStatus U 
		JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
		WHERE U.UserId =@UserId AND U.PropertyId=@Id AND U.IsActive=1 AND U.IsDeleted=0
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
		Bill NVARCHAR(1000))
		
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
		WHERE UserId =@UserId AND PropertyId=@Id AND Date=CONVERT(Date,@Str,103) AND IsActive=1 AND IsDeleted=0
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'AmountReceived' AS ApprovedAmount,
		SUM(P.ApprovedAmount) AS PaidAmount,'' AS Bill FROM WRBHBPettyCashHdr PC
		JOIN WRBHBPettyCash P ON PC.Id=P.PettyCashHdrId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE UserId =@UserId AND PropertyId=@Id AND Date=CONVERT(Date,@Str,103) AND PC.IsActive=1 AND PC.IsDeleted=0
			
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT CONVERT(NVARCHAR,CONVERT(DATE,CAST(U.CreatedDate AS Date),103),110),
		U.ExpenseHead,U.Description,U.Amount,U.Paid,U.BillLogo
		FROM WRBHBPettyCashStatus U 
		JOIN WRBHBUser S ON U.UserId=S.Id AND S.IsActive=1 AND S.IsDeleted=0
		WHERE U.UserId =@UserId AND U.PropertyId=@Id AND U.IsActive=1 AND U.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(U.CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
	
				
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'TotalAmount' AS Description,SUM(Amount) AS ApprovedAmount,SUM(Paid) AS PaidAmount,
		'' AS Bill
		FROM WRBHBPettyCashStatus 
		WHERE UserId =@UserId AND PropertyId=@Id AND IsActive=1 AND IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'ClosingBalance' AS ApprovedAmount,Balance AS PaidAmount,
		'' AS Bill FROM WRBHBPettyCashStatus
		WHERE UserId =@UserId AND PropertyId=@Id AND CONVERT(Date,CreatedDate,103)=CONVERT(Date,@Str,103) AND 
		IsActive=1 AND IsDeleted=0
		GROUP BY Balance
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
		
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'' AS ExpenseHead,'' AS Description,'' AS ApprovedAmount,'' AS PaidAmount,
		'' AS Bill
		INSERT INTO #PettyCash1(Date,ExpenseHead,Description,ApprovedAmount,PaidAmount,Bill)
		SELECT '' AS Date,'Resident Manager','Operations Manager','Head Operations','Account Manager',
		'' AS Bill 
		
		
		SELECT Id AS SNo,ISNULL(Date,'')AS Date,ISNULL(ExpenseHead,'')AS ExpenseHead,ISNULL(Description,'')AS Description,
		ISNULL(ApprovedAmount,'')AS ApprovedAmount,ISNULL(PaidAmount,'')AS PaidAmount,
		ISNULL(Bill,'')AS Bill
		FROM #PettyCash1
		
		SELECT DISTINCT D.OpeningBalance FROM WRBHBPettyCashHdr D
		JOIN WRBHBPettyCashStatus H ON H.Status=CONVERT(NVARCHAR(100),D.Date,103) AND
		H.UserId=D.UserId AND H.PropertyId=D.PropertyId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.UserId =@UserId AND H.PropertyId=@Id AND H.IsActive=1 AND H.IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(H.CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103) 
		
		SELECT DISTINCT Balance FROM WRBHBPettyCashStatusHdr
		WHERE UserId =@UserId AND PropertyId=@Id AND IsActive=1 AND IsDeleted=0
		AND CONVERT(NVARCHAR,CAST(CreatedDate AS Date),103)=CONVERT(NVARCHAR(100),@Str,103)
		
END
IF(@Action='DownloadReport')
BEGIN
		SELECT BillLogo FROM WRBHBPettyCashStatus  
		WHERE PropertyId=@Id AND UserId=@UserId AND Id=CAST(@Str AS BIGINT) AND IsActive=1 AND IsDeleted=0
		--http:sstage.in/Client_images/Gas_1. Gas cylinder 1760.jpg    
END
IF(@Action='PCNewReport')
BEGIN
		DECLARE @Cnt int
			
        CREATE TABLE #PCNEW(Requestedby NVARCHAR(100),RequestedOn NVARCHAR(100),
        ExpenseHead NVARCHAR(100),ExpenseItem NVARCHAR(100),Description NVARCHAR(100),Amount DECIMAL(27,2),
        BillDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),Property NVARCHAR(100),
        Id bigint IDENTITY(1,1)  NOT NULL PRIMARY KEY,PCId Int)
        
        
		INSERT INTO #PCNEW(Requestedby,RequestedOn,ExpenseHead,ExpenseItem,Description,Amount,
		BillDate,BillStartDate,BillEndDate,Property,PCId)
	
		SELECT (U.FirstName+''+U.LastName) AS Requestedby,CONVERT(NVARCHAR,PC.CreatedDate,105) 
		AS RequestedOn,EG.ExpenseHead,PC.ExpenseHead AS ExpenseItem,PC.Description,PC.Paid AS Amount,
		CONVERT(NVARCHAR,PC.BillDate,105),CONVERT(NVARCHAR,@Str,105) AS Startdate,
		CONVERT(NVARCHAR,@Str1,105) AS EndDate,P.PropertyName,PC.Id 
		FROM WRBHBPettyCashStatus PC
		JOIN WRBHBExpenseHeads EX ON PC.ExpenseHead=EX.HeaderName AND EX.IsActive=1 AND EX.IsDeleted=0
		JOIN WRBHBExpenseGroup EG ON EX.ExpenseGroupId=EG.Id 
		JOIN WRBHBUser U ON PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 
		AND	CONVERT(date,PC.CreatedDate,103) BETWEEN CONVERT(date,@Str,103) AND CONVERT(date,@Str1,103)
		GROUP BY U.FirstName,U.LastName,PC.CreatedDate,EG.ExpenseHead,PC.ExpenseHead,PC.Description,
		PC.Paid,PC.BillDate,P.PropertyName,PC.Id
		ORDER BY PC.Id ASC

				
		SELECT Id as SNo,Requestedby,RequestedOn,ExpenseHead,ExpenseItem,Description,Amount,
		BillDate,BillStartDate,BillEndDate,Property	FROM #PCNEW 
			
		
END	
END


 
