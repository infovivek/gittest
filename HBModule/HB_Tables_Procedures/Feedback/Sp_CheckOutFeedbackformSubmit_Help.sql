 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_CheckOutFeedbackformSubmit_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_CheckOutFeedbackformSubmit_Help]
GO
 
CREATE PROCEDURE [dbo].[Sp_CheckOutFeedbackformSubmit_Help]
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
 -- Set @Str1='C6953DF4-41BB-4BDE-8A34-23B81BA716034';
 -- Select LEN(@Str1);
BEGIN
 
	
	IF @Action ='Submitted'
	BEGIN 
	
	create  table #Testtable(Id bigint,GuestName nvarchar(200),ClientName nvarchar(200),PropertyName nvarchar(200),
	CheckIndate nvarchar(200),ChkOutDate nvarchar(200),Cleanlinessofrooms nvarchar(200),QualityofFoodServed nvarchar(200),
	InternetService nvarchar(200),RoomAmbience nvarchar(200),QualityofService nvarchar(200),
	OverallStayExperience nvarchar(200),Remarks nvarchar(900))
	
		 
		  If(@FromDt='') and  (@ToDt='')  
		Begin
		 If(@Str1!='')-- prpty wise fileter
		Begin
		INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1 and PropertyName like '%'+@Str1+'%' 
			order by Id Desc
			
		END
		 If(@Str2!='') -- clientName wise filter
		 Begin
		 INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1   and ClientName like '%'+@Str2+'%' 
			order by Id Desc
		 End 
		  If(@Str2='') And (@Str1='') -- clientName wise filter
		 Begin
		 INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1   and ClientName like '%'+@Str2+'%' and convert(date,CreatedDate,103)
			 between convert(date,@FromDt,103) and convert(date,@ToDt,103)
			order by Id Desc
		 End 
		End
		
		 If(@FromDt!='') and  (@ToDt!='')  
		Begin
		 If(@Str1!='')-- prpty wise fileter
		Begin
		INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1 and PropertyName like '%'+@Str1+'%' and convert(date,CreatedDate,103)
			 between convert(date,@FromDt,103) and convert(date,@ToDt,103)
			order by Id Desc
			
		END
		 If(@Str2!='') -- clientName wise filter
		 Begin
		 INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1   and ClientName like '%'+@Str2+'%' and convert(date,CreatedDate,103)
			 between convert(date,@FromDt,103) and convert(date,@ToDt,103)
			order by Id Desc
		 End 
		  If(@Str2='') And (@Str1='') -- clientName wise filter
		 Begin
		 INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1   and ClientName like '%'+@Str2+'%' and convert(date,CreatedDate,103)
			 between convert(date,@FromDt,103) and convert(date,@ToDt,103)
			order by Id Desc
		 End 
		 
		 END
		 If(@Str2='') And (@Str1='') and (@FromDt='') and  (@ToDt='')  -- clientName wise filter
		 Begin
		 INsert into #Testtable(Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks)
	
		    Select Id,Guestname GuestName,ClientName ClientName,PropertyName PropertyName,CheckInDate CheckIndate,
			CheckoutDate ChkOutDate,
		    isnull(f.Cleanlinessofrooms,'') Cleanlinessofrooms,isnull(f.QualityofFoodServed,'') QualityofFoodServed,
		    isnull(f.InternetService,'') InternetService,isnull(f.RoomAmbience,'') RoomAmbience,
		    isnull(f.QualityofService,'') QualityofService,isnull(f.OverallStayExperience,'') OverallStayExperience,
			isnull(f.Remarks ,'') Remarks
			from WRBHBFeedBckForms F
			where isactive=1  
			order by Id Desc
		 EnD 
	 End
	   select Id,GuestName,ClientName,PropertyName,CheckIndate,ChkOutDate,Cleanlinessofrooms,
	    QualityofFoodServed,InternetService,RoomAmbience,QualityofService,OverallStayExperience,Remarks
	    from #Testtable
	
 
 End 
 
--exec [dbo].[Sp_CheckOutFeedbackform_Help] @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'C6953DF4-41BB-4BDE-8A34-23B81BA716034',@Str2=N'',@Id1=0,@Id2=0,@UserId=0

--ALTER TABLE WRBHBFeedBckForms
--ADD Email nvarchar(200)

--ALTER TABLE WRBHBFeedBckForms
--Add Mobile nvarchar(200)

--Update WRBHBFeedBckForms set MObile='',Email=''

--Select * from WRBHBFeedBckForms
--where isactive=1
--order by BookingCode desc

--update WRBHBFeedBckForms set isactive=0 where id in(119,59,22,23,8,1,11,39,43,61,2)
--update WRBHBFeedBckForms set clientName='Crisil Limited' where clientId=83
--Select * from WRBHBClientManagement where Id=83
 
   