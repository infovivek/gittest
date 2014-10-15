SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCash_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PettyCash_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: PETTYCASH Update
Purpose  	: PETTYCASH Update
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
CREATE PROCEDURE [dbo].[Sp_PettyCash_Update]
(
@Date			NVARCHAR(100),
@Description	NVARCHAR(MAX),
@ExpenseHead	NVARCHAR(100),
@Amount			DECIMAL(27,1),
@CreatedBy		INT,
@Status			NVARCHAR(100),
@Comments		NVARCHAR(1000),
@PropertyId		BIGINT,
@UserId			BIGINT,
@Id				BIGINT,
@Total			BIGINT,
@ExpenseGroupId	BIGINT
)
AS
BEGIN
DECLARE @Identity int
UPDATE WRBHBPettyCash SET Date=Convert(date,@Date,103),Description=@Description,ExpenseHead=@ExpenseHead,
Amount=@Amount,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),TotalAmount=@Total,ExpenseGroupId=@ExpenseGroupId,
Status=@Status
WHERE Id=@Id 
			
SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBPettyCash WHERE Id=@Identity;
	
END			