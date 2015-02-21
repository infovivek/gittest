 
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
		CheckInDate  NvarchaR(200),CheckOutDate  NvarchaR(200),NoOfDays int ,Discount decimal(27,2),Tariff Decimal(27,2),PId  Nvarchar(500),BookedId int,
		NewCheckInDate NvarchaR(200),NewCheckoutDate NvarchaR(200),LastBillDate Nvarchar(100),CheckInHdrId bigint)
		
	    Create Table #FinalChk(Guest nvarchar(200),PropertyName nvarchar(1000),ClientName nvarchar(1000),ChkOutTariffNetAmount decimal(27,2),
		BookingCode bigint,LastBillDate nvarchar(50),FirstName NvarchaR(200),Propertytype nVARCHAR(200),CheckOutNo Nvarchar(100),CityName Nvarchar(100),
		CheckInDate  NvarchaR(200),CheckOutDate  NvarchaR(200),NoOfDays int ,Discount decimal(27,2),Tariff Decimal(27,2),
		Sno int primary key identity(1,1),NewCheckInDate NvarchaR(200),NewCheckoutDate NvarchaR(200))
	
		CREATE TABLE #ExpChkout(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,BookingCode BIGINT,
		CheckInHdrId Bigint ,Tariff Decimal(27,2),CheckInDate  NvarchaR(200),PropertyType nvarchar(100),
		NewCheckInDate NvarchaR(200),NewCheckoutDate NvarchaR(200),LastBillDate Nvarchar(100));
	 
	 
   
   
	 	TRUNCATE TABLE #ExpChkout;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
       Tariff,CheckInDate,PropertyType,NewCheckInDate,NewCheckoutDate,LastBillDate)
         Select  H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType,convert(nvarchar(100),Cast(c.NewCheckInDate as DATE),103),
		 convert(nvarchar(100),Cast(C.NewCheckoutDate as DATE),103),convert(nvarchar(100),Cast(C.NewCheckoutDate as Date),103)
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId and ABPA.CurrentStatus='CheckIn' 
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	and C.id=Abpa.CheckInHdrId 	
         where   H.CancelStatus!='Canceled' and isnull(ABPA.CheckOutHdrId,0) =0 
         and c.isactive=1 and c.isdeleted=0 and ABPA.RoomShiftingFlag=0  --and ABPA.BookingId=7643
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id,C.NewCheckInDate,C.NewCheckoutDate,ABPA.CurrentStatus 
	 	 order by C.Id desc
		 
	 
--APARTMENT
         INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
       Tariff,CheckInDate,PropertyType,NewCheckInDate,NewCheckoutDate,LastBillDate)
         Select   H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType ,convert(nvarchar(100),Cast(c.NewCheckInDate as DATE),103),
		 convert(nvarchar(100),Cast(C.NewCheckoutDate as DATE),103),convert(nvarchar(100),Cast(C.NewCheckoutDate as Date),103)
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
         where   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
         and c.isactive=1 and c.isdeleted=0
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id,C.NewCheckInDate,C.NewCheckoutDate 
	 	--and pu.UserId=@Pram1
		 order by C.Id desc
   
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
  Tariff,CheckInDate,PropertyType,NewCheckInDate,NewCheckoutDate,LastBillDate) 
       Select  H.Id, Property PropertyName,PropertyId, GuestName,'' BookingLevel,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,''City,c.CityId,H.ClientName,H.ClientId,C.BookingCode,C.Id,
		 c.Tariff,convert(nvarchar(100),ABPA.ChkInDt,103),c.propertyType ,convert(nvarchar(100),Cast(c.NewCheckInDate as DATE),103),
		 convert(nvarchar(100),Cast(C.NewCheckoutDate as DATE),103),convert(nvarchar(100),Cast(C.NewCheckoutDate as Date),103)
		 from WRBHBCheckInHdr C
		 join  WRBHBBooking H on c.BookingId=H.Id
    	 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId
    	 AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0	 	
         where   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn' 
         and c.isactive=1 and c.isdeleted=0
         group by C.Id, Property,PropertyId, GuestName,
		 ABPA.ChkOutDt,c.CityId,H.ClientName,H.ClientId,C.BookingCode,
		 c.Tariff,ABPA.ChkInDt,c.propertyType,H.Id,C.NewCheckInDate,C.NewCheckoutDate 
	     
  		
   INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,
   Tariff,CheckInDate,PropertyType,NewCheckInDate,NewCheckoutDate,LastBillDate)
            Select Distinct C.id,s.HotalName,S.HotalId,ag.FirstName,'',convert(nvarchar(100),Ag.ChkOutDt,103),
            S.City,C.CityId,C.ClientName,C.ClientId,c.bookingCode,0,
			SingleTariff,  convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,'External Property','' NewCheckInDate,''NewCheckoutDate,''NewCheckoutDate
			--,DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays,AG.Occupancy,Tariff,
			from wrbhbbooking C
			join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
			join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
			JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
			and  PropertyType='MMT'  and Ag.CurrentStatus!='Canceled'  and AG.CurrentStatus='CheckIn' 
			LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
		  	Group by C.id,s.HotalName,S.HotalId,ag.FirstName,Ag.ChkOutDt,
            S.City,C.CityId,C.ClientName,C.ClientId,c.bookingCode,
			SingleTariff,  Ag.ChkInDt
			order by C.id
		
		
	 Delete #ExpChkout where  convert(date,CheckInDate,103)< convert(date,'04/07/2014',103);
		 
	If( @FromDt='') and (@ToDt='')
	Begin		
		insert into #FinalChkout(Guest,Property,ClientName,Tariff,BookingNo,ChkOutDate,FirstName,
		Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,ChkOutTariffNetAmount,PId,BookedId,
		NewCheckInDate,NewCheckoutDate,LastBillDate,CheckInHdrId)
           
		Select GuestName,PropertyName,ClientName,Tariff ,BookingCode,ExpDate,GuestName,
		PropertyType,'',c.CityName,CheckInDate,ExpDate,
		DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103)) as nodays,0,
		DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103))* Tariff ChkOutTariffNetAmount, 
		PropertyId,p.BookedId ,NewCheckInDate,NewCheckoutDate,''LastBillDate,CheckInHdrId
		from #ExpChkout P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		 
		End
		Else
		Begin 
		 
		 insert into #FinalChkout(Guest,Property,ClientName,Tariff,BookingNo,ChkOutDate,FirstName,
		Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,ChkOutTariffNetAmount,PId,BookedId,
		NewCheckInDate,NewCheckoutDate,LastBillDate,CheckInHdrId)
           
		Select GuestName,PropertyName,ClientName,Tariff ,BookingCode,ExpDate,GuestName,
		PropertyType,'',c.CityName,CheckInDate,ExpDate,
		 DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103)) as nodays,0,
		 DateDiff(day,convert(date,CheckInDate,103),convert(date,ExpDate,103))* Tariff ChkOutTariffNetAmount,
		--DateDiff(day,convert(date,NewCheckInDate,103),convert(date,GETDATE(),103)) as nodays,0,
		--DateDiff(day,convert(date,NewCheckInDate,103),convert(date,GETDATE(),103))* Tariff ChkOutTariffNetAmount,
		PropertyId,p.BookedId ,NewCheckInDate,NewCheckoutDate,''LastBillDate,CheckInHdrId
		from #ExpChkout P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		where Convert(date,CheckInDate,103)between CONVERT(date,@FromDt,103) and  CONVERT(DATE,@ToDt,103) 
		End    --and CONVERT(NVARCHAR,DATEADD(DAY,1,CONVERT(DATE,@ToDt,103)))
		  

       UPDATE #FinalChkout SET Property = P.PropertyName 
	   FROM #FinalChkout F 
	   JOIN WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PId AND P.IsActive=1 
	   AND IsDeleted=0 and p.Category='Internal Property'  
	
		
	  UPDATE #FinalChkout SET CheckInDate = convert(nvarchar(100),p.ArrivalDate,103)
      from #FinalChkout F 
	  JOIN WRBHBCheckInHdr p WITH(NOLOCK) ON p.Id=f.CheckInHdrId AND P.IsActive=1 
	  AND IsDeleted=0 
	   
      UPDATE #FinalChkout SET LastBillDate =  p.BillEndDate
   --   Select p.BillEndDate,LastBillDate,FirstName,p.Property
      from #FinalChkout F 
	   JOIN WRBHBChechkOutHdr p WITH(NOLOCK) ON p.ChkInHdrId=f.CheckInHdrId 
	   and f.Guest=p.GuestName AND P.IsActive=1 
	   AND IsDeleted=0 and  convert(date, p.BillEndDate,103) > convert(date,'04/07/2014',103);
	   	   
	  
	   	
	    UPDATE #FinalChkout SET  LastBillDate  =  Convert(nvarchar(100),CheckInDate,103)
	    where LastBillDate='' and  Convert(date,CheckOutDate,103)  >=Convert(date,GETDATE(),103)
	 
		  
	    UPDATE #FinalChkout set NoOfDays= DateDiff(day,convert(date,LastBillDate,103),convert(date,GETDATE(),103))
		where   Convert(date,CheckOutDate,103)  >Convert(date,GETDATE(),103)
		  
		update #FinalChkout  set NoOfDays=1 WHERE  NoOfDays<=0;
		
		update #FinalChkout  set ChkOutTariffNetAmount=NoOfDays*Tariff;
          --Select * from #FinalChkout where BookingNo= 5759
		  --Update #FinalChkout set LastBillDate ='' where 
		  --  Convert(date,CheckOutDate,103)=CONVERT(date,LastBillDate,103)-- and CONVERT(date,@ToDt,103)
		  --and LastBillDate!='' 
		  
	   Delete #FinalChkout where   NoOfDays=0 or ClientName='';
	 
		if(@Str1='Internal Property')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,NewCheckInDate ,NewCheckoutDate )

			Select Property,ClientName,ChkOutTariffNetAmount,BookingNo, LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,
			Guest,NewCheckInDate ,NewCheckoutDate 
			from #FinalChkout
			where --Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103) 
			Propertytype='Internal Property'
			Group by Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,LastBillDate,NewCheckInDate ,NewCheckoutDate ,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff
			order by CheckOutNo asc
			
			if(@FromDt='')
			begin
				select PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk
				Select Convert(Nvarchar(100),Getdate(),103) as TodayDate;
			 end
		    else
		    Begin
				select PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk 
				Select Convert(Nvarchar(100),Getdate(),103) as TodayDate;
		--    where Convert(date,CheckInDate,103)between CONVERT(date,@FromDt,103) and CONVERT(date,@ToDt,103)
		    End
		End
		
		--Select * from #FinalChkout 
		--where Propertytype='External Property'
		--and  Convert(date,CheckOutDate,103)  >Convert(date,GetDate(),103) 
		 
		if(@Str1='External Property')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,NewCheckInDate ,NewCheckoutDate )

			Select Property ,ClientName,ChkOutTariffNetAmount,BookingNo BookingCode, LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,
			Guest,NewCheckInDate ,NewCheckoutDate 
			from #FinalChkout
			where-- Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103)
			Propertytype='External Property'
			Group by Property ,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff,NewCheckInDate ,NewCheckoutDate 
			order by CheckOutNo asc
			if(@FromDt='')
			begin
				select PropertyName ,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk
				Select Convert(Nvarchar(100),Getdate(),103) as TodayDate;
			 end
		    else
		    Begin
				select PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk 
				Select Convert(Nvarchar(100),Getdate(),103) as TodayDate;
			--	where Convert(date,CheckInDate,103)between CONVERT(date,@FromDt,103) and CONVERT(date,@ToDt,103)
		    End
		End
		if(@Str1='Managed G H')
		BEGIN
		insert into #FinalChk(PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
		CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,NewCheckInDate ,NewCheckoutDate )

			Select Property ,ClientName,ChkOutTariffNetAmount,BookingNo BookingCode, LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff, 
			Guest,NewCheckInDate ,NewCheckoutDate 
			from #FinalChkout
			where --Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103) 
		    Propertytype='Managed G H'
			Group by Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate,LastBillDate,
			FirstName,Propertytype,CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Guest,Tariff,NewCheckInDate ,NewCheckoutDate 
			order by CheckOutNo asc
			
			if(@FromDt='')
			begin
				select PropertyName ,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk
				Select Convert(Nvarchar(100),Getdate(),103)as TodayDate;
		    end
		    else
		    Begin
				select PropertyName,ClientName,ChkOutTariffNetAmount,BookingCode,LastBillDate,FirstName,Propertytype,
				CheckOutNo,CityName,CheckInDate,CheckOutDate,NoOfDays,Discount,Tariff,Guest,Sno 
				from  #FinalChk 
				Select Convert(Nvarchar(100),Getdate(),103) as TodayDate;
			--	where Convert(date,CheckInDate,103)between CONVERT(date,@FromDt,103) and CONVERT(date,@ToDt,103)
		    End
		    
		End
		
		
		END

--exec Sp_PendingUnsettled_Help @Action=N'Pageload',@FromDt=N'01/11/2014',@ToDt=N'30/11/2014',@Str1=N'External Property',@Str2=N'',@Id1=0,@Id2=0,@UserId=41