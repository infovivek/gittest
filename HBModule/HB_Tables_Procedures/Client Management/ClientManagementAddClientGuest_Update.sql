SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientManagementAddClientGuest_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_ClientManagementAddClientGuest_Update]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (19/02/2014)  >
Section  	: CLIENT MANAGEMENT ADD CLIENT GUEST
Purpose  	: CLIENT GUEST Update
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi          21 Feb 2014                         Data Type Alterations
*******************************************************************************************************
*/
CREATE PROCEDURE sp_ClientManagementAddClientGuest_Update(@Id BIGINT,
@CltmgntId BIGINT,@CompanyName NVARCHAR(100),@EmpCode NVARCHAR(100),
@FirstName NVARCHAR(100),@LastName NVARCHAR(100),@Grade NVARCHAR(100),
@GMobileNo NVARCHAR(100),@EmailId NVARCHAR(100),@RangeMin DECIMAL(27,2),
@RangeMax DECIMAL(27,2),@CreatedBy BIGINT,@CltmgntRowId NVARCHAR(100),@Designation NVARCHAR(100))
AS
BEGIN
DECLARE @GradeId BIGINT
IF NOT EXISTS (SELECT NULL FROM WRBHBGradeMaster WITH (NOLOCK)
WHERE UPPER(Grade) = UPPER(@Grade)  AND IsDeleted = 0 AND IsActive = 1 AND ClientId=@CltmgntId)

BEGIN
	INSERT INTO WRBHBGradeMaster(Grade,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,IsDeleted,RowId,ClientId)

	VALUES(@Grade,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@CltmgntId)

SELECT @GradeId =@@IDENTITY;
END
ELSE
BEGIN
	SELECT @GradeId=Id FROM WRBHBGradeMaster WITH (NOLOCK)
	WHERE UPPER(Grade) = UPPER(@Grade)  AND IsDeleted = 0 AND IsActive = 1 AND ClientId=@CltmgntId
END

 UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@CltmgntId,
 CompanyName=@CompanyName,EmpCode=@EmpCode,FirstName=@FirstName,
 LastName=@LastName,Grade=@Grade,GMobileNo=@GMobileNo,EmailId=@EmailId,
 RangeMin=@RangeMin,RangeMax=@RangeMax,ModifiedBy=@CreatedBy,Designation=@Designation,
 ModifiedDate=GETDATE(),GradeId=@GradeId WHERE Id=@Id;	   
 SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Id;	   
END
