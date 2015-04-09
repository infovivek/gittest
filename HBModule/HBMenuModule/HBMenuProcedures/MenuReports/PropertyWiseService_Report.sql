SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[HBMenu_PropertyWiseService_Report]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[HBMenu_PropertyWiseService_Report]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Booking_Report]    Script Date: 12/03/2014 10:07:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE HBMenu_PropertyWiseService_Report
(
	@Action NVARCHAR(100)=NULL,
	@PayMode NVARCHAR(100)=NULL, 
	@FromDate NVARCHAR(100)=NULL,
	@ToDate NVARCHAR(100)=NULL,
	@CityId Bigint,
	@PropertyId Bigint,
	@ClientId int,  --THIS IS CLIENT iD
	@ChkMode int,  --this is mothwise or datewise from front end {example:@ChkMode(month=1,Date=0)}
	@PrptyType Nvarchar(100),
	@MonthWise Bigint,
	@userId nvarchar(200)
	
)
AS 
BEGIN 
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
    --drop table #BookingSelect;
    --DROP TABLE #CheckInSelect;
    --DROP TABLE #CheckOutSelect;
    --DROP TABLE #BookingSelectFinal;
    --drop table #FinalSelect;
      CREATE TABLE #BookingSelect(BookingCode BIgint,ClientId BIGINT,ClientName Nvarchar(300),BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PropertyType NVARCHAR(100),ApartmentId BIGINT,CityId BIGINT,
	  PropertyName NVARCHAR(500),CityName NVARCHAR(500),RoomCaptured BIGINT);
	 
	  CREATE TABLE  #BookingSelectFinal(BookingCode BIGINT,ClientId BIGINT,ClientName Nvarchar(300),BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(200),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),
	  Tariff DECIMAL(27,2),DayDiff BIGINT,ApartmentId BIGINT,Category NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
	  TariffPaymentMode NVARCHAR(100),PropertyId BIGINT,PropertyType NVARCHAR(100),CityId BIGINT,CityName NVARCHAR(100),
	  PropertyName NVARCHAR(100),RoomCaptured BIGINT);
	  
	  
	  CREATE TABLE  #BookingTestFinal(BookingCode BIGINT,ClientId BIGINT,ClientName Nvarchar(300),BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(200),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),
	  Tariff DECIMAL(27,2),DayDiff BIGINT,ApartmentId BIGINT,Category NVARCHAR(100),ServicePaymentMode NVARCHAR(100),
	  TariffPaymentMode NVARCHAR(100),PropertyId BIGINT,PropertyType NVARCHAR(100),CityId BIGINT,CityName NVARCHAR(100),
	  PropertyName NVARCHAR(100));
	  

	CREATE TABLE  #FinalSelect(ClientId BIGINT,ClientName Nvarchar(300),Counts Bigint,BookingId BIGINT,CheckInDt NVARCHAR(100),
	CheckOutDt NVARCHAR(100),DayDiff BIGINT,Tariff DECIMAL(27,2),TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName NVARCHAR(100),TariffPaymentMode NVARCHAR(100),
	CityId Bigint,PropertyId BIGINT,PropertyType Nvarchar(100),GuestId BIGINT,RoomId BIGINT,RoomTypes NVARCHAR(500));

    CREATE TABLE  #FinalSelectTest(ClientId BIGINT,ClientName Nvarchar(300),Counts Bigint,BookingId BIGINT,CheckInDt NVARCHAR(100),
	CheckOutDt NVARCHAR(100),DayDiff BIGINT,Tariff DECIMAL(27,2),TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName NVARCHAR(100),TariffPaymentMode NVARCHAR(100),
	CityId Bigint,PropertyId BIGINT,PropertyType Nvarchar(100),GuestId BIGINT,RoomId BIGINT,RoomTypes NVARCHAR(500),
	IDS int NOT NULL PRIMARY KEY identity (1,1),Personcount bigint,occupancy NVARCHAR(100),Bookinglevel NVARCHAR(100));



	Create TABLE  #tempSDateFinal(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT,GuestId bigint)
	Create TABLE  #tempDatnew(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT)
	
	
	Create TABLE  #tempDat(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT,GuestId bigint)
	
	Create TABLE  #tempDats(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,MonthId int ,MonthDates NVARCHAR(100),BookingId BIGINT,GuestId bigint)
	
	 
	Create TABLE  #MonthWises(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,
	DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,MonthDates NVARCHAR(100), 
	Jan DECIMAL(27,2) null,Feb DECIMAL(27,2) null,Mar DECIMAL(27,2) null,Aprl DECIMAL(27,2) null,
	may DECIMAL(27,2) null,Jun DECIMAL(27,2)null,Jul DECIMAL(27,2) null,Aug DECIMAL(27,2)null,
	Sept DECIMAL(27,2)null,Oct DECIMAL(27,2)null,Nov DECIMAL(27,2),Decm DECIMAL(27,2), 
	A1 INT null,A2 INT null,A3 INT null,A4 INT null,A5 INT null,A6 INT null,
	A7 INT null,A8 INT null,A9 INT null,A10 INT null,A11 INT,A12 INT,
	B1 INT null,B2 INT null,B3 INT null,B4 INT null,B5 INT null,B6 INT null,
	B7 INT null,B8 INT null,B9 INT null,B10 INT null,B11 INT,B12 INT)
	 
	Create TABLE  #MonthWise(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,  
	Jan DECIMAL(27,2) null,Feb DECIMAL(27,2) null,Mar DECIMAL(27,2) null,Aprl DECIMAL(27,2) null,
	may DECIMAL(27,2) null,Jun DECIMAL(27,2)null,Jul DECIMAL(27,2) null,Aug DECIMAL(27,2)null,
	Sept DECIMAL(27,2)null,Oct DECIMAL(27,2)null,Nov DECIMAL(27,2),Decm DECIMAL(27,2),
	A1 INT null,A2 INT null,A3 INT null,A4 INT null,A5 INT null,A6 INT null,
	A7 INT null,A8 INT null,A9 INT null,A10 INT null,A11 INT,A12 INT,
	B1 INT null,B2 INT null,B3 INT null,B4 INT null,B5 INT null,B6 INT null,
	B7 INT null,B8 INT null,B9 INT null,B10 INT null,B11 INT,B12 INT)
	
	Create TABLE  #FrontEnd( NightCount BIGINT,StayPersons BIGINT, TOTAL DECIMAL(27),
	CityName  NVARCHAR(100),CityId BIGINT,Jan DECIMAL(27) null,Feb DECIMAL(27) null,
	Mar DECIMAL(27) null,Aprl DECIMAL(27) null,PropertyName NVARCHAR(100),PropertyId BIGINT,
	may DECIMAL(27) null,Jun DECIMAL(27)null,Jul DECIMAL(27) null,Aug DECIMAL(27)null,
	Sept DECIMAL(27)null,Oct DECIMAL(27)null,Nov DECIMAL(27),Decm DECIMAL(27),
	A1 INT null,A2 INT null,A3 INT null,A4 INT null,A5 INT null,A6 INT null,
	A7 INT null,A8 INT null,A9 INT null,A10 INT null,A11 INT,A12 INT,
	B1 INT null,B2 INT null,B3 INT null,B4 INT null,B5 INT null,B6 INT null,
	B7 INT null,B8 INT null,B9 INT null,B10 INT null,B11 INT,B12 INT)
	
	 Set @UserId =( Select Id FROM WrbhbTravelDesk WHERE IsDeleted=0 AND IsActive=1 AND Rowid=@userId)

IF @Action ='PageLoads'
 BEGIN 
 Create Table #TempClient(ClientName Nvarchar(300),ClientId Bigint,MasterClientId BIGINT,Id Bigint Primary Key Identity(1,1))
 Declare @Designation Nvarchar(100);--,@NoOfDays BIGINT,@userId Bigint,@ClientId Bigint, ;
 --Set @userId=34;
 Set @ClientId    = (Select ClientId FROM WrbhbTravelDesk WHERE IsDeleted=0 AND IsActive=1 AND Id=@userId) 
 Set @Designation = (Select Designation FROM WrbhbTravelDesk WHERE IsDeleted=0 AND IsActive=1 AND Id=@userId)
  -- sELECT @ClientId,@Designation
      If(@Designation='MasterClient')
		Begin  

			Insert into #TempClient(ClientId,ClientName,MasterClientId) 
			Select Id,ClientName,MasterClientId from WRBHBClientManagement
			where MasterClientId=@ClientId and IsActive=1 and IsDeleted=0
		END
		If(@Designation='Client')
		Begin  

			Insert into #TempClient(ClientId,ClientName,MasterClientId) 
			Select Id,ClientName,MasterClientId from WRBHBClientManagement
			where Id=@ClientId and IsActive=1 and IsDeleted=0
		END
		
		      SELECT ClientId Id,ClientName,MasterClientId from #TempClient;
		      SELECT PropertyName Property,Id FROM WRBHBProperty
			  WHERE IsActive=1 AND IsDeleted=0;
			  SELECT CityName CityName,Id  FROM WRBHBCity
			  WHERE IsActive=1 AND IsDeleted=0; 
			  Select @Designation as ClientTypes;
	END
	
 
IF @Action ='PageLoad'
		BEGIN 
		-- Set @UserId =( Select Id FROM WrbhbTravelDesk WHERE IsDeleted=0 AND IsActive=1 AND Rowid=@userId)

		 Set @ClientId    = (Select ClientId FROM WrbhbTravelDesk WHERE IsDeleted=0 AND IsActive=1 AND Id=@userId) 
		if(@FromDate='Current Month')
		BEGIN
		 	DECLARE @mydate date--, @ToDate  date 
            SELECT @mydate = GETDATE() 
         --   SET @ToDate   =CONVERT(date,DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))),DATEADD(mm,1,GETDATE())),101)
		--	SET @FromDate = CONVERT(date,DATEADD(dd,-(DAY(@mydate)-1),@mydate),101)
			SET @ToDate   =CONVERT(Nvarchar(300),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))),DATEADD(mm,1,GETDATE())),103)
			SET @FromDate = CONVERT(Nvarchar(300),DATEADD(dd,-(DAY(@mydate)-1),@mydate),103)
			Set @MonthWise=1;
		-- 	select @FromDate,@ToDate 
 
		END
		if(@FromDate='Last 3 Months')
		BEGIN
			--DECLARE @FromDate date, @ToDate  date 

			SET @ToDate  = Convert(Nvarchar(300),GETDATE(),103)
			SET @FromDate = Convert(Nvarchar(300),DATEADD(MONTH, -3, GETDATE()),103)
			 --select Convert(NVARCHAR,DATEADD(MONTH, -6, GETDATE()),103),Convert(NVARCHAR,GETDATE(),103)
			Set @MonthWise=3;
		--	select @FromDate,@ToDate 
 
		END
		if(@FromDate='Last 6 Months')
		BEGIN
			--DECLARE @FromDate date, @ToDate  date 

			SET @ToDate  = Convert(Nvarchar(300),GETDATE(),103)
			SET @FromDate = Convert(Nvarchar(300),DATEADD(MONTH, -6, GETDATE()),103)
			Set @MonthWise=6;
		--	select @FromDate,@ToDate 
 
		END
		--  select @FromDate,@ToDate ,@ClientId,@userId return;
		       ----External INTERNAL  
    --GET DATA FROM BOOKING ROOM LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode, ClientId,ClientName, G.BookingId,RoomId,G.RoomType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
     G.ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType, b.CityId,P.PropertyName,P.City,RoomCaptured
     FROM WRBHBBooking B     
     JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0  and g.RoomShiftingFlag=0  
     JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
     AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
     LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND BP.PropertyId=R.PropertyId AND R.RoomStatus='Active'   
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id -- AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND      Isnull(B.CancelStatus,'')!='Canceled'-- and b.BookingCode=4810  
      and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)-- and b.Id=10698
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,G.RoomType,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,g.GuestId,
     BP.PropertyType,B.CityId,P.PropertyName,P.City ,BookingCode,RoomCaptured 
       
       
     --GET DATA FROM BOOKING ROOM LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,G.RoomType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType,B.CityId,P.PropertyName,P.City,RoomCaptured
     FROM WRBHBBooking B     
     JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0 and g.RoomShiftingFlag=0  
     JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
     AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
     LEFT OUTER  JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id --AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0  AND   Isnull(B.CancelStatus,'')!='Canceled'   
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
     and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,G.RoomType, ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType,B.CityId,P.PropertyName,P.City ,BookingCode ,RoomCaptured ,g.GuestId
       
     --GET DATA FROM BOOKING BED LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,BedType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,B.CityId ,P.PropertyName,P.City ,0
     FROM WRBHBBooking B     
     JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0   
     JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     left Outer JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id --AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0  AND   Isnull(B.CancelStatus,'')!='Canceled'  
     and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,BedType,g.GuestId,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,B.CityId ,P.PropertyName,P.City,BookingCode 
       
        
     --GET DATA FROM BOOKING BED LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,BedType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,B.CityId  ,P.PropertyName,P.City ,0
     FROM WRBHBBooking B     
     JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId    AND G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     left outer JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id --AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND   Isnull(B.CancelStatus,'')!='Canceled'  
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
      and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,BedType,g.GuestId,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,B.CityId   ,P.PropertyName,BookingCode,P.City
       
     --GET DATA FROM BOOKING APARTMENT LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,ApartmentId,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,ApartmentId,B.CityId  ,P.PropertyName,P.City,0 
     FROM WRBHBBooking B     
     JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   AND  G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     LEFT OUTER JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
     AND A.IsActive=1 AND B.IsDeleted=0       
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id --AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND   Isnull(B.CancelStatus,'')!='Canceled'  
     and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)
     GROUP BY ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId,B.CityId,P.PropertyName,BookingCode,
     P.City,g.GuestId
      
      
      
     --GET DATA FROM BOOKING APARTMENT LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,ApartmentId,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,g.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,ApartmentId,B.CityId   ,P.PropertyName,P.City,0
     FROM WRBHBBooking B     
     JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   AND  G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     LEFT OUTER  JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
     AND A.IsActive=1 AND B.IsDeleted=0       
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id --AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 and Isnull(B.CancelStatus,'')!='Canceled'  
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
     and CONVERT(date,ChkInDt,103)>=CONVERT(date,'01/08/2014',103)
     GROUP BY ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId,B.CityId,P.PropertyName,P.City,
     BookingCode,g.GuestId
     
         delete #BookingSelect where PropertyType='MMT';
         
     --Getting MMT Data
      INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,ApartmentId,CityId,PropertyName,CityName,RoomCaptured)   
     
            Select Distinct BookingCode,ClientId,ClientName,C.Id,RoomId,RoomName,Ag.GuestId,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,
            CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',Occupancy,BookingLevel,Tariff,'MMT',ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
            s.HotalId,PropertyType,0,CityId,HotalName,CityName,RoomCaptured
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT'  and Ag.CurrentStatus!='Canceled'   and ag.RoomShiftingFlag=0 and BookingCode!=0
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
		   --Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
			Group by C.id,s.HotalName,S.HotalId,ag.GuestId,Ag.ChkOutDt,RoomName,Ag.FirstName,S.City,C.CityId,C.ClientName,C.ClientId,
			c.bookingCode,RoomId,SingleTariff,Ag.ChkInDt,Occupancy,BookingLevel,Tariff,ServicePaymentMode,
			TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,s.HotalId,PropertyType,CityId,HotalName,CityName,RoomCaptured
			order by C.id
       
        delete #BookingSelect where convert(date,CheckInDt,103) <Convert(date,'01/08/2014',103)
 --     Select * from #BookingSelect    
 --Declare  @BkingId BIGINT,@GstId Bigint,@NoDays bigint;
 --set @NoDays=(SELECT COUNT(*) FROM #BookingSelect 
	--			where  DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))<=0);
 --SELECT top 1  @BkingId=BookingId, @GstId=GuestName  --,@NoDays=1 
 --FROM #BookingSelect 
 --where   DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))<=0;
 ----Select @BkingId,@GstId,@NoDays;
 -- WHILE (@NoDays>0)   
 --    BEGIN 
 --        UPDATE #BookingSelect Set CheckInDt=(select top 1 CONVERT(nvarchar(100),(D.ChkInDt),103))		 
	--	from #BookingSelect H
	--	join WRBHBBookingPropertyAssingedGuest D on   d.GuestId=@GstId and d.BookingId=@BkingId
	--	where IsDeleted=0 and IsActive=1 and h.BookingLevel='Room'-- GuestId = 52402 and BookingId = 10698  
	--   set @NoDays=(SELECT COUNT(*) FROM #BookingSelect 
	--			 where  DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))<=0);
	--	 IF @NoDays>0 
	--		 BEGIN    
	--			SELECT TOP 1  @BkingId=BookingId, @GstId=GuestName   
	--			FROM #BookingSelect 
	--			where  DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))<=0
	--			--set @NoDays=(SELECT COUNT(*) FROM #BookingSelect 
	--			--where  DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))<=0);
	--		END
	--End	
       --sELECT * FROM #BookingSelect WHERE ClientId=@ClientId
        
    INSERT INTO #BookingSelectFinal(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,  
	BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,
	CityId,CityName,PropertyName,RoomCaptured) 
	 SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
	 DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))  AS DiffDate,ISNULL(ApartmentId,0),
	 Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName,RoomCaptured 
	 FROM #BookingSelect B
	 left outer   JOIN WRBHBCity C ON C.Id=B.CityId
	 WHERE  --CONVERT(DATE,CheckOutDt,103) <= CONVERT(DATE,GETDATE(),103)  
	 CONVERT(DATE,CheckInDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
	 
	 --tariff amount not equals to zero and all the avl
	INSERT INTO #BookingSelectFinal(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,  
	BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,
	CityId,CityName,PropertyName,RoomCaptured) 
	SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
	DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))  AS DiffDate,ISNULL(ApartmentId,0),
	Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName ,RoomCaptured
	FROM #BookingSelect B
	left outer   JOIN WRBHBCity C ON C.Id=B.CityId
	WHERE  --CONVERT(DATE,CheckOutDt,103) > CONVERT(DATE,GETDATE(),103) 
	CONVERT(DATE,CheckOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
	  
	
	INSERT INTO #BookingSelectFinal(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,  
	BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,
	CityId,CityName,PropertyName,RoomCaptured) 
	SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
	DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))  AS DiffDate,ISNULL(ApartmentId,0),
	Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName,RoomCaptured 
	FROM #BookingSelect B
	LEFT  JOIN WRBHBCity C ON C.Id=B.CityId
    WHERE  CONVERT(DATE,CheckOutDt,103) > CONVERT(DATE,@ToDate,103) and 
    CONVERT(DATE,CheckInDt,103) <= CONVERT(DATE,@FromDate,103)     
	 
	-- update  #BookingSelectFinal set DayDiff=1 
	-- where DayDiff<0 ;
	 
	INSERT INTO #FinalSelectTest(ClientId,ClientName,Counts,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,GuestId,RoomId,RoomTypes,Personcount,occupancy,Bookinglevel)

	select ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	Tariff TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,
	GuestName GuestId ,RoomId,RoomName RoomTypes,0,occupancy,Bookinglevel
	from #BookingSelectFinal -- where  BookingId=10698
	group by  ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,RoomId,GuestName,
	RoomName,RoomCaptured,occupancy,Bookinglevel; 
	   
	--update #FinalSelectTest set Personcount= 1 where occupancy='Single' and Bookinglevel='Room'
	--update #FinalSelectTest set Personcount= 2 where occupancy='Double' and Bookinglevel='Room'
	--update #FinalSelectTest set Personcount= 3 where occupancy='Triple' and Bookinglevel='Room'
	--update #FinalSelectTest set Personcount= 1 where occupancy='Single' and Bookinglevel='Bed'
	--update #FinalSelectTest set Personcount= 2 where occupancy='Double' and Bookinglevel='Bed'
	--update #FinalSelectTest set Personcount= 3 where occupancy='Triple' and Bookinglevel='Bed'
	--update #FinalSelectTest set Personcount= 1 where occupancy='Single' and Bookinglevel='Apartment'
	--update #FinalSelectTest set Personcount= 2 where occupancy='Double' and Bookinglevel='Apartment'
	--update #FinalSelectTest set Personcount= 3 where occupancy='Triple' and Bookinglevel='Apartment'
	 -- Select * from #FinalSelectTest where propertyid =3
	 -- return
 
     Delete #FinalSelectTest Where DayDiff<0;
 	 Declare  @ClientIds BIGINT ,@j int,@ClientName NVARCHAR(500),@Counts BIGINT,@NoOfDays Bigint; 
 	 Declare  @BookingId BIGINT,@CheckInDate  NVARCHAR(100),@CheckOutDate NVARCHAR(50);
 	 Declare  @DayDiff bigint,@Tariff Decimal(27,2),@Total decimal(27,2)
 	 Declare  @Property NVARCHAR(200),@City NVARCHAR(200),@TariffPaymentMode NVARCHAR(100);
 	 Declare  @CityIdS BIGINT,@PropertyIdS BIGINT, @PropertyType NVARCHAR(100) ;
	 Declare  @GuestId BIGINT,@RoomId BIGINT,@RoomTypes nvarchar(500),@IDS int;
     Declare  @CHeckOutTime NVARCHAR(200),@CHeckInTime NVARCHAR(200);
   --SELECT * FROM #FinalSelectTest   
     SELECT @Counts=COUNT(*) FROM #FinalSelectTest  
     
     SELECT @CHeckOutTime=' 11:59:00 AM',@CHeckInTime=' 12:00:00 PM' 
     SELECT TOP 1 @ClientIds=ClientId,@ClientName=ClientName, @BookingId=BookingId,@CheckInDate=CheckInDt,
     @CheckOutDate=CheckOutDt, @DayDiff=DayDiff,@Tariff=Tariff,@GuestId=guestId,
     @NoOfDays=  DATEDIFF(day, CONVERT(DATE,CheckInDt ,103), CONVERT(DATE,CheckOutDt,103)),
	 @Total=TOTAL,@Property=PropertyName,@City=CityName,@TariffPaymentMode=TariffPaymentMode,
	 @CityIdS=CityId,@PropertyIdS=PropertyId,@PropertyType=PropertyType, @J=0,@IDS=IDS,
	 @GuestId =0 ,@RoomId=RoomId,@RoomTypes=RoomTypes  FROM #FinalSelectTest 
   
     WHILE (@NoOfDays>0)   
     BEGIN         
		INSERT INTO #FinalSelect(ClientId,ClientName,Counts,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	 	TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,GuestId,RoomId,RoomTypes)
		SELECT  @ClientIds,@ClientName,1,@BookingId,
		CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate,103)),103),@CheckOutDate ,@DayDiff ,@Tariff,
		@Total,@Property,@City,@TariffPaymentMode,@CityIdS,@PropertyIdS,@PropertyType,@GuestId,@RoomId,@RoomTypes ;
			 SET @J=@J+1  
			 SET @NoOfDays=@NoOfDays-1  
		 IF @NoOfDays=0 
			 BEGIN    
			     DELETE FROM #FinalSelectTest  WHERE   IDS=@IDS ;
			      
				 SELECT TOP 1 @ClientIds=ClientId,@ClientName=ClientName, @BookingId=BookingId,@CheckInDate=CheckInDt,
				 @CheckOutDate=CheckOutDt, @DayDiff=DayDiff,@Tariff=Tariff,@GuestId=guestId,
			 	 @NoOfDays= DATEDIFF(day, CONVERT(DATE,CheckInDt ,103), CONVERT(DATE,CheckOutDt,103)),
				 @Total=TOTAL,@Property=PropertyName,@City=CityName,@TariffPaymentMode=TariffPaymentMode,
				 @CityIdS=CityId,@PropertyIdS=PropertyId,@PropertyType=PropertyType, @J=0,@IDS=IDS 
				 FROM #FinalSelectTest 
				  --set @Counts=(select COUNT(*) FROM #FinalSelectTest ) 
			 END  
     END  
      
	---Client wise AND MODE WISE	
		INSERT INTO #tempSDateFinal (ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,Counts,DayDiff ,Counts ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId,GuestId 
		FROM #FinalSelect
		WHERE CONVERT(DATE,CheckInDt,103)BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103) 
		and  ClientId=@ClientId  -- PropertyId=2636 
	 	group by ClientId,ClientName,Counts,DayDiff , TOTAL,PropertyName,CityName,
	    TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId ,GuestId 
		 
	 
	 -- select * from #tempSDateFinal  
 --Return;	 
	
If (isnull(@CityId,0)=0) and  (isnull(@PropertyId,0)=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)
	SELECT ClientId,ClientName,NightCount as NiteCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId
	FROM #tempSDateFinal  ;
End
If (isnull(@CityId,0)!=0) and  (isnull(@PropertyId,0)!=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)
	SELECT ClientId,ClientName,NightCount as NiteCount, StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId
	FROM #tempSDateFinal WHERE CityId=@CityId and PropertyId=@PropertyId ;
End
 If (isnull(@CityId,0)!=0) and  (isnull(@PropertyId,0)=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)
	SELECT ClientId,ClientName,NightCount as NiteCount, StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId
	FROM #tempSDateFinal WHERE   CityId=@CityId;-- and PropertyId=@PropertyId 
End
If (isnull(@CityId,0)=0) and  (isnull(@PropertyId,0)!=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)
	SELECT ClientId,ClientName,NightCount as NiteCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId
	FROM #tempSDateFinal WHERE  PropertyId=@PropertyId ;
End 

	  tRUNCATE TABLE  #tempSDateFinal;
	   
 	 
  --Select * From #tempDat
--Return;
	---Client wise AND MODE WISE
	if @PayMode='both'
	begin
		INSERT INTO #tempSDateFinal(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId,GuestId FROM #tempDat
		WHERE  ClientId=@ClientId 
	 end
	 ELSE
	 BEGIN
		INSERT INTO #tempSDateFinal(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId,GuestId FROM #tempDat
		WHERE  	ClientId=@ClientId	AND TariffPaymentMode=@PayMode 
	 END 
	 
	    --Select * from #tempSDateFinal
	 -- Return;
	 
	 Truncate table #tempDat;
	  
---caluculations done and sent to front end by this select  process 
 
If(@PrptyType='All')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId,GuestId 
		FROM #tempSDateFinal
  
END

If(@PrptyType='Entity Preferred')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId,GuestId 
		FROM #tempSDateFinal 
	     WHERE UPPER(PropertyType)=UPPER('CPP')
END
If(@PrptyType='Other Property')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId ,GuestId
		FROM #tempSDateFinal 
	     WHERE UPPER(PropertyType)NOT IN (UPPER('CPP'),UPPER('MGH'),UPPER('DdP'),UPPER('MMT')) 
END 
If(@PrptyType='Guest Houses')
BEGIN
   		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId,GuestId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId ,GuestId
		FROM #tempSDateFinal
	WHERE UPPER(PropertyType) IN (UPPER('MGH'),UPPER('DdP')) 
 
END 
 	--  Select * from #tempSDateFinal   
	  
	  
   --sELECT * FROM #tempDat   --TariffPaymentMode=@PayMode;
  -- rETURN;
declare @StartDate datetime
declare @EndDate datetime
select @StartDate = convert(date,@FromDate,103) ,  @EndDate = convert(date,@ToDate,103)  
--select @StartDate = convert(date,'01/03/2015',103) ,  @EndDate = convert(date,'31/03/2015',103)  
select @StartDate= @StartDate-(DATEPART(DD,@StartDate)-1)
Declare @Month int
declare @temp  table
(
TheDate date,
Months int identity(1,1) 
)
while (@StartDate<@EndDate)
begin
insert into @temp values (@StartDate)
select @StartDate=DATEADD(MM,1,@StartDate)
 --@Month=(Select SUBSTRING(CONVERT(VARCHAR(100),@EndDate,103),4,2)  )
end
Declare @monthcount bigint
set @monthcount=(select COUNT(*) from @temp)
     delete  @temp  where Months=4 and @monthcount<5
     delete  @temp where Months=7 and @monthcount>5  
    -- select * from @temp;
	INSERT INTO #tempDats(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,MonthId,MonthDates,BookingId,GuestId)

	SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
     TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,t2.Months,t2.TheDate,BookingId,GuestId 
     FROM #tempDat t1
     join @temp t2   on MONTH(CONVERT(DATE,t1.CheckInDt,103)) = MONTH(CONVERT(DATE,t2.TheDate,103))
     
     --GROUP BY ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
 --    TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,t2.Months,t2.TheDate
     
  -- select * from #tempDats
--    exec HBMenu_PropertyWiseService_Report @Action=N'Pageload',@FromDate=N'Last 6 Months',--Current Month',
--@PayMode=N'Both',@ToDate=N'',@CityId=0,@PropertyId=0,@ClientId=2095,@ChkMode=4,
--@PrptyType=N'All',@MonthWise=0,@userId=N'920e1854-2b7b-4c42-b717-a6e0572c17c0'
 --RETURN;
   
	truncate table #MonthWise
--JAN
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
    TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
    Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
    A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	TOTAL,0,0,0,0,0,0,0,0,0,0,0,
	NightCount,0,0,0,0,0,0,0,0,0,0,0,
	DayDiff,0,0,0,0,0,0,0,0,0,0,0 from #tempDats where MonthId=1;
	 
 --Feb
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,TOTAL,0,0,0,0,0,0,0,0,0,0,
	0,NightCount,0,0,0,0,0,0,0,0,0,0,
	0,DayDiff,0,0,0,0,0,0,0,0,0,0	 from #tempDats where MonthId=2;
	
 
 --March
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,TOTAL,0,0,0,0,0,0,0,0,0,
	0,0,NightCount,0,0,0,0,0,0,0,0,0,
	0,0,DayDiff,0,0,0,0,0,0,0,0,0 from #tempDats where MonthId=3; 
 --April
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,TOTAL,0,0,0,0,0,0,0,0,
	0,0,0,NightCount,0,0,0,0,0,0,0,0,
	0,0,0,DayDiff,0,0,0,0,0,0,0,0 from #tempDats where MonthId=4; 
 --MAy 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,TOTAL,0,0,0,0,0,0,0,
	0,0,0,0,NightCount,0,0,0,0,0,0,0,
	0,0,0,0,DayDiff,0,0,0,0,0,0,0from #tempDats where MonthId=5;  
--JUne 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,TOTAL,0,0,0,0,0,0,
	0,0,0,0,0,NightCount,0,0,0,0,0,0,
	0,0,0,0,0,DayDiff,0,0,0,0,0,0   from #tempDats where MonthId=6 
	--JULY
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,TOTAL,0,0,0,0,0,
	0,0,0,0,0,0,NightCount,0,0,0,0,0,
	0,0,0,0,0,0,DayDiff,0,0,0,0,0   from #tempDats where MonthId=7; 
	
--AUG
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,TOTAL,0,0,0,0,
	0,0,0,0,0,0,0,NightCount,0,0,0,0,
	0,0,0,0,0,0,0,DayDiff,0,0,0,0 from #tempDats where MonthId= 8; 
 --SEPT
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,TOTAL,0,0,0,
	0,0,0,0,0,0,0,0,NightCount,0,0,0,
	0,0,0,0,0,0,0,0,DayDiff,0,0,0 from #tempDats where MonthId= 9; 
 --OCT
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,TOTAL,0,0 ,
	0,0,0,0,0,0,0,0,0,NightCount,0,0,
	0,0,0,0,0,0,0,0,0,DayDiff,0,0 from #tempDats where MonthId=10; 
 --NOV 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,0,TOTAL,0,
	0,0,0,0,0,0,0,0,0,0,NightCount,0,
	0,0,0,0,0,0,0,0,0,0,DayDiff,0 from #tempDats where MonthId=11; 
--DECM 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,0,0,TOTAL,
	0,0,0,0,0,0,0,0,0,0,0,NightCount,
	0,0,0,0,0,0,0,0,0,0,0,DayDiff from #tempDats where MonthId=12 ;
  
   -- Select SUM(TOTAL) from #MonthWise where PropertyId=1 
   ---- and MONTH(CONVERT(DATE,CheckOutDt,103))=8   and MONTH(CONVERT(DATE,CheckInDt,103))=8  
    -- Select * from #MonthWise where PropertyId=2636 
    --and MONTH(CONVERT(DATE,CheckOutDt,103))=3   and MONTH(CONVERT(DATE,CheckInDt,103))=3  
   -- Return;
--Select CityName,NightCount,StayPersons,CheckInDt,
--CityId,PropertyId,TOTAL,PropertyName from #MonthWise  
--group by CityName,NightCount,StayPersons,CheckInDt,CityId,TOTAL,PropertyName,PropertyId
if('1'=@ChkMode)  --citydatewise report 
BEGIN     

     SELECT  CityName,sum(NightCount)StayPersons ,sUM(DayDiff)NightCount ,--sum(DayDiff),  
     sum(TOTAL) TOTAL--,sum(Jan) Jan,sum(Feb) Feb,sum(Mar)Mar,sum(Aprl)Aprl,sum(may)may,sum(Jun)Jun,  
     --sum(Jul)Jul,sum(Aug)Aug,sum(Sept)Sept,sum(Oct)Oct,sum(Nov)Nov,sum(Decm)Decm   
     FROM #MonthWise --WHERE   TOTAL!=0
     GROUP BY   CheckInDt,CityName,CityId  order by CityName  
      select 'Report is From '+@FromDate+' To '+@ToDate   as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
	DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
	DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
	DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
	DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
	DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
	DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
	DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
	DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
	DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
end   
if('2'=@ChkMode)  --citywise report
BEGIN    
    
 INSERT INTO #FrontEnd(NightCount,StayPersons,CityName,CityId,TOTAL,PropertyId ,PropertyName,  
 Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,  
 A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)  
    
 SELECT  sum(NightCount)NightCount, sUM(DayDiff) StayPersons,--sum(DayDiff),  
 CityName,CityId ,sum(TOTAL) TOTAL,0 ,'',--MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
 sum(Jan) '1',sum(Feb) '2',sum(Mar)'3',sum(Aprl)'4',sum(may)'5',sum(Jun)'6'  ,  
 sum(Jul)'7',sum(Aug)'8',sum(Sept)'9',sum(Oct)'10',sum(Nov)'11',sum(Decm)'12',  
 SUM(A1)'21',sum(A2)'22',sum(A3)'23',sum(A4)'24',sum(A5)'25',sum(A6)'26',  
 sum(A7)'27',sum(A8)'28',sum(A9)'29',sum(A10)'30',sum(A11)'31',sum(A12)'32',  
 sum(B1)'41',sum(B2)'42',sum(B3)'43',sum(B4)'44',sum(B5)'45',sum(B6)'46',  
 sum(B7)'47',sum(B8)'48',sum(B9)'49',sum(B10)'50',sum(B11)'51',sum(B12)'52'  
 FROM #MonthWise-- WHERE   TOTAL!=0   
 GROUP BY   CityName,CityId    
 order by CityName   
  if(@MonthWise=1)  
	 BEGIN   
		  SELECT   CityName,PropertyName,A1,B1,Jan 'one',--,A2,B2,Feb 'two',A3,B3,Mar'three', --Aprl'4',may'5',Jun'6' ,  
		  --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
		  NightCount StayPersons, StayPersons NightCount, TOTAL  
		  FROM #FrontEnd --WHERE   TOTAL!=0
		   order by CityName --GROUP BY  PropertyName,PropertyId ,CityName,CityId
		     select 'Report is From '+@FromDate+' To '+@ToDate      as Reportdate ,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
			DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
			DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
			DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
			DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
			DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
			DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
			DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
			DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
			DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
 
	  END   
	 If(@MonthWise=3)  
	 Begin  
		   Select CityName,--sum(DayDiff),MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
		   A1,B1,isnull(Jan,0) 'one',A2,B2,isnull(Feb,0) 'two',A3,B3,isnull(Mar,0)'three',--Aprl'4',may'5',Jun'6' ,  
		   -- Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A4,A5,A6,A7,A8,A9,A10,A11,A12,B4,B5,B6,B7,B8,B9,B10,B11,B12  
		   NightCount StayPersons,StayPersons NightCount,TOTAL  
		   from #FrontEnd 
		   --WHERE   TOTAL!=0 
		    order by CityName    
		       select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
		       DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
				DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
				DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
				DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
				DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
				DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
				DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
				DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
				DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
	  End  
    If(@MonthWise=6)  
	 Begin  
			Select CityName,A1,B1,isnull(Jan,0)'one',A2,B2,isnull(Feb,0)'two',A3,B3,isnull(Mar,0)'three',A4,B4,isnull(Aprl,0)'four',
			A5,B5,isnull(may,0)'five',A6,B6,isnull(Jun,0)'six' , 
			--Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A7,A8,A9,A10,A11,A12,  
			--B7,B8,B9,B10,B11,B12 ,sum(DayDiff),  CityName,MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt, 
			NightCount StayPersons,StayPersons NightCount,TOTAL  
			from #FrontEnd  
			-- WHERE   TOTAL!=0
			 	order by CityName    
			  select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
			  DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
			DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
			DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
			DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
			DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
			DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
			DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
			DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
			DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
		End      
  END  
  
if('3'=@ChkMode)  --prptydatewise Report
	BEGIN  
		SELECT  CityName,PropertyName,sum(NightCount) StayPersons,SUM(DayDiff)NightCount ,--sum(DayDiff),  
		sum(TOTAL) TOTAL -- sum(Jan) '1',sum(Feb) '2',sum(Mar)'3',sum(Aprl)'4',sum(may)'5',sum(Jun)'6'  ,  
		-- sum(Jul)'7',sum(Aug)'8',sum(Sept)'9',sum(Oct)'10',sum(Nov)'11',sum(Decm)'12'   
		FROM #MonthWise  -- WHERE   TOTAL!=0
		GROUP BY  PropertyName,PropertyId ,CityName,CityId  order by CityName  
		   select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
		   DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
	END
  if('4'=@ChkMode)  --propertywise report
BEGIN  

 INSERT INTO #FrontEnd(NightCount,StayPersons,CityName,CityId,TOTAL,PropertyId ,PropertyName,  
 Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,  
 A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)  
    
 SELECT  sum(NightCount)NightCount, sUM(DayDiff)StayPersons,--sum(DayDiff),  
 CityName,CityId ,sum(TOTAL) TOTAL,PropertyId ,PropertyName,--MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
 sum(Jan) '1',sum(Feb) '2',sum(Mar)'3',sum(Aprl)'4',sum(may)'5',sum(Jun)'6'  ,  
 sum(Jul)'7',sum(Aug)'8',sum(Sept)'9',sum(Oct)'10',sum(Nov)'11',sum(Decm)'12',  
 SUM(A1)'21',sum(A2)'22',sum(A3)'23',sum(A4)'24',sum(A5)'25',sum(A6)'26',  
 sum(A7)'27',sum(A8)'28',sum(A9)'29',sum(A10)'30',sum(A11)'31',sum(A12)'32',  
 sum(B1)'41',sum(B2)'42',sum(B3)'43',sum(B4)'44',sum(B5)'45',sum(B6)'46',  
 sum(B7)'47',sum(B8)'48',sum(B9)'49',sum(B10)'50',sum(B11)'51',sum(B12)'52'  
 FROM #MonthWise    
 GROUP BY   CityName,CityId ,PropertyId ,PropertyName  
 order by CityName  
 if(@MonthWise=1)  
	 BEGIN   
		  SELECT   CityName,PropertyName,A1,B1,Jan 'one',--,A2,B2,Feb 'two',A3,B3,Mar'three', --Aprl'4',may'5',Jun'6' ,  
		  --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
		  NightCount StayPersons, StayPersons NightCount, TOTAL  
		  FROM #FrontEnd-- WHERE   TOTAL!=0 
		  order by CityName --GROUP BY  PropertyName,PropertyId ,CityName,CityId  
		   select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
		   DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
	  END   
	 if(@MonthWise=3)  
	 BEGIN   
		  SELECT   CityName,PropertyName,A1,B1,Jan 'one',A2,B2,Feb 'two',A3,B3,Mar'three', --Aprl'4',may'5',Jun'6' ,  
		  --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
		  NightCount StayPersons, StayPersons NightCount, TOTAL  
		  FROM #FrontEnd-- WHERE   TOTAL!=0 
		  order by CityName --GROUP BY  PropertyName,PropertyId ,CityName,CityId  
		   select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
		   DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
	  END  
 if(@MonthWise=6)  
     BEGIN   
		SELECT   CityName,PropertyName,A1,B1,Jan 'one',A2,B2,Feb 'two',A3,B3,Mar 'three', A4,B4,Aprl 'four', A5,B5,may 'five', A6,B6,Jun 'six'  
		--Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
		,NightCount StayPersons, StayPersons NightCount,TOTAL  
		FROM #FrontEnd  --WHERE   TOTAL!=0
		 order by CityName--GROUP BY  PropertyName,PropertyId ,CityName,CityId  
		   select 'Report is From '+@FromDate+' To '+@ToDate    as Reportdate,DATENAME(MONTH, GETDATE()) + ' ' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS Months,
		   DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()))+' '+ CAST(YEAR(DATEADD(MONTH,-2,GETDATE()))AS VARCHAR(4))  Months1,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months2,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months3 ,
DATENAME(MONTH,DATEADD(MONTH,-5,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-5, GETDATE()))AS VARCHAR(4))  Months11,
DATENAME(MONTH,DATEADD(MONTH,-4,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-4, GETDATE()))AS VARCHAR(4))  Months21,
DATENAME(MONTH,DATEADD(MONTH,-3,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-3, GETDATE()))AS VARCHAR(4))  Months31 , 
DATENAME(MONTH,DATEADD(MONTH,-2,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-2, GETDATE()))AS VARCHAR(4))  Months41,
DATENAME(MONTH,DATEADD(MONTH,-1,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH,-1, GETDATE()))AS VARCHAR(4))  Months51,
DATENAME(MONTH,DATEADD(MONTH, 0,GETDATE()) )+ ' ' + CAST(YEAR(DATEADD(MONTH, 0, GETDATE()))AS VARCHAR(4))  Months61   
   
      END  
  END --Chkmode 4 close

  
 END--Action close Pageload
 END 
 
 
 -- exec Sp_Booking_Report @Action ='PageLoad', @PayMode ='Bill to Client', @CityId = 0,@PropertyId = '',
 --@FromDate ='01/05/2014',@ToDate ='11/12/2014',@ChkMode='3', @ClientId =2007,@PrptyType='all'
  --Select * from wrbhbtravelDesk
  -- exec HBMenu_PropertyWiseService_Report @Action=N'PageLoads',@FromDate=N'',@PayMode=N'',@ToDate=N'',@CityId=0,@PropertyId=0,@ClientId=0,@ChkMode=0,@PrptyType=N'',@MonthWise=0,@userId=1
  