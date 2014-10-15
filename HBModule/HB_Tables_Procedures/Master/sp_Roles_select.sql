SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Roles_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_Roles_Select]

Go

CREATE PROCEDURE sp_Roles_Select(@Id int,
@UserId int)

AS 
BEGIN
if @id<>0
Begin
Select RoleName AS RoleName,Statuss AS Statuss,Id
from WRBHBRoles
where IsActive=1 and IsDeleted=0 and Id=@Id;

CREATE TABLE #ScreenRoles( ScreenName NVARCHAR(100),scrId BIGINT,ModuleName NVARCHAR(100),
ModuleId BIGINT,Id BIGINT,Rights NVARCHAR(100))

		
INSERT INTO #ScreenRoles(ScreenName ,scrId ,ModuleName ,ModuleId ,Id, Rights)
SELECT ScreenName AS ScreenName,Id AS scrId,
		ModuleName AS ModuleName,ModuleId AS ModuleId,0,0
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0 
		and Id NOT IN (SELECT scrId FROM WRBHBRolesRights s WHERE IsActive=1 AND IsDelete=0 AND RolesId=@Id);
		
INSERT INTO #ScreenRoles(ScreenName ,scrId ,ModuleName ,ModuleId ,Id ,Rights)		
SELECT ScreenName AS ScreenName,scrId AS scrId,
	   ModuleName AS ModuleName,ModuleId AS ModuleId,Id,Selected
	   FROM WRBHBRolesRights WHERE IsActive=1 AND IsDelete=0 AND RolesId=@Id;
	   
	   SELECT ScreenName ModuleName ,Id AS scrId,ModuleId AS ModuleId,0 AS Id,'true' as Rights
		FROM WRBHBScreenMaster WHERE IsActive=0 AND IsDeleted=0 AND ModuleId=0
		order by OrderNumber
	   
SELECT ScreenName ,scrId ,ModuleName ,ModuleId ,Id ,Rights FROM #ScreenRoles

End

Else

BEGIN
Select RoleName,Statuss,Id from WRBHBRoles
where IsActive=1 and IsDeleted=0
order by Id desc;
End
End