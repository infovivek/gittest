
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_ReassignClient_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_ReassignClient_Help]
GO
/*=============================================
Author Name  : Anbu
Created Date : 03/04/2014 
Section  	 : Master
Purpose  	 : Tax
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_ReassignClient_Help]
(
@Action             NVARCHAR(100)=NULL,
@SelectId           INT=NULL
)
AS
BEGIN
IF @Action ='CLIENTLOAD1'
   BEGIN
	   SELECT RoleName AS label,Id As Data From WRBHBRoles
	   WHERE  IsActive=1 AND IsDeleted=0 AND RoleName IN('Sales Executive','CRM','Key Account Person');
   END
 IF @Action ='PROPERTYLOAD1'
   BEGIN
	   SELECT RoleName AS label,Id As Data From WRBHBRoles
	   WHERE  IsActive=1 AND IsDeleted=0 AND RoleName IN('Operations Managers','Resident Managers','Assistant Resident Managers','Project Managers','Other Roles','Sales');
   END
IF @Action ='CLIENTSALELOAD'
	BEGIN
		SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
	END
IF @Action ='CLIENTCRMLOAD'
	BEGIN
		SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
	END  
IF @Action ='CLIENTKEYLOAD'
	BEGIN
		SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
	END
IF @Action='PROPERTYOMLOAD'
   BEGIN
		SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
   IF @Action ='PROPERTYRMLOAD'
   BEGIN
	  SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
IF @Action ='PROPERTYARMLOAD'
   BEGIN
	  SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
IF @Action ='PROPERTYPMLOAD'
   BEGIN
	   SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
IF @Action='PROPERTYORLOAD'
   BEGIN
		SELECT U.FirstName AS label,U.Id AS Data,RolesId AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
IF @Action='PROPERTYSLOAD'
   BEGIN
		SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE RolesId=@SelectId AND UR.IsActive=1 AND UR.IsDeleted=0;
   END
IF @Action='SALESLOAD'
	BEGIN     
		SELECT DISTINCT CM.SalesExecutiveId AS SelectId,CM.Id,CM.ClientName,R.RoleName,
		CM.CCity,Convert(NVARCHAR,CM.CreatedDate,103) AS CreatedDate,0 AS checks
		FROM WRBHBRoles R
		JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
	    JOIN WRBHBClientManagement CM ON U.Id=CM.SalesExecutiveId  AND CM.IsActive=1 AND CM.IsDeleted=0 
	    WHERE U.Id=@SelectId AND R.IsActive=1 AND R.IsDeleted=0  AND RoleName IN('Sales Executive'); 
	      
	    SELECT DISTINCT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and  UR.Roles ='Sales Executive' and 
		U.Id NOT IN (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='CRMLOAD'
	BEGIN
	    SELECT DISTINCT CM.CRMId AS SelectId,CM.Id,CM.ClientName,CM.CCity,R.RoleName,
	    Convert(NVARCHAR,CM.CreatedDate,103) AS CreatedDate,0 AS checks
	    FROM WRBHBRoles R
		JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
	    JOIN WRBHBClientManagement CM ON U.Id=CM.CRMId  AND CM.IsActive=1 AND CM.IsDeleted=0 
	    WHERE U.Id=@SelectId AND R.IsActive=1 AND R.IsDeleted=0  AND RoleName IN('CRM');
	    
	    SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 AND UR.Roles ='CRM' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='KEYACCOUNTPERSON'
	BEGIN
		SELECT DISTINCT CM.KeyAccountPersonId,CM.Id,CM.ClientName,R.RoleName,
		CM.CCity,Convert(NVARCHAR,CM.CreatedDate,103) AS CreatedDate,0 AS checks
		FROM WRBHBRoles R
		JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
	    JOIN WRBHBClientManagement CM ON U.Id=CM.CRMId  AND CM.IsActive=1 AND CM.IsDeleted=0 
	    WHERE U.Id=@SelectId AND R.IsActive=1 AND R.IsDeleted=0  AND RoleName IN('Key Account Person');
	    
	    SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Key Account Person' AND
		U.Id NOT IN (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='OPERATIONMANAGER'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Operations Managers'
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Operations Managers');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Operations Managers' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='RESIDENTMANAGER'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Resident Managers' 
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Resident Managers');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Resident Managers' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='PROJECTMANAGER'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Project Managers'
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Project Managers');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Project Managers' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='ASSISTANTRESIDENTMANAGER'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Assistant Resident Managers'
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Assistant Resident Managers');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Assistant Resident Managers' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='OTHERROLE'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Other Roles'
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0  
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Other Roles');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 and UR.Roles ='Other Roles' AND
		U.Id NOT IN  (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
IF @Action='SALE'
	BEGIN
		SELECT DISTINCT PU.Id,UR.UserId,PU.PropertyId,P.PropertyName AS ClientName,C.CityName AS CCity,R.RoleName,
		Convert(NVARCHAR,P.CreatedDate,103) AS CreatedDate,0 AS checks FROM WRBHBRoles R 
		LEFT OUTER JOIN WRBHBUserRoles UR ON R.Id=UR.RolesId AND UR.IsActive=1 AND UR.IsDeleted=0
	    LEFT OUTER JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		LEFT OUTER JOIN WRBHBPropertyUsers PU ON U.Id=PU.UserId AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType='Sales' 
		LEFT OUTER JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
        LEFT OUTER JOIN WRBHBCity C ON P.CityId=C.Id  	
        WHERE  U.Id=@SelectId AND P.IsActive=1 AND P.IsDeleted=0 AND RoleName IN('Sales');
        
        SELECT U.FirstName AS label,U.Id AS Data FROM WRBHBUserRoles UR
		JOIN WRBHBUser U ON UR.UserId=U.Id AND U.IsActive=1 AND U.IsDeleted=0
		WHERE  UR.IsActive=1 AND UR.IsDeleted=0 AND UR.Roles ='Sales' AND
		U.Id NOT IN (Select Id from WRBHBUser where Id=@SelectId and IsActive=1 and IsDeleted=0)
	END
END


 