SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Registration_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Registration_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: REGISTRATION INSERT
Purpose  	: REGISTRATION INSERT
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE Sp_Registration_Insert
(
@Title		NVARCHAR(100),
@FirstName	NVARCHAR(100),
@LastName	NVARCHAR(100),
@Mobile		NVARCHAR(100),
@Email		NVARCHAR(100),
--@Password	VARBINARY(300),
@Agreed		BIT,
@CreatedBy	BIGINT,
@ClientId	BIGINT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
IF EXISTS (SELECT NULL FROM WRBHBExternal_Users WITH (NOLOCK) 
WHERE UPPER(Email) = UPPER(@Email)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
               
  SET @ErrMsg = 'Email Already Exists';
    SELECT @ErrMsg;
    
END 
IF EXISTS (SELECT NULL FROM WRBHBExternal_Users WITH (NOLOCK) 
WHERE UPPER(Mobile) = UPPER(@Mobile)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
               
  SET @ErrMsg = 'Mobile Already Exists';
    SELECT @ErrMsg;
    
END 
ELSE
BEGIN
DECLARE @UserPassword VARCHAR(100)

--PASSWORD GENERATION  (all values between ASCII code 48 - 122 excluding defaults)
EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out
--select @UserPassword
SET @UserPassword=@UserPassword;
open symmetric key sk_key decryption by password = 'WARBHB@Pass';

	INSERT INTO WRBHBExternal_Users (Password,Title,FirstName,LastName,Mobile,Email,IsActive,IsDeleted,
				CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,ClientId)
	VALUES (encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'),@Title,@FirstName,@LastName,@Mobile,@Email,
	@Agreed,0,@CreatedBy,GETDATE(),@CreatedBy,
				GETDATE(),NEWID(),@ClientId)		
				
				
SET  @Identity=@@IDENTITY

SELECT Id,RowId,@UserPassword FROM WRBHBExternal_Users WHERE Id=@Identity;				
END
END


