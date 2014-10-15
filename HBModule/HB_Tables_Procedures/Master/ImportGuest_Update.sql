SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ImportGuest_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ImportGuest_Update]
GO 
/* 
        Author Name : <NAHARJUN.U>
		Created On 	: <Created Date (01/04/2014)  >
		Section  	: IMPORT GUEST Update
		Purpose  	: Sp_ImportGuest_Update
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
CREATE PROCEDURE [dbo].[Sp_ImportGuest_Update]
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
@Id				BIGINT,
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
DECLARE @Identity int
Update WRBHBClientManagementAddClientGuest SET CompanyName=@CompanyName,
EmpCode=@EmpCode,FirstName=@FirstName,LastName=@LastName,Grade=@Grade,
		GMobileNo=@MobileNumber,EmailId=@Email,Designation=@Designation,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id

--SET  @Identity=@@IDENTITY
SELECT CompanyName,EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,Designation,
RangeMin,RangeMax,Id,RowId FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@ClientId
AND IsActive=1 AND IsDeleted=0;
END					 