SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientManagementAddClientGuest_Insert_mvc]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_ClientManagementAddClientGuest_Insert_mvc]
GO 
 
CREATE PROCEDURE sp_ClientManagementAddClientGuest_Insert_mvc(    
@CltmgntId BIGINT,@CompanyName NVARCHAR(100),@EmpCode NVARCHAR(100),    
@FirstName NVARCHAR(100),@LastName NVARCHAR(100),@Grade NVARCHAR(100),    
@GMobileNo NVARCHAR(100),@EmailId NVARCHAR(100),@Designation NVARCHAR(100),
@Nationality nvarchar(100),@Column1  nvarchar(100),@Column2 nvarchar(100),@Column3 nvarchar(100),
@Column4 nvarchar(100),@Column5 nvarchar(100),@Column6 nvarchar(100),@Column7 nvarchar(100),
@Column8 nvarchar(100),@Column9 nvarchar(100),@Column10 nvarchar(100),
@RangeMin DECIMAL(27,2),@RangeMax DECIMAL(27,2),@CreatedBy BIGINT,@CltmgntRowId NVARCHAR(100) )    
AS     
BEGIN    
Set @CltmgntId=(Select Id from WRBHBClientManagement where IsActive=1 and ClientName=@CompanyName)
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
 DECLARE @Pwd NVARCHAR(100)='',@PwdBinary VARBINARY(300),@Id Bigint;    
 Select @Id =(SELECT Id FROM WRBHBClientManagementAddClientGuest WITH (NOLOCK)    
 WHERE IsActive = 1 AND CltmgntId=@CltmgntId and EmpCode=@EmpCode and EmailId=@EmailId)   
 --Select @Id;
 If ( isnull(@Id,0)!= 0) 
  BEGIN    
	 UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@CltmgntId,
	 CompanyName=@CompanyName,EmpCode=@EmpCode,FirstName=@FirstName,
	 LastName=@LastName,Grade=@Grade,GMobileNo=@GMobileNo,EmailId=@EmailId,
	 RangeMin=@RangeMin,RangeMax=@RangeMax,ModifiedBy=@CreatedBy,Designation=@Designation,
	 ModifiedDate=GETDATE(),GradeId=@GradeId WHERE Id=@id;	
   --DECLARE @UserPassword VARCHAR(100)   
   ----PASSWORD GENERATION  (all values between ASCII code 48 - 122 excluding defaults)    
   --EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out     
   --SET @UserPassword=@UserPassword;    
   --open symmetric key sk_key decryption by password = 'WARBHB@Pass';   
   --INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,    
   --EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,    
   --CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,    
   --Designation,GradeId,Nationality,Title,Password,Column1,Column2,
			--	Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10)
				    
   --VALUES(@CltmgntId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,    
   --@GMobileNo,@EmailId,@RangeMin,@RangeMax,@CreatedBy,GETDATE(),@CreatedBy,    
   --GETDATE(),1,0,@CltmgntRowId,@Designation,@GradeId,@Nationality,'',
   --encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'),
   --@Column1,@Column2,@Column3,@Column4,@Column5,@Column6,@Column7,@Column8,@Column9,@Column10);         
  END   
 ELSE  
  BEGIN  
   INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,    
   EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,    
   CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,    
   Designation,GradeId,Nationality,Title,Password,Column1,Column2,
				Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10)    
   VALUES(@CltmgntId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,    
   @GMobileNo,@EmailId,@RangeMin,@RangeMax,@CreatedBy,GETDATE(),@CreatedBy,    
   GETDATE(),1,0,@CltmgntRowId,@Designation,@GradeId,@Nationality,'',
   encryptbykey(key_guid('sk_key'), '', 1, 'HB@1wr'),
   @Column1,@Column2,@Column3,@Column4,@Column5,@Column6,@Column7,@Column8,@Column9,@Column10);    
  END   
 --
 --DECLARE @InsId BIGINT;
 --SET @InsId=@@IDENTITY;
 --SELECT Id,RowId,Password,@Pwd AS PwdVarchar 
 --FROM WRBHBClientManagementAddClientGuest WHERE Id=@InsId;
END    
  
 