 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchBooking_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchBooking_Search
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
CREATE PROCEDURE Sp_SearchBooking_Search
(
@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@Str2		NVARCHAR(100),
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		INT,
@Id			INT
)
AS
BEGIN								--drop table #TEMP1 drop table #TEMP2 drop table #TEMPFINAL
		CREATE TABLE #TEMP1(BookingCode BIGINT,Guests NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100))
				
		CREATE TABLE #TEMP2(BookingCode BIGINT,Guests NVARCHAR(1024),ClientName NVARCHAR(100),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100),BookingLevel NVARCHAR(100))
	
		CREATE TABLE #TEMPFINAL(BookingCode BIGINT,Guests NVARCHAR(4000),ClientName NVARCHAR(100),ClientId BIGINT,
		PropertyName NVARCHAR(100),Category NVARCHAR(100),PropertyId BIGINT,BookingDate NVARCHAR(100),
		CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Status NVARCHAR(100),CancelStatus NVARCHAR(100),
		ChkInStatus NVARCHAR(100),BookingLevel NVARCHAR(100))
				
		
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId 
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
--Room Level CPP		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		
--Bed Level	CPP		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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

--Appartment Level CPP		
		INSERT INTO #TEMP1(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
		
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,
		CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBApartmentBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode		
--CPP INSERT
--ROOM LEVEL CPP		
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode
		
--BED LEVEL CPP		
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
		JOIN WRBHBBedBookingProperty BP ON B.Id=BP.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest PAG ON B.Id = PAG.BookingId 
		JOIN WRBHBProperty P ON PAG.BookingPropertyId=P.Id
		LEFT OUTER JOIN WRBHBCheckInHdr CIH ON B.Id = CIH.BookingId
		WHERE B.BookingCode IN(SELECT BookingCode FROM #TEMP1
		GROUP BY BookingCode HAVING COUNT(*) >=2) AND CONVERT(DATETIME,PAG.CreatedDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
		CONVERT(DATETIME,GETDATE(),103) AND P.Id IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0) ORDER BY BookingCode

--APARTMENT LEVEL CPP		
		INSERT INTO #TEMP2(BookingCode,Guests,ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,
		CheckOutDate,Status,CancelStatus,ChkInStatus)
			
		SELECT DISTINCT B.BookingCode,(BGD.FirstName+ ' '+ BGD.LastName) AS Guests,B.ClientName Client,B.ClientId,
		P.PropertyName Property,'CPP',BP.PropertyId,CONVERT(NVARCHAR(100),PAG.CreatedDate,103) AS BookingDate,
		CONVERT(NVARCHAR(100),PAG.ChkInDt,103) AS CheckInDate,CONVERT(NVARCHAR(100),PAG.ChkOutDt,103) AS CheckOutDate,
		PAG.CurrentStatus Status,B.CancelStatus,CIH.CheckStatus
		FROM WRBHBBooking B
		JOIN WRBHBBookingGuestDetails BGD ON B.Id=BGD.BookingId
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
		
		SELECT DISTINCT BookingCode,(SELECT Substring((SELECT ', ' + CAST(T1.Guests AS VARCHAR(1024)) FROM #TEMP1 T1
		WHERE T1.BookingCode=T2.BookingCode AND T1.ClientName=T2.ClientName AND 
		T1.PropertyName NOT IN(UPPER('Ddp'),UPPER('MGH')) FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName,  
		ClientName,ClientId,PropertyName,Category,PropertyId,BookingDate,CheckInDate,CheckOutDate,Status,CancelStatus,
		ChkInStatus FROM #TEMP2 T2 WHERE Status!='0' 
		
		
--UPDATING FIRST TEMP TABLE
 		
		UPDATE #TEMPFINAL SET Status='Booked' where Status='Direct Booked'
		UPDATE #TEMPFINAL SET Status='Cancelled' WHERE CancelStatus!=''	
		UPDATE #TEMPFINAL SET Status='CheckIn' WHERE ChkInStatus='CheckIn' AND Status!='CheckOut'	
		--SELECT BookingCode,Guests,ClientName Client,PropertyName Property,BookingDate,Status FROM #TEMP1
	
	
	IF @Action='Booking'
	BEGIN
--NON IS GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate='' AND @ToDate='' 
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,CheckOutDate,
			Status FROM #TEMPFINAL ORDER BY BookingCode desc
		END	
--ONLY PROPERTY IS GIVEN		
		IF @Str1='' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,CheckOutDate,
			Status FROM #TEMPFINAL
			WHERE PropertyId=@Id ORDER BY BookingCode desc
		END	
			
--ONLY STATUS IS GIVEN
		IF @Str1!='All Status' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE Status=@Str1
					ORDER BY BookingCode desc
				END	
		IF @Str1='All Status' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL 
					ORDER BY BookingCode desc
				END	

--ONLY CATEGORY IS GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2!='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE Category=@Str2
					ORDER BY BookingCode desc
				END	

--ONLY DATE ARE GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode DESC
				END	

--TWO DATA
--ONLY PROPERTY AND STATUS ARE GIVEN			
		IF @Str1!='' AND @Id!=0 AND @FromDate='' AND @ToDate=''
		BEGIN
			IF @Str1='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND PropertyId=@Id ORDER BY BookingCode desc
			    END
		END	


--ONLY PROPERTY AND CATEGORY ARE GIVEN
		IF @Str1='' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE PropertyId=@Id AND Category=@Str2 ORDER BY BookingCode desc
		END


--ONLY PROPERTY AND DATE ARE GIVEN
		IF @Str1='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
			CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
		END

--ONLY CATEGORY AND STATUS ARE GIVEN
		IF @Str1!='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
		BEGIN
			IF @Str1='All Status' AND @Id=0 AND @FromDate='' AND @ToDate=''  AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id=0 AND @FromDate='' AND @ToDate=''  AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND Category=@Str2 ORDER BY BookingCode desc
			    END
		END	
		
--ONLY CATEGORY AND DATE ARE GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE Category=@Str2 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
			CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
		END
		
--ONLY STATUS AND DATE ARE GIVEN
		IF @Str1!='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
		BEGIN
			IF @Str1='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!=''  AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!=''  AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			    END
		END	
		
--THREE DATA ARE GIVEN
--PROPERTY,CATEGORY AND STATUS ARE GIVEN		
		IF @Str1!='' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND PropertyId=@Id ORDER BY BookingCode desc
				END
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND Category=@Str2 AND PropertyId=@Id ORDER BY BookingCode desc
				END	
			END
			
--PROPERTY,CATEGORY AND DATE ARE GIVEN				
		IF @Str1='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status FROM #TEMPFINAL
				WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) AND Category=@Str2 ORDER BY BookingCode desc
			END
--PROPERTY,STATUS AND DATE		
		IF @Str1!='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
			END
--CATEGORY,STATUS AND DATE ARE GIVEN
			IF @Str1!='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND 
					CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) AND
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
				IF @Str1!='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND Status=@Str1 AND CONVERT(DATETIME,BookingDate,103) BETWEEN 
					CONVERT(DATETIME,@FromDate,103) and CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
			END
--ALL DATA ARE GIVEN
--PROPERTY,STATUS,DATE AND CATEGORY ARE GIVEN	
		IF @Str1!='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Category=@Str2 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Status=@Str1 AND Category=@Str2 AND CONVERT(DATETIME,BookingDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
			END

--NOTHING IS GIVEN			
		IF @Str1='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2=''
			BEGIN
				SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
				CheckInDate,CheckOutDate,Status FROM #TEMPFINAL
				WHERE  CONVERT(DATETIME,BookingDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
				CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode desc	
			END	
	END
		
		
	
	
	
	
	
	
		
		
---ChickIn Date wise search
		
	IF @Action='CheckIn'
	BEGIN
--ONLY PROPERTY IS GIVEN		
		IF @Str1='' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,CheckOutDate,
			Status FROM #TEMPFINAL
			WHERE PropertyId=@Id ORDER BY BookingCode desc
		END	
			
--ONLY STATUS IS GIVEN
		IF @Str1!='All Status' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE Status=@Str1
					ORDER BY BookingCode desc
				END	
		IF @Str1='All Status' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					ORDER BY BookingCode desc
				END	

--ONLY CATEGORY IS GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2!='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE Category=@Str2
					ORDER BY BookingCode desc
				END	

--ONLY DATE ARE GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL WHERE CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode DESC
				END	

--TWO DATA
--ONLY PROPERTY AND STATUS ARE GIVEN			
		IF @Str1!='' AND @Id!=0 AND @FromDate='' AND @ToDate=''
		BEGIN
			IF @Str1='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' 
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND PropertyId=@Id ORDER BY BookingCode desc
			    END
		END	


--ONLY PROPERTY AND CATEGORY ARE GIVEN
		IF @Str1='' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE PropertyId=@Id AND Category=@Str2 ORDER BY BookingCode desc
		END


--ONLY PROPERTY AND DATE ARE GIVEN
		IF @Str1='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE PropertyId=@Id AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
			CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
		END

--ONLY CATEGORY AND STATUS ARE GIVEN
		IF @Str1!='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
		BEGIN
			IF @Str1='All Status' AND @Id=0 AND @FromDate='' AND @ToDate=''  AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id=0 AND @FromDate='' AND @ToDate=''  AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND Category=@Str2 ORDER BY BookingCode desc
			    END
		END	
		
--ONLY CATEGORY AND DATE ARE GIVEN
		IF @Str1='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
		BEGIN
			SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
			CheckOutDate,Status FROM #TEMPFINAL
			WHERE Category=@Str2 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
			CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
		END
		
--ONLY STATUS AND DATE ARE GIVEN
		IF @Str1!='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
		BEGIN
			IF @Str1='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!=''  AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE CONVERT(DATETIME,CheckInDate,103) between CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
			IF @Str1!='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!=''  AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
			    END
		END	
		
--THREE DATA ARE GIVEN
--PROPERTY,CATEGORY AND STATUS ARE GIVEN		
		IF @Str1!='' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND PropertyId=@Id ORDER BY BookingCode desc
				END
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate='' AND @ToDate='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Status=@Str1 AND Category=@Str2 AND PropertyId=@Id ORDER BY BookingCode desc
				END	
			END
			
--PROPERTY,CATEGORY AND DATE ARE GIVEN				
		IF @Str1='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
				CheckOutDate,Status FROM #TEMPFINAL
				WHERE PropertyId=@Id AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
				CONVERT(DATETIME,@ToDate,103) AND Category=@Str2 ORDER BY BookingCode desc
			END
--PROPERTY,STATUS AND DATE		
		IF @Str1!='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Status=@Str1 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
			END
--CATEGORY,STATUS AND DATE ARE GIVEN
			IF @Str1!='' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND 
					CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) AND
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
				IF @Str1!='All Status' AND @Id=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE Category=@Str2 AND Status=@Str1 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN 
					CONVERT(DATETIME,@FromDate,103) and CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END
			END
			
--ALL DATA ARE GIVEN
--PROPERTY,STATUS,DATE AND CATEGORY ARE GIVEN	
		IF @Str1!='' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
			BEGIN
				IF @Str1='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Category=@Str2 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
				IF @Str1!='All Status' AND @Id!=0 AND @FromDate!='' AND @ToDate!='' AND @Str2!=''
				BEGIN
					SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,CheckInDate,
					CheckOutDate,Status FROM #TEMPFINAL
					WHERE PropertyId=@Id AND Status=@Str1 AND Category=@Str2 AND CONVERT(DATETIME,CheckInDate,103) BETWEEN CONVERT(DATETIME,@FromDate,103) and
					CONVERT(DATETIME,@ToDate,103) ORDER BY BookingCode desc
				END	
			END

--NOTHING IS GIVEN			
		IF @Str1='' AND @Id=0 AND @FromDate='' AND @ToDate='' AND @Str2=''
			BEGIN
				SELECT DISTINCT BookingCode,Guests,ClientName Client,PropertyName Property,Category,BookingDate,
				CheckInDate,CheckOutDate,Status FROM #TEMPFINAL
				WHERE  CONVERT(DATETIME,CheckInDate,103) between CONVERT(DATETIME,GETDATE()-30,103) and
				CONVERT(DATETIME,GETDATE(),103) ORDER BY BookingCode desc	
			END	
	END
	END


--select DISTINCT * from #TEMPFINAL
--WHERE BookingCode IN(SELECT BookingCode FROM #TEMP1
--    GROUP BY BookingCode HAVING COUNT(*) >=2) 