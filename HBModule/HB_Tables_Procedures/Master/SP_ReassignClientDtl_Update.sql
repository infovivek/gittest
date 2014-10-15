SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ReassignClientDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ReassignClientDtl_Update]
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
CREATE PROCEDURE [dbo].[Sp_ReassignClientDtl_Update] (
@Id					BIGINT,
@SelectId           BIGINT,
@UserId             BIGINT,
@ReassignId			BIGINT,
@check				Bit,
@RoleName           NVARCHAR(100),
@CreatedBy			BIGINT,
@TranferDtlsId      NVarChar(4000),
@ReassignClientHdrId  BIGINT
) 
AS
BEGIN
IF(@check =1)
UPDATE WRBHBReference SET Details=@TranferDtlsId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@ReassignClientHdrId AND IsActive=1 AND IsDeleted=0;

IF(@RoleName='Sales Executive')
	BEGIN
		IF(@check =1)
		BEGIN
			UPDATE WRBHBClientManagement SET 
			SalesExecutiveId=@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND IsActive=1 AND IsDeleted=0

			SELECT Id ,RowId FROM WRBHBClientManagement WHERE Id=@Id
		END
	END

ELSE
IF(@RoleName='CRM')
	BEGIN
	IF(@check =1)
		BEGIN
			UPDATE WRBHBClientManagement SET 
			CRMId=@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND IsActive=1 AND IsDeleted=0


			SELECT Id ,RowId FROM WRBHBClientManagement WHERE Id=@Id
		END
	END
ELSE
IF(@RoleName='Key Account Person')
	BEGIN
		IF(@check =1)
			BEGIN
			UPDATE WRBHBClientManagement SET 
			KeyAccountPersonId=@ReassignId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND IsActive=1 AND IsDeleted=0

			SELECT Id ,RowId FROM WRBHBClientManagement WHERE Id=@Id
		END
	END

END

GO
