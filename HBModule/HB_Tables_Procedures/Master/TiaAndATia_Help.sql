SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TiaAndATia_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TiaAndATia_Help
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TiaAndATia_Help
Purpose  	: TiaAndATia_Help
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
CREATE PROCEDURE [dbo].Sp_TiaAndATia_Help
(
@Action NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	SELECT PropertyName as Property,Id as Id FROM WRBHBProperty WHERE IsActive=1 AND IsDeleted=0
	
	SELECT AdjustmentCategory as label,Id FROM WRBHBAdjustmentCategories
	
	SELECT FinancialYear AS label,Id as data FROM WRBHBFinancialYear
END
IF @Action='OWNERLOAD'
 BEGIN
	SELECT FirstName Owner,Id Id FROM WRBHBPropertyOwners WHERE PropertyId=@Id AND IsActive=1 AND IsDeleted=0
END	
IF @Action='PANLOAD'
 BEGIN
	SELECT PANNO FROM WRBHBPropertyOwners WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
 END
 IF @Action='Flag'
 BEGIN
	SELECT Flag FROM WRBHBAdjustmentCategories WHERE Id=@Id
 END
END