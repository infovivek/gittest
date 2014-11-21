-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ReportRentANDMaintenance_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ReportRentANDMaintenance_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:o2-06-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Report Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_ReportRentANDMaintenance_Help](
@Action NVARCHAR(100),
@Pram1	 BIGINT,
@Pram2	 BIGINT,
@Pram3	 NVARCHAR(100),
@Pram4	 NVARCHAR(100),
@Pram5	 NVARCHAR(100),
@UserId  BIGINT)			
AS
BEGIN
IF @Action ='Month'
BEGIN
	IF @Pram5='Rentals'
	BEGIN
		SELECT REPLACE(RIGHT(CONVERT(VARCHAR(11), LastMonth, 106), 8), ' ', '-') AS LastMonth,Id
		FROM WRBHBInvoiceRentMonthGeneratedRent
	END 
	IF @Pram5='Maintenance'
	BEGIN
		SELECT REPLACE(RIGHT(CONVERT(VARCHAR(11), LastMonth, 106), 8), ' ', '-') AS LastMonth,Id
		FROM WRBHBInvoiceRentMonthGeneratedMaintenance
	END 
	IF @Pram5='Receivables'
	BEGIN
		SELECT REPLACE(RIGHT(CONVERT(VARCHAR(11), LastMonth, 106), 8), ' ', '-') AS LastMonth,Id
		FROM WRBHBInvoiceExternalAmountMonthGenerated
	END 
	IF @Pram5='Managed Guest House Receivables'
	BEGIN
		SELECT REPLACE(RIGHT(CONVERT(VARCHAR(11), LastMonth, 106), 8), ' ', '-') AS LastMonth,Id
		FROM WRBHBInvoiceManagedGHAmountMonthGenerated
	END 
 
END
IF @Action ='Genarate'
BEGIN
	IF @Pram5='Rentals'
	BEGIN
		CREATE TABLE #RentAndMaintenance(OwnerName NVARCHAR(100),PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
		RentelAmount DECIMAL(27,2),TDSAMOUNT DECIMAL(27,2),RentType NVARCHAR(100),
		TIACredit DECIMAL(27,2), TIADebit DECIMAL(27,2),NTIACredit DECIMAL(27,2),NTIADebit DECIMAL(27,2),
		Type NVARCHAR(100))
		DECLARE @DATE DATE
		
		SELECT @DATE=LastMonth FROM dbo.WRBHBInvoiceRentMonthGeneratedRent
		WHERE Id=@Pram1
		
		
		
		INSERT INTO  #RentAndMaintenance(OwnerName,PropertyName,ApartmentNo,RentelAmount,TDSAMOUNT,RentType,
		TIACredit,TIADebit,NTIACredit,NTIADebit,Type)
		SELECT OwnerName,PropertyName,B.BlockName+'-'+A.ApartmentNo ApartmentNo,RentelAmount,TDSAMOUNT,RentType,
		TIAAdjusementCreditAmount TIACredit,TIAAdjusementDebitAmount TIADebit,
		NTIAAdjusementCreditAmount NTIACredit,NTIAAdjusementDebitAmount NTIADebit,'Rental'		
		FROM WRBHBInvoiceRentAmount	R
		JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.PropertyId=R.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN WRBHBPropertyApartment A	WITH(NOLOCK) ON A.PropertyId=R.PropertyId AND B.Id=A.BlockId
		AND A.IsActive=1 AND A.IsDeleted=0 and R.ApartmentId=A.Id
		JOIN dbo.WRBHBPropertyOwners PO WITH(NOLOCK) ON PO.Id=R.OwnerId
		WHERE RentMonthGeneratedRentId=@Pram1 AND RentelAmount!=CAST(0 AS DECIMAL)
		
		INSERT INTO  #RentAndMaintenance(OwnerName,PropertyName,ApartmentNo,RentelAmount,TDSAMOUNT,RentType,
		TIACredit,TIADebit,NTIACredit,NTIADebit,Type)
		SELECT OwnerName,PropertyName,B.BlockName+'-'+A.ApartmentNo ApartmentNo,RentelAmount,0,RentType,
		0,0,0,0,'Maintenance'
		FROM dbo.WRBHBInvoiceRentMonthGeneratedMaintenance S
		JOIN WRBHBInvoiceMaintenanceAmount R WITH(NOLOCK) ON  R.RentMonthGeneratedMaintenanceId=S.Id
		JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.PropertyId=R.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN WRBHBPropertyApartment A	WITH(NOLOCK) ON A.PropertyId=R.PropertyId AND B.Id=A.BlockId
		AND A.IsActive=1 AND A.IsDeleted=0 and R.ApartmentId=A.Id
		WHERE MONTH(CONVERT(DATE,LastMonth,103))=MONTH(@DATE) AND
		YEAR(CONVERT(DATE,LastMonth,103))=YEAR(@DATE)
		AND RentelAmount!=CAST(0 AS DECIMAL)
		
		
		SELECT OwnerName,PropertyName,ApartmentNo,RentelAmount,TDSAMOUNT,RentType,
		TIACredit,TIADebit,NTIACredit,NTIADebit,Type FROM #RentAndMaintenance
		
	END 
	IF @Pram5='Maintenance'
	BEGIN	
		SELECT OwnerName,PropertyName,B.BlockName+'-'+A.ApartmentNo ApartmentNo,RentelAmount,RentType
		FROM WRBHBInvoiceMaintenanceAmount R
		JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.PropertyId=R.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN WRBHBPropertyApartment A	WITH(NOLOCK) ON A.PropertyId=R.PropertyId AND B.Id=A.BlockId
		AND A.IsActive=1 AND A.IsDeleted=0 and R.ApartmentId=A.Id
		WHERE RentMonthGeneratedMaintenanceId=@Pram1 AND RentelAmount!=CAST(0 AS DECIMAL)
	END 
	IF @Pram5='Receivables'
	BEGIN
		CREATE TABLE #Receivables(ClientName NVARCHAR(100),RentelAmount NVARCHAR(100),Type NVARCHAR(100))
		
		INSERT INTO #Receivables(ClientName,RentelAmount,Type)
		SELECT C.ClientName,RentelAmount,Type
		FROM WRBHBInvoiceExternalAmount R
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON R.ClientIdORPropertyId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE ExternalAmountMonthGeneratedId=@Pram1 AND ClientType='CLIENT' and Type=@Pram4 
		
		
		INSERT INTO #Receivables(ClientName,RentelAmount,Type)
		SELECT C.PropertyName,RentelAmount,Type
		FROM WRBHBInvoiceExternalAmount R
		JOIN WRBHBProperty C WITH(NOLOCK) ON R.ClientIdORPropertyId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE ExternalAmountMonthGeneratedId=@Pram1 AND ClientType='Property' and Type=@Pram4
		
		SELECT ClientName,RentelAmount,Type FROM #Receivables
		WHERE RentelAmount!=CAST(0 AS DECIMAL)
	END 
	IF @Pram5='Managed Guest House Receivables'
	BEGIN
		SELECT C.ClientName,RentelAmount,Type
		FROM WRBHBInvoiceManagedGHAmount R
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON R.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE ManagedGHAmountMonthGenerated=@Pram1 AND RentelAmount!=CAST(0 AS DECIMAL)
	END 
END
END




	
	