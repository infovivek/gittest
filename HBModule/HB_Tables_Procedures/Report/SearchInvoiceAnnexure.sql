SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_SearchInvoiceAnnexure_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_SearchInvoiceAnnexure_Help]
GO
/*=============================================
Author Name  :  
Created Date : 03/04/2014 
Section  	 :  
Purpose  	 :  
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_SearchInvoiceAnnexure_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
--@Str3 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL,
--@Id3 INT=NULL, 
@UserId INT=NULL
)
AS
BEGIN
IF @Action ='PAGELOAD'
   
 Begin
		Create Table #SepratebyComma(CheckoutId Bigint, Id int Primary Key identity(1,1))
		Create Table #Annuxer(InvoiceNumber NVARCHAR(500),BookingCode  NVARCHAR(100),Property NVARCHAR(500),
		ClientName NVARCHAR(500),CityName NVARCHAR(500),GuestNam NVARCHAR(500),CheckInDate NVARCHAR(500),
		CheckOutDate NVARCHAR(500),NoOfDays BIGINT,LT DECIMAL(27,2),ST DECIMAL(27,2),CEss DECIMAL(27,2),
		Hecess DECIMAL(27,2),NetAmt Decimal(27,2),selectRadio INT,ChkoutId BIGINT,PrtyId Bigint,
		STPerCent Decimal(27,2),LTPerCent Decimal(27,2))
 DECLARE @tmpstr VARCHAR(50), @Net decimal(27,2),@TotalAmt Decimal(27,2);
 DECLARE @Cnt int,@Chkid Bigint=0;Declare @BillType Nvarchar(100)=''
 
 Declare @St Decimal(27,2),@Lt Decimal(27,2)
  Declare @CEss Decimal(27,2),@HCess Decimal(27,2),@NDays Bigint
  declare @PanCardNo nvarchar(100);
  DEclare @LOGO  NVARCHAR(MAX);
  SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster where IsActive=1) 
  Create Table #NODays (NoDays Bigint,ChkoutId Bigint)
  Declare @TinNumber Nvarchar(100);
  Declare @CinNumber Nvarchar(100);
  Declare @Propcity  Nvarchar(100);
  Declare @prtyTye Nvarchar(100),@CkId Bigint;
if(@Str2='Tac')
Begin
DECLARE @id VARCHAR(MAX)

SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,'
 

WHILE CHARINDEX(',', @id) > 0 
BEGIN 
    
     SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

    INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
    SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id))
    --Select @id,@tmpstr
END 

--DECLARE @Cnt int,@Chkid Bigint=0;
   SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
   while @Cnt>0
   begin
          Set @Chkid=(Select top 1 CheckoutId from  #SepratebyComma
           order by Id desc )
           
            INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
			
			SELECT CT.TACInvoiceNo InvoiceNumber,B.BookingCode,P.PropertyName Property,C.ClientName AS ClientName,B.CityName,C.GuestName AS GuestName ,
			CT.CheckInDate as CheckInDate,CT.CheckOutDate AS CheckOutDate,
			c.NoOfDays,CT.MarkupAmount,CT.TotalBusinessSupportST as ST, 
			 ct.ChkOutTariffCess,ct.ChkOutTariffHECess,Round(CT.MarkupAmount+CT.TotalBusinessSupportST+ 
			 ct.ChkOutTariffCess+ct.ChkOutTariffHECess,0) NetAmt,0 as selectRadio ,C.Id as ChkoutId,P.Id,
			 Ct.BusinessSupportST,C.LuxuryTaxPer
			--,'CheckOut'Status,'TAC' as PropertyCat,'Tariff' BillType,Ct.Rate, 
			FROM WRBHBChechkOutHdr C 
			join WRBHBBooking B WITH(NOLOCK) on c.BookingId=B.Id and B.IsActive=1 and B.IsDeleted=0
			JOIN WRBHBExternalChechkOutTAC CT WITH(NOLOCK) ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 --and p.Category='Internal Property'
			WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' and CT.Id=50
			ORDER BY   c.id desc ;
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
Declare @NAmt Decimal(27,2);
Set @Net=(Select SUM(LT) from #Annuxer )
Set @BillType='Tac';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(ST) from #Annuxer)

Set @St=(Select SUM(ST) from #Annuxer)
 Set @Lt=(Select SUM(LT) from #Annuxer)
 Set @CEss=(Select SUM(cess) from #Annuxer)
 Set @HCess=(Select SUM(Hecess) from #Annuxer)
 Set @NDays=(Select SUM(NoOfDays) from #Annuxer)
 Set @NAmt=(Select Sum(NetAmt) from #Annuxer)
 Set @PanCardNo=(SELECT PanCardNo FROM WRBHBCompanyMaster where IsActive=1)
 Set @Propcity=(Select Top 1 CityName from #Annuxer) 
--Select @St,@Lt,@CEss,@HCess,@Net,@TotalAmt;
		Select Distinct CONVERT(Nvarchar(100),GETDATE(),103) as BillDate,InvoiceNumber,BookingCode BookingId,
		Property PropertyName,ClientName,CityName City,GuestNam GuestName,
		CheckInDate ChkInDt,CheckOutDate ChkOutDt,NoOfDays,CEss+Hecess Rate,st as TaxNo,
		Round(LT,0) Amount,Round(@lt,0) as TotalTariff,
		Round(NetAmt,0) TotalAmount,0 as selectRadio,ChkoutId,PrtyId,--@Net As Logo,
		'Rupees : '+dbo.fn_NtoWord(ROUND(@NAmt,0),'','') AS Name,
		Round(@TotalAmt,0) as TotalAmt,@NAmt as NetAmount,
		@CEss Cess,@HCess HCess,'0.00' LuxuryTax,@St SerivceTax,'0.00' as Vat,
		PrtyId ,p.Phone as Phone,@NDays as Stay,'TIN : 29340489869' as Tin,
		P.City City,p.Propertaddress Propertaddress,p.Postal,@Propcity Propcity,
		p.Email as Email,@BillType,@LOGO AS logo,'PAN NO : '+ @PanCardNo PanCardNo,
		isnull(STPerCent,0) STPerCent,isnull(LTPerCent,0) LTPerCent,'2.00'CessPercent,'1.00'HECessPercent,
		-- p.Phone,p.Email,@CompanyName as CompanyName,  
	 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
	 ''+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  ' +'CIN No: U72900KA2005PTC035942' as TaxNo,
	 'Please make the payment in favour of' AS Latepay ,'' AS LTPer,
	 'Humming Bird Travel & Stay Pvt Ltd.' AS ExtraMatress,
	 'Bank HSBC, Bangalore' AS Description , 'Account No  071358154001 (CA)' AS ServiceHCess ,
	 'IFSC Code HSBC0560002' AS ServiceCess, 'Taxable Category : Business Support Services ' as Taxablename,  
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	 'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate
		FROM #Annuxer A
		join WRBHBProperty p on p.Id=a.PrtyId and p.IsActive=1 
		group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.Propertaddress ,p.Postal,p.Email,
		InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId,
		STPerCent,LTPerCent
End


if(@Str2='External')
Begin
SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,' 

WHILE CHARINDEX(',', @id) > 0 
BEGIN 
  
    SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

    INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
    SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id)) 
END 


   SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
   while @Cnt>0
   begin
          Set @Chkid=(Select top 1 CheckoutId from  #SepratebyComma
           order by Id desc )
           
            INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,Cess,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
			
			SELECT  InVoiceNo InvoiceNumber,BookingCode,p.PropertyName+'-'+cc.CityName Property,
			F.ClientName ClientName,cc.CityName ,
			GuestName GuestName,f.CheckInDate CheckInDate,F.CheckOutDate CheckOutDate,F.NoOfDays,
			F.ChkOutTariffLT,F.ChkOutTariffST1,F.ChkOutTariffCess,F.ChkOutTariffHECess,
			Round(F.ChkOutTariffLT+F.ChkOutTariffST1+F.ChkOutTariffHECess+F.ChkOutTariffCess+f.ChkOutTariffTotal,0) as NetAmt, 
			--0 Rate, 0 St,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,--'Tariff' BillType,
			0 as selectRadio ,f.Id ChkoutId,P.Id,F.ServiceTaxPer,f.LuxuryTaxPer--,'CheckOut'Status,'External Property' as PropertyCat
			FROM WRBHBChechkOutHdr f
			JOIN WRBHBBooking  B WITH(NOLOCK) ON f.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			join WRBHBProperty p WITH(NOLOCK) on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category='External Property'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			where    InVoiceNo!='0' and  InVoiceNo!=''  and f.Id=@Chkid
			ORDER BY   f.Id desc  
			
		   INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,Cess,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
		
			SELECT  InVoiceNo InvoiceNumber,BookingCode,S.HotalName+'-'+cc.CityName Property,
			F.ClientName ClientName,cc.CityName ,
			GuestName GuestName,f.CheckInDate CheckInDate,F.CheckOutDate CheckOutDate,F.NoOfDays,
			F.ChkOutTariffLT,F.ChkOutTariffST1,F.ChkOutTariffCess,F.ChkOutTariffHECess,
			Round(F.ChkOutTariffLT+F.ChkOutTariffST1+F.ChkOutTariffHECess+F.ChkOutTariffCess+f.ChkOutTariffTotal,0) as NetAmt, 
			--0 Rate, 0 St,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,--'Tariff' BillType,
			0 as selectRadio ,f.Id ChkoutId,s.HotalId,F.ServiceTaxPer,f.LuxuryTaxPer--,'CheckOut'Status,'External Property' as PropertyCat
			FROM WRBHBChechkOutHdr f
			JOIN WRBHBBooking  B WITH(NOLOCK) ON f.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON f.PropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 and  F.PropertyType='MMT'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=f.CityId and cc.IsActive=1  
			where    InVoiceNo!='0' and  InVoiceNo!=''  and f.Id=@Chkid
			ORDER BY   f.Id desc  
			
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
  --Select * from #Annuxer
Set @Net=(Select SUM(NetAmt) from #Annuxer )
Set @BillType='External';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(LT)+SUM(ST) from #Annuxer)
Set @St=(Select SUM(ST) from #Annuxer)
 Set @Lt=(Select SUM(LT) from #Annuxer)
 Set @CEss=(Select SUM(cess) from #Annuxer)
 Set @HCess=(Select SUM(Hecess) from #Annuxer)
Set @Propcity=(Select Top 1 CityName from #Annuxer) 

Set @CkId=(Select top 1 ChkoutId from #Annuxer)
Set @prtyTye=(Select Top 1 PropertyType  from WRBHBChechkOutHdr where Id=@CkId)
 insert into #NODays(NoDays,ChkoutId)
 Select  (NoOfDays),ChkoutId  from #Annuxer 
 group by ChkoutId,NoOfDays
  Set @NDays=(Select Top 1 SUM(NoDays) from #NODays )
 --Select @St,@Lt,@CEss,@HCess,@Net,@TotalAmt,@NDays;
if(@prtyTye!='MMT')
BEGIN
			Select Distinct CONVERT(Nvarchar(100),GETDATE(),103) as BillDate,InvoiceNumber,BookingCode BookingId,
			Property PropertyName,ClientName,CityName City,GuestNam GuestName,
			CheckInDate ChkInDt,CheckOutDate ChkOutDt,NoOfDays,CEss+Hecess Rate,ST+LT as TaxNo,
			Round(NetAmt-(CEss+Hecess+ST+LT),0) Amount,Round(@TotalAmt,0) as TotalTariff,
			Round(NetAmt,0) TotalAmount,0 as selectRadio,ChkoutId,PrtyId,--@Net As Logo,
			'Rupees : '+dbo.fn_NtoWord(ROUND(@Net,0),'','') AS Name,Round(@TotalAmt,0) as TotalAmt,@Net as NetAmount,
			@CEss Cess,@HCess HCess,@Lt LuxuryTax,@St SerivceTax,0 as Vat,'2.00'CessPercent,'1.00'HECessPercent,
			PrtyId ,p.Phone as Phone,@NDays as Stay, P.City City,p.Propertaddress Propertaddress,p.Postal
			,p.Email as Email,@BillType,@LOGO AS logo,@Propcity Propcity,
			'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
			'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
			'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
			and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  '
			+'CIN No: U72900KA2005PTC035942' as CINNo,  
			'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
			'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
			'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
			isnull(STPerCent,0) STPerCent,isnull(LTPerCent,0) LTPerCent,
			--'Luxury Tax @ '+CAST(0 AS NVARCHAR)+'%' LTPer, 'Service Tax @ '+CAST(0 AS NVARCHAR)+'%' STPer,
			'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate
			FROM #Annuxer A
			join WRBHBProperty p on p.Id=a.PrtyId and p.IsActive=1 
			--where  @prtyTye!='MMT'
			group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.Propertaddress ,p.Postal,p.Email,
			InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId,
			STPerCent,LTPerCent 
	END
	Else
	BEGIN		
			Select Distinct CONVERT(Nvarchar(100),GETDATE(),103) as BillDate,InvoiceNumber,BookingCode BookingId,
			Property PropertyName,ClientName,CityName City,GuestNam GuestName,
			CheckInDate ChkInDt,CheckOutDate ChkOutDt,NoOfDays,CEss+Hecess Rate,ST+LT as TaxNo,
			Round(NetAmt-(CEss+Hecess+ST+LT),0) Amount,Round(@TotalAmt,0) as TotalTariff,
			Round(NetAmt,0) TotalAmount,0 as selectRadio,ChkoutId,PrtyId,--@Net As Logo,
			'Rupees : '+dbo.fn_NtoWord(ROUND(@Net,0),'','') AS Name,Round(@TotalAmt,0) as TotalAmt,@Net as NetAmount,
			@CEss Cess,@HCess HCess,@Lt LuxuryTax,@St SerivceTax,0 as Vat,'2.00'CessPercent,'1.00'HECessPercent,
			PrtyId ,p.Phone as Phone,@NDays as Stay, P.City City,p.Line1,p.State Propertaddress,p.Pincode
			,p.Email as Email,@BillType,@LOGO AS logo,@Propcity Propcity,
			'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
			'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
			'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
			and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  '
			+'CIN No: U72900KA2005PTC035942' as CINNo,  
			'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
			'TIN : 29340489869' as Tin,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
			'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
			isnull(STPerCent,0) STPerCent,isnull(LTPerCent,0) LTPerCent,
			--'Luxury Tax @ '+CAST(0 AS NVARCHAR)+'%' LTPer, 'Service Tax @ '+CAST(0 AS NVARCHAR)+'%' STPer,
			'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate
			FROM #Annuxer A
			join WRBHBStaticHotels p  WITH(NOLOCK) ON A.PrtyId = p.HotalId and p.IsActive=1
			group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.state,p.Line1 ,p.Pincode,p.Email,
			InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId,
			STPerCent,LTPerCent 
		END
End
End
 

if(@Str2='Internal')
Begin
SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,'
   

WHILE CHARINDEX(',', @id) > 0 
BEGIN 
  
     SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

    INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
    SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id)) 
END 


   SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
   while @Cnt>0
   begin
          Set @Chkid=(Select top 1 CheckoutId from  #SepratebyComma
           order by Id desc )
         
 INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
 CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
				
SELECT H.InVoiceNo,B.BookingCode,h.Property,h.ClientName,''cityName, H.GuestName,
CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, 
--(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount,
h.ChkOutTariffLT  LT,H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3+Cs.ChkOutServiceST,
h.ChkOutTariffCess+CS.Cess,CS.HECess+H.ChkOutTariffHECess,
Round((CSD.BillAmount),0) NetAmt,
0 as selectRadio ,H.Id as ChkoutId,h.PropertyId,H.ServiceTaxPer,H.LuxuryTaxPer
FROM WRBHBChechkOutHdr H
JOIN WRBHBCheckInHdr  B WITH(NOLOCK) ON H.ChkinHdrId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND CSD.IsActive=1 AND CSD.IsDeleted=0	
join WRBHBCheckOutServiceHdr CS With(nolock) on h.Id= cs.CheckOutHdrId and cs.IsActive=1 and cs.IsDeleted=0  
WHERE H.IsActive=1 AND H.IsDeleted=0  and h.Id=@Chkid  and csd.BillType ='Consolidate'
group by  H.InVoiceNo,h.Property,h.ClientName,H.GuestName,CSD.BillAmount,
H.CheckInDate,H.CheckOutDate,H.NoOfDays,B.BookingCode,
Cs.ChkOutServiceST,CS.Cess,CS.HECess,H.Id,h.PropertyId,h.ChkOutTariffLT,
H.ChkOutTariffST1,H.ChkOutTariffSC,H.ChkOutTariffST3,h.ChkOutTariffCess,
H.ChkOutTariffHECess,H.ServiceTaxPer,H.LuxuryTaxPer
ORDER BY H.Id desc  
            INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
			
		 
			SELECT	H.InVoiceNo,BookingCode,P.PropertyName,C.ClientName,B.cityName, H.GuestName,
			--H.Id,ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, --CONVERT(NVARCHAR,BillDate,103),
			--CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,	ChkOutTariffHECess,PrintInvoice,
			h.ChkOutTariffLT,H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3,h.ChkOutTariffCess as cess,H.ChkOutTariffHECess,
			Round(h.ChkOutTariffLT+H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3+h.ChkOutTariffCess+H.ChkOutTariffHECess+h.ChkOutTariffTotal,0) NetAmt,
			0 as selectRadio ,H.Id as ChkoutId,P.Id,H.ServiceTaxPer,H.LuxuryTaxPer
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0 and p.Category='Internal Property'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0   and h.Status in('CheckOut','UnSettled')-- and Property='Ratnalayam'
			 and	 InVoiceNo!='0' and  InVoiceNo!=''   and H.Id=@Chkid and H.id not in(Select ChkoutId from #Annuxer)
			ORDER BY   H.id desc ;
			
INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
 CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId,STPerCent,LTPerCent)
				
SELECT H.InVoiceNo,B.BookingCode,h.Property,h.ClientName,''cityName, H.GuestName,
CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, 
--(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount,
0  LT,Cs.ChkOutServiceST,CS.Cess,CS.HECess,
Round((CSD.BillAmount),0) NetAmt,
0 as selectRadio ,H.Id as ChkoutId,h.PropertyId,H.ServiceTaxPer,H.LuxuryTaxPer
FROM WRBHBChechkOutHdr H
JOIN WRBHBCheckInHdr  B WITH(NOLOCK) ON H.ChkinHdrId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND CSD.IsActive=1 AND CSD.IsDeleted=0	
join WRBHBCheckOutServiceHdr CS With(nolock) on h.Id= cs.CheckOutHdrId and cs.IsActive=1 and cs.IsDeleted=0  
WHERE H.IsActive=1 AND H.IsDeleted=0  and h.Id=@Chkid  and csd.BillType ='Service'-- and H.id not in(Select ChkoutId from #Annuxer)
group by  H.InVoiceNo,h.Property,h.ClientName,H.GuestName,CSD.BillAmount,
H.CheckInDate,H.CheckOutDate,H.NoOfDays,B.BookingCode,
Cs.ChkOutServiceST,CS.Cess,CS.HECess,H.Id,h.PropertyId,H.ServiceTaxPer,H.LuxuryTaxPer
ORDER BY H.Id desc
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
 
Set @Net=(Select SUM(NetAmt) from #Annuxer )
Set @BillType='Internal';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(LT)+SUM(ST) from #Annuxer)
 		
 
 Set @St=(Select SUM(ST) from #Annuxer)
 Set @Lt=(Select SUM(LT) from #Annuxer)
 Set @CEss=(Select SUM(cess) from #Annuxer)
 Set @HCess=(Select SUM(Hecess) from #Annuxer)
Set @Propcity=(Select Top 1 CityName from #Annuxer) 
 insert into #NODays(NoDays,ChkoutId)
 Select  (NoOfDays),ChkoutId  from #Annuxer 
 group by ChkoutId,NoOfDays
  Set @NDays=(Select Top 1 SUM(NoDays) from #NODays )
 --Select @St,@Lt,@CEss,@HCess,@Net,@TotalAmt,@NDays;
           Select Distinct CONVERT(Nvarchar(100),GETDATE(),103) as BillDate,InvoiceNumber,BookingCode BookingId,
            Property PropertyName,ClientName,CityName City,GuestNam GuestName,
			CheckInDate ChkInDt,CheckOutDate ChkOutDt,NoOfDays,CEss+Hecess Rate,ST+LT as TaxNo,
			Round(NetAmt-(CEss+Hecess+ST+LT),0) Amount,Round(@TotalAmt,0) as TotalTariff,
			Round(NetAmt,0) TotalAmount,0 as selectRadio,ChkoutId,PrtyId,--@Net As Logo,
			'Rupees : '+dbo.fn_NtoWord(ROUND(@Net,0),'','') AS Name,
			Round(@TotalAmt,0) as TotalAmt,@Net as NetAmount,
@CEss Cess,@HCess HCess,@Lt LuxuryTax,@St SerivceTax,0 as Vat,'2.00'CessPercent,'1.00'HECessPercent,
 PrtyId ,p.Phone as Phone,@NDays as Stay, 'TIN : 29340489869' as Tin,
P.City City,p.Propertaddress Propertaddress,p.Postal,isnull(STPerCent,0) STPerCent,isnull(LTPerCent,0) LTPerCent,
p.Email as Email,@BillType,@LOGO AS logo,@Propcity Propcity,
 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
	 'INVOICE : For any invoice clarification revert within 7 days from the date of receipt' as Invoice,  
	 'All cheque or demand drafts in payment of bills should be drawn in favor of Hummingbird Travel and stay pvt.ltd.  
	 and should be crossed A/C PAYEE ONLY.' as Cheque,'PAN NO :'+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  '
	 +'CIN No: U72900KA2005PTC035942' as CINNo, 
	 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bill after due date.' as Latepay ,  
	 'TIN : 29340489869' as Description,'Taxable Category : Accommodation Service,Business Support Services and Restaurant Services' as Taxablename,  
	 'Service Tax Regn. No : AABCH5874RST001' as ServiceTaxNo,
	 --'Luxury Tax @ '+CAST(0 AS NVARCHAR)+'%' LTPer, 'Service Tax @ '+CAST(0 AS NVARCHAR)+'%' STPer,
	 'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate
			FROM #Annuxer A
			join WRBHBProperty p on p.Id=a.PrtyId and p.IsActive=1 
          group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.Propertaddress ,p.Postal,p.Email,
          InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId,
          STPerCent,LTPerCent
	End		
end 
--exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'70,69,68,67,',@Str2=N'Tac',@Id1=0,@Id2=0

 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'1320,1319,',@Str2=N'Internal',@Id1=0,@Id2=0
 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'1320,1319,',@Str2=N'Internal',@Id1=0,@Id2=0
 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'973,972,',@Str2=N'External',@Id1=0,@Id2=0
--WIZA8BW2PN
--IYPESZEALN
 --Select * from WRBHBChechkOutHdr where Id=1320