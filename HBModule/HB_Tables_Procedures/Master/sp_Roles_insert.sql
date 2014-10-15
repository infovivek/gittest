SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_Roles_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[sp_Roles_Insert]

Go

CREATE PROCEDURE [dbo].[sp_Roles_Insert](
@RoleName nvarchar(100),
@Statuss nvarchar(50),
@Createdby int)

AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
IF EXISTS (SELECT NULL FROM WRBHBRoles WITH (NOLOCK) 
WHERE UPPER(RoleName) = UPPER(@RoleName)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
               
  SET @ErrMsg = 'Role Name Already Exists';
        
  SELECT @ErrMsg;
             
 END
 ELSE
 BEGIN
                 
   
INSERT INTO WRBHBRoles(RoleName,Statuss,Createdby,Createddate,Modifiedby,
Modifieddate,IsActive,IsDeleted,Rowid)
VALUES (@Rolename,@Statuss, @Createdby,GETDATE(),@Createdby,GETDATE(),1,0,NEWID())


SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBRoles WHERE Id=@Identity;
END
END
