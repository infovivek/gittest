SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractProductMaster_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_ContractProductMaster_Select
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACTPRODUCTMASTER SELECT
Purpose  	: PRODUCT SELECT
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
CREATE PROCEDURE Sp_ContractProductMaster_Select
(
@Id		INT,
@UserId INT
)
AS
BEGIN

IF @Id!=0
BEGIN
SELECT Convert(NVARCHAR,EffectiveFrom,103) AS EffectiveFrom,TypeService,ProductName,BasePrice,
PerQuantityprice,CP.Id,IsComplimentary,ContractRate,CPS.SubType,CPS.Id AS SubTypeId 
FROM WRBHBContarctProductMaster CP 
JOIN WRBHBContractProductSubMaster CPS ON CP.SubTypeId= CPS.Id AND CPS.IsActive=1 AND CPS.IsDeleted=0
WHERE CP.IsActive=1 AND CP.IsDeleted=0  AND CP.Id=@Id
END
ELSE
BEGIN
--SELECT Convert(NVARCHAR,EffectiveFrom,103) AS EffectiveFrom,TypeService,ProductName,BasePrice,
--PerQuantityprice,Id,IsComplimentary,ContractRate FROM WRBHBContarctProductMaster 
--WHERE IsActive=1 AND IsDeleted=0 

SELECT TypeService,ProductName,PerQuantityprice,Id 
FROM WRBHBContarctProductMaster WHERE IsActive=1 AND IsDeleted=0 
 order by Id desc  
END
END
