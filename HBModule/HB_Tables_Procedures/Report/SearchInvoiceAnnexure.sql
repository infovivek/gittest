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
		Hecess DECIMAL(27,2),NetAmt Decimal(27,2),selectRadio INT,ChkoutId BIGINT,PrtyId Bigint)
 DECLARE @tmpstr VARCHAR(50), @Net decimal(27,2),@TotalAmt Decimal(27,2);
 DECLARE @Cnt int,@Chkid Bigint=0;Declare @BillType Nvarchar(100)=''
 
 Declare @St Decimal(27,2),@Lt Decimal(27,2)
  Declare @CEss Decimal(27,2),@HCess Decimal(27,2),@NDays Bigint
  
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
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
			
			SELECT CT.TACInvoiceNo InvoiceNumber,B.BookingCode,P.PropertyName Property,C.ClientName AS ClientName,B.CityName,C.GuestName AS GuestName ,
			CT.CheckInDate as CheckInDate,CT.CheckOutDate AS CheckOutDate,
			c.NoOfDays,CT.MarkupAmount,CT.TotalBusinessSupportST as ST, 
			 ct.ChkOutTariffCess,ct.ChkOutTariffHECess,Round(CT.MarkupAmount+CT.TotalBusinessSupportST+ 
			 ct.ChkOutTariffCess+ct.ChkOutTariffHECess,0) NetAmt,0 as selectRadio ,C.Id as ChkoutId,P.Id
			--,'CheckOut'Status,'TAC' as PropertyCat,'Tariff' BillType,Ct.Rate, 
			FROM WRBHBChechkOutHdr C 
			join WRBHBBooking B WITH(NOLOCK) on c.BookingId=B.Id and B.IsActive=1 and B.IsDeleted=0
			JOIN WRBHBExternalChechkOutTAC CT WITH(NOLOCK) ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 --and p.Category='Internal Property'
			WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' and CT.Id=@Chkid
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
--Select @St,@Lt,@CEss,@HCess,@Net,@TotalAmt;
           Select Distinct CONVERT(Nvarchar(100),GETDATE(),103) as BillDate,InvoiceNumber,BookingCode BookingId,
            Property PropertyName,ClientName,CityName City,GuestNam GuestName,
			CheckInDate ChkInDt,CheckOutDate ChkOutDt,NoOfDays,CEss+Hecess Rate,st as TaxNo,
			Round(LT,0) Amount,Round(@lt,0) as TotalTariff,
			Round(NetAmt,0) TotalAmount,0 as selectRadio,ChkoutId,PrtyId,--@Net As Logo,
			'Rupees : '+dbo.fn_NtoWord(ROUND(@Net,0),'','') AS Logo,
			Round(@TotalAmt,0) as TotalAmt,@NAmt as NetAmount,
@CEss Cess,@HCess HCess,'0.00' LuxuryTax,@St SerivceTax,'0.00' as Vat,
 PrtyId ,p.Phone as Phone,@NDays as Stay,
P.City City,p.Propertaddress Propertaddress,p.Postal
,p.Email as Email,@BillType
			FROM #Annuxer A
			join WRBHBProperty p on p.Id=a.PrtyId and p.IsActive=1 
          group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.Propertaddress ,p.Postal,p.Email,
          InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId
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
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,Cess,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
			
			SELECT  InVoiceNo InvoiceNumber,BookingCode,p.PropertyName+'-'+cc.CityName Property,
			F.ClientName ClientName,cc.CityName ,
			GuestName GuestName,f.CheckInDate CheckInDate,F.CheckOutDate CheckOutDate,F.NoOfDays,
			F.ChkOutTariffLT,F.ChkOutTariffST1,F.ChkOutTariffCess,F.ChkOutTariffHECess,
			Round(F.ChkOutTariffLT+F.ChkOutTariffST1+F.ChkOutTariffHECess+F.ChkOutTariffCess+f.ChkOutTariffTotal,0) as NetAmt, 
			--0 Rate, 0 St,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,--'Tariff' BillType,
			0 as selectRadio ,f.Id ChkoutId,P.Id--,'CheckOut'Status,'External Property' as PropertyCat
			FROM WRBHBChechkOutHdr f
			JOIN WRBHBBooking  B WITH(NOLOCK) ON f.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			join WRBHBProperty p WITH(NOLOCK) on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category='External Property'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			where    InVoiceNo!='0' and  InVoiceNo!=''  and f.Id=@Chkid
			ORDER BY   f.Id desc  
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
 
Set @Net=(Select SUM(NetAmt) from #Annuxer )
Set @BillType='External';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(LT)+SUM(ST) from #Annuxer)
End
End

if(@Str2='Internals')
Begin
SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,'
 
    CREATE TABLE #TempInvoiceBill1(CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),BookingCode NVARCHAR(100),
	InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),
	CheckOutId BIGINT,SerivceTax7 DECIMAL(27,2),Servicetax12 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),
	CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),
	Location NVARCHAR(100),MasterClientName NVARCHAR(100),LuxuryTax DECIMAL(27,2),
	PropertyId BIGINT,ClientId BIGINT,PropertyType NVARCHAR(100),ExtraAmount DECIMAL(27,2),
	NoOfDays NVARCHAR(100),PaymentDate NVARCHAR(100),Hcess DECIMAL(27,2),Cess DECIMAL(27,2),Discount DECIMAL(27,2),
	PrintInvoice bigint)
	
	CREATE TABLE #TempInvoiceBillTotalAmount1(CheckOutId BIGINT,TotalAmount DECIMAL(27,2),
	ChkInHdrId BIGINT,BillType nvarchar(100),BillAmount DECIMAL(27,2))
		
	CREATE TABLE #TempInvoiceBillTariffAmount1(CheckOutId BIGINT,TariffAmount DECIMAL(27,2),
	ChkInHdrId BIGINT)
	
	
	CREATE TABLE #TempBillFinal1(CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),BookingCode NVARCHAR(100),
	InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),
	CheckOutId BIGINT,SerivceTax7 DECIMAL(27,2),Servicetax12 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),
	CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),
	Location NVARCHAR(100),MasterClientName NVARCHAR(100),LuxuryTax DECIMAL(27,2),
	PropertyId BIGINT,ClientId BIGINT,PropertyType NVARCHAR(100),ExtraAmount DECIMAL(27,2),
	TotalAmount DECIMAL(27,2),TariffAmount DECIMAL(27,2),FOODANDBeverages DECIMAL(27,2),
	SerivceTax4 DECIMAL(27,2),VAT DECIMAL(27,2),Broadband DECIMAL(27,2),Laundry DECIMAL(27,2),
	PaymentType NVARCHAR(100),PaymentMode NVARCHAR(100),AcountNo NVARCHAR(100),NoOfDays NVARCHAR(100),
	PaymentDate NVARCHAR(100),OrderBy NVARCHAR(100),
	Hcess DECIMAL(27,8),Cess DECIMAL(27,2),Discount DECIMAL(27,2),BillType nvarchar(100),BillAmount DECIMAL(27,2),
	BillId bigint,PrintInvoice bigint)
	
	if(@FromDt!='')and(@ToDt!='')
	Begin
	        INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice )
			SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 AND H.Flag=1  and h.Status='CheckOut' --and InVoiceNo like '%HBE%' 
			and CONVERT(DATE,h.CheckOutDate,103) BETWEEN CONVERT(DATE,@FromDt,103)
			AND CONVERT(DATE,@ToDt,103)
	End
	else
	Begin
	      INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice )
			SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 AND H.Flag=1  and h.Status='CheckOut' --and InVoiceNo like '%HBE%'
	End		
	INSERT INTO #TempInvoiceBillTotalAmount1(TotalAmount,CheckOutId,ChkInHdrId,BillType,BillAmount)
	SELECT SUM(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount
	FROM WRBHBChechkOutHdr H
	JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
	JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND 
	CSD.IsActive=1 AND CSD.IsDeleted=0	
	WHERE H.IsActive=1 AND H.IsDeleted=0  
	GROUP BY H.Id,H.ChkInHdrId,CSD.BillType,Csd.BillAmount
	ORDER BY Id desc
	
	INSERT INTO #TempInvoiceBillTotalAmount1(TotalAmount,CheckOutId,ChkInHdrId,BillType,BillAmount)
	Select SUM(h.ChkOutTariffNetAmount),H.Id,H.ChkInHdrId ,'Tariff',h.ChkOutTariffNetAmount
	FROM WRBHBChechkOutHdr H
	where IsActive=1 and IsDeleted=0 and H.Id not in (Select CheckOutId from #TempInvoiceBillTotalAmount1)
	 and h.ChkOutTariffNetAmount!=0
	GROUP BY H.Id,H.ChkInHdrId, h.ChkOutTariffNetAmount
	ORDER BY Id desc
			
   INSERT INTO #TempInvoiceBillTariffAmount1(TariffAmount,CheckOutId,ChkInHdrId)
	SELECT H.ChkOutTariffTotal,H.Id,H.ChkInHdrId
	FROM WRBHBChechkOutHdr H	
	WHERE H.IsActive=1 AND H.IsDeleted=0  

  
		

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
           
   --         INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			--CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
			
			
		SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,
		ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,
		ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,
		ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,
		ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,
		ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,
		ISNULL(TariffAmount,0) TariffAmount,0,0,0,0,0,
		--ISNULL(Broadband,0) Broadband,ISNULL(FOODANDBeverages,0) FOODANDBeverages,
		--ISNULL(SerivceTax4,0) SerivceTax4,ISNULL(VAT,0) VAT,ISNULL(Laundry,0) Laundry,
		ISNULL(ExtraAmount,0) ExtraAmount,
		'A',ISNULL(Cess,0),ISNULL(Hcess,0),D.BillAmount,D.BillType,H.CheckOutId as ChkoutId,PropertyId,PrintInvoice
		FROM #TempInvoiceBill1 H 
		  JOIN #TempInvoiceBillTotalAmount1 D ON D.CheckOutId =H.CheckOutId
		right outer   JOIN #TempInvoiceBillTariffAmount1 D1 ON H.CheckOutId =D1.CheckOutId  
		where H.CheckOutId=723
		GROUP BY CreatedDate, ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
		MasterClientName, GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,
		CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,
		TariffAmount,--Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,
		ExtraAmount,Cess,Hcess,D.BillAmount,D.BillType,H.CheckOutId,PropertyId,PrintInvoice
		
			SELECT	H.InVoiceNo,BookingCode,P.PropertyName,C.ClientName,B.cityName, H.GuestName,
			--H.Id,ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, --CONVERT(NVARCHAR,BillDate,103),
			--CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,	ChkOutTariffHECess,PrintInvoice,
			h.ChkOutTariffLT,H.ChkOutTariffST1,h.ChkOutTariffCess as cess,H.ChkOutTariffHECess,
			Round(h.ChkOutTariffLT+H.ChkOutTariffST1+h.ChkOutTariffCess+H.ChkOutTariffHECess+h.ChkOutTariffTotal,0) NetAmt,
			0 as selectRadio ,H.Id as ChkoutId,P.Id
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0 and p.Category='Internal Property'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 AND H.Flag=1  and h.Status='CheckOut'-- and Property='Ratnalayam'
			 and	 InVoiceNo!='0' and  InVoiceNo!=''   and H.Id=723
			ORDER BY   H.id desc ;
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
 
Set @Net=(Select SUM(NetAmt) from #Annuxer )
Set @BillType='Internal';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(LT)+SUM(ST) from #Annuxer)
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
 CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
				
SELECT H.InVoiceNo,B.BookingCode,h.Property,h.ClientName,''cityName, H.GuestName,
CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, 
--(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount,
h.ChkOutTariffLT  LT,H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3+Cs.ChkOutServiceST,
h.ChkOutTariffCess+CS.Cess,CS.HECess+H.ChkOutTariffHECess,
Round((CSD.BillAmount),0) NetAmt,
0 as selectRadio ,H.Id as ChkoutId,h.PropertyId
FROM WRBHBChechkOutHdr H
JOIN WRBHBCheckInHdr  B WITH(NOLOCK) ON H.ChkinHdrId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND CSD.IsActive=1 AND CSD.IsDeleted=0	
join WRBHBCheckOutServiceHdr CS With(nolock) on h.Id= cs.CheckOutHdrId and cs.IsActive=1 and cs.IsDeleted=0  
WHERE H.IsActive=1 AND H.IsDeleted=0  and h.Id=@Chkid  and csd.BillType ='Consolidate'
group by  H.InVoiceNo,h.Property,h.ClientName,H.GuestName,CSD.BillAmount,
H.CheckInDate,H.CheckOutDate,H.NoOfDays,B.BookingCode,
Cs.ChkOutServiceST,CS.Cess,CS.HECess,H.Id,h.PropertyId,h.ChkOutTariffLT,
H.ChkOutTariffST1,H.ChkOutTariffSC,H.ChkOutTariffST3,h.ChkOutTariffCess,H.ChkOutTariffHECess
ORDER BY H.Id desc  
            INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
			
		 
			SELECT	H.InVoiceNo,BookingCode,P.PropertyName,C.ClientName,B.cityName, H.GuestName,
			--H.Id,ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, --CONVERT(NVARCHAR,BillDate,103),
			--CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,	ChkOutTariffHECess,PrintInvoice,
			h.ChkOutTariffLT,H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3,h.ChkOutTariffCess as cess,H.ChkOutTariffHECess,
			Round(h.ChkOutTariffLT+H.ChkOutTariffST1+H.ChkOutTariffSC+H.ChkOutTariffST3+h.ChkOutTariffCess+H.ChkOutTariffHECess+h.ChkOutTariffTotal,0) NetAmt,
			0 as selectRadio ,H.Id as ChkoutId,P.Id
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0 and p.Category='Internal Property'
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 AND H.Flag=1  and h.Status='CheckOut'-- and Property='Ratnalayam'
			 and	 InVoiceNo!='0' and  InVoiceNo!=''   and H.Id=@Chkid and H.id not in(Select ChkoutId from #Annuxer)
			ORDER BY   H.id desc ;
			
INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
 CheckInDate,CheckOutDate,NoOfDays,LT,ST,CEss,Hecess,NetAmt,selectRadio,ChkoutId,PrtyId)
				
SELECT H.InVoiceNo,B.BookingCode,h.Property,h.ClientName,''cityName, H.GuestName,
CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),H.NoOfDays, 
--(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount,
0  LT,Cs.ChkOutServiceST,CS.Cess,CS.HECess,
Round((CSD.BillAmount),0) NetAmt,
0 as selectRadio ,H.Id as ChkoutId,h.PropertyId
FROM WRBHBChechkOutHdr H
JOIN WRBHBCheckInHdr  B WITH(NOLOCK) ON H.ChkinHdrId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND CSD.IsActive=1 AND CSD.IsDeleted=0	
join WRBHBCheckOutServiceHdr CS With(nolock) on h.Id= cs.CheckOutHdrId and cs.IsActive=1 and cs.IsDeleted=0  
WHERE H.IsActive=1 AND H.IsDeleted=0  and h.Id=@Chkid  and csd.BillType ='Service'-- and H.id not in(Select ChkoutId from #Annuxer)
group by  H.InVoiceNo,h.Property,h.ClientName,H.GuestName,CSD.BillAmount,
H.CheckInDate,H.CheckOutDate,H.NoOfDays,B.BookingCode,
Cs.ChkOutServiceST,CS.Cess,CS.HECess,H.Id,h.PropertyId
ORDER BY H.Id desc
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End
 
Set @Net=(Select SUM(NetAmt) from #Annuxer )
Set @BillType='Internal';
set @TotalAmt=@Net-(Select SUM(cess)+SUM(Hecess)+SUM(LT)+SUM(ST) from #Annuxer)
End
			
 Create Table #NODays (NoDays Bigint,ChkoutId Bigint)
 Set @St=(Select SUM(ST) from #Annuxer)
 Set @Lt=(Select SUM(LT) from #Annuxer)
 Set @CEss=(Select SUM(cess) from #Annuxer)
 Set @HCess=(Select SUM(Hecess) from #Annuxer)

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
			'Rupees : '+dbo.fn_NtoWord(ROUND(@Net,0),'','') AS Logo,
			Round(@TotalAmt,0) as TotalAmt,@Net as NetAmount,
@CEss Cess,@HCess HCess,@Lt LuxuryTax,@St SerivceTax,0 as Vat,
 PrtyId ,p.Phone as Phone,@NDays as Stay,
P.City City,p.Propertaddress Propertaddress,p.Postal
,p.Email as Email,@BillType
			FROM #Annuxer A
			join WRBHBProperty p on p.Id=a.PrtyId and p.IsActive=1 
          group by Property,ClientName,CityName,PrtyId ,p.Phone, P.City ,p.Propertaddress ,p.Postal,p.Email,
          InvoiceNumber,BookingCode,GuestNam,CheckInDate,CheckOutDate,NoOfDays,CEss,Hecess,ST,LT,NetAmt,ChkoutId
			
end 
--exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'70,69,68,67,',@Str2=N'Tac',@Id1=0,@Id2=0

 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'1320,1319,',@Str2=N'Internal',@Id1=0,@Id2=0
 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'1320,1319,',@Str2=N'Internal',@Id1=0,@Id2=0
 --exec Sp_SearchInvoiceAnnexure_Help @Action=N'PAGELOAD',@Str1=N'973,972,',@Str2=N'External',@Id1=0,@Id2=0
--WIZA8BW2PN
--IYPESZEALN
 --Select * from WRBHBChechkOutHdr where Id=1320