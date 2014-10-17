SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatus_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatus_Insert

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (28/06/2014)  >
Section  	: PETTYCASH STATUS HELP
Purpose  	: PETTYCASH STATUS HELP
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

CREATE PROCEDURE Sp_PettyCashStatus_Insert
(
@ExpenseHead    NVARCHAR(100),
@Status		    NVARCHAR(100),
@Description	NVARCHAR(100),
@Amount         DECIMAL(27,2),
@Paid		    DECIMAL(27,2),
@PropertyId     BIGINT,
@BillLogo       NVARCHAR(1000),
@ExpenseId		BIGINT,
@BillDate       NVARCHAR(1000),
@UserId		    BIGINT
)
AS
DECLARE @Identity int
BEGIN
	UPDATE WRBHBPettyCashApprovalDtl SET Process=0 
	WHERE UserId=@UserId AND PropertyId=@PropertyId
	
	UPDATE WRBHBNewPettyCashApprovalDtl SET Process=0,IsActive=0,IsDeleted=1
	WHERE UserId=@UserId AND PropertyId=@PropertyId
	
	INSERT INTO WRBHBPettyCashStatus(PropertyId,ExpenseHead,Status,Description,Amount,
	Paid,UserId,IsActive,IsDeleted,Createdby,Createddate,Modifiedby,Modifieddate,
	RowId,Flag,BillLogo,ExpenseId,BillDate)
	VALUES(@PropertyId,@ExpenseHead,@Status,@Description,@Amount,@Paid,@UserId,1,0,@UserId,
	GETDATE(),@UserId,GETDATE(),NEWID(),1,@BillLogo,@ExpenseId,@BillDate)
	
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBPettyCashStatus WHERE Id=@Identity;
END


--TRUNCATE TABLE WRBHBPettyCashStatus
