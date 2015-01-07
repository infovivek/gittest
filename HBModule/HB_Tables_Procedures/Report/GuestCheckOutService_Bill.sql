-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_GuestCheckOutService_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_GuestCheckOutService_Bill]
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
CREATE PROCEDURE [dbo].[SP_GuestCheckOutService_Bill]
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
	
	SELECT  h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,
	convert(nvarchar(100),h.BillDate,103) as BillDate,
	h.ClientName,h.Id,h.InVoiceNo,
	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
	h.ChkOutTariffST2 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,
	h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),
	d.ArrivalDate,103) as ArrivalDate,
	d.Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as CompanyAddress,
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	and should be crossed A/C PAYEE ONLY.' as Cheque,
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,
	'PAN NO :'+@PanCardNo+'   |   '+'TIN :'+ t.TINNumber +'   |   '+'L Tax No :'+ t.LuxuryNo+'  |  '
	 +'CIN No:'+t.CINNumber as TaxNo,
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
    'Rupees : '+dbo.fn_NtoWord(ROUND(SUM(CS.ChkOutServiceNetAmount),0),'','') AS AmtWords
	
	from  WRBHBCheckInHdr d
	 join WRBHBChechkOutHdr h on h.ChkInHdrId = d.Id and d.IsActive = 1 and d.IsDeleted = 0
	join WRBHBCheckOutServiceHdr CS on h.Id = cs.CheckOutHdrId and CS.IsActive = 1 and CS.IsDeleted= 0
	--join WRBHBCheckOutServiceDtls CSD on cs.Id = csd.CheckOutServceHdrId and CSD.IsActive = 1 and CSD.IsDeleted = 0
	
	join WRBHBProperty p on d.PropertyId = p.Id and p.IsActive = 1 and p.IsDeleted = 0
	join WRBHBState s on s.Id=p.StateId
	 join WRBHBCity c on c.Id=p.CityId 
	join WRBHBBooking b on b.Id = d.BookingId	
	join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 and CS.CheckOutHdrId =  @Id1
	GROUP BY h.GuestName ,h.Name,h.Stay,h.Type,h.BookingLevel,
	BillDate,h.ClientName,h.Id,	h.ChkOutTariffTotal ,h.ChkOutTariffLT ,h.ChkOutTariffNetAmount,
	h.ChkOutTariffST2 ,h.ChkOutTariffST3 ,h.ChkOutTariffCess ,
	h.ChkOutTariffHECess ,h.ChkOutTariffSC,h.CheckInDate,d.Tariff,p.PropertyName,p.Propertaddress,
	c.CityName,s.StateName,p.Postal,p.Phone,p.Email,	
    H.VATPer,h.RestaurantSTPer ,
    h.BusinessSupportST ,h.InVoiceNo,h.BillFromDate,h.BillEndDate,t.LuxuryNo,d.ArrivalDate,
    t.TINNumber,t.CINNumber--,CS.ChkOutServiceNetAmount
   
	
	END
	
END


--select * from WRBHBCheckOutServiceHdr
--select * from WRBHBCheckOutServiceDtls

--truncate table WRBHBCheckOutServiceHdr