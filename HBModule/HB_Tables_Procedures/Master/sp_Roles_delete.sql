SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Roles_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_Roles_Delete]

Go

CREATE PROCEDURE [dbo].[sp_Roles_Delete]
(
@Id int,
@UserId int
)
AS
BEGIN
update WRBHBRoles set IsActive=0,IsDeleted=1,ModifiedBy=@UserId
Where Id=@Id

--Update WRBHBRolesGroup Set IsActive=1,IsDeleted=1,ModifiedBy=@Id
--Where Id=@Id

End
GO