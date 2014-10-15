 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyImages_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyImages_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT IMAGE
		Purpose  	: PROPERTY Insert
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
CREATE PROCEDURE [dbo].[Sp_PropertyImages_Insert] (
@PropertyId				BIGINT,
@ImageLocation			NVARCHAR(100),
@CreatedBy				INT
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--INSERT
INSERT INTO dbo.WRBHBPropertyImages(PropertyId,ImageLocation,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
VALUES
(@PropertyId,@ImageLocation,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),@IsActive,@IsDeleted,@RowId)

SELECT Id , RowId FROM WRBHBPropertyImages WHERE Id=@@IDENTITY
END

GO
