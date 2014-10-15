 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_VendorCost_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  [Sp_VendorCost_Help]
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
CREATE PROCEDURE [Sp_VendorCost_Help]
(@Action NVARCHAR(100),
@Id   bigint,
@Str  NVARCHAR(100),
@Str1  NVARCHAR(100))
AS
BEGIN
  IF @Action='PageLoad'
  BEGIN
	   SELECT VendorName,Id FROM WRBHBVendor WHERE IsActive=1 AND VendorCategory='Food'; 
  END
  
  IF @Action='Serviceload'
  BEGIN  
      DECLARE @Id1 int
      SET @Id1=(SELECT DISTINCT VendorId FROM WRBHBVendorCost WHERE VendorId=@Id)
       
	  IF(@Id1 !=0)
	  BEGIN
			SELECT DISTINCT ISNULL(CONVERT(NVARCHAR(100),EffectiveFrom,103),'') AS EffectiveFrom
			FROM WRBHBVendorCost
			WHERE IsActive=1 AND IsDeleted=0 AND VendorId=@Id
			
			SELECT DISTINCT ProductName AS ServiceItem,ItemId,Cost,Id,Flag 
			FROM WRBHBVendorCost
			WHERE IsActive=1 AND IsDeleted=0 AND VendorId=@Id
		    
			--History
		   
			SELECT DISTINCT ISNULL(CONVERT(NVARCHAR(100),EffectiveFrom,103),'') AS EffectiveFrom,
			ISNULL(CONVERT(NVARCHAR(100),EffectiveTo,103),'') AS EffectiveTo,'History' AS History 
			FROM WRBHBVendorCost 
			WHERE  VendorId=@Id;
	    
	  END
	  ELSE
	  BEGIN
	   
	       SELECT CONVERT(Nvarchar(100),GETDATE(),103) AS EffectiveFrom
		   
		   CREATE TABLE #Product(ServiceItem NVARCHAR(100),ItemId INT,Cost DECIMAL(27,2),Id INT,Flag INT)
		   
		   INSERT INTO #Product(ServiceItem,ItemId,Cost,Id,Flag)
		   SELECT ProductName AS ServiceItem,Id AS ItemId,0 As Cost,0 AS Id,0 AS Flag 
		   FROM WRBHBContarctProductMaster
		   WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages';
		   
		  
		   INSERT INTO #Product(ServiceItem,ItemId,Cost,Id,Flag)
		   SELECT ServiceItem,ItemId,0 As Cost,0 AS Id,1 AS Flag 
		   FROM WRBHBOutsourceServiceItems
		   WHERE IsActive=1 AND IsDeleted=0	   
		   	   
		   SELECT ServiceItem,ItemId,Cost,Id,Flag FROM #Product
		   
		   SELECT ISNULL(CONVERT(NVARCHAR(100),EffectiveFrom,103),'') AS EffectiveFrom,
		   ISNULL(CONVERT(NVARCHAR(100),EffectiveTo,103),'') AS EffectiveTo,'History' AS History 
		   FROM WRBHBVendorCost 
		   WHERE VendorId=@Id group by EffectiveFrom,EffectiveTo;
	  END 
      END
IF @Action='History1'
      BEGIN   
	  IF(ISNULL(@Id,0) !=0)
	  BEGIN
	    SELECT DISTINCT ProductName AS ServiceItem,ItemId,Cost,Id 
	    FROM WRBHBVendorCost
	    WHERE IsActive=1 AND IsDeleted=0 AND VendorId=@Id
	    AND EffectiveFrom=CONVERT(date,@Str,103) 
	 END
	 END
IF @Action='History'
      BEGIN   
	  IF(ISNULL(@Id,0) !=0)
	  BEGIN
	    SELECT DISTINCT ProductName AS ServiceItem,ItemId,Cost,Id 
	    FROM WRBHBVendorCost
	    WHERE IsActive=0 AND IsDeleted=1 AND VendorId=@Id
	    AND EffectiveFrom=CONVERT(date,@Str,103) AND EffectiveTo=CONVERT(date,@Str1,103)
	 END
	 ELSE
	 BEGIN
	 
	   CREATE TABLE #Product1(ServiceItem NVARCHAR(100),ItemId INT,Cost DECIMAL(27,2),Id INT,Flag INT)
	   
	   INSERT INTO #Product(ServiceItem,ItemId,Cost,Id,Flag)
	   SELECT ProductName AS ServiceItem,Id AS ItemId,0 As Cost,0 AS Id,0 AS Flag 
	   FROM WRBHBContarctProductMaster
	   WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages';
	   
	   INSERT INTO #Product(ServiceItem,ItemId,Cost,Id,Flag)
	   SELECT ServiceItem,ItemId,0 As Cost,0 AS Id,1 AS Flag 
	   FROM WRBHBOutsourceServiceItems
	   WHERE IsActive=1 AND IsDeleted=0	   
	   	   
	   SELECT ServiceItem,ItemId,Cost,Id,Flag FROM #Product1
	 END
  END
 END
 
 
 

 
 
