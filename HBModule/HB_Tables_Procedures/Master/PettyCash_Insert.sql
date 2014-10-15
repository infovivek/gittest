SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCash_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PettyCash_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: PETTYCASH INSERT
Purpose  	: PRODUCT INSERT
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
CREATE PROCEDURE [dbo].[Sp_PettyCash_Insert]
(
@PettyCashHdrId INT,
@Description	NVARCHAR(max),
@ExpenseHead	NVARCHAR(100),
@Amount			DECIMAL(27,1),
@Status			NVARCHAR(100),
@CreatedBy		INT
)
AS
BEGIN
DECLARE @Identity int
BEGIN 
	INSERT INTO	WRBHBPettyCash (PettyCashHdrId,Description,ExpenseHead,Amount,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,
			ModifiedDate,RowId,Status,Remark,ApprovedAmount)
	VALUES (@PettyCashHdrId,@Description,@ExpenseHead,@Amount,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),
			NEWID(),@Status,0,@Amount)
	
	SET  @Identity=@@IDENTITY
	SELECT Id,Rowid FROM WRBHBPettyCash WHERE Id=@Identity;
END
END			


