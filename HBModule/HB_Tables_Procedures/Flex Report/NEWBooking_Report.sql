SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_NEWBooking_Report') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_NEWBooking_Report
GO 

CREATE PROCEDURE Sp_NEWBooking_Report
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
	  PropertyName NVARCHAR(100),RoomCaptured BIgint);
	  
	  
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
	--and TariffPaymentMode=@PayMode;
	

	--INSERT INTO #BookingTestFinal
	--(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,
	--CheckInDt,CheckOutDt,Occupancy, BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,
	--TariffPaymentMode,PropertyId,PropertyType,CityId,CityName,PropertyName)
	
	--SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,
	--CheckInDt,CheckOutDt,Occupancy, BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,
	--TariffPaymentMode,PropertyId,PropertyType,CityId,CityName,PropertyName
	--FROM #BookingSelectFinal B  

	INSERT INTO #FinalSelectTest(ClientId,ClientName,Counts,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,GuestId,RoomId,RoomTypes)

	select ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	Tariff TOTAL,PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,0 GuestId ,RoomId,RoomName RoomTypes
	from #BookingSelectFinal 
	  group by  ClientId,ClientName,DayDiff,BookingId,CheckInDt,CheckOutDt,DayDiff,Tariff,
	     PropertyName,CityName,TariffPaymentMode,CityId,PropertyId,PropertyType,RoomId,RoomName,RoomCaptured;
	
      
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
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,0,'',DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,'' BookingId 
		FROM #FinalSelect
		WHERE  CONVERT(DATE,CheckInDt,103)
		BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103) and-- PropertyId=1
		ClientId=@ClientId 
		--group by ClientId,ClientName,DayDiff , TOTAL,PropertyName,CityName,
		--TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType--,BookingId 
	
--	select * from #tempDat where TariffPaymentMode=@TariffPaymentMode
--	ORDER BY PropertyId
--	Return;
	 CREATE TABLE #BTCBOOKING(ClientId BIGINT,BTCAmount DECIMAL(27,2),Type NVARCHAR(100))
	 CREATE TABLE #DirectBOOKING(ClientId BIGINT,DirectAmount DECIMAL(27,2))
	 CREATE TABLE #BillToClientBOOKING(ClientId BIGINT,BillToClientAmount DECIMAL(27,2))
	 
	 CREATE TABLE #GHBOOKING(ClientId BIGINT,GHAmount DECIMAL(27,2))
	 CREATE TABLE #CPPBOOKING(ClientId BIGINT,CPPAmount DECIMAL(27,2))
	 CREATE TABLE #OthersBOOKING(ClientId BIGINT,OthersAmount DECIMAL(27,2))
	 
	 
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'BTC' FROM #tempDat
	  WHERE TariffPaymentMode='Bill to Company (BTC)'
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Direct' FROM #tempDat
	  WHERE TariffPaymentMode='Direct'
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Bill To Client' FROM #tempDat
	  WHERE TariffPaymentMode NOT IN('Bill to Company (BTC)','Direct')
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  select 0,SUM(BTCAmount),'Total' from #BTCBOOKING
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'GH' FROM #tempDat
	  WHERE UPPER(PropertyType) IN(UPPER('MGH'),UPPER('DdP'))
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'CPP' FROM #tempDat
	  WHERE UPPER(PropertyType)=UPPER('CPP')
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Others' FROM #tempDat
	  WHERE UPPER(PropertyType)NOT IN (UPPER('CPP'),UPPER('MGH'),UPPER('DdP')) 
	  GROUP BY ClientId
	  
	  
	 IF @PrptyType='City'
	  BEGIN
		
		SELECT C.CityName,CAST(SUM(isnull(TOTAL,0)) AS  BIGINT)  FROM #tempDat S
		JOIN WRBHBCity C WITH(NOLOCK) ON S.CityId=C.Id
		WHERE ISNULL(TOTAL,0)!=0
		GROUP BY CityId,C.CityName
	  END
	  IF @PrptyType='CityComma'
	  BEGIN
		
		SELECT C.CityName,dbo.RupieFormat(SUM(isnull(TOTAL,0)))  FROM #tempDat S
		JOIN WRBHBCity C WITH(NOLOCK) ON S.CityId=C.Id
		WHERE ISNULL(TOTAL,0)!=0
		GROUP BY CityId,C.CityName
	  END
	  ELSE
	  BEGIN
	    SELECT ClientId,dbo.RupieFormat(ISNULL(BTCAmount,0)) Amount,Type FROM #BTCBOOKING
	    WHERE ISNULL(BTCAmount,0)!=0	  
	  END
	  
	  
  
 END
 END 
 
 

  