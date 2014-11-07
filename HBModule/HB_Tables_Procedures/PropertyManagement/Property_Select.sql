SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Property_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_Property_Select]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT USER
		Purpose  	: PROPERTY SEARCH
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date			Signature			Description of Changes
	********************************************************************************************************	
	Sakthi          5 June 2014    UserName Alterations (Previous Taken in PropertyUserTable, Change to UserMaster)              
	*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[sp_Property_Select](  
@SelectId   BigInt,  
@Pram1           BigInt=NULL,   
@Pram2    NVARCHAR(100)=NULL,  
@UserId          BigInt  
)  
AS  
BEGIN  
IF @SelectId <> 0    
BEGIN   
DECLARE @StateId BIGINT,@CityId BIGINT;   
SELECT @StateId=StateId FROM WRBHBProperty P  WHERE IsDeleted=0 AND  P.Id =@SelectId 
SELECT @CityId=CityId FROM WRBHBProperty P  WHERE IsDeleted=0 AND  P.Id =@SelectId 

---NOTE IF U CHANCE ARE ADD ANYTHING TO CHANGE HELP PROCEDURE ALSO IN Copy ACTION
 
 SELECT PropertyName,Code,Category,PropertDescription,Prefix,Propertaddress,C.CityName,  
 L.Locality,S.StateName,Postal,Phone,Directions,Keyword,ServicesSwimPool,ServicesPub,ServicesGym,  
 ServicesRestaurant,ServicesConfHall,ServicesCyberCafe,ServicesLaundry,ShowOnWebsite,  
 LatitudeLongitude,P.Id,P.IsActive,CONVERT(NVARCHAR(100),Date,103) Date,P.StateId,
 P.CityId,P.LocalityId,ISNULL(TotalNoRooms,'') TotalNoRooms ,RackTarrifSingle PropertyRackTarrif,PT.PropertyType,
 PT.Id TypeId,RackTarrifDouble,BookingPolicy,CancelPolicy,Email,CheckIn,CheckInType,CheckOut,CheckOutType,GraceTime
 FROM WRBHBProperty P  
 LEFT OUTER JOIN WRBHBState S ON P.StateId=S.Id  
 LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
 LEFT OUTER JOIN WRBHBLocality L ON P.LocalityId=L.Id 
 LEFT OUTER JOIN dbo.WRBHBPropertyType PT ON PT.Id=P.PropertyType
 WHERE p.IsDeleted=0 AND  P.Id =@SelectId  
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Operations Managers';  
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Resident Managers';  
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Assistant Resident Managers';
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Project Managers';
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Ops Head';
   
 SELECT U.FirstName label,P.UserId,P.UserType,P.Id FROM WRBHBPropertyUsers P
 LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=P.UserId   
 WHERE P.IsDeleted=0 AND U.IsDeleted=0 AND U.IsActive=1 AND
 PropertyId=@SelectId AND UserType='Finance';
   
 SELECT BlockDescription Description,BlockName Block,Id FROM dbo.WRBHBPropertyBlocks  
 WHERE PropertyId=@SelectId AND IsDeleted=0
 
  SELECT CityName label,Id CityId FROM WRBHBCity C WHERE StateId=@StateId
  
  SELECT Locality label,Id LocalityId FROM WRBHBLocality C WHERE CityId=@CityId
   
END   
   
IF @SelectId=0  
BEGIN  
 SELECT PropertyName,C.CityName,S.StateName,Category,p.Id 
 FROM WRBHBProperty P  
 LEFT OUTER JOIN WRBHBState S ON P.StateId=S.Id  
 LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
 WHERE P.IsActive=1 and P.IsDeleted=0
END   
 END  