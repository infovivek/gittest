SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TransSubsPriceModel_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[Sp_TransSubsPriceModel_Select]
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TRANSSUBSPRICEMODEL SELECT
Purpose  	: MODEL SELECT
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
CREATE PROCEDURE Sp_TransSubsPriceModel_Select
(
@Id INT,
@UserId INT
)
AS
BEGIN

IF @Id!=0
BEGIN
SELECT Types,Name,Amount,AllowedBookings,Id,EscalationTenure,EscalationPercentage FROM WRBHBTransSubsPriceModel 
WHERE IsActive=1 AND IsDeleted=0  AND Id=@Id
END
ELSE
BEGIN
SELECT Name,AllowedBookings,Id FROM WRBHBTransSubsPriceModel  WHERE IsActive=1 AND IsDeleted=0
END
	
END