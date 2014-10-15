SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_usermasterinsert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_usermasterinsert]
GO 

CREATE PROCEDURE [dbo].[sp_usermasterinsert]  
(  
--@Title                nvarchar(100),  
@UserName             nvarchar(100),  
--@UserPassword    nvarchar(100),  
--@UserGroup     nvarchar(100),  
--@UserGroupId    nvarchar(100),  
--@UserRoles     nvarchar(100),  
@Email      nvarchar(100),  
@FirstName     nvarchar(100),  
@LastName     nvarchar(100),  
@Address     nvarchar(100),  
@State      nvarchar(100),  
@City      nvarchar(100),  
@Zip      nvarchar(100),  
--@PhoneNumber    nvarchar(100),  
@MobileNumber    nvarchar(100),  
@CreatedBy     bigint,  
@EmployeeID     nvarchar(100),                          
@CountId     bigint  
)  
AS  
BEGIN   
DECLARE @Identity INT,@Identity1 NVARCHAR(100),@Id int 
DECLARE @InsId INT,@ErrMsg NVARCHAR(MAX)  
  
IF EXISTS(SELECT NULL FROM WRBHBUser WITH (NOLOCK) WHERE Email=@Email AND IsDeleted=0 AND IsActive=1)   
BEGIN  
SET @ErrMsg = 'EmailId Already Exist';
SELECT @ErrMsg;
  
--IF EXISTS(SELECT NULL FROM WRBHBUser WITH (NOLOCK)WHERE Email=@Email AND IsDeleted=0 AND IsActive=1)  
--BEGIN  
--SET @ErrMsg = 'Email Already Exist';  
END  
--END  
  
ELSE  
BEGIN  
DECLARE @UserPassword VARCHAR(100)  
  
--PASSWORD GENERATION  (all values between ASCII code 48 - 122 excluding defaults)  
EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out  
--select @UserPassword  
SET @UserPassword=@UserPassword;  
open symmetric key sk_key decryption by password = 'WARBHB@Pass';  
INSERT INTO WRBHBUser(UserPassword,UserName,Email,FirstName,LastName,  
       Address,State,City,Zip,MobileNumber,CreatedBy,CreatedDate,ModifiedBy,  
       ModifiedDate,IsActive,IsDeleted,RowId,EmployeeID,CountId)  
            VALUES  
     (encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'),@FirstName,@Email,  
     @FirstName,@LastName,  
     @Address,@State,@City,@Zip,@MobileNumber,@CreatedBy,  
     GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@EmployeeID,@CountId)  
   
 SELECT @Identity=@@IDENTITY  
 --SELECT @Identity1=@Identity  
   
 --UPDATE WRBHBUser SET UserPassword=encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr')  
 --WHERE Id=@Identity  
                     
 SELECT Id,RowId,@UserPassword FROM WRBHBUser WHERE Id=@Identity;  
  
END  
END  