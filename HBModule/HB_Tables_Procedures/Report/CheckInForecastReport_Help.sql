SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_CheckInForecastReport_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_CheckInForecastReport_Help
GO 

CREATE PROCEDURE Sp_CheckInForecastReport_Help
(
	@Action NVARCHAR(100)=NULL,
	@Pram1 NVARCHAR(100)=NULL,    --int
	@Pram2  NVARCHAR(100)=NULL,   --int
	@Pram3 NVARCHAR(100)=NULL,--@FromDate
	@Pram4  NVARCHAR(100)=NULL,--@ToDate
	@Pram5  NVARCHAR(100)=NULL,
	@UserId int
)
AS 
BEGIN 
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
-- exec  Sp_CheckInForecastReport_Help @Action='CheckInForecast',@Pram1=0,@Pram2=0,@Pram3='01/11/2014',@Pram4='',@Pram5='INTERNAL Property',@UserId=1
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
 IF @Action ='CheckInForecast'
		Begin  
		  
 CREATE TABLE #FIRSTDATAS (CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT,
CheckInDate  NVARCHAR(100),NoOfDays bigint,TotalAmt decimal(27,2),PrintInvoice bit ,BillDate  Nvarchar(100),
TariffpaymentMode NVARCHAR(100))

 
CREATE TABLE #TFMODES(TariffPaymentMode NVARCHAR(200),BookingId BIGINT,GuestId BIGINT,RoomId BIGINT,
BookingPropertyId BIGINT,Tariff DECIMAL(27,2) ,CheckOutDate NVARCHAR(50),CheckInDate Nvarchar(100)
)

 

CREATE TABLE #TEST(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TotalDays Bigint,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),BillDate Nvarchar(100)  )

CREATE TABLE #MonthWise(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),PrintInvoice bit,GTVAmount Decimal(27,2),Direct1Amt Decimal(27,2))


CREATE TABLE #MonthWise1(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),PrintInvoice bit)

 
CREATE TABLE #MonthWiseFinal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),TariffPaymentMode nvarchar(100),PrintInvoice bit,Bookingid Bigint,
CityId Bigint,CityName nvarchar(500),DirectAmt1 Decimal(27,2))

CREATE TABLE #MonthWiseFinal1( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),TariffPaymentMode nvarchar(100),PrintInvoice bit)


CREATE TABLE #MonthWiseFinalNew( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNewNet( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
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
PrintInvoice bit)


Create Table #Temp1Final(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2),Pid Bigint,CityId Bigint )

Create Table #Temp1Finals(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2),Pid Bigint )

--truncate table #Test
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


CREATE TABLE #TFFINAL(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),TotalDays Bigint,GTVAmount Decimal(27,2) ,
Direct1Amt Decimal(27,2))

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
			WHERE d.RoomShiftingFlag=0  AND CurrentStatus !=('Canceled')
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
			WHERE    CurrentStatus !='Canceled' --and BookingPropertyId in(1,2,3,6,7,267)
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
			WHERE    CurrentStatus !='Canceled'-- and BookingPropertyId in(1,2,3,6,7,267)
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client'--and d.BookingPropertyId=2 
			GROUP BY D.FirstName,GuestId,ApartmentId,D.ApartmentType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,D.CurrentStatus


 Update #TFFINALS set TotalDays =C.NoOfDays,CheckOutDate=CONVERT(NVARCHAR,c.CheckOutDate,103)
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
 where c.PropertyType='Internal Property' AND  f.ChkInHdrId!=0 AND
  CurrentStatus in ('CheckIn','CheckOut') 
 

	update #TFFINALS set   CheckOutDate = CONVERT(nvarchar(100),GETDATE(),103) ,
	TotalDays= DateDiff(day,CONVERT(date,CheckInDate,103),CONVERT(Date,GETDATE(),103)) 
	where CurrentStatus in ('CheckIn') 
	and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103)
	
	
	update #TFFINALS set TotalDays= DateDiff(day,CONVERT(date,CheckInDate,103),CONVERT(Date,CheckOutDate,103)) 
	where CurrentStatus in ('CheckIn','CheckOut') 
	 
	----Select  DateDiff(day,CONVERT(date,CheckInDate,103),GETDATE())   from #TFFINALS 
	-- Select * from #TFFINALS where CurrentStatus in ('CheckIn') 
	-- and CONVERT(date,CheckOutDate,103) >= CONVERT(Date,GETDATE(),103) 
 
 --Select * from #TFFINALS where BookingId=6059

 --order by BookingId
 
INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 
					
 Select RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
 where -- month(CONVERT(DATE,CheckOutDate,103))=11
  Occupancy ='Single'-- and PropertyId=2
 group by RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
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
 order by BookingId 
 
	 UPDATE #TFFINALSs SET TotalDays=1 WHERE ISNULL(TotalDays,0)=0
	 Delete #TFFINALSs where CurrentStatus='Booked'	 
     Delete #TFFINALSs   WHERE ISNULL(TotalDays,0)< 0-- and  CONVERT(DATE,CheckInDate,103) <CONVERT(DATE,'01/09/2014',103) 
 --Select * from #TFFINALS where BookingId=4791
  --Select * from WRBHBBookingPropertyAssingedGuest 
 --where BookingId=3837
 
 -- Select * from WRBHBApartmentBookingPropertyAssingedGuest 
 --where BookingId=7298
 
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
		INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,PropertyType,ClientName,Property,PropertyId,Typess,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays,GTVAmount,Direct1Amt)
		SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId,  @PropertyType ,@ClientName,@Property,@PropertyId,@Typess  ,
		@Tariff, CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate  ,103)),103),@CheckOutDate,--
		--@CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
		 @BookingId,@ChkoutId,@ChkInHdrId,
		@TariffPaymentMode, @PrintInvoice,1  ,0,0 
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
       DELETE #TFFINAL where CONVERT(DATE,CheckOutDate,103)> CONVERT(DATE,GETDATE(),103)	 
     --Select * from #TFFINAL   where   BookingId=4791   
  --order by  BookingId 
   --  order by BookingId;return;
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
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0  and Tariff>100
   
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
   delete  from #TFFINAL where PropertyType='External Property'-- and TariffPaymentMode='Direct'
   ---For Externals
   
      Declare @Tacinvoice int;Declare @Category nvarchar(100);  
   --  Select SingleTariff,SingleandMarkup,Markup,  
		 --PropertyId,TAC,TACPer,NofDays from #ExternalForecast
	  CREATE TABLE #ExternalForecastNew1(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays bigint,RoomCapture BIGINT) 
	  
      CREATE TABLE #ExternalForecasts1(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint,RoomCapture BIGINT)
	 -- truncate table  #ExternalForecasts
	    INSERT INTO #ExternalForecasts1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays ,g.RoomCaptured
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus not IN ('Booked')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,G.CurrentStatus,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer ,g.RoomCaptured 
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecasts1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103)) ,g.RoomCaptured   
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
		 G.CurrentStatus,g.RoomCaptured
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecasts1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103)),g.RoomCaptured   
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
		 G.CurrentStatus,g.RoomCaptured
	--oly for cpp  below select Working	 
		 INSERT INTO #ExternalForecasts1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,g.ChkInDt,g.ChkOutDt) as noday,
		 g.RoomCaptured--,G.CurrentStatus  
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
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category, g.RoomCaptured, 
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
	       
	     INSERT INTO #ExternalForecasts1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture) 
Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
--Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,0 Id ,
ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as noday,ag.RoomCaptured
from wrbhbbooking C
join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		and  PropertyType='MMT' 
LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
 where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
  
 
		UPDATE #ExternalForecasts1 SET NofDays=NoOfDays FROM #ExternalForecasts1 S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut';
	--Truncate table  #ExternalForecastNew1;
		 INSERT INTO #ExternalForecastNew1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture)
	SELECT BookingId,isnull(PropertyAssGustId,0),RoomName,GuestName,CheckInDt,CheckOutDt,Type,isnull(Occupancy,''),  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,isnull(TAC,''),TACPer,isnull(NofDays,0),RoomCapture FROM #ExternalForecasts1
	WHERE Occupancy='Single'   		
	group by  BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays ,RoomCapture
	
	INSERT INTO #ExternalForecastNew1(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture)
	SELECT BookingId,isnull(0,0),RoomName,'',CheckInDt,CheckOutDt,Type,isnull(Occupancy,''),  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,isnull(TAC,''),TACPer,isnull(NofDays,0),RoomCapture FROM #ExternalForecasts1
	WHERE Occupancy!='Single'  
	GROUP BY BookingId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture
--	Select * from WRBHBBookingPropertyAssingedGuest where BookingId in(5820,5822)
	
 update #ExternalForecastNew1 set NofDays=1 where isnull(NofDays,0)=0;
 
 update #ExternalForecastNew1 set   CheckOutDt = CONVERT(nvarchar(100),GETDATE(),103) ,
	NofDays= DateDiff(day,CONVERT(date,CheckInDt,103),CONVERT(Date,GETDATE(),103)) 
	where Type in ('CheckIn') and Category!='MMT'
	and CONVERT(date,CheckOutDt,103) > CONVERT(Date,GETDATE(),103)
--	Delete #ExternalForecastNew1 where Type in('Booking');
	 
 update #ExternalForecastNew1 Set RoomId=0,RoomType='',DataGetType=''
   --return;
 --If(@Pram5='All Properties')
	--Begin 
 --  delete from  #TFFINAL where propertyType='External Property';
 --   delete from  #TFFINAL where propertyType='MMT';
 --end
  
 --If(@Pram5='External Property')
	--Begin 
    --delete from  #TFFINAL where propertyType='External Property';
    -- delete from  #TFFINAL where propertyType='MMT';
 --end
 -- Select * from #TFFINAL
  --return;
  --Select * from WRBHBCheckInHdr where PropertyType like '%External%' order by Id desc
    -- select * from #ExternalForecastNew1		 
   --where MONTH(CONVERT(DATE,CheckOutDt,103))= 12 and NofDays>0
  
  Update #ExternalForecastNew1 Set NofDays=1 where NofDays=0;
  
 --Select * from    #ExternalForecastNew1 where Category like '%External%'
-- and month(CONVERT(DATE,CheckOutDt,103))=12 return;
  Declare @Markup Decimal(27,2);
  Declare @SingleandMarkup decimal(27,2), @SingleTariff  decimal(27,2) ;
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
    @SingleTariff=isnull(SingleTariff,0),
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=isnull(TAC,''),@Markup=Markup
    FROM #ExternalForecastNew1  WHERE TAC=1  
     --Select @NoOfDays
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,GTVAmount,Direct1Amt)
             
	 Select 0 RoomId,@PropertyId,isnull(((@Tariff*@TAC)/100),0),@Category,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice,@Markup,@SingleTariff  --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew1 WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@SingleTariff=isnull(SingleTariff,0),
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=isnull(TAC,''),@Markup=Markup
			FROM #ExternalForecastNew1  WHERE TAC=1 
		END   
         
    END  
  
  -- For tAc=0
    --select * from #ExternalForecastNew1	 where Category='MMt' and MONTH(CONVERT(DATE,CheckOutDt,103))= 12 and NofDays>0
   -- order by IDE 
  -- where NofDays<0
   
    SELECT TOP 1  @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@SingleandMarkup=isnull(SingleandMarkup,0),
    @SingleTariff=isnull(SingleTariff,0),@Markup=Markup,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=isnull(TAC,''),@Markup=Markup
    FROM #ExternalForecastNew1  WHERE TAC=0 -- and month(CONVERT(DATE,CheckOutDt,103))=11 
  --  Select  @NoOfDays,@Tariff,@TariffPaymentMode
    --  Select isnull((@SingleandMarkup-@SingleTariff),0)+@Markup as dd
    WHILE (@NoOfDays>0)  
    BEGIN   
     	    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,GTVAmount,Direct1Amt)
             
	 Select 0 RoomId,@PropertyId,isnull(@Tariff,0), --isnull(@SingleandMarkup,0),--@SingleTariff),0)+@Markup,
	 @Category,''Property,@Typess ,
     @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode, @Tacinvoice,@Markup,@SingleTariff --from #ExternalForecast WHERE TAC=1 
	    --Select  @NoOfDays  
		SET @j=@j+1  
		SET @NoOfDays=isnull(@NoOfDays,0)-1  
		IF isnull(@NoOfDays,0)=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew1 WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@SingleandMarkup=isnull(SingleandMarkup,0),  @SingleTariff=isnull(SingleTariff,0), 
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=isnull(TAC,''),@Markup=Markup
			FROM #ExternalForecastNew1  WHERE TAC=0 --and month(CONVERT(DATE,CheckOutDt,103))=11 
		END   
         
    END  
     -- Delete #TFFINAL where Typess in('Booking');
 --Delete #TFFINAL where Typess in('CheckIn') and CONVERT(date,CheckOutDate,103) > CONVERT(Date,GETDATE(),103)

 --Tariff		 
		INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
		PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,Tariff,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,GTVAmount,Direct1Amt) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
			PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,ChkOutTariffTotal,0 Dedicat,0 Direct,0 Btc,0 Onlin,0 Gtv,0 Total,PrintInvoice,
			GTVAmount,Direct1Amt
			FROM #TFFINAL  WHERE
			month(CONVERT(DATE,CheckOutDate,103))=month(CONVERT(DATE,@Pram3,103))
             AND YEAR(CONVERT(DATE,CheckOutDate,103))=Year(CONVERT(DATE,@Pram3,103))
             --and PropertyType='External Property'  
			--MONTH(CONVERT(DATE,CheckOutDate,103))= 10
		--	AND YEAR(CONVERT(DATE,CheckOutDate,103))=2014
 
			--Select * from  #MonthWise  return;
			Update #MonthWise set PropertyType=p.Category
			from #MonthWise M 
			join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1 ;
	--Update #MonthWise Set GTVAmount=0 
	--where PropertyType='External Property' and TariffPaymentMode='Bill to Company (BTC)'	
 ---- Select * from    #TFFINAL  where PropertyType='MMT'
   --Select * from  #MonthWise where   PropertyType !='Internal Property' and
  -- MONTH(CONVERT(DATE,CheckOutDate,103))= 12 order by BookingId
   --TariffPaymentMode='Direct'--  PropertyType not in('Internal Property','MANAGED G H')
   --return;
    --Select * from #MonthWise  where  PropertyType in ('External Property','MMT') and-- where PropertyId=594
   --   MONTH(CONVERT(DATE,CheckOutDate,103))= 2	 return	 
   
   --Select * from    #MonthWise where PropertyType like '%External%'    
   --and month(CONVERT(DATE,CheckOutDate,103))= 2 
   --order by BookingId return;
  
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(Tariff) Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId,'',0
	from #MonthWise F
	left outer join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0  and TariffPaymentMode='Bill to Company (BTC)'  
	GROUP BY p.PropertyName,p.Category,p.Id  ,f.Bookingid,p.CityId
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,sum(Tariff) Direct,0 Btc,0 Onlin,SUM(GTVAmount) Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId,'',0
	from #MonthWise F
	left outer join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	GROUP BY p.PropertyName,p.Category,p.Id ,f.Bookingid,p.CityId
   
	
	   UPDATE #MonthWise SET Property = P.PropertyName 
	  FROM #MonthWise F 
	   JOIN WRBHBBookingProperty p WITH(NOLOCK) ON p.BookingId=F.BookingId AND P.IsActive=1 AND IsDeleted=0
	 
	 UPDATE #MonthWise SET Property = P.PropertyName 
	 FROM #MonthWise F 
	 JOIN  WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PropertyId  AND P.IsActive=1 AND IsDeleted=0
	 WHERE F.PropertyType='External Property'
	 
	 
	 UPDATE #MonthWise SET Property  = P.HotalName 
	 FROM #MonthWise F 
	 JOIN  WRBHBStaticHotels p WITH(NOLOCK) ON p.HotalId=F.PropertyId AND P.IsActive=1 AND IsDeleted=0 
	 WHERE F.PropertyType='MMT'
	--  Select * from #MonthWise  where   PropertyType='MMT'
	-- RETURN;
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	Select p.Property,P.PropertyType,P.PropertyId, 
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, SUM(0) Gtv,sum(P.Tariff) Total,
	''PrintInvoice,P.Bookingid,0,'',0--,P.CityId 
	from #MonthWise  p
 	where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Bill to Company (BTC)' 
	group by  p.Property,P.PropertyType,TariffPaymentMode,P.Bookingid,P.PropertyId
	order by BookingId--BP.PropertyId
	 
	 
	   
	 INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	 Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	Select p.Property,P.PropertyType,P.PropertyId, 
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, 0 Gtv,sum(P.Tariff) Total,
	''PrintInvoice,P.Bookingid,0,'',0--,P.CityId 
	from #MonthWise  p
	 where P.PropertyType='MMT' and P.ChkOutTariffTotal!=0 -- and TariffPaymentMode='Bill to Company (BTC)' 
	group by  p.Property,P.PropertyType,TariffPaymentMode,P.Bookingid,P.PropertyId
	order by BookingId--BP.PropertyId
	  
	
	  UPDATE #MonthWiseFinal SET CityId = P.CityId 
	  FROM #MonthWiseFinal F 
	  JOIN WRBHBBooking p WITH(NOLOCK) ON p.Id=F.BookingId AND P.IsActive=1 AND IsDeleted=0
  --Select *  from #MonthWise  where PropertyType in('External Property','MMT')  AND  Bookingid IN (18081,18227)
	   
	 
	--INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	--Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	--Select  Bp.PropertyName,P.PropertyType, BP.PropertyId,
	--0  ,''TariffPaymentMode,0 Dedicat,0   Direct,0 Btc,0 Onlin, SUM(GTVAmount) Gtv,Sum(P.ChkOutTariffTotal) Total,
	--''PrintInvoice,Bp.BookingId,Pp.CityId,'',SUM(P.ChkOutTariffTotal)
	--from #MonthWise  p
	--left outer JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON P.PropertyId=BP.PropertyId
	--AND BP.IsActive=1 AND BP.IsDeleted=0 and Bp.PropertyType='Exp'  and p.BookingId=Bp.BookingId
	--join WRBHBProperty PP on BP.PropertyId=pP.Id and pP.IsActive=1
	--where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	--group by   Bp.PropertyName,P.PropertyType,TariffPaymentMode,BP.PropertyId,Bp.BookingId,Pp.CityId
	--order by BP.PropertyId
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	select  Pp.PropertyName,P.PropertyType, P.PropertyId,
	0  ,''TariffPaymentMode,0 Dedicat,0   Direct,0 Btc,0 Onlin, SUM(GTVAmount) Gtv,Sum(P.ChkOutTariffTotal) Total,
	''PrintInvoice,P.BookingId,Pp.CityId,'',SUM(P.ChkOutTariffTotal)
	from #MonthWise  p
  --JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON P.PropertyId=BP.PropertyId
	--AND BP.IsActive=1 AND BP.IsDeleted=0 and Bp.PropertyType='Exp'  and p.BookingId=Bp.BookingId
	join WRBHBProperty PP on P.PropertyId=PP.Id and PP.IsActive=1
	where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	--AND P.Bookingid IN (18081,18227)
	group by   PP.PropertyName,P.PropertyType,TariffPaymentMode,P.PropertyId,p.BookingId,Pp.CityId
	order by P.PropertyId
	 	 
	   
	-- UPDATE #MonthWiseFinal SET PropertyType = 'External Property'
	--FROM #MonthWiseFinal F  
	--WHERE F.PropertyType='MMT';
	  
	  
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,CityName,DirectAmt1)
	
	SELECT Property PropertyName,m.PropertyType PropertyType,m.PropertyId,
	0  ,''TariffPaymentMode,sum(Tariff) Dedicat,0 Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	PrintInvoice,m.Bookingid,P.CityId,'',0
	FROM #MonthWise m
	join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
	JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0  
	where m.PropertyType='MANAGED G H' and TariffPaymentMode='0' and ChkOutTariffTotal!=0
	group by Property,m.PropertyId,m.PropertyType,PrintInvoice,m.Bookingid,P.CityId
	order by m.PropertyId
	 
	update  #MonthWiseFinal  Set CityName=c.CityName
	from #MonthWiseFinal m
	join wrbhbcity c on c.Id=m.CityId where c.IsActive=1 and IsDeleted=0;
	 
	  -- select  * from #MonthWiseFinal where PropertyType in('MMT', 'External Property')
	  --return
	update #MonthWiseFinal set Gtv=0 where  PropertyType in('MMT', 'External Property')
	If(@Pram5='All Properties')
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select m.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct)+SUM(Gtv) Direct,Sum(Btc) BTC,
		0 Online,Sum(Gtv+Direct+Btc+Dedicat) Total,Sum(Gtv+DirectAmt1+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m 
		where m.PropertyType='External Property'
		group by  Property,m.PropertyId,m.PropertyType,m.CityName,m.CityId
		order by m.PropertyType
		
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select m.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct)  Direct,Sum(Btc) BTC,
		0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Gtv+Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m 
		where m.PropertyType!='External Property'
		group by  Property,m.PropertyId,m.PropertyType,m.CityName,m.CityId
		order by m.PropertyType
		 
	End
	Else
	Begin
		If(@Pram5='External Property')
		Begin
			Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
			Select m.CityName CityName, Property PropertyName ,
			Sum(Dedicat) DD,Sum(Direct)+SUM(Gtv) Direct,Sum(Btc) BTC,
		    0 Online,Sum(Gtv+Direct+Btc+Dedicat) Total,Sum(Gtv+DirectAmt1+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		    from #MonthWiseFinal m 
			where m.PropertyType in('External Property','MMT')
			group by  Property,m.PropertyId,m.PropertyType,m.CityName,m.CityId
			order by m.PropertyType 
		End
		else
		Begin
			Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
			Select m.CityName CityName, Property PropertyName ,
			Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
			0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
			from #MonthWiseFinal m 
			where m.PropertyType =@Pram5
			group by  Property,m.PropertyId,m.PropertyType,m.CityName,m.CityId
			order by m.PropertyType 
		End
	End
	    
	 
	if(@Pram1=0)
	Begin
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,'A'OrderData
		From #Temp1Final 
		order by Category
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select ''CityName,'TOTAL'PropertyName,Sum(DD),Sum(Direct),Sum(BTC),Sum(Online),Sum(TOTAL),Sum(GTV),
		''Category,''Pid,'Z'OrderData
		From #Temp1Final
	End
	else
	Begin
	   	Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,'A'OrderData
		From #Temp1Final 
		Where CityId=@pram1
		order by Category
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select ''CityName,'TOTAL'PropertyName,Sum(DD),Sum(Direct),Sum(BTC),Sum(Online),Sum(TOTAL),Sum(GTV),
		''Category,''Pid,'Z'OrderData
		From #Temp1Final
		Where CityId=@pram1
	End
	--Group  by CityName,PropertyName,Category,Pid,OrderData 
	  Select 0;
	Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData
	From #Temp1Finals
	order by OrderData
	
	
	
	
	
	
	End--Action name checkin forcaST
	
End
 
	
	--Return;
	
--	 exec Sp_CheckInForecastReport_Help @Action='CheckInForecast',@Pram1=0,@Pram2=2014,
--@Pram3='01/10/2014',@Pram4='',@Pram5='All Properties',@UserId=1

-- exec Sp_CheckInForecastReport_Help @Action='CheckInForecast',@Pram1=0,@Pram2=2014,
--@Pram3='01/10/2014',@Pram4='',@Pram5='INTERNAL PROPERTY',@UserId=1
		
-- --	for second grid 


		 