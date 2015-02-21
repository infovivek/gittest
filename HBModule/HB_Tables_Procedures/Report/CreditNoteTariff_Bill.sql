-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CreditNoteTariff_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteTariff_Bill]
GO
/*=============================================
Author Name  : Anbu
Created Date : 09/02/2015 
Section  	 : Report
Purpose  	 : CreditNoteTariff_Bill
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CreditNoteTariff_Bill]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 INT=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='PAGELOAD'
	BEGIN
		DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@LOGO VARCHAR(MAX),@LuxuryTax NVARCHAR(100),
		@TariffAmount DECIMAL(27,2),@ClientAddress NVARCHAR(500),@ClientId BIGINT;  
	
		SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)  
		SET @Address=(SELECT Address FROM WRBHBCompanyMaster)  
		SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
		
		SELECT @ClientId=H.ClientId  FROM WRBHBChechkOutHdr H
		JOIN WRBHBCreditNoteTariffHdr I WITH(NOLOCK) ON H.Id=I.CheckOutId
		WHERE I.Id=@Id1
		SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
		WHERE H.Id=@ClientId
		
			
		 SELECT h.GuestName as GuestName,CONVERT(NVARCHAR(100),CN.CreatedDate,103) as BillDate,P.PropertyName ,
		 h.ClientName,CN.CrdInVoiceNo AS InVoiceNo,CD.NoOfDays,CONVERT(NVARCHAR(100),d.ArrivalDate,103)as ArrivalDate,  
		 ROUND(CD.Amount,0) Tariff,CD.NoOfDays,CD.Total As TotalTariff,CN.LuxuryTax,CN.ServiceTax1 AS SerivceNet,CN.ServiceTax2 AS ServiceCharge,
		 (c.CityName+','+s.StateName+','+p.Postal) as Propcity,@CompanyName as CompanyName,@LOGO AS logo,CN.Description,
		 CONVERT(NVARCHAR(100),h.BillFromDate,103) ChkinDT,CONVERT(NVARCHAR(100),h.BillEndDate,103) as ChkoutDT,CN.ChkInVoiceNo AS PIInvoice,
		 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
		 @ClientAddress as Address,(CD.Total+CN.LuxuryTax+CN.ServiceTax1+CN.ServiceTax2) AS NetAmount,  
		 'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
		 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
		 CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
		 'Rupees : '+dbo.fn_NtoWord(ROUND(h.ChkOutTariffNetAmount,0),'','') AS AmtWords
		 FROM WRBHBCreditNoteTariffDtls CD 
		 JOIN WRBHBCreditNoteTariffHdr CN ON CD.CrdTariffHdrId=CN.Id
		 JOIN WRBHBChechkOutHdr h  ON CN.CheckOutId=H.Id
		 join WRBHBCheckInHdr d ON h.ChkInHdrId = d.Id  
		 join WRBHBProperty p ON d.PropertyId = p.Id 
		 join WRBHBState s ON s.Id=p.StateId
		 join WRBHBCity c ON c.Id=p.CityId 
		 join WRBHBTaxMaster t ON t.StateId=s.Id   
		 WHERE h.IsActive = 1 and h.IsDeleted = 0 
		 and  CN.Id= @Id1 
	
		
		
	 
END
END



