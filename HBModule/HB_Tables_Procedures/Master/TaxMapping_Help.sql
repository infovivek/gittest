SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TaxMapping_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_TaxMapping_Help

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (07/10/2014)  >
Section  	: TaxMapping
Purpose  	: TaxMapping
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

CREATE PROCEDURE Sp_TaxMapping_Help
(
@Action		NVARCHAR(100),
@Str        NVARCHAR(100), 
@Id			BIGINT,
@UserId		Int)
AS 
BEGIN
	IF @Action='PAGELOAD'
	BEGIN
		SELECT DISTINCT P.PropertyName AS Property,P.Id AS PropertyId
		FROM WRBHBPropertyUsers PU
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.UserId=@UserId AND P.Category IN('Internal Property','Managed G H') 
	END
	IF @Action='Property'
		BEGIN
		DECLARE @PId Int;
				
				SET @PId=(SELECT DISTINCT PropertyId FROM WRBHBTaxMapping WHERE PropertyId=@Id 
				AND IsActive=1 AND IsDeleted=0)
		  
		  IF ISNULL(@PId,0) !=0
		  BEGIN
				SELECT ServiceItem,ItemId,VAT,LuxuryTax,ST1,
				ST2,ST3,Service,Id 
				FROM WRBHBTaxMapping
				WHERE PropertyId=@Id AND IsActive=1 AND IsDeleted=0
		  END
		  ELSE
		  BEGIN      
				SELECT DISTINCT TypeService AS ServiceItem,0 AS ItemId,0 AS VAT,0 AS LuxuryTax,0 AS ST1,
				0 AS ST2,0 AS ST3,'Service' As Service,0 AS Id 
				FROM WRBHBContarctProductMaster
				WHERE IsActive=1 AND IsDeleted=0
		  END
		END
END