-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_ExtCheckOutConsolidate_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_ExtCheckOutConsolidate_Bill]
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
CREATE PROCEDURE [dbo].[SP_ExtCheckOutConsolidate_Bill]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='PageLoad'
	BEGIN
	
	Declare @ProType nvarchar(100);
	set @ProType = (select top 1 PropertyType from WRBHBChechkOutHdr where Id = @Id1 and 
	IsActive = 1 and IsDeleted = 0)
 
 
 
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@PanCardNo VARCHAR(100),
	@ServiceTaxNo VARCHAR(100),@LOGO VARCHAR(MAX),@LuxuryTax NVARCHAR(100),
	@TariffAmount DECIMAL(27,2),@ClientAddress NVARCHAR(500),@ClientId BIGINT,
	@Miscellaneous DECIMAL(27,2),@MiscellaneousRemarks NVARCHAR(100),@Food DECIMAL(27,2),
	@Laundry DECIMAL(27,2),@Service DECIMAL(27,2);
 
	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
	SET @PanCardNo =(SELECT PanCardNo FROM WRBHBCompanyMaster)
	SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
	
	SELECT @ClientId=I.ClientId  FROM WRBHBChechkOutHdr H
	JOIN WRBHBBooking I WITH(NOLOCK) ON I.Id=H.BookingId
	WHERE H.Id=@Id1
    SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
	WHERE H.Id=@ClientId
	
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
    
    SELECT @MiscellaneousRemarks=MiscellaneousRemarks 
    FROM dbo.WRBHBCheckOutServiceHdr H
    WHERE H.CheckOutHdrId=@Id1 AND H.IsActive=1 AND H.IsDeleted=0
    
	CREATE TABLE #Prop3(GuestName NVARCHAR(MAX),Name NVARCHAR(MAX),Stay NVARCHAR(MAX),Type NVARCHAR(MAX),
	BookingLevel NVARCHAR(MAX),BillDate NVARCHAR(MAX),ClientName NVARCHAR(MAX),NoOfDays INT, InVoiceNo NVARCHAR(MAX),
	ChkOutTariffNetAmount DECIMAL(27,2),TotalTariff DECIMAL(27,2),ServiceAmount DECIMAL(27,2),
	LuxuryTax DECIMAL(27,2),SerivceNet DECIMAL(27,2),ServiTarFood DECIMAL(27,2), 
	ServiceCharge DECIMAL(27,2), Vat1 DECIMAL(27,2),SerivceTax DECIMAL(27,2),Cess DECIMAL(27,2),
	HCess DECIMAL(27,2),ArrivalDate NVARCHAR(MAX),Tariff DECIMAL(27,2),Propertyaddress NVARCHAR(MAX),
	Propcity NVARCHAR(MAX),CityName NVARCHAR(MAX),StateName NVARCHAR(MAX), Postal NVARCHAR(MAX),Phone NVARCHAR(MAX),
	Email NVARCHAR(MAX),ChkOutServiceLT  DECIMAL(27,2),ServiceTax1  DECIMAL(27,2),ChkOutServiceNetAmount  DECIMAL(27,2),
	Amount  DECIMAL(27,2),ServiceNetAmt  DECIMAL(27,2),Vat DECIMAL(27,2),CompanyName NVARCHAR(MAX),
	PanCardNo NVARCHAR(MAX),logo NVARCHAR(MAX),ChkinDT NVARCHAR(100),ChkoutDT NVARCHAR(MAX),
	CompanyAddress NVARCHAR(MAX),Invoice NVARCHAR(MAX),Cheque NVARCHAR(MAX),Latepay NVARCHAR(MAX),TaxNo NVARCHAR(MAX),
	ServiceTaxNo NVARCHAR(MAX),Taxablename NVARCHAR(MAX),BillAmount DECIMAL(27,2),Address NVARCHAR(MAX),
	LTPer NVARCHAR(MAX),STPer NVARCHAR(MAX),VATPer NVARCHAR(MAX),Food DECIMAL(27,2),
	Laundry DECIMAL(27,2),Service DECIMAL(27,2) ,Miscellaneous  DECIMAL(27,2),MiscellaneousRemarks  NVARCHAR(MAX),
	ServiceFB NVARCHAR(MAX),ServiceOT NVARCHAR(MAX),OtherService DECIMAL(27,2),ChkOutServiceST  DECIMAL(27,2),
	CessService  DECIMAL(27,2),HECess1 DECIMAL(27,2),ExtraMatress  DECIMAL(27,2),CINNo NVARCHAR(MAX),
	InVoicedate NVARCHAR(MAX),AmtWords NVARCHAR(MAX),
	LTAgreed DECIMAL(27,2),LTRack DECIMAL(27,2),STAgreed DECIMAL(27,2),STRack DECIMAL(27,2))
	
	INSERT INTO #Prop3(GuestName ,Name ,Stay ,Type ,
	BookingLevel ,BillDate ,ClientName ,NoOfDays , InVoiceNo ,
	ChkOutTariffNetAmount ,TotalTariff ,ServiceAmount ,	LuxuryTax ,SerivceNet ,ServiTarFood , 
	ServiceCharge , Vat1 ,SerivceTax ,Cess ,HCess ,ArrivalDate ,Tariff ,Propertyaddress ,
	Propcity ,CityName ,StateName , Postal ,Phone ,Email ,ChkOutServiceLT,ServiceTax1  ,ChkOutServiceNetAmount,
	Amount,ServiceNetAmt,Vat ,CompanyName ,PanCardNo ,logo ,ChkinDT ,ChkoutDT ,
	CompanyAddress ,Invoice ,Cheque ,Latepay ,TaxNo ,
	ServiceTaxNo ,Taxablename ,BillAmount ,Address ,LTPer ,STPer ,VATPer ,Food ,
	Laundry ,Service  ,Miscellaneous ,MiscellaneousRemarks  ,
	ServiceFB ,ServiceOT ,OtherService ,ChkOutServiceST ,CessService ,HECess1 ,ExtraMatress ,CINNo ,
	InVoicedate,AmtWords,LTAgreed,LTRack,STAgreed,STRack) 
	
    select h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
    convert(nvarchar(100),h.BillDate,103) as BillDate,h.ClientName,h.NoOfDays,h.InVoiceNo,
	isnull(h.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,
	(ISNULL(h.ChkOutTariffTotal,0)) as TotalTariff,
	--(ISNULL(h.ChkOutTariffTotal,0)+ISNULL(h.LTAgreedAmount,0)+ISNULL(LTRackAmount,0)+ISNULL(STAgreedAmount,0)+ISNULL(STRackAmount,0)) as TotalTariff,
	sum(cs.ChkOutServiceAmtl) as ServiceAmount,
	h.ChkOutTariffLT as LuxuryTax,
	isnull(h.ChkOutTariffST1,0) as SerivceNet,
	(isnull(h.ChkOutTariffST2,0)+sum(isnull(cs.ChkOutServiceST,0))) as ServiTarFood,
	h.ChkOutTariffSC as ServiceCharge,
	sum(cs.ChkOutServiceVat) as Vat,h.ChkOutTariffST3 as SerivceTax,
	(h.ChkOutTariffCess+sum(cs.Cess)) as Cess,
	(h.ChkOutTariffHECess+sum(cs.HECess)) as HCess,--CSDD.BillAmount,
	convert(nvarchar(100),h.CheckInDate,103) as ArrivalDate,
	(round(h.ChkOutTariffTotal,0)/h.NoOfDays) AS Tariff,
	--(round(d.Tariff,0)+(h.LTAgreedAmount/h.NoOfDays)+(h.LTRackAmount/h.NoOfDays)+(h.STAgreedAmount/h.NoOfDays)+(h.STRackAmount/h.NoOfDays)) Tariff,
	(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,
	p.Phone,p.Email,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,sum(cs.ChkOutServiceAmtl) as Amount,	
	sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,sum(cs.ChkOutServiceVat) as Vat,
	@CompanyName as CompanyName,'PAN NO :'+@PanCardNo AS PanCardNo,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0) as BillAmount,
	--round((round(isnull(h.ChkOutTariffTotal,0),0)+round(isnull(ChkOutTariffExtraAmount,0),0)+round(isnull(@Food,0),0)+
	--round(isnull(@Laundry,0),0)+round(isnull(@Service,0),0)+round(isnull(@Miscellaneous,0),0)+round(isnull(h.ChkOutTariffLT,0),0)+
	--round(isnull(h.ChkOutTariffST1,0),0)+round(isnull(h.ChkOutTariffSC,0),0)+round(sum(CS.ChkOutServiceST),0)+round(sum(CS.OtherService),0)+
	--(round (isnull(h.ChkOutTariffST3,0),0)+round(isnull(h.ChkOutTariffCess,0),0)+round(sum(cs.Cess),0))+
	--(round(isnull(h.ChkOutTariffHECess,0),0)+round(sum(cs.HECess),0)+round(sum(cs.ChkOutServiceVat),0))),0) as 	BillAmount,
	@ClientAddress as Address,
	'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	 'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
	 ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,
    sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,
    sum(CS.HECess) HECess,h.ChkOutTariffExtraAmount ExtraMatress,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0),'','') AS AmtWords,
    h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount
    
	--CSDD.BillAmount
	
	
	from WRBHBChechkOutHdr h 
	join  WRBHBCheckInHdr d on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	
	
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId
	  --join WRBHBCheckOutSettleHdr CSS on h.Id = CSS.ChkOutHdrId and CSS.IsActive = 1 and CSS.IsDeleted = 0
	--join WRBHBCheckOutSettleDtl CSDD on CSS.Id = CSDD.CheckOutSettleHdrId and csdd.CheckOutSettleHdrId=h.id  
	--CSDD.IsActive = 1 and CSDD.IsDeleted = 0
	 left outer join WRBHBProperty p on d.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	 join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
	-- join WRBHBTaxMaster t on t.StateId=s.Id 
	--join WRBHBBooking b on b.Id = d.BookingId
	left outer join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and cs.IsDeleted = 0
	
	where h.IsActive = 1 and h.IsDeleted = 0
	--and CSDD.BillType ='Consolidated'
	 and h.Id = @Id1 and  h.PropertyType IN ('External Property','CPP')
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.PropertyName,p.Propertaddress,
	c.CityName,s.StateName,p.Postal,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST,h.ChkOutTariffST1 ,H.LuxuryTaxPer,H.ServiceTaxPer,h.ChkOutTariffExtraAmount,
    h.InVoiceNo,h.NoOfDays,h.BillFromDate,h.BillEndDate,h.CreatedDate,h.LTAgreedAmount,
    h.LTRackAmount,h.STAgreedAmount,h.STRackAmount--,t.LuxuryNo
    
-- MGH
	INSERT INTO #Prop3(GuestName ,Name ,Stay ,Type ,
	BookingLevel ,BillDate ,ClientName ,NoOfDays , InVoiceNo ,
	ChkOutTariffNetAmount ,TotalTariff ,ServiceAmount ,	LuxuryTax ,SerivceNet ,ServiTarFood , 
	ServiceCharge , Vat1 ,SerivceTax ,Cess ,HCess ,ArrivalDate ,Tariff ,Propertyaddress ,
	Propcity ,CityName ,StateName , Postal ,Phone ,Email ,ChkOutServiceLT,ServiceTax1  ,ChkOutServiceNetAmount,
	Amount,ServiceNetAmt,Vat ,CompanyName ,PanCardNo ,logo ,ChkinDT ,ChkoutDT ,
	CompanyAddress ,Invoice ,Cheque ,Latepay ,TaxNo ,
	ServiceTaxNo ,Taxablename ,BillAmount ,Address ,LTPer ,STPer ,VATPer ,Food ,
	Laundry ,Service  ,Miscellaneous ,MiscellaneousRemarks  ,
	ServiceFB ,ServiceOT ,OtherService ,ChkOutServiceST ,CessService ,HECess1 ,ExtraMatress ,CINNo ,
	InVoicedate ,AmtWords, LTAgreed,LTRack,STAgreed,STRack)   
	
    select h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
    convert(nvarchar(100),h.BillDate,103) as BillDate,h.ClientName,h.NoOfDays,h.InVoiceNo,
	isnull(h.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,
	h.ChkOutTariffTotal as TotalTariff,sum(cs.ChkOutServiceAmtl) as ServiceAmount,
	h.ChkOutTariffLT as LuxuryTax,
	isnull(h.ChkOutTariffST1,0) as SerivceNet,
	(isnull(h.ChkOutTariffST2,0)+sum(isnull(cs.ChkOutServiceST,0))) as ServiTarFood,
	h.ChkOutTariffSC as ServiceCharge,
	sum(cs.ChkOutServiceVat) as Vat,h.ChkOutTariffST3 as SerivceTax,
	(h.ChkOutTariffCess+sum(cs.Cess)) as Cess,
	(h.ChkOutTariffHECess+sum(cs.HECess)) as HCess,--CSDD.BillAmount,
	convert(nvarchar(100),h.CheckInDate,103) as ArrivalDate,
	ROUND (d.Tariff,0) Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,
	p.Phone,p.Email,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,sum(cs.ChkOutServiceAmtl) as Amount,	
	sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,sum(cs.ChkOutServiceVat) as Vat,
	@CompanyName as CompanyName,'PAN NO :'+@PanCardNo AS PanCardNo,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0) as BillAmount,
	--round((round(isnull(h.ChkOutTariffTotal,0),0)+round(isnull(ChkOutTariffExtraAmount,0),0)+round(isnull(@Food,0),0)+
	--round(isnull(@Laundry,0),0)+round(isnull(@Service,0),0)+round(isnull(@Miscellaneous,0),0)+round(isnull(h.ChkOutTariffLT,0),0)+
	--round(isnull(h.ChkOutTariffST1,0),0)+round(isnull(h.ChkOutTariffSC,0),0)+round(sum(CS.ChkOutServiceST),0)+round(sum(CS.OtherService),0)+
	--(round (isnull(h.ChkOutTariffST3,0),0)+round(isnull(h.ChkOutTariffCess,0),0)+round(sum(cs.Cess),0))+
	--(round(isnull(h.ChkOutTariffHECess,0),0)+round(sum(cs.HECess),0)+round(sum(cs.ChkOutServiceVat),0))),0) as 	BillAmount,
	@ClientAddress as Address,
	'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	 'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
	 ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,
    sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,
    sum(CS.HECess) HECess,h.ChkOutTariffExtraAmount ExtraMatress,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0),'','') AS AmtWords,
    h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount
    
    
	--CSDD.BillAmount
	
	
	from WRBHBChechkOutHdr h 
	join  WRBHBCheckInHdr d on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	
	
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId
	  --join WRBHBCheckOutSettleHdr CSS on h.Id = CSS.ChkOutHdrId and CSS.IsActive = 1 and CSS.IsDeleted = 0
	--join WRBHBCheckOutSettleDtl CSDD on CSS.Id = CSDD.CheckOutSettleHdrId and csdd.CheckOutSettleHdrId=h.id  
	--CSDD.IsActive = 1 and CSDD.IsDeleted = 0
	 left outer join WRBHBProperty p on d.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	 join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
	-- join WRBHBTaxMaster t on t.StateId=s.Id 
	--join WRBHBBooking b on b.Id = d.BookingId
	left outer join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and cs.IsDeleted = 0
	
	where h.IsActive = 1 and h.IsDeleted = 0
	--and CSDD.BillType ='Consolidated'
	 and h.Id = @Id1 and  h.PropertyType in ('Managed G H','DdP')
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.PropertyName,p.Propertaddress,
	c.CityName,s.StateName,p.Postal,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST,h.ChkOutTariffST1 ,H.LuxuryTaxPer,H.ServiceTaxPer,h.ChkOutTariffExtraAmount,
    h.InVoiceNo,h.NoOfDays,h.BillFromDate,h.BillEndDate,h.CreatedDate,
    h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount--,t.LuxuryNo

-- MMT    
    
    INSERT INTO #Prop3(GuestName ,Name ,Stay ,Type ,
	BookingLevel ,BillDate ,ClientName ,NoOfDays , InVoiceNo ,
	ChkOutTariffNetAmount ,TotalTariff ,ServiceAmount ,	LuxuryTax ,SerivceNet ,ServiTarFood , 
	ServiceCharge , Vat1 ,SerivceTax ,Cess ,HCess ,ArrivalDate ,Tariff ,Propertyaddress ,
	Propcity ,CityName ,StateName , Postal ,Phone ,Email ,ChkOutServiceLT,ServiceTax1  ,ChkOutServiceNetAmount,
	Amount,ServiceNetAmt,Vat ,CompanyName ,PanCardNo ,logo ,ChkinDT ,ChkoutDT ,
	CompanyAddress ,Invoice ,Cheque ,Latepay ,TaxNo ,
	ServiceTaxNo ,Taxablename ,BillAmount ,Address ,LTPer ,STPer ,VATPer ,Food ,
	Laundry ,Service  ,Miscellaneous ,MiscellaneousRemarks  ,
	ServiceFB ,ServiceOT ,OtherService ,ChkOutServiceST ,CessService ,HECess1 ,ExtraMatress ,CINNo ,
	InVoicedate ,AmtWords, LTAgreed,LTRack,STAgreed,STRack)   
	
    select h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
    convert(nvarchar(100),h.BillDate,103) as BillDate,h.ClientName,h.NoOfDays,h.InVoiceNo,
	isnull(h.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,
	h.ChkOutTariffTotal as TotalTariff,sum(cs.ChkOutServiceAmtl) as ServiceAmount,
	h.ChkOutTariffLT as LuxuryTax,
	isnull(h.ChkOutTariffST1,0) as SerivceNet,
	(isnull(h.ChkOutTariffST2,0)+sum(isnull(cs.ChkOutServiceST,0))) as ServiTarFood,
	h.ChkOutTariffSC as ServiceCharge,
	sum(cs.ChkOutServiceVat) as Vat,h.ChkOutTariffST3 as SerivceTax,
	(h.ChkOutTariffCess+sum(cs.Cess)) as Cess,
	(h.ChkOutTariffHECess+sum(cs.HECess)) as HCess,--CSDD.BillAmount,
	convert(nvarchar(100),h.CheckInDate,103) as ArrivalDate,
	ROUND (d.Tariff,0) Tariff,(p.HotalName+','+p.Line1) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Pincode) as Propcity,c.CityName,s.StateName,p.Pincode,
	p.Phone,p.Email,
	sum(cs.ChkOutServiceLT) ChkOutServiceLT,sum(cs.ChkOutServiceST) as ServiceTax,
	sum(Cs.ChkOutServiceNetAmount) ChkOutServiceNetAmount,sum(cs.ChkOutServiceAmtl) as Amount,	
	sum(CS.ChkOutServiceNetAmount) as ServiceNetAmt,sum(cs.ChkOutServiceVat) as Vat,
	@CompanyName as CompanyName,'PAN NO :'+@PanCardNo AS PanCardNo,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,
	round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0) as BillAmount,
	--round((round(isnull(h.ChkOutTariffTotal,0),0)+round(isnull(ChkOutTariffExtraAmount,0),0)+round(isnull(@Food,0),0)+
	--round(isnull(@Laundry,0),0)+round(isnull(@Service,0),0)+round(isnull(@Miscellaneous,0),0)+round(isnull(h.ChkOutTariffLT,0),0)+
	--round(isnull(h.ChkOutTariffST1,0),0)+round(isnull(h.ChkOutTariffSC,0),0)+round(sum(CS.ChkOutServiceST),0)+round(sum(CS.OtherService),0)+
	--(round (isnull(h.ChkOutTariffST3,0),0)+round(isnull(h.ChkOutTariffCess,0),0)+round(sum(cs.Cess),0))+
	--(round(isnull(h.ChkOutTariffHECess,0),0)+round(sum(cs.HECess),0)+round(sum(cs.ChkOutServiceVat),0))),0) as 	BillAmount,
	@ClientAddress as Address,
	'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	 'VAT @'+CAST(H.VATPer AS NVARCHAR(100))+'%' VATPer,
	 ISNULL(@Food,0) AS Food,ISNULL(@Laundry,0) Laundry,ISNULL(@Service,0) Service,
    ISNULL(@Miscellaneous,0) Miscellaneous,'Miscellaneous - '+@MiscellaneousRemarks MiscellaneousRemarks,
    'Service Tax @'+CAST(h.RestaurantSTPer  AS NVARCHAR)+'% on Food and Beverages' ServiceFB,
    'Service Tax @'+CAST(h.BusinessSupportST AS NVARCHAR)+'% on Others' ServiceOT,
    sum(CS.OtherService) OtherService,
    sum(CS.ChkOutServiceST) ChkOutServiceST,sum(CS.Cess) CessService,
    sum(CS.HECess) HECess,h.ChkOutTariffExtraAmount ExtraMatress,
    'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
    'Rupees : '+dbo.fn_NtoWord(round((isnull(h.ChkOutTariffNetAmount+sum(CS.ChkOutServiceNetAmount),0)),0),'','') AS AmtWords,
    h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount
    
    
	--CSDD.BillAmount
	
	
	from WRBHBChechkOutHdr h 
	join  WRBHBCheckInHdr d on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	
	
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId
	  --join WRBHBCheckOutSettleHdr CSS on h.Id = CSS.ChkOutHdrId and CSS.IsActive = 1 and CSS.IsDeleted = 0
	--join WRBHBCheckOutSettleDtl CSDD on CSS.Id = CSDD.CheckOutSettleHdrId and csdd.CheckOutSettleHdrId=h.id  
	--CSDD.IsActive = 1 and CSDD.IsDeleted = 0
	 left outer join WRBHBStaticHotels p on h.PropertyId = p.HotalId and p.IsActive = 1 and p.IsDeleted = 0
	 join WRBHBState s on s.Id=h.StateId
	 join WRBHBCity c on c.Id=h.CityId 
	-- join WRBHBTaxMaster t on t.StateId=s.Id 
	--join WRBHBBooking b on b.Id = d.BookingId
	left outer join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and cs.IsDeleted = 0
	
	where h.IsActive = 1 and h.IsDeleted = 0
	--and CSDD.BillType ='Consolidated'
	 and h.Id = @Id1 and  h.PropertyType = 'MMT'
	group by h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.HotalName,p.Line1,
	c.CityName,s.StateName,p.Pincode,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST,h.ChkOutTariffST1 ,H.LuxuryTaxPer,H.ServiceTaxPer,h.ChkOutTariffExtraAmount,
    h.InVoiceNo,h.NoOfDays,h.BillFromDate,h.BillEndDate,h.CreatedDate,
    h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount--,t.LuxuryNo    
    
    
    SELECT GuestName ,Name ,Stay ,Type ,
	BookingLevel ,BillDate ,ClientName ,NoOfDays , InVoiceNo ,
	ChkOutTariffNetAmount ,TotalTariff ,ServiceAmount ,	LuxuryTax ,SerivceNet ,ServiTarFood , 
	ServiceCharge , Vat1 ,SerivceTax ,Cess ,HCess ,ArrivalDate ,Tariff ,Propertyaddress ,
	Propcity ,CityName ,StateName , Postal ,Phone ,Email ,ChkOutServiceLT,ServiceTax1  ,ChkOutServiceNetAmount,
	Amount,ServiceNetAmt,Vat ,CompanyName ,PanCardNo ,logo ,ChkinDT ,ChkoutDT ,
	CompanyAddress ,Invoice ,Cheque ,Latepay ,TaxNo ,
	ServiceTaxNo ,Taxablename ,BillAmount ,Address ,LTPer ,STPer ,VATPer ,Food ,
	Laundry ,Service  ,Miscellaneous ,MiscellaneousRemarks  ,
	ServiceFB ,ServiceOT ,OtherService ,ChkOutServiceST ,CessService ,HECess1 ,ExtraMatress ,CINNo ,
	InVoicedate,AmtWords , LTAgreed,LTRack,STAgreed,STRack   FROM #Prop3
    group by GuestName ,Name ,Stay ,Type ,
	BookingLevel ,BillDate ,ClientName ,NoOfDays , InVoiceNo ,
	ChkOutTariffNetAmount ,TotalTariff ,ServiceAmount ,	LuxuryTax ,SerivceNet ,ServiTarFood , 
	ServiceCharge , Vat1 ,SerivceTax ,Cess ,HCess ,ArrivalDate ,Tariff ,Propertyaddress ,
	Propcity ,CityName ,StateName , Postal ,Phone ,Email ,ChkOutServiceLT,ServiceTax1  ,ChkOutServiceNetAmount,
	Amount,ServiceNetAmt,Vat ,CompanyName ,PanCardNo ,logo ,ChkinDT ,ChkoutDT ,
	CompanyAddress ,Invoice ,Cheque ,Latepay ,TaxNo ,
	ServiceTaxNo ,Taxablename ,BillAmount ,Address ,LTPer ,STPer ,VATPer ,Food ,
	Laundry ,Service  ,Miscellaneous ,MiscellaneousRemarks  ,
	ServiceFB ,ServiceOT ,OtherService ,ChkOutServiceST ,CessService ,HECess1 ,ExtraMatress ,CINNo ,
	InVoicedate,AmtWords, LTAgreed,LTRack,STAgreed,STRack
    
	END
	
END


--select * from WRBHBCheckOutServiceHdr
--select * from WRBHBCheckOutServiceDtls

-- exec SP_GuestCheckOutConsolidate_Bill @Action=N'PAGELOAD',@Str1=N'',@Str2=N'',@Id1=25,@Id2=0
--exec SP_ExtCheckOutConsolidate_Bill @Action=N'PAGELOAD',@Str1=N'',@Str2=N'External Property',@Id1=2572,@Id2=0