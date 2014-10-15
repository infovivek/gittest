SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TiaAndATia_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TiaAndATia_Select
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
CREATE PROCEDURE Sp_TiaAndATia_Select
(
@Id BIGINT,
@UserId BIGINT
)
AS
BEGIN
IF(@Id=0)
BEGIN
   SELECT P.PropertyName,O.FirstName,AdjustmentAmount,TT.Id FROM WRBHBTiaAndNTia TT  
   JOIN WRBHBProperty P ON TT.PropertyId=P.Id 
   JOIN WRBHBPropertyOwners O ON TT.OwnerId=O.Id
   WHERE TT.IsActive=1 AND TT.IsDeleted=0 
END

IF(@Id!=0)
BEGIN
	SELECT P.PropertyName PropertyName,TT.PropertyId PId,O.FirstName OwnerName,TT.OwnerId OId,
	AC.AdjustmentCategory,AC.Id AdjustmentCategoryId,AdjustmentAmount,CONVERT(NVARCHAR(100),AdjustmentMonth,105) as Date,Description Descr,AdjustmentType,TT.Id 
	FROM WRBHBTiaAndNTia TT  
   JOIN WRBHBProperty P ON TT.PropertyId=P.Id 
   JOIN WRBHBPropertyOwners O ON TT.OwnerId=O.Id
   JOIN WRBHBAdjustmentCategories AC ON TT.AdjustmentCategoryId=AC.Id
   WHERE TT.IsActive=1 AND TT.Id=@Id
   --GROUP BY PropertyName,FirstName
END
END

