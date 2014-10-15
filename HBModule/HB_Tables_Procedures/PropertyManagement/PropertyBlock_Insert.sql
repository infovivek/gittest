 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyBlock_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyBlock_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT BLOCK
		Purpose  	: PROPERTY BLOCK Insert
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
CREATE PROCEDURE [dbo].[Sp_PropertyBlock_Insert] (
@PropertyId					BIGINT,
@BlockDescription			NVARCHAR(100),
@BlockName              	NVARCHAR(100),
@PropertyRowId				NVARCHAR(100),
@CreatedBy					BIGINT

) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--INSERT
INSERT INTO dbo.WRBHBPropertyBlocks(PropertyId,BlockDescription,BlockName,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
VALUES
(@PropertyId,@BlockDescription,@BlockName ,
@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),@IsActive,@IsDeleted,@PropertyRowId)

SELECT Id , RowId FROM WRBHBPropertyBlocks WHERE Id=@@IDENTITY
END

GO
