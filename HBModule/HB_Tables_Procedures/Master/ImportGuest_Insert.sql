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
	@Id    BIGINT
)
AS
BEGIN
DECLARE @Email NVARCHAR(100),@ECode NVARCHAR(100),@Id1 INT

SET @Email=(SELECT Email FROM WRBHBImportGuest WHERE Id=@Id)
SET @ECode=(SELECT EmpCode FROM WRBHBImportGuest WHERE Id=@Id)
	
SET @Id1=(SELECT Id FROM WRBHBClientManagementAddClientGuest 
WHERE EmailId=@Email AND EmpCode=@ECode)
IF ISNULL(@Id1,0)=0
	BEGIN
		INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,EmpCode,FirstName,LastName,Grade,
		GMobileNo,EmailId,RangeMin,RangeMax,Designation,GradeId,Nationality,Title,Column1,Column2,
		Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,IsDeleted,RowId)
		
		SELECT ClientId,'' AS CompanyName,EmpCode,FirstName,LastName,Grade,MobileNo AS GMobileNo,Email AS EmailId,
		0.00 AS RangeMin,0.00 AS RangeMax,Designation,0 AS GradeId,Nationality,'' AS Title,Column1,Column2,
		Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,1 AS CreatedBy,GETDATE(),1 AS ModifiedBy,
		GETDATE(),1,0,NEWID() FROM WRBHBImportGuest
		WHERE Id=@Id 
	
	END
	ELSE
	BEGIN
		UPDATE WRBHBClientManagementAddClientGuest SET CltmgntId=IG.ClientId,CompanyName='',
		EmpCode=IG.EmpCode,FirstName=IG.FirstName,LastName=IG.LastName,Grade=IG.Grade,
		GMobileNo=IG.MobileNo,EmailId=IG.Email,Designation=IG.Designation,Nationality=IG.Nationality,
		Column1=IG.Column1,Column2=IG.Column2,Column3=IG.Column3,Column4=IG.Column4,Column5=IG.Column5,
		Column6=IG.Column6,Column7=IG.Column7,Column8=IG.Column8,Column9=IG.Column9,Column10=IG.Column10,
		ModifiedBy=1,ModifiedDate=GETDATE() FROM WRBHBImportGuest IG
		JOIN WRBHBClientManagementAddClientGuest C ON IG.ClientId=C.CltmgntId AND C.IsActive=1 AND C.IsDeleted=0
		WHERE C.Id=@Id1 
	END
END

