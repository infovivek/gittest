 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyUsers_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyUsers_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT USER
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
CREATE PROCEDURE [dbo].[Sp_PropertyUsers_Insert] (
@PropertyId				BIGINT,
@UserName				NVARCHAR(100),
@UserId					BIGINT,
@UserType				NVARCHAR(100),
@CreatedBy				BigInt,
@PropertyRowId          NVARCHAR(100)
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--INSERT
INSERT INTO dbo.WRBHBPropertyUsers(PropertyId,UserName,UserId,UserType,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
VALUES
(@PropertyId,@UserName,@UserId,@UserType,
@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),@IsActive,@IsDeleted,@PropertyRowId)

SELECT Id , RowId FROM WRBHBPropertyUsers WHERE Id=@@IDENTITY
END

GO
