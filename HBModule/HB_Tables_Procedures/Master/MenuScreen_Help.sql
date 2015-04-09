SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MenuScreen_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_MenuScreen_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: MenuScreen 
		Purpose  	: MenuScreen
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date			Signature			Description of Changes
	********************************************************************************************************	
	*******************************************************************************************************
*/--exec Sp_MenuScreen_Help @PAction=N'DATALOAD',@Pram1=65,@Pram2=0,@Pram3=N'',@UserName=N'',@Password=N''
CREATE PROCEDURE [dbo].[Sp_MenuScreen_Help](
@PAction		 NVARCHAR(100)=NULL,
@Pram1		     BIGINT,
@Pram2           BIGINT=NULL, 
@Pram3			 NVARCHAR(100)=NULL, 
@UserName        NVARCHAR(100),
@Password		 NVARCHAR(100)	
)
AS
BEGIN  
IF @PAction ='User'
BEGIN
DECLARE @USERID BIGINT;
OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';

 SELECT @USERID=Id 
 FROM WRBHBUser 
 WHERE CONVERT(VARCHAR(100),decryptbykey(UserPassword, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName ;
 IF ISNULL(@USERID,0)!=0
 BEGIN
		CREATE TABLE #TEMPUSER(RoleId BIGINT,Roles NVARCHAR(100))
		CREATE TABLE #TEMPSCREENS(SCREENNAME NVARCHAR(100),Id BIGINT,ModuleName NVARCHAR(100),SWF NVARCHAR(100))
		INSERT INTO #TEMPUSER(RoleId,Roles)
		SELECT RolesId,Roles FROM WRBHBUserRoles 
		WHERE UserId=@USERID AND IsActive=1 AND IsDeleted=0 group by RolesId,Roles; 
		INSERT INTO #TEMPSCREENS(SCREENNAME,Id,ModuleName,SWF)
		SELECT B.ScreenName,B.Id,B.ModuleName,SWF FROM dbo.WRBHBRoles S
		LEFT OUTER JOIN dbo.WRBHBRolesRights A WITH(NOLOCK) ON S.Id=A.RolesId AND A.Selected=1 and a.isactive=1 and a.isdelete=0
		LEFT OUTER JOIN dbo.WRBHBScreenMaster B WITH(NOLOCK) ON A.scrId=B.Id AND B.IsDeleted=0 and B.isactive=0
		JOIN #TEMPUSER T WITH(NOLOCK) ON T.RoleId=S.Id
		WHERE S.IsActive=1 AND S.IsDeleted=0 AND Statuss= 'Active'
		  
		SELECT Id,Email,FirstName FROM WRBHBUser WHERE Id=@USERID
		
		SELECT ISNULL(SCREENNAME,'') SCREENNAME,ISNULL(Id,0) Id,ISNULL(ModuleName,'')ModuleName,
		ISNULL(SWF,'')SWF FROM #TEMPSCREENS 
		GROUP BY SCREENNAME,Id,ModuleName,SWF
		
		SELECT ModuleName FROM WRBHBScreenMaster
		WHERE ModuleId=0
		
		SELECT RolesId data,r.RoleName label FROM WRBHBUserRoles ur
		join dbo.WRBHBRoles r on r.Id=ur.RolesId and r.IsActive=1 and r.IsDeleted=0
		WHERE UserId=@USERID and ur.IsActive=1 and ur.IsDeleted=0;
		
 END
 ELSE
 BEGIN
	SELECT 'USER NOT MATCH' as NAME
 END		
END 
IF @PAction ='Roles'
BEGIN
		CREATE TABLE #TEMPUSER1(RoleId BIGINT,Roles NVARCHAR(100))
		CREATE TABLE #TEMPSCREENS1(SCREENNAME NVARCHAR(100),Id BIGINT,ModuleName NVARCHAR(100),SWF NVARCHAR(100))
		INSERT INTO #TEMPUSER1(RoleId,Roles)
		SELECT  RolesId,Roles FROM WRBHBUserRoles
		WHERE RolesId=@Pram1;
		INSERT INTO #TEMPSCREENS1(SCREENNAME,Id,ModuleName,SWF)
		SELECT B.ScreenName,B.Id,B.ModuleName,SWF FROM dbo.WRBHBRoles S
		LEFT OUTER JOIN dbo.WRBHBRolesRights A WITH(NOLOCK) ON S.Id=A.RolesId AND A.Selected=1
		LEFT OUTER JOIN dbo.WRBHBScreenMaster B WITH(NOLOCK) ON A.scrId=B.Id AND  B.IsDeleted=0
		JOIN #TEMPUSER1 T WITH(NOLOCK) ON T.RoleId=S.Id
		WHERE S.IsActive=1 AND IsDelete=0 AND Statuss= 'Active'
		  
		SELECT Id,Email,FirstName FROM WRBHBUser WHERE Id=@Pram2
		
		SELECT ISNULL(SCREENNAME,'') SCREENNAME,ISNULL(Id,0) Id,ISNULL(ModuleName,'')ModuleName,
		ISNULL(SWF,'')SWF FROM #TEMPSCREENS1 
		GROUP BY SCREENNAME,Id,ModuleName,SWF
		
		SELECT ModuleName FROM WRBHBScreenMaster
		WHERE ModuleId=0
		
		
END

IF @PAction ='DATALOAD'
BEGIN
 --Expected CHECKIN
		-- SELECT TOP 10 H.ClientName ,CityName,D.FirstName FirstName,BookingLevel  
		     
		CREATE TABLE #ExpChkin(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(500),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,
		BookingCode BIGINT,Category nvarchar(500),MOP Nvarchar(200) );
	 
	 	TRUNCATE TABLE #ExpChkin;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel+'-'+RoomType as BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,AG.TariffPaymentMode
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Booked','Direct Booked')   and AG.CurrentStatus='Booked'
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkInDt,103) <=CONVERT(date,GETDATE(),103)
	 	and pu.UserId=@Pram1
	 	--and clientName='Jubilant Life Science' and BookingCode=3400
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.TariffPaymentMode,RoomType
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel+'-'+RoomType as BookingLevel,
		convert(nvarchar(100),Ag.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		P.Category,AG.TariffPaymentMode
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
	 	and pu.UserId=@Pram1
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,RoomType,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,Ag.TariffPaymentMode
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+'-'+ABPA.ApartmentType as BookingLevel,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.TariffPaymentMode
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 and CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103)  
		 and pu.UserId=@Pram1
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,p.Id,ABPA.ApartmentType,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+'-'+ABPA.ApartmentType as BookingLevel,
		  convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  P.Category,ABPA.TariffPaymentMode
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
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,ABPA.ApartmentType,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+''+BedType,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.TariffPaymentMode
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.Status IN('Booked','Direct Booked')  and H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='Booked'
		 and  CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,BedType,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkin(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,Category,MOP)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel+''+BedType,
		 convert(nvarchar(100),ABPA.ChkInDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 P.Category,ABPA.TariffPaymentMode
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
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkInDt,BedType,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc 
		 
    UPDATE  #ExpChkin  
    SET Category=C.PropertyType
    FROM #ExpChkin CC
    JOIN  WRBHBBookingProperty C ON C.PropertyId=cc.PropertyId and c.isactive=1
    and C.BookingId=CC.BookedId
    where Category!='';
      delete #ExpChkin where Category='Cpp' and MOP!='Bill to Company (BTC)'
    --#GRID VALUES 1 FOR TABLE0 
      select  BookedId,PropertyName,PropertyId,GuestName as FirstName,BookingLevel,Category,
      Convert(nvarchar(100),ExpDate,103) ExpDate,C.CityName,CityId,ClientName,ClientId,BookingCode,MOP
       from #ExpChkin F
       left join WRBHBCity C on c.Id=F.CityId
      where Convert(date,ExpDate,103)>= CONVERT(date,'01/09/2014',103) 
      and PropertyName!='' and ClientName!='' --and Category='CPP'
      group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
      ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,Category,MOP
      order by Convert(date,ExpDate,103)
  --  Return;   
--EXPECTED CHECKOUT
			     
		CREATE TABLE #ExpChkout(BookedId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,
		GuestName NVARCHAR(200),BookingLevel NVARCHAR(200),ExpDate NVARCHAR(100),
		CityName NVARCHAR(200),CityId Bigint,ClientName NVARCHAR(100),ClientId BIGINT,
		BookingCode BIGINT,CheckInHdrId Bigint ,Category nvarchar(500),MOP Nvarchar(200) );
	 
	 
   	create TABLE #TEMPFINALCHKOUTS(GuestName NVARCHAR(200),GuestId BIGINT,CityId BIGINT,BookingId BIGINT,
   ChkOutDate NVARCHAR(200),Type NVARCHAR(200), PropertyName NVARCHAR(200) ,CityName NVARCHAR(200),CheckInHdrId Bigint,
   Category nvarchar(500),MOP Nvarchar(200) ,PropertyId Bigint)
   
   
   
	 	TRUNCATE TABLE #ExpChkout;
-- Room Level Property booked and direct booked	 
       INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel+' '+RoomType,
		convert(nvarchar(100),Ag.ChkOutDt,103) AS ExpDate,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		AG.CheckInHdrId,P.Category,AG.TariffPaymentMode
		FROM WRBHBBooking H
		--JOIN WRBHBBookingProperty A WITH(NOLOCK) ON H.Id= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		JOIN WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON H.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = AG.BookingpropertyId and P.IsActive = 1 --and A.IsDeleted = 0
		JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
        JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE    AG.CurrentStatus='CheckIn' and AG.RoomShiftingFlag=0
		and H.Cancelstatus !='Canceled' and CONVERT(date,Ag.ChkInDt,103) <=CONVERT(date,GETDATE(),103)
	 	and pu.UserId=@Pram1
	 	--and clientName='Jubilant Life Science' and BookingCode=3400
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkOutDt,P.Id,RoomType,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode
		order by H.Id desc
		
		    
 -- Room Level Property booked and direct booked  
     INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
        select distinct H.Id, P.PropertyName PropertyName,P.Id,AG.FirstName FirstName,H.BookingLevel+' '+RoomType,
		convert(nvarchar(100),Ag.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode
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
	 	and pu.UserId=@Pram1
		group by H.Id, P.PropertyName,AG.FirstName,H.BookingLevel,Ag.ChkOutDt,RoomType,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,Ag.CheckInHdrId,P.Category,AG.TariffPaymentMode
		order by H.Id desc
--APARTMENT
      INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
         select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+' '+ABPA.ApartmentType,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode
		  FROM WRBHBBooking H
		-- JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id = ABPA.BookingId AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
         JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE  H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103)  
		 and pu.UserId=@Pram1
		group by H.Id, p.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,p.Id,ABPA.ApartmentType,
		p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode
		order by H.Id desc 
--APARTMENT   
 	 INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
 	      SELECT DISTINCT H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+' '+ABPA.ApartmentType,
		  convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		  0,P.Category,ABPA.TariffPaymentMode
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
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,ABPA.ApartmentType,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc
		
-- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
		 select distinct H.Id, p.PropertyName PropertyName,p.Id,ABPA.FirstName FirstName,H.BookingLevel+' '+BedType,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode
		 FROM WRBHBBooking H
		 --JOIN WRBHBApartmentBookingProperty ABP WITH(NOLOCK) ON H.Id = ABP.BookingId AND ABP.IsActive = 1 AND ABP.IsDeleted = 0
		 JOIN WRBHBBedBookingPropertyAssingedGuest ABPA WITH(NOLOCK) ON H.Id= ABPA.BookingId  AND ABPA.IsActive = 1 AND ABPA.IsDeleted = 0
		 JOIN WRBHBProperty P WITH(NOLOCK) ON P.Id = ABPA.BookingPropertyId and P.IsActive = 1 and P.IsDeleted = 0
		 JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUser U WITH(NOLOCK) ON   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0
		 JOIN WRBHBUserRoles R WITH(NOLOCK) ON  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0 
		 WHERE   H.CancelStatus!='Canceled'  and ABPA.CurrentStatus='CheckIn'
		 and  CONVERT(date,ABPA.ChkInDt,103) <= CONVERT(date,GETDATE(),103) 
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,BedType,
		P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode  ,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc
		
		
 -- Bed Level Booked and DirectBooked Property
  INSERT INTO #ExpChkout(BookedId,PropertyName,PropertyId,GuestName,BookingLevel,ExpDate,CityName,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP)
		 SELECT DISTINCT H.Id, p.PropertyName PropertyName,P.Id,ABPA.FirstName FirstName,H.BookingLevel+' '+BedType,
		 convert(nvarchar(100),ABPA.ChkOutDt,103) ExpDate ,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,
		 0,P.Category,ABPA.TariffPaymentMode
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
		 and pu.UserId=@Pram1
		 group by H.Id, P.PropertyName,ABPA.FirstName,H.BookingLevel,ABPA.ChkOutDt,BedType,
		 P.Id,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,ABPA.TariffPaymentMode
		 order by H.Id desc 
    --#GRID VALUES 1 FOR TABLE0 
    
    
	
    INSERT INTO #TEMPFINALCHKOUTS(GuestName,GuestId,Type, PropertyName,ChkOutDate,CityName,CityId,BookingId,CheckInHdrId, Category ,MOP,PropertyId )
      select  GuestName as FirstName,0 as GuestId,BookingLevel Type,PropertyName, --PropertyId,BookingLevel,
      Convert(nvarchar(100),ExpDate,103) CheckOutDate,C.CityName CityName,CityId,BookedId,CheckInHdrId--ClientName,ClientId,BookingCode
      ,Category ,MOP,PropertyId
       from #ExpChkout F
       left join WRBHBCity C on c.Id=F.CityId
      where Convert(date,ExpDate,103)<= CONVERT(date,GETDATE(),103) 
      group by BookedId,PropertyName,PropertyId,GuestName,BookingLevel,
      ExpDate,c.CityName ,CityId,ClientName,ClientId,BookingCode,CheckInHdrId,Category,MOP,PropertyId
      order by Convert(date,ExpDate,103)
       
    UPDATE  #TEMPFINALCHKOUTS  
    SET Category=C.PropertyType
    FROM #TEMPFINALCHKOUTS CC
    JOIN  WRBHBBookingProperty C ON C.PropertyId=cc.PropertyId and c.isactive=1
     and C.BookingId=CC.BookingId
    where Category!='';
    
      delete #TEMPFINALCHKOUTS where Category='Cpp' and MOP!='Bill to Company (BTC)'
        
      
       Select C.ChkInGuest GuestName ,C.Id,c.BookingId,C.RoomNo,C.RoomId ,
        B.GuestId,B.Type, B.PropertyName,B.ChkOutDate CheckOutDate,B.CityName,B.CityId,B.Category,B.MOP
        from WRBHBCheckInHdr c
        join #TEMPFINALCHKOUTS B on b.BookingId=c.BookingId --and C.Id=b.CheckInHdrId
        where IsActive=1 and IsDeleted=0
       group by  B.GuestId,B.Type, B.PropertyName,B.ChkOutDate,B.CityName,B.CityId,
       C.ChkInGuest,C.Id,c.BookingId,C.RoomNo,C.RoomId,B.Category,B.MOP
       order by Id desc
 --return;
-- NEW PROPERTY WISE
CREATE TABLE #PROPWSE(PropertyName NVARCHAR(200),Code NVARCHAR(200),Category NVARCHAR(200),CityName NVARCHAR(200),PrtyId BIGINT,Locality nvarchar(100))
    INSERT INTO #PROPWSE(PropertyName,Code,Category,CityName,PrtyId,Locality )
		SELECT TOP 15 PropertyName,Code,Category,C.CityName,P.Id,Locality  FROM WRBHBProperty P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		join WRBHBLocality L with(nolock)on p.LocalityId=L.Id and L.IsActive=1
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id  and PU.IsActive = 1 and
		PU.IsDeleted = 0 and pu.userid=@Pram1
		WHERE   P.IsActive = 1 and P.IsDeleted = 0 AND Category='External Property'
		ORDER BY P.Id DESC
		
		INSERT INTO #PROPWSE(PropertyName,Code,Category,CityName,PrtyId,Locality )
		SELECT TOP 15 PropertyName,Code,Category,C.CityName,P.Id ,Locality FROM WRBHBProperty P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		join WRBHBLocality L with(nolock)on p.LocalityId=L.Id and L.IsActive=1
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id  and PU.IsActive = 1 and 
		PU.IsDeleted = 0 and pu.userid=@Pram1
		WHERE   P.IsActive = 1 and P.IsDeleted = 0 AND Category='Internal Property' 
		ORDER BY P.Id DESC
		
		INSERT INTO #PROPWSE(PropertyName,Code,Category,CityName,PrtyId,Locality )
		SELECT TOP 15 PropertyName,Code,Category,C.CityName,P.Id ,Locality FROM WRBHBProperty P
		join WRBHBCity C  WITH(NOLOCK) ON C.Id = P.CityId and C.IsActive = 1
		join WRBHBLocality L with(nolock)on p.LocalityId=L.Id and L.IsActive=1
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id  and PU.IsActive = 1
		and PU.IsDeleted = 0 and pu.userid=27
		WHERE   P.IsActive = 1 and P.IsDeleted = 0 AND Category='Managed G H'
		ORDER BY P.Id DESC
		
     SELECT PropertyName,Code,Category,CityName City,PrtyId,Locality FROM #PROPWSE P
	 join WRBHBPropertyUsers PU on PU.PropertyId = P.PrtyId
	 and PU.IsActive = 1 and PU.IsDeleted = 0 
	 WHERE PU.UserId=@Pram1
     group by PropertyName,Code,Category,CityName,PrtyId,Locality 
		
-- NEW CLIENT PROCESS		
		SELECT TOP 20 C.ClientName,C.CState,C.CCity,C.CLocality ,C.Id,R.ClientName as  MasterClient  
		FROM WRBHBMasterClientManagement R 
	 	 join  WRBHBClientManagement C on r.Id=C.MasterClientId and r.IsActive=1 and r.IsDeleted=0
		where --C.KeyAccountPersonId=65 or CRMId=65
		c.IsActive=1 and c.IsDeleted=0 
		ORDER BY ID DESC
 --NEW GUEST PROCESS  
		CREATE TABLE  #GuestWise(FirstName  NVARCHAR(200),LastName  NVARCHAR(200),BookingId BIGINT,Email  NVARCHAR(200),)
		
		INSERT INTO #GuestWise(FirstName,LastName,BookingId,Email)
		SELECT TOP 15 BA.FirstName,BA.LastName,B.Id ,D.EmailId 
		FROM WRBHBBookingGuestDetails D
		JOIN WRBHBBooking B ON B.Id=D.BookingId
		JOIN WRBHBBookingPropertyAssingedGuest BA ON BA.BookingId=B.Id
		WHERE B.IsActive=1 AND B.IsDeleted=0 AND D.IsActive=1 AND D.IsDeleted=0
		AND BA.IsActive=1 AND BA.IsDeleted=0
		GROUP BY  BA.FirstName,BA.LastName,D.EmailId ,B.Id
		ORDER BY B.ID DESC

		 
		INSERT INTO #GuestWise(FirstName,LastName,BookingId,Email)
		SELECT TOP 15 BA.FirstName,BA.LastName ,B.Id ,D.EmailId 
		FROM WRBHBBookingGuestDetails D
		JOIN WRBHBBooking B ON B.Id=D.BookingId
		JOIN WRBHBBedBookingPropertyAssingedGuest BA ON BA.BookingId=B.Id
		WHERE B.IsActive=1 AND B.IsDeleted=0 AND D.IsActive=1 AND D.IsDeleted=0
		AND BA.IsActive=1 AND BA.IsDeleted=0
		GROUP BY  BA.FirstName,BA.LastName,D.EmailId ,B.Id
		ORDER BY B.ID DESC
		 

		INSERT INTO #GuestWise(FirstName,LastName,BookingId,Email) 
		SELECT TOP 15 BA.FirstName,BA.LastName ,B.Id ,D.EmailId 
		FROM WRBHBBookingGuestDetails D
		JOIN WRBHBBooking B ON B.Id=D.BookingId
		JOIN WRBHBApartmentBookingPropertyAssingedGuest BA ON BA.BookingId=B.Id
		WHERE B.IsActive=1 AND B.IsDeleted=0 AND D.IsActive=1 AND D.IsDeleted=0
		AND BA.IsActive=1 AND BA.IsDeleted=0
		GROUP BY  BA.FirstName,BA.LastName,D.EmailId ,B.Id
		ORDER BY B.ID DESC
		
		
		Select TOP 20 FirstName,LastName,Email EmailId from #GuestWise
		group by FirstName,LastName,Email
-- NEW CLIENTCONTRACTS		
		--SELECT TOP 15 ContractName,Client,ContractType,CONVERT(NVARCHAR(100),AgreementDate,103) AgreementDate
		--FROM WRBHBContractManagement
		--ORDER BY ID DESC
		CREATE TABLE #ClientContract(ContractName NVARCHAR(100),Client NVARCHAR(100),ContractType NVARCHAR(100),AgreementDate NVARCHAR(100),CnId BIGINT)

		INSERT INTO #ClientContract(ContractName,Client,ContractType,AgreementDate,CnId)

		SELECT TOP 15 CM.ContractName,CM.Client,CM.ContractType,
		CONVERT(NVARCHAR(100),CM.AgreementDate,103) AgreementDate,CM.Id
		FROM WRBHBContractManagement CM
		LEFT OUTER JOIN WRBHBContractManagementAppartment CA ON CM.Id=CA.ContractId AND CA.IsActive=1 AND CA.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON CA.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE   CM.IsActive=1 AND CM.IsDeleted=0 and pu.UserId=@Pram1
		order by Cm.Id desc --CM.AgreementDate

		INSERT INTO #ClientContract(ContractName,Client,ContractType,AgreementDate,CnId)

		SELECT TOP 15 ContractName,Client,ContractType,CONVERT(NVARCHAR(100),StartDate,103) AgreementDate,CN.Id
		FROM WRBHBContractNonDedicated CN
		LEFT OUTER JOIN WRBHBContractNonDedicatedApartment CA ON CN.Id=CA.NondedContractId AND CA.IsActive=1 AND CA.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON CA.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE CN.IsActive=1 AND CN.IsDeleted=0 and pu.UserId=@Pram1
		--group by 
		order by  CONVERT(NVARCHAR(100),StartDate,103) desc
		
         SELECT ContractName,Client,ContractType,AgreementDate,CnId from #ClientContract
         group by ContractName,Client,ContractType,AgreementDate,CnId 
--TODAYS SALE Grid 7 for front End
        SELECT TOP 15 Property,ClientName,ChkOutTariffNetAmount,InVoiceNo as InVoiceNo ,
        Convert(NVARCHAR(100),BillDate,103)  ChkOutDate
        FROM WRBHBChechkOutHdr H 
        JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON   U.Id=pu.UserId AND U.IsActive=1 AND U.IsDeleted=0
		WHERE H.IsActive=1 AND H.IsDeleted=0 and PaymentStatus='Paid' and pu.UserId=@Pram1 
		Group by Property,ClientName,ChkOutTariffNetAmount,InVoiceNo,BillDate--,H.Id
		ORDER BY Convert(NVARCHAR(100),BillDate,103),InVoiceNo DESC
		
		
 --Grid 8 For PettyCash 
 
		CREATE TABLE #PettycashRequest(Requestedby NVARCHAR(100),PCAccount NVARCHAR(100),RequestedStatus NVARCHAR(100),
		ProcessedStatus NVARCHAR(100),Comments NVARCHAR(100),RequestedOn NVARCHAR(100),Process BIT,
		RequestedAmount DECIMAL(27,2),Processedon NVARCHAR(100),Processedby NVARCHAR(100),RequestedUserId INT,Id INT,PropertyId INT)
		
	 	 
		INSERT INTO #PettycashRequest(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
		
		SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount,PC.RequestedStatus AS RequestedStatus,
		PC.ProcessedStatus AS ProcessedStatus,PC.Comments AS Comments,
		CONVERT(NVARCHAR(100),PC.RequestedOn,103) AS RequestedOn,0 AS Process,
		PC.RequestedAmount AS RequestedAmount,
		CONVERT(NVARCHAR(100),pc.LastProcessedon,103) AS Processedon,(US.FirstName+' '+US.LastName) AS Processedby,
		PC.RequestedUserId AS RequestedUserId, PC.Id,
		PC.PropertyId
		From WRBHBPettyCashApprovalDtl PC
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.RequestedUserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		JOIN WRBHBUser US ON PC.UserId=US.Id AND US.IsActive=1 AND US.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PU.UserId=@Pram1 AND
		 PC.Process=1 AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Resident Managers','Assistant Resident Managers','Operations Managers',
		'Ops Head','Finance')	
		
				
		INSERT INTO #PettycashRequest(Requestedby,PCAccount,RequestedStatus,ProcessedStatus,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId)
		
		SELECT  DISTINCT (U.FirstName+' '+U.LastName) AS Requestedby,P.PropertyName AS PCAccount
		,PcDTL.Status AS RequestedStatus,'Waiting For Operation Manager Approval' AS ProcessedStatus,'Processing' AS Comments,
		CONVERT(NVARCHAR(100),PC.Date,103) AS RequestedOn,0 AS Process,
		SUM(PcDTL.Amount) AS RequestedAmount,CONVERT(NVARCHAR(100),GETDATE(),103) AS Processedon,
		 'Process' AS Processedby,PC.UserId AS RequestedUserId, 0 AS Id,
		PC.PropertyId
		From WRBHBPettyCashHdr PC
		join WRBHBPettyCash PcDTL on pc.Id=PcDTL.PettyCashHdrId and PcDTL.IsActive=1 and PcDTL.IsDeleted=0
		JOIN WRBHBProperty P ON PC.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  PC.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE PC.IsActive=1 AND PC.IsDeleted=0 AND PC.Flag=0 
		AND Remark=0 AND PU.UserId=@Pram1 
		AND P.Category IN('Internal Property','Managed G H')
		AND PU.UserType IN('Operations Managers')
		group by  U.FirstName,U.LastName,P.PropertyName,PcDTL.Status,PC.Date,PC.UserId,PC.PropertyId
	
		
		SELECT top 15  Requestedby,PCAccount Property,RequestedStatus,ProcessedStatus,Comments,
		RequestedOn,Process,RequestedAmount,Processedon,Processedby,RequestedUserId,Id,PropertyId 
		FROM #PettycashRequest
		order by Id desc;
 --Grid-9
		Select top 15   D.InvoiceNo , CONVERT(NVARCHAR(100), H.DepositedDate ,103) DDate,H.Amount,D.ClientId
		from WRBHBDeposits H
		JOIN WRBHBDepositsDlts D  WITH (NOLOCK) ON H.Id=D.DepHdrId  AND D.IsActive=1 AND D.IsDeleted=0
		JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON H.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  Pu.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0	and pu.UserId=@Pram1 
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND Mode='Cash'
		group by D.InvoiceNo , H.Id,CONVERT(NVARCHAR(100), H.DepositedDate ,103) ,H.Amount,D.ClientId
		order by H.Id desc
 --Grid-10
		Select top 15  D.InvoiceNo , CONVERT(NVARCHAR(100), H.DepositedDate ,103) DDate,H.Amount,D.ClientId 
		from WRBHBDeposits H
		JOIN WRBHBDepositsDlts D  WITH (NOLOCK) ON H.Id=D.DepHdrId  AND D.IsActive=1 AND D.IsDeleted=0
		JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON H.PropertyId=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON  Pu.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0	and pu.UserId=@Pram1 
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND Mode='Cheque'
		group by D.InvoiceNo , H.Id,CONVERT(NVARCHAR(100), H.DepositedDate ,103) ,H.Amount,D.ClientId
		order by H.Id desc
 --Grid -11
 

		Create Table #FinalChkout(Property nvarchar(1000),ClientName nvarchar(1000),ChkOutTariffNetAmount decimal(27,2),
		BookingNo bigint,ChkOutDate nvarchar(50))
		insert into #FinalChkout(Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate)

        SELECT  Property,H.ClientName ClientName,ChkOutTariffNetAmount,B.BookingCode as BookingNo,
        Convert(NVARCHAR(100),BillDate,103)  ChkOutDate
        FROM WRBHBChechkOutHdr H 
        join WRBHBBooking B on h.BookingId= B.Id and b.IsActive=1 and b.IsDeleted=0
        JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		JOIN WRBHBUser U ON   U.Id=pu.UserId AND U.IsActive=1 AND U.IsDeleted=0
		WHERE H.IsActive=1 AND H.IsDeleted=0 and PaymentStatus='UnPaid' and pu.UserId=@Pram1 
		AND PU.UserType IN('Resident Managers','Operations Managers','Ops Head','Finance','Super Admin')
		Group by Property,H.ClientName,ChkOutTariffNetAmount,B.BookingCode,BillDate,H.Id,B.Id
		ORDER BY  Convert(NVARCHAR(100),BillDate,103)  
		
		
		
		
		Select Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate from #FinalChkout
		where Convert(date,ChkOutDate,103)>= CONVERT(date,'01/09/2014',103) 
		Group by Property,ClientName,ChkOutTariffNetAmount,BookingNo,ChkOutDate
		
END
 	END
 