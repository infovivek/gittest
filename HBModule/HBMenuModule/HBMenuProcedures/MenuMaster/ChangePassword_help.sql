---=====
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[HBMenu_ChangePassword_help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[HBMenu_ChangePassword_help]
GO 
create procedure HBMenu_ChangePassword_help
(
@PAction   nvarchar(100),
@Param1    nvarchar(100),
@Param2    nvarchar(100),
@Id        bigint
)
as 
begin
--declare @Action varchar(100)
DECLARE @UserPassword VARCHAR(100)


--IF @PAction ='User'
--BEGIN	
--			SELECT  RoleName label,Id UserId,0 as Id,isnull(RoleGroup,'') as  UserType
--			 FROM dbo.WRBHBRoles 
--			WHERE  IsActive=1  AND IsDeleted=0-- AND UserGroup='Other Roles';
--END
--IF @PAction ='UserDelete'
--BEGIN	
--			update WRBHBUserRoles set IsActive=0,IsDeleted=1,ModifiedBy=1,ModifiedDate=GETDATE() where Id=@Id

--END
IF @PAction ='Password'
BEGIN
     OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
     SELECT  CONVERT(VARCHAR(100),decryptbykey(Password, 1, convert(VARCHAR(300), 'HB@1wr')))
     AS UserPassword,Id FROM WrbhbTravelDesk WHERE Id=@Id
END
IF @PAction ='Password_update'
BEGIN
	 select @UserPassword=@Param2
	 OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
     UPDATE WrbhbTravelDesk SET Password= encryptbykey(key_guid('sk_key'),@UserPassword,1,'HB@1wr')
     WHERE Id=@Id
END
END 