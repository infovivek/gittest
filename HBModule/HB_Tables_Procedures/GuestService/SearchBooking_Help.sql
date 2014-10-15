 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchBooking_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchBooking_Help
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
CREATE PROCEDURE Sp_SearchBooking_Help
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
		CREATE TABLE #TEMP1(BookingCode BIGINT,Guests NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100))
				
		CREATE TABLE #TEMP2(BookingCode BIGINT,Guests NVARCHAR(1024),ClientName NVARCHAR(100),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100))
	
		CREATE TABLE #TEMPFINAL(BookingCode BIGINT,Guests NVARCHAR(4000),ClientName NVARCHAR(4000),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100))
				
		SELECT DISTINCT (P.PropertyName+ '-'+C.CityName) Property,PropertyId as zId FROM WRBHBBookingProperty BP
		JOIN WRBHBProperty P ON P.Id=BP.PropertyId 
		JOIN WRBHBCity C ON C.Id=P.CityId
		WHERE BP.IsActive=1 AND BP.IsDeleted=0 
		
		--SELECT DISTINCT Category label FROM WRBHBProperty
		
--FIRST TEMP TABLE INSERT		
--Room Level
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus
		ORDER BY BookingCode

--Bed Level		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus
		ORDER BY BookingCode
		
--Appartment Level		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus
		ORDER BY BookingCode
--CPP Insert
--Room Level		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus ORDER BY BookingCode
		
--Bed Level			
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus ORDER BY BookingCode	

--Appartment Level		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode!=0 AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		GROUP BY B.BookingCode,B.ClientName,B.ClientId,
		P.PropertyName,P.Category,BP.PropertyId,BGD.FirstName,BGD.LastName,PAG.CreatedDate,
		PAG.ChkInDt,PAG.ChkOutDt,PAG.CurrentStatus,B.CancelStatus,CIH.CheckStatus ORDER BY BookingCode	
		
		
--SECOND TEMP TABLE INSERT	
--Room Level (UNIQUE BOOKING CODE)	
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
		
--Bed Level	 (UNIQUE BOOKING CODE)	
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode

--Appartment Level  (UNIQUE BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
		
--CPP Insert	
--Room Level CPP  (UNIQUE BOOKING CODE)	
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
		
--Bed Level CPP  (UNIQUE BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode	
		
--Appartment Level CPP  (UNIQUE BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1   
		GROUP BY BookingCode HAVING COUNT(*) =1) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode	
					
--SECOND INSERT FOR TEMP TABLE 
--ROOM LEVEL (REPEATED BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
	
--BED LEVEL (REPEATED BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode	
	
--APPARTMENT LEVEL (REPEATED BOOKING CODE)
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,P.Category,BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode		
--CPP INSERT
--ROOM LEVEL CPP (REPEATED BOOKING CODE)	
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
		
--BED LEVEL CPP	(REPEATED BOOKING CODE)	
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode

--APARTMENT LEVEL CPP (REPEATED BOOKING CODE)		
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId AND BGD.IsActive=1 AND BGD.IsDeleted=0
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode	
		
--INSERT FOR TEMPFINAL TABLE

		INSERT INTO #TEMPFINAL(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT BookingCode,(SELECT Substring((SELECT ', ' + CAST(T1.Guests AS VARCHAR(1024)) FROM #TEMP1 T1
		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName,  
		ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,
		ChkInStatus FROM #TEMP2 T2 WHERE Status!='0' 
		
		
--UPDATING FIRST TEMP TABLE
 		
		UPDATE #TEMPFINAL SET Status='Booked' where Status='Direct Booked'
		UPDATE #TEMPFINAL SET Status='Cancelled' WHERE CancelStatus!=''	
		UPDATE #TEMPFINAL SET Status='CheckIn' WHERE ChkInStatus='CheckIn' AND Status!='CheckOut'	
		--SELECT BookingCode,Guests,ClientName Client,PropertyName Property,BookingDate,Status FROM #TEMP1
		
		SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
		CheckOutDate,Status FROM #TEMPFINAL
		ORDER BY BookingCode desc
	END
END

