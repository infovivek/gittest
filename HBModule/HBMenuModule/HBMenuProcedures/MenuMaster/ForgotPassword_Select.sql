SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[HBMenu_ForgotPassword_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[HBMenu_ForgotPassword_Select]
GO   
/* 
Author Name : Anbu
Created On 	: <Created Date (22/04/2014)  >
Section  	: Forgot Select
Purpose  	: Forgot Select
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
CREATE PROCEDURE HBMenu_ForgotPassword_Select
(
 @Email          NVARCHAR(100),
 @UserId			BIGINT
)
AS
	BEGIN
		DECLARE @ErrMsg NVARCHAR(MAX),@Testvalu nvarchar(100);
		Set @Testvalu = (SELECT Id FROM WrbhbTravelDesk WITH (NOLOCK) 
		WHERE UPPER(Email) = UPPER(@Email)  AND IsDeleted = 0 AND IsActive = 1)
		 
 If isnull(@Testvalu,'') !=''
	BEGIN
	  OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
		  SELECT  CONVERT(VARCHAR(100),decryptbykey(Password,1,convert(VARCHAR(300),'HB@1wr')))
		  AS UserPassword,Email,RowId FROM WrbhbTravelDesk WHERE Email=@Email and IsActive=1; 
    END
ELSE
   BEGIN
		  
	    SET @ErrMsg = 'EmailId Is Incorrect';
		SELECT @ErrMsg As EmailId;
	END  
	
END	