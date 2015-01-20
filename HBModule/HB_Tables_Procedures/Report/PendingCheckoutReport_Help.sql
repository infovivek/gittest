	SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[PendingCheckoutReport_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PendingCheckoutReport_Help]
GO
/*=============================================
Author Name  :  
Created Date : 03/04/2014 
Section  	 :  
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
CREATE PROCEDURE [dbo].[PendingCheckoutReport_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
--@Str3 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL,
--@Id3 INT=NULL, 
@UserId INT=NULL
)
AS
BEGIN
IF @Action ='PAGELOAD'
   
 Begin		     
		CREATE TABLE #ExpChkout(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,
		BookingCode BIGINT,CheckInHdrId Bigint ,Category nvarchar(500),MOP Nvarchar(200),CheckInDate Nvarchar(100),
		PropertyEmail Nvarchar(200),PrptyPhone Nvarchar(300) );


		create TABLE #TEMPFINALCHKOUTS(GuestName NVARCHAR(200),GuestId BIGINT,CityId BIGINT,BookingId BIGINT,
		ChkOutDate NVARCHAR(200),Type NVARCHAR(200), PropertyName NVARCHAR(200) ,CityName NVARCHAR(200),CheckInHdrId Bigint,
		Category nvarchar(500),MOP Nvarchar(200) ,PropertyId Bigint,BookingCode Nvarchar(100),ClientName NVARCHAR(100),ClientId BIGINT,
		CheckInDate Nvarchar(100),NOofdays Int,PropertyMail Nvarchar(200),ContactNumber Nvarchar(100))
		
		create TABLE #TEMPFINAL(GuestName NVARCHAR(200),GuestId BIGINT,CityId BIGINT,BookingId BIGINT,
		ChkOutDate NVARCHAR(200),Type NVARCHAR(200), PropertyName NVARCHAR(200) ,CityName NVARCHAR(200),CheckInHdrId Bigint,
		Category nvarchar(500),MOP Nvarchar(200) ,PropertyId Bigint,BookingCode Nvarchar(100),ClientName NVARCHAR(100),ClientId BIGINT,
		CheckInDate Nvarchar(100),NOofdays Int,PropertyMail Nvarchar(200),ContactNumber Nvarchar(100),RoomNO  Nvarchar(100),RoomId  Nvarchar(100))

   

   
 --  Declare @Pram1 int; set @Pram1=65;
	 	TRUNCATE TABLE #ExpChkout;
	 	truncate table #TEMPFINALCHKOUTS;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
       ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkOutDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		AG.CheckInHdrId,P.Category,AG.TariffPaymentMode,convert(nvarchar(100),Ag.ChkInDt,103) ChkInDt,P.Email,P.Phone
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE    AG.CurrentStatus='CheckIn' and AG.RoomShiftingFlag=0
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkInDt,103) <=CONVERT(date,GETDATE(),103)
	 	and pu.UserId=@UserId
	 	--and clientName='Jubilant Life Science' and BookingCode=3400
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkOutDt,P.Id,Ag.ChkInDt,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
     ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode,convert(nvarchar(100),Ag.ChkInDt,103) ChkInDt,P.Email,P.Phone
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = Ag.BookingPropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  AG.CurrentStatus='CheckIn' and AG.RoomShiftingFlag=0
		and H.Cancelstatus !='Canceled' AND H.Id NOT IN(SELECT BookedId FROM #ExpChkout) 
		and Ag.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103)))
	 	and pu.UserId=@UserId
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkOutDt,Ag.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
      ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode,convert(nvarchar(100),ABPA.ChkInDt,103) ChkInDt,P.Email,P.Phone
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103)  
		 and pu.UserId=@UserId
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,p.Id,ABPA.ChkInDt,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
 	 ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		  convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  0,P.Category,ABPA.TariffPaymentMode,convert(nvarchar(100),ABPA.ChkInDt,103) ChkInDt,P.Email,P.Phone
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkout)
		 and ABPA.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		 CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103))) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode,convert(nvarchar(100),ABPA.ChkInDt,103) ChkInDt,P.Email,P.Phone
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and  CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,ABPA.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode,convert(nvarchar(100),ABPA.ChkInDt,103) ChkInDt,P.Email,P.Phone
		 FROM WRBHBBooking H
		-- JOIN WRBHBBedBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND	 ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.ID=ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0 
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE   H.CancelStatus!='Canceled' and ABPA.CurrentStatus='CheckIn'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkout)-- and P.Category in ('Internal Property') 
		 and  ABPA.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		 CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103))) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc 
    --#GRID VALUES 1 FOR TABLE0 
    --MMT	 
	  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
      ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)

		SELECT DISTINCT H.Id, p.PropertyName PropertyName,s.HotalId,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),AG.ChkOutDt,103) ExpDate ,S.City,H.CityId,H.ClientName,H.ClientId,BookingCode,
		0,'MMT',AG.TariffPaymentMode,convert(nvarchar(100),AG.ChkInDt,103) ChkInDt,P.Email,P.Phone--,Ag.CurrentStatus,H.Status
		from wrbhbbooking H
		join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
		JOIN dbo.WRBHBBookingProperty P WITH(NOLOCK)ON H.Id=P.BookingId AND P.IsActive=1 AND P.IsDeleted=0  
		and  PropertyType='MMT' 
		LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=p.PropertyId AND PA.IsDeleted=0  
		where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
		and  CONVERT(date,ag.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		and   H.CancelStatus!='Canceled' and Ag.CurrentStatus='CheckIn'
		group by  Ag.BookingId,p.PropertyName ,Ag.BookingPropertyId,ag.FirstName,Ag.ChkInDt,s.City,H.CityId,H.ClientName,
		H.ClientId,H.BookingCode,p.PropertyType,Ag.ChkOutDt,Ag.TariffPaymentMode,p.Email,s.Phone,H.Id,s.HotalId,
		h.BookingLevel,P.Email,P.Phone--,Ag.CurrentStatus,H.Status
			 
			--MMT	 
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,
  ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,CheckInDate,PropertyEmail,PrptyPhone)


        SELECT DISTINCT H.Id, p.PropertyName PropertyName,s.HotalId,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),AG.ChkOutDt,103) ExpDate ,S.City,H.CityId,H.ClientName,H.ClientId,BookingCode,
		0,'MMT',AG.TariffPaymentMode,convert(nvarchar(100),AG.ChkInDt,103) ChkInDt,P.Email,P.Phone--,Ag.CurrentStatus,H.Status
		from wrbhbbooking H
		join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
		JOIN dbo.WRBHBBookingProperty P WITH(NOLOCK)ON H.Id=P.BookingId AND P.IsActive=1 AND P.IsDeleted=0  
		and  PropertyType='MMT' 
		LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=p.PropertyId AND PA.IsDeleted=0  
		where  Ag.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
        CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103)))  
		and   H.CancelStatus!='Canceled' and Ag.CurrentStatus='CheckIn'
		group by  Ag.BookingId,p.PropertyName ,Ag.BookingPropertyId,ag.FirstName,Ag.ChkInDt,s.City,H.CityId,H.ClientName,
		H.ClientId,H.BookingCode,p.PropertyType,Ag.ChkOutDt,Ag.TariffPaymentMode,p.Email,s.Phone,H.Id,s.HotalId,
		h.BookingLevel,P.Email,P.Phone--,Ag.CurrentStatus,H.Status
			 
			 
	
	INSERT INTO #TEMPFINALCHKOUTS(GuestName,GuestId,Type, PropertyName,ChkOutDate,CityName,CityId,BookingId,
	CheckInHdrId, Category ,MOP,PropertyId,BookingCode,ClientName,ClientId,CheckIndate,NOofdays,PropertyMail,ContactNumber )
	select  GuestName as FirstName,0 as GuestId,BookingLevel Type,PropertyName, --PropertyId,BookingLevel,
	Convert(nvarchar(100),ExpDate,103) CheckOutDate,C.CityName CityName,CityId,BookedId,CheckInHdrId,
	Category ,MOP,PropertyId,BookingCode,ClientName,ClientId,CheckIndate,
	DateDiff(day,convert(date,CheckIndate,103),convert(date,ExpDate,103)) as nodays,PropertyEmail PropertyMail,PrptyPhone ContactNumber
	from #ExpChkout F
	left join WRBHBCity C on c.Id=F.CityId
	where Convert(date,ExpDate,103)<= CONVERT(date,GETDATE(),103) 
	group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ClientName,ClientId,CheckIndate,
	ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,PropertyId,PrptyPhone,PropertyEmail 
	order by Convert(date,ExpDate,103)
       
    UPDATE  #TEMPFINALCHKOUTS   SET Category=C.PropertyType
    FROM #TEMPFINALCHKOUTS CC
    JOIN  WRBHBBookingProperty C ON C.PropertyId=cc.PropertyId and c.isactive=1
    and C.BookingId=CC.BookingId  where Category!='';
    
	UPDATE  #TEMPFINALCHKOUTS  
	SET ClientName=C.CLIENTNAME
	FROM #TEMPFINALCHKOUTS CC
	JOIN  WRBHBCLIENTMANAGEMENT C ON C.Id=cc.ClientId and c.isactive=1
	delete #TEMPFINALCHKOUTS where clientId=0;

	delete #TEMPFINALCHKOUTS where Category='Cpp' and MOP!='Bill to Company (BTC)'
 
    
     If(@Str1='Internal Property')
    BEGIN 
		INSERT INTO #TEMPFINAL(GuestName,CheckInHdrId,BookingId,RoomNO,RoomId,BookingCode,GuestId,Type,PropertyName,
		ChkOutDate,CityName,CityId,Category ,MOP,PropertyId,ClientName,ClientId,CheckIndate,NOofdays,PropertyMail,ContactNumber )
			
			Select C.ChkInGuest GuestName ,C.Id,c.BookingId,C.RoomNo,C.RoomId ,B.BookingCode,
			B.GuestId,B.Type, B.PropertyName,B.ChkOutDate CheckOutDate,B.CityName,B.CityId,B.Category,B.MOP,C.propertyId,
			B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber 
			from WRBHBCheckInHdr c
			join #TEMPFINALCHKOUTS B on b.BookingId=c.BookingId and C.Id=b.CheckInHdrId
			where IsActive=1 and IsDeleted=0 and B.category='InP'
			group by  B.GuestId,B.Type, B.PropertyName,B.ChkOutDate,B.CityName,B.CityId,
			C.ChkInGuest,C.Id,c.BookingId,C.RoomNo,C.RoomId,B.Category,B.MOP,B.BookingCode,
			 B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber ,C.propertyId
			order by  year(CONVERT(DATE,B.ChkOutDate,103)) 
    End   
    
     If(@Str1='External Property')
    BEGIN
		INSERT INTO #TEMPFINAL(GuestName,CheckInHdrId,BookingId,RoomNO,RoomId,BookingCode,GuestId,Type,PropertyName,
		ChkOutDate,CityName,CityId,Category ,MOP,PropertyId,ClientName,ClientId,CheckIndate,NOofdays,PropertyMail,ContactNumber )
			
			Select C.ChkInGuest GuestName ,C.Id,c.BookingId,C.RoomNo,C.RoomId ,B.BookingCode,
			B.GuestId,B.Type, B.PropertyName,B.ChkOutDate CheckOutDate,B.CityName,B.CityId,B.Category,B.MOP,C.propertyId,
			B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber 
			from WRBHBCheckInHdr c
			join #TEMPFINALCHKOUTS B on b.BookingId=c.BookingId and C.Id=b.CheckInHdrId
			where IsActive=1 and IsDeleted=0 and B.category='ExP'
			group by  B.GuestId,B.Type, B.PropertyName,B.ChkOutDate,B.CityName,B.CityId,
			C.ChkInGuest,C.Id,c.BookingId,C.RoomNo,C.RoomId,B.Category,B.MOP,B.BookingCode,
			 B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber ,C.propertyId
			order by  year(CONVERT(DATE,B.ChkOutDate,103)) 
    End   
    
    
    If(@Str1='')
    BEGIN
		INSERT INTO #TEMPFINAL(GuestName,CheckInHdrId,BookingId,RoomNO,RoomId,BookingCode,GuestId,Type,PropertyName,
		ChkOutDate,CityName,CityId,Category ,MOP,PropertyId,ClientName,ClientId,CheckIndate,NOofdays,PropertyMail,ContactNumber )
			
			Select C.ChkInGuest GuestName ,C.Id,c.BookingId,C.RoomNo,C.RoomId ,B.BookingCode,
			B.GuestId,B.Type, B.PropertyName,B.ChkOutDate CheckOutDate,B.CityName,B.CityId,B.Category,B.MOP,C.propertyId,
			B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber 
			from WRBHBCheckInHdr c
			join #TEMPFINALCHKOUTS B on b.BookingId=c.BookingId and C.Id=b.CheckInHdrId
			where IsActive=1 and IsDeleted=0 
			group by  B.GuestId,B.Type, B.PropertyName,B.ChkOutDate,B.CityName,B.CityId,
			C.ChkInGuest,C.Id,c.BookingId,C.RoomNo,C.RoomId,B.Category,B.MOP,B.BookingCode,
			 B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber ,C.propertyId
			order by  year(CONVERT(DATE,B.ChkOutDate,103)) 
    End
    
    If(@Str1='Managed G H')
    BEGIN
		INSERT INTO #TEMPFINAL(GuestName,CheckInHdrId,BookingId,RoomNO,RoomId,BookingCode,GuestId,Type,PropertyName,
		ChkOutDate,CityName,CityId,Category ,MOP,PropertyId,ClientName,ClientId,CheckIndate,NOofdays,PropertyMail,ContactNumber )
			
			Select C.ChkInGuest GuestName ,C.Id,c.BookingId,C.RoomNo,C.RoomId ,B.BookingCode,
			B.GuestId,B.Type, B.PropertyName,B.ChkOutDate CheckOutDate,B.CityName,B.CityId,B.Category,B.MOP,C.propertyId,
			B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber 
			from WRBHBCheckInHdr c
			join #TEMPFINALCHKOUTS B on b.BookingId=c.BookingId and C.Id=b.CheckInHdrId
			where IsActive=1 and IsDeleted=0 and B.category In ('DdP','MGH')
			group by  B.GuestId,B.Type, B.PropertyName,B.ChkOutDate,B.CityName,B.CityId,
			C.ChkInGuest,C.Id,c.BookingId,C.RoomNo,C.RoomId,B.Category,B.MOP,B.BookingCode,
			 B.ClientName,B.ClientId,B.CheckInDate,NOofdays,PropertyMail,ContactNumber ,C.propertyId
			order by  year(CONVERT(DATE,B.ChkOutDate,103)) 
    End      
        if(@FromDt='')
	 begin
            Select GuestName,PropertyName,ClientName,CityName,CheckIndate,ChkOutDate,NOofdays,MOP,
            PropertyMail,ContactNumber ,BookingCode,Category,
            Type,CityId,BookingId,CheckInHdrId, PropertyId,ClientId
			From #TEMPFINAL
	 end 
        else
	  Begin
	        Select GuestName,PropertyName,ClientName,CityName,CheckIndate,ChkOutDate,NOofdays,MOP,
            PropertyMail,ContactNumber ,BookingCode,Category,
            Type,CityId,BookingId,CheckInHdrId, PropertyId,ClientId
			From #TEMPFINAL
			where  Convert(date,ChkOutDate,103)between CONVERT(date,@FromDt,103) and CONVERT(date,@ToDt,103)
	  end 
	  
       END
       END
       
       
       
     -- exec PendingCheckoutReport_Help @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'',@Str2=N'', @Id1=0,@Id2=0, @UserId=65;
     
