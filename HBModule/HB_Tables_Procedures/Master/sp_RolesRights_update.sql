SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_RolesRights_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_RolesRights_Update]

Go
CREATE PROCEDURE [dbo].[sp_RolesRights_Update]
(
@RolesId Int,
@ScreenName  nvarchar(100),
@scrId nvarchar(100),
@ModuleName nvarchar(100),
@ModuleId nvarchar(50),
@Selected bit,
@Id     int,
@Createdby int)

AS
BEGIN


UPDATE WRBHBRolesRights SET 
ScreenName=@ScreenName,
scrId=@scrId,ModuleId=@ModuleId,Selected=@Selected,
modifiedby=@createdby,modifieddate=GETDATE() where RolesId=@RolesId and Id=@Id;

select Id,RowId From WRBHBRolesRights where Id=@Id;
End

