SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PettyCashApprovalHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PettyCashApprovalHdr_Insert]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (03/06/2014)  >
Section  	: PETTYCASH REQUESTED HELP
Purpose  	: PETTYCASH REQUESTED HELP
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
CREATE PROCEDURE [dbo].[SP_PettyCashApprovalHdr_Insert]
(
@PropertyId		BIGINT,
@UserId			BIGINT,
@Property	NVARCHAR(100),
@CreatedBy		INT
)
AS
BEGIN
	DECLARE @Identity int
	
	INSERT INTO	WRBHBNewPettyCashApprovalHdr (PropertyId,UserId,Property,IsActive,IsDeleted,CreatedBy,
	CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@PropertyId,@UserId,@Property,1,0,@CreatedBy,GETDATE()
	,@CreatedBy,GETDATE(),NEWID())
	
	
	INSERT INTO	WRBHBPettyCashApprovalHdr (PropertyId,UserId,Property,IsActive,IsDeleted,CreatedBy,
	CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@PropertyId,@UserId,@Property,1,0,@CreatedBy,GETDATE()
	,@CreatedBy,GETDATE(),NEWID()) 
	
	SELECT Id,RowId FROM WRBHBPettyCashApprovalHdr WHERE Id=@@IDENTITY;
END			