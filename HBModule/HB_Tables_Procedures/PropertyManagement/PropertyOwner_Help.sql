SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwner_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwner_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY OWNER Help
		Purpose  	: PROPERTYOWNER Help
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
CREATE PROCEDURE [dbo].[sp_PropertyOwner_Help](
@PAction		 NVARCHAR(100)=NULL,
@PropertyId      BIGINT,
@Pram1           BIGINT=NULL, 
@Pram2			 NVARCHAR(100)=NULL, 
@UserId          BIGINT
)
AS
BEGIN  
DECLARE @SelectId BIGINT;
DECLARE @StateId BIGINT,@CityId BIGINT;	  
 IF @PAction ='PROPERTYOWNER'
 BEGIN
	
	SELECT TOP 1 @SelectId=Id FROM WRBHBPropertyOwners WHERE UPPER(PANNO)=UPPER(@Pram2) AND IsDeleted=0 AND IsActive=1;
	
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
		
		SELECT B.BlockName+' - '+ApartmentNo ApartmentName ,0 Id,A.Id ApartmentId,0 AS Tick FROM dbo.WRBHBPropertyApartment A
		LEFT OUTER JOIN dbo.WRBHBPropertyBlocks B ON A.BlockId=B.Id and b.IsDeleted=0
		WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0;
		
		--SELECT ApartmentNo ApartmentName ,0 Id,Id ApartmentId,0 AS Tick  
		--FROM dbo.WRBHBPropertyApartment
		--WHERE PropertyId=@PropertyId AND IsDeleted=0;
    END
    ELSE
    BEGIN
		SELECT PropertyId ApartmentId,PropertyName ApartmentName,Id,0 AS Tick 
		FROM WRBHBPropertyOwnerProperty Ap 
		WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
		
		SELECT PropertyName AS ApartmentName,0 Id,Id ApartmentId,0 AS Tick  FROM WRBHBProperty 
		WHERE IsDeleted=0 AND Category in ('External Property');
	END
	SELECT CityName label,Id data FROM WRBHBCity C WHERE StateId=@StateId
	SELECT Locality label,Id LocalityId FROM WRBHBLocality C WHERE CityId=@CityId
	
	SELECT Name,EmailId,ContactType,PhoneNumber,designation,Id
	FROM WRBHBPropertyOwnerOtherContacts
	WHERE OwnerId=@SelectId
 END
IF @PAction ='PROPERTYOWNEREmailId'
 BEGIN
	
	SELECT TOP 1 @SelectId=Id FROM WRBHBPropertyOwners WHERE UPPER(EmailID)=UPPER(@Pram2) AND IsDeleted=0 AND IsActive=1;
	
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
		SELECT ApartmentId,ApartmentName,Id 
		FROM WRBHBPropertyOwnerApartment Ap 
		WHERE Ap.OwnerId=@SelectId  AND IsDeleted=0 
		
		SELECT ApartmentNo ApartmentName ,0 Id,Id ApartmentId 
		FROM dbo.WRBHBPropertyApartment
		WHERE PropertyId=@PropertyId AND IsDeleted=0;
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
END

