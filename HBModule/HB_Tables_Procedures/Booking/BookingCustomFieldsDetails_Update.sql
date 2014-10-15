SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BookingCustomFieldsDetails_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_BookingCustomFieldsDetails_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: Custom Fields Details  Insert 
Purpose  	: Custom Fields Details  Insert
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
CREATE PROCEDURE [dbo].[Sp_BookingCustomFieldsDetails_Update](
@BookingId			BIGINT,
@CustomFieldsId		BIGINT,
@CustomFields		NVARCHAR(100),
@CustomFieldsValue	NVARCHAR(100),
@Mandatory			NVARCHAR(100),
@CreatedBy			BIGINT,
@Id					BIGINT) 
AS
BEGIN
 --UPDATE
 
	UPDATE WRBHBBookingCustomFieldsDetails SET
	BookingId=@BookingId,
	CustomFieldsId=@CustomFieldsId,
	CustomFields=@CustomFields,
	CustomFieldsValue=@CustomFieldsValue,
	Mandatory=@Mandatory,	
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id	
 
	SELECT Id,RowId FROM WRBHBBookingCustomFieldsDetails WHERE Id=@Id
 
END
GO
