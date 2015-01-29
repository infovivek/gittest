-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_KOT_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_KOT_Help]
GO 
-- ===============================================================================
-- Author: Shameem
-- Create date:11-05-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	KOT 
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_KOT_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,@Str2 NVARCHAR(100)=NULL,
@Id1 BIGINT=NULL,@Id2 BIGINT=NULL)

AS
BEGIN
If @Action ='PageLoad'
BEGIN
	SELECT DISTINCT P.PropertyName Property,P.Id AS PropertyId	
	FROM WRBHBPropertyUsers  PU 
    JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	WHERE PU.UserId=@Id2 AND P.Category IN('Internal Property','Managed G H') AND
	PU.IsActive=1 AND PU.IsDeleted=0 AND PU.UserType IN('Resident Managers' ,'Assistant Resident Managers')
	
	SELECT CONVERT(varchar(103),GETDATE(),103) as Date
	
END
If @Action ='Date'
BEGIN
	DECLARE @PropertyId Int
	SET @PropertyId=(SELECT DISTINCT PropertyId FROM WRBHBKOTHdr 
	WHERE IsActive = 1 AND IsDeleted = 0 AND PropertyId=@Id2)
	
	CREATE TABLE #Room(GuestName NVARCHAR(100),BookingCode INT,Property NVARCHAR(100),RoomType NVARCHAR(100),BookingId INT,
	Id INT,PropertyId INT,BreakfastVeg INT,BreakfastNonVeg INT,LunchVeg INT,LunchNonVeg INT,DinnerVeg INT,DinnerNonVeg INT,
	CheckInId INT)
IF(@PropertyId !=0)
BEGIN
  IF(@Str2=CONVERT(NVARCHAR(100),GETDATE(),103))
  BEGIN
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.RoomNo,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBookingPropertyAssingedGuest D ON H.Id = D.CheckInHdrId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H') 
	
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.BedType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBedBookingPropertyAssingedGuest D ON H.GuestId=D.GuestId AND H.BookingId=D.BookingId AND
		H.BedId = D.BedId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND  
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H')  
		
			
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.ApartmentType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBApartmentBookingPropertyAssingedGuest D ON  H.GuestId=D.GuestId AND H.BookingId=D.BookingId 
		AND H.ApartmentId = D.ApartmentId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H') 
		
		SELECT GuestName,BookingCode,Property,RoomType AS RoomNo,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId FROM #Room 
		
		SELECT DISTINCT (H.FirstName+''+H.LastName) AS UserName,H.Id AS UserId,
		0 AS Id,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg
		FROM WRBHBUser H
		JOIN WRBHBPropertyUsers PU ON H.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBProperty P ON PU.PropertyId = P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0
		
	END
	IF(ISNULL(@Str2,0)=(SELECT DISTINCT CONVERT(NVARCHAR,Date,103)FROM WRBHBKOTHdr WHERE PropertyId=@Id2 AND 
	CONVERT(NVARCHAR,Date,103)=@Str2 AND IsActive=1 AND IsDeleted=0))
	BEGIN
		SELECT KOTEntryHdrId,D.PropertyId,D.BookingId,BookingCode,GuestName,RoomNo,
		BreakfastVeg,BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,D.Id,D.CheckInId
		FROM WRBHBKOTDtls D
		JOIN WRBHBKOTHdr H ON D.KOTEntryHdrId=H.Id AND H.IsActive=1 AND H.IsDeleted=0
		JOIN WRBHBBookingPropertyAssingedGuest P ON D.CheckInId = P.CheckInHdrId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE D.IsActive = 1 AND D.IsDeleted = 0 AND H.PropertyId = @PropertyId AND
		CONVERT(NVARCHAR,H.Date,103)=@Str2 AND P.CurrentStatus='CheckIn' AND P.RoomShiftingFlag=0
		--USER
		SELECT KOTEntryHdrId,U.UserName,U.UserId,BreakfastVeg,BreakfastNonVeg,LunchVeg,
		LunchNonVeg,DinnerVeg,DinnerNonVeg,U.Id
		FROM WRBHBKOTUser U
		JOIN WRBHBKOTHdr H ON U.KOTEntryHdrId=H.Id AND H.IsActive=1 AND H.IsDeleted=0
		WHERE U.IsActive = 1 and U.IsDeleted = 0 and H.PropertyId = @PropertyId AND
		CONVERT(NVARCHAR,H.Date,103)=@Str2;
	END
	ELSE
	BEGIN
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.RoomNo,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBookingPropertyAssingedGuest D ON H.Id = D.CheckInHdrId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H') 
	
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.BedType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBedBookingPropertyAssingedGuest D ON H.GuestId=D.GuestId AND H.BookingId=D.BookingId AND
		H.BedId = D.BedId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND  
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H')  
		
			
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.ApartmentType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBApartmentBookingPropertyAssingedGuest D ON  H.GuestId=D.GuestId AND H.BookingId=D.BookingId 
		AND D.ApartmentId = D.ApartmentId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H')
				
		SELECT GuestName,BookingCode,Property,RoomType AS RoomNo,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId FROM #Room 
		
		SELECT DISTINCT (H.FirstName+''+H.LastName) AS UserName,H.Id AS UserId,
		0 AS Id,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg
		FROM WRBHBUser H
		JOIN WRBHBPropertyUsers PU ON H.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBProperty P ON PU.PropertyId = P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0
END
END
ELSE
BEGIN
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.RoomNo,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBookingPropertyAssingedGuest D ON H.Id = D.CheckInHdrId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H') 
	
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.BedType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBBedBookingPropertyAssingedGuest D ON H.GuestId=D.GuestId AND H.BookingId=D.BookingId AND
		H.BedId = D.BedId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND  
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H')  
		
			
		INSERT INTO #Room(GuestName,BookingCode,Property,RoomType,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,CheckInId)
		
		SELECT DISTINCT H.ChkInGuest,H.BookingCode AS BookingCode,H.Property,H.ApartmentType,ISNULL(H.BookingId,0) as BookingId,
		0 AS Id,ISNULL(H.PropertyId,0) as PropertyId,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg,H.Id
		FROM WRBHBCheckInHdr H
		JOIN WRBHBProperty P ON P.Id = H.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBApartmentBookingPropertyAssingedGuest D ON  H.GuestId=D.GuestId AND H.BookingId=D.BookingId 
		AND D.ApartmentId = D.ApartmentId AND D.IsActive=1 AND D.IsDeleted=0
		WHERE H.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0 AND 
		CONVERT(date,GETDATE(),103) BETWEEN D.ChkInDt AND D.ChkOutDt AND
		D.CurrentStatus='CheckIn' AND P.Category IN('Internal Property','Managed G H') 
		
		
		SELECT GuestName,BookingCode,Property,RoomType AS RoomNo,BookingId,Id,PropertyId,BreakfastVeg,
		BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg FROM #Room  
		
		SELECT DISTINCT (H.FirstName+''+H.LastName) AS UserName,H.Id AS UserId,
		0 AS Id,0 AS BreakfastVeg,
		0 AS BreakfastNonVeg,0 AS LunchVeg,0 AS LunchNonVeg,0 AS DinnerVeg,0 AS DinnerNonVeg
		FROM WRBHBUser H
		JOIN WRBHBPropertyUsers PU ON H.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBProperty P ON PU.PropertyId = P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.PropertyId = @Id2 AND H.IsActive=1 AND H.IsDeleted=0
	END

END
END






