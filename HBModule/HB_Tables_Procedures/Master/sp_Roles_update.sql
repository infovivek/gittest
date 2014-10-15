SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Roles_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_Roles_Update]

Go
CREATE PROCEDURE [dbo].[sp_Roles_Update]
(
@RoleName nvarchar(100),
@Statuss  nvarchar(100),
@Id        int,
@Createdby int)

AS
BEGIN
UPDATE WRBHBRoles SET RoleName=@RoleName,
Statuss=@Statuss,
modifiedby=@createdby,modifieddate=GETDATE()

where Id=@Id and IsActive=1 and IsDeleted=0 



select Id,RowId From WRBHBRoles 
where Id=@Id;
End
GO


