SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_Booking_Report') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_Booking_Report
GO 

CREATE PROCEDURE Sp_Booking_Report
(
	@Action NVARCHAR(100)=NULL,
	@PayMode NVARCHAR(100)=NULL, 
	@CityId Bigint,
	@PropertyId Bigint,
	@FromDate NVARCHAR(100)=NULL,
	@ToDate NVARCHAR(100)=NULL,
	@ClientId int,  --THIS IS CLIENT iD
	@ChkMode int,  --this is mothwise or datewise from front end {example:@ChkMode(month=1,Date=0)}
	@PrptyType Nvarchar(100),
	@MonthWise Bigint
	
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
	IDS int NOT NULL PRIMARY KEY identity (1,1));



	Create TABLE  #tempSDateFinal(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT)
	Create TABLE  #tempDatnew(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT)
	
	
	Create TABLE  #tempDat(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,PropertyType nvarchar(100),BookingId BIGINT)
	
	Create TABLE  #tempDats(ClientId BIGINT,ClientName Nvarchar(300),NightCount BIGINT,StayPersons BIGINT,DayDiff BIGINT ,TOTAL DECIMAL(27,2),
	PropertyName NVARCHAR(100),CityName  NVARCHAR(100),	TariffPaymentMode NVARCHAR(100),CheckInDt  NVARCHAR(100),
	CheckOutDt  NVARCHAR(100) ,CityId BIGINT,PropertyId BIGINT,MonthId int ,MonthDates NVARCHAR(100))
	
	 
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
	
	
	
IF @Action ='PageLoads'
		Begin 
  SELECT GuestId,EmpCode,FirstName,LastName,Id AS BookingGuestTableId,
  0 AS Tick,1 AS Chk,FirstName+'  '+LastName AS Name 
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 
end
 
	IF @Action ='PageLoad'
		Begin 
		       ----External INTERNAL  
    --GET DATA FROM BOOKING ROOM LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode, ClientId,ClientName, G.BookingId,RoomId,G.RoomType,''FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
     G.ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType, b.CityId,P.PropertyName,P.City,RoomCaptured
     FROM WRBHBBooking B     
     JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
     AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
   LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND BP.PropertyId=R.PropertyId AND R.RoomStatus='Active'  
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND      Isnull(B.CancelStatus,'')!='Canceled'  
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,G.RoomType,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType,B.CityId,P.PropertyName,P.City ,BookingCode,RoomCaptured 
       
       
     --GET DATA FROM BOOKING ROOM LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,G.RoomType,''FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType,B.CityId,P.PropertyName,P.City,RoomCaptured
     FROM WRBHBBooking B     
     JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
     AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
     LEFT OUTER  JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0  AND   Isnull(B.CancelStatus,'')!='Canceled'   
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,G.RoomType, ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,
     BP.PropertyType,B.CityId,P.PropertyName,P.City ,BookingCode ,RoomCaptured 
       
     --GET DATA FROM BOOKING BED LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,B.CityId ,P.PropertyName,P.City ,0
     FROM WRBHBBooking B     
     JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId  AND G.IsActive=1 AND G.IsDeleted=0   
     JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0  AND   Isnull(B.CancelStatus,'')!='Canceled'  
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,B.CityId ,P.PropertyName,P.City,BookingCode 
       
        
     --GET DATA FROM BOOKING BED LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,RoomId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,B.CityId  ,P.PropertyName,P.City ,0
     FROM WRBHBBooking B     
     JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId    AND G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))     
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
     AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND   Isnull(B.CancelStatus,'')!='Canceled'  
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
     GROUP BY ClientId,ClientName,G.BookingId,RoomId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,B.CityId   ,P.PropertyName,BookingCode,P.City
       
     --GET DATA FROM BOOKING APARTMENT LEVEL CHECKIN DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,ApartmentId,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,''FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,ApartmentId,B.CityId  ,P.PropertyName,P.City,0 
     FROM WRBHBBooking B     
     JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   AND  G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
      LEFT OUTER JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
     AND A.IsActive=1 AND B.IsDeleted=0       
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 AND   Isnull(B.CancelStatus,'')!='Canceled'  
     GROUP BY ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId,B.CityId   ,P.PropertyName,BookingCode,P.City
      
      
      
     --GET DATA FROM BOOKING APARTMENT LEVEL CHECKOUT DATE WISE  
     INSERT INTO #BookingSelect(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
     BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
     PropertyId,PropertyType,ApartmentId,CityId,PropertyName,CityName,RoomCaptured)   
     SELECT BookingCode,ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,''FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
     CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,0,0,0,P.Id,BP.PropertyType,ApartmentId,B.CityId   ,P.PropertyName,P.City,0
     FROM WRBHBBooking B     
     JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   AND  G.IsActive=1 AND G.IsDeleted=0  
     JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
     --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
     LEFT OUTER  JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
     AND A.IsActive=1 AND B.IsDeleted=0       
     JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
     WHERE B.IsActive=1 AND B.IsDeleted=0 and Isnull(B.CancelStatus,'')!='Canceled'  
     AND B.Id NOT IN(SELECT BookingId FROM #BookingSelect)  
     GROUP BY ClientId,ClientName,G.BookingId,G.ApartmentId,G.ApartmentType,ChkInDt,ChkOutDt,G.Tariff,Category,  
     ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId,B.CityId ,P.PropertyName,P.City,BookingCode
       
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
	 -- group by BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
	 -- CheckInDt, CheckOutDt, ApartmentId,
 	--Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName ,RoomCaptured
	--and TariffPaymentMode=@PayMode;
	
	
	 
	 --and BookingId   NOT IN(SELECT BookingId FROM #BookingSelectFinal)  
	--and TariffPaymentMode=@PayMode;
	
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
	 
	-- group by BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
--	 CheckInDt, CheckOutDt, ApartmentId,
--	Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName 
	 --and BookingId   NOT IN(SELECT BookingId FROM #BookingSelectFinal)  
	--and TariffPaymentMode=@PayMode;
	

	--INSERT INTO #BookingTestFinal
	--(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,
	--CheckInDt,CheckOutDt,Occupancy, BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,
	--TariffPaymentMode,PropertyId,PropertyType,CityId,CityName,PropertyName)
	
	--SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,
	--CheckInDt,CheckOutDt,Occupancy, BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,
	--TariffPaymentMode,PropertyId,PropertyType,CityId,CityName,PropertyName
	--FROM #BookingSelectFinal B  

 
--order  by BookingId
-- Return;

	INSERT INTO #FinalSelectTest(ClientId,ClientName,Counts,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,GuestId,RoomId,RoomTypes)

	select ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	Tariff TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,0 GuestId ,RoomId,RoomName RoomTypes
	from #BookingSelectFinal 
	  group by  ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	     PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,RoomId,RoomName,RoomCaptured;
	
	--Select * from #BookingSelect where  ClientId=1528 and PropertyName='Blueridge Honey Homes Travel and Stay'
	--Select * from #FinalSelectTest where  ClientId=1528 and PropertyName='Blueridge Honey Homes Travel and Stay'
	--group by ClientId,ClientName,Counts,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	--TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,GuestId,RoomId,RoomTypes,Ids
	--order  by BookingId
      Select * from #FinalSelectTest where ClientId=2007
      order by BookingId
      Return;
 	 Declare  @ClientIds BIGINT ,@j int,@ClientName NVARCHAR(500),@Counts BIGINT,@NoOfDays Bigint; 
 	 Declare  @BookingId BIGINT,@CheckInDate  NVARCHAR(100),@CheckOutDate NVARCHAR(50);
 	 Declare  @DayDiff bigint,@Tariff Decimal(27,2),@Total decimal(27,2)
 	 Declare  @Property NVARCHAR(200),@City NVARCHAR(200),@TariffPaymentMode NVARCHAR(100);
 	 Declare  @CityIdS BIGINT,@PropertyIdS BIGINT, @PropertyType NVARCHAR(100) ;
	 Declare  @GuestId BIGINT,@RoomId BIGINT,@RoomTypes nvarchar(500),@IDS int;
     Declare @CHeckOutTime NVARCHAR(200),@CHeckInTime NVARCHAR(200);
   --SELECT * FROM #FinalSelectTest   
     SELECT @Counts=COUNT(*) FROM #FinalSelectTest  
     
     SELECT @CHeckOutTime=' 11:59:00 AM',@CHeckInTime=' 12:00:00 PM' 
     SELECT TOP 1 @ClientIds=ClientId,@ClientName=ClientName, @BookingId=BookingId,@CheckInDate=CheckInDt,
     @CheckOutDate=CheckOutDt, @DayDiff=DayDiff,@Tariff=Tariff,
    -- @NoOfDays=DATEDIFF(day,CAST(CheckInDt+@CHeckInTime AS DATETIME),CAST(CheckOutDt+@CHeckOutTime AS DATETIME)),
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
			-- Select @NoOfDays;
		 IF @NoOfDays=0 
			 BEGIN    
			     DELETE FROM #FinalSelectTest  WHERE   IDS=@IDS ;
			     
				-- Select @RoomTypes,@BookingId,@RoomId;
				 SELECT TOP 1 @ClientIds=ClientId,@ClientName=ClientName, @BookingId=BookingId,@CheckInDate=CheckInDt,
				 @CheckOutDate=CheckOutDt, @DayDiff=DayDiff,@Tariff=Tariff,
				-- @NoOfDays=DATEDIFF(day,CAST(CheckInDt+@CHeckInTime AS DATETIME),CAST(CheckOutDt+@CHeckOutTime AS DATETIME)),
				 @NoOfDays= DATEDIFF(day, CONVERT(DATE,CheckInDt ,103), CONVERT(DATE,CheckOutDt,103)),
				 @Total=TOTAL,@Property=PropertyName,@City=CityName,@TariffPaymentMode=TariffPaymentMode,
				 @CityIdS=CityId,@PropertyIdS=PropertyId,@PropertyType=PropertyType, @J=0,@IDS=IDS 
				  FROM #FinalSelectTest 
				 
			 END  
     END  
    

	---Client wise AND MODE WISE	
		INSERT INTO #tempSDateFinal (ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,Counts,DayDiff ,Counts ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		FROM #FinalSelect
		WHERE  CONVERT(DATE,CheckInDt,103)
		 BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103) and-- PropertyId=1
		ClientId=@ClientId 
	--	group by ClientId,ClientName,Counts,DayDiff , TOTAL,PropertyName,CityName,
	---	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		
-- sELECT * FROM #tempSDateFinal where TariffPaymentMode='Direct' and PropertyId=7
--sELECT SUM(TOTAL) FROM #tempSDateFinal  WHERE TOTAL!=0
--ORDER BY BookingId

 --rETURN;
	
If (isnull(@CityId,0)=0) and  (isnull(@PropertyId,0)=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)
	SELECT ClientId,ClientName,NightCount as NiteCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId
	FROM #tempSDateFinal  ;
End
If (isnull(@CityId,0)!=0) and  (isnull(@PropertyId,0)!=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)
	SELECT ClientId,ClientName,NightCount as NiteCount, StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId
	FROM #tempSDateFinal WHERE CityId=@CityId and PropertyId=@PropertyId ;
End
 If (isnull(@CityId,0)!=0) and  (isnull(@PropertyId,0)=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)
	SELECT ClientId,ClientName,NightCount as NiteCount, StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId
	FROM #tempSDateFinal WHERE   CityId=@CityId;-- and PropertyId=@PropertyId 
End
If (isnull(@CityId,0)=0) and  (isnull(@PropertyId,0)!=0)
Begin
    INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)
	SELECT ClientId,ClientName,NightCount as NiteCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId
	FROM #tempSDateFinal WHERE  PropertyId=@PropertyId ;
End 

	  tRUNCATE TABLE  #tempSDateFinal;
	   
 	 
 --Select * From #tempDat
--Return;
	---Client wise AND MODE WISE
	if @PayMode='both'
	begin
		INSERT INTO #tempSDateFinal(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId FROM #tempDat
		WHERE  ClientId=@ClientId 
	 end
	 ELSE
	 BEGIN
		INSERT INTO #tempSDateFinal(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId FROM #tempDat
		WHERE  	ClientId=@ClientId	AND TariffPaymentMode=@PayMode 
	 END 
	 
	  --Select * from #tempDat
	 --Return;
	 
	 Truncate table #tempDat;
	  
---caluculations done and sent to front end by this select  process
If(@PrptyType='ALL')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		FROM #tempSDateFinal
  
END

If(@PrptyType='CPP')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		FROM #tempSDateFinal 
	     WHERE UPPER(PropertyType)=UPPER('CPP')
END
If(@PrptyType='OTHER')
BEGIN
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		FROM #tempSDateFinal 
	     WHERE UPPER(PropertyType)NOT IN (UPPER('CPP'),UPPER('MGH'),UPPER('DdP')) 
END 
If(@PrptyType='GH')
BEGIN
   		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,BookingId 
		FROM #tempSDateFinal
	WHERE UPPER(PropertyType) IN (UPPER('MGH'),UPPER('DdP')) 
 
END 
 	-- Select * from #tempSDateFinal  where TOTAL!=0
	 --Return;
	  
 --sELECT * FROM #tempDat where TariffPaymentMode=@PayMode;
  --rETURN;
declare @StartDate datetime
declare @EndDate datetime
select @StartDate = convert(date,@FromDate,103) ,  @EndDate = convert(date,@ToDate,103)  

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
--select * from @temp
	INSERT INTO #tempDats(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,MonthId,MonthDates)

	SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
     TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,t2.Months,t2.TheDate FROM #tempDat t1
     join @temp t2   on MONTH(CONVERT(DATE,t1.CheckInDt,103)) = MONTH(CONVERT(DATE,t2.TheDate,103))
     --GROUP BY ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
 --    TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,t2.Months,t2.TheDate
     
  --  Select * from #tempDats  where TariffPaymentMode='Direct' and PropertyId=7 
 -- sELECT SUM(TOTAL),CityName FROM #tempDats 
 --  GROUP BY CityName
 --    Return;  
	 
--	INSERT INTO #MonthWises(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
--    TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertryId,MonthDates,
--    Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
--    A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12) 

--SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
--     TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,MonthDates,MonthId,
--     0,0,0,0,0,0,0,0,0,0,0,
--     0,0,0,0,0,0,0,0,0,0,0,0,
--     0,0,0,0,0,0,0,0,0,0,0,0 FROM #tempDats
     
   --SELECT * FROM(SELECT ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
   --  TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,MonthDates,MonthId FROM #tempDats) AS original
   -- PIVOT  
   -- (
   --     MIN(MonthId) FOR MonthId IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],
   --     [13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],
   --     [25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36] )
   -- ) AS PivotTable
       
  --   ORDER BY PropertyId
    
   
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
	StayPersons,0,0,0,0,0,0,0,0,0,0,0 from #tempDats where MonthId=1;
	 
 --Feb
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,TOTAL,0,0,0,0,0,0,0,0,0,0,
	0,NightCount,0,0,0,0,0,0,0,0,0,0,
	0,StayPersons,0,0,0,0,0,0,0,0,0,0	 from #tempDats where MonthId=2;
	
 
 --March
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,TOTAL,0,0,0,0,0,0,0,0,0,
	0,0,NightCount,0,0,0,0,0,0,0,0,0,
	0,0,StayPersons,0,0,0,0,0,0,0,0,0 from #tempDats where MonthId=3; 
 --April
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,TOTAL,0,0,0,0,0,0,0,0,
	0,0,0,NightCount,0,0,0,0,0,0,0,0,
	0,0,0,StayPersons,0,0,0,0,0,0,0,0 from #tempDats where MonthId=4; 
 --MAy 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,TOTAL,0,0,0,0,0,0,0,
	0,0,0,0,StayPersons,0,0,0,0,0,0,0,
	0,0,0,0,StayPersons,0,0,0,0,0,0,0from #tempDats where MonthId=5;  
--JUne 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,TOTAL,0,0,0,0,0,0,
	0,0,0,0,0,NightCount,0,0,0,0,0,0,
	0,0,0,0,0,StayPersons,0,0,0,0,0,0   from #tempDats where MonthId=6 
	--JULY
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,TOTAL,0,0,0,0,0,
	0,0,0,0,0,0,NightCount,0,0,0,0,0,
	0,0,0,0,0,0,StayPersons,0,0,0,0,0   from #tempDats where MonthId=7; 
	
--AUG
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,TOTAL,0,0,0,0,
	0,0,0,0,0,0,0,NightCount,0,0,0,0,
	0,0,0,0,0,0,0,StayPersons,0,0,0,0 from #tempDats where MonthId= 8; 
 --SEPT
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,TOTAL,0,0,0,
	0,0,0,0,0,0,0,0,NightCount,0,0,0,
	0,0,0,0,0,0,0,0,StayPersons,0,0,0 from #tempDats where MonthId= 9; 
 --OCT
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,TOTAL,0,0 ,
	0,0,0,0,0,0,0,0,0,NightCount,0,0,
	0,0,0,0,0,0,0,0,0,StayPersons,0,0 from #tempDats where MonthId=10; 
 --NOV 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,0,TOTAL,0,
	0,0,0,0,0,0,0,0,0,0,NightCount,0,
	0,0,0,0,0,0,0,0,0,0,StayPersons,0 from #tempDats where MonthId=11; 
--DECM 
	INSERT INTO #MonthWise(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,
	A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)
	Select ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
	TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,
	0,0,0,0,0,0,0,0,0,0,0,TOTAL,
	0,0,0,0,0,0,0,0,0,0,0,NightCount,
	0,0,0,0,0,0,0,0,0,0,0,StayPersons from #tempDats where MonthId=12 ;
  
   -- Select SUM(TOTAL) from #MonthWise where PropertyId=1 
   ---- and MONTH(CONVERT(DATE,CheckOutDt,103))=8   and MONTH(CONVERT(DATE,CheckInDt,103))=8  
   -- Select * from #MonthWise where PropertyId=1 
   -- --and MONTH(CONVERT(DATE,CheckOutDt,103))=8   and MONTH(CONVERT(DATE,CheckInDt,103))=8  
   -- Return;

if('1'=@ChkMode)  
BEGIN     

     SELECT  CityName,sum(NightCount)StayPersons ,sUM(StayPersons)NightCount ,--sum(DayDiff),  
      sum(TOTAL) TOTAL--,  
    -- sum(Jan) Jan,sum(Feb) Feb,sum(Mar)Mar,sum(Aprl)Aprl,sum(may)may,sum(Jun)Jun,  
    --sum(Jul)Jul,sum(Aug)Aug,sum(Sept)Sept,sum(Oct)Oct,sum(Nov)Nov,sum(Decm)Decm   
    FROM #MonthWise WHERE   TOTAL!=0
 GROUP BY   CityName,CityId  
 order by CityName   
end   
if('2'=@ChkMode)  
BEGIN    
    
  INSERT INTO #FrontEnd(NightCount,StayPersons,CityName,CityId,TOTAL,PropertyId ,PropertyName,  
 Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,  
 A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)  
    
 SELECT  sum(NightCount)NightCount, sUM(StayPersons) StayPersons,--sum(DayDiff),  
 CityName,CityId ,sum(TOTAL) TOTAL,0 ,'',--MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
 sum(Jan) '1',sum(Feb) '2',sum(Mar)'3',sum(Aprl)'4',sum(may)'5',sum(Jun)'6'  ,  
 sum(Jul)'7',sum(Aug)'8',sum(Sept)'9',sum(Oct)'10',sum(Nov)'11',sum(Decm)'12',  
 SUM(A1)'21',sum(A2)'22',sum(A3)'23',sum(A4)'24',sum(A5)'25',sum(A6)'26',  
 sum(A7)'27',sum(A8)'28',sum(A9)'29',sum(A10)'30',sum(A11)'31',sum(A12)'32',  
 sum(B1)'41',sum(B2)'42',sum(B3)'43',sum(B4)'44',sum(B5)'45',sum(B6)'46',  
 sum(B7)'47',sum(B8)'48',sum(B9)'49',sum(B10)'50',sum(B11)'51',sum(B12)'52'  
 FROM #MonthWise WHERE   TOTAL!=0   
 GROUP BY   CityName,CityId    
 order by CityName   
 If(@MonthWise=3)  
 Begin  
  Select CityName,--sum(DayDiff),  
  --MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
  A1,B1,isnull(Jan,0) 'one',A2,B2,isnull(Feb,0) 'two',A3,B3,isnull(Mar,0)'three'--Aprl'4',may'5',Jun'6' ,  
 -- Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',  
 --A4,A5,A6,A7,A8,A9,A10,A11,A12,  
 --B4,B5,B6,B7,B8,B9,B10,B11,B12  
 ,NightCount StayPersons,StayPersons NightCount,TOTAL  
  from #FrontEnd WHERE   TOTAL!=0  
 order by CityName    
  End  
  If(@MonthWise=6)  
 Begin  
  Select --sum(DayDiff),  
 CityName,--MONTH(CONVERT(DATE,CheckOutDt,103)) CheckOutDt,  
  A1,B1,isnull(Jan,0) 'one',A2,B2,isnull(Feb,0) 'two',A3,B3,isnull(Mar,0)'three',A4,B4,isnull(Aprl,0)'four',A5,B5,isnull(may,0)'five',A6,B6,isnull(Jun,0)'six'  
  --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',  
 --A7,A8,A9,A10,A11,A12,  
 --B7,B8,B9,B10,B11,B12  
 ,NightCount StayPersons,StayPersons NightCount,TOTAL  
 from #FrontEnd   WHERE   TOTAL!=0
 order by CityName    
  End      
       
  END  
  if('4'=@ChkMode)  
BEGIN  
 INSERT INTO #FrontEnd(NightCount,StayPersons,CityName,CityId,TOTAL,PropertyId ,PropertyName,  
 Jan,Feb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,  
 A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12)  
    
 SELECT  sum(NightCount)NightCount, sUM(StayPersons)StayPersons,--sum(DayDiff),  
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
 if(@MonthWise=3)  
 BEGIN  
  SELECT   CityName,PropertyName,  
    A1,B1,Jan 'one',A2,B2,Feb 'two',A3,B3,Mar'three', --Aprl'4',may'5',Jun'6' ,  
  --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',  
 --A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,  
 --B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
 NightCount StayPersons, StayPersons NightCount, TOTAL  
     FROM #FrontEnd WHERE   TOTAL!=0  
 --GROUP BY  PropertyName,PropertyId ,CityName,CityId   
 order by CityName   
 eND  
 if(@MonthWise=6)  
 BEGIN  
  SELECT   CityName,PropertyName,  
    A1,B1,Jan 'one',A2,B2,Feb 'two',A3,B3,Mar 'three', A4,B4,Aprl 'four', A5,B5,may 'five', A6,B6,Jun 'six'  
 --Jul'7',Aug'8',Sept'9',Oct'10',Nov'11',Decm'12',  
 --A1,A2,A3,A4,A5,A6,--A7,A8,A9,A10,A11,A12,  
 --B1,B2,B3,B4,B5,B6--,B7,B8,B9,B10,B11,B12  
 ,NightCount StayPersons, StayPersons NightCount,TOTAL  
     FROM #FrontEnd  WHERE   TOTAL!=0 
 --GROUP BY  PropertyName,PropertyId ,CityName,CityId   
 order by CityName   
 eND  
  END  
  if('3'=@ChkMode)  
BEGIN  
  SELECT  CityName,PropertyName,sum(NightCount) StayPersons,SUM(StayPersons)NightCount ,--sum(DayDiff),  
     sum(TOTAL) TOTAL  
    -- sum(Jan) '1',sum(Feb) '2',sum(Mar)'3',sum(Aprl)'4',sum(may)'5',sum(Jun)'6'  ,  
 -- sum(Jul)'7',sum(Aug)'8',sum(Sept)'9',sum(Oct)'10',sum(Nov)'11',sum(Decm)'12'   
 FROM #MonthWise   WHERE   TOTAL!=0
 GROUP BY  PropertyName,PropertyId ,CityName,CityId   
 order by CityName  
  END 
  
 END
 eND 
 
 
 
 -- exec Sp_Booking_Report @Action ='PageLoad', @PayMode ='Bill to Client', @CityId = 0,@PropertyId = '',
 --@FromDate ='01/05/2014',@ToDate ='31/07/2014',@ChkMode='3', @ClientId =2007,@PrptyType='all',@MonthWise=3
  