SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_UserRoles_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_UserRoles_Update]
GO 
CREATE PROCEDURE sp_UserRoles_Update
(
@Id		   bigint,
@UserId    int,
@RolesId   nvarchar(100),
@Roles     nvarchar(100)
)

AS
BEGIN
DECLARE @Identity int;
Update WRBHBUserRoles SET RolesId=@RolesId,Roles=@Roles ,Modifiedby=@UserId,
						  Modifieddate=GETDATE(),IsActive=1,IsDeleted=0 where UserId=@UserId and Id=@Id
					
select RolesId,Roles from WRBHBUserRoles where  Id=@Id;							  
END						  