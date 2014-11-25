 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PendingUnsettled_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE  Sp_PendingUnsettled_Help
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TACInvoice Search
		Purpose  	: TACInvoice Search
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
CREATE PROCEDURE Sp_PendingUnsettled_Help
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
--Drop Table #FinalChkout
--drop table #FinalChk
--drop table #ExpChkout
		Create Table #FinalChkout(Guest nvarchar(200),Property nvarchar(1000),ClientName nvarchar(1000),ChkOutTariffNetAmount decimal(27,2),
		BookingNo NvarchaR(200),ChkOutDate nvarchar(50),FirstName NvarchaR(200),Propertytype nVARCHAR(200),CheckOutNo Nvarchar(100),CityName Nvarchar(100),
		CheckInDate  NvarchaR(200),CheckOutDate  NvarchaR(200),NoOfDays int ,Discount decimal(27,2),Tariff Decimal(27,2),PId  Nvarchar(500),BookedId int)
		
	    Create Table #FinalChk(Guest nvarchar(200),PropertyName nvarchar(1000),ClientName nvarchar(1000),ChkOutTariffNetAmount decimal(27,2),
		BookingCode bigint,LastBillDate nvarchar(50),FirstName NvarchaR(200),Propertytype nVARCHAR(200),CheckOutNo Nvarchar(100),CityName Nvarchar(100),
		CheckInDate  NvarchaR(200),CheckOutDate  NvarchaR(200),NoOfDays int ,Discount decimal(27,2),Tariff Decimal(27,2),
		Sno int primary key identity(1,1))
	
		CREATE TABLE #ExpChkout(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,BookingCode BIGINT,
		CheckInHdrId Bigint ,Tariff Decimal(27,2),CheckInDate  NvarchaR(200),PropertyType nvarchar(100));
	 
	 
   
   
	 	TRUNCATE TABLE #ExpChkout;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
       Tariff,CheckInDate,PropertyType)
         Select  H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType 
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
         where   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
         and c.isactive=1 and c.isdeleted=0 and ABPA.RoomShiftingFlag=0
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id
	 	--and pu.UserId=@Pram1
		 order by C.Id desc
		
		 --Select * FROM WRBHBBooking H
		 --right outer join WRBHBBookingPropertyAssingedGuest  D   ON H.Id= D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		 --	WHERE     D.CurrentStatus='CheckIn' and D.isactive=1 and D.isdeleted=0 
		 --	  and D. RoomShiftingFlag=0 and H.Cancelstatus !='Canceled' 
  
--APARTMENT
         INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
       Tariff,CheckInDate,PropertyType)
         Select   H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType 
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
         where   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
         and c.isactive=1 and c.isdeleted=0
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id
	 	--and pu.UserId=@Pram1
		 order by C.Id desc
      
   --      select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 --convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,0,
		 --Tariff,convert(nvarchar(100),CheckInDate,103),p.Category
		 --FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 --JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 --JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
   --      JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 --WHERE  H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'  
	  --   -- and pu.UserId=@Pram1
		 --group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,p.Id,
		 --p.City,p.CityId,H.ClientName,H.ClientId,BookingCode ,Tariff ,CheckInDate,p.Category
		 --order by H.Id desc 
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
  Tariff,CheckInDate,PropertyType) 
       Select  H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType 
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
         where   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
         and c.isactive=1 and c.isdeleted=0
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id
	 	--and pu.UserId=@Pram1
		 order by C.Id desc
		 --select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel,
		 --convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,0,
		 --Tariff,convert(nvarchar(100),CheckInDate,103),p.Category
		 --FROM WRBHBBooking H
   -- 	 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 --JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 --JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 --JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 --WHERE   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
		 ---- and pu.UserId=@Pram1
		 --group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,
		 --P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,Tariff,CheckInDate,p.Category
		 --order by H.Id desc
		
  --INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
  --Tariff,CheckInDate,PropertyType)

  --      Select   C.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		-- convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,0,
		-- c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType 
		-- from WRBHBCheckInHdr C
		-- join  WRBHBBooking H on c.BookingId=H.Id
  --  	 JOIN WRBHBBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
  --  	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
  --       where  C.propertytype='Managed G H'  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
  --       and c.isactive=1 and c.isdeleted=0
  
  
  		
   INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
   Tariff,CheckInDate,PropertyType)
            Select Distinct C.id,s.HotalName,S.HotalId,ag.FirstName,'',convert(nvarchar(100),Ag.ChkOutDt,103),
            S.City,C.CityId,C.ClientName,C.ClientId,c.bookingCode,0,
			SingleTariff,  convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,'External Property'
			--,DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays,AG.Occupancy,Tariff,
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT'  and Ag.CurrentStatus!='Canceled'
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
		   --Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
			Group by C.id,s.HotalName,S.HotalId,ag.FirstName,Ag.ChkOutDt,
            S.City,C.CityId,C.ClientName,C.ClientId,c.bookingCode,
			SingleTariff,  Ag.ChkInDt
			order by C.id
		
		insert into #FinalChkout(Guest,Property,ClientName,Tariff,BookingNo,ChkOutDate,FirstName,
		Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,ChkOutTariffNetAmount,PId,BookedId )
           
		Select GuestName,PropertyName,ClientName,Tariff ,BookingCode,ExpDate,GuestName,
		PropertyType,'',c.CityName,CheckInDate,ExpDate,
		DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103)) as nodays,0,
		DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103))* Tariff ChkOutTariffNetAmount,
		PropertyId,p.BookedId
		--BookedId,PropertyId,BookingLevel,CityId,ClientId,
		from #ExpChkout P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		where Convert(date,ExpDate,103)>= CONVERT(date,'01/09/2014',103)
		--join 
      UPDATE #FinalChkout SET Property = P.PropertyName 
	  FROM #FinalChkout F 
	   JOIN WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PId AND P.IsActive=1 
	   AND IsDeleted=0 and p.Category='Internal Property'
	-- Select * from WRBHBBookingProperty where  BookingId=5566
 
		
		if(@Str1='Internal Property')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest)

			Select Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest
			from #FinalChkout
			where --Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103) 
			   Propertytype='Internal Property'
			Group by Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff
			order by CheckOutNo asc
			
			select PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		    CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
		    from  #FinalChk
		End
		if(@Str1='External Property')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest)

			Select Property ,ClientName,ChkOutTariffNetAmount,BookingNo BookingCode,ChkOutDate LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest
			from #FinalChkout
			where-- Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103)
			   Propertytype='External Property'
			Group by Property ,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff
			order by CheckOutNo asc
			
			select PropertyName ,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		    CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
		    from  #FinalChk
		End
		if(@Str1='Managed G H')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest)

			Select Property ,ClientName,ChkOutTariffNetAmount,BookingNo BookingCode,ChkOutDate LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest
			from #FinalChkout
			where --Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103) 
			   Propertytype='Managed G H'
			Group by Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff
			order by CheckOutNo asc
			
			select PropertyName ,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		    CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
		    from  #FinalChk
		    
		End
		
		
		END
		