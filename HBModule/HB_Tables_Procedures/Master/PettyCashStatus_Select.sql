SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashStatus_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCashStatus_Select

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (2/04/2014)  >
Section  	: PETTYCASH STATUS SELECT
Purpose  	: PETTYCASH STATUS SELECT
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

CREATE PROCEDURE Sp_PettyCashStatus_Select
(
@PropertyId BIGINT,
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		BIGINT,
@Id			BIGINT
)
AS
BEGIN
	IF @Id=0
	
	BEGIN
		SELECT ExpenseHead,Amount,Paid FROM WRBHBPettyCashStatus
	END
	ELSE
	BEGIN
		SELECT ExpenseHead,Status,Description,Amount,Paid,Id FROM WRBHBPettyCashStatus 
		WHERE Id=@Id
	END
END