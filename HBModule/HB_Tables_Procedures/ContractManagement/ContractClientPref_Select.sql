SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_ContractClientPref_Select
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PERF SELECT
Purpose  	: CLIENT PREF SELECT
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
CREATE PROCEDURE Sp_ContractClientPref_Select
(
@Id		INT,
@UserId INT
)
AS
BEGIN

IF @Id!=0
BEGIN
	SELECT ClientName,ClientId,Date,Id FROM WRBHBContractClientPref_Header WHERE Id=@Id 
	AND IsActive=1 AND IsDeleted=0
    
    SELECT HeaderId,P.PropertyName as Property,PropertyId,RoomType,RoomId,TariffSingle,TariffDouble,
    TariffTriple,Facility,TaxInclusive as Inclusive ,TaxPercentage as Tax,C.Id
	FROM WRBHBContractClientPref_Details C
	JOIN WRBHBProperty P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	WHERE HeaderId=@Id AND C.IsActive=1 AND C.IsDeleted=0 ORDER BY P.PropertyName
END
ELSE
BEGIN
	SELECT ClientName,Id FROM WRBHBContractClientPref_Header  
   	where IsActive=1 and IsDeleted=0;  
	
END
END