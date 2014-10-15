
GO
/****** Object:  StoredProcedure [dbo].[SP_ContractBill_Report]    Script Date: 09/22/2014 15:04:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=============================================
Author Name  : Naharjun.U
Created Date : 20/08/2014 
Section  	 : Contract Bill Report
Purpose  	 : Report
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
ALTER PROCEDURE  [dbo].[SP_ContractBill_Report] 
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 INT=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='Pageload'
	BEGIN
						
		DECLARE @StartDate DATE,@Enddate DATE,@ContractEndDate DATE,@ContractStartDate DATE,
		@ContractLevel NVARCHAR(100),@ContractId BIGINT;
		SET @ContractStartDate=(SELECT CONVERT(DATE,StartDate,106) FROM WRBHBContractManagement WHERE Id=@Id1)
		SET @ContractEndDate=(SELECT CONVERT(DATE,EndDate,106) FROM WRBHBContractManagement WHERE Id=@Id1)
		
		SELECT @ContractLevel=BookingLevel FROM  WRBHBInvoiceManagedGHAmount H
		JOIN WRBHBContractManagement  D WITH(NOLOCK) ON D.Id=H.ContractId 
		WHERE H.Id=@Id1  
		
		IF(@ContractStartDate<GETDATE())
			BEGIN
				SET @StartDate=(SELECT DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)))
			END
		ELSE
			BEGIN
				SET @StartDate=@ContractStartDate
			END
		IF(@ContractEndDate>GETDATE())
			BEGIN
				SET @Enddate=(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))
			END
		ELSE
			BEGIN
				SET @Enddate=@ContractEndDate
			END
	--select @StartDate,@Enddate,@ContractStartDate,@ContractEndDate
		IF @Str1='M'
		BEGIN
		--select @Str1
			SELECT P.PropertyName AS PropertyName,P.Propertaddress AS Propertaddress,'Phone :'+P.Phone AS Phone,
			'Email :'+P.Email AS Email,CMG.ClientName AS CompanyName,'Management Fees for ' + CMTA.Property 
			+'For the Month of '+substring(CONVERT(nvarchar(100),getdate(),107),0,4)+' '+
			substring(CONVERT(nvarchar(100),getdate(),107),11,13) AS Description,CMG.BAddress1 AS Address,
			CMG.BCity AS City,CMG.BState AS State,CMG.ContactNo AS PanCardNo,CONVERT(NVARCHAR(100),MA.StartDate,106) 
			AS ChkInDt,CONVERT(NVARCHAR(100),MA.Enddate,106) AS CHkOutDt,InvoiceNo as Invoice,
			MA.RentelAmount AS TotalTariff,
			Convert(NVARCHAR(100),GETDATE(),106) AS BillDate,			
			AdjustmentAmount AS Rate,DATEDIFF(DAY,MA.StartDate,MA.Enddate)+1 AS NoOfDays,
			ROUND(TotalAmount,0) AS NetAmount,MA.Attention AS ClientName,CM.Id,
			'Please make the payment in favour of' AS Latepay,
			'Humming Bird Travel & Stay Pvt Ltd.' AS ExtraMatress,'Bank' AS Tin,
			'HSBC, Bangalore' AS ServiceHCess,
			'Account No' AS ServiceTaxNo,'071358154001 (CA)' AS ServiceCess,'IFSC Code' AS TaxNo,
			'HSBC056002' AS SServiceTax,'All bank charges, where applicable, to the account of the client' AS CompanyAddress,
			'Notify any discrepancy in writing within 7 days of receipt of this invoice' AS Item,
			'PAN No:AABCH 5874 R,L Tax No:L00100571,TIN No:29340489869' AS Price,
			'Service Tax No – AABCH5874RST001,Category – Accommodation Services & Business Support' AS Quantity,
			MA.ReferenceNo as Cheque,
			dbo.fn_NtoWord(ROUND(TotalAmount,0),'','') AS Logo,
			'Service Tax @'+CAST(STper AS NVARCHAR)+'%' AS SerivceNet,
			(isnull(STTax,0)-(ISNULL(Cess,0)+(ISNULL(HCess,0)))) AS ServiceCharge,
			Cess AS Cess,
			HCess AS HCess,
			'CIN No: U72900KA2005PTC035942' as CINNo			
			FROM WRBHBInvoiceManagedGHAmount MA
			JOIN WRBHBContractManagement CM ON MA.ContractId=CM.Id
			JOIN WRBHBClientManagement CMG ON MA.ClientId=CMG.Id
			JOIN WRBHBContractManagementTariffAppartment CMTA ON CM.Id=CMTA.ContractId
			JOIN WRBHBProperty P ON CMTA.PropertyId=P.Id
			where ISNULL(InvoiceNo,'')!='' AND MA.Id=@Id1-- AND MA.Type=' Managed Contracts '
		END
		IF @Str1='D'
		BEGIN
			 
			IF @ContractLevel!='Apartment'
			BEGIN
				SELECT P.PropertyName AS PropertyName,P.Propertaddress AS Propertaddress,'Phone :'+P.Phone AS Phone,
				'Email :'+P.Email AS Email,CMG.ClientName AS CompanyName,'Management Fees for ' + CMTA.Property 
				+'For the Month of '+substring(CONVERT(nvarchar(100),getdate(),107),0,4)+' '+
				substring(CONVERT(nvarchar(100),getdate(),107),11,13) AS Description,CMG.BAddress1 AS Address,
				CMG.BCity AS City,CMG.BState AS State,CMG.ContactNo AS PanCardNo,CONVERT(NVARCHAR(100),MA.StartDate,106) 
				AS ChkInDt,CONVERT(NVARCHAR(100),MA.Enddate,106) AS CHkOutDt,InvoiceNo as Invoice,
				MA.RentelAmount AS TotalTariff,Convert(NVARCHAR(100),GETDATE(),106) AS BillDate,			
				AdjustmentAmount AS Rate,DATEDIFF(DAY,MA.StartDate,MA.Enddate)+1 AS NoOfDays,
				ROUND(TotalAmount,0) AS NetAmount,MA.Attention AS ClientName,CM.Id,
				'Please make the payment in favour of' AS Latepay,
				'Humming Bird Travel & Stay Pvt Ltd.' AS ExtraMatress,'Bank' AS Tin,
				'HSBC, Bangalore' AS ServiceHCess,
				'Account No' AS ServiceTaxNo,'071358154001 (CA)' AS ServiceCess,'IFSC Code' AS TaxNo,
				'HSBC056002' AS SServiceTax,'All bank charges, where applicable, to the account of the client' AS CompanyAddress,
				'Notify any discrepancy in writing within 7 days of receipt of this invoice' AS Item,
				'PAN No:AABCH 5874 R,L Tax No:L00100571,TIN No:29340489869' AS Price,
				'Service Tax No – AABCH5874RST001,Category – Accommodation Services & Business Support' AS Quantity,
				MA.ReferenceNo as Cheque,
				dbo.fn_NtoWord(ROUND(TotalAmount,0),'','') AS Logo,
				'Service Tax @'+CAST(STper AS NVARCHAR)+'%' SerivceNet,
				'Luxury Tax '+CAST(LTper AS NVARCHAR)+'%' AS LTPer,
				LTTax as LuxuryTax,(isnull(STTax,0)-(ISNULL(Cess,0)+(ISNULL(HCess,0)))) AS  ServiceCharge,
				Cess AS Cess,
				HCess AS HCess ,
				'CIN No: U72900KA2005PTC035942' as CINNo
				FROM WRBHBInvoiceManagedGHAmount MA
				JOIN WRBHBContractManagement CM ON MA.ContractId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
				JOIN WRBHBClientManagement CMG ON MA.ClientId=CMG.Id AND CMG.IsActive=1 AND CMG.IsDeleted=0
				JOIN WRBHBContractManagementTariffAppartment CMTA ON CM.Id=CMTA.ContractId AND CMTA.IsActive=1
				AND CMTA.IsDeleted=0
				JOIN WRBHBProperty P ON CMTA.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
				where ISNULL(MA.InvoiceNo,'')!='' AND MA.Id=@Id1-- AND MA.Type=' Dedicated Contracts '
			END
			ELSE
			BEGIN
				SELECT P.PropertyName AS PropertyName,P.Propertaddress AS Propertaddress,'Phone :'+P.Phone AS Phone,
				'Email :'+P.Email AS Email,CMG.ClientName AS CompanyName,'Management Fees for ' + CMTA.Property 
				+'For the Month of '+substring(CONVERT(nvarchar(100),getdate(),107),0,4)+' '+
				substring(CONVERT(nvarchar(100),getdate(),107),11,13) AS Description,CMG.BAddress1 AS Address,
				CMG.BCity AS City,CMG.BState AS State,CMG.ContactNo AS PanCardNo,CONVERT(NVARCHAR(100),MA.StartDate,106) 
				AS ChkInDt,CONVERT(NVARCHAR(100),MA.Enddate,106) AS CHkOutDt,InvoiceNo as Invoice,
				MA.RentelAmount AS TotalTariff,Convert(NVARCHAR(100),GETDATE(),106) AS BillDate,			
				AdjustmentAmount AS Rate,DATEDIFF(DAY,MA.StartDate,MA.Enddate)+1 AS NoOfDays,
				ROUND(TotalAmount,0) AS NetAmount,MA.Attention AS ClientName,CM.Id,
				'Please make the payment in favour of' AS Latepay,
				'Humming Bird Travel & Stay Pvt Ltd.' AS ExtraMatress,'Bank' AS Tin,
				'HSBC, Bangalore' AS ServiceHCess,
				'Account No' AS ServiceTaxNo,'071358154001 (CA)' AS ServiceCess,'IFSC Code' AS TaxNo,
				'HSBC056002' AS SServiceTax,'All bank charges, where applicable, to the account of the client' AS CompanyAddress,
				'Notify any discrepancy in writing within 7 days of receipt of this invoice' AS Item,
				'PAN No:AABCH 5874 R,L Tax No:L00100571,TIN No:29340489869' AS Price,
				'Service Tax No – AABCH5874RST001,Category – Accommodation Services & Business Support' AS Quantity,
				MA.ReferenceNo as Cheque,
				dbo.fn_NtoWord(ROUND(TotalAmount,0),'','') AS Logo,
				'Service Tax @'+CAST(STper AS NVARCHAR)+'%' SerivceNet,
				'Luxury Tax '+CAST(LTper AS NVARCHAR)+'%' AS LTPer,
				LTTax as LuxuryTax,(isnull(STTax,0)-(ISNULL(Cess,0)+(ISNULL(HCess,0)))) AS  ServiceCharge,
				Cess AS Cess,
				HCess AS HCess ,
				'CIN No: U72900KA2005PTC035942' as CINNo
				FROM WRBHBInvoiceManagedGHAmount MA
				JOIN WRBHBContractManagement CM ON MA.ContractId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
				JOIN WRBHBClientManagement CMG ON MA.ClientId=CMG.Id AND CMG.IsActive=1 AND CMG.IsDeleted=0
				JOIN WRBHBContractManagementAppartment CMTA ON CM.Id=CMTA.ContractId AND CMTA.IsActive=1
				AND CMTA.IsDeleted=0
				JOIN WRBHBProperty P ON CMTA.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
				where ISNULL(MA.InvoiceNo,'')!='' AND MA.Id=@Id1-- AND MA.Type=' Dedicated Contracts '
			
			
			END
		END
	END	
END