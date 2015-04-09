-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ReportForeCast_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ReportForeCast_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:o2-06-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Report Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_ReportForeCast_Help](
@Action NVARCHAR(100),
@Pram1	 BIGINT, 
@Pram2	 BIGINT,
@Pram3	 NVARCHAR(100),
@Pram4	 NVARCHAR(100),
@Pram5	 NVARCHAR(100),
@UserId  BIGINT)			
AS
BEGIN
--exec SP_ReportForeCast_Help @Action='BookingForecast',@Pram1=0,@Pram2=0,@Pram3='01/11/2014',@Pram4='',@Pram5='External Property',@UserId=1
IF @Action ='PropertyAndCity'
 BEGIN
	
	  CREATE TABLE #PROPERTYCITY(PropertyName NVARCHAR(100),Id BIGINT,Category NVARCHAR(100))
	  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
	  SELECT  'All Properties',0,'' 
	  IF @Pram5='All Properties'
	  BEGIN	
          INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
		  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
		  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('Internal Property','Managed G H','External Property')	  
	  END
	  ELSE
	  BEGIN 
		  IF(@Pram5='Internal Property')
		  BEGIN	
			  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
			  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
			  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('Internal Property','Managed G H')
		  END
		  ELSE
		  BEGIN
			  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
			  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
			  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('External Property')
		  END
	  END
	  SELECT  PropertyName,Id ZId FROM #PROPERTYCITY 
	  
	  SELECT CityName,Id FROM WRBHBCity  
	  WHERE IsActive=1 AND IsDeleted=0 
	  --AND Category in('Internal Property','Managed G H') ;
	  
	  SELECT ClientName,Id FROM WRBHBClientManagement
	  WHERE IsActive=1 AND IsDeleted=0 
	  ORDER BY ClientName ASC	  
 END 
 IF @Action ='BookingForecast'
 BEGIN 
	   

CREATE TABLE #TFFINAL(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),TotalDays Bigint,Markupamount Decimal(27,2) )
  
CREATE TABLE #MonthWise(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),PrintInvoice bit,Markupamount decimal(27,2))
 
CREATE TABLE #MonthWiseFinal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),TariffPaymentMode nvarchar(100),PrintInvoice bit,Bookingid Bigint,
CityId Bigint,GtvAmount Decimal(27,2))

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
 
 
 
  --drop table #TFFINALS
CREATE TABLE #TFFINALS(GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
TariffTotal DECIMAL(27,2),CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),Occupancy nvarchar(100),
BookingId BIGINT,ChkInHdrId BIGINT ,ChkoutId BIGINT,TariffPaymentMode NVARCHAR(100),
TotalDays Bigint ,IDE bigint NOt null primary Key Identity(1,1),Btypes nvarchar(300),CurrentStatus nvarchar(100),
RoomShiftingFlag int)

CREATE TABLE #TFFINALSs(RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
TariffTotal DECIMAL(27,2),CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),Occupancy nvarchar(100),
BookingId BIGINT,ChkInHdrId BIGINT ,ChkoutId BIGINT,TariffPaymentMode NVARCHAR(100),
TotalDays Bigint ,IDE bigint NOt null primary Key Identity(1,1),Btypes nvarchar(300),CurrentStatus nvarchar(100) )



INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes,RoomShiftingFlag) 

			Select  D.FirstName,GuestId,RoomId,D.RoomType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103),
			DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,D.Occupancy ,
			BookingId,isnull(D.CheckOutHdrId ,0),isnull(D.CheckInHdrId,0),TariffpaymentMode,D.CurrentStatus,'RoomLvl'Btypes,RoomShiftingFlag
			from WRBHBBooking H
			JOIN WRBHBBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			WHERE d.RoomShiftingFlag=0  AND D.CurrentStatus !=('Canceled')
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client' 
			and BookingPropertyId in(1,2,3,6,7,267)
			  --and month(CONVERT(DATE,D.ChkOutDt,103))=11 and d.BookingPropertyId=2 
			GROUP BY  D.CheckOutHdrId ,D.FirstName,GuestId,RoomId,D.RoomType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,D.CheckOutHdrId,D.CheckInHdrId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,
			D.CurrentStatus,D.Occupancy ,RoomShiftingFlag

 INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes,RoomShiftingFlag) 
			
			Select  D.FirstName,GuestId,RoomId,D.BedType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103)
			,DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,'BedBook',
			BookingId,0,0,TariffpaymentMode,D.CurrentStatus,'BedLvl'Btypes,RoomShiftingFlag
			from WRBHBBooking H
			JOIN WRBHBBedBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			WHERE    D.CurrentStatus !='Canceled' and BookingPropertyId in(1,2,3,6,7,267)
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client'--and d.BookingPropertyId=2 
			GROUP BY D.FirstName,GuestId,RoomId,D.BedType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,D.CurrentStatus ,
			RoomShiftingFlag



  
			 INSERT INTO #TFFINALS( GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
						TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
						TariffPaymentMode,CurrentStatus,Btypes,RoomShiftingFlag) 
			Select  D.FirstName,GuestId,D.ApartmentId,D.ApartmentType,ClientName,''Property,d.BookingPropertyId PropertyId,
			'Internal Property'PropertyType,Tariff,CONVERT(NVARCHAR,d.ChkOutDt,103),CONVERT(NVARCHAR,d.ChkInDt,103),
			DateDiff(day,d.ChkInDt,d.ChkOutDt) NofDays,'Apartment',
			BookingId,0,0,TariffpaymentMode,D.CurrentStatus,'ApartLvl'Btypes,RoomShiftingFlag
			from WRBHBBooking H
			JOIN WRBHBApartmentBookingPropertyAssingedGuest D ON H.Id=D.BookingId
			WHERE    D.CurrentStatus !='Canceled' and BookingPropertyId in(1,2,3,6,7,267)
			AND D.IsActive=1 and D.IsDeleted=0 AND TariffPaymentMode!='Bill to Client'--and d.BookingPropertyId=2 
			GROUP BY D.FirstName,GuestId,ApartmentId,D.ApartmentType,ClientName,d.BookingPropertyId,d.ChkInDt,
			Tariff,CheckOutDate,BookingId,d.ChkInDt,Tariff,D.ChkOutDt,TariffpaymentMode,D.CurrentStatus,
			RoomShiftingFlag


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
 
 --Select * from #TFFINALS where RoomShiftingFlag=1
 
 -- Select * from #TFFINALS
  --where BookingiD in (5278)


INSERT INTO #TFFINALSs( RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes) 
					
 Select 0 RoomId,''Typess,ClientName,Property,PropertyId,PropertyType,
			TariffTotal,CheckOutDate,CheckInDate,TotalDays,Occupancy,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,CurrentStatus,Btypes from #TFFINALS 
 where -- month(CONVERT(DATE,CheckOutDate,103))=11
  Occupancy ='Single'-- and PropertyId=2
 group by  RoomId,ClientName,Property,PropertyId,PropertyType,
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
		 

 --Select * from #TFFINALSs  where PropertyId =2 AND BookingId=4681  
   -- order by BookingId; 
 
  Declare  @Count BIGINT ,@j int,@Tariff DECIMAL(27,2),@NoOfDays BIGINT;   
	 Declare  @CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(500),@GuestId BIGINT,@RoomId BIGINT;
     Declare  @Typess NVARCHAR(100),@ClientName NVARCHAR(200),@Property NVARCHAR(200),@PropertyId BIGINT;
     Declare  @PropertyType NVARCHAR(100),@CheckOutDate NVARCHAR(50),@CheckInDate  NVARCHAR(100);
     Declare  @BookingId BIGINT,@ChkoutId BIGINT,@ChkInHdrId BIGINT ,@TariffPaymentMode NVARCHAR(100);
     Declare  @PrintInvoice bit, @IDE Bigint,@TotalDays BIGINT,@TAC DECIMAL(27,2); 
     
     SELECT TOP 1 @Tariff=TariffTotal , 
     @NoOfDays=TotalDays,--DATEDIFF(day, CONVERT(DATE,CheckInDate ,103), CONVERT(DATE,CheckOutDate,103)),
     @CheckOutNo= 0,@GuestName=0,@GuestId=0,@RoomId=RoomId,
     @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
     @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,@CheckInDate=CheckInDate,
     @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
     @PrintInvoice=0 ,@J=0,@TotalDays=TotalDays,@IDE=IDE   FROM #TFFINALSs 
    
    --SELECT @NoOfDays;
     WHILE (@NoOfDays>0)   
     BEGIN         
		INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays,Markupamount)
		SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId, @Typess,@ClientName,@Property,@PropertyId,@PropertyType,
		@Tariff, CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate  ,103)),103),@CheckOutDate,--
		--@CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
		 @BookingId,@ChkoutId,@ChkInHdrId,
		@TariffPaymentMode, @PrintInvoice,1  ,0
			 SET @J=@J+1  
			 SET @NoOfDays=@NoOfDays-1   
		IF @NoOfDays=0  
			 BEGIN    
			 
				 DELETE FROM #TFFINALSs WHERE IDE=@IDE  --CheckOutNo =@CheckOutNo
					
			     SELECT TOP 1 @Tariff=TariffTotal , 
				 @NoOfDays= TotalDays,-- DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103)),
				 @CheckOutNo= 0,@GuestName=0,@GuestId=0,@RoomId=RoomId,
				 @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
				 @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,
				 @CheckInDate= CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(CheckInDate AS DATE)),103)  ,
				 @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
				 @PrintInvoice=0 ,@J=0 ,@IDE=IDE FROM #TFFINALSs 
			 END 
			  
     END   
    --  Select * from #TFFINAL WHERE MONTH(CONVERT(DATE,CheckOutDate,103))= 12
    -- order by BookingId;return;
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
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0   and Tariff>100
   
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
		TariffPaymentMode,PrintInvoice,Markupamount)
		
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
		TariffPaymentMode,PrintInvoice,Markupamount)
		
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
       UPDATE #TFFINAL SET PropertyType = P.Category 
	 FROM #TFFINAL F 
	 left outer JOIN  WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PropertyId  AND P.IsActive=1 AND IsDeleted=0
	 WHERE F.PropertyType='Managed G H'
	 
   delete  from #TFFINAL where PropertyType='External Property'-- and TariffPaymentMode='Direct'
   ---For Externals
   	  CREATE TABLE #ExternalForecastNew(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays bigint,RoomCapture Bigint) 
	  
      CREATE TABLE #ExternalForecasts(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint,RoomCapture Bigint)
	  truncate table  #ExternalForecasts
	    INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays ,g.RoomCaptured
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  -- and PropertyId=752
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus IN ('Booked')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category, g.RoomCaptured, 
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer  
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
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
		 AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category, g.RoomCaptured, 
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
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
		 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category, g.RoomCaptured, 
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
	--oly for cpp  below select Working	 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1-SingleTariff,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,g.ChkInDt,g.ChkOutDt) as nodays , g.RoomCaptured--,G.CurrentStatus  
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
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,g.RoomCaptured,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,SingleandMarkup1,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
	       
	     INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays,RoomCapture) 
			Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
			convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
			--Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
			ServicePaymentMode,TariffPaymentMode,Tariff,SingleandMarkup,Markup,Bp.PropertyId Id ,
			ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays ,ag.RoomCaptured
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT' and AG.CurrentStatus in('Booked','CheckIn','CheckOut')
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
			where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
			Group by C.id,Ag.guestid,Ag.RoomType,ag.FirstName,Ag.ChkInDt,Ag.ChkOutDt,CurrentStatus,
			AG.Occupancy,Tariff,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,s.HotalId ,
			ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),Bp.PropertyId,AG.RoomCaptured
			
			
			
  	UPDATE #ExternalForecasts SET NofDays=NoOfDays FROM #ExternalForecasts S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut';
 

truncate table #ExternalForecastNew;

  
    INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0),RoomCapture FROM #ExternalForecasts
	WHERE Occupancy='Single'
	group by BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture
	
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture)
	SELECT BookingId,''PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0),RoomCapture FROM #ExternalForecasts
	WHERE Occupancy!='Single'
	GROUP BY BookingId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays,RoomCapture
	
	
	 update #ExternalForecastNew set NofDays=1   where NofDays=0;
	
	 
	 -- Select * from #ExternalForecastNew where BookingId=11152-- category ='External Property'
	  --and PropertyId=752 
	 --  order by BookingId;return;
	     
    Declare @Tacinvoice int;Declare @Category nvarchar(100),@Markup Decimal(27,2),@SingleTariff Decimal(27,2);
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC,@Markup=Markup,@SingleTariff=SingleTariff
    FROM #ExternalForecastNew 
      --Select @NoOfDays
    WHILE (@NoOfDays>=1)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
            BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice,Markupamount)
             
	 Select 0 RoomId,@PropertyId,@Tariff,@Category,''Property,isnull(@Typess,'') ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice,@Markup  --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=isnull(@NoOfDays,0)-1
		IF isnull(@NoOfDays,0)=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC,@Markup=Markup,
			@SingleTariff=SingleTariff
			FROM #ExternalForecastNew  
		END    
    END  
    --Select * from  #TFFINAL where PropertyType like '%MMT%' 
  --return;
 --Tariff	
 -- Update #TFFINAL Set Markupamount=0 
	--where PropertyType='External Property' and TariffPaymentMode='Bill to Company (BTC)'	
		 
		INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
		PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,Tariff,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Markupamount) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
			PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,ChkOutTariffTotal,0 Dedicat,0 Direct,0 Btc,0 Onlin,0 Gtv,0 Total,PrintInvoice,Markupamount
			FROM #TFFINAL  WHERE
			month(CONVERT(DATE,CheckOutDate,103))=month(CONVERT(DATE,@Pram3,103))
             AND YEAR(CONVERT(DATE,CheckOutDate,103))=Year(CONVERT(DATE,@Pram3,103))
			--MONTH(CONVERT(DATE,CheckOutDate,103))= 10
		--	AND YEAR(CONVERT(DATE,CheckOutDate,103))=2014
  
 --Select * from #MonthWise  where BookingId=11152-- PropertyType not in('Internal Property','MANAGED G H') -- and TariffPaymentMode!='Direct'-- and PropertyId=793
  --  and MONTH(CONVERT(DATE,CheckOutDate,103))= 2
  -- AND YEAR(CONVERT(DATE,CheckOutDate,103))=2014
 --   order by BookingId
  --   return; 

	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(Tariff) Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId,0
	from #MonthWise F
	left outer join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0  and TariffPaymentMode='Bill to Company (BTC)'  
	GROUP BY p.PropertyName,p.Category,p.Id  ,f.Bookingid,p.CityId
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,sum(Tariff) Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId,0
	from #MonthWise F
	left outer join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	GROUP BY p.PropertyName,p.Category,p.Id ,f.Bookingid,p.CityId
	
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,sum(Tariff) Dedicat,0 Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId,0
	from #MonthWise F
	left outer join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0  and Typess like ' Monthly '  
	GROUP BY p.PropertyName,p.Category,p.Id ,f.Bookingid,p.CityId
  
	 
	 UPDATE #MonthWise SET Property  = P.HotalName 
	 FROM #MonthWise F 
	 left outer JOIN  WRBHBStaticHotels p WITH(NOLOCK) ON p.HotalId=F.PropertyId AND P.IsActive=1 AND IsDeleted=0 
	 WHERE F.PropertyType='MMT'
	 
	 UPDATE #MonthWise SET Property = P.PropertyName 
	 FROM #MonthWise F 
	 left outer JOIN  WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PropertyId  AND P.IsActive=1 AND IsDeleted=0
	 WHERE F.PropertyType='External Property'
	 
	 
	 
		INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
		Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
			Select p.Property,P.PropertyType,P.PropertyId, 
			0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, 0 Gtv,
			sum(P.Tariff) Total,
			''PrintInvoice,P.Bookingid,0,0--PP.CityId 
			from #MonthWise  p 
			where P.PropertyType in ('External Property') and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Bill to Company (BTC)' 
			group by  p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,P.Bookingid 
			order by P.PropertyId
	 
		INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
		Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
			Select p.Property,P.PropertyType,P.PropertyId, 
			0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, 0 Gtv,sum(P.Tariff) Total,
			''PrintInvoice,P.Bookingid,0,0--PP.CityId 
			from #MonthWise  p 
			where P.PropertyType in ('MMT') and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Bill to Company (BTC)' 
			group by  p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,P.Bookingid 
			order by P.PropertyId

	If(@Pram5='All Properties') 
	Begin
		INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
		Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
		Select  p.Property,P.PropertyType, P.PropertyId,
			0  ,''TariffPaymentMode,0 Dedicat, SUM(Markupamount)  Direct,0 Btc,0 Onlin, SUM(0) Gtv,Sum(P.ChkOutTariffTotal) Total,
			''PrintInvoice,p.BookingId,0,SUM(P.ChkOutTariffTotal) -SUM(Markupamount) --p.CityId
			from #MonthWise  p
			where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
			group by   p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,p.BookingId--,Pp.CityId
			order by P.PropertyId
	end
	if(@Pram5='External Property') 
	Begin
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
		Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
		Select  p.Property,P.PropertyType, P.PropertyId,
			0  ,''TariffPaymentMode,0 Dedicat, SUM(Markupamount)  Direct,0 Btc,0 Onlin, SUM(0) Gtv,Sum(P.ChkOutTariffTotal) Total,
			''PrintInvoice,p.BookingId,0,SUM(P.ChkOutTariffTotal)--+SUM(Markupamount)--p.CityId
			from #MonthWise  p
			where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
			group by   p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,p.BookingId--,Pp.CityId
			order by P.PropertyId
	END
	
      UPDATE #MonthWiseFinal SET CityId = P.CityId 
	  FROM #MonthWiseFinal F 
	  JOIN WRBHBBooking p WITH(NOLOCK) ON p.Id=F.BookingId AND P.IsActive=1 AND IsDeleted=0
	 
      UPDATE #MonthWiseFinal SET PropertyType = 'External Property'
	  FROM #MonthWiseFinal F  
	  WHERE F.PropertyType='MMT';
	  
	  
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId,GtvAmount)
	
	SELECT Property PropertyName,m.PropertyType PropertyType,m.PropertyId,
	0  ,''TariffPaymentMode,sum(Tariff) Dedicat,0 Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	PrintInvoice,m.Bookingid,P.CityId,0
	FROM #MonthWise m
	join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
	JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0  
	where m.PropertyType='MANAGED G H' and TariffPaymentMode='0' and ChkOutTariffTotal!=0
	group by Property,m.PropertyId,m.PropertyType,PrintInvoice,m.Bookingid,P.CityId
	order by m.PropertyId
	 
	 --Select * from #MonthWiseFinal   where  Property like '%Confident Propus - A Boutique Hotel%'
	 --Return	
	
	-- select * from #TFFINAL  where PropertyId=594
   -- and MONTH(CONVERT(DATE,CheckOutDate,103))= 2
	 
	If(@Pram5='All Properties') 
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(0) Online,Sum(Direct+Btc+Dedicat) Total,Sum(GtvAmount+Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
	 	JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId --AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(0) Online,Sum(Direct+Btc+Dedicat) Total,Sum(GtvAmount+Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	if(@Pram5='External Property') 
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Direct+Btc+Dedicat) Total,Sum(GtvAmount+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
		JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId --AND C.IsActive=1 AND C.IsDeleted=0 
		where m.PropertyType='External Property'
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Gtv) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Gtv+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	if(@Pram5='Internal Property')  
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
		JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId --AND C.IsActive=1 AND C.IsDeleted=0 
		where m.PropertyType='Internal Property'
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	
	if(@Pram5='Managed G H')  
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
		JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId --AND C.IsActive=1 AND C.IsDeleted=0 
		where m.PropertyType='Managed G H'
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		SUM(Onlin) Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	
	 --Select * from #Temp1Final  
	 --Return	
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
	Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData
	From #Temp1Finals
	order by OrderData 
	
 END
END




	
	