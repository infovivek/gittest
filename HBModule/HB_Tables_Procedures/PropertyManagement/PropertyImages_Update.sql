 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyImages_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyImages_Update]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT Images
		Purpose  	: PROPERTY Update
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
CREATE PROCEDURE [dbo].[Sp_PropertyImages_Update] (
@PropertyId				BIGINT,
@ImageLocation			NVARCHAR(100),
@CreatedBy				BIGINT,
@Id						INT
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--Update
UPDATE dbo.WRBHBPropertyImages SET 
ImageLocation=@ImageLocation,
ModifiedBy=@CreatedBy,
ModifiedDate=GETDATE()
WHERE Id=@Id AND IsActive=1 AND IsDeleted=0

SELECT Id , RowId FROM WRBHBPropertyImages WHERE Id=@Id
END

GO
