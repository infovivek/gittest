SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchBookingGuest_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchBookingGuest_Search
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: Search booking Search
		Purpose  	: Search booking Search
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date			Signature			Description of Changes
	********************************************************************************************************	
	*******************************************************************************************************
*/
CREATE PROCEDURE Sp_SearchBookingGuest_Search
(
@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@Str2		NVARCHAR(100),					--drop table #TEMP2
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		INT,
@Id			INT,
@Id2		INT,					--WRBHBChechkOutHdr
@Id3		NVARCHAR(100)
)
AS
BEGIN	
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action='Booking'
	BEGIN	
		
		CREATE TABLE #TEMP1(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(1024),GuestId BIGINT,
		ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),Category NVARCHAR(100),
		PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),
		Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),PaymentMode NVARCHAR(100),
		Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100))
				
		CREATE TABLE #TEMP2(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(1024),GuestId BIGINT,
		ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),Category NVARCHAR(100),
		PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),
		Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),PaymentMode NVARCHAR(100),
		Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100))
	
		CREATE TABLE #TEMPFINAL(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(2500),
		GuestId NVARCHAR(2500),ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),
		Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),
		CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),
		PaymentMode NVARCHAR(100),Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100))

	 
		
--FIRST TEMP TABLE INSERT
--Room Level		
		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
		SELECT DISTINCT B.BookingCode,PAG.Occupancy,
		(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId as GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt),B.BookingLevel
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		--JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id=PAG.BookingId--AND BP.Id=PAG.BookingPropertyId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE  CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103)
		GROUP BY B.BookingCode,PAG.Occupancy,
		B.ClientName,B.ClientId,BGD.GuestId,
		BP.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		B.CheckInDate,B.CheckOutDate,B.Status,B.CancelStatus,PAG.CurrentStatus,PAG.TariffPaymentMode,PAG.Tariff,
		PAG.ChkInDt,PAG.ChkOutDt,B.BookingLevel ORDER BY BookingCode


--Appartment Level		
		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,
		BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)

		SELECT DISTINCT B.BookingCode,'' as OccupancyLevel,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,
		BGD.GuestId as GuestId,B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,
		CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 			
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0

--Bed Level	
		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,
		BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
		BookingLevel)

		SELECT DISTINCT B.BookingCode,'' as OccupancyLevel,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,
		BGD.GuestId as GuestId,B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,
		CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 				
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0 
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
		WHERE B.IsActive=1 AND B.IsDeleted=0
		
--SECOND TEMP TABLE INSERT	
--Room Level	
		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
		SELECT DISTINCT B.BookingCode,PAG.Occupancy,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode

--Appartment Level
		
		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 			
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
		
--Bed Level
		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)


		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 			
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
				
--SECOND INSERT FOR TEMP2 TABLE
--Room Level 

		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
		BookingLevel)
			
		SELECT DISTINCT B.BookingCode,PAG.Occupancy,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between 
		CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode

--Appartment Level
		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
		BookingLevel)
		
		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 			
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
		
--Bed Level 
		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
		BookingLevel)
		
		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
		FROM WRBHBBooking B 			
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
		AND PAG.IsDeleted=0
		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		AND PAG.GuestId=BGD.GuestId				
		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
		AND PAG.BookingPropertyId=BP.PropertyId
		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) >=1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
--INSERT FOR TEMPFINAL TABLE

		INSERT INTO #TEMPFINAL(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
		SELECT DISTINCT BookingCode,OccupancyLevel,(SELECT Substring((SELECT ', ' + CAST(T1.Guests AS VARCHAR(1024)) FROM #TEMP1 T1
		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  Guests,
		(SELECT Substring((SELECT ', ' + CAST(T1.GuestId AS NVARCHAR(200)) FROM #TEMP1 T1
		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  GuestId,
		ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,CheckOutDate,
		Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel FROM #TEMP2 T2
		WHERE ChkInStatus!='0' AND BookingCode!=0
		
	 
--UPDATING FIRST TEMP TABLE
 		
		UPDATE #TEMPFINAL SET Status='Booked' where Status='Direct Booked'
		--UPDATE #TEMPFINAL SET Status='Booked' where Status='Front Booking'
		UPDATE #TEMPFINAL SET Status='Cancelled' WHERE CancelStatus!=''	
		UPDATE #TEMPFINAL SET Status='CheckIn' WHERE ChkInStatus='CheckIn'	
		UPDATE #TEMPFINAL SET Status='CheckOut' WHERE ChkInStatus='CheckOut'	
		--SELECT BookingCode,Guests,ClientName Client,PropertyName Property,BookingDate,Status FROM #TEMP1
		
		--SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
		--CheckOutDate,Status,PaymentMode,Tariff as TotalTariff,Days FROM #TEMPFINAL
		--ORDER BY BookingCode desc
	
	--SELECT * FROM #TEMPFINAL
	
	
		CREATE TABLE #BookingCode (BookingCode NVARCHAR(100)) 
		--declare @Str2 nvarchar(100)='983,982' 
	WHILE LEN(@Str2) > 0
		BEGIN
			Declare @individual varchar(20) = null
			
		    IF PATINDEX('%,%',@Str2) > 0
				BEGIN
					SET @individual = SUBSTRING(@Str2, 0, PATINDEX('%,%',@Str2))
					--SELECT @individual
					SET @Str2 = SUBSTRING(@Str2, LEN(@individual + ',') + 1,LEN(@Str2))
				END
			ELSE
				BEGIN
					SET @individual = @Str2
					SET @Str2 = NULL
					--INSERT INTO #BookingCode(BookingCode)
					--SELECT @individual
					--SELECT BookingCode AS Guest FROM #BookingCode
				END
				INSERT INTO #BookingCode(BookingCode) 
				SELECT @individual
				--SELECT BookingCode AS BookingCode FROM #BookingCode
				--DROP TABLE #BookingCode
		
				 declare @Value bigint,@Value1 bigint;
			     set @Value= (SELECT ISNULL(COUNT(*),0) FROM #BookingCode)
			     set @Value1=ISNULL(@Value,0)
				-- select @Value,@Value1
		END
		 set @Value1=ISNULL(@Value,0)
				-- select @Value,@Value1
	-- SELECT @Id,@Id2,@Str1,ISNULL(@Value,0),@FromDate
	
--1 DATA IS GIVEN	
--ONLY PROPERTY IS GIVEN		
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1=0  AND @FromDate=''
		BEGIN
			SELECT @Id
			
			SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,
			BookingDate,CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff FROM #TEMPFINAL
			WHERE PropertyId=@Id ORDER BY BookingCode desc
		END	

--ONLY CLIENT IS GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate=''
		BEGIN
		--DECLARE @Str10 NVARCHAR(100)='Client';
		--return @Str10
			SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,
			BookingDate,CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff FROM #TEMPFINAL
			WHERE ClientId=@Id2 ORDER BY BookingCode desc
		END	
		

--ONLY GUEST IS GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='' AND @Value1=0 AND @FromDate=''
		BEGIN
			SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,
			BookingDate,CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
			WHERE GuestId LIKE '%'+@Id3+'%'  ORDER BY BookingCode desc
		END			
		
--ONLY BOOKING CODE IS GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate=''
		BEGIN
			SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,
			BookingDate,CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
			WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc			
		END
		
--ONLY STATUS IS GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND  @Str1!='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
				CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL 
				WHERE Status=@Str1 ORDER BY BookingCode desc
			END	
		IF @Id=0 AND @Id2=0 AND  @Str1='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
				CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				ORDER BY BookingCode desc
			END			

--ONLY DATE ARE GIVEN
			IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate!='' 
				BEGIN
					SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
					CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
					WHERE CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	

--2 DATA ARE GIVEN				
--ONLY PROPERTY AND CLIENT ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,CheckOutDate,
				Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 ORDER BY BookingCode desc
			END	

--ONLY PROPERTY AND STATUS ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id ORDER BY BookingCode desc
			END
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''		
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND PropertyId=@Id ORDER BY BookingCode desc
		    END
		    
--ONLY PROPERTY AND BOOKING CODE ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND  @Str1='' AND @Value1!=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END
	
--ONLY PROPERTY AND DATE ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END

--ONLY PROPERTY AND GUEST
		IF @Id!=0 AND @Id2=0 AND @Id3!=0 AND  @Str1='' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND GuestId LIKE '%'+@Id3+'%' ORDER BY BookingCode desc
			END

--ONLY CLIENT AND BOOKING CODE ARE GIVEN
	    IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END	

--ONLY CLIENT AND STATUS ARE GIVEN
	    IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND Status=@Str1 ORDER BY BookingCode desc
			END	
		 IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 ORDER BY BookingCode desc
			END
									
--ONLY CLIENT AND DATE ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END

--ONLY CLIENT AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND  @Str1='' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND GuestId IN(@Id3) ORDER BY BookingCode desc
			END	

--ONLY BOOKING CODE AND STATUS ARE GIVEN
	    IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END	
		 IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END	

--ONLY BOOKING CODE AND DATE ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		

--ONLY BOOKING CODE AND GUEST
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='' AND @Value1!=0 AND @FromDate=''	
		BEGIN
			SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
			WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
			GuestId IN(@Id3) ORDER BY BookingCode desc
		END
										
--ONLY STATUS AND DATE ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END

--ONLY STATUS AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status='Booked' AND GuestId IN('18395') ORDER BY BookingCode desc
			END
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE GuestId IN(@Id3) ORDER BY BookingCode desc
			END
--ONLY DATE AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='' AND @Value1=0 AND @FromDate!=''			
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE GuestId=@Id3 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END
				
--3 PARAMETERS ARE GIVEN
				
--ONLY PROPERTY,CLIENT AND STATUS ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 ORDER BY BookingCode desc
			END	
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND Status=@Str1 ORDER BY BookingCode desc
			END	
			
--ONLY PROPERTY,CLIENT AND BOOKINGCODE ARE GIVEN			
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END		
			
--ONLY PROPERTY,CLIENT AND DATE ARE GIVEN			
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND 
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		

--ONLY PROPERTY,CLIENT AND GUEST ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId IN(@Id3) ORDER BY BookingCode desc
			END	
			
--ONLY PROPERTY,STATUS AND BOOKINGCODE ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND Status=@Str1 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END	

--ONLY PROPERTY,STATUS AND DATE ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND Status=@Str1 AND 
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	
			
--ONLY PROPERTY,STATUS AND GUEST ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND Status=@Str1 AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND GuestId IN(@Id3) ORDER BY BookingCode desc
			END	
			
--ONLY PROPERTY,BOOKINGCODE AND DATE ARE GIVEN			
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode DESC
			END	
	
--ONLY PROPERTY,BOOKINGCODE AND GUEST ARE GIVEN			
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3 ORDER BY BookingCode DESC
			END	
								
--ONLY PROPERTY,DATE AND GUEST ARE GIVEN			
		IF @Id!=0 AND @Id2=0 AND @Id3!=0 AND  @Str1='' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103)  AND
				GuestId IN(@Id3) ORDER BY BookingCode DESC
			END	

	
--ONLY CLIENT,STATUS AND BOOKINGCODE ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND Status=@Str1 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END	

--ONLY CLIENT,STATUS AND DATE ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND Status=@Str1 AND 
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	


--ONLY CLIENT,STATUS AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND Status=@Str1 AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END	
		
			
--ONLY CLIENT,BOOKINGCODE AND DATE ARE GIVEN			
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode DESC
			END	
			
			
--ONLY CLIENT,BOOKINGCODE AND GUEST ARE GIVEN			
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId IN(@Id3) ORDER BY BookingCode DESC
			END	
				
										
--ONLY STATUS,BOOKINGCODE AND DATE ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	


--ONLY STATUS,BOOKINGCODE AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND GuestId IN(@Id3)
				 ORDER BY BookingCode desc
			END	

			
--4 DATA ARE GIVEN			
--PROPERTY,CLIENT,STATUS AND BOOKINGCODE ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND PropertyId=@Id AND ClientId=@Id2 AND
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) 
				ORDER BY BookingCode desc
			END	
	
--PROPERTY,CLIENT,STATUS AND DATE ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND  @Str1!='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND PropertyId=@Id AND ClientId=@Id2 AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND PropertyId=@Id AND 
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	


--PROPERTY,CLIENT,STATUS AND GUEST ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND Status=@Str1 AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND PropertyId=@Id AND GuestId IN(@Id3)
				ORDER BY BookingCode desc
			END	
			
						
--PROPERTY,CLIENT,BOOKINGCODE AND DATE ARE GIVEN
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND PropertyId=@Id 
				AND ClientId=@Id2 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END
	
--PROPERTY,BOOKINGCODE,STATUS AND DATE ARE GIVEN
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND PropertyId=@Id AND
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	
			
--CLIENT,BOOKINGCODE,STATUS AND DATE ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND ClientId=@Id2 AND
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END				

--CLIENT,BOOKINGCODE,STATUS AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND ClientId=@Id2 AND
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	

--GUEST,STATUS,BOOKINGCODE AND DATE ARE GIVEN
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3 ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3  ORDER BY BookingCode desc
			END		
--DATE,BOOKINGCODE,CLIENT AND GUEST ARE GIVEN
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				GuestId=@Id3 AND  CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	
			
--5 DATA ARE GIVEN
--EXCEPT DATE
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId=@Id3 AND Status=@Str1 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value!=0 AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId=@Id3 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) ORDER BY BookingCode desc
			END	

--EXCEPT BOOKING CODE			
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId=@Id3 AND Status=@Str1 AND 
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId=@Id3 AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END	

--EXCEPT STATUS			
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND GuestId=@Id3 AND 
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) AND
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END

--EXCEPT GUEST			
		IF @Id!=0 AND @Id2!=0 AND @Id3=0 AND @Str1!='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) AND
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND ClientId=@Id2 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END

--EXCEPT CLIENT			
		IF @Id!=0 AND @Id2=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND GuestId=@Id3 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) AND
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE PropertyId=@Id AND GuestId=@Id3 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END
			
--EXCEPT PROPERTY			
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE GuestId=@Id3 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) AND
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff FROM #TEMPFINAL
				WHERE GuestId=@Id3 AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode)
				AND CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			END			
																												
--NOTHING IS GIVEN				
	IF @Id=0 AND @Id2=0 AND @Id3=0 AND @Str1='' AND @Str2='' AND @FromDate=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
				CheckInDate,CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE  CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,'1/1/2000',103) and
				CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode desc	
			END	



--ALL VALUES ARE GIVEN
	IF @Id!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE Status=@Str1 AND ClientId=@Id2 AND PropertyId=@Id AND
				BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND
				CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) AND GuestId=@Id3 ORDER BY BookingCode desc
			END		
		IF @Id=0 AND @Id2!=0 AND @Id3!=0 AND @Str1='All Status' AND @Value1!=0 AND @FromDate!=''
			BEGIN
				SELECT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status,PaymentMode,Tariff*Days AS TotalTariff  FROM #TEMPFINAL
				WHERE ClientId=@Id2 AND PropertyId=@Id AND BookingCode IN(SELECT CAST(BookingCode AS BIGINT) FROM #BookingCode) AND 
				CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) 
				AND	CONVERT(DATETIME,@ToDate,103) AND GuestId=@Id3 ORDER BY BookingCode desc
			END																							 	
	END
	END
	--END
	
	--exec Sp_SearchBookingGuest_Search @Str1=N'',@Str2=N'',@FromDate=N'',@ToDate=N'',@Id2='2723',@Id3=2723,
--@Action=N'Booking',@Id=0,@UserId=4