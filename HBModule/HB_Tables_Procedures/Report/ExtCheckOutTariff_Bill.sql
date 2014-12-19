-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_ExtCheckOutTariff_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_ExtCheckOutTariff_Bill]
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
CREATE PROCEDURE [dbo].[SP_ExtCheckOutTariff_Bill]
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
	
	-- Company master
	--select LegalCompanyName as CompanyName,CompanyShortName,('Regd office :'+Address+'.'+'www.Hummingbirdindia.com') as Address,
	--City,State,ImageName,Email,PanCardNo,Logo,
	--'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	--'CHEQUE : All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd 
	--and should be crossed A/C PAYEE ONLY.' as Cheque,
	--'LATE PAYMENT : Interest @18 per annum will be charged on all outstanding bill after due date.' as Latepay 
	
	--from WRBHBCompanyMaster  
	--where IsActive = 1 and IsDeleted = 0
	
--	 Tariff Bill
	
	--select h.GuestName as GuestName,h.Name,h.Stay,h.Type,h.BookingLevel,convert(nvarchar(100),h.BillDate,103) as BillDate,
	--h.ClientName,
	--h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,h.ChkOutTariffNetAmount as NetAmount,
	--h.ChkOutTariffST1 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,
	--h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,convert(nvarchar(100),d.ArrivalDate,103) as ArrivalDate,
	--d.Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(p.City+','+
	--p.State+','+p.Postal) as Propcity,p.City,p.State,p.Postal,
	--p.Phone,p.Email
	--,'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com' as Address,
	--'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,
	--'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.
	--and should be crossed A/C PAYEE ONLY.' as Cheque,
	--'LATE PAYMENT : Interest @18 per annum will be charged on all outstanding bill after due date.' as Latepay ,
	--'Hummingbird Travel and Stay Pvt Ltd.' as CompanyName,'PAN NO : AABCH 5874 R' as PanCardNo,'L Tax No : L00100571' as TaxNo,
	--'TIN : 29340489869' as Tin,'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	--'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename
	
	--from WRBHBChechkOutHdr h
	--join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id
	--join WRBHBProperty p on d.PropertyId = p.Id
	
	--where h.IsActive = 1 and h.IsDeleted = 0
	--and 
	--h.Id = @Id1
	Declare @ProType nvarchar(100);
	set @ProType = (select top 1 PropertyType from WRBHBChechkOutHdr where Id = @Id1 and IsActive = 1 and IsDeleted = 0)
	
	
	
	
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@PanCardNo VARCHAR(100),  
	@ServiceTaxNo VARCHAR(100),@LOGO VARCHAR(MAX),@LuxuryTax NVARCHAR(100),
	@TariffAmount DECIMAL(27,2),@ClientAddress NVARCHAR(500),@ClientId BIGINT;  

	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)  
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)  
	SET @PanCardNo =(SELECT PanCardNo FROM WRBHBCompanyMaster)  
	SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
	
	SELECT @ClientId=I.ClientId  FROM WRBHBChechkOutHdr H
	JOIN WRBHBBooking I WITH(NOLOCK) ON I.Id=H.BookingId
	WHERE H.Id=@Id1
    SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
	WHERE H.Id=@ClientId
    
	CREATE TABLE #Prop1(GuestName NVARCHAR(100),Name NVARCHAR(100),Stay NVARCHAR(100),Type NVARCHAR(MAX),
	BookingLevel NVARCHAR(100),BillDate NVARCHAR(100),ClientName NVARCHAR(100),CheckOutNo NVARCHAR(MAX), InVoiceNo NVARCHAR(100),
	TotalTariff DECIMAL(27,2),LuxuryTax DECIMAL(27,2),NetAmount DECIMAL(27,2),SerivceNet DECIMAL(27,2),
	SerivceTax DECIMAL(27,2),Cess DECIMAL(27,2),NoOfDays INT,HCess DECIMAL(27,2),ServiceCharge DECIMAL(27,2),
	ExtraMatress DECIMAL(27,2),ArrivalDate NVARCHAR(100),Tariff DECIMAL(27,2),Propertyaddress NVARCHAR(MAX),
	Propcity NVARCHAR(MAX),CityName NVARCHAR(MAX),StateName NVARCHAR(MAX), Postal NVARCHAR(MAX),Phone NVARCHAR(MAX),
	Email NVARCHAR(MAX),CompanyName NVARCHAR(MAX),logo NVARCHAR(MAX),ChkinDT NVARCHAR(MAX),ChkoutDT NVARCHAR(MAX),
	CompanyAddress NVARCHAR(MAX),Address NVARCHAR(MAX),Invoice NVARCHAR(MAX),Cheque NVARCHAR(MAX),TaxNo NVARCHAR(MAX),
	Latepay NVARCHAR(MAX),Tin NVARCHAR(100),Taxablename NVARCHAR(MAX),ServiceTaxNo NVARCHAR(MAX),LTPer NVARCHAR(MAX),
	STPer NVARCHAR(MAX),CINNo NVARCHAR(MAX), InVoicedate NVARCHAR(MAX),AmtWords NVARCHAR(MAX),
	LTAgreed DECIMAL(27,2),LTRack DECIMAL(27,2),STAgreed DECIMAL(27,2),STRack DECIMAL(27,2)) 
--'External Property'
	INSERT INTO #Prop1(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,CheckOutNo,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax ,Cess ,NoOfDays ,HCess ,ServiceCharge ,
	ExtraMatress ,ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Address ,Invoice ,Cheque ,TaxNo ,
	Latepay ,Tin ,Taxablename ,ServiceTaxNo ,LTPer ,STPer,
	CINNo , InVoicedate,AmtWords, LTAgreed,LTRack,STAgreed,STRack)   
     
    
    
	SELECT h.GuestName as GuestName,h.Name,h.Stay,h.Type,d.Type as BookingLevel,convert(nvarchar(100),h.CheckOutDate,103) as BillDate,  
	h.ClientName,h.CheckOutNo,h.InVoiceNo,  
	(ISNULL(h.ChkOutTariffTotal,0)) as TotalTariff,
	h.ChkOutTariffLT as LuxuryTax,round(h.ChkOutTariffNetAmount,0) as NetAmount,  
	h.ChkOutTariffST1 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,h.NoOfDays,  
	h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,h.ChkOutTariffExtraAmount as ExtraMatress,
	convert(nvarchar(100),d.ArrivalDate,103)as ArrivalDate,  
	(round(h.ChkOutTariffTotal,0)/h.NoOfDays) AS Tariff,
	--+(h.LTAgreedAmount/h.NoOfDays)+(h.LTRackAmount/h.NoOfDays)+(h.STAgreedAmount/h.NoOfDays)+(h.STRackAmount/h.NoOfDays)) Tariff,
	(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+  
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,  
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,  
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
	@ClientAddress as Address,  
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
	and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'  |  '
	+'CIN No: U72900KA2005PTC035942' as TaxNo,  
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
	'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
	'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
	'Rupees : '+dbo.fn_NtoWord(ROUND(h.ChkOutTariffNetAmount,0),'','') AS AmtWords,
	h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount

	from WRBHBChechkOutHdr h  
	join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id  
	join WRBHBProperty p on d.PropertyId = p.Id 
	join WRBHBState s on s.Id=p.StateId
	join WRBHBCity c on c.Id=p.CityId 
	join WRBHBBooking b on b.Id = d.BookingId 	
	-- join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 
	and   h.Id = @Id1  AND h.PropertyType IN('External Property','CPP')
	
	
-- 	'Managed G H'
	INSERT INTO #Prop1(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,CheckOutNo,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax ,Cess ,NoOfDays ,HCess ,ServiceCharge ,
	ExtraMatress ,ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Address ,Invoice ,Cheque ,TaxNo ,
	Latepay ,Tin ,Taxablename ,ServiceTaxNo ,LTPer ,STPer,
	CINNo , InVoicedate ,AmtWords, LTAgreed,LTRack,STAgreed,STRack)   
     
    
    
	SELECT h.GuestName as GuestName,h.Name,h.Stay,h.Type,d.Type as BookingLevel,convert(nvarchar(100),h.CheckOutDate,103) as BillDate,  
	h.ClientName,h.CheckOutNo,h.InVoiceNo,  
	h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,round(h.ChkOutTariffNetAmount,0) as NetAmount,  
	h.ChkOutTariffST1 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,h.NoOfDays,  
	h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,h.ChkOutTariffExtraAmount as ExtraMatress,
	convert(nvarchar(100),d.ArrivalDate,103)as ArrivalDate,  
	round(d.Tariff,0) Tariff,(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+  
	s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,  
	p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,  
	CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
	@ClientAddress as Address,  
	'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
	'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
	and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'  |  '
	+'CIN No: U72900KA2005PTC035942' as TaxNo,  
	'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
	'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
	'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
	'Rupees : '+dbo.fn_NtoWord(ROUND(h.ChkOutTariffNetAmount,0),'','') AS AmtWords,
	h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount

	from WRBHBChechkOutHdr h  
	join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id  
	join WRBHBProperty p on d.PropertyId = p.Id 
	join WRBHBState s on s.Id=p.StateId
	join WRBHBCity c on c.Id=p.CityId 
	join WRBHBBooking b on b.Id = d.BookingId 	
	-- join WRBHBTaxMaster t on t.StateId=s.Id   
	where h.IsActive = 1 and h.IsDeleted = 0 
	and   
	h.Id = @Id1  AND h.PropertyType = 'Managed G H'
 
--MMT	
	INSERT INTO #Prop1(GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,CheckOutNo,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax ,Cess ,NoOfDays ,HCess ,ServiceCharge ,
	ExtraMatress ,ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Address ,Invoice ,Cheque ,TaxNo ,
	Latepay ,Tin ,Taxablename ,ServiceTaxNo ,LTPer ,STPer,
	CINNo , InVoicedate,AmtWords , LTAgreed,LTRack,STAgreed,STRack) 
	
	
	select h.GuestName as GuestName,h.Name,h.Stay,h.Type,d.Type as BookingLevel,convert(nvarchar(100),h.CheckOutDate,103) as BillDate,  
	 h.ClientName,h.CheckOutNo,h.InVoiceNo,  
	 h.ChkOutTariffTotal as TotalTariff,h.ChkOutTariffLT as LuxuryTax,round(h.ChkOutTariffNetAmount,0) as NetAmount,  
	 h.ChkOutTariffST1 as SerivceNet,h.ChkOutTariffST3 as SerivceTax,h.ChkOutTariffCess as Cess,h.NoOfDays,  
	 h.ChkOutTariffHECess as HCess,h.ChkOutTariffSC as ServiceCharge,h.ChkOutTariffExtraAmount as ExtraMatress,
	 convert(nvarchar(100),d.ArrivalDate,103)as ArrivalDate,  
	 round(d.Tariff,0) Tariff,(p.HotalName+','+p.Line1) as Propertyaddress,(c.CityName+','+  
	 s.StateName+','+p.Pincode) as Propcity,c.CityName,s.StateName,p.Pincode,  
	 p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,  
	 CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
	 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
	 @ClientAddress as Address,  
	 'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
	 'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
	 and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'  |  '
	 +'CIN No: U72900KA2005PTC035942' as TaxNo,  
	 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
	 'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,'Luxury Tax @ '+CAST(H.LuxuryTaxPer AS NVARCHAR)+'%' LTPer,
	 'Service Tax @ '+CAST(H.ServiceTaxPer AS NVARCHAR)+'%' STPer,
	 'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
	 'Rupees : '+dbo.fn_NtoWord(ROUND(h.ChkOutTariffNetAmount,0),'','') AS AmtWords,
	 h.LTAgreedAmount,h.LTRackAmount,h.STAgreedAmount,h.STRackAmount
	   
	 from WRBHBChechkOutHdr h  
	 join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id  
	 join WRBHBStaticHotels p on d.PropertyId = p.HotalId 
	 join WRBHBState s on s.Id=h.StateId
	 join WRBHBCity c on c.Id=h.CityId 
	 join WRBHBBooking b on b.Id = d.BookingId 	
	-- join WRBHBTaxMaster t on t.StateId=s.Id   
	 where h.IsActive = 1 and h.IsDeleted = 0 
	 and   
	 h.Id = @Id1  AND h.PropertyType = 'MMT'
	
	
	SELECT GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,CheckOutNo,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax ,Cess ,NoOfDays ,HCess ,ServiceCharge ,
	ExtraMatress ,ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Address ,Invoice ,Cheque ,TaxNo ,
	Latepay ,Tin ,Taxablename ,ServiceTaxNo ,LTPer ,STPer,
	CINNo , InVoicedate,AmtWords, LTAgreed,LTRack,STAgreed,STRack from #Prop1 
	GROUP BY GuestName ,Name,Stay ,Type,BookingLevel ,BillDate ,ClientName ,CheckOutNo,InVoiceNo ,
	TotalTariff ,LuxuryTax ,NetAmount ,SerivceNet ,SerivceTax ,Cess ,NoOfDays ,HCess ,ServiceCharge ,
	ExtraMatress ,ArrivalDate ,Tariff ,Propertyaddress ,Propcity ,CityName ,StateName , Postal ,Phone ,
	Email ,CompanyName ,logo ,ChkinDT ,ChkoutDT ,CompanyAddress ,Address ,Invoice ,Cheque ,TaxNo ,
	Latepay ,Tin ,Taxablename ,ServiceTaxNo ,LTPer ,STPer,
	CINNo , InVoicedate,AmtWords, LTAgreed,LTRack,STAgreed,STRack
	
	
	
	
END
END



--exec SP_ExtCheckOutTariff_Bill @Action=N'PAGELOAD',@Str1=N'',@Str2=N'',@Id1=2169,@Id2=0