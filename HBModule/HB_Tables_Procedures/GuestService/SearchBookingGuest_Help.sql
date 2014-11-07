 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchBookingGuest_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchBookingGuest_Help
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: Search booking HELP
		Purpose  	: Search booking HELP
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
CREATE PROCEDURE Sp_SearchBookingGuest_Help
(
@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		INT,
@Id			INT
)
AS							--DROP TABLE #TEMPFINAL
BEGIN						--DROP TABLE #TEMP2
	IF @Action='Pageload'	--DROP TABLE #TEMP1
	BEGIN
		CREATE TABLE #TempProperty(Property NVARCHAR(100),zId BIGINT)
		
		INSERT INTO #TempProperty(Property,zId)
		SELECT DISTINCT (P.PropertyName+ '-'+C.CityName) Property,PropertyId as zId FROM WRBHBBookingProperty BP
		JOIN WRBHBProperty P ON P.Id=BP.PropertyId 
		JOIN WRBHBCity C ON C.Id=P.CityId
		WHERE BP.IsActive=1 AND BP.IsDeleted=0 
		
		INSERT INTO #TempProperty(Property,zId)
		SELECT HotalName+'-'+City ,HotalId FROM WRBHBStaticHotels
		WHERE IsDeleted=0 AND IsActive=1 
		ORDER BY HotalName ASC
		
		SELECT Property,CAST(zId AS NVARCHAR) zId FROM #TempProperty
		ORDER BY Property ASC
		
		SELECT DISTINCT Category label FROM WRBHBProperty where IsActive = 1 and IsDeleted = 0
		
		SELECT ClientName Client,Id ZId FROM WRBHBClientManagement where IsActive=1 ORDER BY Client
		
		SELECT DISTINCT (FirstName+ ' '+ LastName) AS Guest,GuestId as ZId
		FROM WRBHBBookingGuestDetails ORDER BY Guest
		
--		CREATE TABLE #TEMP1(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(1024),GuestId BIGINT,
--		ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),Category NVARCHAR(100),
--		PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),
--		Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),PaymentMode NVARCHAR(100),
--		Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100),BookingId BIGINT,PropertyType NVARCHAR(100))
				
--		CREATE TABLE #TEMP2(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(1024),GuestId BIGINT,
--		ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),Category NVARCHAR(100),
--		PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),
--		Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),PaymentMode NVARCHAR(100),
--		Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100))
	
--		CREATE TABLE #TEMPFINAL(BookingCode BIGINT,OccupancyLevel NVARCHAR(100),Guests NVARCHAR(2500),
--		GuestId NVARCHAR(2500),ClientName NVARCHAR(100),ClientId BIGINT,PropertyName NVARCHAR(100),
--		Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),CheckInDate NVARCHAR(100),
--		CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),ChkInStatus NVARCHAR(100),
--		PaymentMode NVARCHAR(100),Tariff DECIMAL(27,2),Days BIGINT,BookingLevel NVARCHAR(100))

	 
		
----BOOKING AND CANCELED
----Room Level		
--		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
--		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel,PropertyType)
		
--		SELECT DISTINCT B.BookingCode,PAG.Occupancy,
--		(PAG.FirstName+ ' '+ PAG.LastName) AS Guests,PAG.GuestId as GuestId,
--		B.ClientName Client,B.ClientId,ISNULL(P.PropertyName,'') Property,P.Category,PAG.BookingPropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,PAG.CurrentStatus Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt),B.BookingLevel,BP.PropertyType
--		FROM WRBHBBooking B		
--		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
--		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId	AND PAG.BookingPropertyTableId=BP.Id	
--		LEFT OUTER JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id		
--		WHERE  CONVERT(DATETIME,B.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103)
--		GROUP BY B.BookingCode,PAG.Occupancy,
--		B.ClientName,B.ClientId,PAG.GuestId,
--		P.PropertyName,P.Category,PAG.BookingPropertyId,PAG.FirstName,PAG.LastName,PAG.CreatedDate,
--		B.CheckInDate,B.CheckOutDate,B.Status,B.CancelStatus,PAG.CurrentStatus,PAG.TariffPaymentMode,PAG.Tariff,
--		PAG.ChkInDt,PAG.ChkOutDt,B.BookingLevel,BP.PropertyType ORDER BY BookingCode


----Appartment Level		
--		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,
--		BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel,
--		PropertyType)

--		SELECT DISTINCT B.BookingCode,'' as OccupancyLevel,(PAG.FirstName+ ' '+ PAG.LastName) AS Guests,
--		PAG.GuestId as GuestId,B.ClientName Client,B.ClientId,ISNULL(P.PropertyName,'') Property,P.Category,PAG.BookingPropertyId,
--		CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
--		CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,PAG.CurrentStatus Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel,
--		BP.PropertyType
--		FROM WRBHBBooking B 			
--		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0					
--		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyTableId=BP.Id
--		LEFT OUTER JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE   B.IsActive=1 AND B.IsDeleted=0 AND CONVERT(DATETIME,B.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) 

----Bed Level	
--		INSERT INTO #TEMP1(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,
--		BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
--		BookingLevel,PropertyType)

--		SELECT DISTINCT B.BookingCode,'' as OccupancyLevel,(PAG.FirstName+ ' '+ PAG.LastName) AS Guests,
--		PAG.GuestId as GuestId,B.ClientName Client,B.ClientId,ISNULL(P.PropertyName,'') Property,P.Category,PAG.BookingPropertyId,
--		CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
--		CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,PAG.CurrentStatus Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel,BP.PropertyType
--		FROM WRBHBBooking B 				
--		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0 					
--		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyTableId=BP.Id
--		LEFT OUTER JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE B.IsActive=1 AND B.IsDeleted=0
--		AND CONVERT(DATETIME,B.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) 
		
-----UPDATE MMT PROPERTY NAME
--	UPDATE #TEMP1 SET PropertyName=S.HotalName,Category='MMT' FROM #TEMP1 A
--	JOIN dbo.WRBHBStaticHotels S ON A.PropertyId=S.HotalId
--	WHERE PropertyType='MMT'
	
	
		
----SECOND TEMP TABLE INSERT	
----Room Level	
--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
--		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
--		SELECT DISTINCT B.BookingCode,PAG.Occupancy,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B
--		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
--		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
--		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
--		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
--		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
--		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode

----Appartment Level
		
--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
--		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
--		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B 			
--		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0
--		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
--		AND PAG.GuestId=BGD.GuestId				
--		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyId=BP.PropertyId
--		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
--		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
		
----Bed Level
--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
--		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)


--		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B 			
--		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0
--		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
--		AND PAG.GuestId=BGD.GuestId				
--		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyId=BP.PropertyId
--		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
--		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
				
----SECOND INSERT FOR TEMP2 TABLE
----Room Level 

--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
--		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
--		BookingLevel)
			
--		SELECT DISTINCT B.BookingCode,PAG.Occupancy,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B
--		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
--		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
--		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
--		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
--		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
--		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between 
--		CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode

----Appartment Level
--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
--		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
--		BookingLevel)
		
--		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B 			
--		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0
--		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
--		AND PAG.GuestId=BGD.GuestId				
--		JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyId=BP.PropertyId
--		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
--		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
		
----Bed Level 
--		INSERT INTO #TEMP2(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,
--		PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,
--		BookingLevel)
		
--		SELECT DISTINCT B.BookingCode,'',(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,BGD.GuestId,
--		B.ClientName Client,B.ClientId,BP.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),
--		PAG.CreatedDate,103) AS BookingDate,CONVERT(NVARCHAR(100),B.CheckInDate,103) AS CheckInDate,
--		CONVERT(NVARCHAR(100),B.CheckOutDate,103) AS CheckOutDate,B.Status Status,B.CancelStatus,PAG.CurrentStatus,
--		PAG.TariffPaymentMode,PAG.Tariff,DATEDIFF(DAY,PAG.ChkInDt,PAG.ChkOutDt) as Days,B.BookingLevel
--		FROM WRBHBBooking B 			
--		JOIN WRBHBBedBookingPropertyAssingedGuest PAG WITH(NOLOCK) ON PAG.BookingId=B.Id AND PAG.IsActive=1 
--		AND PAG.IsDeleted=0
--		JOIN WRBHBBookingGuestDetails BGD WITH(NOLOCK) ON B.Id=BGD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
--		AND PAG.GuestId=BGD.GuestId				
--		JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
--		AND PAG.BookingPropertyId=BP.PropertyId
--		JOIN WRBHBProperty P on  P.Id = PAG.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
--		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
--		GROUP BY BookingCode HAVING COUNT(*) >=1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
--		CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode
----INSERT FOR TEMPFINAL TABLE

--		INSERT INTO #TEMPFINAL(BookingCode,OccupancyLevel,Guests,GuestId,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
--		CheckOutDate,Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel)
		
--		SELECT DISTINCT BookingCode,OccupancyLevel,(SELECT Substring((SELECT ', ' + CAST(T1.Guests AS VARCHAR(1024)) FROM #TEMP1 T1
--		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
--		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  Guests,
--		(SELECT Substring((SELECT ', ' + CAST(T1.GuestId AS NVARCHAR(200)) FROM #TEMP1 T1
--		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
--		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  GuestId,
--		ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,CheckOutDate,
--		Status,CancelStatus,ChkInStatus,PaymentMode,Tariff,Days,BookingLevel FROM #TEMP2 T2
--		WHERE ChkInStatus!='0' AND BookingCode!=0
		
	 
----UPDATING FIRST TEMP TABLE
 		
--		UPDATE #TEMPFINAL SET Status='Booked' where Status='Direct Booked'
--		--UPDATE #TEMPFINAL SET Status='Booked' where Status='Front Booking'
--		UPDATE #TEMPFINAL SET Status='Cancelled' WHERE CancelStatus!=''	
--		UPDATE #TEMPFINAL SET Status='CheckIn' WHERE ChkInStatus='CheckIn'	
--		UPDATE #TEMPFINAL SET Status='CheckOut' WHERE ChkInStatus='CheckOut'
--		--SELECT BookingCode,Guests,ClientName Client,PropertyName Property,BookingDate,Status FROM #TEMP1
		
		--SELECT DISTINCT BookingCode,OccupancyLevel,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
		--CheckOutDate,Status,PaymentMode,Tariff as TotalTariff,Days FROM #TEMP1
		--GROUP BY BookingCode,OccupancyLevel,Guests,ClientName ,PropertyName ,Category,
		--BookingDate,CheckInDate,
		--CheckOutDate,Status,PaymentMode,Tariff ,Days
		--ORDER BY BookingCode desc
	END
END