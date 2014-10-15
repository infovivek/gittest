SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Roles_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_Roles_Help]
GO 

CREATE PROCEDURE [dbo].[sp_Roles_Help](
@Action NVARCHAR(100)=NULL,
@Param1 NVARCHAR(100)=NULL,
@UserId int
)
AS 
BEGIN
IF @Action ='PageLoad'
SELECT RoleName,Statuss,Id AS Id  FROM WRBHBRoles 
WHERE IsActive=1 and IsDeleted=0
END
IF @Action = 'Dataload'  
		BEGIN 
		SELECT ScreenName ModuleName ,Id AS scrId,ModuleId AS ModuleId,0 AS Id,'true' as Rights
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0 AND ModuleId=0
		order by OrderNumber;
		
		SELECT ScreenName AS ScreenName,Id AS scrId,
		ModuleName AS ModuleName,ModuleId AS ModuleId,0 AS Id,0 as Rights
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0 AND ModuleId !=0
		order by OrderNumber;
END;
IF @Action = 'Selectall'  
		BEGIN 
		SELECT ScreenName ModuleName ,Id AS scrId,ModuleId AS ModuleId,0 AS Id,'true' as Rights
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0 AND ModuleId=0
		order by OrderNumber;
		
		SELECT ScreenName AS ScreenName,Id AS scrId,
		ModuleName AS ModuleName,ModuleId AS ModuleId,0 AS Id,1 as Rights
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0  
		order by OrderNumber;
END
--IF @Action = 'Usr'  
--		BEGIN 
--		SELECT Id AS RoleGroupId,RoleName AS RoleName FROM dbo.WRBHBRoles WHERE IsDeleted=0;
--		END
--		ELSE
--		BEGIN
--		SELECT Id AS RoleGroupId,RoleGroup  AS RoleGroup FROM dbo.WRBHBRolesGroup WHERE IsDeleted=0; 
--		END ;
