SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_PendingChkinReport_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_PendingChkinReport_Help]
GO
/*=============================================
Author Name  : Anbu
Created Date : 03/04/2014 
Section  	 : Master
Purpose  	 : Tax
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_PendingChkinReport_Help]
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
IF @Action ='Pageload'
BEGIN
 --Expected CHECKIN
		-- SELECT TOP 10 H.ClientName ,CityName,D.FirstName FirstName,BookingLevel  
		     
		CREATE TABLE #ExpChkin(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,
		BookingCode BIGINT,Category NVARCHAR(100),CheckOutDate NVARCHAR(100),NoOfdays BIGINT,
		MOP NVARCHAR(100),Propertyemail NVARCHAR(100),ContactNum NVARCHAR(100),PrptyType Nvarchar(100));
		
		CREATE TABLE #ExpChkinDate(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,
		BookingCode BIGINT,Category NVARCHAR(100),CheckOutDate NVARCHAR(100),NoOfdays BIGINT,
		MOP NVARCHAR(100),Propertyemail NVARCHAR(100),ContactNum NVARCHAR(100),PrptyType Nvarchar(100));
	
      
	  --CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum
	 	TRUNCATE TABLE #ExpChkin;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		convert(nvarchar(100),Ag.ChkOutDt,103),DateDiff(day,convert(date,Ag.ChkInDt,103),convert(date,Ag.ChkOutDt,103)) as nodays,
		aG.TariffPaymentMode,P.Email,P.Phone,''
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Booked'
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkInDt,103) <=CONVERT(date,GETDATE(),103)
	 	and pu.UserId=@UserId
	 	--and clientName='Jubilant Life Science' and BookingCode=3400
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,Ag.ChkOutDt,aG.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
     BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		convert(nvarchar(100),Ag.ChkOutDt,103),DateDiff(day,convert(date,Ag.ChkInDt,103),convert(date,Ag.ChkOutDt,103)) as nodays,
		aG.TariffPaymentMode,P.Email,P.Phone,''
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = Ag.BookingPropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Booked'
		and H.Cancelstatus !='Canceled' AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin) 
		and Ag.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103)))
	 	and pu.UserId=@UserId
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,Ag.ChkOutDt,aG.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
      BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		 convert(nvarchar(100),ABPA.ChkOutDt,103),DateDiff(day,convert(date,ABPA.ChkInDt,103),convert(date,ABPA.ChkOutDt,103)) as nodays,
		 ABPA.TariffPaymentMode,P.Email,P.Phone,''
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 and CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103)  
		 and pu.UserId=@UserId
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,p.Id,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,ABPA.TariffPaymentMode,P.Email,P.Phone
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
 	 BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		  convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		  convert(nvarchar(100),ABPA.ChkOutDt,103),DateDiff(day,convert(date,ABPA.ChkInDt,103),convert(date,ABPA.ChkOutDt,103)) as nodays,
		  ABPA.TariffPaymentMode,P.Email,P.Phone,''
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin)
		 and ABPA.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		 CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103))) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
  BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		 convert(nvarchar(100),ABPA.ChkOutDt,103),DateDiff(day,convert(date,ABPA.ChkInDt,103),convert(date,ABPA.ChkOutDt,103)) as nodays,
		 ABPA.TariffPaymentMode,P.Email,P.Phone,''
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 and  CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.ChkOutDt,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
  BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,
		 convert(nvarchar(100),ABPA.ChkOutDt,103),DateDiff(day,convert(date,ABPA.ChkInDt,103),convert(date,ABPA.ChkOutDt,103)) as nodays,
		 ABPA.TariffPaymentMode,P.Email,P.Phone,''
		 FROM WRBHBBooking H
		-- JOIN WRBHBBedBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND	 ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.ID=ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0 
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled' and ABPA.CurrentStatus='Booked'
		 AND H.Id NOT IN(SELECT BookedId FROM #ExpChkin)-- and P.Category in ('Internal Property') 
		 and  ABPA.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		 CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103))) 
		 and pu.UserId=@UserId
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.ChkOutDt,ABPA.TariffPaymentMode,P.Email,P.Phone
		 order by H.Id desc 
	
	--MMT	 
	 INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
     BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType) 
     
          Select Distinct  Ag.BookingId,Bp.PropertyName ,Ag.BookingPropertyId,ag.FirstName,'Room',Convert(nvarchar(100),Ag.ChkInDt,103),
          s.City,c.CityId,c.ClientName,c.ClientId,c.BookingCode,'MMT',convert(nvarchar(100),Ag.ChkOutDt,103),
			DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays ,Ag.TariffPaymentMode,bp.Email,s.Phone,bp.PropertyType
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT' 
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
			where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
			 and  CONVERT(date,ag.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
			group by  Ag.BookingId,Bp.PropertyName ,Ag.BookingPropertyId,ag.FirstName,Ag.ChkInDt,s.City,c.CityId,c.ClientName,
            c.ClientId,c.BookingCode,bp.PropertyType,Ag.ChkOutDt,Ag.TariffPaymentMode,bp.Email,s.Phone
			 
			--MMT	 
	 INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
     BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType) 
     
          Select Distinct  Ag.BookingId,Bp.PropertyName ,Ag.BookingPropertyId,ag.FirstName,'Room',Convert(nvarchar(100),Ag.ChkInDt,103),
          s.City,c.CityId,c.ClientName,c.ClientId,c.BookingCode,'MMT',convert(nvarchar(100),Ag.ChkOutDt,103),
			DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays ,Ag.TariffPaymentMode,bp.Email,s.Phone,Bp.PropertyType
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT' 
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
			where   Ag.ChkInDt  BETWEEN CONVERT(date,GETDATE(),103) AND  
		    CONVERT(NVARCHAR,DATEADD(DAY,7,CONVERT(DATE,GETDATE(),103))) 
			group by  Ag.BookingId,Bp.PropertyName ,Ag.BookingPropertyId,ag.FirstName,Ag.ChkInDt,s.City,c.CityId,c.ClientName,
            c.ClientId,c.BookingCode,bp.PropertyType,Ag.ChkOutDt,Ag.TariffPaymentMode,bp.Email,s.Phone
			 
		 
		 --  Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
			--convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
			----Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
			--ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,Bp.PropertyId Id ,
			--ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays 
			--from wrbhbbooking C
			--join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			--join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			--JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			--and  PropertyType='MMT' 
			--LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
			--where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
			--Group by C.id,Ag.guestid,Ag.RoomType,ag.FirstName,Ag.ChkInDt,Ag.ChkOutDt,CurrentStatus,
			--AG.Occupancy,Tariff,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,s.HotalId ,
			--ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),Bp.PropertyId
			
    --#GRID VALUES 1 FOR TABLE0
    
    UPDATE  #ExpChkin  
    SET ClientName=C.CLIENTNAME
    FROM #ExpChkin CC
    JOIN  WRBHBCLIENTMANAGEMENT C ON C.Id=cc.ClientId and c.isactive=1
    delete #ExpChkin where clientId=0;
    
    
    UPDATE  #ExpChkin  
    SET PrptyType=C.PropertyType
    FROM #ExpChkin CC
    JOIN  WRBHBBookingProperty C ON C.PropertyId=cc.PropertyId and c.isactive=1
    where PrptyType='';
    
    --Select cc.PrptyType ,c.PropertyType,c.BookingId,cc.BookedId,c.PropertyId,cc.PropertyId
    --FROM #ExpChkin CC
    --JOIN  WRBHBBookingProperty C ON C.PropertyId=cc.PropertyId and c.isactive=1
    --where PrptyType='';
    
    
    delete #ExpChkin where PrptyType='Cpp' and MOP!='Bill to Company (BTC)'
   -- return;
    If(@Str1='Internal Property')
    BEGIN
    	INSERT INTO #ExpChkinDate(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
       
      select  BookedId,PropertyName+' - '+C.CityName PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
      Convert(nvarchar(100),ExpDate,103) CheckinDate,C.CityName,CityId,ClientName,ClientId,BookingCode,Category,
       CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
      from #ExpChkin F
      left join WRBHBCity C on c.Id=F.CityId
      where Convert(date,ExpDate,103) between CONVERT(date,'01/09/2014',103) and  CONVERT(date,getdate(),103)
      AND Category='Internal Property'
      group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
      ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,
       CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
      order by Convert(date,ExpDate,103) desc;
    END
        If(@Str1='External Property')
    BEGIN
    	INSERT INTO #ExpChkinDate(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
			select  BookedId,PropertyName+' - '+C.CityName PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,C.CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			from #ExpChkin F
			left join WRBHBCity C on c.Id=F.CityId
			where Convert(date,ExpDate,103)between CONVERT(date,'01/09/2014',103) and  CONVERT(date,getdate(),103)
			AND Category='External Property'
			group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
			ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			order by Convert(date,ExpDate,103) desc;
			
			INSERT INTO #ExpChkinDate(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
			select  BookedId,PropertyName+' - '+C.CityName PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,C.CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			from #ExpChkin F
			left join WRBHBCity C on c.Id=F.CityId
			where Convert(date,ExpDate,103)between CONVERT(date,'01/09/2014',103) and  CONVERT(date,getdate(),103)
			AND Category='MMT'
			group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
			ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			order by Convert(date,ExpDate,103) desc;
			
			Update #ExpChkinDate set Category='CPP' where PrptyType='CPP'
			
    END
       If(@Str1='Managed G H')
    BEGIN
    	INSERT INTO #ExpChkinDate(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
			select  BookedId,PropertyName+' - '+C.CityName PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,C.CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			from #ExpChkin F
			left join WRBHBCity C on c.Id=F.CityId
			where Convert(date,ExpDate,103)between CONVERT(date,'01/09/2014',103) and CONVERT(date,getdate(),103)
			and Category='Managed G H'
			group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
			ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			order by Convert(date,ExpDate,103) desc;
    END
     If(@Str1='')
    BEGIN
    	INSERT INTO #ExpChkinDate(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,
       BookingCode,Category,CheckOutDate,NoOfdays,MOP,Propertyemail,ContactNum,PrptyType)
			select  BookedId,PropertyName+' - '+C.CityName PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,C.CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			from #ExpChkin F
			left join WRBHBCity C on c.Id=F.CityId
			where Convert(date,ExpDate,103) between CONVERT(date,'01/09/2014',103) and   CONVERT(date,getdate(),103)
			AND Category='Internal Property' --- AND Category='Managed G H'
			group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
			ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			order by Convert(date,ExpDate,103) desc;
    END
    
    
    if(@FromDt='')
	 begin
            select  BookedId,PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			From #ExpChkinDate
      end 
        else
	  Begin
            select  BookedId,PropertyName,PropertyId,GuestName as FirstName,BookingLevel,
			Convert(nvarchar(100),ExpDate,103) CheckinDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,
			CheckOutDate, NoOfdays,MOP, Propertyemail, ContactNum,PrptyType
			From #ExpChkinDate 
			where Convert(date,ExpDate,103)between CONVERT(date,@FromDt,103) and CONVERT(date,@ToDt,103)
      End
    
      EnD
      End
      
      
     --exec Sp_PendingChkinReport_Help @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'External Property',@Str2=N'', @Id1=0,@Id2=0, @UserId=65;
