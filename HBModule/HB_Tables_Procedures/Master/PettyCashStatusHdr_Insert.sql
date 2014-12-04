SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatusHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatusHdr_Insert

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (29/10/2014)  >
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

CREATE PROCEDURE Sp_PettyCashStatusHdr_Insert
(

@PropertyId     BIGINT,
@UserId		    BIGINT,
@Balance		DECIMAL(27,2),
@CreatedBy		BIGINT
)
AS
DECLARE @Identity int,@NewEntry bit,@ErrMsg NVARCHAR(MAX)
BEGIN
	SET @NewEntry=(SELECT NewEntry FROM WRBHBPettyCashStatusHdr
	WHERE PropertyId=@PropertyId AND UserId=@UserId AND IsActive=1 AND IsDeleted=0 AND
	Id=(SELECT MAX(Id) FROM WRBHBPettyCashStatusHdr WHERE UserId=@UserId AND
	PropertyId=@PropertyId))
	
	IF(@NewEntry=0)
	BEGIN
		SET @ErrMsg = 'PC Expense Report Can be submit after the Previous Expense Report Approval.';
	    SELECT @ErrMsg;
	END
	ELSE
	BEGIN	
		INSERT INTO WRBHBPettyCashStatusHdr(PropertyId,UserId,Balance,IsActive,IsDeleted,Createdby,
		Createddate,Modifiedby,Modifieddate,RowId,Flag,NewEntry)
		VALUES(@PropertyId,@UserId,@Balance,1,0,@UserId,GETDATE(),@UserId,GETDATE(),NEWID(),1,0)
	
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBPettyCashStatusHdr WHERE Id=@Identity;
	
	END
END


--TRUNCATE TABLE WRBHBPettyCashStatus
