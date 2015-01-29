
GO
/****** Object:  StoredProcedure [dbo].[Sp_ExternalChkoutIntermediate_Help]    Script Date: 11/12/2014 15:03:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================
-- Author: Shameem
-- Create date:09-07-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	External Check Out
-- =================================================================================
ALTER PROCEDURE [dbo].[Sp_ExternalChkoutIntermediate_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@BillFrom NVARCHAR(100),
@BillTo NVARCHAR(100),
@CheckInHdrId INT=NULL,
--@Tariff DECIMAL(27,2)=NULL,
@StateId INT=NULL,
@PropertyId BIGINT=NULL,
@UserId INT=NULL
)
AS
BEGIN
DECLARE @Cnt INT,@StateId1 int;
set @StateId1 = 17;
IF @Action='ServiceEntry'  
 BEGIN
	UPDATE WRBHBChechkOutHdr SET  ServiceEntryFlag=1 where Id=@CheckInHdrId
 END
IF @Action='PageLoad'
	BEGIN
	SET @Cnt=(SELECT COUNT(*) FROM WRBHBChechkOutHdr)
		IF @Cnt=0 BEGIN SELECT 1 AS CheckoutNo;
	END
	ELSE 
	BEGIN
	SELECT TOP 1 CAST(CheckoutNo AS INT)+1 AS CheckoutNo FROM WRBHBChechkOutHdr
		ORDER BY Id DESC;
	END
	
	
	-- Room Level Property booked and direct booked (External Property)
	    CREATE TABLE #Prop (ZId BIGINT,PropertyName NVARCHAR(100))
	    INSERT INTO #Prop(ZId,PropertyName)
	    
		SELECT DISTINCT P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBCheckInHdr CH on CH.BookingId = AG.BookingId and CH.IsActive = 1 and CH.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and A.PropertyType in ('ExP','MGH','DdP')
		--and P.Category in ('External Property','Managed G H') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) =  CONVERT(nvarchar(100),GETDATE(),103)
		
		and PU.UserId=@UserId 
-- MGH Bed		
		INSERT INTO #Prop(ZId,PropertyName)
	    
		SELECT DISTINCT P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBedBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBedBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBCheckInHdr CH on CH.BookingId = AG.BookingId and CH.IsActive = 1 and CH.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and A.PropertyType in ('MGH')
		--and P.Category in ('External Property','Managed G H') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) =  CONVERT(nvarchar(100),GETDATE(),103)
		
		and PU.UserId=@UserId
		
		INSERT INTO #Prop(ZId,PropertyName)
		SELECT DISTINCT P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBCheckInHdr CH on CH.BookingId = AG.BookingId and CH.IsActive = 1 and CH.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and A.PropertyType in ('CPP') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) =  CONVERT(nvarchar(100),GETDATE(),103)
		
		and PU.UserId=@UserId 
		
		INSERT INTO #Prop(ZId,PropertyName)
	    
	    SELECT S.HotalId AS PropertyId,(S.HotalName+','+C.CityName+','+st.StateName) AS PropertyName
		FROM WRBHBBooking H
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBStaticHotels S WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId AND s.IsActive=1 AND s.IsDeleted=0
		JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON H.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0 
		JOIN wrbhbcity C ON C.Id = H.cityId AND C.IsActive = 1
		JOIN wrbhbstate st ON st.Id = C.StateId AND st.IsActive = 1 
		WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND
		H.Status IN('Booked','Direct Booked')  
		AND H.Cancelstatus !='Canceled' AND BP.PropertyType='MMT' 
		GROUP BY S.HotalId,S.HotalName,C.CityName,st.StateName
		
		
		
		
		SELECT CAST((ZId) AS NVARCHAR(100)) AS ZId,PropertyName from #Prop GROUP BY ZId,PropertyName
		SELECT count(*) AS PropertyCount,CAST((ZId) AS NVARCHAR(100)) AS ZId,PropertyName FROM #Prop
		GROUP BY ZId,PropertyName 
 		
 		 
 		 -- Item Load
    
		CREATE TABLE #Service(Item NVARCHAR(100),PerQuantityprice DECIMAL(27,2),Id INT,TypeService NVARCHAR(100))  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Food And Beverages'  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Laundry'  

		SELECT Item,PerQuantityprice,Id as ItemId,TypeService  
		FROM #Service 
       
END 
If @Action = 'GuestName'
BEGIN
	--	SELECT  GuestName,GuestId,StateId,Id AS CheckInHdrId,PropertyId,RoomId,ApartmentId,
	--	BookingId,BedId,Type as Level--PropertyId,Property--,PropertyType
	--	From WRBHBCheckInHdr
	--	WHERE IsActive=1 AND IsDeleted=0 AND 
	--    PropertyId = @PropertyId and
	--	PropertyType in ('External Property','Managed G H') 
	--	--and 
	----	CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and
	--	AND Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
	--	IsActive = 1 and IsDeleted = 0 )
		CREATE TABLE #GUEST(GuestName NVARCHAR(100),GuestId INT,StateId INT,CheckInHdrId INT,  
		PropertyId BIGINT,RoomId INT,ApartmentId INT,BookingId INT,BedId INT,Type NVARCHAR(100),Flag int,
		BookingCode nvarchar(100),ChkInDT nvarchar(100),ChkOutDT nvarchar(100))  
--1 Room Level		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('External Property' , 'Managed G H','MMT','CPP','DdP') and  
		h.PropertyId = @PropertyId and  d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1 and ISNULL(Flag,0)=1  )  OR
		h.Id   in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1 and ISNULL(Flag,0)=1 and PropertyId=@PropertyId)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
--1 Bed Level		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBedBookingPropertyAssingedGuest d on --h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('Managed G H') and  
		h.PropertyId = @PropertyId and  d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1 and ISNULL(Flag,0)=1  )  OR
		h.Id   in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=1 and ISNULL(Flag,0)=1 and PropertyId=@PropertyId)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
-- 2 Room Level		
		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('External Property' , 'Managed G H','MMT','CPP','DdP') and  
		h.PropertyId = @PropertyId and   d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0  )  and
		h.Id not in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
-- 2 Bed Level
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBedBookingPropertyAssingedGuest d on -- h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('Managed G H') and  
		h.PropertyId = @PropertyId and   d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0  )  and
		h.Id not in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt		

--3 Room Level 
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('External Property','Managed G H','MMT','CPP','DdP') and  
		h.PropertyId = @PropertyId and   --d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 ) 
		
		and h.Id  not IN (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where isnull(Flag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0  ) 
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
--3 Bed Level
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBedBookingPropertyAssingedGuest d on --h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('Managed G H') and  
		h.PropertyId = @PropertyId and   --d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 ) 
		
		and h.Id  not IN (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where isnull(Flag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0  ) 
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt 
				
--4 Room Level 		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('External Property','Managed G H','MMT','CPP','DdP') and  
		h.PropertyId = @PropertyId and   d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0 and Isnull(Flag,0)=0 ) 
		and h.Id  not IN (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0 and Isnull(Flag,0)=0 ) 
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
--4 Bed Level
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		From WRBHBCheckInHdr  h
		join WRBHBBedBookingPropertyAssingedGuest d on --h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		h.PropertyType in ('Managed G H') and  
		h.PropertyId = @PropertyId and   d.CurrentStatus = 'CheckIn' and 
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		h.Id  IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0 and Isnull(Flag,0)=0 ) 
		and h.Id  not IN (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0 and Isnull(Flag,0)=0 ) 
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt		

		--INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		--BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)  

		--SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		--h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt 
		--From WRBHBCheckInHdr  h
		--join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		--h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		--d.IsActive=1 and d.IsDeleted=0
		--WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		--h.PropertyType in ('External Property' , 'Managed G H') and  
		--h.PropertyId = 1334 and  
		---- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		--h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0
		--and ISNULL(IntermediateFlag,0)=1  )  and
		--h.Id not in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0
		--and ISNULL(IntermediateFlag,0)=1)
		--group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		--h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
		SELECT  GuestName,GuestId,StateId, CheckInHdrId,CAST((PropertyId) AS NVARCHAR(100)) AS  PropertyId,
		RoomId,ApartmentId,BookingId,BedId,Type as Level,BookingCode ,ChkInDT as CheckInDate,ChkOutDT as CheckOutDate 
		FROM #GUEST 
		group by GuestName,GuestId,StateId, CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type ,BookingCode ,ChkInDT,ChkOutDT
		 
		SELECT DISTINCT U.FirstName AS label,U.Id AS Data FROM WRBHBUser U
		JOIN WRBHBPropertyUsers P ON U.Id=P.UserId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE P.UserType in ('Resident Managers','Assistant Resident Managers') AND 
		U.IsActive=1 AND U.IsDeleted=0 and P.PropertyId = @PropertyId
	END

IF @Action = 'GuestDetails'	
BEGIN
		DECLARE @IntId BIGINT;
		
		SET @IntId=(SELECT TOP 1 ISNULL(Id,0) AS chekoutId FROM WRBHBChechkOutHdr WHERE ChkInHdrId = @CheckInHdrId AND ISNULL(IntermediateFlag,0)=1
		AND Status = 'UnSettled' AND IsActive= 1 AND IsDeleted =0);
		
IF (ISNULL(@IntId,0)!=0)
BEGIN
	SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType,EmailId FROM WRBHBCheckInHdr  
	WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0 

	CREATE TABLE #LEVEL(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC nvarchar(100),TACPer DECIMAL(27,2))
	DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100),@NewCheckInDate NVARCHAR(100);
	SET @BookingId=(SELECT BookingId FROM WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	SET @GuestId=(SELECT GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	SET @BookingLevel=(SELECT Type from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	
	IF @BookingLevel = 'Room' 
	BEGIN
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer)
		SELECT TOP 1 CONVERT(nvarchar(100),(d.ChkInDt),103),CONVERT(nvarchar(100),(d.ChkOutDt),103),
		d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,isnull((d.Tariff*h.TACPer/100),0)
		FROM  WRBHBBookingProperty h 
		JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
		h.PropertyId = d.BookingPropertyId
		AND h.IsActive = 1 and
		h.IsDeleted = 0
		WHERE d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
		--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff,d.ChkInDt,d.ChkOutDt
		ORDER BY d.Id DESC;
	END
	
	IF @BookingLevel = 'Bed' 
	BEGIN
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer)
		SELECT TOP 1 CONVERT(nvarchar(100),(d.ChkInDt),103),CONVERT(nvarchar(100),(d.ChkOutDt),103),
		d.TariffPaymentMode,d.ServicePaymentMode ,0,0
		FROM  WRBHBBedBookingProperty h 
		JOIN WRBHBBedBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
		h.PropertyId = d.BookingPropertyId
		AND h.IsActive = 1 and
		h.IsDeleted = 0
		WHERE d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
		--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff,d.ChkInDt,d.ChkOutDt
		ORDER BY d.Id DESC;
	END
	
	DECLARE @ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@TariffPaymentMode NVARCHAR(100),
	@ServicePaymentMode NVARCHAR(100),@TAC NVARCHAR(100),@TACPer DECIMAL(27,2);
	SET @ChkInDate =( SELECT ChkInDate FROM #LEVEL)	
	SET @ChkOutDate =( SELECT ChkOutDate FROM #LEVEL)
	SET @TariffPaymentMode =(SELECT TariffPaymentMode FROM #LEVEL)
	SET @ServicePaymentMode =(SELECT ServicePaymentMode FROM #LEVEL)
	SET @TAC=(SELECT TAC from #LEVEL)
	SET @TACPer=(SELECT TACPer from #LEVEL)
	
	SELECT @NewCheckInDate=convert(nvarchar(100),Cast(NewCheckInDate as DATE),103)	FROM WRBHBCheckInHdr  
	WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId
	
	
	--SELECT Property,
	--CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate,103) as Stay,Tariff,
	--CONVERT(nvarchar(100),@ChkOutDate,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate
	--FROM WRBHBCheckInHdr
	--WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId ;
	
	SELECT Property, Stay,ChkOutTariffTotal AS  Tariff,  
	CONVERT(NVARCHAR(100),BillEndDate,103) AS ChkoutDate,CONVERT(NVARCHAR(100),BillFromDate,103) AS CheckInDate  
	FROM WRBHBChechkOutHdr  
	WHERE IsActive = 1 AND IsDeleted = 0 AND Status = 'UnSettled' AND ChkInHdrId =@CheckInHdrId
		
		
	----BillDate 
	--SELECT CONVERT(varchar(103),@ChkOutDate,103) as BillDate,convert(nvarchar(100),GETDATE(),103) as TodayDate
	DECLARE @Roles NVARCHAR(100);
		SET @Roles=(SELECT Roles FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND Roles='Operations Managers');
		
		IF(@Roles = 'Operations Managers')
		BEGIN
		--BillDate   
			SELECT CONVERT(NVARCHAR(103),@ChkOutDate,103) as BillDate ,convert(nvarchar(100),@ChkOutDate,103) as TodayDate
		END
		ELSE
		BEGIN
		--BillDate   
			SELECT CONVERT(NVARCHAR(103),@ChkOutDate,103) as BillDate ,convert(nvarchar(100),GETDATE(),103) as TodayDate
		END
	
	

	SELECT ClientName,ClientId,CityId,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,
	Id From  WRBHBCheckInHdr  
	WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
	
	--Day Count
			--CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)
			--INSERT INTO #CountDays (NoofDays,CheckInHdrId)
	--SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,
	--Id--,ArrivalDate
	--FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;
	SELECT DATEDIFF(day,CONVERT(date,BillFromDate,103), CONVERT(date,BillEndDate ,103) ) AS Days,  
	Id--,ArrivalDate  
	FROM WRBHBChechkOutHdr WHERE  Status = 'UnSettled' AND ChkInHdrId=@CheckInHdrId;
	
	SELECT IntermediateFlag FROM WRBHBChechkOutHdr where Status = 'UnSettled' AND ChkInHdrId=@CheckInHdrId;
	
	
	
END
ELSE
BEGIN
	SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType,EmailId FROM WRBHBCheckInHdr  
	WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0 
	
	CREATE TABLE #LEVELs(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC nvarchar(100),TACPer DECIMAL(27,2))
	--DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100),@NewCheckInDate NVARCHAR(100);
	SET @BookingId=(SELECT BookingId FROM WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	SET @GuestId=(SELECT GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	SET @BookingLevel=(SELECT Type from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
	
	IF @BookingLevel = 'Room' 
	BEGIN
		INSERT INTO #LEVELs(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer)
		SELECT TOP 1 CONVERT(nvarchar(100),(d.ChkInDt),103),CONVERT(nvarchar(100),(d.ChkOutDt),103),
		d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,isnull((d.Tariff*h.TACPer/100),0)
		FROM  WRBHBBookingProperty h 
		JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
		h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 and h.IsDeleted = 0
		where d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
		--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff,d.ChkInDt,d.ChkOutDt
		order by d.Id desc;
	END
	IF @BookingLevel = 'Bed' 
	BEGIN
		INSERT INTO #LEVELs(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer)
		SELECT TOP 1 CONVERT(nvarchar(100),(d.ChkInDt),103),CONVERT(nvarchar(100),(d.ChkOutDt),103),
		d.TariffPaymentMode,d.ServicePaymentMode ,0,0
		FROM  WRBHBBedBookingProperty h 
		JOIN WRBHBBedBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
		h.PropertyId = d.BookingPropertyId
		AND h.IsActive = 1 AND h.IsDeleted = 0
		WHERE d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
		--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff,d.ChkInDt,d.ChkOutDt
		ORDER BY d.Id DESC;
	END
	--DECLARE @ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@TariffPaymentMode NVARCHAR(100),
	--@ServicePaymentMode NVARCHAR(100),@TAC NVARCHAR(100),@TACPer DECIMAL(27,2);
	SET @ChkInDate =( SELECT ChkInDate FROM #LEVELs)	
	SET @ChkOutDate =( SELECT ChkOutDate FROM #LEVELs)
	SET @TariffPaymentMode =(SELECT TariffPaymentMode FROM #LEVELs)
	SET @ServicePaymentMode =(SELECT ServicePaymentMode FROM #LEVELs)
	SET @TAC=(SELECT TAC from #LEVELs)
	SET @TACPer=(SELECT TACPer from #LEVELs)
	
	SELECT @NewCheckInDate=convert(nvarchar(100),Cast(NewCheckInDate as DATE),103)	FROM WRBHBCheckInHdr  
	WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId
	
	
	SELECT Property,
	CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate,103) as Stay,Tariff,
	CONVERT(nvarchar(100),@ChkOutDate,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate
	FROM WRBHBCheckInHdr
	WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId;
		
		
	--DECLARE @Roles NVARCHAR(100);
		SET @Roles=(SELECT Roles FROM WRBHBUserRoles  WHERE UserId = @UserId AND IsActive = 1 AND IsDeleted = 0 AND Roles='Operations Managers');
		
		IF(@Roles = 'Operations Managers')
		BEGIN
		--BillDate   
			SELECT CONVERT(NVARCHAR(103),@ChkOutDate,103) as BillDate ,convert(nvarchar(100),@ChkOutDate,103) as TodayDate
		END
		ELSE
		BEGIN
		--BillDate   
			SELECT CONVERT(NVARCHAR(103),@ChkOutDate,103) as BillDate ,convert(nvarchar(100),GETDATE(),103) as TodayDate
		END
	
	

	SELECT ClientName,ClientId,CityId,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,
	Id From  WRBHBCheckInHdr  
	WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
	
	--Day Count
			--CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)
			--INSERT INTO #CountDays (NoofDays,CheckInHdrId)
	SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,
	Id--,ArrivalDate
	FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;
	
	SELECT IntermediateFlag FROM WRBHBChechkOutHdr where Status = 'UnSettled' AND ChkInHdrId=@CheckInHdrId;
	
	
END

END
	
IF @Action='CHKINROOMDETAILS'
BEGIN
		DECLARE @CID BIGINT;
		--Select isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId and Flag=0 and
		--IsActive = 1 and IsDeleted = 0
		SET @CID=(SELECT TOP 1 isnull(Id,0) AS chekoutId FROM WRBHBChechkOutHdr WHERE ChkInHdrId = @CheckInHdrId and Flag=0
		and IsActive= 1 and IsDeleted =0)  
 --select @CID  
	IF(ISNULL(@CID,0)=0)  
	BEGIN  
	
			CREATE TABLE #LEVEL1(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
			TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC NVARCHAR(100),TACPer DECIMAL(27,2),
			STAgreed DECIMAL(27,2),LTAgreed Decimal(27,2),STRack DECIMAL(27,2),LTRack DECIMAL(27,2),
			SingleMarkup DECIMAL(27,2),DoubleMarkup DECIMAL(27,2),TripleMarkup DECIMAL(27,2))
			--DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);
			SET @BookingId=(SELECT BookingId FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
			SET @GuestId=(SELECT GuestId FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
			SET @BookingLevel=(SELECT Type FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
--select @GuestId ,@BookingId
		IF @BookingLevel = 'Room' 
		BEGIN
			INSERT INTO #LEVEL1(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT TOP 1 CONVERT(NVARCHAR(100),(d.ChkInDt),103),CONVERT(NVARCHAR(100),(d.ChkOutDt),103),
			d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,isnull((d.Tariff*h.TACPer/100),0),
			d.LTonAgreed,d.LTonRack,d.STonAgreed,d.STonRack,(h.GeneralMarkup+h.Markup),
			(h.GeneralMarkup+h.Markup),(h.GeneralMarkup+h.Markup)
			FROM  WRBHBBookingProperty h 
			JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId AND
			h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 AND h.IsDeleted = 0
			 
			JOIN WRBHBCheckInHdr c on C.PropertyId=d.BookingPropertyId AND c.IsActive = 1 AND c.IsDeleted = 0
			where d.GuestId  = @GuestId AND d.BookingId = @BookingId AND d.IsActive = 1 AND d.IsDeleted = 0
			AND c.PropertyType IN ('External Property','Managed G H','MMT','DdP')
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
			
			
			
			INSERT INTO #LEVEL1(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			
			SELECT TOP 1 CONVERT(NVARCHAR(100),(d.ChkInDt),103),CONVERT(NVARCHAR(100),(d.ChkOutDt),103),
			d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,ISNULL((d.Tariff*h.TACPer/100),0),
			ISNULL(CD.STAgreed ,0) ,ISNULL(CD.LTAgreed,0),0,ISNULL(CD.LTRack,0),
			0,0,0
			FROM  WRBHBBooking B 
			JOIN WRBHBBookingProperty h on h.BookingId=b.Id AND h.IsActive = 1 AND h.IsDeleted = 0
			JOIN WRBHBBookingPropertyAssingedGuest d ON h.BookingId= d.BookingId AND
			h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 AND h.IsDeleted = 0
			JOIN WRBHBContractClientPref_Header CH ON B.ClientId=CH.ClientId AND CH.IsActive=1 AND
			CH.IsDeleted = 0
			JOIN WRBHBContractClientPref_Details CD ON  CH.Id = CD.HeaderId AND CD.IsActive = 1 AND CD.IsDeleted=0
			where d.GuestId  = @GuestId AND d.BookingId = @BookingId AND d.IsActive = 1 AND d.IsDeleted = 0
			and h.PropertyType='CPP' AND d.TariffPaymentMode='Bill to Company (BTC)'
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
			
			
		END
		
		IF @BookingLevel = 'Bed' 
		BEGIN
			INSERT INTO #LEVEL1(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT TOP 1 CONVERT(NVARCHAR(100),(d.ChkInDt),103),CONVERT(NVARCHAR(100),(d.ChkOutDt),103),
			d.TariffPaymentMode,d.ServicePaymentMode ,0,0,0,0,0,0,0,0,0
			FROM  WRBHBBedBookingProperty h 
			JOIN WRBHBBedBookingPropertyAssingedGuest d on h.BookingId= d.BookingId AND
			h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 AND h.IsDeleted = 0
			 
			JOIN WRBHBCheckInHdr c on C.PropertyId=d.BookingPropertyId AND c.IsActive = 1 AND c.IsDeleted = 0
			where d.GuestId  = @GuestId AND d.BookingId = @BookingId AND d.IsActive = 1 AND d.IsDeleted = 0
			AND c.PropertyType IN ('Managed G H')
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
		END
	
			DECLARE @ChkInDate1 nvarchar(100),@ChkOutDate1 nvarchar(100),@TariffPaymentMode1 nvarchar(100),
			@ServicePaymentMode1 nvarchar(100),@TAC1 nvarchar(100),@TACPer1 nvarchar(100),
			@STAgreed Decimal(27,2),@LTAgreed Decimal(27,2),@STRack decimal(27,2),@LTRack decimal(27,2),
			@SingleMarkup Decimal(27,2),@DoubleMarkup Decimal(27,2),@TripleMarkup Decimal(27,2);
			SET @ChkInDate1 =( SELECT ChkInDate FROM #LEVEL1)	
			SET @ChkOutDate1 =( SELECT ChkOutDate FROM #LEVEL1)
			SET @TariffPaymentMode1 =(SELECT TariffPaymentMode FROM #LEVEL1)
			SET @ServicePaymentMode1 =(SELECT ServicePaymentMode FROM #LEVEL1)
			SET @TAC1=(SELECT TAC from #LEVEL1)
			SET @TACPer1=(SELECT TACPer from #LEVEL1)
			SET @STAgreed=(SELECT STAgreed FROM #LEVEL1)
			SET @LTAgreed=(SELECT LTAgreed FROM #LEVEL1)
			SET @STRack=(SELECT STRack FROM #LEVEL1)
			SET @LTRack=(SELECT LTRack FROM #LEVEL1)
			SET @SingleMarkup=(SELECT SingleMarkup FROM #LEVEL1)
			SET @DoubleMarkup=(SELECT DoubleMarkup FROM #LEVEL1)
			SET @TripleMarkup=(SELECT TripleMarkup FROM #LEVEL1)
			
			
			
			
-- this is chkin and chkout date after comes selected bill date		
			
			CREATE TABLE #LEVEL2(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
			TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC NVARCHAR(100),TACPer DECIMAL(27,2),
			STAgreed DECIMAL(27,2),LTAgreed DECIMAL(27,2),STRack DECIMAL(27,2),LTRack DECIMAL(27,2),
			SingleMarkup DECIMAL(27,2),DoubleMarkup DECIMAL(27,2),TripleMarkup DECIMAL(27,2))
			--DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);
			SET @BookingId=(SELECT BookingId FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId AND IsActive = 1 AND IsDeleted =0)
			SET @GuestId=(SELECT GuestId FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId AND IsActive = 1 AND IsDeleted =0)
			SET @BookingLevel=(SELECT Type FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId AND IsActive = 1 AND IsDeleted =0)
--select @GuestId ,@BookingId
		IF @BookingLevel = 'Room' 
		BEGIN
			INSERT INTO #LEVEL2(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT TOP 1 @BillFrom,@BillTo,
			d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,isnull((d.Tariff*h.TACPer/100),0),
			d.LTonAgreed,d.LTonRack,d.STonAgreed,d.STonRack,(h.GeneralMarkup+h.Markup),
			(h.GeneralMarkup+h.Markup),(h.GeneralMarkup+h.Markup)
			FROM  WRBHBBookingProperty h 
			JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
			h.PropertyId = d.BookingPropertyId	AND h.IsActive = 1 and	h.IsDeleted = 0
			JOIN WRBHBCheckInHdr c on C.PropertyId=d.BookingPropertyId AND c.IsActive = 1 AND c.IsDeleted = 0
			where d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
			AND c.PropertyType IN ('External Property','Managed G H','MMT','DdP')
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
			
			INSERT INTO #LEVEL2(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			
			SELECT TOP 1 @BillFrom,@BillTo,
			d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,isnull((d.Tariff*h.TACPer/100),0),
			ISNULL(CD.STAgreed ,0) ,ISNULL(CD.LTAgreed,0),0,ISNULL(CD.LTRack,0),
			0,0,0
			FROM  WRBHBBooking B 
			JOIN WRBHBBookingProperty h on h.BookingId=b.Id AND h.IsActive = 1 AND h.IsDeleted = 0
			JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
			h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 and h.IsDeleted = 0
			JOIN WRBHBContractClientPref_Header CH ON B.ClientId=CH.ClientId AND CH.IsActive=1 AND
			CH.IsDeleted = 0
			JOIN WRBHBContractClientPref_Details CD ON  CH.Id = CD.HeaderId AND CD.IsActive = 1 AND CD.IsDeleted=0
			where d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
			and h.PropertyType='CPP' AND d.TariffPaymentMode='Bill to Company (BTC)'
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
		END
		
		
		IF @BookingLevel = 'Bed' 
		BEGIN
			INSERT INTO #LEVEL2(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC,TACPer,
			STAgreed,LTAgreed,STRack,LTRack,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT TOP 1 CONVERT(NVARCHAR(100),(d.ChkInDt),103),CONVERT(NVARCHAR(100),(d.ChkOutDt),103),
			d.TariffPaymentMode,d.ServicePaymentMode ,0,0,0,0,0,0,0,0,0
			FROM  WRBHBBedBookingProperty h 
			JOIN WRBHBBedBookingPropertyAssingedGuest d on h.BookingId= d.BookingId AND
			h.PropertyId = d.BookingPropertyId AND h.IsActive = 1 AND h.IsDeleted = 0
			 
			JOIN WRBHBCheckInHdr c on C.PropertyId=d.BookingPropertyId AND c.IsActive = 1 AND c.IsDeleted = 0
			where d.GuestId  = @GuestId AND d.BookingId = @BookingId AND d.IsActive = 1 AND d.IsDeleted = 0
			AND c.PropertyType IN ('Managed G H')
			--group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC,h.TACPer,d.Tariff
			order by d.Id desc;
		END
			--DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100),@TariffPaymentMode nvarchar(100),
			--@ServicePaymentMode nvarchar(100),@TAC nvarchar(100);
			SET @ChkInDate =( SELECT ChkInDate FROM #LEVEL2)	
			SET @ChkOutDate =( SELECT ChkOutDate FROM #LEVEL2)
			SET @TariffPaymentMode =(SELECT TariffPaymentMode FROM #LEVEL2)
			SET @ServicePaymentMode =(SELECT ServicePaymentMode FROM #LEVEL2)
			SET @TAC=(SELECT TAC from #LEVEL2)
			SET @TACPer=(SELECT TACPer from #LEVEL2)
			SET @STAgreed=(SELECT STAgreed FROM #LEVEL2)
			SET @LTAgreed=(SELECT LTAgreed FROM #LEVEL2)
			SET @STRack=(SELECT STRack FROM #LEVEL2)
			SET @LTRack=(SELECT LTRack FROM #LEVEL2)
			SET @SingleMarkup=(SELECT SingleMarkup FROM #LEVEL2)
			SET @DoubleMarkup=(SELECT DoubleMarkup FROM #LEVEL2)
			SET @TripleMarkup=(SELECT TripleMarkup FROM #LEVEL2)
			
			
			
			
			SELECT @NewCheckInDate=convert(nvarchar(100),Cast(NewCheckInDate as DATE),103)	FROM WRBHBCheckInHdr  
		    WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId
		 
		    CREATE TABLE #Prop1(Property NVARCHAR(100),Stay NVARCHAR(100),Tariff DECIMAL(27,2),ChkoutDate NVARCHAR(100),
		    CheckInDate NVARCHAR(100),SingleMarkup DECIMAL(27,2),DoubleMarkup DECIMAL(27,2),TripleMarkup DECIMAL(27,2))   
		    
		    INSERT INTO  #Prop1(Property,Stay,Tariff,ChkoutDate,CheckInDate,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT Property,
			CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate1,103) as Stay,
			--((round(ISNULL(Tariff,0),0)))+(ISNULL(Tariff,0)*ISNULL(@STAgreed,0)/100)+(ISNULL(Tariff,0)*ISNULL(@LTAgreed,0)/100)+(ISNULL(Tariff,0)*ISNULL(@STRack,0)/100)+
			--(ISNULL(Tariff,0)*ISNULL(@LTRack,0)/100),0))) AS Tariff,
			((round(ISNULL(Tariff,0),0))) AS Tariff,
			CONVERT(nvarchar(100),@ChkOutDate1,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate,
			@SingleMarkup,0,0
			FROM WRBHBCheckInHdr
			WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId and Occupancy='Single';
			
			INSERT INTO  #Prop1(Property,Stay,Tariff,ChkoutDate,CheckInDate,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT Property,
			CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate1,103) as Stay,
			((round(ISNULL(Tariff,0),0))) AS Tariff,
			CONVERT(nvarchar(100),@ChkOutDate1,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate,
			0,@DoubleMarkup,0
			FROM WRBHBCheckInHdr
			WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId and Occupancy='Double';
			
			INSERT INTO  #Prop1(Property,Stay,Tariff,ChkoutDate,CheckInDate,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT Property,
			CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate1,103) as Stay,
			((round(ISNULL(Tariff,0),0))) AS Tariff,
			CONVERT(nvarchar(100),@ChkOutDate1,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate,
			0,0,@TripleMarkup
			FROM WRBHBCheckInHdr
			WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId and Occupancy='Triple';
			
			INSERT INTO  #Prop1(Property,Stay,Tariff,ChkoutDate,CheckInDate,SingleMarkup,DoubleMarkup,TripleMarkup)
			SELECT Property,
			CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate1,103) as Stay,
			((round(ISNULL(Tariff,0),0))) AS Tariff,
			CONVERT(nvarchar(100),@ChkOutDate1,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate,
			0,0,@TripleMarkup
			FROM WRBHBCheckInHdr
			WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId and Type='Bed';
			
			select Property,Stay,Tariff,ChkoutDate,CheckInDate
			from #Prop1 
			group by Property,Stay,Tariff,ChkoutDate,CheckInDate
		
		
	--BillDate 
			SELECT CONVERT(varchar(103),@ChkOutDate,103) as BillDate,convert(nvarchar(100),GETDATE(),103) as TodayDate
		
	--Type
			SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr
			WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
		
			SELECT ClientName,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,
			Id From  WRBHBCheckInHdr  
			WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
	--Day Count
			CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)
			INSERT INTO #CountDays (NoofDays,CheckInHdrId)
			SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,
			Id--,ArrivalDate
			FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;
		
	--	Tax Calculation in External Property 
			CREATE TABLE #ServiceTax(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT)

			CREATE TABLE #ServiceTax2(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT,
			DATE NVARCHAR(100))

			CREATE TABLE #ExTariff(Tariff DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),
			STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),LTRack decimal(27,2),
			Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),SingleMarkupAmount DECIMAL(27,2),
			DoubleMarkupAmount DECIMAL(27,2),TACPer DECIMAL(27,2))

			CREATE TABLE #FINALTAX(Tariff DECIMAL(27,2),STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),
			LTRack decimal(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
			Amount DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),BST DECIMAL(27,2),NetAmountTAC decimal(27,2),ST DECIMAL(27,2))

			CREATE TABLE #FINAL(Tariff DECIMAL(27,2),STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),
			LTRack decimal(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
			Amount DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),BST DECIMAL(27,2),NetAmountTAC decimal(27,2),ST DECIMAL(27,2))


			DECLARE @Occupancy NVARCHAR(100);
			SET @Occupancy=(SELECT Occupancy FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId)
		
	--IF @Occupancy = 'Single'
	--	BEGIN
	--		INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date)
	--		SELECT Tariff,RackSingle,0,STonAgreed,LTonAgreed,STonRack,LTonRack,Occupancy,convert(nvarchar(100),ChkInDt,103)
	--		FROM WRBHBBookingPropertyAssingedGuest
	--		WHERE IsActive = 1 AND IsDeleted = 0 
	--		AND GuestId = @GuestId and BookingId = @BookingId
	--	END	
	--IF	@Occupancy = 'Double'
	--	BEGIN
	--		INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date)
	--		SELECT Tariff,0,RackDouble,STonAgreed,LTonAgreed,STonRack,LTonRack,Occupancy,convert(nvarchar(100),ChkInDt,103)
	--		FROM WRBHBBookingPropertyAssingedGuest
	--		WHERE IsActive = 1 AND IsDeleted = 0 
	--		AND GuestId = @GuestId and BookingId = @BookingId
	--	END
-- Service Tax
			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		--	CONVERT(varchar(100),ISNULL(DateTo,GETDATE()+1),103)
			CONVERT(varchar(100),@ChkOutDate,103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),Date,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
			CONVERT(nvarchar(100),@ChkOutDate,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1


			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		--	CONVERT(varchar(100),ISNULL(DateTo,GETDATE()+1),103)
			CONVERT(varchar(100),@ChkOutDate,103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),DateTo,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
			CONVERT(nvarchar(100),@ChkOutDate,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1
			
		--	select @ChkOutDate

			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
	--		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()+1),103)
			CONVERT(varchar(100),@ChkOutDate,103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),@ChkInDate,103)	
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1
		
--Select @ChkOutDate;
			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		--	CONVERT(varchar(100),ISNULL(DateTo,GETDATE()+1),103)
			CONVERT(varchar(100),@ChkOutDate,103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),@ChkOutDate,103)<= CONVERT(nvarchar(100),DateTo,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1	
			group by ServiceTaxOnTariff,BusinessSupportST,Date,DateTo,Id
	 
	--select * from #ExTariff
	
	
			DECLARE @Tariff DECIMAL(27,2),@RackTariffSingle DECIMAL(27,2),@RackTariffDouble DECIMAL(27,2),@Dt1 DateTime ,@prtyId BIGINT,
			@chktime NVARCHAR(100),@TimeType NVARCHAR(100),@chkouttime NVARCHAR(100);
			DECLARE @DateDiff int,@i int,@HR NVARCHAR(100),@MIN INT,@OutPutSEC INT,@OutPutHour INT,@NoOfDays INT,
			--@STAgreed DECIMAL(27,2),@LTAgreed DECIMAL(27,2),@STRack DECIMAL(27,2),@LTRack DECIMAL(27,2),
			@SingleMarkupAmount DECIMAL(27,2),@DoubleMarkupAmount DECIMAL(27,2);
		
		
			SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1			
			FROM #ServiceTax;		
			WHILE (@DateDiff>=0)
			BEGIN
				INSERT INTO #ServiceTax2(ServiceTax,BusinessSupportST,FromDT,ToDT,DATE)
				SELECT TOP 1 ServiceTax,BusinessSupportST,FromDT,ToDT,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,FromDT,103)),103)
				FROM #ServiceTax
				SET @i=@i+1
				SET @DateDiff=@DateDiff-1			
				IF @DateDiff=0
				BEGIN
					DELETE FROM #ServiceTax
					WHERE Id IN(SELECT TOP 1 Id FROM #ServiceTax)
					SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(DAY, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1			
					FROM #ServiceTax;
				END
			END  
			DECLARE @BookingPropertyId BIGINT;  
			SELECT @BookingPropertyId=PropertyId FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId  
			SET @HR=(select CheckIn from WRBHBProperty where Id =@BookingPropertyId) 
			--SET @HR=(select CheckIn from WRBHBProperty where Id = @CheckInHdrId)
			--TARIFF SPLIT FOR CHECK IN TO CHECK OUT 
			
			
	-- this is for single markup amount add	(External )	
			SELECT TOP 1 @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,
			--@Tariff=Tariff,
			--@Tariff=((round(ISNULL(Tariff,0),0)+(ISNULL(Tariff,0)*ISNULL(@STAgreed,0)/100)+(ISNULL(Tariff,0)*ISNULL(@LTAgreed,0)/100)+(ISNULL(Tariff,0)*ISNULL(@STRack,0)/100)+
			--(ISNULL(Tariff,0)*ISNULL(@LTRack,0)/100),0))),
			@Tariff=((round(ISNULL(Tariff,0),0))),
			@RackTariffSingle=RackTariffSingle,
			@RackTariffDouble=RackTariffDouble,@i=0,@SingleMarkupAmount = @SingleMarkup,
			@DoubleMarkupAmount = @DoubleMarkup,
			--	@RackTariff=RackTariff,
			@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr 
			where Id=@CheckInHdrId and Occupancy='Single'
			
			
	-- this is for Double markup amount add	(External )		
			SELECT TOP 1 @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,
			--@Tariff=Tariff,
			@Tariff=((round(ISNULL(Tariff,0),0))),
			@RackTariffSingle=RackTariffSingle,
			@RackTariffDouble=RackTariffDouble,@i=0,@SingleMarkupAmount = @SingleMarkup,
			@DoubleMarkupAmount = @DoubleMarkup,
			--	@RackTariff=RackTariff,
			@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr 
			where Id=@CheckInHdrId and Occupancy='Double'
	-- this is for Triple markup amount add	(External )		
			SELECT TOP 1 @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,
			--@Tariff=Tariff,
			@Tariff=((round(ISNULL(Tariff,0),0))),
			@RackTariffSingle=RackTariffSingle,
			@RackTariffDouble=RackTariffDouble,@i=0,@SingleMarkupAmount = @SingleMarkup,
			@DoubleMarkupAmount = @DoubleMarkup,
			--	@RackTariff=RackTariff,
			@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr 
			where Id=@CheckInHdrId and Occupancy='Triple'
			
			SELECT TOP 1 @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,
			--@Tariff=Tariff,
			@Tariff=((round(ISNULL(Tariff,0),0))),
			@RackTariffSingle=RackTariffSingle,
			@RackTariffDouble=RackTariffDouble,@i=0,@SingleMarkupAmount = @SingleMarkup,
			@DoubleMarkupAmount = @DoubleMarkup,
			--	@RackTariff=RackTariff,
			@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr 
			where Id=@CheckInHdrId and Type='Bed'
			
			
			
		
			IF @HR='12'		
			BEGIN
			-- To Check Time
			SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
			CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
			CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+'12:00:00',CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
			CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
			CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+@chkouttime) AS M
			);
			IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END
			ELSE BEGIN SELECT @MIN AS M END	
	--this is 24 hour  for mat
			SELECT @DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60) 
	-- this is 12 hour Format	
		--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes 
			IF(UPPER(@TimeType)=UPPER('AM'))
			BEGIN
				IF(CAST(@chktime AS TIME)<CAST('11:00:00' AS TIME))
				BEGIN
					SELECT @NoOfDays=@NoOfDays+1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount,
					@TACPer
				--	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)
				END		 
			END		 
		 --GET AFTER 1 CL CHECKOUT TIME TARIFF ADD  AND ABOVE ONE HR TARIFF ADD  
			IF(@OutPutHour>12)
			BEGIN
				IF(@NoOfDays = 1)
				BEGIN
					SELECT @NoOfDays=@NoOfDays 
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount,@TACPer
				END
				ELSE
				BEGIN
					SELECT @NoOfDays=@NoOfDays + 1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount,@TACPer
				END
			
		 
		--	--SELECT @NoOfDays=@NoOfDays+1
		--	--INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
		--	--SingleMarkupAmount,DoubleMarkupAmount)
		--	--SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
		--	--CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount
		----	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
			END	
		 --DAYS TARIFF ADD	
		 			
			WHILE (@DateDiff>0)
			BEGIN	
					SELECT @NoOfDays=@NoOfDays+1					
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount,
					@TACPer
					--SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
					SET @i=@i+1
					SET @DateDiff=@DateDiff-1   
			
			 END
		     
			 END--hr end		
			 
			 ELSE 
			 BEGIN
		 --Get Date Differance
					SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
					CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
					CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+@chktime,CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
					CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
					CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+@chkouttime) AS M
					);
					IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END
					ELSE BEGIN SELECT @MIN AS M END	
					--this is 24 hour  for mat
					Select @i=0,@DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60) 
			-- this is 12 hour Format	
			--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes  		
		    
		   --ABOVE 1 HR IT WILL WORK
		   --select @OutPutHour;
			IF(@OutPutHour>12)
			BEGIN
			IF (@NoOfDays = 1)
				BEGIN
					SELECT @NoOfDays=@NoOfDays 
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount,@TACPer
				END
				ELSE
				BEGIN
					SELECT @NoOfDays=@NoOfDays + 1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount,TACPer)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount,@TACPer
				
				END
				
	--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		    END
		   
		   
		   
		    --DAYS TARIFF ADD
		  --  select @NoOfDays,@DateDiff
		    
			WHILE (@DateDiff>0)
			BEGIN	
				SELECT @NoOfDays=@NoOfDays 	+1			
				INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
				SingleMarkupAmount,DoubleMarkupAmount,TACPer)
				SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
				CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
				@DoubleMarkupAmount,@TACPer
	--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
				SET @i=@i+1
				SET @DateDiff=@DateDiff-1			               
			END			
		END		
		
	--	select * from #ExTariff
		--select * from #ServiceTax2
		
	--	SELECT @TariffPaymentMode;
	--	select @NoOfDays,@DateDiff
	
	--select @TAC
		IF @TariffPaymentMode IN('Bill to Company (BTC)','Bill to Client')
		BEGIN
		--select @TAC
			IF @TAC=0
				BEGIN
			--	
			--(RACK TARIFF SINGLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffSingle*LTRack)/100,0),
				ISNULL((RackTariffSingle*STRack)/100,0),Occupancy ,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.SingleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single'
				
				--(RACK TARIFF Double)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double'
				--(RACK TARIFF Triple)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Triple'
				
				set @TAC=1
			END
			ELSE
			BEGIN
			
			
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffSingle*LTRack)/100,0),
				ISNULL((RackTariffSingle*STRack)/100,0),Occupancy ,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.SingleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single'
			
				--(RACK TARIFF Double)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double'
				
				
				--(RACK TARIFF Triple)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Triple'
			--set @TAC=1
			END
		END
		--ELSE
		--BEGIN
		--IF @TAC=0
		--      BEGIN
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Single'
				
		--		--(RACK TARIFF Double)
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Double'
		--		set @TAC=0
		--	END
		--	ELSE
		--	BEGIN 
		
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Single'
				
		--		--(RACK TARIFF Double)
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Double'
		--			SET @TAC=0
		--	END
		--END
	--	select @TAC AS AC,@TariffPaymentMode;
	--	select * from #FINALTAX
--	select * from #ServiceTax2
	--select * from #ExTariff
	--select @TAC,@TACPer
		If @TariffPaymentMode ='Direct'
		BEGIN
			IF @TAC='0'
			BEGIN
				--(Agreed TARIFF SINGLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT d.Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.SingleMarkupAmount,0),
				isnull(d.SingleMarkupAmount*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.SingleMarkupAmount,0),h.ServiceTax
				FROM #ServiceTax2 h
				right outer join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single' AND ISNULL(h.ServiceTax,0)!=0
		
		--(Agreed TARIFF DOUBLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.DoubleMarkupAmount,0),
				isnull(d.DoubleMarkupAmount*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.DoubleMarkupAmount,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double' AND ISNULL(h.ServiceTax,0)!=0
				
				
		
		END
		ELSE
		BEGIN
		--(RACK TARIFF SINGLE)
		
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(@TACPer,0),
				isnull(@TACPer*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(@TACPer,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single' AND ISNULL(h.ServiceTax,0)!=0
		
		--(RACK TARIFF DOUBLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(@TACPer,0),
				isnull(@TACPer*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(@TACPer,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double' AND ISNULL(h.ServiceTax,0)!=0
		--SET @TAC=1
			END
		END
		
		
		
		--select * from #FINALTAX
		INSERT INTO #FINAL(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,BusinessSupportST,BST,NetAmountTAC,ST)
		SELECT SUM(ISNULL(Tariff,0)),SUM(ISNULL(STAgreed,0)),SUM(ISNULL(LTAgreed,0)),SUM(ISNULL(STRack,0)),
		SUM(ISNULL(LTRack,0)),Occupancy,SUM(ISNULL(ServiceTax,0)),(ISNULL(Amount,0)),SUM(ISNULL(BusinessSupportST,0)),
		ISNULL(BST,0),SUM(ISNULL(NetAmountTAC,0)),ISNULL(ST,0)
		FROM #FINALTAX
		GROUP BY Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,BusinessSupportST,
		BST,NetAmountTAC,ST
		
		
		SELECT @NoOfDays as NoofDays --FROM #Tariff
		
		SELECT DISTINCT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		BusinessSupportST,BST,NetAmountTAC ,ST FROM #FINAL
		group by TARIFF ,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		BusinessSupportST,BST,NetAmountTAC ,ST
		
	
		--select * from #FINAL
		--SELECT @TAC;
		--IF @TAC=0
		-- BEGIN
		 
		--	SELECT @NoOfDays as NoofDays --FROM #Tariff
		--	SELECT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--	BusinessSupportST,BST,NetAmountTAC ,ST FROM #FINAL where NetAmountTAC!=0
		--END
		--ELSE
		--BEGIN
		--select 'dsfsdf'
		--	SELECT @NoOfDays as NoofDays --FROM #Tariff
		--	SELECT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--	BusinessSupportST,BST,NetAmountTAC,ST FROM #FINAL where NetAmountTAC=0
		--END
	--END
	
		SELECT COUNT(Id) AS Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId   
		and IsActive = 1 and IsDeleted = 0 and ISNULL(Flag,0)= 0 
		 
		SELECT COUNT(d.CheckOutHdrId) AS Id2 FROM WRBHBChechkOutHdr h  
		JOIN WRBHBCheckOutServiceHdr d ON h.Id = d.CheckOutHdrId  
		and d.IsActive = 1 and d.IsDeleted = 0
		--join WRBHBCheckOutServiceDtls cs on d.Id= cs.CheckOutServceHdrId  
		WHERE h.ChkInHdrId= @CheckInHdrId  
		 and h.IsActive = 1 and h.IsDeleted = 0 and ISNULL(Flag,0)= 0
		 
		 
		SELECT top 1 Id  
		FROM WRBHBChechkOutHdr WHERE ChkInHdrId = @CheckInHdrId  and ISNULL(Flag,0)= 0
		order by Id desc
		 
		SELECT COUNT(Tariff) AS Tariff FROM #FINAL  
		
		CREATE TABLE #TariffSet(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  

		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCash d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCard d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCheque d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCompanyInvoice d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentNEFT d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		-- Service  
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 
		 
		 
		 INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and d.Payment='Service'  
		 and ISNULL(ch.Flag,0)= 0 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated'  and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  
		 
		 
		 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Consolidated'  and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Consolidated'  and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  



		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = ch.Id  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   
     
     
  
   --   DECLARE @TEMPConsolidate1 NVARCHAR(100)  
   --SELECT @TEMPConsolidate1=PaymentStatus FROM #TariffSet   
   --WHERE BillType='Consolidate'  
     
   --IF ISNULL(@TEMPConsolidate1,'')='Paid'  
   --BEGIN   
   -- DELETE FROM #TariffSet   
   -- WHERE BillType!='Consolidate'  
   --END   
  
  
		SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
		FROM  #TariffSet
		
		--Name  
		  SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		  WHERE ChkInHdrId=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   
	        and ISNULL(Flag,0)= 0 
	        
		  -- TARIFF FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND D.IsDeleted = 0   
		  AND H.ChkInHdrId = @CheckInHdrId  and ISNULL(h.Flag,0)= 0 
		  -- SERVICE FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		  FROM WRBHBCheckOutServiceHdr H  
		  JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.ChkInHdrId=@CheckInHdrId  and ISNULL(d.Flag,0)= 0 
		  -- CONSOLIDATE FOR ADD PAYMENTS  
		  SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND  
		  H.ChkInHdrId = @CheckInHdrId  and ISNULL(h.Flag,0)= 0 
	        
	        
		  SELECT COUNT(*) AS UnPaid FROM  #TariffSet  WHERE PaymentStatus = 'UnPaid'  
		 
    END  
	 else-- for checkout done with flag 0  
 begin  
 
 
		SELECT Property,Stay,ChkOutTariffAdays  AS Tariff,  
		CONVERT(NVARCHAR(100),CheckOutDate,103) AS ChkoutDate,CONVERT(NVARCHAR(100),CheckInDate,103) AS CheckInDate  
		FROM WRBHBChechkOutHdr WHERE  Id=@CID and  IsActive=1 and IsDeleted=0 and Flag=0  

		--BillDate   
		SELECT CONVERT(VARCHAR(103),CheckOutDate ,103) AS BillDate,convert(nvarchar(100),GETDATE(),103) as TodayDate   
		FROM WRBHBChechkOutHdr  WHERE   Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  

		--Type  
		SELECT GuestName AS Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr  
		WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  

		CREATE TABLE #PaymentMode1(TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100))  
		-- DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)  
  
  
		If @BookingLevel = 'Room'   
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode  
			  from WRBHBBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END  
		If @BookingLevel = 'Bed'  
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode   
			  from WRBHBBedBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END   
		If @BookingLevel = 'Apartment'  
		BEGIN  
			INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			select TariffPaymentMode,ServicePaymentMode   
			from WRBHBApartmentBookingPropertyAssingedGuest  
			where GuestId = @GuestId and BookingId = @BookingId  
		END  

		DECLARE @TariffPaymentModes nvarchar(100),@ServicePaymentModes nvarchar(100);  
		set @TariffPaymentModes =( SELECT top 1 TariffPaymentMode FROM #PaymentMode1)   
		set @ServicePaymentModes =( SELECT top 1 ServicePaymentMode FROM #PaymentMode1)  
		--SELECT ClientName,Direct,BTC,Id From  WRBHBCheckInHdr    
		--WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
    
		SELECT ClientName,@TariffPaymentModes as TariffPaymentMode,@ServicePaymentModes as ServicePaymentMode,  
		Id From  WRBHBCheckInHdr    
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
		--Day Count  
		CREATE TABLE #CountDays1(NoofDays INT,CheckInHdrId INT)  
		INSERT INTO #CountDays1(NoofDays,CheckInHdrId)  
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,  
		Id--,ArrivalDate  
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;  



		Select 0 as M;  

		Select NoOfDays from WRBHBChechkOutHdr  where  Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  

		select ChkOutTariffTotal NetTariff,ChkOutTariffLT LuxuryTax,  
		ChkOutTariffST1 ServiceTax,0 LT,0 ST  from WRBHBChechkOutHdr   
		where   Id=@CID and --IsActive=1 and IsDeleted=0 and 
		Flag=0  

		SELECT COUNT(Id) as Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId   
     
		SELECT COUNT(d.CheckOutHdrId) as Id2 from WRBHBChechkOutHdr h  
		join WRBHBCheckOutServiceHdr d on h.Id = d.CheckOutHdrId   
		where h.ChkInHdrId= @CheckInHdrId and h.  
		IsActive=1 and h.IsDeleted=0  
		SELECT Id from WRBHBChechkOutHdr   
		where Id=@CID and --IsActive=1 and IsDeleted=0 and 
		Flag=0  
		 
		select 1 as Tariff;--this is doubt value 
		 
		DECLARE @CheckOutId BIGINT;
		 
		 SELECT @CheckOutId=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 AND IsActive = 1 and IsDeleted = 0
		  
		CREATE TABLE #TariffSet1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId --AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId --AND d.IsActive=1 AND d.IsDeleted=0 
		
	
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId --AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId --AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId --AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSetFinal(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet1
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffs(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CID --AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id --AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CID --AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
		
		DECLARE @TSCOUNT  INT;
		SELECT @TSCOUNT=COUNT(*) FROM  #Tariffs
        
        IF @TSCOUNT=2
        BEGIN
			INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffs  
			group by BillNo
		END
		
		
		update #Tariffs set NetAmount=isnull(d.NetAmount,0),OutStanding=(t.Amount-isnull(d.NetAmount,0)) 
		from #Tariffs t
		left outer Join  #TariffSetFinal d on t.BillType=d.BillType
		
		
		DECLARE @TARIFAMT11 DECIMAL(27,2),@SERVICEAMT11 DECIMAL(27,2)  
		SET @TARIFAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1 where BillType='Tariff')  
		SET @SERVICEAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1  where BillType='Service')  
		-- select @TARIFAMT11,@SERVICEAMT11  
		--update #TariffSet1 set  NetAmount = @TARIFAMT11  where BillType='Tariff' ;  
		--update #TariffSet1 set  NetAmount = @SERVICEAMT11  where BillType='Service' ;  

		--CREATE TABLE #TafFin(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
        
		--INSERT INTO #TafFin(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,isnull(T1.Amount,0) Amount, (ISNULL(T2.NetAmount,0)) NetAmount,  
		--ISNULL(T1.Amount,0)-(ISNULL(T2.NetAmount,0)) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffs T1  
		--LEFT   JOIN #TariffSet1 T2 ON T1.BillType=T2.BillType  
		--group by T1.BillNo,T1.BillType,T1.Amount,T2.NetAmount,T1.PaymentStatus  
		
        update #Tariffs set PaymentStatus='Paid'  
        where Amount=NetAmount;  
        
       
        
		DECLARE @TARIFAMT DECIMAL(27,2),@SERVICEAMT DECIMAL(27,2),@CONSOLIAMT DECIMAL(27,2)  
		SET @TARIFAMT=(SELECT OutStanding from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT=(SELECT OutStanding from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT=(SELECT OutStanding from #Tariffs  where BillType='Consolidate')  

		DECLARE @TARIFAMT1 DECIMAL(27,2),@SERVICEAMT1 DECIMAL(27,2),@CONSOLIAMT1 DECIMAL(27,2)  
		SET @TARIFAMT1=(SELECT NetAmount from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT1=(SELECT NetAmount from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT1=(SELECT NetAmount from #Tariffs  where BillType='Consolidate')  
        
     
           
		DELETE  FROM   #Tariffs  WHERE BillType='Consolidate'  
		and round((@TARIFAMT1+@SERVICEAMT1),0)!=0  

		DECLARE @TEMPConsolidate NVARCHAR(100),@Netamount1 decimal(27,2)  
		SELECT @TEMPConsolidate=PaymentStatus FROM #Tariffs   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate,'')='Paid'  
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END 

		SELECT @Netamount1=NetAmount FROM #Tariffs   
		WHERE BillType='Consolidate' 

		IF cast(ISNULL(@Netamount1,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END
		 
        SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id FROM #Tariffs; 
         
		 
		SELECT  Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CID --AND IsActive=1 AND IsDeleted=0   
		GROUP BY Name

		-- TARIFF FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@TARIFAMT,0),0) AS ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive = 1 AND D.IsDeleted = 0 AND 
		H.Id = @CID  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@SERVICEAMT,0),0) AS ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE-- H.IsActive=1 AND H.IsDeleted=0 AND 
		D.Id=@CID;  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL( ROUND((@TARIFAMT+@SERVICEAMT),0),0) AS ConsolidateAmount 
		--FROM #Tariffs  
		--WHERE ROUND((@TARIFAMT+@SERVICEAMT),0)!=0  
		--SELECT 1 AS Paid;    
		
		SELECT COUNT(*) AS UnPaid FROM  #Tariffs  WHERE PaymentStatus = 'UnPaid'  
		
		
		END  
	 END 	
END			
			 
		
	IF @Action='IMAGEUPLOAD'  
	BEGIN 
		UPDATE WRBHBChechkOutPaymentCompanyInvoice SET FileLoad=@Str1 
		WHERE Id=@CheckInHdrId ---CompanyInvoice Id IS IN @CheckInHdrId
	END 
	IF @Action='Print'
		BEGIN
	
		DECLARE @CheckOutId1 BIGINT;
		 
		 --SELECT @CheckOutId1=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 --AND IsActive = 1 and IsDeleted = 0
		
		  select @CheckOutId1=@CheckInHdrId
		  
		 
		  
		CREATE TABLE #TariffSet2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSetFinal2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet2
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffsa(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckOutId1 
		--AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id --AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckOutId1 --AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
  
    
        DECLARE @TSCOUNT1  INT;
		SELECT @TSCOUNT1=COUNT(*) FROM  #Tariffsa
        
        IF @TSCOUNT1=2
        BEGIN
			INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffsa  
			group by BillNo
		END
		
		
		
		update #Tariffsa set NetAmount=d.NetAmount,OutStanding=(t.Amount-d.NetAmount) 
		from #Tariffsa t
		Join  #TariffSetFinal2 d on t.BillType=d.BillType 

		
		
		dECLARE @TARIFAMT111 DECIMAL(27,2),@SERVICEAMT111 DECIMAL(27,2)  
		SET @TARIFAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2 where BillType='Tariff')  
		SET @SERVICEAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2  where BillType='Service')  
		--select @TARIFAMT111,@SERVICEAMT111  
		update #TariffSet2 set  NetAmount = @TARIFAMT111  where BillType='Tariff' ;  
		update #TariffSet2 set  NetAmount = @SERVICEAMT111  where BillType='Service' ;  
   

		CREATE TABLE #TafFin1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,T1.Amount,ISNULL(T2.NetAmount,0) NetAmount,  
		--ISNULL(T1.Amount,0)-ISNULL(T2.NetAmount,0) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffsa T1  
		--left  outer  JOIN #TariffSet2 T2 ON T1.BillType=T2.BillType  
         
        
       
       
		--CREATE TABLE #TafFin22(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin22(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--select BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus   
		--from  #TafFin1 		
		--group by BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus ;  
		--  select * from #TafFin22  

		dECLARE @TARIFAMTs DECIMAL(27,2),@SERVICEAMTs DECIMAL(27,2)  
		SET @TARIFAMTs=(SELECT OutStanding from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMTs=(SELECT OutStanding from #Tariffsa  where BillType='Service')  
		

		dECLARE @TARIFAMT1s DECIMAL(27,2),@SERVICEAMT1s DECIMAL(27,2)  
		SET @TARIFAMT1s=(SELECT NetAmount from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMT1s=(SELECT NetAmount from #Tariffsa  where BillType='Service')  

		  
		   
		delete  from   #Tariffsa  where BillType='Consolidate'  
		and round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  

		DECLARE @TEMPConsolidate1 NVARCHAR(100),@Netamount decimal(27,2),@PamentMode Nvarchar(100)   
		SELECT @TEMPConsolidate1=PaymentStatus FROM #Tariffsa   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate1,'') = 'Paid'  
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END   
		
		SELECT @Netamount=sum(NetAmount) FROM #Tariffsa   
		WHERE BillType='Consolidate' 


		IF cast(ISNULL(@Netamount,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END  
		
		update #Tariffsa set PaymentStatus='Paid'  
		where Amount=@Netamount;
		   --select * from #TafFin22
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #Tariffs  
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #TariffSet1  
		
		Select  BillNo,BillType,Amount,SUM(NetAmount) NetAmount,Amount-SUM(NetAmount) OutStanding,PaymentStatus,
		0 AS Id from #Tariffsa
		group by BillNo,BillType,Amount,PaymentStatus
		
      --Name  
        
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE ChkInHdrId=@PropertyId AND IsActive=1 AND IsDeleted=0   

		-- TARIFF FOR ADD PAYMENTS   
		--@PropertyId(CheckOut Id Temp... send)  
		SELECT isnull(round(@TARIFAMTs,0),0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive = 1 AND D.IsDeleted = 0  AND 
		H.Id = @PropertyId  

		-- SERVICE FOR ADD PAYMENTS  
		SELECT isnull(round(@SERVICEAMTs,0),0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id-- AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive=1 AND H.IsDeleted=0 AND 
		D.Id=@PropertyId;  
		-- CONSOLIDATE FOR ADD PAYMENTS  

		SELECT distinct isnull(round((@TARIFAMT1s+@SERVICEAMT1s),0),0) AS ConsolidateAmount 
		--from #TafFin22  
		--WHERE round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  
		
		    
	END	
		
IF @Action='Prints'  
  BEGIN   
		CREATE TABLE #Tariff1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
     
     
        -- CAST(ISNULL(KH.TotalAmount,0)as DECIMAL(27,2)) AS Amount  
           
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT  DISTINCT CH.CheckOutNo,'Service' AS BillType,round(ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckInHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  


		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT DISTINCT CO.CheckOutNo,'Consolidate' AS BillType,round(CO.ChkOutTariffNetAmount+CS.ChkOutServiceNetAmount,0) AS Amount,  
		0.00 AS NetAmount,  
		0.00 as OutStanding,'Unpaid' as PaymentStatus   
		FROM WRBHBChechkOutHdr CO  
		JOIN WRBHBCheckOutServiceHdr CS ON CO.Id=CS.CheckOutHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  
		WHERE CO.Id=@CheckInHdrId AND CO.IsActive=1 AND CO.IsDeleted=0;  

		SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
			 FROM  #Tariff1   
         
        
      --Name  
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   


		-- TARIFF FOR ADD PAYMENTS  
		SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND D.IsDeleted = 0   
		AND H.Id = @CheckInHdrId  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.Id=@CheckInHdrId  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND  
		H.Id = @CheckInHdrId  
        
        
  END   
  
  IF @Action='PaidUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,Flag = 1
	   WHERE ChkInHdrId = @CheckInHdrId 
	   --UPDATE WRBHBExternalChechkOutTAC set PaymentStatus = 'Paid'  
	   --WHERE ChkInHdrId = @CheckInHdrId  
  END   
IF @Action='ServiceUpdate'  
  BEGIN  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  
  END   
IF @Action='ConUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'UnPaid'  
	   WHERE ChkInHdrId = @CheckInHdrId  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'UnPaid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  END 
		
If @Action='TariffIntermediate'  
BEGIN
	
    DECLARE @CheckOutId2 BIGINT,@CheckOutId22 BIGINT;
    DECLARE @IntemediateChkoutDt NVARCHAR(100),@PayeeName NVARCHAR(100),@Address NVARCHAR(4000),
	@Consolidated BIT,@CreatedBy BIGINT
    SET @CheckOutId2 =  (SELECT TOP 1 Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId 
    and IsActive= 1 and IsDeleted = 0  order by Id desc) 
    SET @CheckOutId22 =  (SELECT TOP 1 Id  FROM WRBHBExternalChechkOutTAC WHERE ChkInHdrId=@CheckInHdrId 
    and IsActive= 1 and IsDeleted = 0  order by Id desc) 
    SET @IntemediateChkoutDt = (SELECT TOP 1 CONVERT(DATE,BillEndDate,103)  FROM WRBHBChechkOutHdr
     WHERE ChkInHdrId=@CheckInHdrId order by Id desc)
     
     
    SET @PayeeName =(select top 1 GuestName from WRBHBChechkOutHdr where ChkInHdrId=@CheckInHdrId order by Id desc)
  --  SET @Consolidated = 
    
   
	--UPDATE WRBHBCheckInHdr SET NewCheckInDate = @IntemediateChkoutDt 
	--WHERE Id = @CheckInHdrId  
	
	UPDATE WRBHBChechkOutHdr SET PaymentStatus = 'Paid' ,Flag = 1,Status='CheckOut' ,IsActive = 1 
	WHERE Id = @CheckOutId2 
	
	UPDATE WRBHBExternalChechkOutTAC SET PaymentStatus = 'Paid' ,Status='CheckOut',Flag = 1 ,IsActive = 1 
	WHERE Id = @CheckOutId22 
	
	UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'  ,IsActive = 1  
	WHERE CheckOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCash SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCard SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCheque SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCompanyInvoice SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentNEFT SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	-- Settlement table insert 
	CREATE TABLE #TEMPCHKHDR(ChkOutHdrId INT,PayeeName NVARCHAR(100),AddressS NVARCHAR(4000),
	Consolidated BIT,CreatedBy BIGINT,ModifiedBy BIGINT,Payment nvarchar(100),AmountPaid decimal(27,2),StatusId Bigint)

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)

	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCash
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCard
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCheque
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCompanyInvoice
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentNEFT
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2
	--Insert into main table
	INSERT INTO WRBHBCheckOutSettleHdr(ChkOutHdrId,PayeeName,Address,Consolidated,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	Select Distinct ChkOutHdrId,PayeeName,AddressS,0,CreatedBy,GETDATE(),ModifiedBy,GETDATE(),1,0,NEWID()
	from #TEMPCHKHDR

	DEclare @CkstlHdrid Bigint;
	SET @CkstlHdrid=@@IDENTITY;

	--SELECT Id FROM WRBHBCheckOutSettleHdr WHERE Id=@CkstlHdrid;


	INSERT INTO WRBHBCheckOutSettleDtl(CheckOutSettleHdrId,PropertyId,GuestId,BillNo,BillType,
	BillAmount,NetAmount,OutStanding,PaymentStatus,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	Select @CkstlHdrid,0 as prptyId,0 as GuestId,0 as BillNO, Payment Billtype,
	AmountPaid,AmountPaid,0 as Outstand,'Paid' Status,
	CreatedBy,GETDATE(),CreatedBy,GETDATE(),1,0,NEWID()
	from #TEMPCHKHDR
	group by Payment,AmountPaid,CreatedBy
	
	
	
END		



IF @Action='IMAGEUPLOAD'  
  BEGIN 
		UPDATE WRBHBChechkOutPaymentCompanyInvoice SET FileLoad=@Str1 
		WHERE Id=@CheckInHdrId ---CompanyInvoice Id IS IN @CheckInHdrId
  END 