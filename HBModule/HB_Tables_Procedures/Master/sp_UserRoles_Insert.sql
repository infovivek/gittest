SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_UserRoles_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_UserRoles_Insert]
GO 
CREATE PROCEDURE sp_UserRoles_Insert
(
@UserId			int, 
@RolesId		int,
@Roles		nvarchar(100)
)

AS
BEGIN
--DECLARE @Identity int,@RolesId int;
--IF(@UserId!=0)
--BEGIN
--IF(@RolesId!=0)
--BEGIN
--UPDATE WRBHBUserRoles SET UserId=@UserId,Roles=@Roles,CreatedBy=@UserId,CreatedDate=GETDATE(),ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsActive=0,
--IsDeleted=0,RowId=NEWID() WHERE UserId=@UserId AND RolesId=@RolesId
--END
--END
--ELSE
select @Roles=RoleName from WRBHBRoles where id=@RolesId
INSERT INTO WRBHBUserRoles (UserId,RolesId,Roles,CreatedBy,CreatedDate,ModifiedBy,Modifieddate,IsActive,IsDeleted,RowId)
						 values( @UserId,@RolesId,@Roles,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID())
--SELECT @RolesId=Id from WRBHBRolesGroup where IsDeleted=0 AND IsActive=0


SELECT Id,RowId FROM WRBHBUserRoles WHERE Id=@@IDENTITY;
End
