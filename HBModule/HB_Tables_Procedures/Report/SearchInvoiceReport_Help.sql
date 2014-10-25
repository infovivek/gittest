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
IF @Action ='Pageload'
   BEGIN 
   
   
    --   drop table  #TempInvoiceBillTotalAmount; 
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


       INSERT INTO #TempBillFinal1(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,
		GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,
		TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,
		BillAmount,BillType,BillId,PropertyId,PrintInvoice)
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
		--LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId 
		--LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId 
		--LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId 
	--	where   InVoiceNo like '%HBE%'
		GROUP BY CreatedDate, ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,
		MasterClientName, GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,
		CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,
		TariffAmount,--Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,
		ExtraAmount,Cess,Hcess,D.BillAmount,D.BillType,H.CheckOutId,PropertyId,PrintInvoice
		
		
		DECLARE @Count INT;
		SELECT @Count=COUNT(* ) FROM #TempBillFinal1 
		
		if(@Str1='')
		begin
		SELECT BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+Location Property,ClientName ClientName, 
		GuestName GuestName,CONVERT(NVARCHAR,CheckInDate,103) AS CheckInDate,
		 CONVERT(NVARCHAR,CheckOutDate,103) AS CheckOutDate,Location,
		TotalAmount,TariffAmount Amount,BillAmount Amounts,BillType BillType,BillId ChkoutId,
		0 as selectRadio ,'CheckOut'Status,'Internal Property' as PropertyCat
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
				GuestName GuestName,CONVERT(NVARCHAR,CheckInDate,103) AS CheckInDate,
		 CONVERT(NVARCHAR,CheckOutDate,103) AS CheckOutDate,''Location,
				''TotalAmount,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,'Tariff' BillType,f.Id ChkoutId,
				0 as selectRadio ,'CheckOut'Status,'External Property' as PropertyCat
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
				SELECT '0'BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+cc.CityName Property,ClientName ClientName, 
				GuestName GuestName,CONVERT(NVARCHAR,CheckInDate,103) AS CheckInDate,
		 CONVERT(NVARCHAR,CheckOutDate,103) AS CheckOutDate,''Location,
				''TotalAmount,ChkOutTariffTotal Amount,ChkOutTariffNetAmount Amounts,'Tariff' BillType,f.Id ChkoutId,
				0 as selectRadio ,'CheckOut'Status,'External Property' as PropertyCat
				FROM WRBHBChechkOutHdr f
				join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1
				JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId and cc.IsActive=1  
				where    InVoiceNo!='0' and  InVoiceNo!=''
				ORDER BY   f.Id desc 
			end
       end
       if(@Str1='Internal Property')
		begin
		SELECT BookingCode,InVoiceNo InvoiceNumber,p.PropertyName+'-'+Location Property,ClientName ClientName, 
		GuestName GuestName,CONVERT(NVARCHAR,CheckInDate,103) AS CheckInDate,
		 CONVERT(NVARCHAR,CheckOutDate,103) AS CheckOutDate,Location,
		TotalAmount,TariffAmount Amount,BillAmount Amounts,BillType BillType,BillId ChkoutId,
		0 as selectRadio ,'CheckOut'Status,'Internal Property' as PropertyCat
		FROM #TempBillFinal1 f
		join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and  p.Category=@Str1
		 where BillAmount!=0  and InVoiceNo!='0'-- and  PrintInvoice=0
		ORDER BY   BillId desc 
       end
       if(@Str1='TAC')
		begin 
		if(@FromDt!='')and(@ToDt!='')
	    Begin 
			SELECT CT.Id as ChkoutId,CT.TACInvoiceNo InvoiceNumber,P.PropertyName Property,
			--round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST+CT.TACAmount,0) as Amount ,
			CT.MarkupAmount  as Amount,
			CT.TACAmount Amounts,C.GuestName AS GuestName ,C.ClientName AS ClientName,
			CONVERT(NVARCHAR,CT.CheckInDate,103) AS CheckInDate,
			CONVERT(NVARCHAR,CT.CheckOutDate,103) AS CheckOutDate,--ct.NoOfDays,ct.Rate,
			0 as selectRadio ,'CheckOut'Status,'TAC' as PropertyCat,'Tariff' BillType
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
				SELECT CT.Id as ChkoutId,CT.TACInvoiceNo InvoiceNumber,P.PropertyName Property,
				--round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST,0) as Amount,
				CT.MarkupAmount  as Amount,
				CT.TACAmount Amounts,C.GuestName AS GuestName ,C.ClientName AS ClientName,
				CONVERT(NVARCHAR,CT.CheckInDate,103) AS CheckInDate,
				CONVERT(NVARCHAR,CT.CheckOutDate,103) AS CheckOutDate,--ct.NoOfDays,ct.Rate,
				0 as selectRadio ,'CheckOut'Status,'TAC' as PropertyCat,'Tariff' BillType 
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
END


