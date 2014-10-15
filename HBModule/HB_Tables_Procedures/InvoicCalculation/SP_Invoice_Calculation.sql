-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Invoice_Calculation]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Invoice_Calculation]
GO 
-- ===============================================================================
-- Author:ARUNPRASATH
-- Create date:26-04-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Invoice Calculation
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Invoice_Calculation](@Action NVARCHAR(100),
@Date NVARCHAR(100),@Str2 NVARCHAR(100),@Id1 BIGINT,@Id2 BIGINT)			
AS
BEGIN
DECLARE @CDATE DATETIME,@Flage BIT;
IF @Action ='RENTLOAD'
BEGIN
 
 -- DELETE FROM #TempPropertyApartmentRent
 -- DELETE FROM #TempRentCalculation
    --drop table #TempPropertyApartmentRent
    --drop table #TempPropertyApartmentRentTDSDeclaration
    --drop table #TempRentCalculation
    --drop table #TempEsculationRent
    --drop table #TempEsculationRentTDS
 
	 CREATE TABLE #TempPropertyApartmentRent(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
	 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),RentStartDate DATE,ExpiryDate DATE,
	 OwnerName NVARCHAR(100),AgreementOwnerId BIGINT,TDSAMOUNT DECIMAL(27,2),OwnerId BIGINT,TIAAdjusementCreditAmount DECIMAL(27,2),
	 TIAAdjusementDebitAmount DECIMAL(27,2))
	 
	 CREATE TABLE #TempPropertyApartmentRentTDSDeclaration(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
	 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),RentStartDate DATE,ExpiryDate DATE,
	 OwnerName NVARCHAR(100),AgreementOwnerId BIGINT,TDSAMOUNT DECIMAL(27,2),OwnerId BIGINT,TIAAdjusementCreditAmount DECIMAL(27,2),
	 TIAAdjusementDebitAmount DECIMAL(27,2))
	 
	 CREATE TABLE #TempRentCalculation(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
	 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),TDSAMOUNT DECIMAL(27,2),OwnerId BIGINT,
	 NTIAAdjusementCreditAmount DECIMAL(27,2),NTIAAdjusementDebitAmount DECIMAL(27,2))
	 
	 CREATE TABLE #TempEsculationRent(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
	 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),RentStartDate DATE,ExpiryDate DATE,
	 OwnerName NVARCHAR(100),AgreementOwnerId BIGINT)
	 
	 CREATE TABLE #TempEsculationRentTDS(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
	 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),RentStartDate DATE,ExpiryDate DATE,
	 OwnerName NVARCHAR(100),AgreementOwnerId BIGINT)
	 
	 
	 SELECT TOP 1 @CDATE=DATEADD(month, 1, LastMonth),@Flage=1 FROM WRBHBInvoiceRentMonthGeneratedRent
	 ORDER BY Id DESC	
	 IF ISNULL(@CDATE,'')=''
	 BEGIN
		 SELECT @CDATE=GETDATE();
		 SET @Flage=0
	 END
	 ELSE
	 BEGIN
		IF ((day('01/25/2014')=day(GETDATE()))AND(YEAR(@CDATE)=YEAR(GETDATE()))AND(MONTH(@CDATE)=MONTH(GETDATE())))
		BEGIN		
			SET @Flage=0
		END
		ELSE
	    BEGIN	
			SET @Flage=1
	    END  
	 END
	 --AND(YEAR(@CDATE)=YEAR(GETDATE()))AND(DAY('01/25/2014')=YEAR(GETDATE()))
	 --select @Flage,@CDATE,year(@CDATE),MONTH(@CDATE),day(@CDATE),GETDATE(),year(GETDATE()),MONTH(GETDATE()),day('01/25/2014'),day(GETDATE())
	 --return
	 IF @Flage=0
	 BEGIN
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE NOT IN TDS DECLARATION
		 INSERT INTO #TempPropertyApartmentRent(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
		 RentType,RentStartDate,ExpiryDate,OwnerName,AgreementOwnerId,OwnerId)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,(ISNULL(PA.StartingRentalMonth,0)*AO.SplitPer)/100,
		 ISNULL(RentalType,''),ISNULL(RentalStartDate,''),ISNULL(ExpiryDate,''),AO.OwnerName,AO.Id,AO.OwnerId
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month, 1,@CDATE),103)	 
		 JOIN WRBHBPropertyAgreementsOwner AO WITH(NOLOCK) ON AO.AgreementId=PA.Id AND AO.IsActive=1 AND AO.IsDeleted=0
		 AND AO.OwnerId NOT IN(SELECT OwnerId FROM dbo.WRBHBTDSDeclaration D
		 JOIN dbo.WRBHBFinancialYear FY WITH(NOLOCK)ON FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE IN TDS DECLARATION
		 INSERT INTO #TempPropertyApartmentRentTDSDeclaration(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
		 RentType,RentStartDate,ExpiryDate,OwnerName,AgreementOwnerId,OwnerId)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,(ISNULL(PA.StartingRentalMonth,0)*AO.SplitPer)/100,
		 ISNULL(RentalType,''),ISNULL(RentalStartDate,''),ISNULL(ExpiryDate,''),AO.OwnerName,AO.Id,AO.OwnerId
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month, 1, @CDATE),103)	 
		 JOIN WRBHBPropertyAgreementsOwner AO WITH(NOLOCK) ON AO.AgreementId=PA.Id AND AO.IsActive=1 AND AO.IsDeleted=0
		 AND AO.OwnerId IN(SELECT OwnerId FROM dbo.WRBHBTDSDeclaration D
		 JOIN dbo.WRBHBFinancialYear FY WITH(NOLOCK)ON FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 
		
		 
		 --SELECT PROPERTY,APARTMENT,EsculationRent BELOW EXPIRED DATE
		 INSERT INTO #TempEsculationRent(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
		 RentType,RentStartDate,ExpiryDate,OwnerName,AgreementOwnerId)	 
		 SELECT P.AgreementId,P.PropertyId ,PropertyName,ApartmentNo,ApartmentId,(AE.Rental*AO.SplitPer)/100 Rental,
		 RentType,AE.StartDate,ExpiryDate,AO.OwnerName,AO.Id
		 FROM #TempPropertyApartmentRent P
		 JOIN dbo.WRBHBPropertyAgreementsDetails AE WITH(NOLOCK) ON AE.AgreementId=P.AgreementId
		 AND CONVERT(DATE,StartDate,103)<= CONVERT(DATE,@CDATE,103)
		 JOIN WRBHBPropertyAgreementsOwner AO WITH(NOLOCK) ON AO.AgreementId=P.AgreementId 
		 AND AO.IsActive=1 AND AO.IsDeleted=0
		 
		 --SELECT PROPERTY,APARTMENT,EsculationRent BELOW EXPIRED DATE TDS TABLE
		 INSERT INTO #TempEsculationRentTDS(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
		 RentType,RentStartDate,ExpiryDate,OwnerName,AgreementOwnerId)	 
		 SELECT P.AgreementId,P.PropertyId ,PropertyName,ApartmentNo,ApartmentId,(AE.Rental*AO.SplitPer)/100 Rental,
		 RentType,AE.StartDate,ExpiryDate,AO.OwnerName,AO.Id
		 FROM #TempPropertyApartmentRentTDSDeclaration P
		 JOIN dbo.WRBHBPropertyAgreementsDetails AE WITH(NOLOCK) ON AE.AgreementId=P.AgreementId
		 AND CONVERT(DATE,StartDate,103)<= CONVERT(DATE,@CDATE,103)
		 JOIN WRBHBPropertyAgreementsOwner AO WITH(NOLOCK) ON AO.AgreementId=P.AgreementId 
		 AND AO.IsActive=1 AND AO.IsDeleted=0		
		--DATEADD(month, 10, @CDATE)
		 
		 --UPDATE EsculationRent VALUE	NOT IN TDS DECLARATION 
		 UPDATE #TempPropertyApartmentRent
		 SET #TempPropertyApartmentRent.RentelAmount=#TempEsculationRent.RentelAmount
		 FROM #TempEsculationRent
		 WHERE #TempPropertyApartmentRent.AgreementId=#TempEsculationRent.AgreementId
		 AND #TempPropertyApartmentRent.ApartmentId=#TempEsculationRent.ApartmentId
		 AND #TempPropertyApartmentRent.PropertyId=#TempEsculationRent.PropertyId
		 
		 
		  --UPDATE EsculationRent VALUE	  IN TDS DECLARATION
		 UPDATE #TempPropertyApartmentRentTDSDeclaration
		 SET #TempPropertyApartmentRentTDSDeclaration.RentelAmount=#TempEsculationRentTDS.RentelAmount
		 FROM #TempEsculationRentTDS
		 WHERE  #TempPropertyApartmentRentTDSDeclaration.AgreementId=#TempEsculationRentTDS.AgreementId
		 AND #TempPropertyApartmentRentTDSDeclaration.ApartmentId=#TempEsculationRentTDS.ApartmentId
		 AND #TempPropertyApartmentRentTDSDeclaration.PropertyId=#TempEsculationRentTDS.PropertyId
		 
		  
		 --UPDATE TIA VALUE	NOT IN TDS DECLARATION Credit to Owner +
		 UPDATE #TempPropertyApartmentRent
		 SET #TempPropertyApartmentRent.RentelAmount=(#TempPropertyApartmentRent.RentelAmount+ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)),
		 #TempPropertyApartmentRent.TIAAdjusementCreditAmount=ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)
		 FROM WRBHBTiaAndNTia,#TempPropertyApartmentRent,WRBHBAdjustmentCategories
		 WHERE  #TempPropertyApartmentRent.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempPropertyApartmentRent.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=0 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND AdjustmentType='Credit' 
		 
		 --UPDATE TIA VALUE	NOT IN TDS DECLARATION Debit TO OWNER -
		 UPDATE #TempPropertyApartmentRent
		 SET #TempPropertyApartmentRent.RentelAmount=(#TempPropertyApartmentRent.RentelAmount-ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)),
		 #TempPropertyApartmentRent.TIAAdjusementDebitAmount=ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)
		 FROM WRBHBTiaAndNTia,#TempPropertyApartmentRent,WRBHBAdjustmentCategories
		 WHERE  #TempPropertyApartmentRent.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempPropertyApartmentRent.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=0 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND  AdjustmentType='Debit' 
		 
		 
		 --UPDATE TIA VALUE	IN TDS DECLARATION Credit to Owner +
		 UPDATE #TempPropertyApartmentRentTDSDeclaration
		 SET #TempPropertyApartmentRentTDSDeclaration.RentelAmount=(#TempPropertyApartmentRentTDSDeclaration.RentelAmount+WRBHBTiaAndNTia.AdjustmentAmount),
		 #TempPropertyApartmentRentTDSDeclaration.TIAAdjusementCreditAmount=WRBHBTiaAndNTia.AdjustmentAmount
		 FROM WRBHBTiaAndNTia,#TempPropertyApartmentRentTDSDeclaration,WRBHBAdjustmentCategories
		 WHERE  #TempPropertyApartmentRentTDSDeclaration.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempPropertyApartmentRentTDSDeclaration.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=0 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND AdjustmentType='Credit' 
		
		 --UPDATE TIA VALUE	IN TDS DECLARATION Debit TO OWNER -
		 UPDATE #TempPropertyApartmentRentTDSDeclaration
		 SET #TempPropertyApartmentRentTDSDeclaration.RentelAmount=(#TempPropertyApartmentRentTDSDeclaration.RentelAmount-WRBHBTiaAndNTia.AdjustmentAmount),
		 #TempPropertyApartmentRentTDSDeclaration.TIAAdjusementDebitAmount=WRBHBTiaAndNTia.AdjustmentAmount
		 FROM WRBHBTiaAndNTia,#TempPropertyApartmentRentTDSDeclaration,WRBHBAdjustmentCategories
		 WHERE  #TempPropertyApartmentRentTDSDeclaration.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempPropertyApartmentRentTDSDeclaration.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=0 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND  AdjustmentType='Debit' 
		 
		 ---New NOT IN TDS DECLARATION 
		 --RENT CALCULATION FOR WITHOUT TDS New Entry
		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
		 RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId
 		 FROM #TempPropertyApartmentRent
 		 WHERE RentelAmount<=15000 AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId 
 		 FROM #TempPropertyApartmentRent
 		 WHERE RentelAmount<=15000 AND RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE);
	 	 
 		  ---old
 		  --RENT CALCULATION FOR WITHOUT TDS Old Entry
		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId 
 		 FROM #TempPropertyApartmentRent
 		 WHERE RentelAmount<=15000 AND RentType='Arrears' AND MONTH(RentStartDate)!=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId
 		 FROM #TempPropertyApartmentRent
 		 WHERE RentelAmount<=15000 AND RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE);
	 	 
	 	 
 		 ---New  IN TDS DECLARATION 
		 --RENT CALCULATION FOR WITHOUT TDS New Entry
		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId 
 		 FROM #TempPropertyApartmentRentTDSDeclaration
 		 WHERE RentelAmount<=15000 AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId 
 		 FROM #TempPropertyApartmentRentTDSDeclaration
 		 WHERE RentelAmount<=15000 AND RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE);
	 	 
 		  ---old
 		  --RENT CALCULATION FOR WITHOUT TDS Old Entry
		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId 
 		 FROM #TempPropertyApartmentRentTDSDeclaration
 		 WHERE RentelAmount<=15000 AND RentType='Arrears' AND MONTH(RentStartDate)!=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0,OwnerId
 		 FROM #TempPropertyApartmentRentTDSDeclaration
 		 WHERE RentelAmount<=15000 AND RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE);
	 	 
	 	 
	 	 
		 
 		 ---TDS Calculate IN TDS DECLARATION 
	 	 
 		  --RENT CALCULATION FOR WITH TDS New Entry 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PA.PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * D.TDSPercentage)/100) RentelAmount,
 		 RentType ,(RentelAmount * D.TDSPercentage)/100,PA.OwnerId
 		 FROM #TempPropertyApartmentRentTDSDeclaration PA,WRBHBTDSDeclaration D,WRBHBFinancialYear FY 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE) 
 		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.OwnerId=D.OwnerId
 		 AND FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PA.PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * D.TDSPercentage)/100) RentelAmount,
 		 RentType ,(RentelAmount * D.TDSPercentage)/100,PA.OwnerId
 		 FROM #TempPropertyApartmentRentTDSDeclaration PA,WRBHBTDSDeclaration D,WRBHBFinancialYear FY 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE)
 		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.OwnerId=D.OwnerId
 		 AND FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId;
	 	 
	 	 	 
 		  ---Old
 		  --RENT CALCULATION FOR WITH TDS Old Entry 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PA.PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * D.TDSPercentage)/100) RentelAmount,
 		 RentType ,(RentelAmount * D.TDSPercentage)/100,PA.OwnerId
 		 FROM #TempPropertyApartmentRentTDSDeclaration PA,WRBHBTDSDeclaration D,WRBHBFinancialYear FY 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)!=MONTH(@CDATE)
 		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.OwnerId=D.OwnerId
 		 AND FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PA.PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * D.TDSPercentage)/100) RentelAmount,
 		 RentType ,(RentelAmount * D.TDSPercentage)/100,PA.OwnerId
 		 FROM #TempPropertyApartmentRentTDSDeclaration PA,WRBHBTDSDeclaration D,WRBHBFinancialYear FY  	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE)
 		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.OwnerId=D.OwnerId
 		 AND FY.Id=D.FinancialYearId
		 AND CONVERT(DATE,'01/04/'+CAST(SUBSTRING ( FY.FinancialYear ,0 , 5 )AS NVARCHAR),103)<CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,'31/03/'+CAST(SUBSTRING ( FY.FinancialYear ,6 , 10 )AS NVARCHAR),103)>CONVERT(DATE,@CDATE,103)
		 AND D.IsActive=1 AND D.IsDeleted=0 AND PA.PropertyId=D.PropertyId;
	 	 
	 	 
 		 ---TDS Calculate
	 	 
 		  ---New,SLAB1
 		  --RENT CALCULATION FOR WITH TDS New Entry 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax1)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax1)/100,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE) 
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom1 AND S.SlabTo1 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax1)/100) RentelAmount,
 		 RentType ,(RentelAmount * S.SlabTax1)/100,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom1 AND S.SlabTo1 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	
	 	 
 		  ---Old
 		  --RENT CALCULATION FOR WITH TDS Old Entry 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax1)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax1)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)!=MONTH(@CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom1 AND S.SlabTo1 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax1)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax1)/100,OwnerId  
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom1 AND S.SlabTo1 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	 
	 	 
 		 ---New,SLAB2
 		  --RENT CALCULATION FOR WITH TDS New Entry 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax2)/100) RentelAmount,
 		 RentType ,(RentelAmount * S.SlabTax2)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE) 
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom2 AND S.SlabTo2 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax2)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax2)/100 ,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom2 AND S.SlabTo2 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	
	 	 
 		  ---Old
 		  --RENT CALCULATION FOR WITH TDS Old Entry 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax2)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax2)/100 ,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)!=MONTH(@CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom2 AND S.SlabTo2 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax2)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax2)/100 ,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom2 AND S.SlabTo2 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 ---New,SLAB3
 		  --RENT CALCULATION FOR WITH TDS New Entry 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax3)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax3)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE) 
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom3 AND S.SlabTo3 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax3)/100) RentelAmount,
 		 RentType ,(RentelAmount * S.SlabTax3)/100,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom3 AND S.SlabTo3 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	
	 	 
 		  ---Old
 		  --RENT CALCULATION FOR WITH TDS Old Entry 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax3)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax3)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)!=MONTH(@CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom3 AND S.SlabTo3 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax3)/100) RentelAmount,
 		 RentType ,(RentelAmount * S.SlabTax3)/100,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom3 AND S.SlabTo3 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	 
 		  ---New,SLAB4
 		  --RENT CALCULATION FOR WITH TDS New Entry 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax4)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax4)/100 ,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE) 
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom4 AND S.SlabTo4 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax4)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax4)/100 ,OwnerId
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom1 AND S.SlabTo4 AND S.IsActive=4 AND S.IsDeleted=0;
	 	 
	 	
	 	 
 		  ---Old
 		  --RENT CALCULATION FOR WITH TDS Old Entry 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax4)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax4)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Arrears' 
 		 AND MONTH(RentStartDate)!=MONTH(@CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom4 AND S.SlabTo4 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
 		 INSERT INTO #TempRentCalculation(AgreementId,PropertyId  ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT,OwnerId)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount-((RentelAmount * S.SlabTax4)/100) RentelAmount,
 		 RentType,(RentelAmount * S.SlabTax4)/100,OwnerId 
 		 FROM #TempPropertyApartmentRent,WRBHBTDSSlab S 	
 		 WHERE RentelAmount>15000  AND RentType='Advance' AND
 		 MONTH(DATEADD(month, -1, RentStartDate))!=MONTH( @CDATE)
 		 AND (RentelAmount*12) BETWEEN S.SlabFrom4 AND S.SlabTo4 AND S.IsActive=1 AND S.IsDeleted=0;
	 	 
	 	 
 		  --UPDATE NTIA VALUE	 Credit to Owner +
		 UPDATE #TempRentCalculation
		 SET #TempRentCalculation.RentelAmount=(#TempRentCalculation.RentelAmount+ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)),
		 #TempRentCalculation.NTIAAdjusementCreditAmount=ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)
		 FROM WRBHBTiaAndNTia,#TempRentCalculation,WRBHBAdjustmentCategories
		 WHERE  #TempRentCalculation.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempRentCalculation.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=1 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND AdjustmentType='Credit' 
		 
		 --UPDATE NTIA VALUE	Debit TO OWNER -
		 UPDATE #TempRentCalculation
		 SET #TempRentCalculation.RentelAmount=(#TempRentCalculation.RentelAmount-ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)),
		 #TempRentCalculation.NTIAAdjusementDebitAmount=ISNULL(WRBHBTiaAndNTia.AdjustmentAmount,0)
		 FROM WRBHBTiaAndNTia,#TempRentCalculation,WRBHBAdjustmentCategories
		 WHERE  #TempRentCalculation.PropertyId=WRBHBTiaAndNTia.PropertyId
		 AND #TempRentCalculation.OwnerId=WRBHBTiaAndNTia.OwnerId
		 AND MONTH(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=MONTH(CONVERT(DATE,@CDATE,103))
		 AND YEAR(CONVERT(DATE,WRBHBTiaAndNTia.AdjustmentMonth,103))=YEAR(CONVERT(DATE,@CDATE,103))
		 AND WRBHBTiaAndNTia.IsActive=1 AND WRBHBTiaAndNTia.IsDeleted=0
		 AND WRBHBAdjustmentCategories.Flag=1 AND WRBHBAdjustmentCategories.Id=WRBHBTiaAndNTia.AdjustmentCategoryId
		 AND  AdjustmentType='Debit' 
		 
 		 --INSERT MONTH OF RENT
 		 INSERT INTO  WRBHBInvoiceRentMonthGeneratedRent(LastMonth)
 		 SELECT @CDATE
	 	 SELECT @Id1=@@IDENTITY
	 	 
 		 ----Rent Insert  NOT IN TDS DECLARATION OWNER
 		 INSERT INTO WRBHBInvoiceRentAmount(RentMonthGeneratedRentId,OwnerName,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
 		 RentType,TDSAMOUNT,AgreementId,AgreementOwnerId,OwnerId,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,RentDate,
 		 TIAAdjusementCreditAmount,TIAAdjusementDebitAmount,NTIAAdjusementCreditAmount,NTIAAdjusementDebitAmount )
	 	 
 		 SELECT @Id1,C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,RC.RentelAmount,RC.RentType,
 		 RC.TDSAMOUNT,RC.AgreementId,C.AgreementOwnerId,c.OwnerId,1,0,1,@CDATE,1,@CDATE,NEWID(),@CDATE,
 		 ISNULL(C.TIAAdjusementCreditAmount,0),ISNULL(c.TIAAdjusementDebitAmount,0),
 		 ISNULL(RC.NTIAAdjusementCreditAmount,0),ISNULL(RC.NTIAAdjusementDebitAmount,0) 
 		 FROM #TempPropertyApartmentRent C 
 		 JOIN  #TempRentCalculation RC WITH(NOLOCK) ON C.ApartmentId=RC.ApartmentId
 		 AND C.PropertyId=RC.PropertyId AND C.AgreementId=RC.AgreementId 	
 		 AND C.OwnerId=RC.OwnerId  
 		 GROUP BY C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,
 		 RC.RentelAmount,RC.RentType,RC.TDSAMOUNT,RC.AgreementId,C.AgreementOwnerId,C.TIAAdjusementCreditAmount,
 		 C.TIAAdjusementDebitAmount,RC.NTIAAdjusementCreditAmount,RC.NTIAAdjusementDebitAmount ,c.OwnerId
	 	 
 		  ----Rent Insert IN TDS DECLARATION OWNER
 		 INSERT INTO WRBHBInvoiceRentAmount(RentMonthGeneratedRentId,OwnerName,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
 		 RentType,TDSAMOUNT,AgreementId,AgreementOwnerId,OwnerId,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,RentDate,
 		 TIAAdjusementCreditAmount,TIAAdjusementDebitAmount,NTIAAdjusementCreditAmount,NTIAAdjusementDebitAmount )
 		 SELECT @Id1,C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,RC.RentelAmount,RC.RentType,
 		 RC.TDSAMOUNT,RC.AgreementId,C.AgreementOwnerId,C.OwnerId, 1,0,1,@CDATE,1,@CDATE,NEWID(),@CDATE,
 		 ISNULL(C.TIAAdjusementCreditAmount,0),ISNULL(c.TIAAdjusementDebitAmount,0),
 		 ISNULL(RC.NTIAAdjusementCreditAmount,0),ISNULL(RC.NTIAAdjusementDebitAmount,0) 
 		 FROM #TempPropertyApartmentRentTDSDeclaration C 
 		 JOIN  #TempRentCalculation RC WITH(NOLOCK) ON C.ApartmentId=RC.ApartmentId
 		 AND C.PropertyId=RC.PropertyId AND C.AgreementId=RC.AgreementId 	
 		 AND C.OwnerId=RC.OwnerId   
 		 GROUP BY C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,
 		 RC.RentelAmount,RC.RentType,RC.TDSAMOUNT,RC.AgreementId,C.AgreementOwnerId,
 		 C.TIAAdjusementCreditAmount,c.TIAAdjusementDebitAmount,RC.NTIAAdjusementCreditAmount,
 		 RC.NTIAAdjusementDebitAmount ,C.OwnerId
 	 
 	END 
END
IF @Action ='MAINTENANCELOAD'
BEGIN
		-- DELETE FROM #TEMPPROPERTYAPARTMENTMAINTENANCE
 -- DELETE FROM #TEMPMAINTENANCECALCULATION
 -- drop table #TempRentCalculation
     
	 SELECT TOP 1 @CDATE=DATEADD(month, 1, LastMonth),@Flage=1 FROM WRBHBInvoiceRentMonthGeneratedMaintenance
	 ORDER BY Id DESC
	 
	 IF ISNULL(@CDATE,'')=''
	 BEGIN
		 SELECT @CDATE=GETDATE();
		 SET @Flage=0
	 END
	 ELSE
	 BEGIN
		IF ((MONTH(@CDATE)=MONTH(GETDATE()))AND(YEAR(@CDATE)=YEAR(GETDATE()))AND(DAY('01/25/2014')=YEAR(GETDATE())))
		BEGIN
			SET @Flage=0
		END
		ELSE
	    BEGIN	
			SET @Flage=1
	    END 
	 END	
	 IF @Flage=0
	 BEGIN
		 CREATE TABLE #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
		 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),RentStartDate DATE,ExpiryDate DATE,
		 OwnerName NVARCHAR(100),AgreementOwnerId BIGINT,TDSAMOUNT DECIMAL(27,2),Paid NVARCHAR(100))
		 
		 CREATE TABLE #TEMPMAINTENANCECALCULATION(AgreementId BIGINT,PropertyId BIGINT,PropertyName NVARCHAR(100),ApartmentNo NVARCHAR(100),
		 ApartmentId BIGINT,RentelAmount DECIMAL(27,2),RentType NVARCHAR(100),TDSAMOUNT DECIMAL(27,2),AgreementOwnerId BIGINT)
		 
		 
		 
		 --NEW ENTRY
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE
		 INSERT INTO #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,
		 RentelAmount,RentType,RentStartDate,ExpiryDate,OwnerName,Paid)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,ISNULL(PA.MaintenanceAmount,0),
		 ISNULL(MaintenanceType,''),ISNULL(StartingMaintenanceMonth,''),ISNULL(ExpiryDate,''),AssociationName,Paid
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 AND RentInclusive=1  AND ISNULL(PA.LastPaidMonth,'')='' 
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,StartingMaintenanceMonth,103)<= CONVERT(DATE,DATEADD(month, 1,@CDATE),103)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 
		 
		 --Monthly
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE
		 INSERT INTO #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,
		 RentelAmount,RentType,RentStartDate,ExpiryDate,OwnerName,Paid)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,ISNULL(PA.MaintenanceAmount,0),
		 ISNULL(MaintenanceType,''),ISNULL(StartingMaintenanceMonth,''),ISNULL(ExpiryDate,''),AssociationName,
		 Paid
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 AND RentInclusive=1 AND PA.Paid='Monthly' 
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103) AND ISNULL(PA.LastPaidMonth,'')!='' 
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month,1,@CDATE),103)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 
		 --Quarterly
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE
		 INSERT INTO #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,
		 RentelAmount,RentType,RentStartDate,ExpiryDate,OwnerName,Paid)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,ISNULL(PA.MaintenanceAmount,0),
		 ISNULL(MaintenanceType,''),ISNULL(StartingMaintenanceMonth,''),ISNULL(ExpiryDate,''),AssociationName,
		 Paid
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 AND RentInclusive=1 AND PA.Paid='Quarterly' 
		 AND CONVERT(DATE,DATEADD(month,3,PA.LastPaidMonth),103)=CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month, 1,@CDATE),103)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 --Half Yearly
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE
		 INSERT INTO #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,
		 RentelAmount,RentType,RentStartDate,ExpiryDate,OwnerName,Paid)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,ISNULL(PA.MaintenanceAmount,0),
		 ISNULL(MaintenanceType,''),ISNULL(StartingMaintenanceMonth,''),ISNULL(ExpiryDate,''),AssociationName,
		 Paid
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 AND RentInclusive=1 AND PA.Paid='Half Yearly' 
		 AND CONVERT(DATE,DATEADD(month, 6, PA.LastPaidMonth),103)=CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month, 1, @CDATE),103)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 --Yearly
		 --SELECT PROPERTY,APARTMENT,RENT BELOW EXPIRED DATE
		 INSERT INTO #TEMPPROPERTYAPARTMENTMAINTENANCE(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,
		 RentelAmount,RentType,RentStartDate,ExpiryDate,OwnerName,Paid)
		 SELECT PA.Id,P.Id,P.PropertyName,A.ApartmentNo,A.Id,ISNULL(PA.MaintenanceAmount,0),
		 ISNULL(MaintenanceType,''),ISNULL(StartingMaintenanceMonth,''),ISNULL(ExpiryDate,''),AssociationName,
		 Paid
		 FROM dbo.WRBHBProperty P
		 JOIN WRBHBPropertyApartment A WITH(NOLOCK) ON A.PropertyId=P.Id AND  A.IsActive=1 AND A.IsDeleted=0 
		 JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.PropertyId=P.Id AND A.Id=PA.ApartmentId 
		 AND  PA.IsActive=1 AND PA.IsDeleted=0 AND RentInclusive=1 AND PA.Paid='Yearly' 
		 AND CONVERT(DATE,DATEADD(month, 12, PA.LastPaidMonth),103)=CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,ExpiryDate,103)>= CONVERT(DATE,@CDATE,103)
		 AND CONVERT(DATE,RentalStartDate,103)<= CONVERT(DATE,DATEADD(month, 1, @CDATE),103)	 
		 WHERE Category='Internal Property' AND P.IsActive=1 AND P.IsDeleted=0 
		 
		 
		 ---New
		 --RENT CALCULATION FOR WITHOUT TDS New Entry
		 INSERT INTO #TEMPMAINTENANCECALCULATION(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0 
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE
 		 WHERE RentType='Arrears' 
 		 AND MONTH(RentStartDate)=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TEMPMAINTENANCECALCULATION(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0 
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE
 		 WHERE  RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))=MONTH(@CDATE);
	 	 
 		  ---old
 		  --RENT CALCULATION FOR WITHOUT TDS Old Entry
		 INSERT INTO #TEMPMAINTENANCECALCULATION(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0 
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE
 		 WHERE  RentType='Arrears' AND MONTH(RentStartDate)!=MONTH(@CDATE);
	 	 
 		 INSERT INTO #TEMPMAINTENANCECALCULATION(AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,TDSAMOUNT)
 		 SELECT AgreementId,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,RentType,0
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE
 		 WHERE  RentType='Advance' 
 		 AND MONTH(DATEADD(month, -1, RentStartDate))!=MONTH(@CDATE);
	 	 
	 	  --INSERT MONTH OF RENT
 		 INSERT INTO  WRBHBInvoiceRentMonthGeneratedMaintenance(LastMonth)
 		 SELECT @CDATE
 		 SELECT @Id1=@@IDENTITY
 		 ---INSERT MONTALY MAINTENANCE AMOUNT
 		 INSERT INTO WRBHBInvoiceMaintenanceAmount(RentMonthGeneratedMaintenanceId,OwnerName,PropertyId ,PropertyName,ApartmentNo,ApartmentId,RentelAmount,
 		 RentType,TDSAMOUNT,AgreementId,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,MaintenanceAmountDate)
 		 SELECT @Id1,C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,RC.RentelAmount,
 		 RC.RentType,RC.TDSAMOUNT,RC.AgreementId,1,0,1,GETDATE(),1,GETDATE(),NEWID(),@CDATE 
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE C 
 		 JOIN  #TEMPMAINTENANCECALCULATION RC WITH(NOLOCK) ON C.ApartmentId=RC.ApartmentId
 		 AND C.PropertyId=RC.PropertyId AND c.AgreementId=rc.AgreementId 	 
 		 GROUP BY C.OwnerName, RC.PropertyId ,RC.PropertyName,RC.ApartmentNo,RC.ApartmentId,
 		 RC.RentelAmount,RC.RentType,RC.TDSAMOUNT,RC.AgreementId
	 	 
 		 ---Update date
 		 UPDATE WRBHBPropertyAgreements  SET  LastPaidMonth=@CDATE
 		 FROM #TEMPPROPERTYAPARTMENTMAINTENANCE 
 		 WHERE WRBHBPropertyAgreements.Id=#TEMPPROPERTYAPARTMENTMAINTENANCE.AgreementId
 
	END
END
IF @Action ='BTCClient'
BEGIN
	 SELECT TOP 1 @CDATE=DATEADD(month, 1, LastMonth),@Flage=1 FROM WRBHBInvoiceExternalAmountMonthGenerated
	 ORDER BY Id DESC
	 
	 IF ISNULL(@CDATE,'')=''
	 BEGIN
		 SELECT @CDATE=GETDATE();
		 SET @Flage=0
	 END
	 ELSE
	 BEGIN
		IF ((MONTH(@CDATE)=MONTH(GETDATE()))AND(YEAR(@CDATE)=YEAR(GETDATE()))AND(DAY('01/25/2014')=YEAR(GETDATE())))
		BEGIN
			SET @Flage=0
		END
		ELSE
	    BEGIN	
			SET @Flage=1
	    END 
	 END	
	 IF @Flage=0
	 BEGIN
		  CREATE TABLE #ExternalForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
		  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
		  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
		  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
		  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
		  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100))
		  
		  CREATE TABLE #CheckInForecastExternal(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
		  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
		  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
		  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
		  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),DataGetType NVARCHAR(100))  
		  
		  CREATE TABLE #CheckInRevanueExternalMarkUp(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
		  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
		  BookingId BIGINT,PropertyId BIGINT,MarkUp DECIMAL(27,2),SingleTariff DECIMAL(27,2),
		  SingleandMarkup DECIMAL(27,2),MarkupRevenue DECIMAL(27,2),TariffPaymentMode NVARCHAR(100)) 
		  
		  CREATE TABLE #CheckInRevanueExternalTAC(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
		  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
		  BookingId BIGINT,PropertyId BIGINT,TACPer DECIMAL(27,2),TACRevenue DECIMAL(27,2),TariffPaymentMode NVARCHAR(100))
		  
		  CREATE TABLE #RevanueNDD(Tariff DECIMAL(27,2),ClientId BIGINT,ClientName NVARCHAR(100),Type NVARCHAR(100),
		  ClientType NVARCHAR(100))
		  
		  ---CLIENT PAYMENT CHECKOUT BTC DATA
			INSERT INTO #RevanueNDD(Tariff ,ClientId,ClientName,Type,ClientType ) 	  
			SELECT SUM(ISNULL(CI.AmountPaid,0)),B.ClientId,C.ClientName,'BTC','CLIENT'
			FROM WRBHBChechkOutHdr CO
			JOIN WRBHBChechkOutPaymentCompanyInvoice CI ON CO.Id=CI.ChkOutHdrId
			AND CI.IsActive=1 AND CI.IsDeleted=0 AND 
			MONTH(CONVERT(DATE,CO.CreatedDate,103)) = MONTH(CONVERT(DATE,@CDATE,103))   
			AND YEAR(CONVERT(DATE,CO.CreatedDate,103))=YEAR(CONVERT(DATE,@CDATE,103))  
			JOIN WRBHBBooking B ON B.Id=CO.BookingId AND B.IsActive=1 AND B.IsDeleted=0
			JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
			WHERE CO.IsActive=1 AND CO.IsDeleted=0 
			GROUP BY B.ClientId,C.ClientName 

	 
	      
			---PROPERTY TAC,MARK UP FROM CHECKIN TABLE
			INSERT INTO #CheckInForecastExternal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
			Type,BookingLevel,Category,PropertyId,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
			TAC,TACPer,Tariff)   
			SELECT H.BookingId,H.Id,H.RoomId,RoomNo,H.GuestName,CONVERT(NVARCHAR,ArrivalDate,103) ChkInDt,  
			CONVERT(NVARCHAR,G.ChkOutDt,103) ChkOutDt,'CheckedIn','',Category,P.Id,  
			ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
			ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),H.Tariff   
			FROM WrbHbCheckInHdr H  
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
			AND  Category='External Property'  
			JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
			JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND G.IsActive=1 AND G.IsDeleted=0  
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			AND BP.Id=G.BookingPropertyTableId  
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id   
			AND PA.IsDeleted=0        
			WHERE H.IsActive=1 AND H.IsDeleted=0   
			AND MONTH(CONVERT(DATE,H.CreatedDate,103)) = MONTH(CONVERT(DATE,@CDATE,103))   
			AND YEAR(CONVERT(DATE,H.CreatedDate,103))=YEAR(CONVERT(DATE,@CDATE,103)) 
			GROUP BY H.BookingId,H.Id,H.RoomId,RoomNo,H.GuestName,ArrivalDate,  
	 		G.ChkOutDt,Category,P.Id,    
			ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,PA.TAC,PA.TACPer,H.Tariff
	     
			DECLARE @Tariff DECIMAL(27,2),@ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@Count INT;  
			DECLARE @DateDiff int,@i BIGINT,@HR NVARCHAR(100),@RoomId BIGINT,@BookingId BIGINT,@NoOfDays INT,  
			@RoomType NVARCHAR(100),@BookingLevel NVARCHAR(100),@CheckInId BIGINT,@PropertyId BIGINT,  
			@TACPer DECIMAL(27,2),@SingleTariff DECIMAL(27,2),@SingleandMarkup DECIMAL(27,2),@Markup DECIMAL(27,2),  
			@TariffPaymentMode NVARCHAR(100),@PropertyAssGustId BIGINT,@ApartmentId BIGINT;  
	   
		  ---CHECK IN REVANUE AMOUNT FOR MARKUP     
			SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
			@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
			@PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
			@TariffPaymentMode=TariffPaymentMode,@i=0  
			FROM #CheckInForecastExternal WHERE TAC=0 
			
			
			WHILE (@NoOfDays>0)  
			BEGIN                
				INSERT INTO #CheckInRevanueExternalMarkUp(Tariff,RackTariff,MarkupRevenue,NoOfDays,RoomType,BookingLevel,  
				ChkInDate,ChkOutDate,BookingId,PropertyId,SingleTariff,SingleandMarkup,Markup,TariffPaymentMode)  
				SELECT @Tariff,@Tariff,(@SingleandMarkup-@SingleTariff)+@Markup,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
				@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@SingleTariff,@SingleandMarkup,@Markup,  
				@TariffPaymentMode   

				SET @i=@i+1  
				SET @NoOfDays=@NoOfDays-1  

				IF @NoOfDays=0  
				BEGIN   
				DELETE FROM #CheckInForecastExternal WHERE BookingId=@BookingId AND CheckInId=@CheckInId  
				AND TAC=0  

				SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
				@NoOfDays=DATEDIFF(DAY, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
				@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
				@PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
				@TariffPaymentMode=TariffPaymentMode,@i=0  
				FROM #CheckInForecastExternal WHERE TAC=0     
			END    
			END  
	   
		---CHECK IN REVANUE AMOUNT FOR TAC   
			SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,@ChkOutDate,103))+1,  
			@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
			@PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
			@TariffPaymentMode=TariffPaymentMode,@i=0  
			FROM #CheckInForecastExternal WHERE TAC=1  

			WHILE (@NoOfDays>0)  
			BEGIN                
				INSERT INTO #CheckInRevanueExternalTAC(Tariff,RackTariff,TACPer,TACRevenue,NoOfDays,RoomType,BookingLevel,  
				ChkInDate,ChkOutDate,BookingId,PropertyId,TariffPaymentMode)  
				SELECT @Tariff,@Tariff,@TACPer,(@Tariff*@TACPer)/100,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
				@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@TariffPaymentMode   

				SET @i=@i+1  
				SET @NoOfDays=@NoOfDays-1   

				IF @NoOfDays=0  
				BEGIN   
				DELETE FROM #CheckInForecastExternal WHERE BookingId=@BookingId AND CheckInId=@CheckInId  
				AND TAC=1  

				SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
				@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
				@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
				@PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
				@TariffPaymentMode=TariffPaymentMode,@i=0  
				FROM #CheckInForecastExternal WHERE TAC=1     
			END    
			END 
	    
		--CHECK IN START  
		--CHECKIN REVENUE AMOUNT FOR PROPERTY WISE TAC  
			INSERT INTO #RevanueNDD(Tariff ,ClientId,ClientName,Type,ClientType )  
			SELECT SUM(RackTariff),C.Id,C.PropertyName,'BTC','Client' FROM #CheckInRevanueExternalTAC H
			JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
			JOIN dbo.WRBHBProperty C ON C.Id=H.PropertyId AND C.IsActive=1 AND C.IsDeleted=0  
			WHERE LTRIM(TariffPaymentMode)IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')  
			AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@CDATE,103))  
			AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@CDATE,103))   
			GROUP BY C.Id,C.PropertyName  

			INSERT INTO #RevanueNDD(Tariff ,ClientId,ClientName,Type,ClientType )  
			SELECT SUM(TACRevenue),C.Id,C.PropertyName,'TAC','Property' FROM #CheckInRevanueExternalTAC H
			JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
			JOIN WRBHBProperty C ON C.Id=H.PropertyId AND C.IsActive=1 AND C.IsDeleted=0   
			WHERE TariffPaymentMode='Direct'  
			AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@CDATE,103))  
			AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@CDATE,103))   
			GROUP BY C.Id,C.PropertyName  

			--CHECKIN REVENUE AMOUNT FOR PROPERTY WISE MARKUP  
			INSERT INTO #RevanueNDD(Tariff ,ClientId,ClientName,Type,ClientType)  
			SELECT SUM(RackTariff),C.Id,C.PropertyName,'BTC','Client' FROM #CheckInRevanueExternalMarkUp H
			JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
			JOIN WRBHBProperty C ON C.Id=H.PropertyId AND C.IsActive=1 AND C.IsDeleted=0   
			WHERE TariffPaymentMode IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')  
			AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@CDATE,103))-1  
			AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@CDATE,103))   
			GROUP BY C.Id,C.PropertyName  

			INSERT INTO #RevanueNDD(Tariff ,ClientId,ClientName,Type,ClientType )  
			SELECT SUM(MarkupRevenue),C.Id,C.PropertyName,'TAC','Property' FROM #CheckInRevanueExternalMarkUp H
			JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
			JOIN WRBHBProperty C ON C.Id=H.PropertyId AND C.IsActive=1 AND C.IsDeleted=0    
			WHERE TariffPaymentMode='Direct'  
			AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@CDATE,103)) -1 
			AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@CDATE,103))   
			GROUP BY C.Id,C.PropertyName
			
			--INSERT MONTH OF RENT
 			 INSERT INTO  WRBHBInvoiceExternalAmountMonthGenerated(LastMonth)
 			 SELECT @CDATE
 			 SELECT @Id1=@@IDENTITY
 			 ---INSERT MONTALY EXTERNAL AMOUNT
			
			
			INSERT INTO WRBHBInvoiceExternalAmount(ExternalAmountMonthGeneratedId,RentelAmount ,
			ClientIdORPropertyId,ClientName,Type,RentDate,IsActive,IsDeleted,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate,RowId,ClientType)   
			SELECT @Id1,SUM(Tariff),ClientId,ClientName,Type,@CDATE,1,0,1,GETDATE(),1,GETDATE(),NEWID(),ClientType
			FROM #RevanueNDD 
			GROUP BY ClientId,ClientName,Type,ClientType
		END	
END
IF @Action ='MGHClient'
BEGIN
	 SELECT TOP 1 @CDATE=DATEADD(month, 1, LastMonth),@Flage=1 FROM WRBHBInvoiceManagedGHAmountMonthGenerated
	 ORDER BY Id DESC
	 
	 IF ISNULL(@CDATE,'')=''
	 BEGIN
		 SELECT @CDATE=GETDATE();
		 SET @Flage=0
	 END
	 ELSE
	 BEGIN
		IF ((MONTH(@CDATE)=MONTH(GETDATE()))AND(YEAR(@CDATE)=YEAR(GETDATE()))AND(DAY('01/25/2014')=YEAR(GETDATE())))
		BEGIN
			SET @Flage=0
		END
		ELSE
	    BEGIN	
			SET @Flage=1
	    END 
	END	
	IF @Flage=0
	BEGIN
			 CREATE TABLE #NDDCountForecast(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100),
			 PropertyName NVARCHAR(100),ClientId BIGINT,ContractLevel NVARCHAR(100),ContractId BIGINT,ContractType NVARCHAR(100))
			  
		 -- --GET ROOMS ARE DEDICATED OR NON DEDICATER    
		   INSERT INTO #NDDCountForecast(ApartmentId,PropertyId,RoomId,Tariff,PropertyType,PropertyName,ClientId,ContractLevel,ContractId,ContractType)  
		   SELECT CA.ApartmentId,CA.PropertyId,0,Tariff,ContractType,CA.Property,C.ClientId,C.BookingLevel,C.Id,C.RateInterval 
		   FROM dbo.WRBHBContractManagementAppartment CA       
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CA.ContractId AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0
		   JOIN WRBHBProperty P ON P.Id=CA.PropertyId AND P.IsActive=1 AND P.IsDeleted=0  
		   JOIN WRBHBPropertyBlocks B ON P.Id=B.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		   JOIN WRBHBPropertyApartment A ON P.Id=A.PropertyId AND A.IsActive=1 AND A.IsDeleted=0 
		   AND B.Id=A.BlockId AND CA.ApartmentId=A.Id
		   WHERE CA.IsActive=1 AND CA.IsDeleted=0 AND CA.ApartmentId!=0 AND CA.PropertyId!=0  
		      
		   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,ClientId,ContractLevel,ContractId,ContractType)     
		   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.ClientId,C.BookingLevel,C.Id,C.RateInterval 
		   FROM dbo.WRBHBContractManagementTariffAppartment CR  
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId   
		   AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CR.PropertyId AND P.IsActive=1 AND P.IsDeleted=0  
		   JOIN WRBHBPropertyBlocks B ON P.Id=B.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		   JOIN WRBHBPropertyApartment A ON P.Id=A.PropertyId AND A.IsActive=1 AND A.IsDeleted=0 
		   AND B.Id=A.BlockId 
		   JOIN WRBHBPropertyRooms R ON P.Id=A.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 
		   AND B.Id=A.BlockId AND R.ApartmentId=A.Id AND CR.RoomId=R.Id
		   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 AND CR.RoomId!=0  
		     
		   --GET ROOMS ARE DEDICATED Managed Contracts  
		   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,ClientId,
		   ContractLevel,ContractId,ContractType)  
		   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.ClientId,C.BookingLevel,C.Id,C.RateInterval  
		   FROM dbo.WRBHBContractManagementTariffAppartment CR  
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId AND   
		   LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CR.PropertyId AND P.IsActive=1 AND P.IsDeleted=0   
		   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 
		   
		   --INSERT MONTH OF RENT
 			 INSERT INTO  WRBHBInvoiceManagedGHAmountMonthGenerated(LastMonth)
 			 SELECT @CDATE
 			 SELECT @Id1=@@IDENTITY
 			 ---INSERT MONTALY EXTERNAL AMOUNT
			
			
			INSERT INTO WRBHBInvoiceManagedGHAmount(ManagedGHAmountMonthGenerated,RentelAmount ,
			ClientId,ClientName,Type,RentDate,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,ContractId)   
			SELECT @Id1,SUM(Tariff),ClientId,C.ClientName,PropertyType,@CDATE,1,0,1,GETDATE(),1,GETDATE(),NEWID(),ContractId
			FROM #NDDCountForecast B
			JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
			WHERE LTRIM(B.ContractType)=LTRIM('Monthly')			
			GROUP BY ClientId,C.ClientName,PropertyType,ContractId
			
			INSERT INTO WRBHBInvoiceManagedGHAmount(ManagedGHAmountMonthGenerated,RentelAmount ,
			ClientId,ClientName,Type,RentDate,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,ContractId)   
			SELECT @Id1,SUM(Tariff*DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,CONVERT(DATE,@CDATE,103)),0)))),ClientId,C.ClientName,PropertyType,
			@CDATE,1,0,1,GETDATE(),1,GETDATE(),NEWID(),ContractId
			FROM #NDDCountForecast B
			JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
			WHERE LTRIM(B.ContractType)=LTRIM(' Daily ')			
			GROUP BY ClientId,C.ClientName,PropertyType,ContractId
			
			
		
	END	 
END 
IF @Action ='ContractClosed'
BEGIN
       --Dedicated
		UPDATE  WRBHBContractManagement SET ContractStatus='Contract Closed' ,IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		WHERE EndDate<GETDATE() AND IsActive=1 AND IsDeleted=0
		
		UPDATE WRBHBContractManagementAppartment SET IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		FROM WRBHBContractManagementAppartment D
		JOIN WRBHBContractManagement H  WITH(NOLOCK) ON H.Id=D.ContractId AND H.ContractStatus='Contract Closed'
		WHERE D.IsActive=1 AND D.IsDeleted=0
		
		UPDATE WRBHBContractManagementTariffAppartment SET IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		FROM WRBHBContractManagementTariffAppartment D
		JOIN WRBHBContractManagement H  WITH(NOLOCK) ON H.Id=D.ContractId AND H.ContractStatus='Contract Closed'
		WHERE D.IsActive=1 AND D.IsDeleted=0
		
		UPDATE WRBHBContractManagementServices SET IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		FROM WRBHBContractManagementServices D
		JOIN WRBHBContractManagement H  WITH(NOLOCK) ON H.Id=D.ContractId AND H.ContractStatus='Contract Closed'
		WHERE D.IsActive=1 AND D.IsDeleted=0
		
		--Non-Dedicated
		
		UPDATE  WRBHBContractNonDedicated SET ContractStatus='Contract Closed' ,IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		WHERE EndDate<GETDATE() AND IsActive=1 AND IsDeleted=0
		
		UPDATE WRBHBContractNonDedicatedApartment SET IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		FROM WRBHBContractNonDedicatedApartment D
		JOIN WRBHBContractNonDedicated H  WITH(NOLOCK) ON H.Id=D.NondedContractId AND H.ContractStatus='Contract Closed'
		WHERE D.IsActive=1 AND D.IsDeleted=0
		
		UPDATE WRBHBContractNonDedicatedServices SET IsActive=0,IsDeleted=1,
		ModifiedDate=GETDATE()
		FROM WRBHBContractNonDedicatedServices D
		JOIN WRBHBContractNonDedicated H  WITH(NOLOCK) ON H.Id=D.NondedContractId AND H.ContractStatus='Contract Closed'
		WHERE D.IsActive=1 AND D.IsDeleted=0
		
		
END
IF @Action ='Contract Details'
BEGIN
	
		
		CREATE TABLE #Contract(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100),
		PropertyName NVARCHAR(100),ClientId BIGINT,EndDate NVARCHAR(100),RoomNo NVARCHAR(100),BookingLevel NVARCHAR(100))
			  
		 -- --GET ROOMS ARE DEDICATED OR NON DEDICATER    
		   INSERT INTO #Contract(ApartmentId,PropertyId,RoomId,Tariff,PropertyType,PropertyName,ClientId,EndDate,RoomNo,BookingLevel)  
		   SELECT CA.ApartmentId,CA.PropertyId,0,Tariff,ContractType,P.PropertyName,C.ClientId,EndDate,B.BlockName+'-'+A.ApartmentNo,'Dedicated - '+BookingLevel
		   FROM dbo.WRBHBContractManagementAppartment CA       
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CA.ContractId AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CA.PropertyId AND P.IsActive=1 AND P.IsDeleted=0  
		   JOIN WRBHBPropertyBlocks B ON P.Id=B.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		   JOIN WRBHBPropertyApartment A ON P.Id=A.PropertyId AND A.IsActive=1 AND A.IsDeleted=0 
		   AND B.Id=A.BlockId AND CA.ApartmentId=A.Id 
		   WHERE CA.IsActive=1 AND CA.IsDeleted=0 AND CA.ApartmentId!=0 AND CA.PropertyId!=0 
		   AND CONVERT(DATE,EndDate,103)=DATEADD(DAY,9,CONVERT(DATE,GETDATE(),103)) 
		      
		   INSERT INTO #Contract(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,ClientId,EndDate,RoomNo,BookingLevel)     
		   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,P.PropertyName,C.ClientId ,EndDate,B.BlockName+'-'+A.ApartmentNo+'-'+R.RoomNo,'Dedicated - '+BookingLevel
		   FROM dbo.WRBHBContractManagementTariffAppartment CR  
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId   
		   AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CR.PropertyId AND P.IsActive=1 AND P.IsDeleted=0  
		   JOIN WRBHBPropertyBlocks B ON P.Id=B.PropertyId AND B.IsActive=1 AND B.IsDeleted=0
		   JOIN WRBHBPropertyApartment A ON P.Id=A.PropertyId AND A.IsActive=1 AND A.IsDeleted=0 
		   AND B.Id=A.BlockId 
		   JOIN WRBHBPropertyRooms R ON P.Id=A.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 
		   AND B.Id=A.BlockId AND R.ApartmentId=A.Id AND CR.RoomId=R.Id 
		   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 AND CR.RoomId!=0  
		   AND CONVERT(DATE,EndDate,103)=DATEADD(DAY,9,CONVERT(DATE,GETDATE(),103))  
		   
		   --GET ROOMS ARE DEDICATED Managed Contracts  
		   INSERT INTO #Contract(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,ClientId,EndDate,RoomNo,BookingLevel)  
		   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,P.PropertyName,C.ClientId,EndDate,P.PropertyName,'Dedicated - Property'
		   FROM dbo.WRBHBContractManagementTariffAppartment CR  
		   JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId AND   
		   LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CR.PropertyId AND P.IsActive=1 AND P.IsDeleted=0   
		   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 
		   AND CONVERT(DATE,EndDate,103)=DATEADD(DAY,9,CONVERT(DATE,GETDATE(),103)) 
		   
		   --GET ROOMS ARE NON DEDICATED MANAGED CONTRACTS
		   INSERT INTO #Contract(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,ClientId,EndDate,RoomNo,BookingLevel)  
		   SELECT CR.RoomId,CR.PropertyId,0,ApartTarif,ContractType,P.PropertyName,C.ClientId,EndDate,P.PropertyName,'Non-Dedicated - Property'
		   FROM dbo.WRBHBContractNonDedicatedApartment CR  
		   JOIN dbo.WRBHBContractNonDedicated C ON C.Id=CR.NondedContractId    
		   AND C.IsActive=1 AND C.IsDeleted=0 
		   JOIN WRBHBProperty P ON P.Id=CR.PropertyId AND P.IsActive=1 AND P.IsDeleted=0   
		   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 
		   AND CONVERT(DATE,EndDate,103)=DATEADD(DAY,9,CONVERT(DATE,GETDATE(),103))
		   
			
		SELECT B.PropertyType,C.ClientName,CONVERT(NVARCHAR(100),CAST(EndDate AS DATE),105),
		P.PropertyName,RoomNo,BookingLevel,SUM(Tariff),ClientId
		FROM #Contract B
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=B.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		GROUP BY ClientId,C.ClientName,B.PropertyType,EndDate,P.PropertyName,RoomNo,BookingLevel		
END
IF @Action ='Booking Close'
BEGIN
		
		CREATE TABLE #BookingData(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		CheckInDate DATE,CheckOurDate DATE)
		
		CREATE TABLE #BookingDataTariff(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		PId BIGINT PRIMARY KEY IDENTITY(1,1),CheckInDate DATE,CheckOurDate DATE)
		
		CREATE TABLE #BookingDataTariffFinal(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		CheckInDate DATE,CheckOurDate DATE,PId BIGINT PRIMARY KEY IDENTITY(1,1))
		
		CREATE TABLE #LuxuryTax1(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2))  

		CREATE TABLE #LuxuryTax2(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2),  
		DATE NVARCHAR(100))
		
		CREATE TABLE #FINALLuxury(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),
		LT DECIMAL(27,2),ST DECIMAL(27,2),DATE NVARCHAR(100))  

		CREATE TABLE #FINAL(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),
		LT DECIMAL(27,2),ST DECIMAL(27,2))  
  
  
  
		DECLARE @BookingId1 BIGINT,@Count1 BIGINT,@NoData BIGINT;
		
		DECLARE @Tariff1 DECIMAL(27,2),@RackTariffSingle DECIMAL(27,2),@RackTariffDouble DECIMAL(27,2),
		@Dt1 DateTime ,@prtyId BIGINT,@chktime NVARCHAR(100),@TimeType NVARCHAR(100),@chkouttime NVARCHAR(100);  
		DECLARE @DateDiff1 int,@J int,@HR1 NVARCHAR(100),@MIN INT,@OutPutSEC INT,@OutPutHour INT,  
		@NoOfDays1 INT,@RoomId1 BIGINT,@BedId BIGINT,@ApartmentId1 BIGINT,@BookingLevel1 NVARCHAR(100),
		@PId BIGINT,@RoomCapture INT,@StateId BIGINT,@ChkInDateNew DATE,@ChkOutDateNew DATE;
		
		--GET ROOM LEVEL
		INSERT INTO #BookingData(BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,
		GuestId,RoomCaptured,RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate)
		SELECT G.BookingId,G.Id,'Room',G.Tariff,CONVERT(DATE,GETDATE(),103),Occupancy,GuestId,RoomCaptured,
		RoomId,0,0,B.StateId,B.ClientId,G.BookingPropertyId,G.ChkInDt,G.ChkOutDt
		FROM WRBHBBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		WHERE CONVERT(NVARCHAR(100),ChkInDt,103)=CONVERT(NVARCHAR(100),DATEADD(DAY,-3,GETDATE()),103) 
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		
		--GET BED LEVEL
		INSERT INTO #BookingData(BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,
		GuestId,RoomCaptured,RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate)
		SELECT G.BookingId,G.Id,'Bed',G.Tariff,CONVERT(DATE,GETDATE(),103),'Single',GuestId,0,
		RoomId,BedId,0,B.StateId,B.ClientId,G.BookingPropertyId,G.ChkInDt,G.ChkOutDt
		FROM WRBHBBedBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		WHERE CONVERT(NVARCHAR(100),ChkInDt,103)=CONVERT(NVARCHAR(100),DATEADD(DAY,-4,GETDATE()),103) 
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		
		--GET APARTMENT LEVEL
		INSERT INTO #BookingData(BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,
		GuestId,RoomCaptured,RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate)
		SELECT G.BookingId,G.Id,'Apartment',G.Tariff,CONVERT(DATE,GETDATE(),103),'Double',GuestId,0,
		0,0,ApartmentId,B.StateId,B.ClientId,G.BookingPropertyId,G.ChkInDt,G.ChkOutDt
		FROM WRBHBApartmentBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		WHERE CONVERT(NVARCHAR(100),ChkInDt,103)=CONVERT(NVARCHAR(100),DATEADD(DAY,-4,GETDATE()),103) 
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		
		INSERT INTO #BookingDataTariff(BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,
		GuestId,RoomCaptured,RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate)
		SELECT BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,GuestId,RoomCaptured,
		RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate
		FROM #BookingData
		
		
		SELECT @NoOfDays=COUNT(*) FROM #BookingDataTariff
		
		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@BedId=BedId,
		@ApartmentId1=ApartmentId,@BookingLevel1=BookingLevel,@PId=PId,
		@RoomCapture=RoomCaptured
		FROM #BookingDataTariff
		
		
		WHILE (@NoOfDays>0)  
		BEGIN 
			INSERT INTO #BookingDataTariffFinal(BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,
			TodayDate,Occupancy,GuestId,RoomCaptured,RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,
			CheckInDate,CheckOurDate)			
			SELECT BookingId,PropertyAssingedGuestId,BookingLevel,Tariff,TodayDate,Occupancy,GuestId,RoomCaptured,
			RoomId,BedId,ApartmentId,StateId,ClientId,PropertyId,CheckInDate,CheckOurDate
			FROM #BookingDataTariff
			WHERE PId=@PId
			
			
			IF @BookingLevel1='Room'
			BEGIN			
			
				DELETE FROM #BookingDataTariff WHERE BookingId=@BookingId1 AND RoomId=@RoomId1
				AND RoomCaptured=@RoomCapture
			END
			IF @BookingLevel1='Bed'
			BEGIN			
				DELETE FROM #BookingDataTariff WHERE BookingId=@BookingId1 AND RoomId=@RoomId1
				AND RoomCaptured=@RoomCapture
			END
			IF @BookingLevel1='Apartment'
			BEGIN			
				DELETE FROM #BookingDataTariff WHERE BookingId=@BookingId1 AND ApartmentId=@ApartmentId
				AND RoomCaptured=@RoomCapture
			END
			
			SELECT @NoOfDays=COUNT(*) FROM #BookingDataTariff

			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@BedId=BedId,
			@ApartmentId1=ApartmentId,@BookingLevel1=BookingLevel,@PId=PId,
			@RoomCapture=RoomCaptured
			FROM #BookingDataTariff
			
		END	
		
		---ONE DAY TARIFF CALCULATION ADD TO CHECKOUT TABLE
		SELECT @NoData=COUNT(*) FROM #BookingDataTariffFinal
		SELECT @StateId=StateId,@ChkInDateNew=CheckInDate,@ChkOutDateNew=CheckOurDate,
		@PId=PId
		FROM #BookingDataTariffFinal		
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
			---TO GET TAX VALUE FOR GIVAEN DATE  
			-- select @ChkInDate,@ChkOutDate,@StateId; 
			DELETE FROM #LuxuryTax1
			 
			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),Date,103) between CONVERT(nvarchar(100),@ChkInDateNew,103) and  
			CONVERT(nvarchar(100),@ChkOutDateNew,103)    
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),DateTo,103) between CONVERT(nvarchar(100),@ChkInDateNew,103) and  
			CONVERT(nvarchar(100),@ChkOutDateNew,103)    
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),@ChkInDateNew,103)   
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),@ChkOutDateNew,103)<= CONVERT(nvarchar(100),DateTo,103)    
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  



			  
			--SELECT * from #LuxuryTax1  
			DELETE FROM #LuxuryTax2
			SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
			FROM #LuxuryTax1;    
			WHILE (@DateDiff>=0)  
			BEGIN         
				INSERT INTO #LuxuryTax2(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Date,TariffAmtFrom,TariffAmtFrom1,  
				TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
				SELECT TOP 1 LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,FromDT,103)),103),  
				TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3     
				FROM #LuxuryTax1  
				SET @i=@i+1  
				SET @DateDiff=@DateDiff-1     
				IF @DateDiff=0  
				BEGIN  
				DELETE FROM #LuxuryTax1  
				WHERE Id IN(SELECT TOP 1 Id FROM #LuxuryTax1)  
				SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
				FROM #LuxuryTax1;  
			END  
			END
			
			 --SLAB 1 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax*Tariff/100,0),0,ISNULL(h.LuxuryTax,0),  
			ISNULL(h.ServiceTax,0),D.TodayDate   
			FROM #LuxuryTax2 h  
			JOIN #BookingDataTariffFinal d ON H.Date = D.TodayDate  
			WHERE  Tariff between h.TariffAmtFrom AND h.TariffAmtTo  
			AND RackTariffFlag=1  AND PId=@PId

			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax*(RackTariffDouble)/100,0),0,ISNULL(h.LuxuryTax,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE (RackTariffDouble) between h.TariffAmtFrom AND h.TariffAmtTo  
			AND RackTariffFlag=1  

			--SLAB 2 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax1*(RackTariffSingle)/100,0),0,ISNULL(h.LuxuryTax1,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			left outer join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffSingle) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
			AND RackTariffFlag=1  

			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax1*(RackTariffDouble)/100,0),0,ISNULL(h.LuxuryTax1,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			left outer join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffDouble) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
			AND RackTariffFlag=1  

			--SLAB 3 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax2*(RackTariffSingle)/100,0),0,ISNULL(h.LuxuryTax2,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffSingle) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
			AND RackTariffFlag=1  

			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax2*(RackTariffDouble)/100,0),0,ISNULL(h.LuxuryTax2,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffDouble) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
			AND RackTariffFlag=1  

			--SLAB 4 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax3*(RackTariffSingle)/100,0),0,ISNULL(h.LuxuryTax3,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffSingle) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
			AND RackTariffFlag=1  

			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax3*(RackTariffDouble)/100,0),0,ISNULL(h.LuxuryTax3,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (RackTariffDouble) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
			AND RackTariffFlag=1  

			--RACKTARIFFFLAG 0  
			--SLAB 1 CHECK   
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff, ISNULL(h.LuxuryTax*(D.Tariff)/100,0),0,ISNULL(h.LuxuryTax,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (Tariff) between h.TariffAmtFrom AND h.TariffAmtTo  
			AND RackTariffFlag=0  

			--SLAB 2 CHECK   
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax1*(D.Tariff)/100,0),0,ISNULL(h.LuxuryTax1,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (Tariff) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
			AND RackTariffFlag=0  

			--SLAB 3 CHECK   
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax2*(D.Tariff)/100,0),0,ISNULL(h.LuxuryTax2,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (Tariff) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
			AND RackTariffFlag=0  

			--SLAB 4 CHECK   
			INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
			SELECT D.Tariff,ISNULL(h.LuxuryTax3*(D.Tariff)/100,0),0,ISNULL(h.LuxuryTax3,0),  
			ISNULL(h.ServiceTax,0),D.Date   
			FROM #LuxuryTax2 h  
			join #Tariff d ON H.Date = D.Date  
			WHERE  (Tariff) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
			AND RackTariffFlag=0  

			INSERT INTO #FINAL(TARIFF,LuxuryTax,ServiceTax,LT,ST)  
			SELECT SUM(TARIFF),SUM(LuxuryTax),SUM((TARIFF*ST)/100),LT,ST FROM   
			#FINALLuxury  
			GROUP BY TARIFF,LuxuryTax,ServiceTax,LT,ST  


			--Select * from #Tariff;  
			--  SELECT ChkInDate,ChkOutDate FROM #LEVEL;  
			SELECT @NoOfDays as NoofDays --FROM #Tariff  
			SELECT TARIFF as NetTariff,LuxuryTax,ServiceTax,LT,ST FROM #FINAL 
		
		END
		
		--SET DEACTIVATE ROOM LEVEL
		UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,CurrentStatus='No Show',
		ModifiedDate=GETDATE()
		FROM #BookingData B
		WHERE B.BookingId=WRBHBBookingPropertyAssingedGuest.BookingId AND B.PropertyAssingedGuestId=WRBHBBookingPropertyAssingedGuest.Id
		AND B.BookingLevel='Room'
		
		--SET DEACTIVATE BED LEVEL
		UPDATE WRBHBBedBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,CurrentStatus='No Show',
		ModifiedDate=GETDATE()
		FROM #BookingData B
		WHERE B.BookingId=WRBHBBedBookingPropertyAssingedGuest.BookingId 
		AND B.PropertyAssingedGuestId=WRBHBBedBookingPropertyAssingedGuest.Id
		AND B.BookingLevel='Bed'
		
		--SET DEACTIVATE APARTMENT LEVEL
		UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,CurrentStatus='No Show',
		ModifiedDate=GETDATE()
		FROM #BookingData B
		WHERE B.BookingId=WRBHBApartmentBookingPropertyAssingedGuest.BookingId 
		AND B.PropertyAssingedGuestId=WRBHBApartmentBookingPropertyAssingedGuest.Id
		AND B.BookingLevel='Apartment'
		
		
		
		--BOOKING TABLE NOSHOW
		--ROOMLEVEL
		SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
		WHERE BookingLevel='Room'
		SELECT @NoData=COUNT(*) FROM #BookingData
		WHERE BookingLevel='Room'
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
		
			SELECT @Count1=COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
			WHERE BookingId=@BookingId1 AND IsActive=1 AND IsDeleted=0
			
			IF ISNULL(@Count1,0)=0
			BEGIN
				UPDATE WRBHBBooking SET CancelStatus='No Show',ModifiedDate=GETDATE()
				WHERE Id =@BookingId1
			END	
			
			DELETE FROM #BookingData WHERE BookingId=@BookingId1	
			
			SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
			WHERE BookingLevel='Room'
			SELECT @NoData=COUNT(*) FROM #BookingData
			WHERE BookingLevel='Room'
		END
		
		--BEDLEVEL
		SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
		WHERE BookingLevel='Bed'
		SELECT @NoData=COUNT(*) FROM #BookingData
		WHERE BookingLevel='Bed'
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN 
			SELECT @Count1=COUNT(*) FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE BookingId=@BookingId1 AND IsActive=1 AND IsDeleted=0
			IF ISNULL(@Count1,0)=0
			BEGIN
				UPDATE WRBHBBooking SET CancelStatus='No Show',ModifiedDate=GETDATE()
				WHERE Id =@BookingId1
			END	
			
			DELETE FROM #BookingData WHERE BookingId=@BookingId1	
			
			SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
			WHERE BookingLevel='Bed'
			SELECT @NoData=COUNT(*) FROM #BookingData
			WHERE BookingLevel='Bed'
		END
		
		--APARTMENTLEVEL
		SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
		WHERE BookingLevel='Apartment'
		SELECT @NoData=COUNT(*) FROM #BookingData
		WHERE BookingLevel='Apartment'
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN 
			SELECT @Count1=COUNT(*) FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE BookingId=@BookingId1 AND IsActive=1 AND IsDeleted=0
			IF ISNULL(@Count1,0)=0
			BEGIN
				UPDATE WRBHBBooking SET CancelStatus='No Show',ModifiedDate=GETDATE()
				WHERE Id =@BookingId1
			END	
			
			DELETE FROM #BookingData WHERE BookingId=@BookingId1	
			
			SELECT TOP 1 @BookingId1=BookingId FROM #BookingData
			WHERE BookingLevel='Apartment'
			SELECT @NoData=COUNT(*) FROM #BookingData
			WHERE BookingLevel='Apartment'
		END
		
		
		
		
 
END 
IF @Action ='Booking Close Details'
BEGIN

		CREATE TABLE #BookingDataDetails(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		ClientName NVARCHAR(100),PropertyName NVARCHAR(100),RM NVARCHAR(500),BookingCode NVARCHAR(100),CheckInDate NVARCHAR(100),
		GuestName NVARCHAR(500))
		
		CREATE TABLE #BookingDataDetailsCount(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		ClientName NVARCHAR(100),PropertyName NVARCHAR(100),RM NVARCHAR(500),BookingCode NVARCHAR(100),CheckInDate NVARCHAR(100),
		GuestName NVARCHAR(500))
		
		CREATE TABLE #BookingDataDetailsFinal(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		ClientName NVARCHAR(100),PropertyName NVARCHAR(100),RM NVARCHAR(500),BookingCode NVARCHAR(100),CheckInDate NVARCHAR(100),
		GuestName NVARCHAR(500))
		
		CREATE TABLE #BookingRMDetails(BookingId BIGINT,RM NVARCHAR(500),BookingCode NVARCHAR(100))
		
		
		--GET ROOM LEVEL
		INSERT INTO #BookingDataDetails(BookingCode,BookingId,BookingLevel,ClientName,PropertyName,RM,CheckInDate,GuestName)
		SELECT B.BookingCode,G.BookingId,'Room',C.ClientName,P.PropertyName,ISNULL(U.FirstName,''),
		CONVERT(NVARCHAR(100),ChkInDt,103),G.FirstName+' '+G.LastName
		FROM WRBHBBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103)
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,C.ClientName,P.PropertyName,U.FirstName,ChkInDt,G.FirstName,G.LastName
		
		--RM DATA
		INSERT INTO #BookingRMDetails(BookingCode,BookingId,RM)
		SELECT B.BookingCode,G.BookingId,ISNULL(U.FirstName,'')		
		FROM WRBHBBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103)
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,U.FirstName
		
		--GET BED LEVEL
		INSERT INTO #BookingDataDetails(BookingCode,BookingId,BookingLevel,ClientName,PropertyName,RM,CheckInDate,GuestName)
		SELECT B.BookingCode,G.BookingId,'Bed',C.ClientName,P.PropertyName,ISNULL(U.FirstName,''),
		CONVERT(NVARCHAR(100),ChkInDt,103),G.FirstName+' '+G.LastName
		FROM WRBHBBedBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103) 
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,C.ClientName,P.PropertyName,U.FirstName,ChkInDt,G.FirstName,G.LastName
		
		--RM DATA
		INSERT INTO #BookingRMDetails(BookingCode,BookingId,RM)
		SELECT B.BookingCode,G.BookingId,ISNULL(U.FirstName,'')		
		FROM WRBHBBedBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103)
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,U.FirstName
		
		
		--GET APARTMENT LEVEL
		INSERT INTO #BookingDataDetails(BookingCode,BookingId,BookingLevel,ClientName,PropertyName,RM,CheckInDate,GuestName)
		SELECT B.BookingCode,G.BookingId,'Apartment',C.ClientName,P.PropertyName,ISNULL(U.FirstName,''),
		CONVERT(NVARCHAR(100),ChkInDt,103),G.FirstName+' '+G.LastName
		FROM WRBHBApartmentBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')		
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103)
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,C.ClientName,P.PropertyName,U.FirstName,ChkInDt,G.FirstName,G.LastName
				
				
		--RM DATA
		INSERT INTO #BookingRMDetails(BookingCode,BookingId,RM)
		SELECT B.BookingCode,G.BookingId,ISNULL(U.FirstName,'')		
		FROM WRBHBApartmentBookingPropertyAssingedGuest G
		JOIN WRBHBBooking B ON B.Id=G.BookingId AND B.IsActive=1 AND B.IsDeleted=0 AND 
		ISNULL(B.CancelStatus,'')NOT IN('Canceled','No Show')
		JOIN WRBHBClientManagement C ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0
		JOIN WRBHBProperty P ON P.Id=G.BookingPropertyId AND P.IsActive=1 AND P.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON P.Id =PU.PropertyId 
		AND PU.IsActive=1 AND PU.IsDeleted=0 AND 
		UserType in('Resident Managers','Assistant Resident Managers')
		LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
		WHERE CONVERT(DATE,ChkInDt,103)BETWEEN 
		CONVERT(DATE,DATEADD(DAY,-3,GETDATE()),103) AND CONVERT(DATE,GETDATE(),103)
		AND G.IsActive=1 AND G.IsDeleted=0
		AND B.Id NOT IN(SELECT BookingId FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,G.BookingId,U.FirstName
		
		
		
		INSERT INTO #BookingDataDetailsCount(BookingCode,BookingId,RM)
		SELECT BookingCode,BookingId,RM
		FROM #BookingRMDetails B
		WHERE B.BookingId IN(SELECT BookingId FROM #BookingRMDetails   
        GROUP BY BookingId,BookingCode HAVING COUNT(*) =1)
		
		
		INSERT INTO #BookingDataDetailsCount(BookingCode,BookingId,RM)
		SELECT  BookingCode,BookingId,RM
		FROM #BookingDataDetails B
		WHERE B.BookingId IN(SELECT BookingId FROM #BookingDataDetails   
        GROUP BY BookingId,BookingCode HAVING COUNT(*) >=2)
        
        
        INSERT INTO #BookingDataDetailsFinal(BookingId,BookingCode,RM)
        SELECT T2.BookingId,T2.BookingCode,
        (SELECT Substring((SELECT ', ' + CAST(t1.RM AS VARCHAR(1024))   
		FROM   #BookingRMDetails t1 WHERE  t1.BookingId = t2.BookingId		
		FOR XML PATH('')), 3, 10000000) AS list) AS  RM		 
		FROM #BookingDataDetailsCount T2
		
				
		SELECT D.BookingCode,D.CheckInDate,D.ClientName,D.PropertyName,D.GuestName,H.RM,D.BookingLevel,D.BookingId
		FROM #BookingDataDetailsFinal H
		JOIN #BookingDataDetails D WITH(NOLOCK) ON H.BookingId=D.BookingId
		GROUP BY D.BookingCode,D.BookingId,D.BookingLevel,D.ClientName,D.PropertyName,H.RM,D.CheckInDate,D.GuestName
		ORDER BY CAST(D.CheckInDate AS DATE),BookingCode
		
		SELECT CONVERT(NVARCHAR(100),DATEADD(DAY,1,GETDATE()),103)	AS TOMODATE
		
	END	
END














	
	