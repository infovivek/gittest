SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_RolesRights_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_RolesRights_Insert]

Go

CREATE PROCEDURE [dbo].[sp_RolesRights_Insert](
@ScreenName  nvarchar(100),
@scrId nvarchar(100),
@ModuleName nvarchar(100),
@ModuleId nvarchar(50),
@Selected int,
@RolesId int,
@Createdby int)

AS
BEGIN
DECLARE @Identity int,@IsActive int=1;


INSERT INTO WRBHBRolesRights(ScreenName,scrId,ModuleName,ModuleId,Selected,
RolesId,Createdby,Createddate,Modifiedby,Modifieddate,IsActive,IsDelete,Rowid)
VALUES (@ScreenName,@scrId,@ModuleName,@ModuleId,@Selected,
@RolesId,@Createdby,GETDATE(),@Createdby,GETDATE(),@IsActive,0,NEWID())


SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBRolesRights WHERE Id=@Identity;


End