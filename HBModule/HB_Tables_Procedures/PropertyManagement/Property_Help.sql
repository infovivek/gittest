IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Property_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_Property_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT USER
		Purpose  	: PROPERTY Help
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date		   Description of Changes
	********************************************************************************************************	
	Sakthi          5 June 2014    UserName Alterations (Previous Taken in PropertyUserTable, Change to UserMaster)              
	*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[sp_Property_Help](
@PAction		 NVARCHAR(100)=NULL,
@PropertyId      BIGINT,
@Pram1           BIGINT=NULL, 
@Pram2			 NVARCHAR(400)=NULL, 
@Pram3			 NVARCHAR(400)=NULL,
@UserId          BIGINT
)
AS
BEGIN 

IF @PAction='Type'
BEGIN
	SELECT PropertyType as label, Id as data FROM WRBHBPropertyTYPE
END

IF @PAction ='State'
BEGIN
			SELECT  StateName label,Id AS StateId FROM WRBHBState 
			WHERE IsActive=1  
			
END  
IF @PAction ='City'
BEGIN
			SELECT  CityName label,Id AS CityId FROM WRBHBCity 
			WHERE IsActive=1   AND StateId=@Pram1;
END  
IF @PAction ='Locality'
BEGIN
			SELECT  Locality label,Id AS LocalityId FROM WRBHBLocality 
			where  IsActive=1  AND CityId=@Pram1;
END 
IF @PAction ='ImageCount'
BEGIN
			SELECT ISNULL(COUNT(*),0) CNT FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId
			
			SELECT ImageName,ImageLocation,Id FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0
END
IF @PAction ='ImageDelete'
BEGIN
			UPDATE WRBHBPropertyImages SET IsActive=0 , IsDeleted=1  
			WHERE Id=@Pram1
			
			SELECT ISNULL(COUNT(*),0) CNT FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId
			
			SELECT ImageName,ImageLocation,Id FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0
END
IF @PAction ='ImageUpload'
BEGIN
			INSERT INTO dbo.WRBHBPropertyImages(PropertyId,ImageLocation,ImageName,CreatedBy,CreatedDate,ModifiedBy,
			ModifiedDate,IsActive,IsDeleted,RowId)
			SELECT @PropertyId,@Pram2,@Pram3,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID()
			
			SELECT ISNULL(COUNT(*),0) CNT FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId
			
			SELECT ImageName,ImageLocation,Id FROM WRBHBPropertyImages
			WHERE PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0
END
IF @PAction ='User'
BEGIN
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
			WHERE  hd.IsActive=1 AND hd.IsDeleted=0  AND  rl.Roles='Operations Managers';
			
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
			WHERE   hd.IsActive=1 AND hd.IsDeleted=0 AND  rl.Roles='Resident Managers';
			
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
			WHERE  hd.IsActive=1 AND hd.IsDeleted=0  AND  rl.Roles='Assistant Resident Managers';
			
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
			WHERE  hd.IsActive=1 AND hd.IsDeleted=0  AND  rl.Roles='Project Managers';
			
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
			WHERE  hd.IsActive=1 AND hd.IsDeleted=0 AND  rl.Roles='Other Roles';
			
			SELECT  FirstName label,hd.Id UserId,0 as Id,rl.Roles UserType FROM dbo.WRBHBUser hd
			  join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0 
			WHERE   hd.IsActive=1 AND hd.IsDeleted=0 AND  rl.Roles='Sales';
END 
IF @PAction ='UserDelete'
BEGIN
			UPDATE WRBHBPropertyUsers SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 WHERE Id =@PropertyId;
END

IF @PAction ='BlockDelete'
BEGIN
			UPDATE WRBHBPropertyBlocks SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 WHERE Id =@PropertyId;
END
IF @PAction='ROOMSANDBEDSDELETE'
BEGIN
			UPDATE WRBHBPropertyRooms SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 WHERE Id=@PropertyId
END
IF @PAction ='Block'
BEGIN
			SELECT BlockName AS label,Id FROM WRBHBPropertyBlocks   
			WHERE PropertyId=@PropertyId AND IsDeleted=0;
END
IF @PAction ='RoomCategory'
BEGIN
			CREATE TABLE #TEMPRoomCategory(RoomCategory NVARCHAR(100))
			INSERT INTO #TEMPRoomCategory(RoomCategory)
			SELECT 'Single'
			
			INSERT INTO #TEMPRoomCategory(RoomCategory)
			SELECT 'Double'
			
			INSERT INTO #TEMPRoomCategory(RoomCategory)
			SELECT 'Multiple Beds'
			
			SELECT RoomCategory FROM #TEMPRoomCategory
END
IF @PAction ='RoomType'
BEGIN
			CREATE TABLE #TEMPRoomType(RoomType NVARCHAR(100))
			INSERT INTO #TEMPRoomType(RoomType)
			SELECT 'Attached'
			
			INSERT INTO #TEMPRoomType(RoomType)
			SELECT 'Non Attached'
			
			SELECT RoomType FROM #TEMPRoomType
END
IF @PAction ='Managed'
BEGIN
	
			SELECT r.PropertyId,B.BlockName Block,R.BlockId,A.ApartmentNo,R.ApartmentId,R.RoomType,
		   R.RoomNo,R.RackTariff,R.DoubleOccupancyTariff,R.RoomCategory,
		   R.DiscountModePer,R.DiscountModeRS,R.DiscountAllowed,R.Id,A.SellableApartmentType,
		   r.RoomStatus
		   FROM WRBHBPropertyRooms R
		   LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON R.BlockId=B.Id
		   LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON R.ApartmentId=A.Id
		   WHERE R.PropertyId=@PropertyId AND r.IsActive=1;
END

 IF @PAction ='Apartment'
 BEGIN
 DECLARE @SelectId BIGINT;
DECLARE @StateId BIGINT,@CityId BIGINT;
	IF	@Pram2!='Internal Property'
	BEGIN
		SELECT PropertyName AS ApartmentName,0 Id,Id ApartmentId FROM WRBHBProperty 
		WHERE IsDeleted=0 AND Category in ('External Property','Client Prefered','Other Hotels');
		
		SELECT Bank FROM dbo.WRBHBPropertyOwners
		WHERE PropertyId=@PropertyId AND ISNULL(Bank,'')!='' AND IsDeleted=0 group by Bank;
		
	
	 SELECT TOP 1 @SelectId=p.Id
	 FROM dbo.WRBHBPropertyOwners p	  
	 LEFT OUTER JOIN WRBHBPropertyOwnerProperty A ON A.OwnerId=P.Id
	 WHERE  p.IsDeleted=0 AND P.IsActive=1  AND A.PropertyId=@PropertyId 
	
	--SELECT @PropertyId=PropertyId FROM WRBHBPropertyOwners p WHERE p.IsDeleted=0 AND p.Id=@SelectId and PropertyId=@Pram1;
	SELECT @Pram2=Category  FROM WRBHBProperty 
	WHERE IsDeleted=0 AND Id=@PropertyId;
	
	  
	SELECT @StateId=StateId FROM WRBHBPropertyOwners P   WHERE p.IsDeleted=0 AND p.Id=@SelectId ;
	
	SELECT @CityId=CityId FROM WRBHBPropertyOwners P  WHERE IsDeleted=0 AND  P.Id =@SelectId ;
	  
	SELECT PropertyId,Title,FirstName,Lastname,LedgerName,EmailID,
	Phone,Alternatephone,TDSPer,Address,C.CityName City, LocalityArea,S.StateName State,
	Postal,PaymentMode,PayeeName,AccountNumber,AccountType,Bank,
	BranchAddress,IFSC,SWIFTCode,PANNO,TIN,ST,VAT,p.StateId,p.CityId,LocalityId,P.Id 
	FROM WRBHBPropertyOwners p 
	LEFT OUTER JOIN WRBHBState S ON P.StateId=S.Id  
	LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
	LEFT OUTER JOIN WRBHBLocality L ON P.LocalityId=L.Id   
	WHERE p.IsDeleted=0 AND p.Id=@SelectId ; 
	
	IF @Pram2='Internal Property'
	BEGIN
		SELECT ApartmentId,ApartmentName,Id ,0 AS Tick 
		FROM WRBHBPropertyOwnerApartment Ap 
		WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
		
		SELECT ApartmentNo ApartmentName ,0 Id,Id ApartmentId ,0 AS Tick 
		FROM dbo.WRBHBPropertyApartment
		WHERE PropertyId=@PropertyId AND IsDeleted=0;
    END
    ELSE
    BEGIN
		SELECT PropertyId ApartmentId,PropertyName ApartmentName,Id ,0 AS Tick 
		FROM WRBHBPropertyOwnerProperty Ap 
		WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
		
		SELECT PropertyName AS ApartmentName,0 Id,Id ApartmentId ,0 AS Tick  FROM WRBHBProperty 
		WHERE IsDeleted=0 AND Category in ('External Property');
	END
	
	SELECT CityName label,Id data FROM WRBHBCity C WHERE StateId=@StateId
	SELECT Locality label,Id LocalityId FROM WRBHBLocality C WHERE CityId=@CityId
	
	SELECT Name,EmailId,ContactType,PhoneNumber,designation,Id
	FROM WRBHBPropertyOwnerOtherContacts
	WHERE OwnerId=@SelectId
		
	END
	ELSE
	BEGIN
		SELECT B.BlockName+' - '+ApartmentNo ApartmentName ,0 Id,A.Id ApartmentId FROM dbo.WRBHBPropertyApartment A
		LEFT OUTER JOIN dbo.WRBHBPropertyBlocks B ON A.BlockId=B.Id and b.IsDeleted=0
		WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0;
		
		SELECT Bank FROM dbo.WRBHBPropertyOwners
		WHERE PropertyId=@PropertyId AND ISNULL(Bank,'')!='' AND IsDeleted=0 group by Bank;	
		
		
	END
		
 END
 IF @PAction ='Copy'
 BEGIN
		 SELECT PropertyName,Code,Category,PropertDescription,Prefix,Propertaddress,C.CityName,  
		 L.Locality,S.StateName,Postal,Phone,Directions,Keyword,ServicesSwimPool,ServicesPub,ServicesGym,  
		 ServicesRestaurant,ServicesConfHall,ServicesCyberCafe,ServicesLaundry,ShowOnWebsite,  
		 LatitudeLongitude,0 Id,P.IsActive,CONVERT(NVARCHAR(100),Date,103) Date,P.StateId,
		 P.CityId,P.LocalityId,ISNULL(TotalNoRooms,'') TotalNoRooms ,RackTarrifSingle PropertyRackTarrif,
		 PT.PropertyType,PT.Id TypeId,RackTarrifDouble,BookingPolicy,CancelPolicy,Email,CheckOutType
		 FROM WRBHBProperty P  
		 LEFT OUTER JOIN WRBHBState S ON P.StateId=S.Id  
		 LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
		 LEFT OUTER JOIN WRBHBLocality L ON P.LocalityId=L.Id 
		 LEFT OUTER JOIN dbo.WRBHBPropertyType PT ON PT.Id=P.PropertyType
		 WHERE p.IsDeleted=0 AND  P.Id =@PropertyId  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Operations Managers'  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Resident Managers'  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Assistant Resident Managers'  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Project Managers'  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Other Roles'  
		   
		 SELECT U.FirstName label,P.UserId,P.UserType,0 Id FROM WRBHBPropertyUsers P
		 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
		 WHERE P.IsDeleted=0 AND U.IsActive=1 AND U.IsDeleted=0 AND  
		 P.PropertyId =@PropertyId AND P.UserType='Sales'  
		   
		 SELECT BlockDescription Description,BlockName Block,0 Id FROM dbo.WRBHBPropertyBlocks  
		 WHERE PropertyId=@PropertyId AND IsDeleted=0  
 END
  
END

