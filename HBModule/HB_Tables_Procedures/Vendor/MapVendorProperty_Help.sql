 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_MapVendor_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  [Sp_MapVendor_Help]
GO 
/* 
Author Name : Anbu
Created On 	: <Created Date (01/07/2014)  >
Section  	: 
Purpose  	: 
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
CREATE PROCEDURE [Sp_MapVendor_Help]
(@Action NVARCHAR(100),
@Id bigint)
AS
BEGIN
  IF @Action='PageLoad'
  BEGIN
	   SELECT VendorName,Id FROM WRBHBVendor WHERE IsActive=1 AND VendorCategory='Food'; 
	   
      
	   SELECT 0 AS Process,PropertyName,Id AS PropertyId,0 AS Id   FROM WRBHBProperty 
	   WHERE IsActive=1 AND Category IN('Internal Property' ,'Managed G H');
	   
	END
  IF @Action='PropertyLoad'
  BEGIN
      CREATE TABLE #Vendor(Process bit,PropertyName NVARCHAR(100),PropertyId INT,Id INT)
       
      INSERT INTO #Vendor(Process,PropertyName,PropertyId,Id)
	  SELECT Process,Property,PropertyId,Id   FROM WRBHBMapVendor
	  WHERE IsActive=1 AND Process=1 AND VendorId=@Id;
	    
	  INSERT INTO #Vendor(Process,PropertyName,PropertyId,Id)
	  SELECT 0 AS Process,PropertyName,Id AS PropertyId,0 AS Id   FROM WRBHBProperty 
	  WHERE IsActive=1 AND Id NOT IN(SELECT PropertyId FROM #Vendor)
	  AND Category IN('Internal Property' ,'Managed G H');
	   
	  SELECT Process,PropertyName,PropertyId,Id FROM #Vendor
  END
 END