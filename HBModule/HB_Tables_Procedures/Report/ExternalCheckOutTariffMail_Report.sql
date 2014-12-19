-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_ExternalCheckOutTariffMail_Report]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_ExternalCheckOutTariffMail_Report]
GO
/*=============================================
Author Name  : shameem
Created Date : 03/03/2013 
Section  	 : Report
Purpose  	 : Guest Checkout
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_ExternalCheckOutTariffMail_Report]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 INT=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='PageLoad'
	BEGIN
	
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@PanCardNo VARCHAR(100),  
	@ServiceTaxNo VARCHAR(100),@LOGO VARCHAR(MAX),@LuxuryTax NVARCHAR(100),
	@TariffAmount DECIMAL(27,2),@ClientAddress NVARCHAR(500),@ClientId BIGINT;  

	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)  
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)  
	SET @PanCardNo =(SELECT PanCardNo FROM WRBHBCompanyMaster)  
	SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
	
	SELECT @ClientId=I.ClientId  FROM WRBHBChechkOutHdr H
	join WRBHBExternalChechkOutTAC T  on h.Id = T.ChkOutHdrId
	JOIN WRBHBBooking I WITH(NOLOCK) ON I.Id=H.BookingId
	
	WHERE T.Id=@Id1
    SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
	WHERE H.Id=@ClientId
	
	
	SELECT DISTINCT h.GuestName as GuestName,h.Name,h.Stay,h.Type,d.Type as BookingLevel,
	'Check Out :'+convert(nvarchar(100),CONVERT(nvarchar(100),h.CheckOutDate,103),110) as BillDate,  
	 h.ClientName,h.CheckOutNo,T.TACInvoiceNo InVoiceNo,  
	 T.Rate as Tariff,T.MarkUpAmount as TotalTariff,round(T.TACAmount,0) as NetAmount,  
	 T.TotalBusinessSupportST as SerivceTax,T.ChkOutTariffCess as Cess,T.NoOfDays,  
	 T.ChkOutTariffHECess as HCess,
	 'Check In :'+convert(nvarchar(100),h.CheckInDate,103) as ArrivalDate,  
	 (p.Propertaddress) as Propertyaddress,(c.CityName+','+  
	 s.StateName+','+p.Postal) as Propcity,c.CityName as City,s.StateName as State,p.Postal,  
	 p.Phone as Phone,p.Email,p.PropertyName,
	 @CompanyName as CompanyName,@LOGO AS logo,  
	 'Humming Bird Travel & Stay Pvt lt. No 122, Amarjyothi Layout, Domlur Bangalore - 560071. CIN No - U72900KA2005PTC035942'  AS CompanyAddress,
	 @ClientAddress as Address,  
	 'Guest Name :'+d.ChkInGuest as Product,
	 
	 'Rupees : '+dbo.fn_NtoWord(ROUND(T.TACAmount,0),'','') Invoice,  
	 'Email Id - info@hummingbirdindia.com   -  Ph No - 080-42840420' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,  
	 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
	 'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
	 'AABCH5874RST001' as ServiceTaxNo,'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	 'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),CONVERT(nvarchar(100),GETDATE(),103),110) as InVoicedate,
	 'Rupees : '+dbo.fn_NtoWord(ROUND(T.TACAmount,0),'','') AS Invoice,'HDFC BANK' as Bank,'17552560000226' as AccountNo,
	 'HDFC0001755' as IFSCCode,@PanCardNo as PanCardNo,
	 'Business Support Service' as Category,p.Localityarea as Location,
	 (ISNULL(T.TotalBusinessSupportST,0)+ISNULL(T.ChkOutTariffCess,0)+ISNULL(T.ChkOutTariffHECess,0)) AS ST
	   
	 from WRBHBChechkOutHdr h  
	 join WRBHBExternalChechkOutTAC T on h.Id = T.ChkOutHdrId
	 join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id  
	 join WRBHBProperty p on d.PropertyId = p.Id 
	 join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
--	 join WRBHBLocality L on L.CityId = c.Id
	 join WRBHBBooking b on b.Id = d.BookingId 	   
	 where h.IsActive = 1 and h.IsDeleted = 0 
	 and   
	 T.Id = @Id1  
	 
END
END