SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TDSDeclaration_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TDSDeclaration_Select
	GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (22/04/2014)  >
Section  	: COMPANY MASTER SELECT
Purpose  	: COMPANY MASTER SELECT
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
CREATE PROCEDURE Sp_TDSDeclaration_Select
(
@Id BIGINT,
@UserId BIGINT
)
AS
BEGIN
IF(@Id=0)
BEGIN
  SELECT P.PropertyName,O.FirstName,TD.TDSPercentage,F.FinancialYear,TD.Id FROM WRBHBTDSDeclaration TD
  JOIN WRBHBProperty P ON TD.PropertyId=P.Id 
  JOIN WRBHBPropertyOwners O ON TD.OwnerId=O.Id
  JOIN WRBHBFinancialYear F ON TD.FinancialYearId=F.Id
  WHERE TD.IsActive=1 AND TD.IsDeleted=0
END

IF(@Id!=0)
BEGIN
	SELECT P.PropertyName PropertyName,P.Id as PId,O.FirstName OwnerName,O.Id as OId,TD.PANNO PanNo,
	TD.TDSPercentage TDSPercentage,F.FinancialYear FinancialYear,F.Id FId,TD.Image,TD.Id,
	Convert(NVARCHAR(100),TD.CreatedDate,103) AS Date FROM WRBHBTDSDeclaration TD
	JOIN WRBHBProperty P ON TD.PropertyId=P.Id 
	JOIN WRBHBPropertyOwners O ON TD.OwnerId=O.Id
	JOIN WRBHBFinancialYear F ON TD.FinancialYearId=F.Id
	WHERE TD.Id=@Id AND TD.IsActive=1 AND TD.IsDeleted=0
END
END

