SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_TodaysCheckinChkout_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_TodaysCheckinChkout_Help]
GO
/*=============================================
Author Name  : mini
Created Date :  
Section  	 : Report
Purpose  	 :  
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_TodaysCheckinChkout_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL, 
@Id1 INT=NULL,
@Id2 INT=NULL, 
@UserId INT=NULL
)
AS
BEGIN
IF @Action ='ClientDtls'
Begin
     SELECT ClientName,Id FROM WRBHBClientManagement 
     WHERE IsActive=1 AND IsDeleted=0;
     
     Select Convert(Nvarchar(100),GETDATE(),103) as TodayDate;
End
IF @Action ='Pageload'
BEGIN
 Create table #Temp(id Bigint,FirstName nvarchar(500),clientname nvarchar(500),
 HotalName nvarchar(500),MobileNo nvarchar(500), EmailId nvarchar(500),City nvarchar(500),
 CheckinDate nvarchar(500),ChkOutDt nvarchar(500),Sno Bigint identity(1,1) not null primary key,
 ClientId Bigint,BookingCode Nvarchar(500),GuestId Bigint,BookingLevel NVARCHAR(200),Category NVARCHAR(100),
 StayDays Bigint,BookedDate Nvarchar(100))

 Create table #Temps(id Bigint,FirstName nvarchar(500),clientname nvarchar(500),
 HotalName nvarchar(500),MobileNo nvarchar(500), EmailId nvarchar(500),City nvarchar(500),
 CheckinDate nvarchar(100),ChkOutDt nvarchar(100),Sno Bigint identity(1,1) not null primary key,
 ClientId Bigint,BookingCode Nvarchar(500),GuestId Bigint,BookingLevel NVARCHAR(200),Category NVARCHAR(100),
 StayDays Bigint,BookedDate Nvarchar(100))
 
  Create table #FinalSelect(id Bigint,FirstName nvarchar(500),clientname nvarchar(500),
 HotalName nvarchar(500),MobileNo nvarchar(500), EmailId nvarchar(500),City nvarchar(500),
 CheckinDate nvarchar(100),ChkOutDt nvarchar(100),Sno Bigint identity(1,1) not null primary key,
 ClientId Bigint,BookingCode Nvarchar(500),GuestId Bigint,BookingLevel NVARCHAR(200),Category NVARCHAR(100),
 StayDays Bigint,BookedDate Nvarchar(100),Statu Nvarchar(100))
 
 --Expected CHECKIN	-- SELECT TOP 10 H.ClientName ,CityName,D.FirstName FirstName,BookingLevel  
  if(@Str1='Booking') or (@Str1='All')
 Begin	     
		CREATE TABLE #ExpChkin(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,BookingCode BIGINT,
		Category NVARCHAR(100), GuestId Bigint)--,Email Nvarchar(200),Mobile Nvarchar(50),CheckoutDate);
	   
	 	TRUNCATE TABLE #ExpChkin;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
       ClientName,ClientId,BookingCode,Category,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,AG.GuestId
		FROM WRBHBBooking H 
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
	    WHERE   AG.CurrentStatus='Booked'
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkInDt,103)<=CONVERT(date,GETDATE(),103)
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,AG.GuestId
		order by H.Id desc
		
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
     ClientName,ClientId,BookingCode,Category,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.GuestId
		FROM WRBHBBooking H 
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = Ag.BookingPropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		--JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		--JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
      --  JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Booked'
		and H.Cancelstatus !='Canceled' AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin)
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.GuestId
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
      ClientName,ClientId,BookingCode,Category,GuestId)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.GuestId
		 FROM WRBHBBooking H 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 and CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,p.Id,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.GuestId
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
 	 ClientName,ClientId,BookingCode,Category,GuestId)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		  convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  P.Category,ABPA.GuestId
		  FROM WRBHBBooking H 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		-- JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		-- JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		-- JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin)
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.GuestId
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,GuestId)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.GuestId
		 FROM WRBHBBooking H 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		-- JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		--- JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		-- JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		and  CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.GuestId
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,GuestId)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.GuestId
		 FROM WRBHBBooking H 
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.ID=ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 -- JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 -- JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0 
		 -- JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled' and ABPA.CurrentStatus='Booked'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin)-- and P.Category in ('Internal Property') 
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.GuestId
		 order by H.Id desc 
    --#GRID VALUES 1 FOR TABLE0 
 
Insert into #Temps(id,FirstName,clientname,HotalName,
MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate )

Select Distinct C.id,ag.FirstName,C.clientname,S.HotalName,
H.MobileNo, EmailId as Email,S.City,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
convert(nvarchar(100),Ag.ChkOutDt,103),c.ClientId ,c.BookingCode,Ag.guestid,BookingLevel,'MMT',
DateDiff(day, CONVERT(date,Ag.ChkInDt,103),CONVERT(date,Ag.ChkOutDt,103)) as nodays,
--Cast(Convert(date,C.BookedDt,103) as Nvarchar(100))
 Convert(NVARCHAR(100),CAST(C.BookedDt as DATE),103) AS Date
 from wrbhbbooking C
  join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId 
 left outer join  WRBHBBookingGuestDetails H on C.id=H.Bookingid   and Ag.Guestid=H.Guestid
 where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)  --and c.Id=3787
group by C.id,C.clientname,ag.FirstName,Ag.ChkInDt,aG.ID,C.ClientId,BookingLevel,c.BookedDt,--Category,StayDays,
Ag.BookingPropertyId,H.MobileNo, EmailId ,S.City,S.HotalName,Ag.ChkOutDt,aG.cURRENTsTAtus,c.BookingCode,Ag.guestid
   --order by BookingCode desc;
 Insert into #Temps(id,FirstName,clientname,HotalName,
MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate)    
      select B.Id ,GuestName as GuestName,B.ClientName as Company ,PropertyName+' - '+B.CityName Property,
      H.MobileNo, EmailId as Email,B.CityName,--H.guestid,F.guestid,
      Convert(nvarchar(100),ExpDate,103) CheckinDate ,Convert(nvarchar(100),B.CheckoutDate,103) CheckoutDate,
      B.ClientId,B.BookingCode,f.GuestId,F.BookingLevel,Category,
      DateDiff(day, CONVERT(date,ExpDate,103),CONVERT(date,B.CheckoutDate,103)) as nodays,--F.GuestName,h.fIRSTnAME
       Convert(NVARCHAR(100),CAST(B.BookedDt as DATE),103) AS Date
      from #ExpChkin F
      LEFT OUTER join WRBHBBookingGuestDetails H on F.BookedId=H.Bookingid AND h.GuestId=F.GuestId
      and H.IsActive = 1 and H.IsDeleted = 0
      LEFT OUTER join WRBHBBooking B  on B.Id=F.BookedId  AND  h.BookINGId=F.BookedId and B.IsActive = 1 and B.IsDeleted = 0
      --  left join WRBHBCity C on c.Id=F.CityId and C.IsActive = 1 
      where H.Id NOT IN(SELECT BookedId FROM #Temps)--Convert(date,ExpDate,103)= CONVERT(date,GETDATE(),103)--- AND Category='Managed G H'
      and Convert(date,ExpDate,103)>= CONVERT(date,'01/09/2014',103)   --b.ClientId=1921 
      group by PropertyName,GuestName,   ExpDate,B.CityName ,B.ClientName,Category,H.MobileNo,B.Id ,
      EmailId,B.CheckoutDate,B.ClientId,B.BookingCode,F.guestid--,F.GuestName,h.fIRSTnAME,H.guestid 
      ,F.BookingLevel,Category ,B.BookedDt
       order by BookingCode desc;
     -- Select * from #ExpChkin where BookedId=3787
     --select CONVERT(date,CheckinDate,103)  FROM #Temps

	 If(@Id1!=0)
		  Begin
			Insert into #Temp(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
			ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate)
			
			Select id,FirstName,clientname,HotalName,
			MobileNo, EmailId,City, CONVERT(varchar(100),CheckinDate,103) 
			CheckinDate, CONVERT(varchar(100),ChkOutDt,103)
			ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate
			from #Temps where   CONVERT(date,CheckinDate,103)  --=  CONVERT(date,'4/11/2014',103)
			between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103)	and ClientId=@Id1 
			order by CheckinDate;
			
	   Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	   ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
			
		Select id,FirstName,clientname as ClientName,HotalName PropertyName,
		MobileNo, EmailId,City CityName,Convert(Nvarchar(100),CheckinDate,103) ChkinDate,
		Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate,SNo,BookingCode,BookingLevel,Category,StayDays,BookedDate,'Booking'
		from #Temp
		Group by id,FirstName,clientname ,HotalName,MobileNo, EmailId,City ,CheckinDate,
		ChkOutDt, SNo, BookingCode,BookingLevel,Category,StayDays,BookedDate
		End
		 If(@Id1=0)
		  Begin
			Insert into #Temp(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
			ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate)
			Select id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
			ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate
			from #Temps where   CONVERT(date,CheckinDate,103) 
			between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103)
			order by BookingCode desc;
			
	   Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	   ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
		Select id,FirstName,clientname as ClientName,HotalName PropertyName,
		MobileNo, EmailId,City CityName,Convert(Nvarchar(100),CheckinDate,103) ChkinDate,
		Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate, SNo, BookingCode,
		BookingLevel,Category,StayDays,BookedDate,'Booking'
		from #Temp  
		Group by id,FirstName,clientname ,HotalName,MobileNo, EmailId,City ,CheckinDate,
		ChkOutDt, SNo, BookingCode,BookingLevel,Category,StayDays,BookedDate
		End
	END	
    
    if(@Str1='CheckIn')or (@Str1='All')
    Begin	
    --#Checkout Today
      CREATE TABLE #ExpChkind(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,BookingCode BIGINT,
		Category NVARCHAR(100),CheckoutDate Nvarchar(100),GuestId Bigint)--,Email Nvarchar(200),Mobile Nvarchar(50),CheckoutDate);
	  
	 	TRUNCATE TABLE #ExpChkind;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
       ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,convert(nvarchar(100),AG.ChkOutDt,103),GuestId
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='CheckIn'
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkOutDt,103) =CONVERT(date,GETDATE(),103) 
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,AG.ChkOutDt,GuestId
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
     ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,convert(nvarchar(100),AG.ChkOutDt,103),GuestId
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = Ag.BookingPropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='CheckIn'
		and H.Cancelstatus !='Canceled' AND H.Id NOT IN(SELECT BookedId FROM #ExpChkind)  
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.ChkOutDt,GuestId
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
      ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and CONVERT(date,ABPA.ChkOutDt,103) = CONVERT(date,GETDATE(),103) 
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,p.Id,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,GuestId 
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
 	 ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		  convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId 
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkind) 
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId 
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and  CONVERT(date,ABPA.ChkOutDt,103) = CONVERT(date,GETDATE(),103)  
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkind(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103) ,GuestId
		 FROM WRBHBBooking H
		-- JOIN WRBHBBedBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND	 ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.ID=ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0 
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled' and ABPA.CurrentStatus='CheckIn'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkind)-- and P.Category in ('Internal Property') 
	 	 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc 
    --#GRID VALUES 1 FOR TABLE0 
     
		Truncate Table #Temps;
Insert into #Temps(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate )

	Select Distinct C.id,ag.FirstName,C.clientname,S.HotalName,
	H.MobileNo, EmailId as Email,S.City,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
	convert(nvarchar(100),Ag.ChkOutDt,103),c.ClientId ,c.BookingCode,Ag.guestid,
	BookingLevel,'MMT', DateDiff(day, CONVERT(date,Ag.ChkInDt,103),CONVERT(date,Ag.ChkOutDt,103)),
    Convert(NVARCHAR(100),CAST(C.BookedDt as DATE),103) AS Date
	from wrbhbbooking C
	join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
	join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId 
	left outer join  WRBHBBookingGuestDetails H on C.id=H.Bookingid   and Ag.Guestid=H.Guestid
	where Convert(date,Ag.ChkOutDt,103)>= CONVERT(date,'01/09/2014',103)  --and c.Id=3787
	and AG.CurrentStatus='CheckIn'
	group by C.id,C.clientname,ag.FirstName,Ag.ChkInDt,aG.ID,C.ClientId,
	Ag.BookingPropertyId,H.MobileNo, EmailId ,S.City,S.HotalName,Ag.ChkOutDt, c.BookingCode,Ag.guestid,
	BookingLevel,C.BookedDt 


Insert into #Temps(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate) 

	select B.Id ,GuestName as GuestName,B.ClientName as ClientName ,PropertyName+' - '+B.CityName Property,
	H.MobileNo, EmailId as Email,B.cityName, Convert(nvarchar(100),ExpDate,103) CheckinDate ,
	Convert(nvarchar(100),F.CheckoutDate,103) CheckoutDate,B.ClientId,B.BookingCode,H.GuestId,
	F.BookingLevel,Category, DateDiff(day, CONVERT(date,ExpDate,103),CONVERT(date,F.CheckoutDate,103)) ,
	 Convert(NVARCHAR(100),CAST(B.BookedDt as DATE),103) AS Date	  
	from #ExpChkind F
	LEFT OUTER join WRBHBBookingGuestDetails H on F.BookedId=H.Bookingid AND F.GuestId=h.GuestId
	and H.IsActive = 1 and H.IsDeleted = 0
	LEFT OUTER join WRBHBBooking B  on B.Id=F.BookedId  AND  h.BookINGId=F.BookedId and B.IsActive = 1 and B.IsDeleted = 0
	-- left join WRBHBCity C on c.Id=F.CityId and C.IsActive = 1 
	where Convert(date,F.CheckoutDate,103)>= CONVERT(date,'01/09/2014',103)--- AND Category='Managed G H' 
	group by PropertyName,GuestName,   ExpDate,F.CityName ,B.ClientName,Category,H.MobileNo,B.Id ,
	EmailId,F.CheckoutDate,B.cityName,B.ClientId,B.BookingCode,H.GuestId,F.BookingLevel,Category,B.BookedDt --,B.CheckoutDate
	order by BookingCode desc;

	    Truncate Table #Temp; 
	 If(@Id1!=0)
	  Begin
	 
	   Insert into #Temp(id,FirstName,clientname,HotalName,
	   MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,bookedDate)
			Select id,FirstName,clientname,HotalName,
			MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,
		    BookingLevel,Category,StayDays,bookedDate
			from #Temps where ClientId=@Id1 and CONVERT(date,ChkOutDt,103)
			between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103)  and clientname!=''
			order by BookingCode desc;
			
	   Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	   ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
	   
			Select id,FirstName,clientname as ClientName,HotalName PropertyName,MobileNo, EmailId,City CityName,
			Convert(Nvarchar(100),CheckinDate,103) ChkinDate,Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate,
			 SNo ,BookingCode,BookingLevel,Category,StayDays,BookedDate,'CheckIn'
			from #Temp  where   clientname!=''
			group by id,FirstName,clientname,HotalName,	MobileNo, EmailId,City,CheckinDate,ChkOutDt,
			ClientId,BookingCode,GuestId,SNo,BookingLevel,Category,StayDays,BookedDate 
 End
 
	  If(@Id1=0)
		  Begin
	  Insert into #Temp(id,FirstName,clientname,HotalName,
	  MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate)
			Select id,FirstName,clientname,HotalName,
			MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,
			BookingLevel,Category,StayDays,BookedDate
			from #Temps  where    CONVERT(date,ChkOutDt,103) between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103) 	 and clientname!=''
			order by BookingCode desc;
			
	  Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	  ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
			Select id,FirstName,clientname as ClientName,HotalName PropertyName,MobileNo, EmailId,City CityName,
			Convert(Nvarchar(100),CheckinDate,103) ChkinDate,Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate,
			 SNo ,BookingCode,BookingLevel,Category,StayDays,BookedDate,'CheckIn'
			from #Temp 
			group by id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,ChkOutDt,
			ClientId,BookingCode,GuestId ,SNo,BookingLevel,Category,StayDays ,BookedDate
		End
      
    END
  
    if(@Str1='Checkout')or (@Str1='All')
    Begin	
    --#Checkout Today
      CREATE TABLE #ExpBooking(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,BookingCode BIGINT,
		Category NVARCHAR(100),CheckoutDate Nvarchar(100),GuestId Bigint)--,Email Nvarchar(200),Mobile Nvarchar(50),CheckoutDate);
	  
	 	TRUNCATE TABLE #ExpBooking;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
       ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,convert(nvarchar(100),AG.ChkOutDt,103),GuestId
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Checkout'
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkOutDt,103) =CONVERT(date,GETDATE(),103) 
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,AG.ChkOutDt,GuestId
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
     ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,convert(nvarchar(100),AG.ChkOutDt,103),GuestId
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = Ag.BookingPropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Checkout'
		and H.Cancelstatus !='Canceled' AND H.Id NOT IN(SELECT BookedId FROM #ExpBooking)  
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.ChkOutDt,GuestId
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
      ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Checkout'
		 and CONVERT(date,ABPA.ChkOutDt,103) = CONVERT(date,GETDATE(),103)
		-- and pu.UserId=65
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,p.Id,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,GuestId 
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
 	 ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		  convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId 
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Checkout'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpBooking) 
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103),GuestId 
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Checkout'
		 and  CONVERT(date,ABPA.ChkOutDt,103) = CONVERT(date,GETDATE(),103)  
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpBooking(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,Category,CheckoutDate,GuestId)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,convert(nvarchar(100),ABPA.ChkOutDt,103) ,GuestId
		 FROM WRBHBBooking H
		-- JOIN WRBHBBedBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND	 ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.ID=ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0 
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled' and ABPA.CurrentStatus='Checkout'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpBooking)-- and P.Category in ('Internal Property')  
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,GuestId
		 order by H.Id desc 
    --#GRID VALUES 1 FOR TABLE0 
     
		Truncate Table #Temps;
Insert into #Temps(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate )

	Select Distinct C.id,ag.FirstName,C.clientname,S.HotalName,
	H.MobileNo, EmailId as Email,S.City,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
	convert(nvarchar(100),Ag.ChkOutDt,103),c.ClientId ,c.BookingCode,Ag.guestid,
	BookingLevel,'MMT', DateDiff(day, CONVERT(date,Ag.ChkInDt,103),CONVERT(date,Ag.ChkOutDt,103)),
    Convert(NVARCHAR(100),CAST(C.BookedDt as DATE),103) AS Date
	from wrbhbbooking C
	join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
	join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId 
	left outer join  WRBHBBookingGuestDetails H on C.id=H.Bookingid   and Ag.Guestid=H.Guestid
	where Convert(date,Ag.ChkOutDt,103)>= CONVERT(date,'01/09/2014',103)  --and c.Id=3787
	and AG.CurrentStatus='Checkout'
	group by C.id,C.clientname,ag.FirstName,Ag.ChkInDt,aG.ID,C.ClientId,
	Ag.BookingPropertyId,H.MobileNo, EmailId ,S.City,S.HotalName,Ag.ChkOutDt, c.BookingCode,Ag.guestid,
	BookingLevel,C.BookedDt 


Insert into #Temps(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
ChkOutDt,ClientId,BookingCode,GuestId,BookingLevel,Category,StayDays,BookedDate) 

	select B.Id ,GuestName as GuestName,B.ClientName as ClientName ,PropertyName+' - '+B.CityName Property,
	H.MobileNo, EmailId as Email,B.cityName, Convert(nvarchar(100),ExpDate,103) CheckinDate ,
	Convert(nvarchar(100),F.CheckoutDate,103) CheckoutDate,B.ClientId,B.BookingCode,H.GuestId,
	F.BookingLevel,Category, DateDiff(day, CONVERT(date,ExpDate,103),CONVERT(date,F.CheckoutDate,103)) ,
	 Convert(NVARCHAR(100),CAST(B.BookedDt as DATE),103) AS Date	  
	from #ExpBooking F
	LEFT OUTER join WRBHBBookingGuestDetails H on F.BookedId=H.Bookingid AND F.GuestId=h.GuestId
	and H.IsActive = 1 and H.IsDeleted = 0
	LEFT OUTER join WRBHBBooking B  on B.Id=F.BookedId  AND  h.BookINGId=F.BookedId and B.IsActive = 1 and B.IsDeleted = 0
	-- left join WRBHBCity C on c.Id=F.CityId and C.IsActive = 1 
	where Convert(date,F.CheckoutDate,103)>= CONVERT(date,'01/09/2014',103)--- AND Category='Managed G H' 
	group by PropertyName,GuestName,   ExpDate,F.CityName ,B.ClientName,Category,H.MobileNo,B.Id ,
	EmailId,F.CheckoutDate,B.cityName,B.ClientId,B.BookingCode,H.GuestId,F.BookingLevel,Category,B.BookedDt --,B.CheckoutDate
	order by BookingCode desc;

	    Truncate Table #Temp; 
	 If(@Id1!=0)
	  Begin
	 
	   Insert into #Temp(id,FirstName,clientname,HotalName,
	   MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,bookedDate)
			Select id,FirstName,clientname,HotalName,
			MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,
		    BookingLevel,Category,StayDays,bookedDate
			from #Temps where ClientId=@Id1 and CONVERT(date,ChkOutDt,103)
			between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103)  and clientname!=''
			order by BookingCode desc;
			
	   Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	   ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
	   
			Select id,FirstName,clientname as ClientName,HotalName PropertyName,MobileNo, EmailId,City CityName,
			Convert(Nvarchar(100),CheckinDate,103) ChkinDate,Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate,
			 SNo ,BookingCode,BookingLevel,Category,StayDays,BookedDate,'Checkout'
			from #Temp  where   clientname!=''
			group by id,FirstName,clientname,HotalName,	MobileNo, EmailId,City,CheckinDate,ChkOutDt,
			ClientId,BookingCode,GuestId,SNo,BookingLevel,Category,StayDays,BookedDate 
 End
 
	  If(@Id1=0)
		  Begin
	  Insert into #Temp(id,FirstName,clientname,HotalName,
	  MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate)
			Select id,FirstName,clientname,HotalName,
			MobileNo, EmailId,City,CheckinDate,ChkOutDt,ClientId,BookingCode,
			BookingLevel,Category,StayDays,BookedDate
			from #Temps  where    CONVERT(date,ChkOutDt,103) between CONVERT(date,@FromDt,103)  AND CONVERT(date,@ToDt ,103) 	 and clientname!=''
			order by BookingCode desc;
			
	  Insert into #FinalSelect(id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,
	  ChkOutDt,ClientId,BookingCode,BookingLevel,Category,StayDays,BookedDate,Statu)
			Select id,FirstName,clientname as ClientName,HotalName PropertyName,MobileNo, EmailId,City CityName,
			Convert(Nvarchar(100),CheckinDate,103) ChkinDate,Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate,
			 SNo ,BookingCode,BookingLevel,Category,StayDays,BookedDate,'Checkout'
			from #Temp 
			group by id,FirstName,clientname,HotalName,MobileNo, EmailId,City,CheckinDate,ChkOutDt,
			ClientId,BookingCode,GuestId ,SNo,BookingLevel,Category,StayDays ,BookedDate
		End
      
    END
  
    
       Select id,FirstName,clientname as ClientName,HotalName PropertyName,
		MobileNo, EmailId,City CityName,Convert(Nvarchar(100),CheckinDate,103) ChkinDate,
		Convert(Nvarchar(100),ChkOutDt,103) ChkoutDate, SNo, BookingCode,
		BookingLevel,Category,StayDays,BookedDate,Statu as Statues
		from #FinalSelect 
   
      
      
		 
		--End 
    END
End
      
      
     --exec Sp_TodaysCheckinChkout_Help @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'',@Str2=N'', @Id1=0,@Id2=0, @UserId=65;
  -- exec Sp_TodaysCheckinChkout_Help @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'',@Str2=N'', @Id1=0,@Id2=0, @UserId=65;
   
   
   

	
 