SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[HBMenu_MenuScreen_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[HBMenu_MenuScreen_Help]
GO 
 /* 
       Author Name : <Anbu>
		Created On 	: <Created Date (28/01/2015)  >
		Section  	: MenuScreen 
		Purpose  	: MenuScreen
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date			Signature			Description of Changes
	********************************************************************************************************	
	*******************************************************************************************************
*/--exec Sp_MenuScreen_Help @PAction=N'DATALOAD',@Pram1=65,@Pram2=0,@Pram3=N'',@UserName=N'',@Password=N''
CREATE PROCEDURE [dbo].[HBMenu_MenuScreen_Help](
@PAction		 NVARCHAR(100)=NULL,
@Pram1		     BIGINT,
@Pram2           BIGINT=NULL, 
@Pram3			 NVARCHAR(100)=NULL, 
@UserName        NVARCHAR(100),
@Password		 NVARCHAR(100)	,
@userIds          Bigint
)
AS
BEGIN  
IF @PAction ='User'
BEGIN
DECLARE @USERID BIGINT,@ClientId Bigint;
Declare @Designation Nvarchar(200)
OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';

 SELECT @USERID=Id 
 FROM WrbhbTravelDesk  
 WHERE CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName ;
 
 Set @Designation=( Select Designation FROM WrbhbTravelDesk  
 WHERE CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName )
 
  Set @ClientId=( Select ClientId FROM WrbhbTravelDesk  
 WHERE CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName)
 
 --if(@Designation='Master')
 IF ISNULL(@USERID,0)!=0
 BEGIN
		SELECT Id,Email,FirstName,ClientId,Designation as LoginType FROM WrbhbTravelDesk WHERE Id=@USERID
		
		
		SELECT C.ClientLogo as Logo FROM WrbhbTravelDesk T 
		JOIN WRBHBClientManagement C ON T.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE T.Id=@USERID AND T.IsActive=1 AND T.IsDeleted=0
		
		SELECT ISNULL(SCREENNAME,'') SCREENNAME,ISNULL(Id,0) Id,ISNULL(ModuleName,'')ModuleName,
		ISNULL(SWF,'')SWF FROM WRBHBMENU_ScreenMaster 
		WHERE ISNULL(SWF,'')!=''  and IsActive=1-- ModuleName IN('Master','Report','Booking')
		--GROUP BY SCREENNAME,Id,ModuleName,SWF
		order by OrderNumber
		
		SELECT ModuleName,moduleId FROM WRBHBMENU_ScreenMaster
	    WHERE moduleId!=0 and IsActive=1--ModuleName IN('Master','Report','Booking')
	    GROUP BY ModuleName,moduleId
	    order by moduleId
	    if(@Designation='MasterClient')
	    Begin
	    Create Table #TempClntMgnt(zClientId Bigint,label Nvarchar(800)) 
	    
	    --Insert into #TempClntMgnt(zClientId,label)
	    --Select 0,'Select Client';
	    
	    Insert into #TempClntMgnt(zClientId,label) 
	    SELECT Id as zClientId ,ClientName as label  FROM WRBHBClientManagement 
		WHERE IsActive=1 AND IsDeleted=0  and MasterClientId=@ClientId ;
		
		Select zClientId,label from   #TempClntMgnt
	    End
 END
 ELSE
 BEGIN
	SELECT 'USER NOT MATCH' as NAME
 END		
END  
IF @PAction ='DATALOAD'
BEGIN
 --Expected CHECKIN
		-- SELECT TOP 10 H.ClientName ,CityName,D.FirstName FirstName,BookingLevel  
		    
  Set @ClientId=( Select ClientId FROM WrbhbTravelDesk  
 WHERE IsDeleted=0 AND IsActive=1 AND Id=@userIds)
 
 Set @Designation=( Select Designation FROM WrbhbTravelDesk  
 WHERE IsDeleted=0 AND IsActive=1 AND Id=@userIds)
 

 
 
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
	--WHERE  --CONVERT(DATE,CheckOutDt,103) <= CONVERT(DATE,GETDATE(),103)  
	-- CONVERT(DATE,CheckInDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
	 
	 
	 --tariff amount not equals to zero and all the avl
	INSERT INTO #BookingSelectFinal(BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,  
	BookingLevel,Tariff,DayDiff,ApartmentId,Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,
	CityId,CityName,PropertyName,RoomCaptured) 
	SELECT BookingCode,ClientId,ClientName,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Occupancy,BookingLevel,Tariff,
	DATEDIFF(day,CONVERT(DATE,CheckInDt,103 ),CONVERT(DATE,CheckOutDt,103 ))  AS DiffDate,ISNULL(ApartmentId,0),
	Category,ServicePaymentMode,TariffPaymentMode,PropertyId,PropertyType,CityId,C.CityName,PropertyName ,RoomCaptured
	FROM #BookingSelect B
	left outer   JOIN WRBHBCity C ON C.Id=B.CityId
	--WHERE  --CONVERT(DATE,CheckOutDt,103) > CONVERT(DATE,GETDATE(),103) 
	--CONVERT(DATE,CheckOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
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
    --WHERE  CONVERT(DATE,CheckOutDt,103) > CONVERT(DATE,@ToDate,103) and 
    --CONVERT(DATE,CheckInDt,103) <= CONVERT(DATE,@FromDate,103)    
	--and TariffPaymentMode=@PayMode;
	
 

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
	If(@Designation='MasterClient')
	Begin
	Create Table #ClientId(ClientId Bigint,Id Bigint Primary Key Identity(1,1))
	
	--Find by Client Id
     Declare @L Bigint;--,@NoOfDays Bigint;
	
		Insert into #ClientId(ClientId)

		Select Id from WRBHBClientManagement where MasterClientId=@ClientId 
		and IsActive=1 and IsDeleted=0
		
	Declare @Count BIGINT ,@id Bigint,@mastrClentId Bigint;
	Set @L= (Select COUNT(Id) from #ClientId);

	SELECT top 1 @id=Id,@mastrClentId=ClientId From #ClientId  order by Id Desc

	WHILE (@L>0)
	BEGIN 

		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,0,'',DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,'' BookingId 
		FROM #FinalSelect
		WHERE  	ClientId=@mastrClentId 
      Delete #ClientId where Id=@id;
	SET @NoOfDays=0
	IF @NoOfDays=0
	BEGIN
	Set @L= (Select COUNT(Id) from #ClientId);
	SELECT top 1 @id=Id,@mastrClentId=ClientId From #ClientId  order by Id Desc 
	END
	END 
		  
	EnD
	
	If(@Designation='Client')
	Begin
		INSERT INTO #tempDat(ClientId,ClientName,NightCount,StayPersons,DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId,PropertyId,PropertyType,BookingId)

		SELECT ClientId,ClientName,0,'',DayDiff ,TOTAL,PropertyName,CityName,
		TariffPaymentMode,CheckInDt,CheckOutDt ,CityId ,PropertyId,PropertyType,'' BookingId 
		FROM #FinalSelect
		WHERE  	ClientId=@Pram1  ; 
	End
  --select * from #tempDat --where TariffPaymentMode=@TariffPaymentMode
--	ORDER BY PropertyId
 --	Return;
 
  Set @clientName=( Select left(ClientName,9) FROM WrbhbTravelDesk  
 WHERE IsDeleted=0 AND IsActive=1 AND Id=@userIds)
 
	 CREATE TABLE #BTCBOOKING(ClientId BIGINT,BTCAmount DECIMAL(27,2),Type NVARCHAR(500),OTHERS NVARCHAR(100))
	-- CREATE TABLE #DirectBOOKING(ClientId BIGINT,DirectAmount DECIMAL(27,2))
	-- CREATE TABLE #BillToClientBOOKING(ClientId BIGINT,BillToClientAmount DECIMAL(27,2))
	 
	 --CREATE TABLE #GHBOOKING(ClientId BIGINT,GHAmount DECIMAL(27,2))
	 --CREATE TABLE #CPPBOOKING(ClientId BIGINT,CPPAmount DECIMAL(27,2))
	-- CREATE TABLE #OthersBOOKING(ClientId BIGINT,OthersAmount DECIMAL(27,2))
	 
	 
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Bill To Hummingbird','a' FROM #tempDat
	  WHERE TariffPaymentMode='Bill to Company (BTC)'
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Direct','a' FROM #tempDat
	  WHERE TariffPaymentMode='Direct'
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Bill To '+isnull(@clientName,''),'b' FROM #tempDat
	  WHERE TariffPaymentMode   IN('Bill to Client')
	  GROUP BY ClientId 
	  
	   INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,'Direct ','ac' 
	   where 'a'  not  in ( Select OTHERS from #BTCBOOKING)
	   INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,'Bill To Hummingbird','bc' 
	   where 'a'  not  in ( Select OTHERS from #BTCBOOKING)
	   
	 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,'Bill To '+isnull(@clientName,''),'b' 
	   where 'b'  not  in ( Select OTHERS from #BTCBOOKING)
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  select 0,SUM(BTCAmount),'Total','c' from #BTCBOOKING
	  
	   --INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  -- SELECT 0,10.00,'','c'  
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Guest Houses','GH' FROM #tempDat
	  WHERE UPPER(PropertyType) IN(UPPER('MGH'),UPPER('DdP'))
	  GROUP BY ClientId 
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),isnull(@clientName,'')+' Preferred','PR' FROM #tempDat
	  WHERE UPPER(PropertyType) in (UPPER('CPP'))
	  GROUP BY ClientId 
	  
	   INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,'Guest Houses','GH' 
	   where 'GH'  not  in ( Select OTHERS from #BTCBOOKING)
	    INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,isnull(@clientName,'')+' Preferred','PR' from #BTCBOOKING
	   where   ('PR')  not  in ( Select OTHERS from #BTCBOOKING)
	   
	 
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	  SELECT ClientId,SUM(isnull(TOTAL,0)),'Others Properties','S' FROM #tempDat
	  WHERE UPPER(PropertyType)NOT IN (UPPER('CPP'),UPPER('MGH'),UPPER('DdP')) 
	  GROUP BY ClientId
	  
	  INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type,OTHERS)
	   Select 0,0,'Others Properties','s' 
	   where 'S'  not  in ( Select OTHERS from #BTCBOOKING)
	   
	  
	  
	  --  Select * from #BTCBOOKING  
	  --INSERT INTO #BTCBOOKING(ClientId,BTCAmount,Type)
	  --SELECT ClientId,BTCAmount,'Total' FROM #BTCBOOKING
	  --WHERE Type='Total' 
	  --GROUP BY ClientId,BTCAmount
	  
	  
	 --IF @PrptyType='City'
	 -- BEGIN
		 
		 SELECT ClientId,dbo.CommaSeprate(ISNULL(BTCAmount,0)) Amount,Type TotalSpend,OTHERS FROM #BTCBOOKING
	     -- WHERE ISNULL(BTCAmount,0)!= 0	 
	     GROUP BY ClientId,BTCAmount,Type,OTHERS
	     ORDER BY OTHERS
	  --END
	 -- IF @PrptyType='CityComma'
	  --BEGIN
		
		SELECT C.CityName,dbo.CommaSeprate(SUM(isnull(TOTAL,0))) Amount  FROM #tempDat S
		JOIN WRBHBCity C WITH(NOLOCK) ON S.CityId=C.Id
		WHERE ISNULL(TOTAL,0)> 100
		GROUP BY CityId,C.CityName
	  --END
	  
	  
	  
  
 
   END
END
 