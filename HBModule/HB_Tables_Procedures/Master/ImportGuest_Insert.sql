SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ImportGuest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ImportGuest_Insert]
GO 
/* 
        Author Name : <NAHARJUN.U>
		Created On 	: <Created Date (01/04/2014)  >
		Section  	: IMPORT GUEST INSERT
		Purpose  	: Sp_ImportGuest_Insert
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
CREATE PROCEDURE [dbo].[Sp_ImportGuest_Insert]
( 
@CompanyName NVARCHAR(100),  
@ClientId  BIGINT,  
@EmpCode  NVARCHAR(100),  
@FirstName  NVARCHAR(100),  
@LastName  NVARCHAR(100),  
@Grade   NVARCHAR(100),  
@MobileNumber NVARCHAR(100),  
@Email   NVARCHAR(100),  
@Designation NVARCHAR(100),  
@CreatedBy  BIGINT,  
@Nationality NVARCHAR(100),  
@C1    NVARCHAR(100),  
@C2    NVARCHAR(100),  
@C3    NVARCHAR(100),  
@C4    NVARCHAR(100),  
@C5    NVARCHAR(100),  
@C6    NVARCHAR(100),  
@C7    NVARCHAR(100),  
@C8    NVARCHAR(100),  
@C9    NVARCHAR(100),  
@C10   NVARCHAR(100)  
)  
AS  
BEGIN  

--THIS IS ARUN, AM USING THIS PRC FOR ADDCLIENT GUEST PLEASE ASK ME AND CHANGE
DECLARE @Identity int,@GradeId int  
  
IF EXISTS(SELECT NULL FROM WRBHBGradeMaster WITH(NOLOCK) WHERE IsDeleted=0 AND IsActive=1 AND Grade=@Grade   
AND ClientId=@ClientId )   
BEGIN  
 SET @GradeId=(SELECT Id FROM WRBHBGradeMaster WHERE Grade=@Grade AND IsActive=1 AND IsDeleted=0 AND   
 ClientId=@ClientId)  
   
 IF EXISTS(SELECT NULL FROM WRBHBClientManagementAddClientGuest WHERE EmpCode=@EmpCode AND EmailId=@Email AND IsActive=1 AND IsDeleted=0)  
 BEGIN  
  UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@ClientId,CompanyName=@CompanyName,  
  EmpCode=@EmpCode,FirstName=@FirstName,LastName=@LastName,Grade=@Grade,GMobileNo=@MobileNumber,  
  EmailId=@Email,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Designation=@Designation,GradeId=@GradeId,  
  Nationality=@Nationality WHERE EmpCode=@EmpCode AND EmailId=@Email AND IsActive=1 AND IsDeleted=0  
    
    
  --SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity  
  SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,  
  RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId  
  AND IsActive=1 AND IsDeleted=0;  
 END  
 ELSE  
 BEGIN  
  INSERT INTO WRBHBClientManagementAddClientGuest (CltmgntId,CompanyName,EmpCode,FirstName,LastName,Grade,  
     GMobileNo,EmailId,Designation,RangeMin,RangeMax,IsActive,IsDeleted, CreatedBy,CreatedDate,  
     ModifiedBy,ModifiedDate,RowId,GradeId,Nationality,Title,Column1,Column2,Column3,Column4,Column5,  
     Column6,Column7,Column8,Column9,Column10)  
  VALUES (@ClientId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,@MobileNumber,@Email,@Designation,0,0,1,  
    0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@GradeId,@Nationality,'',@C1,@C2,@C3,@C4,@C5,@C6,  
    @C7,@C8,@C9,@C10)  
  SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,  
  RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId  
  AND IsActive=1 AND IsDeleted=0;    
 END  
END  
ELSE  
BEGIN  
 INSERT INTO WRBHBGradeMaster(Grade,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,  
 ClientId) VALUES(@Grade,@CreatedBy,GETDATE(),@CreatedBy,@CreatedBy,1,0,NEWID(),@ClientId)  
  
 SELECT @Identity=@@IDENTITY  
  
 IF EXISTS(SELECT NULL FROM WRBHBClientManagementAddClientGuest WHERE EmpCode=@EmpCode AND EmailId=@Email AND IsActive=1 AND IsDeleted=0)  
 BEGIN  
  UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@ClientId,CompanyName=@CompanyName,  
  EmpCode=@EmpCode,FirstName=@FirstName,LastName=@LastName,Grade=@Grade,GMobileNo=@MobileNumber,  
  EmailId=@Email,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Designation=@Designation,GradeId=@GradeId,  
  Nationality=@Nationality WHERE EmpCode=@EmpCode AND EmailId=@Email AND IsActive=1 AND IsDeleted=0  
    
    
  --SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity  
  SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,  
  RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId  
  AND IsActive=1 AND IsDeleted=0;  
 END  
 ELSE  
 BEGIN  
  INSERT INTO WRBHBClientManagementAddClientGuest (CltmgntId,CompanyName,EmpCode,FirstName,LastName,Grade,  
     GMobileNo,EmailId,Designation,RangeMin,RangeMax,IsActive,IsDeleted, CreatedBy,CreatedDate,  
     ModifiedBy,ModifiedDate,RowId,GradeId,Nationality,Title,Column1,Column2,Column3,Column4,Column5,  
     Column6,Column7,Column8,Column9,Column10)  
  VALUES (@ClientId,@CompanyName,@EmpCode,@FirstName,@LastName,@Grade,@MobileNumber,@Email,@Designation,0,0,1,  
    0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Identity,@Nationality,'',@C1,@C2,@C3,@C4,@C5,@C6,  
    @C7,@C8,@C9,@C10)  
      
  SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,  
  RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId  
  AND IsActive=1 AND IsDeleted=0;  
 --SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity  
 END   
END  
END

