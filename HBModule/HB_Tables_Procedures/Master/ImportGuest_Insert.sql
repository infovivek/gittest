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
@CompanyName	NVARCHAR(100),
@ClientId		BIGINT,
@EmpCode		NVARCHAR(100),
@FirstName		NVARCHAR(100),
@LastName		NVARCHAR(100),
@Grade			NVARCHAR(100),
@MobileNumber	NVARCHAR(100),
@Email			NVARCHAR(100),
@Designation	NVARCHAR(100),
@CreatedBy		BIGINT,
@Nationality	NVARCHAR(100),
@C1				NVARCHAR(100),
@C2				NVARCHAR(100),
@C3				NVARCHAR(100),
@C4				NVARCHAR(100),
@C5				NVARCHAR(100),
@C6				NVARCHAR(100),
@C7				NVARCHAR(100),
@C8				NVARCHAR(100),
@C9				NVARCHAR(100),
@C10			NVARCHAR(100)
)
AS
BEGIN
DECLARE @Identity int,@GradeId int

IF EXISTS(SELECT NULL FROM WRBHBGradeMaster WITH(NOLOCK) WHERE IsDeleted=0 AND IsActive=1 AND Grade=@Grade 
AND ClientId=@ClientId ) 
BEGIN
	SET @GradeId=(SELECT Id FROM WRBHBGradeMaster WHERE Grade=@Grade AND IsActive=1 AND IsDeleted=0 AND 
	ClientId=@ClientId)
	
	IF EXISTS(SELECT NULL FROM WRBHBClientManagementAddClientGuest WHERE EmpCode=@EmpCode AND 
	EmailId=@Email AND IsActive=1 AND IsDeleted=0)
	BEGIN
		UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@ClientId,CompanyName=ISNULL(@CompanyName,''),
		EmpCode=@EmpCode,FirstName=ISNULL(@FirstName,''),LastName=ISNULL(@LastName,''),Grade=@Grade,
		GMobileNo=ISNULL(@MobileNumber,''),EmailId=@Email,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
		Designation=ISNULL(@Designation,''),GradeId=@GradeId,Nationality=ISNULL(@Nationality,''),
		Column1=ISNULL(@C1,''),
		Column2=ISNULL(@C2,''),
		Column3=ISNULL(@C3,''),
		Column4=ISNULL(@C4,''),
		Column5=ISNULL(@C5,''),
		Column6=ISNULL(@C6,''),
		Column7=ISNULL(@C7,''),
		Column8=ISNULL(@C8,''),
		Column9=ISNULL(@C9,''),
		Column10=ISNULL(@C10,'')
		WHERE EmpCode=@EmpCode AND EmailId=@Email AND IsActive=1 AND IsDeleted=0
		
		
		--SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity
		SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,
		RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId
		AND IsActive=1 AND IsDeleted=0;
	END
	ELSE
	BEGIN
		INSERT INTO WRBHBClientManagementAddClientGuest (CltmgntId,CompanyName,EmpCode,FirstName,LastName,Grade,
					GMobileNo,EmailId,Designation,RangeMin,RangeMax,IsActive,IsDeleted,	CreatedBy,CreatedDate,
					ModifiedBy,ModifiedDate,RowId,GradeId,Nationality,Title,Column1,Column2,Column3,Column4,Column5,
					Column6,Column7,Column8,Column9,Column10)
		VALUES (@ClientId,ISNULL(@CompanyName,''),@EmpCode,ISNULL(@FirstName,''),ISNULL(@LastName,''),
		@Grade,ISNULL(@MobileNumber,''),@Email,ISNULL(@Designation,''),0,0,1,
				0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),
				ISNULL(@GradeId,0),
				ISNULL(@Nationality,''),'',
				ISNULL(@C1,''),
				ISNULL(@C2,''),
				ISNULL(@C3,''),
				ISNULL(@C4,''),
				ISNULL(@C5,''),
				ISNULL(@C6,''),
				ISNULL(@C7,''),
				ISNULL(@C8,''),
				ISNULL(@C9,''),
				ISNULL(@C10,''))
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

	IF EXISTS(SELECT NULL FROM WRBHBClientManagementAddClientGuest WHERE EmpCode=@EmpCode AND EmailId=ISNULL(@Email,'') AND IsActive=1 AND IsDeleted=0)
	BEGIN
		UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=@ClientId,CompanyName=ISNULL(@CompanyName,''),
		EmpCode=@EmpCode,FirstName=ISNULL(@FirstName,''),LastName=ISNULL(@LastName,''),Grade=@Grade,
		GMobileNo=ISNULL(@MobileNumber,''),EmailId=@Email,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
		Designation=ISNULL(@Designation,''),GradeId=@GradeId,Nationality=ISNULL(@Nationality,''),
		Column1=ISNULL(@C1,''),
		Column2=ISNULL(@C2,''),
		Column3=ISNULL(@C3,''),
		Column4=ISNULL(@C4,''),
		Column5=ISNULL(@C5,''),
		Column6=ISNULL(@C6,''),
		Column7=ISNULL(@C7,''),
		Column8=ISNULL(@C8,''),
		Column9=ISNULL(@C9,''),
		Column10=ISNULL(@C10,'')
		 WHERE EmpCode=@EmpCode AND EmailId=ISNULL(@Email,'') AND IsActive=1 AND IsDeleted=0
		
		
		--SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity
		SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,
		RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId
		AND IsActive=1 AND IsDeleted=0;
	END
	ELSE
	BEGIN
		INSERT INTO WRBHBClientManagementAddClientGuest (CltmgntId,CompanyName,EmpCode,FirstName,LastName,Grade,
					GMobileNo,EmailId,Designation,RangeMin,RangeMax,IsActive,IsDeleted,	CreatedBy,CreatedDate,
					ModifiedBy,ModifiedDate,RowId,GradeId,Nationality,Title,Column1,Column2,Column3,Column4,Column5,
					Column6,Column7,Column8,Column9,Column10)
		VALUES (@ClientId,ISNULL(@CompanyName,''),@EmpCode,ISNULL(@FirstName,''),ISNULL(@LastName,''),@Grade,
				ISNULL(@MobileNumber,''),@Email,ISNULL(@Designation,''),0,0,1,0,@CreatedBy,GETDATE(),
				@CreatedBy,GETDATE(),NEWID(),@Identity,ISNULL(@Nationality,''),'',
				ISNULL(@C1,''),
				ISNULL(@C2,''),
				ISNULL(@C3,''),
				ISNULL(@C4,''),
				ISNULL(@C5,''),
				ISNULL(@C6,''),
				ISNULL(@C7,''),
				ISNULL(@C8,''),
				ISNULL(@C9,''),
				ISNULL(@C10,''))
				
		SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,
		RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId
		AND IsActive=1 AND IsDeleted=0;
	--SELECT Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE Id=@Identity
	END	
END
END

