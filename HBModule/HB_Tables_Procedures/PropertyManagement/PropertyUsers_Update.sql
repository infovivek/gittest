 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyUsers_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyUsers_Update]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT USER
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
CREATE PROCEDURE [dbo].[Sp_PropertyUsers_Update] (
@PropertyId				BIGINT,
@UserName				NVARCHAR(100),
@UserId					BIGINT,
@UserType				NVARCHAR(100),
@CreatedBy				BIGINT,
@Id						BigInt,
@PropertyRowId          NVARCHAR(100)
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--Update
UPDATE dbo.WRBHBPropertyUsers SET 
UserName=@UserName,UserId=@UserId,UserType=@UserType,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id AND IsActive=1 AND IsDeleted=0

SELECT Id , RowId FROM WRBHBPropertyUsers WHERE Id=@Id
END

GO
