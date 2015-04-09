-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_InvoiceBill_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_InvoiceBill_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:08-08-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Invoice Bill
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_InvoiceBill_Help](
@Action NVARCHAR(100),
@Pram1	 BIGINT, 
@Pram2	 BIGINT,
@Pram3	 NVARCHAR(100),
@Pram4	 NVARCHAR(100),
@Pram5	 NVARCHAR(100),
@UserId  BIGINT)				
AS
BEGIN
 CREATE TABLE #TempInvoiceBill(CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),BookingCode NVARCHAR(100),  
 InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),  
 CheckOutId BIGINT,SerivceTax7 DECIMAL(27,2),Servicetax12 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),  
 CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),  
 Location NVARCHAR(100),MasterClientName NVARCHAR(100),LuxuryTax DECIMAL(27,2),  
 PropertyId BIGINT,ClientId BIGINT,PropertyType NVARCHAR(100),ExtraAmount DECIMAL(27,2),  
 NoOfDays NVARCHAR(100),PaymentDate NVARCHAR(100),Hcess DECIMAL(27,8),Cess DECIMAL(27,2),  
 Discount DECIMAL(27,2),BookingId BIGINT,CheckInId INT,PrintInvoic INT,Type NVARCHAR(100))  
   
 CREATE TABLE #TempInvoiceBillTotalAmount(CheckOutId BIGINT,TotalAmount DECIMAL(27,2),  
 ChkInHdrId BIGINT)  
   
 CREATE TABLE #TempInvoiceBillTariffAmount(CheckOutId BIGINT,TariffAmount DECIMAL(27,2),  
 ChkInHdrId BIGINT)  
   
 CREATE TABLE #TempInvoiceBillFOODANDBeverages(CheckOutId BIGINT,FOODANDBeverages DECIMAL(27,2),  
 CheckOutServiceHdrId BIGINT,SerivceTax4 DECIMAL(27,2),VAT DECIMAL(27,2),MiscellaneousAmount DECIMAL(27,2))  
   
 CREATE TABLE #TempInvoiceBillBroadband(CheckOutId BIGINT,Broadband DECIMAL(27,2),  
 CheckOutServiceHdrId BIGINT)  
   
 CREATE TABLE #TempInvoiceBillLaundry(CheckOutId BIGINT,Laundry DECIMAL(27,2),  
 CheckOutServiceHdrId BIGINT)  
   
 CREATE TABLE #TempInvoiceBillService(CheckOutId BIGINT,Cess DECIMAL(27,2),HCess DECIMAL(27,2),   
 CheckOutServiceHdrId BIGINT,ChkOutServiceVat DECIMAL(27,2))  
   
 CREATE TABLE #TempBillFinal(CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),BookingCode NVARCHAR(100),  
 InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),GuestName NVARCHAR(100),  
 CheckOutId BIGINT,SerivceTax7 DECIMAL(27,2),Servicetax12 DECIMAL(27,2),ServiceCharge DECIMAL(27,2),  
 CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),  
 Location NVARCHAR(100),MasterClientName NVARCHAR(100),LuxuryTax DECIMAL(27,2),  
 PropertyId BIGINT,ClientId BIGINT,PropertyType NVARCHAR(100),ExtraAmount DECIMAL(27,2),  
 TotalAmount DECIMAL(27,2),TariffAmount DECIMAL(27,2),FOODANDBeverages DECIMAL(27,2),  
 SerivceTax4 DECIMAL(27,2),VAT DECIMAL(27,2),Broadband DECIMAL(27,2),Laundry DECIMAL(27,2),  
 PaymentType NVARCHAR(100),PaymentMode NVARCHAR(100),AcountNo NVARCHAR(100),NoOfDays NVARCHAR(100),  
 PaymentDate NVARCHAR(100),OrderBy NVARCHAR(100),Miscellaneous DECIMAL(27,2),  
 Hcess DECIMAL(27,8),Cess DECIMAL(27,2),Discount DECIMAL(27,2),MarkupAmount DECIMAL(27,2),Type NVARCHAR(100))  
   
 CREATE TABLE #TempInvoiceBillMarkupAmount(CheckOutId BIGINT,MarkupAmount DECIMAL(27,2))  
   
 DECLARE @Count INT;  
   
IF @Action ='InvoiceBill'  
BEGIN  
IF @Pram5='All Properties'  
BEGIN  
  --LOCATION CHECK  
IF @Pram1=0   
BEGIN    
	   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct  
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
	   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
	   
	    INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0 
	   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
	   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id --AND C.Id=@Pram1 
	   AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) 
	   
END  
ELSE  
BEGIN  
	   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
	   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1    
	   
	   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0 
	   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
	   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 
	   AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) 
 END  
 END  
 ELSE  
 IF @Pram5='Internal Property'
 BEGIN  
  --LOCATION CHECK  
IF @Pram1=0   
BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
      
END  
ELSE  
BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
 END    
 END  
 ELSE  
 IF @Pram5='External Property'
 BEGIN  
  --LOCATION CHECK  
IF @Pram1=0   
BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
    INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id --AND C.Id=@Pram1 
   AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103)
END  
ELSE  
BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103)
 END    
 END 
 ---UPDATE TAC INVOCE NO
 UPDATE #TempInvoiceBill SET InVoiceNo=S.TACInvoiceNo from #TempInvoiceBill a
 join WRBHBExternalChechkOutTAC s WITH(NOLOCK) ON A.CheckInId=S.ChkInHdrId AND s.IsActive=1
 WHERE Type='Direct' 
 
 UPDATE #TempInvoiceBill SET GuestName=S.GuestName from #TempInvoiceBill a
 join WRBHBChechkOutHdr s WITH(NOLOCK) ON A.CheckInId=S.ChkInHdrId AND s.IsActive=1
 
 
 --SERVICE CESS,HCHESS,VAT AMOUNT ADD  
 INSERT INTO #TempInvoiceBillService(CheckOutId,Cess,HCess,ChkOutServiceVat)  
 SELECT H.CheckOutHdrId,H.Cess,H.HECess,H.ChkOutServiceVat   
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 AND H.IsActive=1 AND H.IsDeleted=0  
 
  INSERT INTO #TempInvoiceBillService(CheckOutId,Cess,HCess,ChkOutServiceVat)  
 SELECT H.ChkOutHdrId,H.ChkOutTariffCess,H.ChkOutTariffHECess,0 AS ChkOutServiceVat   
 FROM #TempInvoiceBill B  
 JOIN WRBHBExternalChechkOutTAC H WITH(NOLOCK) ON B.CheckOutId=H.ChkOutHdrId AND H.IsActive=1
 AND H.IsActive=1 AND H.IsDeleted=0 AND B.Type='Direct'  
   
   
 UPDATE #TempInvoiceBill SET Cess=B.Cess+S.Cess,HCess=B.Hcess+S.HCess   
 FROM #TempInvoiceBill B  
 JOIN #TempInvoiceBillService S ON S.CheckOutId=B.CheckOutId  
   
 --SUM OF MARKUP   
 INSERT INTO #TempInvoiceBillMarkupAmount(CheckOutId,MarkupAmount)  
 SELECT DISTINCT T.CheckOutId,(-1*B.Markup)*T.NoOfDays AS MarkupAmount FROM #TempInvoiceBill T  
 JOIN WRBHBBookingProperty B ON T.BookingId=B.BookingId AND B.IsActive=1 AND B.IsDeleted=0  
 WHERE  B.Markup<0   
    
 --SUM OF TARIFF AND SERVICE   
 INSERT INTO #TempInvoiceBillTotalAmount(TotalAmount,CheckOutId,ChkInHdrId)  
 SELECT SUM(CSD.BillAmount),H.Id,H.ChkInHdrId   
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0  
 JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND   
 CSD.IsActive=1 AND CSD.IsDeleted=0   
 WHERE H.IsActive=1 AND H.IsDeleted=0 AND CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
 AND CONVERT(DATE,@Pram4,103)  
 GROUP BY H.Id,H.ChkInHdrId  
   
   
 -- TARIFF AMOUNT  
 INSERT INTO #TempInvoiceBillTariffAmount(TariffAmount,CheckOutId,ChkInHdrId)  
 SELECT H.ChkOutTariffTotal,H.Id,H.ChkInHdrId  
 FROM WRBHBChechkOutHdr H   
 WHERE H.IsActive=1 AND H.IsDeleted=0 AND CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
 AND CONVERT(DATE,@Pram4,103)  
  
 --Broadband  
 INSERT INTO #TempInvoiceBillBroadband(Broadband,CheckOutId,CheckOutServiceHdrId)  
 SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,H.Id  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId AND H.IsActive=1 AND H.IsDeleted=0  
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON B.CheckOutId = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 AND LTRIM(UPPER(D.ChkOutSerItem))=LTRIM(UPPER('Broadband'))  
 GROUP BY H.Id,H.CheckOutHdrId  
  
 --FOOD AND Beverages AND SERVICE TAX AND VAT  
 INSERT INTO #TempInvoiceBillFOODANDBeverages(FOODANDBeverages,CheckOutId,CheckOutServiceHdrId,SerivceTax4,
 VAT,MiscellaneousAmount)
 SELECT SUM((ISNULL(D.ChkOutSerAmount,0))),H.CheckOutHdrId,0,
 (ISNULL(cast(ChkOutServiceST as decimal(27,2)),0)+(ISNULL(H.OtherService,0))) SerivceTax4,  
 (ISNULL(ChkOutServiceVat,0)),(ISNULL(H.MiscellaneousAmount,0)) MiscellaneousAmount  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId AND H.IsActive=1 AND H.IsDeleted=0
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON H.Id = D.ServiceHdrId AND D.IsActive=1 AND D.IsDeleted=0
 WHERE D.TypeService='Food And Beverages' 
 GROUP BY H.CheckOutHdrId,ChkOutServiceST,H.OtherService,ChkOutServiceVat,H.MiscellaneousAmount
 
 --SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,0,
 --SUM(ISNULL(cast(ChkOutServiceST as decimal(27,2)),0)) SerivceTax4,  
 --SUM(ISNULL(ChkOutServiceVat,0))  
 --FROM #TempInvoiceBill B  
 --JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId AND H.IsActive=1 AND H.IsDeleted=0  
 --JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON B.CheckOutId = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 --JOIN WRBHBContarctProductMaster P WITH(NOLOCK) ON P.Id = D.ProductId AND P.TypeService='Food And Beverages'  
 --AND P.IsActive=1 AND P.IsDeleted=0  
 --GROUP BY H.CheckOutHdrId   
 
 --Laundry  
 INSERT INTO #TempInvoiceBillLaundry(Laundry,CheckOutId,CheckOutServiceHdrId)  
 SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,H.Id  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId AND H.IsActive=1 AND H.IsDeleted=0  
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON B.CheckOutId = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 JOIN WRBHBContarctProductMaster P WITH(NOLOCK) ON P.Id = D.ProductId AND P.TypeService='Laundry'  
 AND P.IsActive=1 AND P.IsDeleted=0   
 GROUP BY H.Id,H.CheckOutHdrId  
 
 --PROPERTY ID CHECK  
 IF @Pram2=0  
 BEGIN  
 
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,MarkupAmount,
  Type,CheckOutId,Miscellaneous)  
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) AS TotalAmount,  
  ISNULL(TariffAmount,0) TariffAmount,ISNULL(Broadband,0) Broadband,ISNULL(FOODANDBeverages,0) FOODANDBeverages,  
  ISNULL(SerivceTax4,0) SerivceTax4,ISNULL(VAT,0) VAT,ISNULL(Laundry,0) Laundry,ISNULL(ExtraAmount,0) ExtraAmount,  
  'A',ISNULL(Cess,0),ISNULL(Hcess,0),ISNULL(M.MarkupAmount,0),H.Type,H.CheckOutId,ISNULL(MiscellaneousAmount,0) AS Miscellaneous
  FROM #TempInvoiceBill H  
  LEFT OUTER JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId =M.CheckOutId  
  LEFT OUTER JOIN #TempInvoiceBillTotalAmount D ON H.CheckOutId =D.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTariffAmount D1 ON H.CheckOutId =D1.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId   
  GROUP BY CreatedDate, ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName, GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,  
  TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,Cess,Hcess,
  MarkupAmount,H.Type,H.CheckOutId,MiscellaneousAmount  
  
   
  
  ---UPDATE TOTAL AMONT FOR DIRECT MODE
  --UPDATE #TempBillFinal SET TotalAmount=H.ChkOutTariffTotal FROM #TempBillFinal S
  --JOIN WRBHBChechkOutHdr H WITH(NOLOCK) ON S.CheckOutId=H.Id AND S.TotalAmount=0
  
  UPDATE #TempBillFinal SET TotalAmount=T.TACAmount FROM #TempBillFinal S
  JOIN WRBHBChechkOutHdr H WITH(NOLOCK) ON S.CheckOutId=H.Id AND S.Type='Direct'
  join WRBHBExternalChechkOutTAC T WITH(NOLOCK) ON H.ChkInHdrId=T.ChkInHdrId AND T.IsActive=1
  
  UPDATE #TempBillFinal SET TariffAmount=(T.Rate*T.NoOfDays+T.TotalBusinessSupportST) FROM #TempBillFinal S
  JOIN WRBHBChechkOutHdr H WITH(NOLOCK) ON S.CheckOutId=H.Id AND S.Type='Direct'
  join WRBHBExternalChechkOutTAC T WITH(NOLOCK) ON H.ChkInHdrId=T.ChkInHdrId AND T.IsActive=1
  
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,  
   Hcess,MarkupAmount,Type,CheckOutId,Miscellaneous)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'Z',SUM(Cess),SUM(Hcess),  
   SUM(MarkupAmount),'',0,SUM(Miscellaneous)  
   FROM #TempBillFinal  
  END  
    
  SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
 (SerivceTax7+Servicetax12+LuxuryTax+ServiceCharge+TariffAmount+Broadband+FOODANDBeverages+SerivceTax4+VAT+Laundry+ExtraAmount+
 CAST(Cess AS DECIMAL(27,2))+CAST(Hcess AS DECIMAL(27,2))+Miscellaneous) AS TotalAmount,TariffAmount,Broadband,
  FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,  
  CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,0 AS DiscountAmount,Miscellaneous  
  FROM #TempBillFinal 
  ORDER BY OrderBy ,CAST(BookingCode AS BIGINT) ASC   
  
 END  
 ELSE  
 BEGIN  
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,  
  MarkupAmount,Type,CheckOutId,Miscellaneous)  
    
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,  
  ISNULL(TariffAmount,0) TariffAmount,ISNULL(Broadband,0) Broadband,ISNULL(FOODANDBeverages,0) FOODANDBeverages,  
  ISNULL(SerivceTax4,0) SerivceTax4,ISNULL(VAT,0) VAT,ISNULL(Laundry,0) Laundry,
  ISNULL(ExtraAmount,0) ExtraAmount,'A',ISNULL(Cess,0),ISNULL(Hcess,0),ISNULL(M.MarkupAmount,0),H.Type,H.CheckOutId
  ,ISNULL(MiscellaneousAmount,0) Miscellaneous  
  FROM #TempInvoiceBill H  
  LEFT OUTER JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId =M.CheckOutId  
  LEFT OUTER JOIN #TempInvoiceBillTotalAmount D ON H.CheckOutId =D.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTariffAmount D1 ON H.CheckOutId =D1.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId  
  WHERE H.PropertyId=@Pram2  
  GROUP BY CreatedDate, ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName, GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,  
  TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,Cess,Hcess,MarkupAmount,
  H.Type,H.CheckOutId,MiscellaneousAmount  
    
  ---UPDATE TOTAL AMONT FOR DIRECT MODE
  UPDATE #TempBillFinal SET TotalAmount=T.TACAmount FROM #TempBillFinal S
  JOIN WRBHBChechkOutHdr H WITH(NOLOCK) ON S.CheckOutId=H.Id AND S.Type='Direct' 
  join WRBHBExternalChechkOutTAC T WITH(NOLOCK) ON H.ChkInHdrId=T.ChkInHdrId AND T.IsActive=1
  
  UPDATE #TempBillFinal SET TariffAmount=(T.Rate*T.NoOfDays+T.TotalBusinessSupportST) FROM #TempBillFinal S
  JOIN WRBHBChechkOutHdr H WITH(NOLOCK) ON S.CheckOutId=H.Id AND S.Type='Direct' 
  join WRBHBExternalChechkOutTAC T WITH(NOLOCK) ON H.ChkInHdrId=T.ChkInHdrId AND T.IsActive=1
  
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,  
   Hcess,MarkupAmount,Type,CheckOutId,Miscellaneous)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'Z',SUM(Cess),SUM(Hcess),  
   SUM(MarkupAmount),'',0,SUM(Miscellaneous)    
   FROM #TempBillFinal  
  END  
  --SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  --GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  --TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,  
  --CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,MarkupAmount AS DiscountAmount  
  --FROM #TempBillFinal  

  
  SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,NoOfDays,PaymentDate,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  (SerivceTax7+Servicetax12+LuxuryTax+ServiceCharge+TariffAmount+Broadband+FOODANDBeverages+SerivceTax4+VAT+Laundry+ExtraAmount+CAST(Cess AS DECIMAL(27,2))+
  CAST(Hcess AS DECIMAL(27,2))+Miscellaneous) AS TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,  
  PaymentMode,AcountNo,CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,0 AS DiscountAmount,Miscellaneous  
  FROM #TempBillFinal
  ORDER BY OrderBy ,CAST(BookingCode AS BIGINT) ASC  
    
 END   
END  


IF @Action ='UnSettled'  
BEGIN  
 IF @Pram5='All Properties'  
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled' 
   
      
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id --AND C.Id=@Pram1
    AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'
  END  
  ELSE  
  BEGIN  
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1
    AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   
  END  
 END  
 ELSE  
 IF @Pram5='Internal Property'
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
     
  END  
  ELSE  
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   
    
  END    
 END
 ELSE  
 IF @Pram5='External Property'
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id --AND C.Id=@Pram1
    AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'
  END  
  ELSE  
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   
    INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess)  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
   ChkOutTariffHECess    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled' 
  END    
 END
   
 --SERVICE CESS,HCHESS,VAT AMOUNT ADD  
 INSERT INTO #TempInvoiceBillService(CheckOutId,Cess,HCess,ChkOutServiceVat)  
 SELECT H.CheckOutHdrId,H.Cess,H.HECess,H.ChkOutServiceVat   
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 AND H.IsActive=1 AND H.IsDeleted=0  
   
 UPDATE #TempInvoiceBill SET GuestName=S.GuestName from #TempInvoiceBill a
 join WRBHBChechkOutHdr s WITH(NOLOCK) ON A.CheckInId=S.ChkInHdrId AND s.IsActive=1
  
 UPDATE #TempInvoiceBill SET Cess=B.Cess+S.Cess,HCess=B.Hcess+S.HCess   
 FROM #TempInvoiceBill B  
 JOIN #TempInvoiceBillService S ON S.CheckOutId=B.CheckOutId  
   
 --SUM OF TARIFF AND SERVICE   
 INSERT INTO #TempInvoiceBillTotalAmount(TotalAmount,CheckOutId,ChkInHdrId)  
 SELECT SUM(CSD.BillAmount),H.Id,H.ChkInHdrId   
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBCheckOutSettleHdr  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND CSH.IsActive=1 AND CSH.IsDeleted=0  
 JOIN WRBHBCheckOutSettleDtl  CSD WITH(NOLOCK) ON CSD.CheckOutSettleHdrId=CSH.Id AND CSD.IsActive=1 AND CSD.IsDeleted=0   
 WHERE H.IsActive=1 AND H.IsDeleted=0 AND CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
 AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
 GROUP BY H.Id,H.ChkInHdrId  
    
 -- TARIFF AMOUNT  
 INSERT INTO #TempInvoiceBillTariffAmount(TariffAmount,CheckOutId,ChkInHdrId)  
 SELECT h.ChkOutTariffTotal,H.Id,H.ChkInHdrId  
 FROM WRBHBChechkOutHdr H   
 WHERE H.IsActive=1 AND H.IsDeleted=0 AND CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
 AND CONVERT(DATE,@Pram4,103) AND H.Status='UnSettled'  
   --Broadband  
 INSERT INTO #TempInvoiceBillBroadband(Broadband,CheckOutId,CheckOutServiceHdrId)  
 SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,H.Id  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON H.Id = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 AND LTRIM(UPPER(D.ChkOutSerItem))=LTRIM(UPPER('Broadband'))  
 GROUP BY H.Id,H.CheckOutHdrId  
  
 --FOOD AND Beverages AND SERVICE TAX AND VAT  
 INSERT INTO #TempInvoiceBillFOODANDBeverages(FOODANDBeverages,CheckOutId,CheckOutServiceHdrId,SerivceTax4,VAT,MiscellaneousAmount)  
 SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,H.Id,ChkOutServiceST SerivceTax4,ChkOutServiceVat,MiscellaneousAmount  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON B.CheckOutId = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 JOIN WRBHBContarctProductMaster P WITH(NOLOCK) ON P.Id = D.ProductId AND P.TypeService='Food And Beverages'  
 AND P.IsActive=1 AND P.IsDeleted=0  
 GROUP BY H.Id,H.CheckOutHdrId,ChkOutServiceST ,ChkOutServiceVat,MiscellaneousAmount  
  
  
 --Laundry  
 INSERT INTO #TempInvoiceBillLaundry(Laundry,CheckOutId,CheckOutServiceHdrId)  
 SELECT SUM(ISNULL(D.ChkOutSerAmount,0)),H.CheckOutHdrId,H.Id  
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 JOIN  WRBHBCheckOutServiceDtls D WITH(NOLOCK) ON B.CheckOutId = D.CheckOutServceHdrId AND D.IsActive=1 AND D.IsDeleted=0  
 JOIN WRBHBContarctProductMaster P WITH(NOLOCK) ON P.Id = D.ProductId AND P.TypeService='Laundry'  
 AND P.IsActive=1 AND P.IsDeleted=0  
 GROUP BY H.Id,H.CheckOutHdrId   
  
   
 --PROPERTY ID CHECK  
 IF @Pram2=0  
 BEGIN  
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,  
  MarkupAmount,Miscellaneous)  
    
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,  
  ISNULL(TariffAmount,0) TariffAmount,ISNULL(Broadband,0) Broadband,ISNULL(FOODANDBeverages,0) FOODANDBeverages,  
  ISNULL(SerivceTax4,0) SerivceTax4,ISNULL(VAT,0) VAT,ISNULL(Laundry,0) Laundry, 
  ISNULL(ExtraAmount,0) ExtraAmount,'A',ISNULL(Cess,0),ISNULL(Hcess,0),ISNULL(M.MarkupAmount,0),
  ISNULL(MiscellaneousAmount,0) Miscellaneous   
  FROM #TempInvoiceBill H  
  JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId =M.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTotalAmount D ON H.CheckOutId =D.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTariffAmount D1 ON H.CheckOutId =D1.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId   
  GROUP BY CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName,GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,MiscellaneousAmount,  
  TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,Cess,Hcess,MarkupAmount  
    
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,Miscellaneous)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'Z',SUM(Cess),SUM(Hcess),SUM(Miscellaneous)    
   FROM #TempBillFinal  
  END  
  SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  (SerivceTax7+Servicetax12+LuxuryTax+ServiceCharge+TariffAmount+Broadband+FOODANDBeverages+SerivceTax4+VAT+Laundry+ExtraAmount+CAST(Cess AS DECIMAL(27,2))+
  CAST(Hcess AS DECIMAL(27,2))+Miscellaneous) AS TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,  
  CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,MarkupAmount AS DiscountAmount,Miscellaneous  
  FROM #TempBillFinal  
  ORDER BY OrderBy ,CAST(BookingCode AS BIGINT)ASC  
    
 END  
 ELSE  
 BEGIN  
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,  
  MarkupAmount,Miscellaneous)  
    
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,  
  ISNULL(TariffAmount,0) TariffAmount,ISNULL(Broadband,0) Broadband,ISNULL(FOODANDBeverages,0) FOODANDBeverages,  
  ISNULL(SerivceTax4,0) SerivceTax4,ISNULL(VAT,0) VAT,ISNULL(Laundry,0) Laundry,
  ISNULL(ExtraAmount,0) ExtraAmount,'A',ISNULL(Cess,0),ISNULL(Hcess,0),ISNULL(M.MarkupAmount,0) ,
  ISNULL(MiscellaneousAmount,0) Miscellaneous  
  FROM #TempInvoiceBill H  
  JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId =M.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTotalAmount D ON H.CheckOutId =D.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillTariffAmount D1 ON H.CheckOutId =D1.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillBroadband D2 ON H.CheckOutId =D2.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillFOODANDBeverages D3 ON H.CheckOutId =D3.CheckOutId   
  LEFT OUTER JOIN #TempInvoiceBillLaundry D4 ON H.CheckOutId =D4.CheckOutId  
  WHERE H.PropertyId=@Pram2  
  GROUP BY CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName,GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount, MiscellaneousAmount, 
  TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,Cess,Hcess,MarkupAmount  
    
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,OrderBy,Cess,Hcess,Miscellaneous)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'Z',SUM(Cess),SUM(Hcess),SUM(Miscellaneous)    
   FROM #TempBillFinal  
  END  
    
 SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,NoOfDays,PaymentDate,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  (SerivceTax7+Servicetax12+ServiceCharge+LuxuryTax+TariffAmount+Broadband+FOODANDBeverages+SerivceTax4+VAT+Laundry+ExtraAmount+CAST(Cess AS DECIMAL(27,2))+
  CAST(Hcess AS DECIMAL(27,2))) AS TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,  
  PaymentMode,AcountNo,CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,0 AS DiscountAmount,Miscellaneous  
  FROM #TempBillFinal 
  ORDER BY OrderBy ,CAST(BookingCode AS BIGINT)  ASC  
    
 END   
END  
IF @Action ='Contract Bill'  
BEGIN  
  CREATE TABLE #ContractBill(ClientName NVARCHAR(100),RentelAmount DECIMAL(27,2),RentDate NVARCHAR(100),  
  Type NVARCHAR(100),Tax DECIMAL(27,2),TotalAmount DECIMAL(27,2),InvoiceNo NVARCHAR(100),  
  AdjustmentAmount DECIMAL(27,2),CreatedDate NVARCHAR(100),ModifiedDate NVARCHAR(100),OrderBy NVARCHAR(100) )  
    
  INSERT INTO #ContractBill(ClientName,RentelAmount,RentDate ,Type,Tax,TotalAmount,InvoiceNo,  
  AdjustmentAmount,CreatedDate,ModifiedDate,OrderBy)  
    
        SELECT ClientName,RentelAmount,CONVERT(NVARCHAR,RentDate,103) RentDate,Type,  
        ISNULL(Tax,0) Tax,ISNULL(TotalAmount,0) TotalAmount,ISNULL(InvoiceNo,'') InvoiceNo,  
        ISNULL(AdjustmentAmount,0) AdjustmentAmount,CONVERT(NVARCHAR,CreatedDate,103),  
        CONVERT(NVARCHAR,ModifiedDate,103),'A'           
        FROM WRBHBInvoiceManagedGHAmount  
        WHERE MONTH(CONVERT(DATE,RentDate,103))  
        BETWEEN MONTH(CONVERT(DATE,@Pram3,103)) AND MONTH(CONVERT(DATE,@Pram4,103))  
        AND YEAR(CONVERT(DATE,RentDate,103))=YEAR(CONVERT(DATE,@Pram3,103))   
        GROUP BY ClientName,RentelAmount,RentDate,Type,  
        Tax,TotalAmount,InvoiceNo,AdjustmentAmount,CreatedDate,ModifiedDate  
          
        INSERT INTO #ContractBill(ClientName,RentelAmount,RentDate ,Type,Tax,TotalAmount,InvoiceNo,AdjustmentAmount,  
        CreatedDate,ModifiedDate,OrderBy)   
        SELECT 'Total',SUM(RentelAmount),'' ,'',SUM(Tax),SUM(TotalAmount),'',SUM(AdjustmentAmount),'','','Z'   
        FROM #ContractBill  
          
          
        SELECT ClientName,RentelAmount,RentDate,Type,Tax,TotalAmount,InvoiceNo,AdjustmentAmount,  
        CONVERT(NVARCHAR,CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,ModifiedDate,103) ModifiedDate  
        FROM #ContractBill  
        ORDER BY OrderBy ASC  
                
END  
IF @Action ='Receipts Bill'  
BEGIN  
 IF @Pram5='All Properties'  
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct  
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
	   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
	   
	  INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0 
	   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
	   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id --AND C.Id=@Pram1 
	   AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) 
	  END  
	  ELSE  
	  BEGIN  
	   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
	   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1    
	   
	   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
	   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
	   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
	   PrintInvoic ,Type )  
	  
	   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
	   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
	   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
	   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
	   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,ChkOutTariffCess,  
	   ChkOutTariffHECess,H.NoOfDays,B.Id ,H.ChkInHdrId,H.PrintInvoice,H.Direct   
	   FROM WRBHBChechkOutHdr H  
	   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0 
	   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
	   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 
	   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId 
	   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 
	   AND C.IsActive=1 AND C.IsDeleted=0  
	   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
	   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
	   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
	   AND CONVERT(DATE,@Pram4,103) 
  END  
 END  
 ELSE  
 IF @Pram5='Internal Property'
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
     
  END  
  ELSE  
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
   
   
  END    
 END  
ELSE  
IF @Pram5='External Property'
 BEGIN  
  --LOCATION CHECK  
  IF @Pram1=0   
  BEGIN   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,ChkOutTariffCess,  
   ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct    
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category='External Property'  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   H.Direct !='Direct' AND
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
    INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND --C.Id=@Pram1 AND 
   C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103)
   
  END  
  ELSE  
  BEGIN    
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,P.PropertyName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,P.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND P.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId AND CC.Id=P.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND    H.Direct !='Direct' AND
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) --AND H.Flag=1   
   
   INSERT INTO #TempInvoiceBill(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
   MasterClientName,GuestName,CheckOutId,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,  
   BillStartDate,BillEndDate,Location,LuxuryTax,ExtraAmount,PropertyId,Cess,Hcess,NoOfDays,BookingId,CheckInId,
   PrintInvoic ,Type )  
   SELECT CONVERT(NVARCHAR,H.CreatedDate,103) CreatedDate,  
   CONVERT(NVARCHAR,H.ModifiedDate,103) ModifiedDate,  
   BookingCode,H.InVoiceNo,S.HotalName,C.ClientName,MC.ClientName,H.GuestName,H.Id,  
   ChkOutTariffST1  SerivceTax7,ChkOutTariffST3 AS Servicetax12,ChkOutTariffSC Servicecharge,  
   CONVERT(NVARCHAR,H.CheckInDate,103),CONVERT(NVARCHAR,H.CheckOutDate,103),  
   CONVERT(NVARCHAR,BillFromDate,103),  
   CONVERT(NVARCHAR,BillEndDate,103),CC.CityName,ChkOutTariffLT,ChkOutTariffExtraAmount,CC.Id,  
   ChkOutTariffCess,ChkOutTariffHECess,H.NoOfDays,B.Id,H.ChkInHdrId,H.PrintInvoice,H.Direct   
   FROM WRBHBChechkOutHdr H  
   JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1 AND B.IsDeleted=0  
   join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON B.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0 
   join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0 -- AND B.Category=@Pram5  
   JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=B.CityId  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0  
   JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id  AND MC.IsActive=1 AND MC.IsDeleted=0  
   WHERE H.IsActive=1 AND H.IsDeleted=0 AND   
   CONVERT(DATE,H.CreatedDate,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103)
   
  END    
 END 
 
UPDATE #TempInvoiceBill SET GuestName=S.GuestName from #TempInvoiceBill a
 join WRBHBChechkOutHdr s WITH(NOLOCK) ON A.CheckInId=S.ChkInHdrId AND s.IsActive=1
 
 
 --SERVICE CESS,HCHESS,VAT AMOUNT ADD  
 INSERT INTO #TempInvoiceBillService(CheckOutId,Cess,HCess,ChkOutServiceVat)  
 SELECT H.CheckOutHdrId,H.Cess,H.HECess,H.ChkOutServiceVat   
 FROM #TempInvoiceBill B  
 JOIN WRBHBCheckOutServiceHdr H WITH(NOLOCK) ON B.CheckOutId=H.CheckOutHdrId  
 AND H.IsActive=1 AND H.IsDeleted=0  
  
   
 UPDATE #TempInvoiceBill SET Cess=B.Cess+S.Cess,HCess=B.Hcess+S.HCess   
 FROM #TempInvoiceBill B  
 JOIN #TempInvoiceBillService S ON S.CheckOutId=B.CheckOutId  
   
 CREATE TABLE #TempReceiptBill(TotalAmount DECIMAL(27,2),PaymentType NVARCHAR(100),CheckOutId BIGINT,  
 PaymentMode NVARCHAR(100),AcountNo NVARCHAR(100),PaymentDate NVARCHAR(100))   
    
 --CASH   
 INSERT INTO #TempReceiptBill(TotalAmount,PaymentType,PaymentMode,CheckOutId,AcountNo,PaymentDate)  
 SELECT CSH.AmountPaid,CSH.Payment,CSH.PaymentMode,H.Id,'',CashReceivedOn   
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBChechkOutPaymentCash  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND   
 CSH.IsActive=1 AND CSH.IsDeleted=0  
   
 --Card   
 INSERT INTO #TempReceiptBill(TotalAmount,PaymentType,PaymentMode,CheckOutId,AcountNo,PaymentDate)  
 SELECT CSH.AmountPaid,CSH.Payment,CSH.CCBrand,H.Id,SOCBatchCloseNo,CONVERT(NVARCHAR,CSH.CreatedDate,103)  
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBChechkOutPaymentCard  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND   
 CSH.IsActive=1 AND CSH.IsDeleted=0  
   
 --Cheque   
 INSERT INTO #TempReceiptBill(TotalAmount,PaymentType,PaymentMode,CheckOutId,AcountNo,PaymentDate)  
 SELECT CSH.AmountPaid,CSH.Payment,CSH.PaymentMode,H.Id,ChequeNumber,CONVERT(NVARCHAR,CSH.CreatedDate,103)  
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBChechkOutPaymentCheque  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND   
 CSH.IsActive=1 AND CSH.IsDeleted=0  
   
   
 --CompanyInvoice   
 INSERT INTO #TempReceiptBill(TotalAmount,PaymentType,PaymentMode,CheckOutId,AcountNo,PaymentDate)  
 SELECT CSH.AmountPaid,CSH.Payment,CSH.PaymentMode,H.Id,'',CONVERT(NVARCHAR,CSH.CreatedDate,103)  
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBChechkOutPaymentCompanyInvoice  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND   
 CSH.IsActive=1 AND CSH.IsDeleted=0  
   
 --NEFT   
 INSERT INTO #TempReceiptBill(TotalAmount,PaymentType,PaymentMode,CheckOutId,AcountNo,PaymentDate)  
 SELECT CSH.AmountPaid,CSH.Payment,CSH.PaymentMode,H.Id,ReferenceNumber,CONVERT(NVARCHAR,CSH.CreatedDate,103)  
 FROM WRBHBChechkOutHdr H  
 JOIN WRBHBChechkOutPaymentNEFT  CSH WITH(NOLOCK) ON CSH.ChkOutHdrId=H.Id AND   
 CSH.IsActive=1 AND CSH.IsDeleted=0  
   
  
 --PROPERTY ID CHECK  
 IF @Pram2=0  
 BEGIN  
    
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,ExtraAmount,PaymentType,PaymentMode,AcountNo,NoOfDays,PaymentDate,OrderBy,Cess,Hcess,MarkupAmount)  
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,  
  ISNULL(ExtraAmount,0) ExtraAmount,ISNULL(PaymentType,''),ISNULL(PaymentMode,''),ISNULL(AcountNo,''),  
  NoOfDays,D.PaymentDate,'A',ISNULL(Cess,0),ISNULL(Hcess,0),M.MarkupAmount  
  FROM #TempInvoiceBill H  
  LEFT OUTER JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId=M.CheckOutId  
  LEFT OUTER JOIN #TempReceiptBill D ON H.CheckOutId =D.CheckOutId   
  GROUP BY CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName,GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,  
  ExtraAmount,PaymentType,PaymentMode,AcountNo,NoOfDays,D.PaymentDate,Cess,Hcess,MarkupAmount  
   
      
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
    
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,PaymentMode,AcountNo,  
   NoOfDays,PaymentDate,OrderBy,Cess,Hcess,MarkupAmount)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'','','',  
   SUM(CAST(NoOfDays AS BIGINT)),'','Z',SUM(Cess),SUM(Hcess),SUM(MarkupAmount)  
   FROM #TempBillFinal  
  END  
    
    
  SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,NoOfDays,PaymentDate,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,  
  PaymentMode,AcountNo,CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,MarkupAmount AS DiscountAmount  
  FROM #TempBillFinal  
  ORDER BY OrderBy,CAST(BookingCode AS BIGINT) ASC   
 END  
 ELSE  
 BEGIN  
  INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,ExtraAmount,PaymentType,PaymentMode,AcountNo,NoOfDays,PaymentDate,OrderBy,Cess,Hcess,MarkupAmount)  
    
  SELECT ISNULL(CreatedDate,'') CreatedDate,ISNULL(ModifiedDate,'') ModifiedDate,ISNULL(BookingCode,'') BookingCode,  
  ISNULL(InVoiceNo,'') InVoiceNo,ISNULL(PropertyName,'') PropertyName,ISNULL(ClientName,'') ClientName,  
  ISNULL(MasterClientName,'') MasterClientName,ISNULL(GuestName,'') GuestName,ISNULL(SerivceTax7,0) SerivceTax7,  
  ISNULL(Servicetax12,0) Servicetax12,ISNULL(ServiceCharge,0) ServiceCharge,ISNULL(CheckInDate,'') CheckInDate,  
  ISNULL(CheckOutDate,'') CheckOutDate,ISNULL(BillStartDate,'') BillStartDate,ISNULL(BillEndDate,'') BillEndDate,  
  ISNULL(Location,'') Location,ISNULL(LuxuryTax,0) LuxuryTax,ISNULL(TotalAmount,0) TotalAmount,  
  ISNULL(ExtraAmount,0) ExtraAmount,ISNULL(PaymentType,''),ISNULL(PaymentMode,''),ISNULL(AcountNo,''),  
  NoOfDays,D.PaymentDate,'A',ISNULL(Cess,0),ISNULL(Hcess,0),M.MarkupAmount  
  FROM #TempInvoiceBill H  
  LEFT OUTER JOIN #TempInvoiceBillMarkupAmount M ON H.CheckOutId=M.CheckOutId  
  LEFT OUTER JOIN #TempReceiptBill D ON H.CheckOutId =D.CheckOutId     
  WHERE H.PropertyId=@Pram2  
  GROUP BY CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,  
  MasterClientName,GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,  
  CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,TotalAmount,  
  ExtraAmount,PaymentType,PaymentMode,AcountNo,NoOfDays,D.PaymentDate,Cess,Hcess,MarkupAmount  
  
     
  SELECT @Count=COUNT(* ) FROM #TempBillFinal  
    
  IF @Count!=0  
  BEGIN  
   INSERT INTO #TempBillFinal(CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,  
   GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
   TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,PaymentMode,AcountNo,  
   NoOfDays,PaymentDate,OrderBy,Cess,Hcess,MarkupAmount)  
     
   SELECT 'Total','','','','','','','',SUM(SerivceTax7),SUM(Servicetax12),SUM(ServiceCharge),'','','',  
   '','',SUM(LuxuryTax),SUM(TotalAmount),SUM(TariffAmount),SUM(Broadband),  
   SUM(FOODANDBeverages),SUM(SerivceTax4),SUM(VAT),SUM(Laundry),SUM(ExtraAmount),'','','',  
   SUM(CAST(NoOfDays AS BIGINT)),'','Z',SUM(Cess),SUM(Hcess),SUM(MarkupAmount)  
   FROM #TempBillFinal  
  END   
    
  SELECT CreatedDate,ModifiedDate,BookingCode,InVoiceNo,PropertyName,ClientName,MasterClientName,NoOfDays,PaymentDate,  
  GuestName,SerivceTax7,Servicetax12,ServiceCharge,CheckInDate,CheckOutDate,BillStartDate,BillEndDate,Location,LuxuryTax,  
  TotalAmount,TariffAmount,Broadband,FOODANDBeverages,SerivceTax4,VAT,Laundry,ExtraAmount,PaymentType,  
  PaymentMode,AcountNo,CAST(Cess AS DECIMAL(27,2)) Cess,CAST(Hcess AS DECIMAL(27,2)) Hcess,0 AS DiscountAmount  
  FROM #TempBillFinal  
    
  ORDER BY OrderBy,CAST(BookingCode AS BIGINT)ASC  
    
 END   
END  
END  
  
  
  
  
 