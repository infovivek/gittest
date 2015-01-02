 
 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_TariffBasedReports') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_TariffBasedReports
GO 

CREATE PROCEDURE Sp_TariffBasedReports
(
	@Action NVARCHAR(100)=NULL,
	@Param1 NVARCHAR(100)=NULL,    --int
	@Param2  NVARCHAR(100)=NULL,   --int
	@FromDate NVARCHAR(100)=NULL,
	@ToDate NVARCHAR(100)=NULL,
	@UserId int
)
AS 
BEGIN 
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
--Sp_TariffBasedReports @Action='PageLoad',@Param1=0,@Param2=2014,@FromDate='',@ToDate='',@UserId=1
--drop  table #FIRSTDATAS;
--drop table #TFMODES;
--drop table #TFFINAL;
--drop table #MonthWise;
--drop table #MonthWiseFinal;
--drop table #MonthWiseFinalNew;

IF @Action ='Year'
		Begin 
			select Id , Years as label  from WRBHBFinancialYear
			where Years!=0
		END
		--UPDATE WRBHBFinancialYear SET Years=2016 WHERE Id=3
 IF @Action ='PageLoad'
		Begin  
		  
		CREATE TABLE #FIRSTDATAS (CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT,
CheckInDate  NVARCHAR(100),NoOfDays bigint,TotalAmt decimal(27,2),PrintInvoice bit ,BillDate  Nvarchar(100),
TariffpaymentMode NVARCHAR(100))

 
CREATE TABLE #TFMODES(TariffPaymentMode NVARCHAR(200),BookingId BIGINT,GuestId BIGINT,RoomId BIGINT,
BookingPropertyId BIGINT,Tariff DECIMAL(27,2) ,CheckOutDate NVARCHAR(50),CheckInDate Nvarchar(100)
)

CREATE TABLE #TFFINAL(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),TotalDays Bigint,GTVAmount Decimal(27,2) )
 

CREATE TABLE #TEST(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TotalDays Bigint,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),BillDate Nvarchar(100)  )

CREATE TABLE #MonthWise(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)
 
CREATE TABLE #MonthWiseFinal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
TariffPaymentMode nvarchar(100),PrintInvoice bit)

CREATE TABLE #MonthWiseFinalGH( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
TariffPaymentMode nvarchar(100),PrintInvoice bit)

create table #MonthWiseFinalNET ( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
TariffPaymentMode nvarchar(100),PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNew( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNewNet( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
PrintInvoice bit)

CREATE TABLE #GrandTotalAll( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNewNetExtTotal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)
CREATE TABLE #MonthWiseGrandTotal ( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)

CREATE TABLE #ExternalNet(GuestId BIGINT,BookingId BIGINT,PropertyId BIGINT,ChkInHdrId BIGINT,
MarkUpAmount DECIMAL(27,2),CheckInDate NVARCHAR(50),CheckOutDate NVARCHAR(50))

CREATE TABLE #MonthWiseNet(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit,GTVAmount Decimal(27,2))
--t  --drop table #TFFINALS
CREATE TABLE #TFFINALS(GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
TariffTotal DECIMAL(27,2),CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),Occupancy nvarchar(100),
BookingId BIGINT,ChkInHdrId BIGINT ,ChkoutId BIGINT,TariffPaymentMode NVARCHAR(100),
TotalDays Bigint ,IDE bigint NOt null primary Key Identity(1,1),Btypes nvarchar(300),CurrentStatus nvarchar(100) )

CREATE TABLE #TFFINALSs(RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
TariffTotal DECIMAL(27,2),CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),Occupancy nvarchar(100),
BookingId BIGINT,ChkInHdrId BIGINT ,ChkoutId BIGINT,TariffPaymentMode NVARCHAR(100),
TotalDays Bigint ,IDE bigint NOt null primary Key Identity(1,1),Btypes nvarchar(300),CurrentStatus nvarchar(100) )



INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 

			Select  D.FirstName,GuestId,RoomId,D.RoomType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103),
			DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,D.Occupancy ,
			BookingId,isnull(D.CheckOutHdrId,0),isnull(D.CheckInHdrId,0),TariffpaymentMode,D.CurrentStatus,'RoomLvl'Btypes
			from WRBHBBooking H
			JOIN WRBHBBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			join WRBHBProperty P  on P.Id=d.BookingPropertyId and p.Category='Internal Property' and P.IsActive=1 and P.IsDeleted=0
			WHERE d.RoomShiftingFlag=0  AND D.CurrentStatus !=('Canceled')
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client' 
			--and BookingPropertyId in(1,2,3,6,7,267)
			  --and month(CONVERT(DATE,D.ChkOutDt,103))=11 and d.BookingPropertyId=2 
			GROUP BY  D.CheckOutHdrId ,D.FirstName,GuestId,RoomId,D.RoomType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,D.CheckOutHdrId,D.CheckInHdrId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,
			D.CurrentStatus,D.Occupancy 

 INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 
			
			Select  D.FirstName,GuestId,RoomId,D.BedType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103)
			,DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,'BedBook',
			BookingId,0,0,TariffpaymentMode,D.CurrentStatus,'BedLvl'Btypes
			from WRBHBBooking H
			JOIN WRBHBBedBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			join WRBHBProperty P  on P.Id=d.BookingPropertyId and p.Category='Internal Property' and P.IsActive=1 and P.IsDeleted=0
			WHERE    D.CurrentStatus !='Canceled' --and BookingPropertyId in(1,2,3,6,7,267)
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client'--and d.BookingPropertyId=2 
			GROUP BY D.FirstName,GuestId,RoomId,D.BedType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,D.CurrentStatus 



  
			 INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
						TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
						TariffPaymentMode,CurrentStatus,Btypes) 
			Select  D.FirstName,GuestId,D.ApartmentId,D.ApartmentType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103),
			DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,'Apartment',
			BookingId,0,0,TariffpaymentMode,D.CurrentStatus,'ApartLvl'Btypes
			from WRBHBBooking H
			JOIN WRBHBApartmentBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			join WRBHBProperty P  on P.Id=d.BookingPropertyId and p.Category='Internal Property' and P.IsActive=1 and P.IsDeleted=0
			WHERE    d.CurrentStatus !='Canceled' --and BookingPropertyId in(1,2,3,6,7,267)
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client'--and d.BookingPropertyId=2 
			GROUP BY D.FirstName,GuestId,ApartmentId,D.ApartmentType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,D.CurrentStatus


 Update #TFFINALS set TotalDays =C.NoOfDays,CheckOutDate=CONVERT(NVARCHAR,c.CheckOutDate,103),
 CheckInDate=CONVERT(NVARCHAR,c.CheckInDate,103)
 from  #TFFINALS F
 JOIN WRBHBChechkOutHdr C WITH(NOLOCK) ON C.Id=F.ChkoutId AND c.IsActive=1 AND c.IsDeleted=0 
 where f.ChkoutId!=0  
 
 
 Update #TFFINALS set Property =c.Propertyname,PropertyType=C.category
 from  #TFFINALS F
 JOIN WRBHBProperty C WITH(NOLOCK) ON C.Id=F.PropertyId AND c.IsActive=1 AND c.IsDeleted=0 
 where c.category='Internal Property'
 
  Update #TFFINALS set CheckInDate=CONVERT(NVARCHAR,c.ArrivalDate,103)
 from  #TFFINALS F
 JOIN WRBHBCheckInHdr C WITH(NOLOCK) ON C.Id=F.ChkInHdrId AND c.IsActive=1 AND c.IsDeleted=0 
 where c.PropertyType='Internal Property' AND  f.ChkInHdrId!=0 AND CurrentStatus in ('CheckIn','CheckOut') 
 
 
 Update #TFFINALS set TotalDays= DATEDIFF(day, CONVERT(DATE,CheckInDate,103),CONVERT(DATE,CheckOutDate,103))
  where PropertyType ='Internal Property' AND ChkInHdrId!=0 AND CurrentStatus in ('CheckIn','CheckOut') 
 
 
 
            INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 
					
				Select   0 RoomId,''Typess,ClientName,Property,PropertyId,PropertyType,
				TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
				TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
				where -- month(CONVERT(DATE,CheckOutDate,103))=11
				Occupancy ='Single'-- and PropertyId=2
				group by   ClientName,Property,PropertyId,PropertyType,
				TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
				TariffPaymentMode,CurrentStatus,Btypes
				order by BookingId 
            INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 
			
				Select RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
				TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
				TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
				where  --month(CONVERT(DATE,CheckOutDate,103))=11
				Occupancy !='Single' --and PropertyId=2
				group by RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
				TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
				TariffPaymentMode,CurrentStatus,Btypes
				order by BookingId ;
	 UPDATE #TFFINALSs SET TotalDays=1 WHERE ISNULL(TotalDays,0)=0
		 
 	
  --Select * from #TFFINALSs    where BookingId=6059
   -- order by BookingId; 
 --	update #TFFINALSs set   CheckOutDate = CONVERT(nvarchar(100),GETDATE(),103) ,
	--TotalDays= DateDiff(day,CONVERT(date,CheckInDate,103),CONVERT(Date,GETDATE(),103)) 
	--where CurrentStatus in ('CheckIn') 
	--and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103) 
	
  Declare  @Count BIGINT ,@j int,@Tariff DECIMAL(27,2),@NoOfDays BIGINT;   
	 Declare  @CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(500),@GuestId BIGINT,@RoomId BIGINT;
     Declare  @Typess NVARCHAR(100),@ClientName NVARCHAR(200),@Property NVARCHAR(200),@PropertyId BIGINT;
     Declare  @PropertyType NVARCHAR(100),@CheckOutDate NVARCHAR(50),@CheckInDate  NVARCHAR(100);
     Declare  @BookingId BIGINT,@ChkoutId BIGINT,@ChkInHdrId BIGINT ,@TariffPaymentMode NVARCHAR(100);
     Declare  @PrintInvoice bit, @IDE Bigint,@TotalDays BIGINT,@TAC DECIMAL(27,2); 
     

     SELECT TOP 1 @Tariff=TariffTotal ,
    -- @NoOfDays=DATEDIFF(day,CAST(CheckInDate AS DATE),CAST(CheckOutDate AS DATE)),
     @NoOfDays=TotalDays,--DATEDIFF(day, CONVERT(DATE,CheckInDate ,103), CONVERT(DATE,CheckOutDate,103)),
     @CheckOutNo= 0,@GuestName=CurrentStatus,@GuestId=0,@RoomId=RoomId,
     @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
     @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,@CheckInDate=CheckInDate,
     @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
     @PrintInvoice=0 ,@J=0,@TotalDays=TotalDays,@IDE=IDE   FROM #TFFINALSs 
    --SELECT @NoOfDays;
     WHILE (@NoOfDays>0)   
     BEGIN         
		INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays,GTVAmount)
		SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId,  @Typess,@ClientName,@Property,@PropertyId,  @PropertyType,
		@Tariff, CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate  ,103)),103),@CheckOutDate,--
		--@CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
		 @BookingId,@ChkoutId,@ChkInHdrId,
		@TariffPaymentMode, @PrintInvoice,1 ,0 
			 SET @J=@J+1  
			 SET @NoOfDays=@NoOfDays-1   
		IF @NoOfDays=0  
			 BEGIN    
			 
				 DELETE FROM #TFFINALSs WHERE IDE=@IDE  --CheckOutNo =@CheckOutNo
					
			     SELECT TOP 1 @Tariff=TariffTotal , 
				 @NoOfDays= TotalDays,-- DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103)),
				 @CheckOutNo= 0,@GuestName=CurrentStatus,@GuestId=0,@RoomId=RoomId,
				 @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
				 @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,
				 @CheckInDate= CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(CheckInDate AS DATE)),103)  ,
				 @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
				 @PrintInvoice=0 ,@J=0 ,@IDE=IDE FROM #TFFINALSs 
			 END 
			  
     END    
    
    --sELECT * FROM #TFFINAL  WHERE  MONTH(cONVERT(DATE,CheckOutDate,103))=12
   -- order by BookingId
--return;
   --DROP TABLE #NDDCountForecast
     --DROP TABLE #NDDCountForecastNew
     --DROP TABLE #NDDCountForecastData
     --DROP TABLE #OutStandingInternal
      CREATE TABLE #NDDCountForecast(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100),MonthDiff bigint,
	  IDE BIGINT PRIMARY KEY IDENTITY(1,1));
	  
	  CREATE TABLE #NDDCountForecastNew(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100),MonthDiff bigint );
	  
	  CREATE TABLE #NDDCountForecastData(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100));
	  
	   CREATE TABLE #OutStandingInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,EntryType NVARCHAR(100),GTV DECIMAL(27,2))
	   
	  -- CREATE TABLE #RevanueDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	    
    -- --GET ROOMS ARE DEDICATED OR NON DEDICATER    
   INSERT INTO #NDDCountForecastData(ApartmentId,PropertyId,RoomId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate)  
   SELECT CA.ApartmentId,CA.PropertyId,0,Tariff,ContractType,CA.Property,C.RateInterval ,
   Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0)
   FROM dbo.WRBHBContractManagementAppartment CA       
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CA.ContractId AND 
   LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE CA.IsActive=1 AND CA.IsDeleted=0 AND CA.ApartmentId!=0 AND CA.PropertyId!=0  
      
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate)     
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval ,
     Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0) 
   FROM dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId   
   AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 AND CR.RoomId!=0  
     
   --GET ROOMS ARE DEDICATED Managed Contracts  
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate) 
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval,
     Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0) 
   FROM  dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId AND   
   LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 and Tariff>100  
   
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,
   Type,StartDate,EndDate,MonthDiff)  
   SELECT RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type, StartDate,EndDate,
    DATEDIFF(MONTH,   StartDate, EndDate)+1 as MonthDiff
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM(' Monthly ')  
  
   	 --TRUNCATE TABLE #TFFINAL
     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff,
      @PropertyType=PropertyType,@Property=PropertyName, @Typess=Type,
       @CheckOutDate=EndDate,@CheckInDate=StartDate,
        @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
 
    -- SELECT @NoOfDays;
     WHILE (@TotalDays>0)   
     BEGIN         
     INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property, Typess,
     CheckInDate,CheckOutDate,TotalDays,
     CheckOutNo,GuestName,GuestId,ClientName,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,GTVAmount)
		
		   SELECT  @RoomId,@PropertyId,@Tariff,'Managed G H',@Property,@Typess,
           CONVERT(NVARCHAR(100),@CheckOutDate,103),
           CONVERT(NVARCHAR,DATEADD(MONTH,@J,CAST(@CheckInDate AS DATE)),103),1,
           0 CheckOutNo,0 GuestName,0 GuestId,0 ClientName,
           0 BookingId,0 ChkoutId,0 ChkInHdrId,0 TariffPaymentMode,0 PrintInvoice,0
			 SET @J=@J+1  
			 SET @TotalDays=@TotalDays-1   
		IF @TotalDays=0  
			 BEGIN    
			 
				 DELETE FROM #NDDCountForecast WHERE IDE=@IDE 
					
			     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff, @PropertyType=PropertyType,
			     @Property=PropertyName, @Typess=Type,@CheckOutDate=EndDate,@CheckInDate=StartDate,
				 @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
			 END 
			  
     END 
     --sELECT * FROM #TFFINAL 
     --RETURN
       TRUNCATE TABLE #NDDCountForecast
   --   TRUNCATE TABLE #TFFINAL 
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,
   Type,StartDate,EndDate,MonthDiff)  
   SELECT RoomId,PropertyId,ApartmentId,    
   (Tariff)*(DATEDIFF(d,StartDate,EndDate)) Tariff,
   --DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,CONVERT(DATE,GETDATE(),103)),0)))),
   PropertyType,PropertyName,Type ,StartDate,EndDate,DATEDIFF(d,StartDate, EndDate)
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM('  Daily  ')
   
     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff,
     @PropertyType=PropertyType,@Property=PropertyName, @Typess=Type,
     @CheckOutDate=EndDate,@CheckInDate=StartDate,
     @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
 
    -- SELECT @NoOfDays;
     WHILE (@TotalDays>0)   
     BEGIN         
     INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property, Typess,
     CheckInDate,CheckOutDate,TotalDays,
     CheckOutNo,GuestName,GuestId,ClientName,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,GTVAmount)
		
		   SELECT  @RoomId,@PropertyId,@Tariff,'Managed G H',@Property,@Typess,
           CONVERT(NVARCHAR(100),@CheckOutDate,103),
           CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103),1,
           0 CheckOutNo,0 GuestName,0 GuestId,0 ClientName,
           0 BookingId,0 ChkoutId,0 ChkInHdrId,0 TariffPaymentMode,0 PrintInvoice,0
			 SET @J=@J+1  
			 SET @TotalDays=@TotalDays-1   
		IF @TotalDays=0  
			 BEGIN    
			 
				 DELETE FROM #NDDCountForecast WHERE IDE=@IDE 
					
			     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff, @PropertyType=PropertyType,
			     @Property=PropertyName, @Typess=Type,@CheckOutDate=EndDate,@CheckInDate=StartDate,
				 @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
			 END 
			  
     END 
     
     update #TFFINAL set ClientName='G H'
    -- Select * from #TFFINAL
     where PropertyType='Managed G H'
     and  (CONVERT(date,CheckOutDate,103)) >  (CONVERT(DATE,GETDATE(),103))
    --and  year(CONVERT(DATE,CheckOutDate,103)) >  year(CONVERT(DATE,GETDATE(),103))
       
   delete  from #TFFINAL where PropertyType='External Property'
   ---For Externals
   	  CREATE TABLE #ExternalForecastNew(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays bigint) 
	  
	   CREATE TABLE #ExternalForecastNewTac(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays bigint) 
	  
      CREATE TABLE #ExternalForecasts(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint)
	  truncate table  #ExternalForecasts
	    INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays 
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus IN ('Booked')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer  
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0   
		 AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0  
		 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
	--oly for cpp  below select Working	 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)--,G.CurrentStatus  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
	 	 AND G.IsActive=1 AND G.IsDeleted=0  and G.CurrentStatus in('CheckIn','CheckOut')
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecasts)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
---only mmt data below	       
	     INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays) 
Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
--Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,0 Id ,
ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays 
from wrbhbbooking C
join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		and  PropertyType='MMT' 
LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
 where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
  
 
		UPDATE #ExternalForecasts SET NofDays=NoOfDays FROM #ExternalForecasts S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut';
 
 truncate table #ExternalForecastNew;
 --truncate table #TFFINAL;
    INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0) FROM #ExternalForecasts
	WHERE Occupancy='Single'
	group by  BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays 
	
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,''PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0) FROM #ExternalForecasts
	WHERE Occupancy!='Single'
	GROUP BY BookingId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays
	
	 
    update #ExternalForecastNew set NofDays=1   where NofDays=0;
    
    
    
 --update #ExternalForecastNew set   CheckOutDt = CONVERT(nvarchar(100),GETDATE(),103) ,
	--NofDays= DateDiff(day,CONVERT(date,CheckInDt,103),CONVERT(Date,GETDATE(),103)) 
	--where Type in ('CheckIn') 
	--and CONVERT(date,CheckOutDt,103) > CONVERT(Date,GETDATE(),103)
	
    --Select * from #ExternalForecastNew  where type!='Booking'
   -- return
    Declare @Tacinvoice int;Declare @Category nvarchar(100),@MarkUps Decimal(27,2),@SingleTariffs Decimal(27,2);
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC,@MarkUps=Markup,@SingleTariffs=SingleTariff
    FROM #ExternalForecastNew 
      --Select @NoOfDays
    WHILE (@NoOfDays>=1)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
            BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,GTVAmount)
             
	 Select 0 RoomId,@PropertyId,@SingleTariffs,@Category,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice,@MarkUps --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=isnull(@NoOfDays,0)-1
		IF isnull(@NoOfDays,0)=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC,@MarkUps=Markup,
			 @SingleTariffs=SingleTariff
			FROM #ExternalForecastNew  
		END    
    END  
      	  
  --Select * from #TFFINAL  where  PropertyType not in('Internal Property','MANAGED G H') -- and TariffPaymentMode!='Direct'-- and PropertyId=793
  -- and MONTH(CONVERT(DATE,CheckOutDate,103))= 11
  -- AND YEAR(CONVERT(DATE,CheckOutDate,103))=2014
  -- order by BookingId
  --  return;

 --Jan		 
		  INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,ChkOutTariffTotal,
			0,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 1
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 ---feb
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 2
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 --March
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 3
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Aprl
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 4
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--May
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 5
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--June
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 6
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--july
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 7
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Augs
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 8
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Sept
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,ChkOutTariffTotal,0, 0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 9
--oct
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 10
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Nov
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 11
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Decem
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 12
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
			
			

			
			Update #MonthWise set PropertyType=p.Category
			from #MonthWise M 
			join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
 
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT p.PropertyName,p.Category,p.Id,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,''PrintInvoice
	from #MonthWise F
	join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' 
	GROUP BY p.PropertyName,p.Category,p.Id
	
	Delete #MonthWise where GuestName='Booked'
	INSERT INTO	#MonthWiseFinalNET( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT p.PropertyName,p.Category,p.Id,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,''PrintInvoice
	from #MonthWise F
	join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' 
	GROUP BY p.PropertyName,p.Category,p.Id    

	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where PropertyType='External Property'
	group by Property,PropertyId,PropertyType,TariffPaymentMode,PrintInvoice


	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where PropertyType='MANAGED G H' 
	group by Property,PropertyId,PropertyType,PrintInvoice
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where PropertyType='MMT' 
	group by Property,PropertyId,PropertyType,PrintInvoice
	
	INSERT INTO	#MonthWiseFinalGH( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where ClientName!='G H' and PropertyType='MANAGED G H'
	group by Property,PropertyId,PropertyType,PrintInvoice
	 
	  --SELECT * FROM #MonthWiseFinalGH  where PropertyType='MANAGED G H' 
	-- return 
 -- Select * from #MonthWiseFinal where propertyType not in('Internal Property','MANAGED G H')
--	 return  
	  ---------------------------------------------------------------------------
	  -----final select for internal
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('Internal Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property,PropertyType,PropertyId, 
	    dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))   
		from #MonthWiseFinal where PropertyType='Internal Property'
		GROUP BY Property,PropertyType,PropertyId 

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal where PropertyType='Internal Property'

Declare @ShiftCountSS int;
		 SET @ShiftCountSS=(SELECT COUNT(*) FROM #MonthWiseFinalNew)  
		--Select  @ShiftCount
  IF @ShiftCountSS<=2
   begin
  Delete #MonthWiseFinalNew ;
   INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('Internal Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
   INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		select p.PropertyName ,p.Category,p.Id, 
	    dbo.CommaSeprate(ISNULL(sum(0),0)), dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)) ,1 
		from WRBHBProperty p where  p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property' 
		GROUP BY p.PropertyName,p.Category,p.Id 
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
   end
   
	  -----final select for External
	  
	   INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('External Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'online' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
		from #MonthWiseFinal 
		where PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinal 
		where PropertyType='External Property' and TariffPaymentMode='Direct'

	 	
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'MMT' Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
		from #MonthWiseFinal 
		where PropertyType='MMT'
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-External') Property,''PropertyType,''PropertyId, 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinal where PropertyType in ('External Property' ,'MMT')
		
	 INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
 -----final select for Managed
 
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('MANAGED G H') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property, 'MANAGED G H' PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm 
		dbo.CommaSeprate(ISNULL((Jan),0)), dbo.CommaSeprate(ISNULL((FEb),0)),
		dbo.CommaSeprate(ISNULL((Mar),0)),dbo.CommaSeprate(ISNULL((Aprl),0)),
		dbo.CommaSeprate(ISNULL((may),0)),dbo.CommaSeprate(ISNULL((Jun),0)),
		dbo.CommaSeprate(ISNULL((Jul),0)),dbo.CommaSeprate(ISNULL((Aug),0)),
		dbo.CommaSeprate(ISNULL((Sept),0)),dbo.CommaSeprate(ISNULL((Oct),0)),
		dbo.CommaSeprate(ISNULL((Nov),0)),dbo.CommaSeprate(ISNULL((Decm),0)) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' 
		--and Jan!=0 and FEb!=0 and Mar!=0 and Aprl!=0 and may!=0 and Jun!=0 
		-- and Jul!=0 and Aug!=0 and Sept!=0 and Oct!=0 and Nov!=0 and Decm!=0
			and (Jan+FEb+Mar+Aprl+may+Jun+Jul+Aug+Sept+Oct+Nov+Decm)!=0

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 COALESCE(upper('Total Amount-MANAGED GH'),'#FFFFFF') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		-- sum(Jan) ,sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' 

        INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
 --GrandTotal AMount
	INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal ;
		--update #MonthWiseFinalNew set PropertyId='' where PropertyType=''
		Select Property PropertyName,PropertyType,isnull(PropertyId,'') PropertyId, 
		isnull(Jan,'')JAN ,isnull(FEb,'') FEB,isnull(Mar,'')MARCH,isnull(Aprl,'')APRL,
		isnull(may,'')MAY,isnull(Jun,'')JUNE,isnull(Jul,'')JULY,isnull(Aug,'')AUG,
		isnull(Sept,'')SEPT,isnull(Oct,'')OCT,isnull(Nov,'')NOV,isnull(Decm,'')DEC,0 as SNo 
		from #MonthWiseFinalNew 
		--  Return;
		
 --	for second grid 
    dELETE  from #TFFINAL WHERE  (cONVERT(DATE,CheckOutDate,103))>= cONVERT(DATE,GETDATE(),103)
		dELETE  from #TFFINAL WHERE  GuestName='Booked'
 
 --Select * from #TFFINAL  where propertyType='Internal Property' AND MONTH(CONVERT(DATE,CheckOutDate,103))= 11
  --order by BookingId
-- Return;
 --Exec Sp_TariffBasedReports @Action='PageLoad',@Param1=0,@Param2=2014,@FromDate='',@ToDate='',@UserId=1
 --truncate table #TFFINALSs;
 --          INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
	--		TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--		TariffPaymentMode,CurrentStatus,Btypes) 

	--			Select RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
	--			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--			TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
	--			where -- month(CONVERT(DATE,CheckOutDate,103))=11
	--			Occupancy ='Single'  and PropertyType='Internal Property'
	--			group by RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
	--			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--			TariffPaymentMode,CurrentStatus,Btypes
	--			order by BookingId 
			
	--		INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
	--		TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--		TariffPaymentMode,CurrentStatus,Btypes) 
	--			Select RoomId,''Typess,ClientName,Property,PropertyId,PropertyType,
	--			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--			TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
	--			where  --month(CONVERT(DATE,CheckOutDate,103))=11
	--			Occupancy !='Single'  and PropertyType='Internal Property'--and PropertyId=2
	--			group by RoomId,ClientName,Property,PropertyId,PropertyType,
	--			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
	--			TariffPaymentMode,CurrentStatus,Btypes
	--			order by BookingId 
	-- UPDATE #TFFINALSs SET TotalDays=1 WHERE ISNULL(TotalDays,0)=0
		 
 	
 --   update #TFFINALSs set   CheckOutDate = CONVERT(nvarchar(100),GETDATE(),103) ,
	--TotalDays= DateDiff(day,CONVERT(date,CheckInDate,103),CONVERT(Date,GETDATE(),103)) 
	--where CurrentStatus in ('CheckIn') 
	--and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103) 
	
	 
 ----update #TFFINALSs Set RoomId=0
 
	--  Delete #TFFINALSs where CurrentStatus='Booked'	 
	--  Select * from #TFFINAL where PropertyId=1 and MONTH( CONVERT(DATE,CheckOutDate,103))=12
 -- Return;

 --    SELECT TOP 1 @Tariff=TariffTotal ,
 --   -- @NoOfDays=DATEDIFF(day,CAST(CheckInDate AS DATE),CAST(CheckOutDate AS DATE)),
 --    @NoOfDays=TotalDays,--DATEDIFF(day, CONVERT(DATE,CheckInDate ,103), CONVERT(DATE,CheckOutDate,103)),
 --    @CheckOutNo= 0,@GuestName=CurrentStatus,@GuestId=0,@RoomId=RoomId,
 --    @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
 --    @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,@CheckInDate=CheckInDate,
 --    @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
 --    @PrintInvoice=0 ,@J=0,@TotalDays=TotalDays,@IDE=IDE   FROM #TFFINALSs 
 --   --SELECT @NoOfDays;
 --    WHILE (@NoOfDays>0)   
 --    BEGIN         
	--	INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
	--	ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
	--	TariffPaymentMode,PrintInvoice,TotalDays,GTVAmount)
	--	SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId,  @Typess,@ClientName,@Property,@PropertyId,  @PropertyType,
	--	@Tariff, CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate  ,103)),103),@CheckOutDate,--
	--	--@CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
	--	 @BookingId,@ChkoutId,@ChkInHdrId,
	--	@TariffPaymentMode, @PrintInvoice,1  ,0
	--		 SET @J=@J+1  
	--		 SET @NoOfDays=@NoOfDays-1   
	--	IF @NoOfDays=0  
	--		 BEGIN    
			 
	--			 DELETE FROM #TFFINALSs WHERE IDE=@IDE  --CheckOutNo =@CheckOutNo
					
	--		     SELECT TOP 1 @Tariff=TariffTotal , 
	--			 @NoOfDays= TotalDays,-- DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103)),
	--			 @CheckOutNo= 0,@GuestName=CurrentStatus,@GuestId=0,@RoomId=RoomId,
	--			 @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
	--			 @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,
	--			 @CheckInDate= CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(CheckInDate AS DATE)),103)  ,
	--			 @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
	--			 @PrintInvoice=0 ,@J=0 ,@IDE=IDE FROM #TFFINALSs 
	--		 END 
			  
 --    END 
    
    --  Select * from #TFFINALSs where PropertyId=1 and MONTH( CONVERT(DATE,CheckOutDate,103))=12
     --Return;
     --For Net revenue Internal Above Done here
	 ---For Externals
         CREATE TABLE #ExternalForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint)
	  
	    INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays 
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus not IN ('Booked')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category, G.CurrentStatus, 
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer  
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0   AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
	--	 Truncate table  #ExternalForecast ;
		INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays) 
Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
--Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,0 Id ,
ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays 
from wrbhbbooking C
join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		and  PropertyType='MMT' 
LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
 where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
   
   
    INSERT INTO #ExternalForecastNewTac(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #ExternalForecast
	WHERE Occupancy='Single'
	group by  BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays 
	
	INSERT INTO #ExternalForecastNewTac(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,''PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #ExternalForecast
	WHERE Occupancy!='Single'
	GROUP BY BookingId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays
	
		UPDATE #ExternalForecastNewTac SET NofDays=NoOfDays FROM #ExternalForecastNewTac S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut'
	   --where PropertyId=456
		-- Delete from #TFFINAL where PropertyType='External Property'; 
    -- truncate table #TFFINAL;
     
     
    update #ExternalForecastNewTac set   CheckOutDt = CONVERT(nvarchar(100),GETDATE(),103) ,
	NofDays= DateDiff(day,CONVERT(date,CheckInDt,103),CONVERT(Date,GETDATE(),103)) 
	where Type in ('CheckIn')  and Category!='MMT'
	and CONVERT(date,CheckOutDt,103) > CONVERT(Date,GETDATE(),103)
	
	--Select * from  #TFFINAL where PropertyType in('External Property','MMT') a
	 Delete #TFFINAL where   PropertyType in('External Property','MMT') 
	-- Delete #TFFINAL where Typess  in ('Booking','CheckIn') and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103)
 
 update #ExternalForecastNewTac set NofDays=1 where isnull(NofDays,0)=0;
	--select * from  #ExternalForecastNewTac   where Category in( 'MMT') and MONTH(CONVERT(DATE,CheckOutDt,103))= 12
	--Select * from #ExternalForecastNewTac
--	where Type in ('CheckIn') 
--	and CONVERT(date,CheckOutDt,103) = CONVERT(Date,GETDATE(),103)
	 -- Select * from #TFFINAL where PropertyType in( 'MMT')and MONTH(CONVERT(DATE,CheckOutDate,103))=12
   --return;
   --  Select SingleTariff,SingleandMarkup,Markup,  
		 --PropertyId,TAC,TACPer,NofDays from #ExternalForecast
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC
    FROM #ExternalForecastNewTac  WHERE TAC=1  
     --Select @NoOfDays
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,GTVAmount)
             
	 Select 0 RoomId,@PropertyId,isnull(((@Tariff*@TAC)/100),0),@Category ,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice ,@Tariff --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNewTac WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecastNewTac  WHERE TAC=1 
		END   
         
    END  
   -- truncate table #TFFINAL;
  -- For tAc=0
  Declare @SingleandMarkup decimal(27,2), @SingleTariff  decimal(27,2),@Markup  decimal(27,2);
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@SingleandMarkup=isnull(SingleandMarkup,0),
    @SingleTariff=isnull(SingleTariff,0),@Markup=Markup,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
    FROM #ExternalForecastNewTac  WHERE TAC=0  
    --  Select isnull((@SingleandMarkup-@SingleTariff),0)+@Markup as dd
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,GTVAmount)
             
	 Select 0 RoomId,@PropertyId,isnull(@SingleTariff,0),--@SingleTariff),0)+@Markup,
	@Category,''Property,@Typess ,
     @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode, @Tacinvoice,@Markup --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNewTac WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@SingleandMarkup=isnull(SingleandMarkup,0),  @SingleTariff=isnull(SingleTariff,0),@Markup=Markup,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecastNewTac  WHERE TAC=0 
		END   
         
    END  
    
    Update #TFFINAL Set GTVAmount=0 
	where PropertyType='External Property' and TariffPaymentMode='Bill to Company (BTC)'	
	
	 Update #TFFINAL Set GTVAmount=0 
	where PropertyType='Internal Property' 
	
 Delete #TFFINAL where Typess  in ('Booking') and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103)
   -- Select * from #TFFINAL --where   PropertyType in('MMT') --and TariffPaymentMode='Direct'
   --and MONTH(CONVERT(DATE,CheckOutDate,103))=12
  ----order by BookingId
  --  return;
 -- Select * from #TFFINAL where   PropertyType in('MMT') --and TariffPaymentMode='Direct'
 --  and MONTH(CONVERT(DATE,CheckOutDate,103))=12
 	---Jan to december fo  2nd table
				 
 --Jan		 
		INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal+GTVAmount,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,ChkOutTariffTotal,
			0,0,0,0,0,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 1
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 ---feb
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
					
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			ChkOutTariffTotal+GTVAmount,0,0,0,0,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 2
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 --March
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,ChkOutTariffTotal+GTVAmount,0,0,0,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 3
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Aprl
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,ChkOutTariffTotal+GTVAmount,0,0,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 4
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--May
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			 SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,ChkOutTariffTotal+GTVAmount,0,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 5
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--June
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
		   SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,ChkOutTariffTotal+GTVAmount,0,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 6
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--july
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,ChkOutTariffTotal+GTVAmount,0,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 7
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Augs
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,ChkOutTariffTotal+GTVAmount,0,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 8
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Sept
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,ChkOutTariffTotal+GTVAmount,0,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 9
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
					
					
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,ChkOutTariffTotal+GTVAmount,0,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 10
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Nov
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
		    SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,ChkOutTariffTotal+GTVAmount,0,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 11
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Decem
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice,GTVAmount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,0,ChkOutTariffTotal+GTVAmount,PrintInvoice,GTVAmount
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 12
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 -- Select SUM(GTVAmount),SUM(ChkOutTariffTotal) from #MonthWiseNet where PropertyType='External property'   and
  -- MONTH(CONVERT(DATE,CheckOutDate,103))= 12 Return;
		  -----final select for internal
		  
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		select top 1 UPPER('Internal Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm,5 
		from #MonthWiseFinal 

		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		select p.PropertyName ,p.Category,p.Id, 
	    dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)),1  
		from #MonthWiseNet F
		join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
		where f.PropertyType='Internal Property' 
		GROUP BY p.PropertyName,p.Category,p.Id 

		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)),0  
		from #MonthWiseNet where PropertyType='Internal Property'
--Dummy for Internal propertyies Name 
Declare @ShiftCount int;
		 SET @ShiftCount=(SELECT COUNT(*) FROM #MonthWiseFinalNewNet)  
		--Select  @ShiftCount
  IF @ShiftCount<=2
   begin
  Delete #MonthWiseFinalNewNet where Property=UPPER('Internal Property'); 
   
   INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		select p.PropertyName ,p.Category,p.Id, 
	    dbo.CommaSeprate(ISNULL(sum(0),0)), dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)) ,1 
		from WRBHBProperty p where  p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property' 
		GROUP BY p.PropertyName,p.Category,p.Id 
   end
   
		

       INSERT INTO	#GrandTotalAll( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)   
		from #MonthWiseNet where PropertyType='Internal Property'
	  -----final select for External
  
	   INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('External Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
	--	from #MonthWiseFinal 
	--Select * from #MonthWiseFinalNewNet
	--order by PrintInvoice desc
	--return;	
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'online' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,'BTC'PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))   
		from #MonthWiseNet 
		WHERE PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,'Pay at property'PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseNet 
		where PropertyType='External Property' and TariffPaymentMode='Direct';
  
        INSERT INTO #MonthWiseFinalNewNetExtTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,'BTC'PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)  
		from #MonthWiseNet 
		WHERE PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
	   INSERT INTO #MonthWiseFinalNewNetExtTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,'BTC'PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseNet 
		where PropertyType='External Property' and TariffPaymentMode='Direct';
		
		INSERT INTO	#MonthWiseFinalNewNetExtTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'MMT' Property,'MMT'PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)  
		from #MonthWiseNet 
		WHERE PropertyType='MMT'
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'MMT' Property,'MMT'PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))   
		from #MonthWiseNet 
		WHERE PropertyType='MMT' --and TariffPaymentMode='Bill To Company (BTC)'
	 
		 
		 INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		 Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		 select top 1 upper('Total Amount-External') Property,''PropertyType,''PropertyId,
		 dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
	     from #MonthWiseFinalNewNetExtTotal
	  INSERT INTO	#GrandTotalAll( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		 select top 1 upper('Total Amount-External') Property,''PropertyType,''PropertyId,
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)  
	     from #MonthWiseFinalNewNetExtTotal
	 
      INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
	--	Select * from #MonthWiseFinal 
    -- and  (CONVERT(date,CheckOutDate,103)) >  (CONVERT(DATE,GETDATE(),103))
--return;
	  -----final select for Managed
 
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('MANAGED G H') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property, 'MANAGED G H' PropertyType,PropertyId, 
		dbo.CommaSeprate(ISNULL((Jan),0)), dbo.CommaSeprate(ISNULL((FEb),0)),
		dbo.CommaSeprate(ISNULL((Mar),0)),dbo.CommaSeprate(ISNULL((Aprl),0)),
		dbo.CommaSeprate(ISNULL((may),0)),dbo.CommaSeprate(ISNULL((Jun),0)),
		dbo.CommaSeprate(ISNULL((Jul),0)),dbo.CommaSeprate(ISNULL((Aug),0)),
		dbo.CommaSeprate(ISNULL((Sept),0)),dbo.CommaSeprate(ISNULL((Oct),0)),
		dbo.CommaSeprate(ISNULL((Nov),0)),dbo.CommaSeprate(ISNULL((Decm),0)) 
		from #MonthWiseFinalGH where PropertyType='MANAGED G H'
		--and (isnull(Jan,'')+isnull(FEb,'')+isnull(Mar,'')+isnull(Aprl,'')+isnull(may,'')+isnull(Jun,'')
		--+isnull(Jul,'')+isnull(Aug,'')+	isnull(Sept,'')+isnull(Oct,'')+isnull(Nov,'')+isnull(Decm,''))!=0
		and (Jan+FEb+Mar+Aprl+may+Jun+Jul+Aug+Sept+Oct+Nov+Decm)!=0

		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 COALESCE(upper('Total Amount-MANAGED GH'),'#FFFFFF') Property,''PropertyType,''PropertyId, 
		 --sum(Jan) ,sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinalGH where PropertyType='MANAGED G H' 
 --Grand Total Sending
	    INSERT INTO	#MonthWiseGrandTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinalGH where PropertyType='MANAGED G H' --or  PropertyType='Internal Property'
 --Grand Total Sending	  
     
	     INSERT INTO	#GrandTotalAll( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-GH') Property,''PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)  
		from #MonthWiseFinalGH where PropertyType='MANAGED G H'
	      Truncate table #MonthWiseGrandTotal;
 
 
  --Declare @ShiftCounts int;
		-- SET @ShiftCounts=(SELECT COUNT(*) FROM #GrandTotalAll where PropertyType='MANAGED G H')  
		-- Select  @ShiftCounts;
  --IF @ShiftCounts<=2
  -- begin
  ----Delete #MonthWiseFinalNewNet where PropertyType=UPPER('MANAGED G H'); 
   
  -- INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice)
		--select 'Not Booked'PropertyName ,''Category,''Id, 
	 --   dbo.CommaSeprate(ISNULL(sum(0),0)), dbo.CommaSeprate(ISNULL(sum(0),0)),
		--dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		--dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		--dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		--dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)),
		--dbo.CommaSeprate(ISNULL(sum(0),0)),dbo.CommaSeprate(ISNULL(sum(0),0)) ,1 
		 
  -- end
   
      INSERT INTO  #MonthWiseGrandTotal( Property,PropertyType,PropertyId, 
		  Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		 select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId,
		 sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	     sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
	     from #GrandTotalAll
	     
	    -- INSERT INTO	#GrandTotalAll( Property,PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
	     
	     INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		  Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm) 
		
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId,
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseGrandTotal  
	 
		Select Property PropertyName,PropertyType,PropertyId PropertyId, 
		isnull(Jan,'')JAN ,isnull(FEb,'') FEB,isnull(Mar,'')MARCH,isnull(Aprl,'')APRL,
		isnull(may,'')MAY,isnull(Jun,'')JUNE, ISNULL(JUL,'') JULY,
		 ISNULL(AUG,'') AUG,
		isnull(Sept,'')SEPT,isnull(Oct,'')OCT,isnull(Nov,'')NOV,isnull(Decm,'')DEC,0 as SNo 
		from #MonthWiseFinalNewNet  order by PrintInvoice desc
		END
 END  
 
 
 
