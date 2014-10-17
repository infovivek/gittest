
GO
/****** Object:  StoredProcedure [dbo].[Sp_CheckIn_Help]    Script Date: 10/09/2014 09:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================
-- Author: Shameem
-- Create date:25-04-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Check In
-- =================================================================================
ALTER PROCEDURE [dbo].[Sp_CheckIn_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,@BookingId INT=NULL,
@ClientId INT=NULL,@RoomId INT=NULL,@GuestId INT=NULL,
@PropertyId INT=NULL,@SSPId BIGINT=NULL,@UserId Bigint =null)

AS
BEGIN
	DECLARE @VChNoPif NVARCHAR(100), @VchCode NVARCHAR(100),@LenChar INT;
	DECLARE @VChNoPif1 NVARCHAR(100), @VchCode1 NVARCHAR(100),@LenChar1 INT;
	DECLARE @Cnt INT;
/*
IF @Action='PropertyLoad'
BEGIN

SELECT PropertyName,Id from WRBHBProperty 
WHERE IsDeleted = 0 and IsActive = 1 and Category = 'External Property' and PropertyName = @Str1;
END*/

If @Action ='PageLoad'
		BEGIN
         -- Check In No
			SET @Cnt=(SELECT COUNT(*) FROM WrbHbCheckInHdr) ;
			IF @Cnt=0 BEGIN SELECT 1 AS CheckInNo;END
			ELSE BEGIN
			SELECT TOP 1 CAST(CheckInNo AS INT)+1 AS CheckInNo FROM WrbHbCheckInHdr
			 ORDER BY Id DESC;
		END 
--- Room level and apartment level Property Load

		CREATE TABLE #Prop(PropertyId INT,PropertyName NVARCHAR(100))
		
IF @SSPId =0
	BEGIN
	    -- Room Level Property booked and direct booked
-- External Property
	    INSERT INTO #Prop(PropertyId,PropertyName)
	    
		select distinct P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.IsActive=1 and H.IsDeleted =0 and 
		H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and P.Category in ('External Property') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103))
		
		and PU.UserId=@UserId 
-- Internal Property	
		INSERT INTO #Prop(PropertyId,PropertyName)
		select distinct P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.IsActive=1 and H.IsDeleted =0 and 
		H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and P.Category in ('Internal Property','Managed G H','Client Prefered') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103))
		
		and PU.UserId=@UserId 
		
		
-- Apartment Level Booked  and Direct Property

		 INSERT INTO #Prop(PropertyId,PropertyName)
		 select distinct P.Id As PropertyId,
		 (P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		 -- ,PU.UserId,P.Category
		 FROM WRBHBBooking H
		 join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		 join WRBHBApartmentBookingProperty ABP on D.BookingId = ABP.BookingId AND ABP.IsActive = 1 AND
		 ABP.IsDeleted = 0
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on ABPA.BookingId = ABP.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABP.PropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		 join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		 WHERE  H.IsActive=1 and H.IsDeleted =0 and 
		 H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled' 
		 and P.Category in ('Internal Property') 
		--and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and PU.UserId=@UserId
		 
-- Bed Level Booked and DirectBooked Property

		 INSERT INTO #Prop(PropertyId,PropertyName)
		 select distinct P.Id As PropertyId,
		 (P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		 --,P.Category
		 FROM WRBHBBooking H
		 join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		 join WRBHBBedBookingProperty ABP on D.BookingId = ABP.BookingId AND ABP.IsActive = 1 AND
		 ABP.IsDeleted = 0
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on ABPA.BookingId = ABP.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABP.PropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		 join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		 WHERE H.IsActive=1 and H.IsDeleted =0 and
		  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'
		 and P.Category in ('Internal Property') 
		 --and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
 	 and PU.UserId=@UserId
		 
END
	ELSE
	BEGIN
-- External Property
		INSERT INTO #Prop(PropertyId,PropertyName)
		select distinct P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE H.IsActive=1 and H.IsDeleted =0 and
		 H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'
		and P.Category in ('External Property') 
		--and  CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		
		and PU.UserId=@UserId
	
-- Internal Property	
	  -- Room Level Property booked and direct booked
	  
	    INSERT INTO #Prop(PropertyId,PropertyName)
		select distinct P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE H.IsActive=1 and H.IsDeleted =0 and
		 H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'
		and P.Category in ('Internal Property','External Property','Managed G H','Client Prefered') 
		--and  CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		
		and PU.UserId=@UserId
		
		
-- Apartment Level Booked  and Direct Property

		 INSERT INTO #Prop(PropertyId,PropertyName)
		 select distinct P.Id As PropertyId,
		 (P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		  --,P.Category
		 FROM WRBHBBooking H
		 join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		 join WRBHBApartmentBookingProperty ABP on D.BookingId = ABP.BookingId AND ABP.IsActive = 1 AND
		 ABP.IsDeleted = 0
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on ABPA.BookingId = ABP.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABP.PropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		 join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		 WHERE H.IsActive=1 and H.IsDeleted =0 and
		  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'
		 and P.Category in ('Internal Property') 
		 --and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and PU.UserId=@UserId
		 
		 -- Bed Level Booked and DirectBooked Property

		 INSERT INTO #Prop(PropertyId,PropertyName)
		 select distinct P.Id As PropertyId,
		 (P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		 --,P.Category
		 FROM WRBHBBooking H
		 join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		 join WRBHBBedBookingProperty ABP on D.BookingId = ABP.BookingId AND ABP.IsActive = 1 AND
		 ABP.IsDeleted = 0
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on ABPA.BookingId = ABP.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABP.PropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		 join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		 WHERE  H.IsActive=1 and H.IsDeleted =0 and
		 H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'
		 and P.Category in ('Internal Property') 
		--and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and PU.UserId=@UserId
		 
		 END		
			
		--	SELECT distinct PropertyId as ZId,PropertyName FROM #Prop
		CREATE TABLE #FinalProp(ZId INT,PropertyName NVARCHAR(100))
		INSERT INTO #FinalProp (ZId,PropertyName)	
		
		SELECT  PropertyId, PropertyName FROM #Prop GROUP BY PropertyId,PropertyName
		
		SELECT ZId,PropertyName FROM #FinalProp
		SELECT COUNT(*) AS PropertyCount,PropertyName,ZId  FROM #FinalProp  GROUP BY ZId,PropertyName
END
	
If @Action = 'GuestLoad'
	BEGIN
-- Table1 ( for Guest Name Load )
		CREATE TABLE #CheckIn1(Id INT,PropertyId INT,CheckInGuest NVARCHAR(100),GuestId NVARCHAR(100),RefGuestId Nvarchar(100),BookingId INT,RoomId INT,ApartmentId INT,BookingLevel NVARCHAR(100),BedId INT,
		RoomCaptureId INT,BookingAssGuestId int)
		CREATE TABLE #CheckIn2(Id INT,PropertyId INT,CheckInGuest NVARCHAR(100),GuestId NVARCHAR(100),RefGuestId Nvarchar(100),BookingId INT,RoomId INT,ApartmentId INT,BookingLevel NVARCHAR(100),BedId INT,
		RoomCaptureId INT,BookingAssGuestId int)
		CREATE TABLE #CheckIn3(Id INT,PropertyId INT,CheckInGuest NVARCHAR(100),GuestId NVARCHAR(100),RefGuestId Nvarchar(100),BookingId INT,RoomId INT,ApartmentId INT,BookingLevel NVARCHAR(100),BedId INT,
		RoomCaptureId INT,BookingAssGuestId int)
		CREATE TABLE #CheckInfinal(Id INT,PropertyId INT,CheckInGuest NVARCHAR(100),GuestId NVARCHAR(100),RefGuestId Nvarchar(100),BookingId INT,RoomId INT,ApartmentId INT,BookingLevel NVARCHAR(100),BedId INT,
		RoomCaptureId INT,BookingAssGuestId int,PId BIGINT PRIMARY KEY IDENTITY (1,1))
		CREATE TABLE #CheckInfinal2(Id INT,PropertyId INT,CheckInGuest NVARCHAR(100),GuestId NVARCHAR(100),RefGuestId Nvarchar(100),BookingId INT,RoomId INT,ApartmentId INT,BookingLevel NVARCHAR(100),BedId INT,
		RoomCaptureId INT,BookingAssGuestId int)
		
		DECLARE @NoData INT,@BookingId1 BIGINT,@RoomId1 BIGINT,@AparmentId BIGINT,@BedId BIGINT,
		@BookingLevel NVARCHAR(100),@PId BIGINT;
		DECLARE @Roles NVARCHAR(100); 
		SET @Roles=(SELECT top 1 'Operations Managers' FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND 
		Roles ='Operations Managers' and Roles = 'Resident Managers' and Roles ='Assistant Resident Managers')
		if(isnull(@Roles,'')='')
		begin
			SET @Roles=(SELECT  top 1 'Operations Managers'  FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND 
			Roles ='Operations Managers'  and Roles = 'Resident Managers' )
		end
		if(isnull(@Roles,'')='')
		begin
			SET @Roles=(SELECT  top 1 'Operations Managers' FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND 
			Roles in('Operations Managers'))
		end
	     if(isnull(@Roles,'')='')
		begin
		SET @Roles=(SELECT  'Resident Managers'  FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND 
		Roles in('Resident Managers','Assistant Resident Managers'))
		end
		--if(isnull(@Roles,'')='')
		--begin
		--SET @Roles=(SELECT  Roles FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND 
		--Roles in('Assistant Resident Managers'))
		--end 
		
	--	select isnull(@Roles,'')
	--	return;
		--SET @Roles=(SELECT top 1 Roles FROM WRBHBUserRoles  WHERE UserId = 65 AND IsActive = 1 AND IsDeleted = 0 AND Roles = 'Operations Managers' AND Roles = 'Resident Managers')  
		--SET @Roles=(SELECT Roles FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND Roles = 'Resident Managers')  
IF @Roles = 'Operations Managers' --OR @Roles = 'Resident Managers'
BEGIN
IF @SSPId =0
	BEGIN
-- To Check Booked and Direct Booked for Room Level
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('Internal Property','Managed G H') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		--and CONVERT(varchar(100),AG.ChkInDt,103) between CONVERT(varchar(100),AG.ChkInDt,103) and
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- To Check  Booked for Apartment Level 
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 --and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) between CONVERT(varchar(100),ABPA.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
-- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
-- to check Bed Level
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,ABPA.RoomId,
		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 --and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) between CONVERT(varchar(100),ABPA.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
		 -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- External Property to check single double 		
		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('External Property','Client Prefered') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and CONVERT(varchar(100),AG.ChkInDt,103) between CONVERT(varchar(100),AG.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn3
		
		
		SELECT @NoData=COUNT(*) FROM #CheckInfinal
		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
		@PId=PId
		FROM #CheckInfinal	
		
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
			FROM #CheckInfinal
			WHERE PId=@PId
			
			IF @BookingLevel='Room'
			BEGIN
				
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
			END 
			IF @BookingLevel='Bed'
			BEGIN
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
			END 
			IF @BookingLevel='Apartment'
			BEGIN
				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
			END 
			
			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
			@PId=PId
			FROM #CheckInfinal	
			
		END
		-- to send front end
		SELECT distinct S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
		FROM #CheckInfinal2 S
		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
END
ELSE
 	BEGIN
 	    -- To Check Booked and Direct Booked for Room Level
        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('Internal Property','Managed G H') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and CONVERT(varchar(100),AG.ChkInDt,103) between CONVERT(varchar(100),AG.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- To Check  Booked for Apartment Level 
        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 --and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) between CONVERT(varchar(100),ABPA.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
-- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
-- to check Bed Level
         INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 --and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 --CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) between CONVERT(varchar(100),ABPA.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
		 -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- External Property to check single double 		
		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('External Property','Client Prefered') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and CONVERT(varchar(100),AG.ChkInDt,103) between CONVERT(varchar(100),AG.ChkInDt,103) and
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) 
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn3
		
		
		
		SELECT @NoData=COUNT(*) FROM #CheckInfinal
		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
		@PId=PId
		FROM #CheckInfinal	
		
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
			FROM #CheckInfinal
			WHERE PId=@PId
			
			IF @BookingLevel='Room'
			BEGIN
				
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
			END 
			IF @BookingLevel='Bed'
			BEGIN
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
			END 
			IF @BookingLevel='Apartment'
			BEGIN
				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
			END 
			
			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
			@PId=PId
			FROM #CheckInfinal	
			
		END
		-- to send front end
		SELECT distinct S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
		FROM #CheckInfinal2 S
		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
		Select Id as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = (select Id from #CheckInfinal)
		
	END
END
ELSE
BEGIN
IF @SSPId =0
	BEGIN
-- To Check Booked and Direct Booked for Room Level
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('Internal Property','Managed G H') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
		and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- To Check  Booked for Apartment Level 
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
-- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
-- to check Bed Level
INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,ABPA.RoomId,
		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
		 -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- External Property to check single double 		
		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('External Property','Client Prefered') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn3
		
		
		SELECT @NoData=COUNT(*) FROM #CheckInfinal
		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
		@PId=PId
		FROM #CheckInfinal	
		
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
			FROM #CheckInfinal
			WHERE PId=@PId
			
			IF @BookingLevel='Room'
			BEGIN
				
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
			END 
			IF @BookingLevel='Bed'
			BEGIN
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
			END 
			IF @BookingLevel='Apartment'
			BEGIN
				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
			END 
			
			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
			@PId=PId
			FROM #CheckInfinal	
			
		END
		-- to send front end
		SELECT distinct S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
		FROM #CheckInfinal2 S
		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
END
ELSE
 	BEGIN
 	    -- To Check Booked and Direct Booked for Room Level
        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('Internal Property','Managed G H') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
		and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- To Check  Booked for Apartment Level 
        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
-- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
-- to check Bed Level
         INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
		 FROM WRBHBBooking H
		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
		 H.IsActive = 1 and H.IsDeleted = 0  
		 and P.Category in ('Internal Property') 
		 and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		 and ABPA.BookingPropertyId=@PropertyId and PU.UserId=@UserId
		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
		 -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
-- External Property to check single double 		
		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
		SELECT  distinct
		H.Id,AG.BookingPropertyId As PropertyId,
		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
		FROM WRBHBBooking H		
		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Direct Booked','Booked')  and 
		isnull(H.CancelStatus,0)!='Canceled'  
		and P.Category in ('External Property','Client Prefered') 
		and H.IsActive = 1 and H.IsDeleted = 0  
	
		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
		and AG.BookingPropertyId = @PropertyId and PU.UserId=@UserId
		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
	    -- Table2 ( to check single or double) 
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) =1)
		
		
		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn1
		where BookingId  IN (SELECT BookingId From #CheckIn1
		group by BookingId having COUNT(*) >=2)
		
		-- Table3(Concatinate 2 Guest Name)
	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select distinct t2.Id,t2.PropertyId,
		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
		from #CheckIn2 t2
		
		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
		from #CheckIn3
		
		
		
		SELECT @NoData=COUNT(*) FROM #CheckInfinal
		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
		@PId=PId
		FROM #CheckInfinal	
		
		WHILE (ISNULL(@NoData,0)!=0)  
		BEGIN
			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
			FROM #CheckInfinal
			WHERE PId=@PId
			
			IF @BookingLevel='Room'
			BEGIN
				
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
			END 
			IF @BookingLevel='Bed'
			BEGIN
				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
			END 
			IF @BookingLevel='Apartment'
			BEGIN
				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
			END 
			
			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
			@PId=PId
			FROM #CheckInfinal	
			
		END
		-- to send front end
		SELECT  distinct S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
		FROM #CheckInfinal2 S
		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
		Select Id as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = (select Id from #CheckInfinal)
		
	END
END	

--IF @SSPId =0
--	BEGIN
---- To Check Booked and Direct Booked for Room Level
--INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		SELECT  
--		H.Id,AG.BookingPropertyId As PropertyId,
--		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
--		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
--		FROM WRBHBBooking H		
--		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
--		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		WHERE  H.Status IN('Direct Booked','Booked')  and 
--		isnull(H.CancelStatus,0)!='Canceled'  
--		and P.Category in ('Internal Property','Managed G H') 
--		and H.IsActive = 1 and H.IsDeleted = 0  
--	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
--		and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		and AG.BookingPropertyId = @PropertyId
--		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
--	    -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
---- To Check  Booked for Apartment Level 
--INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
--		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
--		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
--		 FROM WRBHBBooking H
--		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
--		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
--		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
--		 H.IsActive = 1 and H.IsDeleted = 0  
--		 and P.Category in ('Internal Property') 
--		 and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		 and ABPA.BookingPropertyId=@PropertyId
--		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
---- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
---- to check Bed Level
--INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
--		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,ABPA.RoomId,
--		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
--		 FROM WRBHBBooking H
--		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
--		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
--		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
--		 H.IsActive = 1 and H.IsDeleted = 0  
--		 and P.Category in ('Internal Property') 
--		 and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		 and ABPA.BookingPropertyId=@PropertyId
--		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
--		 -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
---- External Property to check single double 		
--		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		SELECT  
--		H.Id,AG.BookingPropertyId As PropertyId,
--		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
--		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
--		FROM WRBHBBooking H		
--		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
--		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		WHERE  H.Status IN('Direct Booked','Booked')  and 
--		isnull(H.CancelStatus,0)!='Canceled'  
--		and P.Category in ('External Property','Client Prefered') 
--		and H.IsActive = 1 and H.IsDeleted = 0  
	
--		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		and AG.BookingPropertyId = @PropertyId
--		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
--	    -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
--		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn3
		
		
--		SELECT @NoData=COUNT(*) FROM #CheckInfinal
--		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
--		@PId=PId
--		FROM #CheckInfinal	
		
--		WHILE (ISNULL(@NoData,0)!=0)  
--		BEGIN
--			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--			FROM #CheckInfinal
--			WHERE PId=@PId
			
--			IF @BookingLevel='Room'
--			BEGIN
				
--				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
--			END 
--			IF @BookingLevel='Bed'
--			BEGIN
--				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
--			END 
--			IF @BookingLevel='Apartment'
--			BEGIN
--				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
--			END 
			
--			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
--			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
--			@PId=PId
--			FROM #CheckInfinal	
			
--		END
--		-- to send front end
--		SELECT  S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
--		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
--		FROM #CheckInfinal2 S
--		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
--END
--ELSE
-- 	BEGIN
-- 	    -- To Check Booked and Direct Booked for Room Level
--        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		SELECT  
--		H.Id,AG.BookingPropertyId As PropertyId,
--		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
--		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
--		FROM WRBHBBooking H		
--		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
--		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		WHERE  H.Status IN('Direct Booked','Booked')  and 
--		isnull(H.CancelStatus,0)!='Canceled'  
--		and P.Category in ('Internal Property','Managed G H') 
--		and H.IsActive = 1 and H.IsDeleted = 0  
--	--	select * from WRBHBBookingPropertyAssingedGuest where BookingId = 25
--		and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		and AG.BookingPropertyId = @PropertyId
--		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
--	    -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
---- To Check  Booked for Apartment Level 
--        INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
--		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
--		 ABPA.ApartmentId,H.BookingLevel,0 as BedId,0 as RoomCaptureId,ABPA.Id
--		 FROM WRBHBBooking H
--		 join WRBHBApartmentBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId AND
--		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
--		 join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
--		 H.IsActive = 1 and H.IsDeleted = 0  
--		 and P.Category in ('Internal Property') 
--		 and  CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		 and ABPA.BookingPropertyId=@PropertyId
--		 and ABPA.ApartmentId NOT IN (SELECT ApartmentId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId) 
		 
---- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
---- to check Bed Level
--         INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		 select distinct H.Id,ABPA.BookingPropertyId As PropertyId,
--		 (ABPA.FirstName+','+ABPA.LastName) as  ChkInGuest,ABPA.GuestId,ABPA.GuestId,ABPA.BookingId,0 as RoomId,
--		 0 AS ApartmentId,H.BookingLevel,ABPA.BedId as BedId,0 as RoomCaptureId,ABPA.Id
--		 FROM WRBHBBooking H
--		 join WRBHBBedBookingPropertyAssingedGuest ABPA on H.Id = ABPA.BookingId  AND
--		 ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
--		join WRBHBProperty P on P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		 WHERE  H.Status in( 'Booked','Direct Booked')  and isnull(H.CancelStatus,0)!='Canceled'  and
--		 H.IsActive = 1 and H.IsDeleted = 0  
--		 and P.Category in ('Internal Property') 
--		 and CONVERT(varchar(100),ABPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		 CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		 and ABPA.BookingPropertyId=@PropertyId
--		 and ABPA.BedId NOT IN (SELECT BedId From WrbHbCheckInHdr WHERE BookingId=ABPA.BookingId)  
		 
--		 -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId =t2.RoomId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
---- External Property to check single double 		
--		INSERT INTO #CheckIn1(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId) 
--		SELECT  
--		H.Id,AG.BookingPropertyId As PropertyId,
--		(AG.FirstName+' '+AG.LastName)as ChkInGuest,AG.GuestId,AG.GuestId,
--		AG.BookingId,AG.RoomId,0 as ApartmentId,H.BookingLevel,0 as BedId,AG.RoomCaptured,AG.Id--,AG.Occupancy
--		FROM WRBHBBooking H		
--		join WRBHBBookingPropertyAssingedGuest AG on H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
--		join WRBHBProperty P on P.Id = AG.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
--		WHERE  H.Status IN('Direct Booked','Booked')  and 
--		isnull(H.CancelStatus,0)!='Canceled'  
--		and P.Category in ('External Property','Client Prefered') 
--		and H.IsActive = 1 and H.IsDeleted = 0  
	
--		--and CONVERT(varchar(100),AG.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
--		--CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) )
--		and AG.BookingPropertyId = @PropertyId
--		AND AG.RoomId NOT IN (SELECT RoomId From WrbHbCheckInHdr WHERE BookingId=AG.BookingId) 
	     
--	    -- Table2 ( to check single or double) 
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) =1)
		
		
--		INSERT INTO #CheckIn2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn1
--		where BookingId  IN (SELECT BookingId From #CheckIn1
--		group by BookingId having COUNT(*) >=2)
		
--		-- Table3(Concatinate 2 Guest Name)
--	--	CREATE TABLE #CheckIn3(Id INT,PropertyId INT,ChkInGuest NVARCHAR(100),GuestId NVARCHAR(100),BookingId INT,RoomId INT)
--		INSERT INTO #CheckIn3(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select distinct t2.Id,t2.PropertyId,
--		(SELECT Substring((SELECT ', ' + CAST(t1.CheckInGuest AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS ChkInGuest,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS GuestId,
--        (SELECT Substring((SELECT ', ' + CAST(t1.GuestId AS VARCHAR(1024))
--        FROM   #CheckIn1 t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomCaptureId =t2.RoomCaptureId --and t1.GuestId =t2.GuestId
--        FOR XML PATH('')), 3, 10000000) AS list) AS RefGuestId,t2.BookingId,t2.RoomId,t2.ApartmentId,t2.BookingLevel,t2.BedId,t2.RoomCaptureId,t2.BookingAssGuestId--,t2.GuestId
--		from #CheckIn2 t2
		
--		INSERT INTO #CheckInfinal(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--		select Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--		from #CheckIn3
		
		
		
--		SELECT @NoData=COUNT(*) FROM #CheckInfinal
--		SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
--		@PId=PId
--		FROM #CheckInfinal	
		
--		WHILE (ISNULL(@NoData,0)!=0)  
--		BEGIN
--			INSERT INTO #CheckInfinal2(Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId)
--			SELECT Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,BookingLevel,BedId,RoomCaptureId,BookingAssGuestId
--			FROM #CheckInfinal
--			WHERE PId=@PId
			
--			IF @BookingLevel='Room'
--			BEGIN
				
--				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1				
--			END 
--			IF @BookingLevel='Bed'
--			BEGIN
--				DELETE FROM #CheckInfinal WHERE RoomId=@RoomId1 AND BookingId=@BookingId1
--			END 
--			IF @BookingLevel='Apartment'
--			BEGIN
--				DELETE FROM #CheckInfinal WHERE ApartmentId=@AparmentId AND BookingId=@BookingId1
--			END 
			
--			SELECT @NoData=COUNT(*) FROM #CheckInfinal
			
--			SELECT TOP 1 @BookingId1=BookingId,@RoomId1=RoomId,@AparmentId=ApartmentId,@BedId=BedId,@BookingLevel=BookingLevel,
--			@PId=PId
--			FROM #CheckInfinal	
			
--		END
--		-- to send front end
--		SELECT  S.Id,PropertyId,CheckInGuest,GuestId,RefGuestId,BookingId,RoomId,ApartmentId,S.BookingLevel as TYPE,
--		BedId,RoomCaptureId,BookingAssGuestId,A.BookingCode
--		FROM #CheckInfinal2 S
--		JOIN WRBHBBooking A WITH(NOLOCK) ON S.BookingId=A.Id AND A.IsActive=1 AND A.IsDeleted=0
		
--		Select Id as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = (select Id from #CheckInfinal)
		
--	END

	
	END 
IF @Action = 'Property'
BEGIN
	SELECT PropertyName as Property,PropertyId,BookingId
	FROM WRBHBBookingProperty where BookingId = @BookingId and
	IsActive = 1 and IsDeleted = 0 --and PropertyType = 'Internal'
END	 
IF @Action = 'ROOMLOAD'
  BEGIN
 --Guest Details Load 

CREATE TABLE #Name(Name NVARCHAR(100),Grade NVARCHAR(100),EmailId NVARCHAR(100),MobileNo BIGINT,Nationality NVARCHAR(100),
			EmpCode NVARCHAR(100),EmpCode1 INT,GuestId INT,PropertyId INT,Designation NVARCHAR(100),PropertyName NVARCHAR(100),
			PropertyType NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),RoomType NVARCHAR(100),
			Tariff DECIMAL(27,2),ClientName NVARCHAR(100),StateId INT,RoomId INT,ExpectedChkInTime NVARCHAR(100),
			TariffPaymentMode nvarchar(100),ServicePaymentMode nvarchar(100),BookingCode bigint,AMPM nvarchar(100),Occupancy NVARCHAR(100),
			SingleTariff decimal(27,2),DoubleTariff Decimal(27,2),ApartmentId INT ,ApartmentType NVARCHAR(100),BedType NVARCHAR(100),BedId INT,
			SingleMarkupAmount decimal(27,2),DoubleMarkupAmount decimal(27,2),BookingId int,ClientId int,CityId Int,ServiceCharge int)
 IF @SSPId =0
	begin
	--Select @Str1;
	IF @Str1='Room'
	BEGIN
		--  Booked  Single and Double Occupancy ,Booked and Direct
		INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
		
		        SELECT (BPA.FirstName+' '+BPA.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				BPA.RoomType AS EmpCode,BPA.SSPId AS EmpCode ,BPA.GuestId,BPA.BookingPropertyId,GD.Designation,
				P.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,BPA.RoomType,BPA.Tariff,B.ClientName,
				B.StateId,BPA.RoomId,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,BPA.Occupancy,BP.SingleTariff,BP.DoubleTariff,0 as ApartmentId,0 as ApartmentType,
				0 as BedType,0 as BedId,(BP.SingleandMarkup1-BP.SingleTariff),(BP.DoubleandMarkup1-BP.DoubleTariff),
				BPA.BookingId,B.ClientId,B.CityId,C.ServiceCharge
				FROM WRBHBBooking B 			
				JOIN WRBHBBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId			
				JOIN WRBHBBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				AND BPA.BookingPropertyId=BP.PropertyId
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
		END	
		IF @Str1='Apartment'
	    BEGIN 
				-- Apartment Booked and Direct Booked
				INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
				 
				SELECT (GD.FirstName+' '+GD.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				0 AS EmpCode,BPA.SSPId AS EmpCode ,GD.GuestId,BP.PropertyId,GD.Designation,
				BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,B.ClientName,
				B.StateId,0,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,BPA.ApartmentId,BPA.ApartmentType,
				0 as BedType,0 as BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount,
				BPA.BookingId,B.ClientId,B.CityId,C.ServiceCharge
				FROM WRBHBBooking B 			
				JOIN WRBHBApartmentBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId				
				JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				AND BPA.BookingPropertyId=BP.PropertyId
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
				
				 
				--SELECT (BD.FirstName+' '+BD.LastName) as Name,BD.Grade,BD.EmailId,BD.MobileNo,BD.Nationality,
				--0 AS EmpCode,BPA.SSPId AS EmpCode ,BD.GuestId,BP.PropertyId,BD.Designation,
				--BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				--CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,H.ClientName,
				--H.StateId,0,H.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,H.BookingCode
				--,H.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,BPA.ApartmentId,BPA.ApartmentType,
				--0 as BedType,0 as BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount
				--,BPA.BookingId
				----P.Category,P.Id,BP.PropertyId,H.Id,BPA.BookingId,bd.GuestId,BPA.GuestId

				--FROM WRBHBBooking H
				--join WRBHBBookingGuestDetails BD on H.Id = BD.BookingId and BD.IsActive=1 AND BD.IsDeleted=0
				--JOIN WRBHBApartmentBookingProperty BP ON BD.BookingId =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				--left outer JOIN WRBHBApartmentBookingPropertyAssingedGuest BPA ON BP.BookingId=BPA.BookingId AND
				--BD.GuestId = BPA.GuestId and BPA.IsActive=1 AND BPA.IsDeleted=0
				--left outer join WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				
				--WHERE   H.Status in( 'Booked','Direct Booked')    
				--and P.Category in ('Internal Property') 
				----and CONVERT(varchar(100),BPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
				---- CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) ) 
				-- and    H.BookingLevel=@Str1 and BPA.BookingPropertyId = @PropertyId and
				-- BPA.GuestId = @GuestId and BPA.BookingId = @BookingId
		END
		IF @Str1='Bed'
	    BEGIN	 
				-- Bed Booked and Direct Booked
				INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
				
				SELECT (GD.FirstName+' '+GD.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				0 AS EmpCode,BPA.SSPId AS EmpCode ,GD.GuestId,BP.PropertyId,GD.Designation,
				BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,B.ClientName,
				B.StateId,BPA.RoomId,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,0 as ApartmentId,0 as ApartmentType,
				BPA.BedType,BPA.BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount,BPA.BookingId,B.ClientId,B.CityId,
				C.ServiceCharge
				FROM WRBHBBooking B 				
				JOIN WRBHBBedBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId				
				JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				AND BPA.BookingPropertyId=BP.PropertyId
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
				
				--SELECT (BD.FirstName+' '+BD.LastName) as Name,BD.Grade,BD.EmailId,BD.MobileNo,BD.Nationality,
				--0 AS EmpCode,BPA.SSPId AS EmpCode ,BD.GuestId,BP.PropertyId,BD.Designation,
				--BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				--CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,H.ClientName,
				--H.StateId,BPA.RoomId,H.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,H.BookingCode
				--,H.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,0 as ApartmentId,0 as ApartmentType,
				--BPA.BedType,BPA.BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount
				----P.Category,P.Id,BP.PropertyId,H.Id,BPA.BookingId,bd.GuestId,BPA.GuestId
				--,BPA.BookingId

				--FROM WRBHBBooking H
				--join WRBHBBookingGuestDetails BD on H.Id = BD.BookingId and BD.IsActive=1 AND BD.IsDeleted=0
				--join WRBHBBedBookingProperty BP on BD.BookingId = BP.BookingId AND BP.IsActive = 1 AND
				--BP.IsDeleted = 0
				--join WRBHBBedBookingPropertyAssingedGuest BPA on BP.BookingId = BPA.BookingId AND
				--BD.GuestId = BPA.GuestId and BPA.IsActive = 1 AND BPA.IsDeleted = 0
				
				--left outer join WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				
				--WHERE   H.Status IN('Booked','Direct Booked')    
				--and P.Category in ('Internal Property') 
				----and CONVERT(varchar(100),BPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
				---- CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) ) 
				-- and    H.BookingLevel=@Str1 and BPA.BookingPropertyId = @PropertyId and 
				-- BPA.GuestId = @GuestId and BPA.BookingId =@BookingId and BPA.RoomId =@RoomId
			 
		END 	
END
ELSE
 
	BEGIN	
	--  Booked  Single and Double Occupancy ,Booked and Direct
	IF @Str1='Room'
	BEGIN
		--  Booked  Single and Double Occupancy ,Booked and Direct
		INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
		
		        SELECT (BPA.FirstName+' '+BPA.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				BPA.RoomType AS EmpCode,BPA.SSPId AS EmpCode ,BPA.GuestId,BPA.BookingPropertyId,GD.Designation,
				P.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,BPA.RoomType,BPA.Tariff,B.ClientName,
				B.StateId,BPA.RoomId,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,BPA.Occupancy,BP.SingleTariff,BP.DoubleTariff,0 as ApartmentId,0 as ApartmentType,
				0 as BedType,0 as BedId,(BP.SingleandMarkup1-BP.SingleTariff),(BP.DoubleandMarkup1-BP.DoubleTariff),
				BPA.BookingId,B.ClientId,B.CityId,C.ServiceCharge
				FROM WRBHBBooking B 			
				JOIN WRBHBBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId			
				JOIN WRBHBBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
		END	
		IF @Str1='Apartment'
	    BEGIN 
				-- Apartment Booked and Direct Booked
				INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
				 
				SELECT (GD.FirstName+' '+GD.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				0 AS EmpCode,BPA.SSPId AS EmpCode ,GD.GuestId,BP.PropertyId,GD.Designation,
				BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,B.ClientName,
				B.StateId,0,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,BPA.ApartmentId,BPA.ApartmentType,
				0 as BedType,0 as BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount,
				BPA.BookingId,B.ClientId,B.CityId,C.ServiceCharge
				FROM WRBHBBooking B 			
				JOIN WRBHBApartmentBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId				
				JOIN WRBHBApartmentBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
				
				 
				--SELECT (BD.FirstName+' '+BD.LastName) as Name,BD.Grade,BD.EmailId,BD.MobileNo,BD.Nationality,
				--0 AS EmpCode,BPA.SSPId AS EmpCode ,BD.GuestId,BP.PropertyId,BD.Designation,
				--BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				--CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,H.ClientName,
				--H.StateId,0,H.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,H.BookingCode
				--,H.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,BPA.ApartmentId,BPA.ApartmentType,
				--0 as BedType,0 as BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount
				--,BPA.BookingId
				----P.Category,P.Id,BP.PropertyId,H.Id,BPA.BookingId,bd.GuestId,BPA.GuestId

				--FROM WRBHBBooking H
				--join WRBHBBookingGuestDetails BD on H.Id = BD.BookingId and BD.IsActive=1 AND BD.IsDeleted=0
				--JOIN WRBHBApartmentBookingProperty BP ON BD.BookingId =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				--left outer JOIN WRBHBApartmentBookingPropertyAssingedGuest BPA ON BP.BookingId=BPA.BookingId AND
				--BD.GuestId = BPA.GuestId and BPA.IsActive=1 AND BPA.IsDeleted=0
				--left outer join WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				
				--WHERE   H.Status in( 'Booked','Direct Booked')    
				--and P.Category in ('Internal Property') 
				----and CONVERT(varchar(100),BPA.ChkInDt,103) in( CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,GETDATE(),103)),103), 
				---- CONVERT(NVARCHAR,DATEADD(DAY,0,CONVERT(DATE,GETDATE(),103)),103) ) 
				-- and    H.BookingLevel=@Str1 and BPA.BookingPropertyId = @PropertyId and
				-- BPA.GuestId = @GuestId and BPA.BookingId = @BookingId
		END
		IF @Str1='Bed'
	    BEGIN	 
				-- Bed Booked and Direct Booked
				INSERT INTO #Name(Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1,GuestId,PropertyId,Designation,
				PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
				,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
				DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,SingleMarkupAmount,DoubleMarkupAmount,BookingId,
				ClientId,CityId,ServiceCharge)
				
				SELECT (GD.FirstName+' '+GD.LastName) as Name,GD.Grade,GD.EmailId,GD.MobileNo,GD.Nationality,
				0 AS EmpCode,BPA.SSPId AS EmpCode ,GD.GuestId,BP.PropertyId,GD.Designation,
				BP.PropertyName,P.Category,CONVERT(nvarchar(100),BPA.ChkInDt,103) as CheckInDate,
				CONVERT(nvarchar(100),BPA.ChkOutDt,103) as CheckOutDate,0,BPA.Tariff,B.ClientName,
				B.StateId,BPA.RoomId,B.ExpectedChkInTime,BPA.TariffPaymentMode,BPA.ServicePaymentMode,B.BookingCode,
				B.AMPM,0 as Occupancy,'0.00' as SingleTariff,'0.00' as DoubleTariff,0 as ApartmentId,0 as ApartmentType,
				BPA.BedType,BPA.BedId,'0.00' as SingleMarkupAmount,'0.00' as DoubleMarkupAmount,BPA.BookingId,
				B.ClientId,B.CityId,C.ServiceCharge
				FROM WRBHBBooking B 				
				JOIN WRBHBBedBookingPropertyAssingedGuest BPA WITH(NOLOCK) ON BPA.BookingId=B.Id AND BPA.IsActive=1 
				AND BPA.IsDeleted=0 AND BPA.Id=@ClientId
				JOIN WRBHBBookingGuestDetails GD WITH(NOLOCK) ON B.Id=GD.BookingId AND B.IsActive=1 AND B.IsDeleted=0
				AND BPA.GuestId=GD.GuestId				
				JOIN WRBHBBedBookingProperty BP ON B.Id =BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
				JOIN WRBHBProperty P on  P.Id = BPA.BookingPropertyId and P.IsActive=1 and P.IsDeleted = 0
				JOIN WRBHBClientManagement C on C.Id = B.ClientId and C.IsActive = 1 and C.IsDeleted = 0
				WHERE B.Id=@BookingId AND B.IsActive=1 AND B.IsDeleted=0
		END
		END
            SELECT distinct Name,Grade,EmailId,MobileNo,Nationality,EmpCode,EmpCode1 AS EmpCode,GuestId,PropertyId,Designation,
			PropertyName,PropertyType,CheckInDate,CheckOutDate,RoomType,Tariff,ClientName,StateId,RoomId
			,ExpectedChkInTime,TariffPaymentMode,ServicePaymentMode,BookingCode,AMPM,Occupancy,SingleTariff,
			DoubleTariff,ApartmentId,ApartmentType,BedType,BedId,
			SingleMarkupAmount,DoubleMarkupAmount,BookingId ,ClientId,CityId,ServiceCharge
			FROM #Name where PropertyId = @PropertyId
			--where ApartmentId!=0; 
			
			-- Service Load to Check SSP
			SELECT DISTINCT (CS.ServiceName) AS ServiceItem,CS.Price,CS.ProductId,CS.Complimentary
			FROM WRBHBSSPCodeGeneration CM   
			JOIN WRBHBSSPCodeGenerationServices CS ON CM.Id=CS.SSPCodeGenerationId AND CS.IsActive=1 AND CS.IsDeleted=0
			WHERE CM.PropertyId=@PropertyId AND CM.IsActive=1 AND CM.IsDeleted=0			
			order by CS.Complimentary desc
	
			----RoomLoad
			--SELECT distinct (PR.RoomNo+'-'+PA.ApartmentNo+'-'+PB.BlockName+'-'+PR.RoomType) as AvailableRooms ,PR.Id as RoomId,
			--P.Id as PropertyId
			--FROM WRBHBPropertyRooms PR
			--JOIN WRBHBPropertyApartment PA ON PR.ApartmentId=PA.Id AND PA.IsActive=1 AND PA.IsDeleted=0
			--JOIN WRBHBPropertyBlocks PB ON PA.BlockId=PB.Id AND PB.IsActive=1 AND PB.IsDeleted=0
			--JOIN WRBHBProperty P ON PB.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			--left outer JOIN WRBHBCheckInHdr CH ON P.Id=CH.PropertyId AND CH.IsActive=1 AND CH.IsDeleted=0
			--WHERE  PR.IsActive=1 AND PR.IsDeleted=0
			--AND P.Id=@PropertyId and PR.CheckIn!=1 and PA.SellableApartmentType != 'HUB'
 END
--IF @Action='TariffLoad'
--		BEGIN
--				SELECT Tariff FROM WRBHBBookingPropertyAssingedGuest
--				WHERE RoomId=@RoomId AND IsActive=1 AND IsDeleted=0;
--		END


IF @Action = 'CustomFieldLoad'
	 BEGIN
		  -- @Id1 - booking property table id  
		  -- Booking Id
		  --DECLARE @BookingId BIGINT;  
		  SET @BookingId=(SELECT TOP 1 BookingId FROM WRBHBBookingProperty);  
		  -- Client Id
		  SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId);
		 -- Text Box Fields
		 ---select @ClientId
		  SELECT FieldName,FieldValue,Mandatory,Id AS FieldId,0 AS Id 
		  FROM WRBHBClientManagementCustomFields WHERE IsDeleted=0 AND IsActive=1 AND 
		  CltmgntId=@ClientId AND Visible=1 AND FieldType='Text Box';
		 -- List Box Fields
		  SELECT FieldName,FieldValue,Mandatory,Id AS FieldId,0 AS Id 
		  FROM WRBHBClientManagementCustomFields WHERE IsDeleted=0 AND IsActive=1 AND 
		  CltmgntId=@ClientId AND Visible=1 AND FieldType='List Box';
	 END
IF @Action = 'RoomTaxFlagLoad'
		 BEGIN
			 SELECT Occupancy AS Pax,Tariff   FROM WRBHBBookingPropertyAssingedGuest
			 WHERE RoomId=@RoomId
		 END 
IF @Action='IMAGEUPLOAD'  
  BEGIN 
		UPDATE WRBHBCheckInHdr SET GuestImage=@Str1 
		WHERE Id=@GuestId 
  END 
END



