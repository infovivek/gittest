SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_SearchInvoiceReport_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_SearchInvoiceReport_Help]
GO
/*=============================================
Author Name  : Anbu
Created Date : 03/04/2014 
Section  	 : Master
Purpose  	 : Tax
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_SearchInvoiceReport_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
@Str3 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL,
@Id3 INT=NULL, 
@UserId INT=NULL
)
AS
BEGIN
DECLARE @Cnt INT;
IF @Action ='Pageload'
BEGIN 
    --drop table  #TempInvoiceBillTotalAmount; 
    --drop table #TempInvoiceBill;
    --drop table #TempInvoiceBillTariffAmount;
    --drop table #TempBillFinal;
     
    CREATE TABLE #TempInvoiceBill1(CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),BookingCode NVARCHAR(100),
	InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),
	CheckOutId BIGINT,SerivceTax7 DECIMAL(27,2),Servicetax12 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),
	CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),
	Location NVARCHAR(100),MasterClientName NVARCHAR(100),LuxuryTax DECIMAL(27,2),
	PropertyId BIGINT,ClientId BIGINT,PropertyType NVARCHAR(100),ExtraAmount DECIMAL(27,2),
	NoOfDays NVARCHAR(100),PaymentDate NVARCHAR(100),Hcess DECIMAL(27,2),Cess DECIMAL(27,2),Discount DECIMAL(27,2),
	PrintInvoice bigint,Statuss nvarchar(100))
	
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
	BillId bigint,PrintInvoice bigint, statuss  NVARCHAR(100))
	
IF(@FromDt!='')and(@ToDt!='')
BEGIN
	        INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice,Statuss )
			SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice,h.Status
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 --AND H.Flag=1  and h.Status='CheckOut' --and InVoiceNo like '%HBE%' 
			and CONVERT(DATE,h.CheckOutDate,103) BETWEEN CONVERT(DATE,@FromDt,103)
			AND CONVERT(DATE,@ToDt,103)
 --MMT Data's below Select 
			INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice,Statuss )
		
		    SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,s.HotalName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,H.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice,h.Status
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			--JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0  and H.PropertyType='MMT'
			and CONVERT(DATE,h.CheckOutDate,103) BETWEEN CONVERT(DATE,@FromDt,103)
			AND CONVERT(DATE,@ToDt,103)
			
END
ELSE
BEGIN
	       INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice,Statuss )
			
			SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice,h.Status
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0 --AND H.Flag=1  and h.Status='CheckOut' --and InVoiceNo like '%HBE%'
--MMT Data's below Select 
			INSERT INTO #TempInvoiceBill1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
			MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,
			BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,PrintInvoice,Statuss )
		
		    SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,
			BookingCode,H.InVoiceNo,s.HotalName,C.ClientName,'' ClientName,H.GuestName,H.Id,
			ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,
			CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillDate,103),
			CONVERT(NVARCHAR,BillDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,H.Id,ChkOutTariffCess,
			ChkOutTariffHECess,PrintInvoice,h.Status
			FROM WRBHBChechkOutHdr H
			JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			--JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId and cc.IsActive=1  
			JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
			--JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
			WHERE H.IsActive=1 AND H.IsDeleted=0  and H.PropertyType='MMT'
END		
		
			
    			
 --   INSERT INTO #TempInvoiceBillTotalAmount1(TotalAmount,CheckOutId,ChkInHdrId,BillType,BillAmount)
	--SELECT SUM(CSD.BillAmount),H.Id,H.ChkInHdrId ,CSD.BillType,Csd.BillAmount
	--FROM WRBHBChechkOutHdr H
	--JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0
	--JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND 
	--CSD.IsActive=1 AND CSD.IsDeleted=0	
	--WHERE H.IsActive=1 AND H.IsDeleted=0  
	--GROUP BY H.Id,H.ChkInHdrId,CSD.BillType,Csd.BillAmount
	--ORDER BY Id desc
	
	INSERT INTO #TempInvoiceBillTotalAmount1(TotalAmount,CheckOutId,ChkInHdrId,BillType,BillAmount)
	Select SUM(h.ChkOutTariffNetAmount),H.Id,H.ChkInHdrId ,'Tariff',h.ChkOutTariffNetAmount
	FROM WRBHBChechkOutHdr H
	where IsActive=1 and IsDeleted=0 --and H.Id NOT IN (Select CheckOutId from #TempInvoiceBillTotalAmount1)
	AND h.ChkOutTariffNetAmount!=0
	GROUP BY H.Id,H.ChkInHdrId, h.ChkOutTariffNetAmount
	ORDER BY Id desc
	
	INSERT INTO #TempInvoiceBillTotalAmount1(TotalAmount,CheckOutId,ChkInHdrId,BillType,BillAmount)
	Select SUM(H.ChkOutServiceNetAmount) AS TotalAmount,B.Id,B.ChkInHdrId ,'Service',H.ChkOutServiceNetAmount
	FROM WRBHBChechkOutHdr B
	JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.Id=H.CheckOutHdrId AND H.IsActive=1 AND H.IsDeleted=0
    JOIN WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON H.Id = D.ServiceHdrId AND D.IsActive=1 AND D.IsDeleted=0
    WHERE --D.TypeService='Food And Beverages' 
	 B.IsActive=1 and B.IsDeleted=0 --AND B.Id NOT IN (Select CheckOutId from #TempInvoiceBillTotalAmount1)
	--AND D.ChkOutSerAmount!=0
	GROUP BY B.Id,B.ChkInHdrId,H.ChkOutServiceNetAmount
	ORDER BY Id desc
			
    INSERT INTO #TempInvoiceBillTariffAmount1(TariffAmount,CheckOutId,ChkInHdrId)
	SELECT H.ChkOutTariffTotal,H.Id,H.ChkInHdrId
	FROM WRBHBChechkOutHdr H	
	WHERE H.IsActive=1 AND H.IsDeleted=0  


       INSERT INTO #TempBillFinal1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,
		GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,
		TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,
		BillAmount,BillType,BillId,PropertyId,PrintInvoice,statuss )
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
		'A',ISNULL(Cess,0),ISNULL(Hcess,0),D.BillAmount,D.BillType,H.CheckOutId as ChkoutId,PropertyId,PrintInvoice,
		h.statuss
		FROM #TempInvoiceBill1 H 
		  JOIN #TempInvoiceBillTotalAmount1 D ON D.CheckOutId =H.CheckOutId
		right outer   JOIN #TempInvoiceBillTariffAmount1 D1 ON H.CheckOutId =D1.CheckOutId   
		--LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId 
		--LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId 
		--LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId 
	 	where  BookingCode!=''
		GROUP BY CreatedDate, ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
		MasterClientName, GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,
		CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,
		TariffAmount,--Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,
		ExtraAmount,Cess,Hcess,D.BillAmount,D.BillType,H.CheckOutId,PropertyId,PrintInvoice,h.statuss
		
		
		DECLARE @Count INT;
		SELECT @Count=COUNT(* ) FROM #TempBillFinal1 
		-- Select * from #TempBillFinal1 where InVoiceNo='EXT/7027'
		if(@Str1='')
		begin
		Update #TempBillFinal1 Set TariffAmount=BillAmount
		where BillType='Service'
		SELECT BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+Location Property,ClientName ClientName, 
		GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,Location,
		TotalAmount,TariffAmount Amount,BillAmount Amounts,BillType BillType,BillId ChkoutId,
		0 as selectRadio , statuss Status,'Internal Property' as PropertyCat
		FROM #TempBillFinal1 f
		join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category='Internal Property'
		 where BillAmount!=0  and InVoiceNo!='0' and  PrintInvoice=0
		ORDER BY  BillId desc 
		end
		if(@Str1='External Property')
		begin 
			if(@FromDt!='')and(@ToDt!='')
			Begin 
				SELECT '0'BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+cc.CityName Property,ClientName ClientName, 
				GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,''Location,
				''TotalAmount,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,'Tariff' BillType,f.Id ChkoutId,
				0 as selectRadio , F.status Status,'External Property' as PropertyCat
				FROM WRBHBChechkOutHdr f
				join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1
				jOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
				where    InVoiceNo!='0' and  InVoiceNo!=''
				and CONVERT(DATE,f.CheckOutDate,103) BETWEEN CONVERT(DATE,@FromDt,103)
			    AND CONVERT(DATE,@ToDt,103)
				ORDER BY   f.Id desc  
		   end 
			Else
		   begin
			   
	Create Table #ExtData (BookingCode nvarchar(100),InvoiceNumber  nvarchar(100),Property  nvarchar(500),
	ClientName  nvarchar(500),GuestName  nvarchar(200),CheckInDate  nvarchar(50),CheckOutDate  nvarchar(50),
	Location  nvarchar(200),TotalAmount  Decimal(27,2),Amount  Decimal(27,2),Amounts Decimal(27,2),BillType  nvarchar(100),ChkoutId  nvarchar(100),
	selectRadio  nvarchar(100) ,Status  nvarchar(100), PropertyCat  nvarchar(100))
					
				
	INsert into #ExtData( BookingCode,InvoiceNumber,Property,ClientName,GuestName,CheckInDate,CheckOutDate,Location,
	TotalAmount,Amount,Amounts,BillType,ChkoutId,
	selectRadio ,Status, PropertyCat) 
	SELECT '0'BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+cc.CityName Property,ClientName ClientName, 
	GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,''Location,
	 0 TotalAmount,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,'Tariff' BillType,f.Id ChkoutId,
	0 as selectRadio ,f.Status Status,'External Property' as PropertyCat
	FROM WRBHBChechkOutHdr f
	join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1--'External Property'
	JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
	where    InVoiceNo!='0' and  InVoiceNo!=''-- and  f.Id=2759
	ORDER BY   f.Id desc 

	INsert into #ExtData( BookingCode,InvoiceNumber,Property,ClientName,GuestName,CheckInDate,CheckOutDate,Location,
	TotalAmount,Amount,Amounts,BillType,ChkoutId,
	selectRadio ,Status, PropertyCat) 
	SELECT '0'BookingCode,InVoiceNo InvoiceNumber,s.HotalName+'-'+cc.CityName Property,ClientName ClientName, 
	GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,''Location,
	 0 TotalAmount,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,'Tariff' BillType,f.Id ChkoutId,
	0 as selectRadio ,f.Status Status,'External Property' as PropertyCat
	FROM WRBHBChechkOutHdr f
	join WRBHBStaticHotels S   WITH(NOLOCK) ON F.PropertyId = S.HotalId and s.IsActive=1
	--join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1
	JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=f.CityId and cc.IsActive=1  
	where    InVoiceNo!='0' and  InVoiceNo!=''
	ORDER BY   f.Id desc 
	
    INsert into #ExtData( BookingCode,InvoiceNumber,Property,ClientName,GuestName,CheckInDate,CheckOutDate,Location,
	TotalAmount,Amount,Amounts,BillType,ChkoutId,
	selectRadio ,Status, PropertyCat)
Select '0'BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+cc.CityName Property,ClientName ClientName, 
GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,''Location,
0 TotalAmount,h.ChkOutServiceAmtl Amount,H.ChkOutServiceNetAmount Amounts,'Service' BillType,HH.Id ChkoutId,
0 as selectRadio ,Hh.Status Status,'External Property' as PropertyCat
from  WRBHBChechkOutHdr HH
join WRBHBCheckOutServiceHdr H on hh.Id=h.CheckOutHdrId
join WRBHBProperty p on Hh.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category= @Str1
JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
where Hh.PropertyType='External Property'  and ChkOutServiceNetAmount!=0 and InVoiceNo!='0'

	Select BookingCode,InvoiceNumber,Property,ClientName,GuestName,CheckInDate,CheckOutDate,Location,
	TotalAmount,Amount,Amounts,BillType,ChkoutId,
	0 as selectRadio ,Status, PropertyCat from #ExtData
	where InvoiceNumber not like '%HBE/%'
	order by ChkoutId desc
				
			end
       end
       if(@Str1='Internal Property')
		begin
		Update #TempBillFinal1 Set TariffAmount=BillAmount
			where BillType='Service'
			
		SELECT BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+Location Property,ClientName ClientName, 
		GuestName GuestName,CheckInDate CheckInDate,CheckOutDate CheckOutDate,Location,
		TotalAmount,TariffAmount Amount,BillAmount Amounts,BillType BillType,BillId ChkoutId,
		0 as selectRadio ,statuss Status,'Internal Property' as PropertyCat
		FROM #TempBillFinal1 f
		join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1
		 where BillAmount!=0  and InVoiceNo!='0'-- and  PrintInvoice=0
		ORDER BY   BillId desc 
       end
       if(@Str1='TAC')
		begin 
		if(@FromDt!='')and(@ToDt!='')
	    Begin 
			SELECT C.Id as ChkoutId,CT.TACInvoiceNo InvoiceNumber,P.PropertyName Property,
			--round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST+CT.TACAmount,0) as Amount ,
			CT.MarkupAmount  as Amount,
			CT.TACAmount Amounts,C.GuestName AS GuestName ,C.ClientName AS ClientName,
			CT.CheckInDate as CheckInDate,CT.CheckOutDate AS CheckOutDate,--ct.NoOfDays,ct.Rate,
			0 as selectRadio , C.Status Status,'TAC' as PropertyCat,'Tariff' BillType
			FROM WRBHBChechkOutHdr C 
			JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
			JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
			WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H'  
			and CONVERT(DATE,c.CheckOutDate,103) BETWEEN CONVERT(DATE,@FromDt,103)
			AND CONVERT(DATE,@ToDt,103)
			ORDER BY   c.id desc 
			end
			Else
			begin
				SELECT C.Id as ChkoutId,CT.TACInvoiceNo InvoiceNumber,P.PropertyName Property,
				--round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST,0) as Amount,
				CT.MarkupAmount  as Amount,
				CT.TACAmount Amounts,C.GuestName AS GuestName ,C.ClientName AS ClientName,
				CT.CheckInDate as CheckInDate,CT.CheckOutDate AS CheckOutDate,--ct.NoOfDays,ct.Rate,
				0 as selectRadio ,C.Status  Status,'TAC' as PropertyCat,'Tariff' BillType 
				FROM WRBHBChechkOutHdr C 
				JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
				JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
				WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' 
				ORDER BY   c.id desc 
			end
       end
	 	
		--Select ChkOutHdrId,PayeeName from WRBHBCheckOutSettleHdr H
		--join WRBHBCheckOutSettleDtl D on h.id=d.CheckOutSettleHdrId
		
   END  

IF @Action ='CreditNoteTariff'
BEGIN 
		BEGIN  
			SET @Cnt=(SELECT COUNT(*) FROM WRBHBCreditNoteTariffHdr)  
			IF @Cnt=0 
			BEGIN 
			      SELECT 1 AS CreditNoteNo;  
		     END  
		    ELSE   
		BEGIN  
			SELECT TOP 1 CAST(CreditNoteNo AS INT)+1 AS CreditNoteNo FROM WRBHBCreditNoteTariffHdr  
			where IsActive = 1 and IsDeleted = 0
			ORDER BY Id DESC;  
		END
	CREATE TABLE #ChkId(InVoiceNo NVARCHAR(100),ChkOutId INT,PropertyId INT)
	CREATE TABLE #Tariff(Type NVARCHAR(100),TariffAmount DECIMAL(27,2),NoOfDays INT,Total DECIMAL(27,2))
	CREATE TABLE #Tax(LuxuryTaxPer DECIMAL(27,2),ServiceTaxPer DECIMAL(27,2),VATPer DECIMAL(27,2),
	RestaurantSTPer DECIMAL(27,2),ServiceChargeChk DECIMAL(27,2),Type NVARCHAR(100),Cess DECIMAL(27,2),
	HECess DECIMAL(27,2))
	DECLARE @Direct NVARCHAR(100)
	SET @Direct=(SELECT ISNULL(Direct,'') FROM WRBHBChechkOutHdr 
	WHERE Id=@Id1 AND PropertyType='External Property')
	
	IF ISNULL(@Direct,'')=''
	BEGIN
		INSERT INTO #ChkId(InVoiceNo,ChkOutId,PropertyId)
		SELECT InVoiceNo,Id AS ChkOutId,PropertyId FROM WRBHBChechkOutHdr WHERE 
		Id=@Id1 AND InVoiceNo=@FromDt
		
	END
	ELSE
	BEGIN
		INSERT INTO #ChkId(InVoiceNo,ChkOutId,PropertyId)
		SELECT TACInvoiceNo,ChkOutHdrId AS ChkOutId,PropertyId FROM WRBHBExternalChechkOutTAC WHERE 
		ChkOutHdrId=@Id1 AND TACInvoiceNo=@FromDt
	END

	IF ISNULL(@Direct,'')=''
		BEGIN
			INSERT INTO #Tariff(Type,TariffAmount,NoOfDays,Total)
			SELECT 'Tariff' AS Type,(ChkOutTariffTotal/NoOfDays) AS TariffAmount ,NoOfDays,(ChkOutTariffTotal) AS Total
			FROM WRBHBChechkOutHdr WHERE Id=@Id1 AND InVoiceNo=@FromDt
		END
		ELSE
		BEGIN
			INSERT INTO #Tariff(Type,TariffAmount,NoOfDays,Total)
			SELECT 'Tariff' AS Type,(MarkUpAmount) AS TariffAmount ,NoOfDays,(TACAmount) AS Total
			FROM WRBHBExternalChechkOutTAC WHERE ChkOutHdrId=@Id1 AND TACInvoiceNo=@FromDt
		END
		IF ISNULL(@Direct,'')=''
		BEGIN
			 INSERT INTO #Tax(LuxuryTaxPer,ServiceTaxPer,VATPer,RestaurantSTPer,ServiceChargeChk,Type,Cess,HECess)
			 SELECT LuxuryTaxPer,ServiceTaxPer,VATPer,RestaurantSTPer,ISNULL(ServiceChargeChk,0) AS ServiceCharge,
			 PropertyType,T.Cess,T.HECess 
			 FROM WRBHBChechkOutHdr C
			 JOIN WRBHBTaxMaster T WITH(NOLOCK)ON C.StateId=T.StateId AND T.IsActive=1
			 WHERE C.Id=@Id1 AND InVoiceNo=@FromDt AND C.IsActive=1 AND C.IsDeleted=0
		END
		ELSE
		BEGIN
			 INSERT INTO #Tax(LuxuryTaxPer,ServiceTaxPer,VATPer,RestaurantSTPer,ServiceChargeChk,Type,Cess,HECess)
			 SELECT 0,T.ServiceTaxOnTariff AS ServiceTaxPer,0,0,0 AS ServiceCharge,
			 PropertyType,T.Cess,T.HECess  
			 FROM WRBHBExternalChechkOutTAC C
			 JOIN WRBHBTaxMaster T WITH(NOLOCK)ON C.StateId=T.StateId AND T.IsActive=1
			 WHERE ChkOutHdrId=@Id1 AND TACInvoiceNo=@FromDt AND C.IsActive=1 AND C.IsDeleted=0
		END
				
		SELECT InVoiceNo,ChkOutId,PropertyId FROM #ChkId
		
		SELECT Type,TariffAmount,NoOfDays,Total FROM #Tariff
		
		SELECT LuxuryTaxPer,ServiceTaxPer,VATPer,RestaurantSTPer,ServiceChargeChk FROM #Tax
	 
	 --SELECT 'Tariff' AS Type,(ChkOutTariffTotal/NoOfDays) AS TariffAmount ,NoOfDays,(ChkOutTariffTotal/NoOfDays) AS Total
	 --FROM WRBHBChechkOutHdr WHERE Id=@Id1 --AND InVoiceNo=@FromDt
	 
	 
	
END
END
IF @Action ='CreditNoteService'
BEGIN 

		BEGIN  
			SET @Cnt=(SELECT COUNT(*) FROM WRBHBCreditNoteServiceHdr)  
			IF @Cnt=0 BEGIN SELECT 1 AS CreditNoteNo;  
		END  
		ELSE   
		BEGIN  
			SELECT TOP 1 CAST(CreditNoteNo AS INT)+1 AS CreditNoteNo FROM WRBHBCreditNoteServiceHdr  
			where IsActive = 1 and IsDeleted = 0
			ORDER BY Id DESC;  
		END 
	 SELECT InVoiceNo,Id AS ChkOutId,PropertyId FROM WRBHBChechkOutHdr WHERE 
	 Id=@Id1 AND InVoiceNo=@FromDt

	 SELECT ChkOutSerItem AS Item,ChkOutSerAmount AS ServiceAmount,0 AS Quantity,0 AS Total,
	 0 AS Tax,TypeService
	 FROM WRBHBCheckOutServiceDtls D 
	 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK)ON D.ServiceHdrId=H.Id AND H.IsActive=1 AND H.IsDeleted=0
	 JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON H.CheckOutHdrId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	 WHERE C.Id=@Id1 AND C.InVoiceNo=@FromDt AND ChkOutSerAmount !=0
 
	 SELECT LuxuryTaxPer,ServiceTaxPer,VATPer,RestaurantSTPer,ISNULL(ServiceChargeChk,0) AS ServiceCharge 
	 FROM WRBHBChechkOutHdr
	 WHERE Id=@Id1 AND InVoiceNo=@FromDt AND IsActive=1 AND IsDeleted=0;
END
END
IF @Action ='PropertyLoad'
BEGIN 
    SELECT PropertyName,Id AS ZId FROM WRBHBProperty
END
IF @Action ='CreditNoteReport'
BEGIN 
    IF @Str1='Tariff'
    BEGIN
			   CREATE TABLE #TariffExport(CreatedDate NVARCHAR(100),BookingCode NVARCHAR(100),ChkInVoiceNo NVARCHAR(100),CrdInVoiceNo NVARCHAR(100),
			   PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDate NVARCHAR(100),
			   CheckOutDate NVARCHAR(100),Tariff NVARCHAR(100),NoOfDays NVARCHAR(100),TotalAmount NVARCHAR(100),Description NVARCHAR(100),Flag INT)
			   IF @Id1=0
		       BEGIN
				   SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkInVoiceNo,
				   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
				   CD.Amount AS  Tariff,CD.NoOfDays,(CD.Total+CH.LuxuryTax+CH.ServiceTax1+CH.ServiceTax2) 
				   AS TotalAmount,CH.Description,CH.Id
				   FROM WRBHBCreditNoteTariffDtls CD
				   JOIN WRBHBCreditNoteTariffHdr CH WITH(NOLOCK)ON CD.CrdTariffHdrId=CH.Id AND CH.IsActive=1
				   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
				   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
				   WHERE CD.IsActive=1 AND CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
				   
				   INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
				   '' GuestName,'' CheckInDate,'' CheckOutDate,'' Tariff,'' NoOfDays,'' TotalAmount,'' Description,1
				   
				   INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
				   'CreditNote Tariff Report' GuestName,'' CheckInDate,'' CheckOutDate,'' Tariff,'' NoOfDays,'' TotalAmount,'' Description,3
				   
					INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT 'CreatedDate' CreatedDate,'BookingCode' BookingCode,'ChkInVoiceNo' ChkInVoiceNo,'CrdInVoiceNo' CrdInVoiceNo,
				   'PropertyName' PropertyName,'ClientName' ClientName,
				   'GuestName' GuestName,'CheckInDate' CheckInDate,'CheckOutDate' CheckOutDate,'Tariff' Tariff,'NoOfDays' NoOfDays,
				   'TotalAmount' TotalAmount,'Description' Description,2

				   INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   			   
				   SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkInVoiceNo,
				   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
				   CD.Amount AS  Tariff,CD.NoOfDays,(CD.Total+CH.LuxuryTax+CH.ServiceTax1+CH.ServiceTax2) 
				   AS TotalAmount,CH.Description,4
				   FROM WRBHBCreditNoteTariffDtls CD
				   JOIN WRBHBCreditNoteTariffHdr CH WITH(NOLOCK)ON CD.CrdTariffHdrId=CH.Id AND CH.IsActive=1
				   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
				   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
				   WHERE CD.IsActive=1 AND CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
				   
				   
				   SELECT CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description FROM #TariffExport
				   ORDER BY Flag ASC
				 END 
				 ELSE
				 BEGIN
				   SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkInVoiceNo,
				   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
				   CD.Amount AS  Tariff,CD.NoOfDays,(CD.Total+CH.LuxuryTax+CH.ServiceTax1+CH.ServiceTax2)
					AS TotalAmount,CH.Description,CH.Id
				   FROM WRBHBCreditNoteTariffDtls CD
				   JOIN WRBHBCreditNoteTariffHdr CH WITH(NOLOCK)ON CD.CrdTariffHdrId=CH.Id AND CH.IsActive=1
				   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
				   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
				   WHERE CD.IsActive=1 AND CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
				   AND CH.PropertyId=@Id1
				   
					INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
				   '' GuestName,'' CheckInDate,'' CheckOutDate,'' Tariff,'' NoOfDays,'' TotalAmount,'' Description,1
				   
				   INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
				   'CreditNote Tariff Report' GuestName,'' CheckInDate,'' CheckOutDate,'' Tariff,'' NoOfDays,'' TotalAmount,'' Description,3
				   
					INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   SELECT 'CreatedDate' CreatedDate,'BookingCode' BookingCode,'ChkInVoiceNo' ChkInVoiceNo,'CrdInVoiceNo' CrdInVoiceNo,
				   'PropertyName' PropertyName,'ClientName' ClientName,
				   'GuestName' GuestName,'CheckInDate' CheckInDate,'CheckOutDate' CheckOutDate,'Tariff' Tariff,'NoOfDays' NoOfDays,
				   'TotalAmount' TotalAmount,'Description' Description,2

				   INSERT INTO #TariffExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description,Flag)
				   			   
				   SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkInVoiceNo,
				   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
				   CD.Amount AS  Tariff,CD.NoOfDays,(CD.Total+CH.LuxuryTax+CH.ServiceTax1+CH.ServiceTax2) 
				   AS TotalAmount,CH.Description,4
				   FROM WRBHBCreditNoteTariffDtls CD
				   JOIN WRBHBCreditNoteTariffHdr CH WITH(NOLOCK)ON CD.CrdTariffHdrId=CH.Id AND CH.IsActive=1
				   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
				   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
				   WHERE CD.IsActive=1 AND CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
					AND CH.PropertyId=@Id1
				   
				   SELECT CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
				   GuestName,CheckInDate,CheckOutDate,Tariff,NoOfDays,TotalAmount,Description FROM #TariffExport
				   ORDER BY Flag ASC
	     		END      
    END
    ELSE
    BEGIN
			   CREATE TABLE #ServiceExport(CreatedDate NVARCHAR(100),BookingCode NVARCHAR(100),ChkInVoiceNo NVARCHAR(100),CrdInVoiceNo NVARCHAR(100),
			   PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDate NVARCHAR(100),
			   CheckOutDate NVARCHAR(100),ServiceAmount NVARCHAR(100),TotalAmount NVARCHAR(100),Description NVARCHAR(100),Flag INT)
	   IF @Id1=0
		  BEGIN
		  	   
		  	   SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkOutInVoiceNo AS ChkInVoiceNo,
			   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
			   SUM(CD.ServiceAmount) ServiceAmount,TotalAmount AS TotalAmount,CH.Description,CH.Id
			   FROM WRBHBCreditNoteServiceDtls CD
			   JOIN WRBHBCreditNoteServiceHdr CH WITH(NOLOCK)ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
			   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
			   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
			   WHERE CD.IsActive=1 AND 
			   CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
			   AND CD.Quantity !=0
			   GROUP BY CONVERT(NVARCHAR,CH.CreatedDate,103),B.BookingCode,CH.ChkOutInVoiceNo,TotalAmount,
			   CH.CrdInVoiceNo,C.Property,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,CH.Description,CH.Id
			   
			  				   
			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
			   '' GuestName,'' CheckInDate,'' CheckOutDate,'' ServiceAmount,'' TotalAmount,'' Description,1
			   
			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
			   'CreditNote Service Report' GuestName,'' CheckInDate,'' CheckOutDate,'' ServiceAmount,'' TotalAmount,'' Description,3
			   
				INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT 'CreatedDate' CreatedDate,'BookingCode' BookingCode,'ChkInVoiceNo' ChkInVoiceNo,'CrdInVoiceNo' CrdInVoiceNo,
			   'PropertyName' PropertyName,'ClientName' ClientName,
			   'GuestName' GuestName,'CheckInDate' CheckInDate,'CheckOutDate' CheckOutDate,'ServiceAmount' ServiceAmount,
			   'TotalAmount' TotalAmount,'Description' Description,2

			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   			   
			    SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkOutInVoiceNo AS ChkInVoiceNo,
			   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
			   SUM(CD.ServiceAmount) ServiceAmount,TotalAmount AS TotalAmount,CH.Description,CH.Id
			   FROM WRBHBCreditNoteServiceDtls CD
			   JOIN WRBHBCreditNoteServiceHdr CH WITH(NOLOCK)ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
			   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
			   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
			   WHERE CD.IsActive=1 AND 
			   CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
			   AND CD.Quantity !=0
			   GROUP BY CONVERT(NVARCHAR,CH.CreatedDate,103),B.BookingCode,CH.ChkOutInVoiceNo,TotalAmount,
			   CH.CrdInVoiceNo,C.Property,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,CH.Description,CH.Id
			   
			   SELECT CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description FROM #ServiceExport
			   ORDER BY Flag ASC
			   
			   
		  END 
		  ELSE
		  BEGIN
			    SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkOutInVoiceNo AS ChkInVoiceNo,
			   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
			   SUM(CD.ServiceAmount) ServiceAmount,TotalAmount AS TotalAmount,CH.Description,CH.Id
			   FROM WRBHBCreditNoteServiceDtls CD
			   JOIN WRBHBCreditNoteServiceHdr CH WITH(NOLOCK)ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
			   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
			   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
			   WHERE CD.IsActive=1 AND 
			   CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
			   AND CD.Quantity !=0 AND CH.PropertyId=@Id1
			   GROUP BY CONVERT(NVARCHAR,CH.CreatedDate,103),B.BookingCode,CH.ChkOutInVoiceNo,TotalAmount,
			   CH.CrdInVoiceNo,C.Property,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,CH.Description,CH.Id
			   
			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
			   '' GuestName,'' CheckInDate,'' CheckOutDate,'' ServiceAmount,'' TotalAmount,'' Description,1
			   
			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT '' CreatedDate,'' BookingCode,'' ChkInVoiceNo,'' CrdInVoiceNo,'' PropertyName,'' ClientName,
			   'CreditNote Service Report' GuestName,'' CheckInDate,'' CheckOutDate,'' ServiceAmount,'' TotalAmount,'' Description,3
			   
				INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   SELECT 'CreatedDate' CreatedDate,'BookingCode' BookingCode,'ChkInVoiceNo' ChkInVoiceNo,'CrdInVoiceNo' CrdInVoiceNo,
			   'PropertyName' PropertyName,'ClientName' ClientName,
			   'GuestName' GuestName,'CheckInDate' CheckInDate,'CheckOutDate' CheckOutDate,'ServiceAmount' ServiceAmount,
			   'TotalAmount' TotalAmount,'Description' Description,2

			   INSERT INTO #ServiceExport(CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description,Flag)
			   			   
			    SELECT CONVERT(NVARCHAR,CH.CreatedDate,103) AS CreatedDate,B.BookingCode,CH.ChkOutInVoiceNo AS ChkInVoiceNo,
			   CH.CrdInVoiceNo,C.Property AS PropertyName,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,
			   SUM(CD.ServiceAmount) ServiceAmount,TotalAmount AS TotalAmount,CH.Description,CH.Id
			   FROM WRBHBCreditNoteServiceDtls CD
			   JOIN WRBHBCreditNoteServiceHdr CH WITH(NOLOCK)ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
			   JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON CH.CheckOutId=C.Id AND C.IsActive=1 
			   JOIN WRBHBBooking B WITH(NOLOCK)ON C.BookingId=B.Id AND B.IsActive=1
			   WHERE CD.IsActive=1 AND 
			   CONVERT(date,CH.CreatedDate,103) BETWEEN CONVERT(date,@FromDt,103) AND CONVERT(date,@ToDt,103)
			   AND CD.Quantity !=0 AND CH.PropertyId=@Id1
			   GROUP BY CONVERT(NVARCHAR,CH.CreatedDate,103),B.BookingCode,CH.ChkOutInVoiceNo,TotalAmount,
			   CH.CrdInVoiceNo,C.Property,C.ClientName,C.GuestName,C.CheckInDate,C.CheckOutDate,CH.Description,CH.Id
			   
			   SELECT CreatedDate,BookingCode,ChkInVoiceNo,CrdInVoiceNo,PropertyName,ClientName,
			   GuestName,CheckInDate,CheckOutDate,ServiceAmount,TotalAmount,Description FROM #ServiceExport
			   ORDER BY Flag ASC
		  END 
    END
END
END
