SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwner_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwner_Select]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY OWNER USER
		Purpose  	: PROPERTYOWNER SEARCH
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
CREATE PROCEDURE [dbo].[sp_PropertyOwner_Select](  
@SelectId   BigInt,  
@Pram1           BigInt=NULL,   
@Pram2    NVARCHAR(100)=NULL,  
@UserId          BigInt  
)  
AS  
BEGIN  
IF @SelectId <> 0    
BEGIN        
	DECLARE @PropertyId bigint;
	SELECT @PropertyId=PropertyId FROM WRBHBPropertyOwners p WHERE p.IsDeleted=0 AND p.Id=@SelectId and PropertyId=@Pram1;
	SELECT @Pram2=Category  FROM WRBHBProperty 
	WHERE IsDeleted=0 AND Id=@PropertyId;
	DECLARE @StateId BIGINT,@CityId BIGINT; 
	  
	SELECT @StateId=StateId FROM WRBHBPropertyOwners P   WHERE p.IsDeleted=0 AND p.Id=@SelectId and PropertyId=@Pram1;
 
	SELECT @CityId=CityId FROM WRBHBPropertyOwners P  WHERE IsDeleted=0 AND  P.Id =@SelectId and PropertyId=@Pram1;
 
	SELECT PropertyId,Title,FirstName,Lastname,LedgerName,EmailID,
	Phone,Alternatephone,TDSPer,Address,C.CityName City, L.Locality LocalityArea,S.StateName State,
	Postal,PaymentMode,PayeeName,AccountNumber,AccountType,Bank,
	BranchAddress,IFSC,SWIFTCode,PANNO,TIN,ST,VAT,p.StateId,p.CityId,LocalityId,P.Id 
	FROM WRBHBPropertyOwners p 
	LEFT OUTER JOIN WRBHBState S ON P.StateId=S.Id  
	LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
	LEFT OUTER JOIN WRBHBLocality L ON P.LocalityId=L.Id   
	WHERE p.IsDeleted=0 AND p.Id=@SelectId ; 

	
	
	IF @Pram2='Internal Property'
	BEGIN
	SELECT ApartmentId,ApartmentName,Id 
	FROM WRBHBPropertyOwnerApartment Ap 
	WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
	
	SELECT B.BlockName+' - '+ApartmentNo ApartmentName ,0 Id,A.Id ApartmentId,0 AS Tick FROM dbo.WRBHBPropertyApartment A
	LEFT OUTER JOIN dbo.WRBHBPropertyBlocks B ON A.BlockId=B.Id and b.IsDeleted=0
	WHERE A.PropertyId=@Pram1 AND A.IsDeleted=0;
	--SELECT ApartmentNo ApartmentName ,0 Id,Id ApartmentId 
	--FROM dbo.WRBHBPropertyApartment
 --   WHERE PropertyId=@Pram1 AND IsDeleted=0;
    END
    ELSE
    BEGIN
    SELECT PropertyId ApartmentId,PropertyName ApartmentName,Id 
	FROM WRBHBPropertyOwnerProperty Ap 
	WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
	
    SELECT PropertyName AS ApartmentName,0 Id,Id ApartmentId FROM WRBHBProperty 
	WHERE IsDeleted=0 AND Category in ('External Property');
	END
	SELECT CityName label,Id data FROM WRBHBCity C WHERE StateId=@StateId
	SELECT Locality label,Id LocalityId FROM WRBHBLocality C WHERE CityId=@CityId
	
	SELECT Name,EmailId,ContactType,PhoneNumber,designation,Id
	FROM WRBHBPropertyOwnerOtherContacts
	WHERE OwnerId=@SelectId
	
END   
   
IF @SelectId=0  
BEGIN  
 SELECT @Pram2=Category  FROM WRBHBProperty 
	WHERE IsDeleted=0 AND Id=@Pram1;
IF @Pram2='Internal Property' or @Pram2='Managed G H'
	BEGIN	
	 SELECT FirstName,Phone,C.CityName City,p.Id,ISNULL(ApartmentName,'') ApartmentName
	 FROM dbo.WRBHBPropertyOwners p
	 LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
	 LEFT OUTER JOIN WRBHBPropertyOwnerApartment A ON A.OwnerId=P.Id
	 WHERE  p.IsDeleted=0 AND P.IsActive=1  AND p.PropertyId=@Pram1 order by Id desc
 END
 ELSE
 BEGIN 
	 SELECT FirstName,Phone,C.CityName City,p.Id,ISNULL(PropertyName,'') PropertyName
	 FROM dbo.WRBHBPropertyOwners p
	 LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  
	 LEFT OUTER JOIN WRBHBPropertyOwnerProperty A ON A.OwnerId=P.Id
	 WHERE  p.IsDeleted=0 AND P.IsActive=1  AND A.PropertyId=@Pram1 order by Id desc
 END
 
 
END   
 END  