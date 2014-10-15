SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Registration_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Registration_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: REGISTRATION UPDATE
Purpose  	: REGISTRATION UPDATE
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
CREATE PROCEDURE Sp_Registration_Update
(
@Title		NVARCHAR(100),
@FirstName	NVARCHAR(100),
@LastName	NVARCHAR(100),
@Mobile		NVARCHAR(100),
@Email		NVARCHAR(100),
--@Password	VARBINARY(300),
@Agreed		BIT,
@CreatedBy	BIGINT,
@Id			BIGINT, 
@ClientId	BIGINT
)
AS
BEGIN
--DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
--IF EXISTS (SELECT NULL FROM WRBHBExternal_Users WITH (NOLOCK) 
--WHERE UPPER(Email) = UPPER(@Email)  AND IsDeleted = 0 AND IsActive = 1 AND Id=@Id)
--BEGIN
               
--  SET @ErrMsg = 'Email Already Exists';
--    SELECT @ErrMsg;
    
--END
--IF EXISTS (SELECT NULL FROM WRBHBExternal_Users WITH (NOLOCK) 
--WHERE UPPER(Mobile) = UPPER(@Mobile)  AND IsDeleted = 0 AND IsActive = 1 AND Id=@Id)
--BEGIN
               
--  SET @ErrMsg = 'Mobile Already Exists';
--    SELECT @ErrMsg;
    
--END  
--ELSE
DECLARE @UserPassword VARCHAR(100)

--PASSWORD GENERATION  (all values between ASCII code 48 - 122 excluding defaults)
EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out
--select @UserPassword
SET @UserPassword=@UserPassword;
open symmetric key sk_key decryption by password = 'WARBHB@Pass';

	UPDATE WRBHBExternal_Users SET Title=@Title,FirstName=@FirstName,LastName=@LastName,Mobile=@Mobile,
			Email=@Email,Password=encryptbykey(key_guid('sk_key'), @UserPassword, 1,'HB@1wr'),IsActive=@Agreed,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),ClientId=@ClientId
	WHERE Id=@Id
	
	SELECT Id,Rowid,@UserPassword FROM WRBHBExternal_Users WHERE Id=@Id		
END