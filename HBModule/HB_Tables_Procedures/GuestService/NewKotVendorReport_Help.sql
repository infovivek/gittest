 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_KOTVendorReport_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  [Sp_KOTVendorReport_Help]
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
CREATE PROCEDURE [Sp_KOTVendorReport_Help]
(@Action NVARCHAR(100),
@VendorId   bigint,
@PropertyId   bigint,
@Str  NVARCHAR(100),
@Str1  NVARCHAR(100))
AS
BEGIN
  IF @Action='PageLoad'
  BEGIN
	   SELECT VendorName,Id FROM WRBHBVendor 
	   WHERE IsActive=1 AND VendorCategory='Food'; 
  END
  
  IF @Action='PropertyLoad'
  BEGIN   
	   SELECT Property,PropertyId    FROM WRBHBMapVendor 
	   WHERE IsActive=1 AND IsDeleted=0 AND VendorId=@VendorId;
  END
  IF @Action='Serviceload'
  BEGIN 
		
		CREATE TABLE #Cost(ServiceItem NVARCHAR(100),ItemId INT,Quantity INT,Cost DECIMAL(27,2),
		Price DECIMAL(27,2),Revenue DECIMAL(27,2),Flag INT) 
		
		INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT DISTINCT KD.ServiceItem,KD.ItemId,SUM(KD.Quantity),VC.Cost,CAST((KD.Amount/KD.Quantity)AS DECIMAL(27,2)) AS Price,
	    CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTEntryDtl KD ON vc.ItemId=KD.ItemId AND KH.Id=KD.NewKOTEntryHdrId  AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Amount ,KD.Quantity,KD.Price
	    
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT  'Breakfast - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Breakfast - Outsourced Staff' AND KD.ServiceItem='Breakfast - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Lunch - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Lunch - Outsourced Staff' AND KD.ServiceItem='Lunch - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	     
	     INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Dinner - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Dinner - Outsourced Staff' AND KD.ServiceItem='Dinner - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	     
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Tea/Coffee - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Tea/Coffee - Outsourced Staff' AND KD.ServiceItem='Tea/Coffee - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   	   
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT DISTINCT KD.ServiceItem+'-'+'Staff',KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBNewKOTUserEntryDtl KD ON vc.ItemId=KD.ItemId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryHdr KH ON KD.NewKOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN  CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Price ,KD.Quantity
	     
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastNonVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	   (KD.LunchVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	   
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchNonVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	  
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerNonVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	   
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	  
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	   
	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT  'DinnerVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	   (KD.DinnerVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    	    
	    INSERT INTO #Cost(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	   
	    SELECT ServiceItem,SUM(Quantity) AS Quantity,Cost,SUM(Quantity)*Cost AS Total,
	    SUM(Revenue) AS Revenue FROM #Cost
	    group by ServiceItem,ItemId,Cost,Flag	
	    Order by Flag ASC  
	   
	  
	    CREATE TABLE #Final1(ServiceItem NVARCHAR(100),ItemId NVARCHAR(100),Quantity DECIMAL(27,0),
	    VendorRate DECIMAL(27,2),TotalCost DECIMAL(27,2),Revenue DECIMAL(27,2),Flag int) 
		
	    INSERT INTO #Final1(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT 'Total' AS ServiceItem,'' AS ItemId,SUM(Quantity) AS Quantity,SUM(Cost) AS Cost,
	    Quantity*Cost AS Total,
	    SUM(Revenue) AS Revenue,3 FROM #Cost
	    group by Quantity,Cost
	    
	    
	    
	    CREATE TABLE #Final(ServiceItem NVARCHAR(100),ItemId NVARCHAR(100),Quantity NVARCHAR(100),VendorRate NVARCHAR(100),
		TotalCost NVARCHAR(100),Revenue NVARCHAR(100),Flag int) 
	    
	    INSERT INTO #Final(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	   
	    SELECT ServiceItem,ItemId,SUM(Quantity) AS Quantity,Cost,SUM(Quantity)*Cost AS Total,
	    SUM(Revenue) AS Revenue,1 FROM #Cost
	    group by ServiceItem,ItemId,Cost,Flag
	    ORDER BY Flag ASC
	     
	    INSERT INTO #Final(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT '' AS ServiceItem,'' AS ItemId,'' AS Quantity,'' AS Cost,'' AS Total,
	    '' AS Revenue,2 
	
	    INSERT INTO #Final(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT 'Total' AS ServiceItem,'' AS ItemId,SUM(Quantity) AS Quantity,SUM(VendorRate) AS Cost,
	    SUM(TotalCost) AS Total,SUM(Revenue) AS Revenue,3 FROM #Final1
	   
	   	     
	    SELECT ServiceItem,Quantity,VendorRate,TotalCost,Revenue 
	    FROM #Final
		
	    
	  END 
  IF @Action='NewServiceload'
  BEGIN 
		
		CREATE TABLE #Costs(ServiceItem NVARCHAR(100),ItemId INT,Quantity INT,Cost DECIMAL(27,2),
		Price DECIMAL(27,2),Revenue DECIMAL(27,2),Flag INT) 
		
		INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT DISTINCT KD.ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,CAST((KD.Amount/KD.Quantity)AS DECIMAL(27,2)) AS Price,
	    CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTEntryDtl KD ON vc.ItemId=KD.ItemId AND KH.Id=KD.NewKOTEntryHdrId  AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Amount ,KD.Quantity,KD.Price
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT  'Breakfast - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Breakfast - Outsourced Staff' AND KD.ServiceItem='Breakfast - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   
	    
	     INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Lunch - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Lunch - Outsourced Staff' AND KD.ServiceItem='Lunch - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	     
	     INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Dinner - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Dinner - Outsourced Staff' AND KD.ServiceItem='Dinner - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	     
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'Tea/Coffee - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Tea/Coffee - Outsourced Staff' AND KD.ServiceItem='Tea/Coffee - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   	   
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT DISTINCT KD.ServiceItem+'-'+'Staff',KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryDtl KD ON vc.ItemId=KD.ItemId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN  CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Price ,KD.Quantity
	     
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	   (KD.BreakfastVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastNonVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	   
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchNonVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	  
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerNonVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	   
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'BreakfastNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	  
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'LunchNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	   
	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT  'DinnerVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    	    
	    INSERT INTO #Costs(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		
		SELECT 'DinnerNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	   
	    
	    SELECT ServiceItem,SUM(Quantity) AS Quantity,Cost,SUM(Quantity)*Cost AS Total,
	    SUM(Revenue) AS Revenue FROM #Costs
	    group by ServiceItem,ItemId,Cost,Flag	
	    Order by Flag ASC  
	   
		CREATE TABLE #Final2(ServiceItem NVARCHAR(100),ItemId NVARCHAR(100),Quantity DECIMAL(27,0),
	    VendorRate DECIMAL(27,2),TotalCost DECIMAL(27,2),Revenue DECIMAL(27,2),Flag int) 
		
	    INSERT INTO #Final2(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT 'Total' AS ServiceItem,'' AS ItemId,SUM(Quantity) AS Quantity,SUM(Cost) AS Cost,
	    Quantity*Cost AS Total,
	    SUM(Revenue) AS Revenue,3 FROM #Costs
	    group by Quantity,Cost
		
		CREATE TABLE #Finals(ServiceItem NVARCHAR(100),ItemId NVARCHAR(100),Quantity NVARCHAR(100),VendorRate NVARCHAR(100),
		TotalCost NVARCHAR(100),Revenue NVARCHAR(100),Flag int) 
	    
	    INSERT INTO #Finals(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT ServiceItem,ItemId,SUM(Quantity) AS Quantity,Cost,SUM(Quantity)*Cost AS Total,
	    SUM(Revenue) AS Revenue,1 FROM #Costs
	    group by ServiceItem,ItemId,Cost,Flag
	    ORDER BY Flag ASC
	    
	    INSERT INTO #Finals(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT '' AS ServiceItem,'' AS ItemId,'' AS Quantity,'' AS Cost,'' AS Total,
	    '' AS Revenue,2 
	    
	    INSERT INTO #Finals(ServiceItem,ItemId,Quantity,VendorRate,TotalCost,Revenue,Flag)
	    SELECT 'Total' AS ServiceItem,'' AS ItemId,SUM(Quantity) AS Quantity,SUM(Cost) AS Cost,
	    SUM(TotalCost) AS Total,SUM(Revenue) AS Revenue,3 FROM #Final2
	    
	   	    
	    
	    SELECT ServiceItem,Quantity,VendorRate,TotalCost,Revenue FROM #Finals
	   
	    
	  END 
 IF @Action='Print'
	 BEGIN 
	 DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@VendorName NVARCHAR(100),@PropertyName NVARCHAR(100);
	 IF(@PropertyId !=0)
	 BEGIN
	  
		CREATE TABLE #Costp(ServiceItem NVARCHAR(100),ItemId INT,Quantity INT,Cost DECIMAL(27,2),
		Price DECIMAL(27,2),Revenue DECIMAL(27,2),Flag INT) 
		
		 INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT DISTINCT KD.ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,CAST((KD.Amount/KD.Quantity)AS DECIMAL(27,2)) AS Price,
	    CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,1 
	    --CONVERT(date,@Str,103) ,  CONVERT(date,@Str1,103)
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTEntryDtl KD ON vc.ItemId=KD.ItemId AND KH.Id=KD.NewKOTEntryHdrId  AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND  KH.Date  BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Amount ,KD.Quantity,KD.Price, Kh.Date
	   
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT  'Breakfast - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Breakfast - Outsourced Staff' AND KD.ServiceItem='Breakfast - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Lunch - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Lunch - Outsourced Staff' AND KD.ServiceItem='Lunch - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Dinner - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Dinner - Outsourced Staff' AND KD.ServiceItem='Dinner - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Tea/Coffee - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND VC.ProductName='Tea/Coffee - Outsourced Staff' AND KD.ServiceItem='Tea/Coffee - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   	
	   	INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT DISTINCT KD.ServiceItem+'-'+'Staff',KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryDtl KD ON vc.ItemId=KD.ItemId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN  CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Price ,KD.Quantity
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastNonVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchNonVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerNonVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KD.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT  'DinnerVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    
	    INSERT INTO #Costp(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	   (KD.DinnerNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId and KH.PropertyId=@PropertyId
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	   
	    
		SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
		SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
		SET @VendorName=(SELECT VendorName FROM WRBHBVendor WHERE Id=@VendorId)
		SET @PropertyName=(SELECT PropertyName FROM WRBHBProperty WHERE Id=@PropertyId)
		
		
		SELECT ServiceItem AS Item,SUM(Quantity) AS Quantity,Cost AS Rate,SUM(Total) AS TotalAmount,
	    @VendorName AS ClientName,@PropertyName AS PropertyName,@Str AS ChkInDt,
	    @Str1 AS ChkOutDt,@CompanyName AS CompanyName,
	    @Address As CompanyAddress FROM #Costp
	    group by ServiceItem,ItemId,Cost,Flag	
	    Order by Flag ASC  
	    
	    
	 END 
	 ELSE
	 BEGIN 
		CREATE TABLE #Costss(ServiceItem NVARCHAR(100),ItemId INT,Quantity INT,Cost DECIMAL(27,2),
		Price DECIMAL(27,2),Revenue DECIMAL(27,2),Flag INT) 
		INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT DISTINCT KD.ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,CAST((KD.Amount/KD.Quantity)AS DECIMAL(27,2)) AS Price,
	    CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTEntryDtl KD ON vc.ItemId=KD.ItemId AND KH.Id=KD.NewKOTEntryHdrId  AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Amount ,KD.Quantity,KD.Price
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT  'Breakfast - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Breakfast - Outsourced Staff' AND KD.ServiceItem='Breakfast - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Lunch - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Lunch - Outsourced Staff' AND KD.ServiceItem='Lunch - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Dinner - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Dinner - Outsourced Staff' AND KD.ServiceItem='Dinner - Outsourced Staff'
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'Tea/Coffee - Outsourced Staff' AS ServiceItem,KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,3 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBOutsourceKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBOutsourceKOTDtl KD ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND VC.ProductName='Tea/Coffee - Outsourced Staff' AND KD.ServiceItem='Tea/Coffee - Outsourced Staff'
	    AND CONVERT(NVARCHAR(100),KH.Date,103) BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	   	INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT DISTINCT KD.ServiceItem+'-'+'Staff',KD.ItemId,(KD.Quantity),VC.Cost,KD.Price,
	    (KD.Quantity)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBNewKOTUserEntryDtl KD ON vc.ItemId=KD.ItemId AND KD.IsActive=1 AND KD.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND  VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN  CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    group by KD.ServiceItem,KD.ItemId,VC.Cost,KD.Price ,KD.Quantity
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastNonVeg' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchNonVeg' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerNonVeg' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(CP.PerQuantityprice) AS Revenue,1 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTDtls KD ON MP.PropertyId=KD.PropertyId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.BreakfastVeg !=0 AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast'
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'BreakfastNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.BreakfastNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.BreakfastNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND CP.ProductName='Breakfast' AND  VC.ProductName='Breakfast @ 100' AND KD.BreakfastNonVeg !=0
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchVeg !=0 AND CP.ProductName='Lunch (Veg)' AND  VC.ProductName='Lunch (Veg)'
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'LunchNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.LunchNonVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.LunchNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103)
	    AND KD.LunchNonVeg !=0 AND CP.ProductName='Lunch (Non-Veg)' AND  VC.ProductName='Lunch (Non-Veg)'
	   
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT  'DinnerVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerVeg),VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0 
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Veg)' AND  VC.ProductName='Dinner (Veg)' AND KD.DinnerVeg !=0
	    
	    INSERT INTO #Costss(ServiceItem,ItemId,Quantity,Cost,Price,Revenue,Flag)
		SELECT 'DinnerNonVeg'+'-'+'Staff' AS ServiceItem, 0 AS ItemId,(KD.DinnerNonVeg) AS Quantity,VC.Cost,CP.PerQuantityprice,
	    (KD.DinnerNonVeg)*(0) AS Revenue,2 
		FROM WRBHBVendorCost VC 
		JOIN WRBHBMapVendor MP ON VC.VendorId=MP.VendorId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBKOTHdr KH ON MP.PropertyId=KH.PropertyId AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBKOTUser KD ON KH.Id=KD.KOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
	    WHERE VC.IsActive=1 AND VC.IsDeleted=0 AND VC.VendorId=@VendorId 
	    AND KH.Date BETWEEN CONVERT(date,@Str,103) AND  CONVERT(date,@Str1,103) AND
	    CP.ProductName='Dinner (Non-Veg)' AND  VC.ProductName='Dinner (Non-Veg)' AND KD.DinnerNonVeg !=0
	    
	    SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
		SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
		SET @VendorName=(SELECT VendorName FROM WRBHBVendor WHERE Id=@VendorId)
		SET @PropertyName='All'
		
		
		SELECT ServiceItem AS Item,SUM(Quantity) AS Quantity,Cost AS Rate,SUM(Total) AS TotalAmount,
	    @VendorName AS ClientName,@PropertyName AS PropertyName,@Str AS ChkInDt,
	    @Str1 AS ChkOutDt,@CompanyName AS CompanyName,
	    @Address As CompanyAddress FROM #Costp
	    group by ServiceItem,ItemId,Cost,Flag	
	    Order by Flag ASC  
		
		
	  END
 END
 END
 
  