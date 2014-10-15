SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCash_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_PettyCash_Select
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: PETTYCASH SELECT
Purpose  	: PETTYCASH SELECT
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
CREATE PROCEDURE Sp_PettyCash_Select
(
@Id		INT,
@UserId INT
)
AS
BEGIN

IF @Id!=0
BEGIN
	SELECT Convert(NVARCHAR,Date,103) AS Date,Description,ExpenseHead,Amount,Id
	FROM WRBHBPettyCash
	WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id

	SELECT PC.PropertyId as data,WRBHBProperty.PropertyName as label 
	FROM WRBHBPettyCash PC
	JOIN WRBHBProperty ON PC.PropertyId=WRBHBProperty.Id 
	WHERE PC.Id=@Id
END
ELSE
BEGIN

SELECT Convert(NVARCHAR,PC.Date,103) AS Date,Description,ExpenseHead,Amount,PC.Id,P.PropertyName AS Property
	FROM WRBHBPettyCash PC
	JOIN WRBHBProperty P ON PC.PropertyId=P.Id
	WHERE P.IsActive=1 AND P.IsDeleted=0  AND PC.IsActive=1 AND PC.IsDeleted=0

 order by PC.Id desc  
END
END
