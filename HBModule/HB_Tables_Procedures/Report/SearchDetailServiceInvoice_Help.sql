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
@Str1 NVARCHAR(100)=NULL,--This is checkoutId
@Str2 NVARCHAR(100)=NULL, 
@Id1 INT=NULL,--This is CheckinId
@Id2 INT=NULL, 
@UserId INT=NULL
)
AS
--exec SearchDetailServiceInvoice_Help @Action=N'PAGELOAD',@Str1=N'3113,',@Str2=N'External',@Id1=0,@Id2=0
BEGIN
 DECLARE @tmpstr VARCHAR(50), @Net DECIMAL(27,2),@TotalAmt DECIMAL(27,2);
 DECLARE @Cnt int,@Chkid BIGINT=0;DECLARE @BillType Nvarchar(100)=''
 CREATE TABLE #SepratebyComma(CheckoutId  VARCHAR(50) ,id Int Primary key identity(1,1) )
 DECLARE @St DECIMAL(27,2),@Lt DECIMAL(27,2)
 DECLARE @CEss DECIMAL(27,2),@HCess DECIMAL(27,2),@NDays BIGINT
 DECLARE @PanCardNo NVARCHAR(100);
 DECLARE @LOGO  NVARCHAR(MAX);
 SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster where IsActive=1) 
 CREATE TABLE #NODays (NoDays BIGINT,ChkoutId BIGINT)
 DECLARE @TinNumber NVARCHAR(100);
 DECLARE @CinNumber NVARCHAR(100);
 DECLARE @Propcity  NVARCHAR(100);
  
   Create Table #ServiceDtails(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,Cess decimal(27,2),ST decimal(27,2),Hcess decimal(27,2),
            Miscellaneous Decimal(27,2))--,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100))
   Create Table #ServiceDtails1(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100),
            ChkOutSerAmount Decimal(27,2),Quantity Bigint,ProductId bigint,Cess decimal(27,2),ST decimal(27,2),
            Hcess decimal(27,2),OtherService DECIMAL(27,2),MiscellaneousAmount dECIMAL(27,2),ChkOutServiceVat dECIMAL(27,2),
            Miscellaneous Decimal(27,2),DtlId int)
   Create Table #ServiceDtails2(CheckOutNo nvarchar(100),GuestName nvarchar(500),Amounts decimal(27,2),InvoiceNumber nvarchar(100),
            Stay nvarchar(200),CheckInDate nvarchar(50),CheckOutDate nvarchar(50),BillDate nvarchar(50),
            ClientName nvarchar(500),ClientId bigint,Property nvarchar(500),PropertyId bigint,
            ChkoutId bigint,PropertyCat nvarchar(100),Status nvarchar(100),BillType nvarchar(100),
            ChkInHdrId bigint,GuestId bigint,BookingId bigint,ChkOutSerDate nvarchar(100),ServiceItem nvarchar(100),
            ChkOutSerAmount Decimal(27,2),Quantity Bigint,ProductId bigint,Cess decimal(27,2),ST decimal(27,2),
            Hcess decimal(27,2),OtherService dECIMAL(27,2),MiscellaneousAmount DECIMAL(27,2),ChkOutServiceVat dECIMAL(27,2),
            Miscellaneous Decimal(27,2))
          
       
IF @Action ='PAGELOAD' 
BEGIN 
  	
IF @Str1='' 
BEGIN
            insert into #ServiceDtails(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,Miscellaneous)--,ChkOutSerDate,ServiceItem)
 
			Select Ck.CheckOutNo,Ck.GuestName,sum(Sh.ChkOutServiceNetAmount)  Amounts,ck.InVoiceNo InvoiceNumber,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,ck.Property,ck.PropertyId,
			Ck.Id ChkoutId,CK.PropertyType PropertyCat,ck.Status Status,'Service' as BillType,
			Ck.ChkInHdrId as ChkInHdrId,Ck.GuestId,Ck.BookingId BookingId ,sum(Sh.MiscellaneousAmount+sh.OtherService)
			FROM WRBHBChechkOutHdr CK
			join WRBHBCheckOutServiceHdr SH WITH(NOLOCK) on  Ck.Id=sh.CheckOutHdrId and sh.IsActive=1 and sh.IsDeleted=0
		 join WRBHBCheckOutServiceDtls SD WITH(NOLOCK) on SH.Id=SD.ServiceHdrId and sd.IsActive=1 and sd.IsDeleted=0 and  SD.ServiceHdrId!=0
			where isnull(Sh.ChkOutServiceNetAmount,0)!=0 --and isnull(sd.ChkOutSerAmount,0)!=0 
			and Ck.IsActive=1 and ck.IsDeleted=0 and ck.InVoiceNo !=''
			-- and ck.ChkInHdrId in(3012) 
			group by Ck.CheckOutNo,Ck.GuestName,--Sh.ChkOutServiceNetAmount ,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,
			ck.Property,ck.PropertyId, Ck.Id, CK.PropertyType ,ck.InVoiceNo,ck.Status,
			Ck.ChkInHdrId ,Ck.GuestId,Ck.BookingId,  sh.OtherService  -- ,Sd.ChkOutSerDate,ChkOutSerItem
			order by Ck.Id Desc
			
			update #ServiceDtails set Amounts= (H.ChkOutServiceNetAmount)
			from #ServiceDtails Tmp
			join   WRBHBCheckOutServiceHdr H on tmp.ChkoutId=h.CheckOutHdrId and IsActive=1 and IsDeleted=0
		--	dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			 -- Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
	--	End	  
	 if(@Str2='External')
	 Begin	 
			Select CheckOutNo,GuestName,Amounts,InvoiceNumber,
            CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio 
            from #ServiceDtails where PropertyCat='External Property'
            and InvoiceNumber !='0' 
	 End
	 if(@Str2='Internal')
	 begin
			 Select CheckOutNo,GuestName,Amounts,InvoiceNumber as InVoiceNo,
             CheckInDate+' To '+CheckOutDate Stay,BillDate,ClientName,ClientId,Property,PropertyId,
             ChkoutId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio,
             CheckInDate ChkinDT,CheckOutDate as ChkoutDT, CheckInDate as ArrivalDate
           	 from #ServiceDtails where PropertyCat='Internal Property'
             
        end 
 	End		
 END
 
IF @Str1!='' 
	BEGIN
	DECLARE @id VARCHAR(MAX),@Guestid Bigint,@CityId Bigint, @StateId Bigint,@PropertyId Bigint;
	Declare @BillFrom nvarchar(100),@BillTo nvarchar(100), @CityName NVARCHAR(100),@Property nvarchar(100);
	Declare @CessPercent Decimal(27,2),@HECessPercent Decimal(27,2),@STPercent Decimal(27,2),@VATPer Decimal(27,2);
	Declare @Chkoutid bigint,@SServiceTax decimal(27,2);
	SET @id =  @Str1;--'1152,1153,1154,1155,1159,1160,'--@Str1;--
 
	WHILE CHARINDEX(',', @id) > 0 
	BEGIN 
    
		SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

		INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
		SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id))
		-- SELECT * from #SepratebyComma
	END 
	CREATE TABLE #FinalService(ServiceItem NVARCHAR(100),Amount DECIMAL(27,2),
	ProductId BIGINT,TypeService NVARCHAR(100))
	
	CREATE TABLE #Tax(Cess DECIMAL(27,2),ST DECIMAL(27,2),Hcess DECIMAL(27,2),OtherService DECIMAL(27,2),
	Miscellaneous DECIMAL(27,2),ChkInHdrId INT,ChkOutServiceVat DECIMAL(27,2),PrtyCat Nvarchar(200))

		
		SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
		while @Cnt>0
		begin
			Set @Chkoutid      = (Select top 1 CheckoutId from  #SepratebyComma  order by Id desc )
			Set @Chkid      = (Select top 1 ChkInHdrId from  WRBHBChechkOutHdr 
			                   where IsActive=1 and IsDeleted=0 and Id=@Chkoutid order by Id desc  )
			Set @Guestid    =(Select top 1 Id       from  WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @CityId     =(select top 1 CityId   from WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @CityName   =(select top 1 CityName from WRBHBCity where id=@CityId order by Id desc )
			Set @Property   =(select top 1 Property from WRBHBCheckInHdr where id=@Chkid order by Id desc )
		--	Set @PropertyId =(select top 1 PropertyId from WRBHBCheckInHdr where id=@Chkid order by Id desc )
			Set @StateId    =(select top 1 StateId  from WRBHBCity where Id=@CityId )
			Set @BillFrom   =(select top 1 convert(nvarchar(100),ArrivalDate,103) from WRBHBCheckInHdr where id=@Chkid   order by Id desc )
			Set @BillTo     =(convert(nvarchar(100),getdate(),103));
			set @SServiceTax=(select Top 1 BusinessSupportST from WRBHBChechkOutHdr where   Id=@Chkoutid)
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
            Cess,ST,Hcess,OtherService,MiscellaneousAmount,	ChkOutServiceVat,Miscellaneous,DtlId)
 
			Select Ck.CheckOutNo,Ck.GuestName,Sum(Sh.ChkOutServiceNetAmount) Amounts,ck.InVoiceNo InvoiceNumber,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,ck.Property,ck.PropertyId,
			Ck.Id ChkoutId,CK.PropertyType PropertyCat,ck.Status Status,'Service' as BillType,
			Ck.ChkInHdrId as ChkInHdrId,Ck.GuestId,0 BookingId,
			Sd.ChkOutSerDate,sd.ChkOutSerItem ServiceItem,Sd.ChkOutSerAmount,1,sd.ProductId,
			SH.CESS,SH.ChkOutServiceST,SH.HECess,SH.OtherService,0,sH.ChkOutServiceVat,
		   (SH.MiscellaneousAmount),sd.Id
			FROM WRBHBChechkOutHdr CK
			join WRBHBCheckOutServiceHdr SH WITH(NOLOCK) on  Ck.Id=sh.CheckOutHdrId and sh.IsActive=1 and sh.IsDeleted=0
			 join WRBHBCheckOutServiceDtls SD WITH(NOLOCK) on SH.Id=SD.ServiceHdrId and sd.IsActive=1 and sd.IsDeleted=0 and  SD.ServiceHdrId!=0
			where-- isnull(SD.ChkOutSerAmount,0)!=0-- and isnull(sd.ChkOutSerAmount,0)!=0 and 
			 Ck.IsActive=1 and ck.IsDeleted=0 and ck.InVoiceNo !=''
			and ck.Id in(@Chkoutid)  
			group by Ck.CheckOutNo,Ck.GuestName,ck.InVoiceNo,
			Stay,ck.CheckInDate,ck.CheckOutDate,ck.BillDate,ck.ClientName,ck.ClientId,ck.Property,ck.PropertyId,
			Ck.Id,CK.PropertyType,ck.Status,Ck.ChkInHdrId ,Ck.GuestId,
			Sd.ChkOutSerDate,sd.ChkOutSerItem,Sd.ChkOutSerAmount,sd.ProductId,SH.MiscellaneousAmount,Sh.OtherService,
			SH.CESS,SH.ChkOutServiceST,SH.HECess,SH.OtherService,sH.ChkOutServiceVat,Sd.Id
			order by Ck.Id Desc 
 
	INSERT INTO #FinalService(ServiceItem,Amount,ProductId,TypeService) 
	exec Sp_CheckoutService1_Help @Action='ProductLoad',@Str1=@Id,@CheckInHdrId=@Guestid,
	@StateId=@StateId ,@BillFrom=@BillFrom ,@BillTo= @BillTo ;
      
   --   INSERT INTO #FinalService(ServiceItem,Amount,ProductId,TypeService) 
--Exec Sp_CheckoutService1_Help @Action='ProductLoad',@Str1=726,@CheckInHdrId=726,
--@StateId=21,@BillFrom='08/08/2014',@BillTo='09/01/2015'
--726	726	21	08/08/2014	09/01/2015
	DELETE FROM #SepratebyComma WHERE CheckoutId=@Chkoutid  ;
	Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
	End	  
		 --Select @Chkid,@Guestid,@StateId,@BillFrom,@BillTo
	  -- select * from #FinalService
	 -- order by ChkOutSerDate; return;	
		    insert into #ServiceDtails2(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,ChkOutSerDate,
            ServiceItem,ChkOutSerAmount,Quantity,ProductId,Cess,ST,Hcess,OtherService,
            MiscellaneousAmount,ChkOutServiceVat,Miscellaneous)
		    
			 Select CheckOutNo,GuestName,Sum(ChkOutSerAmount),InvoiceNumber as InVoiceNo,
			 CheckInDate+' To '+CheckOutDate Stay, CheckInDate ChkinDT,CheckOutDate as ChkoutDT, 
			 h.ChkOutSerDate,ClientName,ClientId,Property,PropertyId,
			 ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,0 as selectRadio,
			--CheckInDate as ArrivalDate,
			 h.ServiceItem as BillDate,h.ServiceItem as Product,
			 sum(ChkOutSerAmount) as Price,isnull(sum(ChkOutSerAmount)/(d.Amount),0) Quantity, --Sum(Quantity) as Quantity,
			 d.ProductId ,Cess,ST,Hcess,OtherService,MiscellaneousAmount,ChkOutServiceVat,h.Miscellaneous
			 from #ServiceDtails1 h
			 join #FinalService d on h.ProductId=d.ProductId 
			 where ChkOutSerAmount!=0 
			 group by CheckOutNo,GuestName,InvoiceNumber,BillDate,ClientName,ClientId,
			 Property,PropertyId,ChkInHdrId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,--BookingId,
			 CheckInDate,CheckOutDate,CheckInDate,h.ServiceItem,d.ProductId,d.Amount,--,ChkOutSerAmount--,Quantity
			 Cess,ST,Hcess,OtherService,MiscellaneousAmount,ChkOutServiceVat,h.ChkOutSerDate,h.Miscellaneous,h.DtlId
      
     
			INSERT INTO #Tax(Cess,ST,Hcess,OtherService,Miscellaneous,ChkInHdrId,ChkOutServiceVat,PrtyCat)
			select DISTINCT Cess,ST,Hcess,OtherService,Miscellaneous,ChkInHdrId,ChkOutServiceVat,PropertyCat
			From #ServiceDtails1
 

   
            insert into #ServiceDtails2(CheckOutNo,GuestName,Amounts,InvoiceNumber,
            Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,ChkOutSerDate,
            ServiceItem,ChkOutSerAmount,Quantity,ProductId,Cess,ST,Hcess,OtherService,
            MiscellaneousAmount,ChkOutServiceVat,Miscellaneous)
		
			Select ''CheckOutNo,''GuestName,0,'' as InVoiceNo,'' Stay, '' ChkinDT,'' as ChkoutDT, 
			'',''ClientName,0 ClientId,0 Property,0 PropertyId,
			'' ChkoutId, PrtyCat PropertyCat,''Status,'Total'BillType,0 ChkInHdrId,0 GuestId,0 as selectRadio,
			'' BillDate,'Miscellaneous' as Product,
			SUM(Miscellaneous) as Price,0 Quantity, --Sum(Quantity) as Quantity,
			'', isnull(SUM(Cess),0), isnull(SUM(ST),0), isnull(SUM(Hcess),0), isnull(SUM(OtherService),0),
			0 MiscellaneousAmount,isnull(Sum(ChkOutServiceVat),0) ChkOutServiceVat,isnull(SUM(Miscellaneous),0)
			FROM #Tax
			group by PrtyCat
			
			-- insert into #ServiceDtails2(CheckOutNo,GuestName,Amounts,InvoiceNumber,
   --         Stay,CheckInDate,CheckOutDate,BillDate,ClientName,ClientId,Property,PropertyId,
   --         ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,ChkOutSerDate,
   --         ServiceItem,ChkOutSerAmount,Quantity,ProductId,Cess,ST,Hcess,OtherService,
   --         MiscellaneousAmount,ChkOutServiceVat,Miscellaneous)
            
			--Select ''CheckOutNo,''GuestName,0,'' as InVoiceNo,'' Stay, '' ChkinDT,'' as ChkoutDT, 
			--'',''ClientName,0 ClientId,0 Property,0 PropertyId,
			--'' ChkoutId, PrtyCat PropertyCat,''Status,'Totals'BillType,0 ChkInHdrId,0 GuestId,0 as selectRadio,
			--'' BillDate,'Miscellaneous' as Product,
			--SUM(Miscellaneous) as Price,0 Quantity, --Sum(Quantity) as Quantity,
			--'', isnull(SUM(Cess),0), 0, 0, 0,
			--0 MiscellaneousAmount,0 ChkOutServiceVat,isnull(SUM(Miscellaneous),0)
			--FROM #Tax
			--group by PrtyCat
		--	select * from #ServiceDtails2
 
             
       --  SELECT  Cess+ST+Hcess+OtherService  FROM  #ServiceDtails1
       --  where (Cess+ST+Hcess+OtherService)!=0
       --  group by  Cess,ST,Hcess,OtherService 
         --Select * from  #ServiceDtails2 ;
       
         DECLARE @TAX DECIMAL(27,2),@TOT DECIMAL(27,2),@NETAMT DECIMAL(27,2),@vAT dECIMAL(27,2),@STtax Decimal(27,2),
         @OlyAmount DEcimal(27,2),@Todate Nvarchar(100),@Stay Nvarchar(200),@InvoiceDate nvarchar(100) ,@OtherService Decimal(27,2);
         DECLARE @CessTotal Decimal(27,2),@HcessTotal Decimal(27,2),@PrptyAdress nvarchar(900),@MiscellaneousA Decimal(27,2);
         SET @TOT=(SELECT  sum(ChkOutSerAmount)FROM  #ServiceDtails2 )
         SET @TAX=  (SELECT (Cess+ST+Hcess)  FROM  #ServiceDtails2 where  Billtype='Total' )
         sET @vAT=(SELECT isnull(ChkOutServiceVat,0) FROM  #ServiceDtails2 where  Billtype='Total' )
         Set @STtax=(SELECT ST FROM  #ServiceDtails2 where isnull(ST,0)!=0 and Billtype='Total')
         Set @CessTotal=(SELECT Cess FROM #ServiceDtails2 where isnull(Cess,0)!=0 and Billtype='Total')
         Set @HcessTotal=(SELECT Hcess FROM #ServiceDtails2 where isnull(Hcess,0)!=0  and Billtype='Total')
         Set @MiscellaneousA=(SELECT Miscellaneous FROM #ServiceDtails2 where isnull(Miscellaneous,0)!=0 and Billtype='Total')
          Set @OtherService=(SELECT OtherService FROM #ServiceDtails2 where isnull(OtherService,0)!=0 and Billtype='Total')
         
         
         Set @Stay =(SELECT top 1 Stay FROM  #ServiceDtails1 )
         
         Set @OlyAmount =(SELECT MiscellaneousAmount FROM WRBHBCheckOutServiceHdr
                           where CheckOutHdrId= @Chkid and IsActive=1 and IsDeleted=0 and (Cess+HECess+ChkOutServiceST)=0 )
         Set @Todate=(SELECT CheckOutDate FROM WRBHBChechkOutHdr
                           where Id= @Chkoutid and IsActive=1 and IsDeleted=0 )
                           
        Set @InvoiceDate =(SELECT top 1 BillDate FROM WRBHBChechkOutHdr
                           where Id= @Chkoutid and IsActive=1 and IsDeleted=0 )
         
      --   Set @Todate=(SELECT top 1 ChkOutDt FROM WRBHBBookingPropertyAssingedGuest
       --                    where CheckOutHdrId= @Chkoutid and IsActive=1 and IsDeleted=0 
       --                     and RoomShiftingFlag=0 and CurrentStatus='CheckOut'
        --                 order by Id desc )
              Update #ServiceDtails2 Set Quantity='' where  ServiceItem='Miscellaneous'           
       Set @PropertyId =(select top 1 PropertyId from WRBHBChechkOutHdr where id=@Chkoutid order by Id desc )                
       Update #ServiceDtails2 set ChkOutSerAmount=(isnull(@OlyAmount,0)+isnull(@MiscellaneousA,0))
       where BillType='Total'
             --  select @TOT,@TAX,@vAT
         sET @NETAMT=(@TOT+isnull(@TAX,0)+isnull(@vAT,0)+ISNULL(@OlyAmount,0)+ISNULL(@OtherService,0))--+@MiscellaneousA)
         Set @PrptyAdress=(Select top 1  Propertaddress  from WRBHBProperty where IsActive=1 and IsDeleted=0 and Id=@PropertyId)
        -- [AmtWords]
      -- Select @Propcity,@PrptyAdress,@PropertyId
	 if(@Str2='External')
	 Begin	 
			Select CheckOutNo,GuestName,Amounts,InvoiceNumber InVoiceNo,@Stay Stay,
            CheckInDate+' To '+CheckOutDate Stays,BillDate,ClientName,ClientId,Property,PropertyId,
            ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio ,
            CheckInDate ChkinDT,CheckOutDate as ChkoutDT, CheckInDate as ArrivalDate,@Todate as ToDate,
            ChkOutSerDate as BillDate,ServiceItem as Product,ChkOutSerAmount as Price,Quantity as Quantity,ProductId,
            isnull(@CessTotal,0) Cess,isnull(@STtax,0) AS SerivceTax,isnull(@HcessTotal,0) Hcess,rOUND(@NETAMT,0) AS NetAmount,isnull(@vAT,0) AS Vat,
            @CityName AS City,@PrptyAdress as Propertyaddress,  convert(Nvarchar(200),@CessPercent)+' %' CessPercent,
             convert(Nvarchar(200),@HECessPercent)+' %' HECessPercent,@SServiceTax as  SServiceTax,
             isnull(@OtherService,0)  OtherService,
             convert(Nvarchar(200),@VATPer)+' %' as  VATPer,  convert(Nvarchar(200),@STPercent)+' %' as STPercent,
			 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
			 ''+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  ' +'CIN No: U72900KA2005PTC035942' as TaxNo,
			 'INVOICE : For any invoice clarification please revert within 7 days from date of receipt.' as Invoice,
			 'CHEQUE : All Cheque or Demand drafts in payment of bills should be drawn in favour of HummingBird Travel and Stay Pvt.Ltd. and should be crossed "A/C PAYEE ONLY"' as Cheque,
			 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bills after due date' AS Latepay ,
			-- 'PAN NO : AABCH 5874 R, L Tax No : L00100571, TIN : 29340489869' as TaxNo, 
			 'Service Tax Regn. No : AABCH5874RST001,' as ServiceTaxNo,
			 'Taxable Category :Business Support Services and Restaurant Services' as Taxablename,
			 'CIN No: U72900KA2005PTC035942' as CINNo,@InvoiceDate as InVoicedate,
			  'Rupees : '+dbo.fn_NtoWord(ROUND(@NETAMT,0),'','') AS AmtWords
            from #ServiceDtails2 where PropertyCat='External Property'
          -- and InvoiceNumber !=''
           order by Quantity desc
	 End
	 if(@Str2='Internal')
	 begin
			 Select CheckOutNo,GuestName,Amounts,InvoiceNumber as InVoiceNo,@Stay Stay,
             CheckInDate+' To '+CheckOutDate Stays,BillDate,ClientName,ClientId,Property,PropertyId,
             ChkInHdrId ChkoutId,PropertyCat,Status,BillType,ChkInHdrId,GuestId,BookingId,0 as selectRadio,
             CheckInDate ChkinDT,CheckOutDate as ChkoutDT, CheckInDate as ArrivalDate,@Todate as ToDate,
              ChkOutSerDate as BillDate,ServiceItem as Product,ChkOutSerAmount as Price,
               Quantity  as Quantity,ProductId,
             isnull(@CessTotal,0) Cess,isnull(@STtax,0) AS SerivceTax,isnull(@HcessTotal,0) Hcess,rOUND(@NETAMT,0) AS NetAmount,isnull(@vAT,0) AS Vat,
              @CityName AS City,@PrptyAdress as Propertyaddress,convert(Nvarchar(200),@CessPercent)+' %' CessPercent,
              convert(Nvarchar(200),@HECessPercent)+' %'   HECessPercent,  
              convert(Nvarchar(200),@SServiceTax)+' %'  as  SServiceTax,
               isnull(@OtherService,0)  OtherService,
              convert(Nvarchar(200),@VATPer)+' %'  as  VATPer,convert(Nvarchar(200),@STPercent)+' %'  as STPercent,
			 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
			 ''+@PanCardNo+'   |   '+'TIN : 29340489869'+'   |   '+'L Tax No : L00100571'+'  |  ' +'CIN No: U72900KA2005PTC035942' as TaxNo,
			 'INVOICE : For any invoice clarification please revert within 7 days from date of receipt.' as Invoice,
			 'CHEQUE : All Cheque or Demand drafts in payment of bills should be drawn in favour of HummingBird Travel and Stay Pvt.Ltd. and should be crossed "A/C PAYEE ONLY"' as Cheque,
			 'LATE PAYMENT : Interest @18% per annum will be charged on all outstanding bills after due date' AS Latepay ,
			-- 'PAN NO : AABCH 5874 R, L Tax No : L00100571, TIN : 29340489869' as TaxNo, 
			 'Service Tax Regn. No : AABCH5874RST001,' as ServiceTaxNo,
			 'Taxable Category :Business Support Services and Restaurant Services' as Taxablename,
			 'CIN No: U72900KA2005PTC035942' as CINNo,@InvoiceDate as InVoicedate,
			  'Rupees : '+dbo.fn_NtoWord(ROUND(@NETAMT,0),'','') AS AmtWords
			 from #ServiceDtails2 where PropertyCat='Internal Property'
			 order by Quantity desc
      end
	End		
end 


 