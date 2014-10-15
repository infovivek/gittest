SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PettyCashHdr_Insert]
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
CREATE PROCEDURE [dbo].[Sp_PettyCashHdr_Insert]
(
@Date			NVARCHAR(100),
@PropertyId		BIGINT,
@UserId			BIGINT,
@Total			DECIMAL(27,2),
@ExpenseGroupId	BIGINT,
@OpeningBalance DECIMAL(27,2),
@CreatedBy		INT
)
AS
BEGIN
DECLARE @Identity int,@ER INT,@ErrMsg NVARCHAR(MAX)
SET @ER=(SELECT DISTINCT UserId FROM WRBHBPettyCashHdr WHERE UserId=@UserId AND PropertyId=@PropertyId
		 AND IsActive=1 AND IsDeleted=0 AND ExpenseReport=0)
IF ISNULL(@ER,0) != 0
BEGIN
	  SET @ErrMsg = 'Your Previous Request Is Not Completed';
	  SELECT @ErrMsg;
END
ELSE
BEGIN 
	INSERT INTO	WRBHBPettyCashHdr (Date,PropertyId,UserId,TotalAmount,ExpenseGroupId,Flag,OpeningBalance,
	ClosingBalance,ExpenseReport,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (Convert(date,@Date,103),@PropertyId,@UserId,@Total,@ExpenseGroupId,0,@OpeningBalance,0,0,
	1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
	
	SET  @Identity=@@IDENTITY
	SELECT Id,Rowid FROM WRBHBPettyCashHdr WHERE Id=@Identity;
END
END			

