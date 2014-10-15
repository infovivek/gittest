SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_RolesRights_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_RolesRights_Select]

Go

CREATE PROCEDURE sp_RolesRights_Select(@id int,
@UserId int)

AS 
BEGIN
if @id<>0
Begin
Select ScreenName AS ScreenName,scrId AS scrId,ModuleName AS ModuleName,ScreenName AS ScreenName,
ModuleId AS ModuleId,Selected AS Selected,RolesId
from WRBHBRolesRights
where IsActive=1 and IsDelete=0 and RolesId=@Id;

End

Else

BEGIN
Select ScreenName,ModuleName,Selected,RolesId from WRBHBRolesRights
where IsActive=1 and IsDelete=0
order by Id desc;
End
End