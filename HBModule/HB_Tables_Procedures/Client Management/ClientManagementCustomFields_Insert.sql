SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ClientManagementCustomFields_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_ClientManagementCustomFields_Insert]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (19/02/2014)  >
Section  	: CLIENT MANAGEMENT CUSTOME FIELDS
Purpose  	: CLIENT CUSTOM FIELD INSERT
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi          21 Feb 2014                        Add new field Visible and datatype change Field Value
*******************************************************************************************************
*/
CREATE PROCEDURE sp_ClientManagementCustomFields_Insert(@CltmgntId BIGINT,
@FieldName NVARCHAR(100),@FieldType NVARCHAR(100),@FieldValue NVARCHAR(MAX),
@Mandatory BIT,@Visible BIT,@CreatedBy BIGINT,@CltmgntRowId NVARCHAR(100))
AS
BEGIN
 INSERT INTO WRBHBClientManagementCustomFields(CltmgntId,FieldName,
 FieldType,FieldValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
 IsActive,IsDeleted,RowId,Mandatory,Visible)
 VALUES(@CltmgntId,@FieldName,@FieldType,@FieldValue,@CreatedBy,
 GETDATE(),@CreatedBy,GETDATE(),1,0,@CltmgntRowId,@Mandatory,@Visible);
 SELECT Id,RowId FROM WRBHBClientManagementCustomFields WHERE Id=@@IDENTITY;
END	 
