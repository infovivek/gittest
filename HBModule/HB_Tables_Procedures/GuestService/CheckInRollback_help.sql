SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CheckInRollback_help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInRollback_help]
GO
-- ===============================================================================
-- Author: Shameem
-- Create date:10-02-2015
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Check In
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_CheckInRollback_help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,@BookingId INT=NULL,
@GuestId INT=NULL,
@PropertyId BIGINT=NULL,@CheckInHdrId INT=NULL,@UserId Bigint =null)

AS
BEGIN
	DECLARE @VChNoPif NVARCHAR(100), @VchCode NVARCHAR(100),@LenChar INT;
	DECLARE @VChNoPif1 NVARCHAR(100), @VchCode1 NVARCHAR(100),@LenChar1 INT;
	DECLARE @Cnt INT;
	
If @Action ='PageLoad'
	BEGIN
	
	
		CREATE TABLE #BOOK(BookingCode NVARCHAR(100),GuestName NVARCHAR(100),
		ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
		BookingId BIGINT,PropertyId BIGINT,GuestId BIGINT,CheckInHdrId BIGINT,RoomId BIGINT,
		ApartmentId BIGINT,BedId BIGINT)
	
-- 'Internal,External,CPP,Ddp,MGH,MMT Property'	(Room)	
		INSERT INTO #BOOK(BookingCode,GuestName,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),h.BookingId,
		h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		join WRBHBProperty P ON P.Id = d.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		 PU.UserId=@UserId  and 
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 )
		group by h.BookingCode,h.ChkInGuest,h.Property,h.RoomNo,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt
		
-- INT,EXP,MGH,CPP,MMT (BED)		
		INSERT INTO #BOOK(BookingCode,GuestName,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),h.BookingId,
		h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBedBookingPropertyAssingedGuest d on --h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		join WRBHBProperty P ON P.Id = d.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		 PU.UserId=@UserId  and 
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 )
		group by h.BookingCode,h.ChkInGuest,h.Property,h.RoomNo,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt
		
-- INT,EXP,MGH,CPP,MMT (Apartment)		
		INSERT INTO #BOOK(BookingCode,GuestName,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),h.BookingId,
		h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBApartmentBookingPropertyAssingedGuest d on --h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		join WRBHBProperty P ON P.Id = d.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		 PU.UserId=@UserId  and 
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 )
		group by h.BookingCode,h.ChkInGuest,h.Property,h.RoomNo,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt
		
		
		
		DECLARE @Roles NVARCHAR(100);
		SET @Roles=(SELECT  TOP 1 Roles FROM WRBHBUserRoles  
		WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND Roles IN('Other Roles'));
		
		
		
		IF(@Roles = 'Admin')
		BEGIN
			SELECT BookingCode,GuestName,ChkInDate,ChkOutDate,
			BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId FROM #BOOK
			GROUP BY BookingCode,GuestName,ChkInDate,ChkOutDate,
			BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId
		END
		ELSE
		BEGIN
			SELECT BookingCode,GuestName,ChkInDate,ChkOutDate,
			BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId FROM #BOOK
			GROUP BY BookingCode,GuestName,ChkInDate,ChkOutDate,
			BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId
		END
		
		
	
		
	
	END
	
If @Action ='GuestLoad'
	BEGIN	
		CREATE TABLE #BOOK1(BookingCode NVARCHAR(100),GuestName NVARCHAR(100),Property NVARCHAR(100),
		TYPE NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
		BookingId BIGINT,PropertyId BIGINT,GuestId BIGINT,CheckInHdrId BIGINT,RoomId BIGINT,
		ApartmentId BIGINT,BedId BIGINT)
	
-- INT,EXP,MGH,CPP,MMT (Room)		
		INSERT INTO #BOOK1(BookingCode,GuestName,Property,TYPE,BookingLevel,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,h.Property,h.RoomNo,h.Type,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),
			h.BookingId,h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		h.Id = @CheckInHdrId and  
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1)
		group by h.BookingCode,h.ChkInGuest,h.Property,h.RoomNo,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt
		
-- INT,EXP,MGH,CPP,MMT (BED)		
		INSERT INTO #BOOK1(BookingCode,GuestName,Property,TYPE,BookingLevel,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,h.Property,h.BedType,h.Type,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),
		h.BookingId,h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBedBookingPropertyAssingedGuest d on -- h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		h.Id = @CheckInHdrId and  
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1)
		group by h.BookingCode,h.ChkInGuest,h.Property,h.BedType,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt
		
-- INT,EXP,MGH,CPP,MMT (Apartment)		
		INSERT INTO #BOOK1(BookingCode,GuestName,Property,TYPE,BookingLevel,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId)
		
		SELECT  h.BookingCode,h.ChkInGuest,h.Property,h.ApartmentType,h.Type,
		CONVERT(NVARCHAR(100),h.ArrivalDate,103),CONVERT(NVARCHAR(100),h.ChkoutDate,103),
			h.BookingId,h.PropertyId,h.GuestId,h.Id AS CheckInHdrId,
		h.RoomId,h.ApartmentId,h.BedId--,d.ChkInDt,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBApartmentBookingPropertyAssingedGuest d on-- h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType IN ('Internal Property','Managed G H','External Property','MMT','CPP','DdP') and  
		h.Id = @CheckInHdrId and  
		--isnull(d.RoomShiftingFlag,0)=0 and
		d.CurrentStatus = 'CheckIn' and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1)
		group by h.BookingCode,h.ChkInGuest,h.Property,h.ApartmentType,h.Type,
		h.ArrivalDate,h.ChkoutDate,	h.BookingId,h.PropertyId,h.GuestId,h.Id ,
		h.RoomId,h.ApartmentId,h.BedId,d.ChkInDt,d.ChkOutDt		
		
		SELECT BookingCode,GuestName,Property,TYPE,BookingLevel,ChkInDate,ChkOutDate,
		BookingId,PropertyId,GuestId,CheckInHdrId,RoomId,ApartmentId,BedId FROM #BOOK1
	END
	
END	