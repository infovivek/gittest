SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientGradeValue_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ClientGradeValue_Select]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (11/03/2014)  >
		Section  	: Client Grade Value
		Purpose  	: ClientGradeValue SEARCH
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
CREATE PROCEDURE [dbo].[sp_ClientGradeValue_Select](  
@SelectId   BigInt,  
@Pram1           BigInt=NULL,   
@Pram2    NVARCHAR(100)=NULL,  
@UserId          BigInt  
)  
AS  
BEGIN  
IF @SelectId <> 0    
BEGIN   
DECLARE @ClientId BIGINT;   
	SELECT ClientName,GM.Grade,G.Id,G.ClientId,
	GradeId,MinValue,MaxValue,NeedGH,StarRatingId,P.PropertyType,ValueStarRatingFlag 
	FROM dbo.WRBHBClientGradeValue G
	LEFT OUTER JOIN dbo.WRBHBGradeMaster GM ON GM.Id=G.GradeId
	LEFT OUTER JOIN WRBHBClientManagement C ON C.Id=G.ClientId	
	LEFT OUTER JOIN WRBHBPropertyTYPE P ON P.Id=G.StarRatingId
	WHERE  G.Id=@SelectId
	
	SELECT CityId,CityName label ,Id
	FROM WRBHBClientGradeValueDetails
	WHERE ClientGradeValueId=@SelectId AND IsDeleted=0
	
	SELECT @ClientId=ClientId FROM dbo.WRBHBClientGradeValue G WHERE  G.Id=@SelectId
	
	
	SELECT  Id,Grade label FROM dbo.WRBHBClientManagementAddClientGuest 
	WHERE  IsActive=1  AND IsDeleted=0 and CltmgntId=@ClientId  
			
	--SELECT CityName City,Id FROM WRBHBCity WHERE IsActive=1 AND IsDeleted=0	
   
END   
   
IF @SelectId=0  
BEGIN  
	SELECT ClientName,GM.Grade,G.Id,MinValue,MaxValue 
	FROM dbo.WRBHBClientGradeValue G
	LEFT OUTER JOIN dbo.WRBHBGradeMaster GM ON GM.Id=G.GradeId
	LEFT OUTER JOIN WRBHBClientManagement C ON C.Id=G.ClientId
	LEFT OUTER JOIN WRBHBClientManagementAddClientGuest A ON A.Id=G.GradeId
	WHERE  G.IsDeleted=0 ORDER BY Id DESC   
END   
END  