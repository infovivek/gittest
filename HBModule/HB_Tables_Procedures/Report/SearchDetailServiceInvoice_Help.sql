SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SearchDetailServiceInvoice_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SearchDetailServiceInvoice_Help]
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
CREATE PROCEDURE [dbo].[SearchDetailServiceInvoice_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL, 
@Id1 INT=NULL,
@Id2 INT=NULL, 
@UserId INT=NULL
)
AS
--exec SearchDetailServiceInvoice_Help @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'External Property',@Str2=N'',@Id1=0,@Id2=0,@UserId=4
BEGIN
 DECLARE @tmpstr VARCHAR(50), @Net decimal(27,2),@TotalAmt Decimal(27,2);
 DECLARE @Cnt int,@Chkid Bigint=0;Declare @BillType Nvarchar(100)=''
 create table #SepratebyComma(CheckoutId  VARCHAR(50) ,id Int Primary key identity(1,1) )
 Declare @St Decimal(27,2),@Lt Decimal(27,2)
  Declare @CEss Decimal(27,2),@HCess Decimal(27,2),@NDays Bigint
  declare @PanCardNo nvarchar(100);
  DEclare @LOGO  NVARCHAR(MAX);
  SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster where IsActive=1) 
  Create Table #NODays (NoDays Bigint,ChkoutId Bigint)
  Declare @TinNumber Nvarchar(100);
  Declare @CinNumber Nvarchar(100);
  Declare @Propcity  Nvarchar(100);
  
   Create Table #ServiceDtails(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,Cess decimal(27,2),ST decimal(27,2),Hcess decimal(27,2))--,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100))
     Create Table #ServiceDtails1(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100),
            ChkOutSerAmount Decimal(27,2),Quantity Bigint,ProductId bigint,Cess decimal(27,2),ST decimal(27,2),
            Hcess decimal(27,2),OtherService DECIMAL(27,2),MiscellaneousAmount dECIMAL(27,2),ChkOutServiceVat dECIMAL(27,2))
    Create Table #ServiceDtails2(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100),
            ChkOutSerAmount Decimal(27,2),Quantity Bigint,ProductId bigint,Cess decimal(27,2),ST decimal(27,2),
            Hcess decimal(27,2),OtherService dECIMAL(27,2),MiscellaneousAmount DECIMAL(27,2),ChkOutServiceVat dECIMAL(27,2))
          
       
IF @Action ='PAGELOAD' 
 BEGIN 
  	
IF @Str1='' 
 BEGIN
            insert into #ServiceDtails(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId)--,ChkOutSerDate,ServiceItem)
 
			Select Ck.CheckOutNo,Ck.GuestName,sum(Sh.ChkOutServiceNetAmount) Amounts,ck.InVoiceNo InvoiceNumber,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,ck.Property,ck.PropertyId,
			Ck.Id ChkoutId,CK.PropertyType PropertyCat,ck.Status Status,'Service' as BillType,
			Ck.ChkInHdrId as ChkInHdrId,Ck.GuestId,Ck.BookingId BookingId
			--Sd.ChkOutSerDate,ChkOutSerItem ServiceItem
			--cK.ServiceTaxPer,CK.LuxuryTaxPer,CK.C
			FROM WRBHBChechkOutHdr CK
			join WRBHBCheckOutServiceHdr SH WITH(NOLOCK) on  Ck.Id=sh.CheckOutHdrId and sh.IsActive=1 and sh.IsDeleted=0
			 join WRBHBCheckOutServiceDtls SD WITH(NOLOCK) on SH.Id=SD.ServiceHdrId and sd.IsActive=1 and sd.IsDeleted=0
			where isnull(Sh.ChkOutServiceNetAmount,0)!=0 --and isnull(sd.ChkOutSerAmount,0)!=0 
			and Ck.IsActive=1 and ck.IsDeleted=0 and ck.InVoiceNo !=''
			 --and ck.ChkInHdrId in(2242)
			 --and ck.GuestName like '%Pon%'-- Ck.Id=1508-- and Sd.ChkOutSerItem='Tea/Coffee'
			group by Ck.CheckOutNo,Ck.GuestName,--Sh.ChkOutServiceNetAmount ,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,
			ck.Property,ck.PropertyId, Ck.Id, CK.PropertyType ,ck.InVoiceNo,ck.Status,
			Ck.ChkInHdrId ,Ck.GuestId,Ck.BookingId-- ,Sd.ChkOutSerDate,ChkOutSerItem
			order by Ck.Id Desc
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
	--	End	  
		if(@Str2='External')
	 Begin	 
			Select CheckOutNo,GuestName,Amounts,InvoiceNumber,
            CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio 
            from #ServiceDtails where PropertyCat='External Property'
            and InvoiceNumber !='0' 
	 End
		if(@Str2='Internal')
	 begin
			 Select CheckOutNo,GuestName,Amounts,InvoiceNumber as InVoiceNo,
             CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
             ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio,
             CheckInDate ChkinDT,CheckOutDate as ChkoutDT, CheckInDate as ArrivalDate
           	 from #ServiceDtails where PropertyCat='Internal Property'
             
        end 
 	End		
 	end
IF @Str1!='' 
 BEGIN
 DECLARE @id VARCHAR(MAX),@Guestid Bigint,@CityId Bigint, @StateId Bigint;
Declare @BillFrom nvarchar(100),@BillTo nvarchar(100), @CityName NVARCHAR(100),@Property nvarchar(100);
Declare @CessPercent Decimal(27,2),@HECessPercent Decimal(27,2),@STPercent Decimal(27,2),@VATPer Decimal(27,2);
SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,'--@Str1;--
 

WHILE CHARINDEX(',', @id) > 0 
BEGIN 
    
     SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

    INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
    SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id))
    --Select @id,@tmpstr
END 
CREATE TABLE #FinalService(ServiceItem NVARCHAR(100),Amount DECIMAL(27,2),
		ProductId BIGINT,TypeService NVARCHAR(100))
		
  SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
    while @Cnt>0
   begin
			Set @Chkid    = (Select top 1 CheckoutId from  #SepratebyComma  order by Id desc )
			Set @Guestid  = ( Select top 1 Id from  WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @CityId   = ( select top 1 CityId from WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @CityName = ( select top 1 CityName from WRBHBCity where id=@CityId order by Id desc )
			Set @Property = ( select top 1 Property from WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @StateId  = ( select top 1 StateId from WRBHBCity where Id=@CityId )
			Set @BillFrom = ( select top 1 convert(nvarchar(100),ArrivalDate,103)
			from WRBHBCheckInHdr where id=@Chkid   order by Id desc )
			Set @BillTo =(convert(nvarchar(100),getdate(),103));
			--Select * from WRBHBTaxMaster
			--Select @Chkid,@Guestid,@CityId,@CityName,@Property,@StateId,@BillFrom
			Set @CessPercent='2.00';
			Set @HECessPercent='1.00';
			set @VATPer=(Select top 1  VATPer from WRBHBChechkOutHdr where ChkInHdrId=@Chkid )
			set @STPercent=(Select top 1  RestaurantSTPer from WRBHBChechkOutHdr where ChkInHdrId=@Chkid )
			insert into #ServiceDtails1(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,
            ChkOutSerDate,ServiceItem,ChkOutSerAmount,Quantity,ProductId,
            Cess,ST,Hcess,OtherService,MiscellaneousAmount,	ChkOutServiceVat)
 
			Select Ck.CheckOutNo,Ck.GuestName,(Sh.ChkOutServiceNetAmount) Amounts,ck.InVoiceNo InvoiceNumber,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,ck.Property,ck.PropertyId,
			Ck.Id ChkoutId,CK.PropertyType PropertyCat,ck.Status Status,'Service' as BillType,
			Ck.ChkInHdrId as ChkInHdrId,Ck.GuestId,0 BookingId,
			Sd.ChkOutSerDate,sd.ChkOutSerItem ServiceItem,Sd.ChkOutSerAmount,1,sd.ProductId,
			SH.CESS,SH.ChkOutServiceST,SH.HECess,SH.OtherService,sH.MiscellaneousAmount,sH.ChkOutServiceVat
			FROM WRBHBChechkOutHdr CK
			join WRBHBCheckOutServiceHdr SH WITH(NOLOCK) on  Ck.Id=sh.CheckOutHdrId and sh.IsActive=1 and sh.IsDeleted=0
			 join WRBHBCheckOutServiceDtls SD WITH(NOLOCK) on SH.Id=SD.ServiceHdrId and sd.IsActive=1 and sd.IsDeleted=0
			where isnull(Sh.ChkOutServiceNetAmount,0)!=0-- and isnull(sd.ChkOutSerAmount,0)!=0 
			and Ck.IsActive=1 and ck.IsDeleted=0 and ck.InVoiceNo !=''
			 and ck.ChkInHdrId in(@Chkid)
			 --and ck.GuestName like '%Pon%'-- Ck.Id=1508-- and Sd.ChkOutSerItem='Tea/Coffee'
			group by Ck.CheckOutNo,Ck.GuestName,--Sh.ChkOutServiceNetAmount ,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,--Sd.Id ,
			ck.Property,ck.PropertyId, Ck.Id, CK.PropertyType ,ck.InVoiceNo,ck.Status,
			Ck.ChkInHdrId ,Ck.GuestId, Sd.ChkOutSerDate,ChkOutSerItem,Sd.ChkOutSerAmount,sd.ProductId,
			SH.CESS,SH.ChkOutServiceST,SH.HECess,SH.OtherService,sH.MiscellaneousAmount,sH.ChkOutServiceVat,
			Sh.ChkOutServiceNetAmount
			order by Ck.Id Desc
			
			
			--insert into #ServiceDtails1(CheckOutNo,GuestName,InvoiceNumber,
   --         BillDate,ClientId,Property,PropertyId,
   --         ChkoutId,Status,ChkInHdrId,GuestId,ChkOutSerDate,
   --         ServiceItem,ChkOutSerAmount,ProductId)
 
			--Select Ck.CheckOutNo,Ck.GuestName,ck.InVoiceNo InvoiceNumber,
			--ck.BillDate,ck.ClientId,ck.Property,ck.PropertyId,
			--Ck.Id ChkoutId,ck.Status Status,
			--Ck.ChkInHdrId as ChkInHdrId,Ck.GuestId,
			--Sd.ChkOutSerDate,sd.ChkOutSerItem ServiceItem,Sum(Sd.ChkOutSerAmount),sd.ProductId 
			--FROM WRBHBChechkOutHdr CK
		 --	 join WRBHBCheckOutServiceDtls SD WITH(NOLOCK) on Ck.Id=SD.CheckOutServceHdrId and sd.IsActive=1 and sd.IsDeleted=0
			--where isnull(sd.ChkOutSerAmount,0)!=0 
			--and Ck.IsActive=1 and ck.IsDeleted=0 and ck.InVoiceNo !=''
			--  and ck.ChkInHdrId in(@Chkid)
			--group by Ck.CheckOutNo,Ck.GuestName,ck.InVoiceNo ,
			--ck.BillDate,ck.ClientId,ck.Property,ck.PropertyId,
			--Ck.Id,ck.Status ,
			--Ck.ChkInHdrId ,Ck.GuestId,
			--Sd.ChkOutSerDate,sd.ChkOutSerItem,sd.ProductId
			--order by Ck.Id Desc
			--Select * from #ServiceDtails1
			--sELECT * FROM WRBHBCheckOutServiceHdr WHERE Id= 1767
 
INSERT INTO #FinalService(ServiceItem,Amount,ProductId,TypeService) 
exec Sp_CheckoutService1_Help @Action='ProductLoad',@Str1=@Chkid,@CheckInHdrId=@Guestid,
      @StateId=@StateId ,@BillFrom=@BillFrom ,@BillTo= @BillTo ;

--INSERT INTO #FinalService(ServiceItem,Amount,ProductId,TypeService)
--exec Sp_CheckoutService1_Help @Action='ProductLoad',@Str1=2323,@CheckInHdrId=44639,
--@StateId=21 ,@BillFrom='18/11/2014' ,@BillTo='01/12/2014'
 --Select * from	#FinalService
--Select * from #ServiceDtails1
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
		End	 
		
		 insert into #ServiceDtails2(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,ChkOutSerDate,
            ServiceItem,ChkOutSerAmount,Quantity,ProductId,Cess,ST,Hcess,OtherService,
            MiscellaneousAmount,ChkOutServiceVat)
		     Select CheckOutNo,GuestName,Amounts,InvoiceNumber as InVoiceNo,
             CheckInDate+' To '+CheckOutDate Stay, CheckInDate ChkinDT,CheckOutDate as ChkoutDT, 
             BillDate,ClientName,ClientId,Property,PropertyId,
             ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,0 as selectRadio,
            --CheckInDate as ArrivalDate,
             h.ServiceItem as BillDate,h.ServiceItem as Product,
             sum(ChkOutSerAmount) as Price,isnull(sum(ChkOutSerAmount)/(d.Amount),0) Quantity, --Sum(Quantity) as Quantity,
             d.ProductId ,Cess,ST,Hcess,OtherService,MiscellaneousAmount,ChkOutServiceVat
             from #ServiceDtails1 h
             join #FinalService d on h.ProductId=d.ProductId 
             where ChkOutSerAmount!=0
             group by CheckOutNo,GuestName,Amounts,InvoiceNumber,BillDate,ClientName,ClientId,
             Property,PropertyId,ChkInHdrId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,--BookingId,
             CheckInDate,CheckOutDate,CheckInDate,h.ServiceItem,h.ServiceItem,d.ProductId,d.Amount,--,ChkOutSerAmount--,Quantity
             Cess,ST,Hcess,OtherService,MiscellaneousAmount,ChkOutServiceVat
          -- select * from #ServiceDtails1
           dECLARE @TAX DECIMAL(27,2),@TOT DECIMAL(27,2),@NETAMT DECIMAL(27,2),@vAT dECIMAL(27,2)
          SET @TOT=(SELECT SUM(ChkOutSerAmount)FROM  #ServiceDtails1 )
         SET @TAX=(SELECT TOP 1 ( Cess+ST+Hcess+OtherService) FROM  #ServiceDtails1)
         sET @vAT=(SELECT TOP 1 (ChkOutServiceVat) FROM  #ServiceDtails1)
         sET @NETAMT=(@TOT+@TAX+@vAT)
		if(@Str2='External')
	 Begin	 
			Select CheckOutNo,GuestName,Amounts,InvoiceNumber,
            CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio 
            from #ServiceDtails2 where PropertyCat='External Property'
            and InvoiceNumber !='0'
	 End
		if(@Str2='Internal')
	 begin
			 Select CheckOutNo,GuestName,Amounts,InvoiceNumber as InVoiceNo,
             CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
             ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio,
             CheckInDate ChkinDT,CheckOutDate as ChkoutDT, CheckInDate as ArrivalDate,
              ServiceItem as BillDate,ServiceItem as Product,ChkOutSerAmount as Price,Quantity as Quantity,ProductId,
              Cess,ST AS SerivceTax,Hcess,rOUND(@NETAMT,0) AS NetAmount,@vAT AS Vat,
              @CityName AS City,@Property as Propertyaddress,@CessPercent CessPercent,@HECessPercent  HECessPercent,
                      @VATPer as  VATPer,@STPercent as STPercent,
			 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
			 ''+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  ' +'CIN No: U72900KA2005PTC035942' as TaxNo,
			 'INVOICE : For any invoice clarification please revert within 7 days from date of receipt.' as Invoice,
			 'CHEQUE : All Cheque or Demand drafts in payment of bills should be drawn in favour of HummingBird Travel and Stay Pvt.Ltd. and should be crossed "A/C PAYEE ONLY"' as Cheque,
			 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bills after due date' AS Latepay ,
			-- 'PAN NO : AABCH 5874 R, L Tax No : L00100571, TIN : 29340489869' as TaxNo, 
			 'Service Tax Regn. No : AABCH5874RST001,' as ServiceTaxNo,
			 'Taxable Category :Business Support Services and Restaurant Services' as Taxablename,
			 'CIN No: U72900KA2005PTC035942' as CINNo,CONVERT(nvarchar(100),GETDATE(),103) as InVoicedate
			 from #ServiceDtails2 where PropertyCat='Internal Property'
             
     end
			 
 	End		
end 