SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_RolesRights_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_RolesRights_Delete]

Go

CREATE PROCEDURE [dbo].[sp_RolesRights_Delete]
(@Id int)
AS
BEGIN
update WRBHBRolesRights set IsActive=0,IsDelete=1,ModifiedBy=@Id
Where RolesId=@Id
End
GO