SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewSnackKOTEntryReport_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewSnackKOTEntryReport_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (20/06/2014)  >
Section  	: SP_NewSnackKOTEntryReport Help
Purpose  	: SP_NewSnackKOTEntryReport Help
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

CREATE PROCEDURE dbo.[SP_NewSnackKOTEntryReport_Help]
(
@Action NVARCHAR(100),
@PropertyId		BIGINT,
@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100),
@Str3 NVARCHAR(100))
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	   --Property
		SELECT DISTINCT P.PropertyName AS Property,P.Id AS PropertyId
		FROM WRBHBCheckInHdr C
		JOIN WRBHBProperty  P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE C.IsActive=1 AND C.IsDeleted=0 AND  P.Category IN('Internal Property','Managed G H')
 END
 IF @Action='KOTDETAILS'
 
 BEGIN
	    CREATE TABLE  #Guest(ConsumerType NVARCHAR(100),Name NVARCHAR(100),ServiceItem NVARCHAR(100),
	    Quantity INT,Revenue DECIMAL(27,2))
	    --Details for Property and Date 
	    CREATE TABLE #Id(ChkInId INT,GuestId INT,RoomId INT,BedId INT,ApartmentId INT,ClientId INT,
	    BookingId INT,BookLevel NVARCHAR(100))
	    INSERT INTO #Id(ChkInId,GuestId,RoomId,BedId,ApartmentId,ClientId,BookingId,BookLevel)
	    SELECT Id AS ChkInId,GuestId,RoomId,BedId,ApartmentId,ClientId,BookingId,Type
	    FROM WRBHBCheckInHdr 
	    WHERE PropertyId=@PropertyId
	    
	    CREATE TABLE #Contract(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ChkInnId INT,GuesId INT,ProductId INT)
		
		CREATE TABLE #ContractFinal(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ChkInnId INT,GuesId INT,ProductId INT)
	    
        INSERT INTO #Contract(Id,Complimentary,ServiceName,Price,Enable,ChkInnId,GuesId,ProductId)
	    SELECT CS.Id,Complimentary,ServiceName,Price,Enable,D.ChkInId,D.GuestId,ProductId
	    FROM dbo.WRBHBContractManagement H
	    JOIN #Id D ON H.BookingLevel=D.BookLevel AND H.ClientId=D.ClientId
	    JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=D.RoomId
	    AND CM.IsActive=1 AND CM.IsDeleted=0
	    JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
	    WHERE  H.IsActive=1 AND H.IsDeleted=0 AND D.BookLevel='Room' 
	    
         INSERT INTO #Contract(Id,Complimentary,ServiceName,Price,Enable,ChkInnId,GuesId,ProductId)
		 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,D.ChkInId,D.GuestId,ProductId
		 FROM dbo.WRBHBContractManagement H
		 JOIN #Id D ON H.BookingLevel=D.BookLevel AND H.ClientId=D.ClientId
		 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=D.RoomId
		 AND CM.IsActive=1 AND CM.IsDeleted=0
		 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
		 WHERE   H.IsActive=1 AND H.IsDeleted=0 AND D.BookLevel='Bed'
		 
		 INSERT INTO #Contract(Id,Complimentary,ServiceName,Price,Enable,ChkInnId,GuesId,ProductId)
		 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,D.ChkInId,D.GuestId,ProductId
		 FROM dbo.WRBHBContractManagement H
		  JOIN #Id D ON H.BookingLevel=D.BookLevel AND H.ClientId=D.ClientId
		 JOIN WRBHBContractManagementAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.ApartmentId=D.ApartmentId
		 AND CM.IsActive=1 AND CM.IsDeleted=0
		 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
		 WHERE  D.BookLevel='Apartment' AND H.IsActive=1 AND H.IsDeleted=0	
		 
		  INSERT INTO #Contract(Id,Complimentary,ServiceName,Price,Enable,ChkInnId,GuesId,ProductId)
		  SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,D.ChkInId,D.GuestId,ProductId
		  FROM WRBHBContractNonDedicated C
		  JOIN #Id D ON C.ClientId=D.ClientId
		  JOIN WRBHBContractNonDedicatedApartment CM ON @PropertyId=CM.PropertyId AND CM.NondedContractId = C.Id AND CM.IsActive=1 AND CM.IsDeleted=0 
	      JOIN WRBHBContractNonDedicatedServices CS ON C.Id=CS.NondedContractId AND CS.IsActive=1 AND CS.IsDeleted=0
	      WHERE C.IsActive=1 AND C.IsDeleted=0	
	      
	     UPDATE #Contract SET Price=0 
		 WHERE Complimentary=1
		 
		INSERT INTO #ContractFinal(Id,Complimentary,ServiceName,Price,Enable,ChkInnId,GuesId,ProductId)
		SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,0,0,Id
		FROM WRBHBContarctProductMaster 
		WHERE IsActive=1 AND IsDeleted=0
		
		UPDATE #ContractFinal SET Price=S.Price
		FROM  #ContractFinal O
		JOIN #Contract S ON O.ProductId=S.ProductId
				
	IF(@Str3 ='Guest')
	BEGIN
	    INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Quantity,KD.Amount
		
			
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.BreakfastVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.BreakfastNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.LunchVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.DinnerVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.DinnerNonVeg
			
	END
 	IF(@Str3 ='Staff')
	BEGIN
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT 'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Non-Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Dinner (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Non-Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.UserName,KD.DinnerNonVeg,CP.PerQuantityprice
		
	END
	IF(@Str3 ='ALL')
	BEGIN
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Quantity,KD.Amount

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.BreakfastVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.BreakfastNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.LunchVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.DinnerVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.DinnerNonVeg

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT  'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND   CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT  'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND  CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price

	
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) 
		AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice

		
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.UserName,KD.DinnerNonVeg,CP.PerQuantityprice
	
		 
	 END
		SELECT  ConsumerType,Name,ServiceItem,SUM(Quantity) AS Quantity,SUM(Revenue) AS Revenue
		FROM #Guest G
		LEFT OUTER JOIN #ContractFinal F ON G.ServiceItem=F.ServiceName
		group by ConsumerType,Name,ServiceItem
		
	 
 END
 IF @Action='NewKOTDETAILS'
 BEGIN
	    CREATE TABLE  #Guests(ConsumerType NVARCHAR(100),Name NVARCHAR(100),ServiceItem NVARCHAR(100),
	    Quantity INT,Revenue DECIMAL(27,2))
	    --Details for Property and Date 
	IF(@Str3 ='Guest')
	BEGIN
	    INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Quantity,KD.Amount
		
			
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.BreakfastVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.BreakfastNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.LunchVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.DinnerVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.DinnerNonVeg
			
	END
 	IF(@Str3 ='Staff')
	BEGIN
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT 'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Lunch (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Lunch (Non-Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Dinner (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Dinner (Non-Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.UserName,KD.DinnerNonVeg,CP.PerQuantityprice
		
	END
	IF(@Str3 ='ALL')
	BEGIN
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Quantity,KD.Amount

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.BreakfastVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.BreakfastNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.LunchVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.DinnerVeg
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		0 AS Revenue
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.DinnerNonVeg

		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
		
		SELECT  'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND   CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price

		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT  'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 
		AND  CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price

	
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) 
		AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice

		
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Lunch (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Lunch (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guests(ConsumerType,Name,ServiceItem,Quantity,Revenue)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND CP.ProductName='Dinner (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.UserName,KD.DinnerNonVeg,CP.PerQuantityprice
	
		 
	 END
		SELECT  ConsumerType,Name,ServiceItem,SUM(Quantity) AS Quantity,SUM(Revenue) AS Revenue
		FROM #Guests group by ConsumerType,Name,ServiceItem
END
 
END
   