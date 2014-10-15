SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientManagementAddNewClient_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_ClientManagementAddNewClient_Insert]
GO 
/*
Author Name : <NAHARJUN.U>
		Created On 	: <Created Date (19/02/2014)  >
		Section  	: CLIENT MANAGEMENT ADD NEW CLIENT
		Purpose  	: CLIENT INSERT
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
CREATE PROCEDURE sp_ClientManagementAddNewClient_Insert
(
@CltmgntId		BIGINT,
@ContactType	NVARCHAR(100),
@Title			NVARCHAR(100),
@FirstName		NVARCHAR(100),
@LastName		NVARCHAR(100),
@Gender			NVARCHAR(100),
@Designation	NVARCHAR(100),
@MobileNo		NVARCHAR(100),
@Email			NVARCHAR(100),
@AlternateEmail	NVARCHAR(100),
@CreatedBy		BIGINT,
@CltmgntRowId   NVARCHAR(100)
)
AS 
BEGIN
---Insert ContactType
 DECLARE @ContactTypeId BIGINT;
 IF NOT EXISTS(SELECT Id FROM WRBHBClientContactType WHERE UPPER(ContactType)=UPPER(@ContactType))
 BEGIN
	INSERT INTO WRBHBClientContactType(ContactType,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
	VALUES(@ContactType,@CreatedBy,GETDATE(),
	@CreatedBy,GETDATE(),1,0,@CltmgntRowId);
	
	SELECT @ContactTypeId=@@IDENTITY;
	
 END
 ELSE
 BEGIN
	SELECT @ContactTypeId=Id FROM WRBHBClientContactType WHERE UPPER(ContactType)=UPPER(@ContactType)  ;
 END
 ---Insert WRBHBClientManagementAddNewClient
 INSERT INTO WRBHBClientManagementAddNewClient(CltmgntId,ContactType,Title,
 FirstName,LastName,Gender,Designation,MobileNo,Email,AlternateEmail,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,ContactTypeId)
 VALUES(@CltmgntId,@ContactType,@Title,@FirstName,@LastName,@Gender,
 @Designation,@MobileNo,@Email,@AlternateEmail,@CreatedBy,GETDATE(),
 @CreatedBy,GETDATE(),1,0,@CltmgntRowId,@ContactTypeId);			
 SELECT Id,RowId FROM WRBHBClientManagementAddNewClient WHERE Id=@@IDENTITY;
END