SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[HBMenu_MenuScreen_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[HBMenu_MenuScreen_Help]
GO 
 /* 
       Author Name : <Anbu>
		Created On 	: <Created Date (28/01/2015)  >
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
CREATE PROCEDURE [dbo].[HBMenu_MenuScreen_Help](
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
Declare @Designation Nvarchar(200)
OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';

 SELECT @USERID=Id 
 FROM WrbhbTravelDesk  
 WHERE CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName ;
 
 Set @Designation=( Select Designation FROM WrbhbTravelDesk  
 WHERE CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr'))) =@Password
 AND IsDeleted=0 AND IsActive=1 AND Email=@UserName )
 IF ISNULL(@USERID,0)!=0
 BEGIN
		SELECT Id,Email,FirstName,ClientId FROM WrbhbTravelDesk WHERE Id=@USERID
		
		SELECT C.ClientLogo as Logo FROM WrbhbTravelDesk T 
		JOIN WRBHBClientManagement C ON T.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE T.Id=@USERID AND T.IsActive=1 AND T.IsDeleted=0
		
		SELECT ISNULL(SCREENNAME,'') SCREENNAME,ISNULL(Id,0) Id,ISNULL(ModuleName,'')ModuleName,
		ISNULL(SWF,'')SWF FROM WRBHBMENU_ScreenMaster 
		WHERE ISNULL(SWF,'')!=''-- ModuleName IN('Master','Report','Booking')
		GROUP BY SCREENNAME,Id,ModuleName,SWF
		
		SELECT ModuleName,moduleId FROM WRBHBMENU_ScreenMaster
	    WHERE moduleId!=0--ModuleName IN('Master','Report','Booking')
	    GROUP BY ModuleName,moduleId
	    order by moduleId
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
		and ClientId=@Pram1 	--and pu.UserId=@Pram1
	 	--and clientName='Jubilant Life Science' and BookingCode=3400
		group by H.Id, P.PropertyName,H.ClientName ,H.CityName,AG.FirstName,H.BookingLevel,Ag.ChkInDt,P.Id
		,p.City,p.CityId,H.ClientName,H.ClientId,BookingCode,P.Category,AG.TariffPaymentMode,RoomType
		order by H.Id desc 
		  
 
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
   END
END
 