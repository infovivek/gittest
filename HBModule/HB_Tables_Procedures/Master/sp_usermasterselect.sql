SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_usermasterselect]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_usermasterselect]
GO 

create procedure sp_usermasterselect
(
@Id bigint
)
as
begin
if @Id!=0
begin

select Title,UserName,UserPassword,UserGroup,Email,FirstName,LastName,
Address,State,City,Zip,PhoneNumber,MobileNumber,Id
from WRBHBUser where IsActive=1 and IsDeleted=0 and Id=@Id

--SELECT  Roles label,Id UserId,0 as Id --RoleGroup as  UserType
--			 FROM dbo.WRBHBUserRoles 
--			WHERE  IsActive=0  AND IsDeleted=0 AND UserId=@Id

select Roles label,Id,RolesId RolesId,RolesId UserId 
from WRBHBUserRoles where IsActive=1 and IsDeleted=0 and  UserId=@Id
end

else
begin
OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
select FirstName,MobileNumber,Email,
CONVERT(VARCHAR(100),decryptbykey(UserPassword, 1, convert(VARCHAR(300), 'HB@1wr')))
     AS UserPassword,
Id from WRBHBUser where IsActive=1 and IsDeleted=0;
end
end