
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatusHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatusHdr_Update

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

CREATE PROCEDURE Sp_PettyCashStatusHdr_Update
(
@PropertyId     BIGINT,
@UserId		    BIGINT,
@Balance		DECIMAL(27,2),
@CreatedBy		INT,
@Id				INT
)
AS

BEGIN

	UPDATE WRBHBPettyCashStatusHdr SET PropertyId=@PropertyId,UserId=@UserId,Balance=@Balance,
	Flag=1,NewEntry=0,Modifiedby=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id 
	
	
SELECT Id,RowId FROM WRBHBPettyCashStatusHdr WHERE Id=@Id;
END