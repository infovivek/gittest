SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ReassignPropertyDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ReassignPropertyDtl_Update]
GO   
/* 
        Author Name : <Anbu.P>
		Created On 	: <Created Date (07/04/2014)  >
		Section  	: Reassign Executive
		Purpose  	: Executive Update
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
CREATE PROCEDURE [dbo].[Sp_ReassignPropertyDtl_Update] (
@Id					BIGINT,
--@Details			Nvarchar(100),
@PropertyId           BIGINT,
@UserId             BIGINT,
@ReassignId			BIGINT,
@check				Bit,
@RoleName           NVARCHAR(100),
@CreatedBy			BIGINT,
@TranferDtlsId      NVarChar(4000),
@ReassignPropertyHdrId  BIGINT
) 
AS
BEGIN
IF(@check =1)
UPDATE WRBHBReference SET Details=@TranferDtlsId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@ReassignPropertyHdrId AND IsActive=1 AND IsDeleted=0;

IF(@RoleName ='Operations Managers')
BEGIN
IF(@check =1)
	BEGIN
		UPDATE WRBHBPropertyUsers SET 
		UserId =@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0
    	
    	SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
 END
 END
ELSE
IF(@RoleName='Resident Managers')
BEGIN
		IF(@check =1)
		BEGIN
			UPDATE WRBHBPropertyUsers SET 
			UserId =@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0
			
			SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
		END	 
END
ELSE
IF(@RoleName='Assistant Resident Managers')
BEGIN
	IF(@check =1)
	BEGIN
		UPDATE WRBHBPropertyUsers SET 
		UserId =@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0

		SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
	END 
END
ELSE
IF(@RoleName='Project Managers')
BEGIN
	IF(@check =1)
	BEGIN
			UPDATE WRBHBPropertyUsers SET 
			UserId =@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND  PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0

			SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
	END
END
ELSE
IF(@RoleName='Other Roles')
	BEGIN
	IF(@check =1)
			BEGIN
			UPDATE WRBHBPropertyUsers SET 
			UserId=@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id  AND PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0

			SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
	END
END
ELSE
IF(@RoleName ='Sales')
BEGIN
	IF(@check =1)
	BEGIN
		UPDATE WRBHBPropertyUsers SET 
		UserId=@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND PropertyId=@PropertyId AND IsActive=1 AND IsDeleted=0

		SELECT Id ,RowId FROM WRBHBPropertyUsers WHERE Id=@Id
	END
END
END
GO
