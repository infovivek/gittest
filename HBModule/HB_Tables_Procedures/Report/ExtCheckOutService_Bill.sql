-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_ExtCheckOutService_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_ExtCheckOutService_Bill]
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
CREATE PROCEDURE [dbo].[SP_ExtCheckOutService_Bill]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2  NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='PageLoad'
	BEGIN
--		select distinct  h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,convert(nvarchar(100),h.BillDate,103) as BillDate,
--	h.ClientName,h.Id,
--	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
--	h.ChkOutTariffST2 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,
--	h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),d.ArrivalDate,103) as ArrivalDate,
--	d.Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(p.City+','+
--	p.State+','+p.Postal) as Propcity,p.City,p.State,p.Postal,
--	p.Phone,p.Email,'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as Address,
--	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
--	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
--	and should be crossed A/C PAYEE ONLY.' as Cheque,
--	'LATE PAYMENT : Interest @18 per annum will be charged on all outstanding bill after due date.' as Latepay ,
--	'Hummingbird Travel and Stay Pvt Ltd.' as CompanyName,'PAN NO : AABCH 5874 R' as PanCardNo,'L Tax No : L00100571' as TaxNo,
--	'TIN : 29340489869' as Tin,'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
--	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
--	cs.ChkOutServiceAmtl as Amount,cs.ChkOutServiceVat as Vat,cs.ChkOutServiceLT,cs.ChkOutServiceST as ServiceTax,cs.Cess,cs.HECess,Cs.ChkOutServiceNetAmount,
----	CSD.ChkOutSerItem as Product,CSD.ChkOutSerAmount ,
--CS.ChkOutServiceNetAmount as ServiceNetAmt
	
--	from  WRBHBCheckInHdr d
--	 join WRBHBChechkOutHdr h on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
--	join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and CS.IsDeleted= 0
--	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId and CSD.IsActive = 1 and CSD.IsDeleted = 0
	
--	join WRBHBProperty p on d.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	
--	where h.IsActive = 1 and h.IsDeleted = 0
--	and 
--	CS.CheckOutHdrId =  @Id1

 Declare @ProType nvarchar(100);
 set @ProType = (select top 1 PropertyType from WRBHBChechkOutHdr where Id = @Id1 and IsActive = 1 and IsDeleted = 0)
 --select @ProType ;
 
 
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@PanCardNo VARCHAR(100),
	@ServiceTaxNo VARCHAR(100),@LOGO VARCHAR(MAX),@ClientAddress NVARCHAR(500),@ClientId BIGINT,
	@Miscellaneous DECIMAL(27,2),@MiscellaneousRemarks NVARCHAR(100),@Food DECIMAL(27,2),
	@Laundry DECIMAL(27,2),@Service DECIMAL(27,2) ;
	
	SELECT @Food=SUM(ISNULL(D.ChkOutSerAmount,0)) FROM  WRBHBCheckOutServiceDtls D 
	WHERE D.IsActive=1 AND D.IsDeleted=0
    AND ltrim(D.TypeService)=ltrim('Food And Beverages')
    AND D.CheckOutServceHdrId=@Id1 
    
    SELECT @Laundry=SUM(ISNULL(D.ChkOutSerAmount,0)) FROM  WRBHBCheckOutServiceDtls D 
	WHERE D.IsActive=1 AND D.IsDeleted=0
    AND D.TypeService='Laundry'
    AND D.CheckOutServceHdrId=@Id1
    
    SELECT @Service=SUM(ISNULL(D.ChkOutSerAmount,0)) FROM  WRBHBCheckOutServiceDtls D 
	WHERE D.IsActive=1 AND D.IsDeleted=0
    AND D.TypeService='Services'
    AND D.CheckOutServceHdrId=@Id1
    
    SELECT @Miscellaneous=SUM(ISNULL(MiscellaneousAmount,0))--,@MiscellaneousRemarks=MiscellaneousRemarks 
    FROM dbo.WRBHBCheckOutServiceHdr H
    WHERE H.CheckOutHdrId=@Id1 AND H.IsActive=1 AND H.IsDeleted=0
    
    SELECT TOP 1 @MiscellaneousRemarks=MiscellaneousRemarks 
    FROM dbo.WRBHBCheckOutServiceHdr H
    WHERE H.CheckOutHdrId=@Id1 AND H.IsActive=1 AND H.IsDeleted=0
    
    
	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
	SET @PanCardNo =(SELECT PanCardNo FROM WRBHBCompanyMaster)
	SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
	
	SELECT @ClientId=I.ClientId  FROM WRBHBChechkOutHdr H
	JOIN WRBHBBooking I WITH(NOLOCK) ON I.Id=H.BookingId
	WHERE H.Id=@Id1
    SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
	WHERE H.Id=@ClientId
	
	CREATE TABLE #Prop2(GuestName NVARCHAR(MAX),Name NVARCHAR(MAX),Stay NVARCHAR(MAX),Type NVARCHAR(MAX),
	BookingLevel NVARCHAR(MAX),BillDate NVARCHAR(MAX),ClientName NVARCHAR(100),Id INT, InVoiceNo NVARCHAR(MAX),
	TotalTariff DECIMAL(27,2),LuxuryTax DECIMAL(27,2),NetAmount DECIMAL(27,2),SerivceNet DECIMAL(27,2),
	SerivceTax1 DECIMAL(27,2),Cess1 DECIMAL(27,2),HCess1 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),
	ArrivalDate NVARCHAR(MAX),Tariff DECIMAL(27,2),Propertyaddress NVARCHAR(MAX),
	Propcity NVARCHAR(MAX),CityName NVARCHAR(MAX),StateName NVARCHAR(MAX), Postal NVARCHAR(100),Phone NVARCHAR(MAX),
	Email NVARCHAR(MAX),CompanyName NVARCHAR(MAX),logo NVARCHAR(MAX),ChkinDT NVARCHAR(100),ChkoutDT NVARCHAR(MAX),
	CompanyAddress NVARCHAR(MAX),Invoice NVARCHAR(MAX),Cheque NVARCHAR(MAX),Latepay NVARCHAR(MAX),TaxNo NVARCHAR(MAX),ServiceTaxNo NVARCHAR(MAX),
	Taxablename NVARCHAR(MAX),BrandName NVARCHAR(MAX),Amount DECIMAL(27,2),Vat DECIMAL(27,2),ChkOutServiceLT DECIMAL(27,2),
	ServiceTax DECIMAL(27,2),Cess DECIMAL(27,2),HECess DECIMAL(27,2),ChkOutServiceNetAmount DECIMAL(27,2),
	ServiceNetAmt DECIMAL(27,2),Address NVARCHAR(MAX),VATPer NVARCHAR(MAX),Food DECIMAL(27,2),Laundry DECIMAL(27,2),
	Service DECIMAL(27,2),Miscellaneous  DECIMAL(27,2),MiscellaneousRemarks  NVARCHAR(MAX),ServiceFB NVARCHAR(MAX),
	ServiceOT NVARCHAR(MAX),OtherService DECIMAL(27,2), ChkOutServiceST DECIMAL(27,2),CessService DECIMAL(27,2),
	HECess2 DECIMAL(27,2),CINNo NVARCHAR(MAX),InVoicedate NVARCHAR(MAX),AmtWords NVARCHAR(MAX))
	 
	
	

	INSERT INTO #Prop2(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,Id,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax1 ,Cess1 ,HCess1 ,ServiceCharge ,
	ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Invoice ,Cheque,Latepay ,TaxNo ,ServiceTaxNo,
	Taxablename ,BrandName,Amount ,Vat ,ChkOutServiceLT ,
	ServiceTax ,Cess ,HECess ,ChkOutServiceNetAmount ,ServiceNetAmt ,Address ,VATPer ,Food ,Laundry ,
	Service ,Miscellaneous  ,MiscellaneousRemarks  ,ServiceFB ,
	ServiceOT ,OtherService , ChkOutServiceST ,CessService ,HECess2 ,CINNo ,InVoicedate,AmtWords)
	
	SELECT DISTINCT  h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
	convert(nvarchar(100),h.BillDate,103) as BillDate,
	h.ClientName,h.Id,h.InVoiceNo,
	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
	h.ChkOutTariffST2 as SerivceNet,h.ChkOutTariffST3 as SerivceTax1,h.ChkOutTariffCess as Cess1,
	h.ChkOutTariffHECess as HCess1,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),
	h.CheckInDate,103) as ArrivalDate,
	d.Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'  |  '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	'Stay simplified is brand of Humming Bird' BrandName,
	sum(cs.ChkOutServiceAmtl) as Amount,sum(cs.ChkOutServiceVat) as Vat,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(cs.Cess) Cess,sum(cs.HECess) HECess,sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,
    sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,@ClientAddress as Address,'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
    ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,sum(CS.HECess) HECess,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(ROUND(CS.ChkOutServiceNetAmount,0),'','') AS AmtWords
	
	from  WRBHBCheckInHdr d
	 join WRBHBChechkOutHdr h on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and CS.IsDeleted= 0
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId and CSD.IsActive = 1 and CSD.IsDeleted = 0
	
	join WRBHBProperty p on d.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
	join WRBHBBooking b on b.Id = d.BookingId	
--	join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 and CS.CheckOutHdrId =  @Id1 
	AND h.PropertyType IN ('External Property','CPP')
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.PropertyName,p.Propertaddress,
	c.CityName,s.StateName,p.Postal,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST ,h.InVoiceNo,h.BillFromDate,h.BillEndDate,CS.ChkOutServiceNetAmount--,t.LuxuryNo
   
 -- MGH
   INSERT INTO #Prop2(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,Id,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax1 ,Cess1 ,HCess1 ,ServiceCharge ,
	ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Invoice ,Cheque,Latepay ,TaxNo ,ServiceTaxNo,
	Taxablename ,BrandName,Amount ,Vat ,ChkOutServiceLT ,
	ServiceTax ,Cess ,HECess ,ChkOutServiceNetAmount ,ServiceNetAmt ,Address ,VATPer ,Food ,Laundry ,
	Service ,Miscellaneous  ,MiscellaneousRemarks  ,ServiceFB ,
	ServiceOT ,OtherService , ChkOutServiceST ,CessService ,HECess2 ,CINNo ,InVoicedate,AmtWords)
	
	SELECT DISTINCT  h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
	convert(nvarchar(100),h.BillDate,103) as BillDate,
	h.ClientName,h.Id,h.InVoiceNo,
	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
	h.ChkOutTariffST2 as SerivceNet,h.ChkOutTariffST3 as SerivceTax1,h.ChkOutTariffCess as Cess1,
	h.ChkOutTariffHECess as HCess1,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),
	h.CheckInDate,103) as ArrivalDate,
	d.Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+
	'  |  '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	'Stay simplified is brand of Humming Bird' BrandName,
	sum(cs.ChkOutServiceAmtl) as Amount,sum(cs.ChkOutServiceVat) as Vat,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(cs.Cess) Cess,sum(cs.HECess) HECess,sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,
    sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,@ClientAddress as Address,'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
    ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,sum(CS.HECess) HECess,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(ROUND(CS.ChkOutServiceNetAmount,0),'','') AS AmtWords
	
	from  WRBHBCheckInHdr d
	 join WRBHBChechkOutHdr h on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and CS.IsDeleted= 0
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId and CSD.IsActive = 1 and CSD.IsDeleted = 0
	
	join WRBHBProperty p on h.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
	join WRBHBBooking b on b.Id = d.BookingId	
--	join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 and CS.CheckOutHdrId =  @Id1 
	AND h.PropertyType in ('Managed G H','DdP')
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.PropertyName,p.Propertaddress,
	c.CityName,s.StateName,p.Postal,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST ,h.InVoiceNo,h.BillFromDate,h.BillEndDate,CS.ChkOutServiceNetAmount--,t.LuxuryNo
   
   -- MMT
   INSERT INTO #Prop2(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,Id,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax1 ,Cess1 ,HCess1 ,ServiceCharge ,
	ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Invoice ,Cheque,Latepay ,TaxNo ,ServiceTaxNo,
	Taxablename ,BrandName,Amount ,Vat ,ChkOutServiceLT ,
	ServiceTax ,Cess ,HECess ,ChkOutServiceNetAmount ,ServiceNetAmt ,Address ,VATPer ,Food ,Laundry ,
	Service ,Miscellaneous  ,MiscellaneousRemarks  ,ServiceFB ,
	ServiceOT ,OtherService , ChkOutServiceST ,CessService ,HECess2 ,CINNo ,InVoicedate,AmtWords)
	
	SELECT DISTINCT  h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
	convert(nvarchar(100),h.BillDate,103) as BillDate,
	h.ClientName,h.Id,h.InVoiceNo,
	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
	h.ChkOutTariffST2 as SerivceNet,h.ChkOutTariffST3 as SerivceTax1,h.ChkOutTariffCess as Cess1,
	h.ChkOutTariffHECess as HCess1,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),
	h.CheckInDate,103) as ArrivalDate,
	d.Tariff,(p.HotalName+','+p.Line1) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Pincode) as Propcity,c.CityName,s.StateName,p.Pincode,
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'  |  '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	'Stay simplified is brand of Humming Bird' BrandName,
	sum(cs.ChkOutServiceAmtl) as Amount,sum(cs.ChkOutServiceVat) as Vat,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(cs.Cess) Cess,sum(cs.HECess) HECess,sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,
    sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,@ClientAddress as Address,'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
    ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,sum(CS.HECess) HECess,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(ROUND(CS.ChkOutServiceNetAmount,0),'','') AS AmtWords
	
	from  WRBHBCheckInHdr d
	 join WRBHBChechkOutHdr h on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and CS.IsDeleted= 0
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId and CSD.IsActive = 1 and CSD.IsDeleted = 0
	
	join WRBHBStaticHotels p on d.PropertyId = p.HotalId and p.IsActive = 1 and p.IsDeleted = 0
	join WRBHBState s on s.Id=h.StateId
	 join WRBHBCity c on c.Id=h.CityId 
	join WRBHBBooking b on b.Id = d.BookingId	
	--join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 and CS.CheckOutHdrId =  @Id1 
	AND h.PropertyType = 'MMT'
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.HotalName,p.Line1,
	c.CityName,s.StateName,p.Pincode,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST ,h.InVoiceNo,h.BillFromDate,h.BillEndDate,CS.ChkOutServiceNetAmount--,t.LuxuryNo
  
  SELECT GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,Id,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax1 ,Cess1 ,HCess1 ,ServiceCharge ,
	ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Invoice ,Cheque ,TaxNo ,ServiceTaxNo,
	Taxablename ,BrandName,Amount ,Vat ,ChkOutServiceLT ,
	ServiceTax ,Cess ,HECess ,ChkOutServiceNetAmount ,ServiceNetAmt ,Address ,VATPer ,Food ,Laundry ,
	Service ,Miscellaneous  ,MiscellaneousRemarks  ,ServiceFB ,
	ServiceOT ,OtherService , ChkOutServiceST ,CessService ,HECess2 ,CINNo ,InVoicedate,AmtWords from #Prop2
	group by GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,Id,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax1 ,Cess1 ,HCess1 ,ServiceCharge ,
	ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Invoice ,Cheque ,TaxNo ,ServiceTaxNo,
	Taxablename ,BrandName,Amount ,Vat ,ChkOutServiceLT ,
	ServiceTax ,Cess ,HECess ,ChkOutServiceNetAmount ,ServiceNetAmt ,Address ,VATPer ,Food ,Laundry ,
	Service ,Miscellaneous  ,MiscellaneousRemarks  ,ServiceFB ,
	ServiceOT ,OtherService , ChkOutServiceST ,CessService ,HECess2 ,CINNo ,InVoicedate,AmtWords
   
	
	END
	
END


--select * from WRBHBCheckOutServiceHdr
--select * from WRBHBCheckOutServiceDtls

--truncate table WRBHBCheckOutServiceHdr