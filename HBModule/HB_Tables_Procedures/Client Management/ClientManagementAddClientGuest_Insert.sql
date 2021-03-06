SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientManagementAddClientGuest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_ClientManagementAddClientGuest_Insert]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (19/02/2014)  >
Section  	: CLIENT MANAGEMENT ADD CLIENT GUEST
Purpose  	: CLIENT GUEST INSERT
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi         21 Feb 2014                          Datatype Alterations
Sakthi         01 April 2014                        Nationality Field Added
Sakthi         28 Jun 2014      Password Generated & Inserted in Front End Guest Insert (Vinoth)
*******************************************************************************************************
*/
CREATE PROCEDURE sp_ClientManagementAddClientGuest_Insert(    
@CltmgntId BIGINT,@CompanyName NVARCHAR(100),@EmpCode NVARCHAR(100),    
@FirstName NVARCHAR(100),@LastName NVARCHAR(100),@Grade NVARCHAR(100),    
@GMobileNo NVARCHAR(100),@EmailId NVARCHAR(100),@RangeMin DECIMAL(27,2),    
@RangeMax DECIMAL(27,2),@CreatedBy BIGINT,@CltmgntRowId NVARCHAR(100),    
@Designation NVARCHAR(100))    
AS     
BEGIN    
 DECLARE @GradeId BIGINT;    
 SET @CltmgntRowId=NEWID();    
 IF NOT EXISTS (SELECT NULL FROM WRBHBGradeMaster WITH (NOLOCK)    
 WHERE UPPER(Grade) = UPPER(@Grade)  AND IsDeleted = 0 AND     
 IsActive = 1 AND ClientId=@CltmgntId)    
  BEGIN    
   INSERT INTO WRBHBGradeMaster(Grade,CreatedBy,CreatedDate,ModifiedBy,    
   ModifiedDate,IsActive,IsDeleted,RowId,ClientId)    
   VALUES(@Grade,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),    
   @CltmgntId);    
   SELECT @GradeId =@@IDENTITY;    
  END    
 ELSE    
  BEGIN    
   SELECT @GradeId=Id FROM WRBHBGradeMaster WITH (NOLOCK)    
   WHERE UPPER(Grade) = UPPER(@Grade)  AND IsDeleted = 0 AND     
   IsActive = 1 AND ClientId=@CltmgntId;    
  END    
 --    
 DECLARE @Pwd NVARCHAR(100)='',@PwdBinary VARBINARY(300);    
 IF @RangeMax = 01010    
  BEGIN    
   DECLARE @UserPassword VARCHAR(100)   
   --PASSWORD GENERATION  (all values between ASCII code 48 - 122 excluding defaults)    
   EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out    
   --select @UserPassword    
   SET @UserPassword=@UserPassword;    
   open symmetric key sk_key decryption by password = 'WARBHB@Pass';   
   INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,    
   EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,    
   CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,    
   Designation,GradeId,Nationality,Title,Password)    
   VALUES(@CltmgntId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,    
   @GMobileNo,@EmailId,@RangeMin,@RangeMax,@CreatedBy,GETDATE(),@CreatedBy,    
   GETDATE(),1,0,@CltmgntRowId,@Designation,@GradeId,'','',
   encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'));         
  END   
 ELSE  
  BEGIN  
   INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,    
   EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,    
   CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,    
   Designation,GradeId,Nationality,Title,Password)    
   VALUES(@CltmgntId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,    
   @GMobileNo,@EmailId,@RangeMin,@RangeMax,@CreatedBy,GETDATE(),@CreatedBy,    
   GETDATE(),1,0,@CltmgntRowId,@Designation,@GradeId,'','',
   encryptbykey(key_guid('sk_key'), '', 1, 'HB@1wr'))    
  END   
 --
 DECLARE @InsId BIGINT;
 SET @InsId=@@IDENTITY;
 SELECT Id,RowId,Password,@Pwd AS PwdVarchar 
 FROM WRBHBClientManagementAddClientGuest WHERE Id=@InsId;
END    
  
  
