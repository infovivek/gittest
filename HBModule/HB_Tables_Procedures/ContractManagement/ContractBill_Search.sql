
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractBill_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractBill_Search]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (14/08/2014)  >
Section  	: CONTRACT BILL SEARCH
Purpose  	: 
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

CREATE PROCEDURE [dbo].[Sp_ContractBill_Search]
(
@UserId BIGINT,
@Id		BIGINT,
@Str	NVARCHAR(100),
@Str1	NVARCHAR(100)
)
 AS
 BEGIN				--drop table #temp
	CREATE TABLE #TEMP (StartDate DATE,EndDate DATE,Days BIGINT,Rental DECIMAL(27,2),RentalTax DECIMAL(27,2),Id BIGINT,
					ClientId BIGINT,InvoiceNo NVARCHAR(100),Type NVARCHAR(100))
					
		DECLARE @StartDate DATE,@Enddate DATE,@ContractEndDate DATE,@ContractName NVARCHAR(100),@InVoiceNo NVARCHAR(100),
		@Tax DECIMAL(27,2),@Tempinvoiceno nvarchar(100);

		SET @ContractName=(SELECT ContractName FROM WRBHBContractManagement WHERE Id=@Id)
		SET @StartDate=(DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)))
		SET @Enddate=(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))
		SET @ContractEndDate=(SELECT CONVERT(DATE,EndDate,103) FROM WRBHBContractManagement WHERE Id=@Id)
		SET @Tax=(SELECT BusinessSupportST FROM WRBHBTaxMaster WHERE StateId=17)
		SET @Tempinvoiceno = (SELECT TOP 1 InVoiceNo FROM WRBHBInvoiceManagedGHAmount WHERE ContractId=@Id order by Id desc)
		--select @Property,@tempinvoiceno
		IF ISNULL(@Tempinvoiceno , '' )= ''
		BEGIN
			SET @InVoiceNo = SUBSTRING(upper(@ContractName),0,4)+'/'+'01'
		END
		ELSE
		BEGIN
		   SET @InVoiceNo = 
		   SUBSTRING(@Tempinvoiceno,0,6)+
		   CAST(CAST(SUBSTRING(@Tempinvoiceno,6,LEN(@Tempinvoiceno)) AS INT) + 1 AS VARCHAR); 
		END

		--SELECT @ContractName as ContractName,@StartDate as StartDate,@Enddate as EndDate,@ContractEndDate as ContractEndDate,
		--@Tax as Tax,@InVoiceNo as InvoiceNo

		INSERT INTO #TEMP (StartDate,EndDate,Days,Rental,RentalTax,Id,ClientId,InvoiceNo,Type)

		SELECT DISTINCT @StartDate AS StartDate,@enddate AS EndDate,DateDiff(DAY,@StartDate,@enddate) AS Days,
		Convert(DECIMAL(27,2),IMA.RentelAmount) AS Rental,Convert(decimal(27,2),IMA.RentelAmount*12.36/100) AS RentalTax,
		CM.Id,CM.ClientId,ISNULL(IMA.InvoiceNo,''),IMA.Type AS Type FROM WRBHBContractManagement CM
		join WRBHBInvoiceManagedGHAmount IMA on CM.ClientId=IMA.ClientId order by Id
		--where IMA.ContractId=@Id 

		--SELECT StartDate,EndDate,Days,Rental,RentalTax,(Rental+RentalTax) AS TotalTariff,Id AS ContractId,ClientId
		-- FROM #TEMP WHERE Id=@Id AND MONTH(CONVERT(DATE,EndDate,103))<= MONTH(CONVERT(DATE,@ContractEndDate,103)) AND
		-- YEAR(CONVERT(DATE,EndDate,103))<= YEAR(CONVERT(DATE,@ContractEndDate,103))
IF @Str1='ManagedContract'
BEGIN		
   IF @Id!=0 AND @Str=''
   BEGIN
		--SELECT DISTINCT Client,ClientId as ZId FROM WRBHBContractManagement WHERE IsActive=1 AND IsDeleted=0
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND 
		T1.ClientId=@Id AND T1.Type=' Managed Contracts '
	END
    IF @Id=0 AND @Str!=''
   BEGIN
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND
		InvoiceNo LIKE '%'+@Str AND T1.Type=' Managed Contracts '
   END
    IF @Id!=0 AND @Str!=''
   BEGIN
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND
		InvoiceNo LIKE '%'+@Str AND T1.ClientId=@Id  AND T1.Type=' Managed Contracts '
   END
  END
  
IF @Str1='Contract'
BEGIN		
   IF @Id!=0 AND @Str=''
   BEGIN
		--SELECT DISTINCT Client,ClientId as ZId FROM WRBHBContractManagement WHERE IsActive=1 AND IsDeleted=0
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND 
		T1.ClientId=@Id AND T1.Type!=' Managed Contracts '
	END
    IF @Id=0 AND @Str!=''
   BEGIN
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND
		InvoiceNo LIKE '%'+@Str AND T1.Type!=' Managed Contracts '
   END
    IF @Id!=0 AND @Str!=''
   BEGIN
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		Days,Rental,RentalTax,CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(Rental+RentalTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo FROM #TEMP T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' AND
		InvoiceNo LIKE '%'+@Str AND T1.ClientId=@Id  AND T1.Type!=' Managed Contracts '
   END
  END  
 END 	 