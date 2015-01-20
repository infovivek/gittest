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
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE C.IsActive=1 AND C.IsDeleted=0 AND  P.Category IN('Internal Property','Managed G H')
		AND PU.UserId=@PropertyId
		ORDER BY P.PropertyName ASC
 END
 IF @Action='KOTDETAILS'
 
 BEGIN
 
	    CREATE TABLE  #Guest(ConsumerType NVARCHAR(100),Name NVARCHAR(100),ServiceItem NVARCHAR(100),
	    Quantity INT,Revenue DECIMAL(27,2),ClientId INt,ChkInId INT,Flag INT)
	    --Details for Property and Date 
	  	CREATE TABLE #Final(ServiceItem NVARCHAR(100),Quantity INT,Amount DECIMAL(27,2),Date NVARCHAR(100),
		Id INT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))

		CREATE TABLE #Id (ClientId BIGINT,BookingId BIGINT,PropertyId INT,
		GuestId INT,ChkInId INT,RoomId INT,ApartmentId INT,BedId INT,BookLevel NVARCHAR(100),
		SSPID INT,IDE bigint NOt null primary Key Identity(1,1))
				
		INSERT INTO #Id(ClientId,BookingId,PropertyId,GuestId,ChkInId,RoomId,ApartmentId,BedId,BookLevel,SSPID)
		SELECT CH.ClientId,D.BookingId,D.PropertyId,CH.GuestId,CH.Id,CH.RoomId,CH.ApartmentId,
		Ch.BedId,CH.Type,BP.SSPId
		FROM WRBHBKOTDtls D
		JOIN WRBHBCheckInHdr CH ON D.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		JOIN WRBHBBookingPropertyAssingedGuest BP ON D.BookingId=BP.BookingId AND BP.IsActive=1
		WHERE D.PropertyId=@PropertyId AND 
		CONVERT(date,D.HdrDate,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)   
		AND D.IsActive=1 AND D.IsDeleted=0
		
		
		CREATE TABLE #SERVICRAMOUNT(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100),ClientId INT,PropertyId INT)
		
		CREATE TABLE #SERVICRAMOUNTFinal(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100),BookinId INT)
		
	 	 	
		 	INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,
		 	Type,ClientId,PropertyId)
			
			SELECT DISTINCT S.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'SSP',
			G.ClientId,D.PropertyId
			FROM dbo.WRBHBSSPCodeGeneration G			
			JOIN dbo.WRBHBSSPCodeGenerationServices S WITH(NOLOCK) ON S.SSPCodeGenerationId=G.Id AND S.IsActive=1
			AND S.IsDeleted=0
			JOIN #Id D ON G.ClientId=D.ClientId AND G.PropertyId=D.PropertyId
			WHERE  G.PropertyId=@PropertyId AND S.TypeService ='Food And Beverages' AND G.IsActive=1 AND G.IsDeleted=0
		 
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,
			Type,ClientId,PropertyId)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Room',
			H.ClientId,D.PropertyId
			FROM dbo.WRBHBContractManagement H
			JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId 
			AND CM.IsActive=1 AND CM.IsDeleted=0
			JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
			JOIN #Id D ON H.ClientId =D.ClientId AND CM.PropertyId=D.PropertyId
			WHERE CM.PropertyId=@PropertyId AND H.IsActive=1 AND H.IsDeleted=0 AND CS.TypeService ='Food And Beverages'
		
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,
			Type,ClientId,PropertyId)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Bed',
			H.ClientId,D.PropertyId
			FROM dbo.WRBHBContractManagement H
			JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId 
			AND CM.IsActive=1 AND CM.IsDeleted=0
			JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
			JOIN #Id D ON H.ClientId =D.ClientId AND CM.PropertyId=D.PropertyId
			WHERE CM.PropertyId=@PropertyId  AND H.IsActive=1 AND H.IsDeleted=0 AND CS.TypeService ='Food And Beverages'
		
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,
			Type,ClientId,PropertyId)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Apartment',
			H.ClientId,D.ChkInId
			FROM dbo.WRBHBContractManagement H
			JOIN WRBHBContractManagementAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId 
			AND CM.IsActive=1 AND CM.IsDeleted=0
			JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
			JOIN #Id D ON H.ClientId =D.ClientId AND CM.PropertyId=D.PropertyId
			WHERE CM.PropertyId=@PropertyId  AND  H.IsActive=1 AND H.IsDeleted=0 AND CS.TypeService ='Food And Beverages'						
		
		
		
		--NON-DEDICATED
		INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,
		Type,ClientId,PropertyId)
		SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'NonDedicatedContract',
		C.ClientId,D.PropertyId
		FROM WRBHBContractNonDedicated C
		JOIN WRBHBContractNonDedicatedApartment CM ON  CM.NondedContractId = C.Id 
		AND CM.IsActive=1 AND CM.IsDeleted=0 
	    JOIN WRBHBContractNonDedicatedServices CS ON C.Id=CS.NondedContractId AND CS.IsActive=1 
	    AND CS.IsDeleted=0
	    JOIN #Id D ON C.ClientId=D.ClientId AND CM.PropertyId=D.PropertyId
	    WHERE CM.PropertyId=@PropertyId  AND C.IsActive=1 AND C.IsDeleted=0 AND CS.TypeService ='Food And Beverages'
		    
		UPDATE #SERVICRAMOUNT SET Price=0 
		WHERE Complimentary=1
		
		DELETE #Id  FROM  #Id C 
		JOIN  #SERVICRAMOUNT S ON C.ClientId=S.ClientId
						
		DECLARE @cnt INT, @ClientId BIGINT,@PrptyId BIGINT;
		SET @cnt=(SELECT COUNT(*) from  #Id)
		
		SELECT TOP 1 @ClientId=ClientId,@PrptyId=PropertyId FROM #Id
		WHILE @cnt>0
		BEGIN
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type,
			ClientId,PropertyId)
			SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,Id,TypeService,'ProductMaster',@ClientId,@PrptyId
			FROM WRBHBContarctProductMaster
			WHERE IsActive=1 AND IsDeleted=0 AND TypeService ='Food And Beverages'
			
			Delete #Id where @ClientId=ClientId;
			
			Select Top 1 @ClientId=ClientId,@PrptyId=PropertyId from #Id
			Set @cnt=(Select COUNT(*) from  #Id)
		END 
		 
	 
				
	IF(@Str3 ='Guest')
	BEGIN
	    INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,0,KH.CheckInId,0
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Amount,KH.CheckInId,KD.Quantity
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Breakfast' AS ServiceItem,
		SUM(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Breakfast (Non-Veg)' AS ServiceItem,
		SUM(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Lunch (Veg)' AS ServiceItem,
		SUM(KD.LunchVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Lunch (Non-Veg)' AS ServiceItem,
		SUM(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Dinner (Veg)' AS ServiceItem,
		SUM(KD.DinnerVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Dinner (Non-Veg)' AS ServiceItem,
		SUM(KD.DinnerNonVeg) AS Quantity,0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.CheckInId,CH.ClientId
		
		
			
	END
 	IF(@Str3 ='Staff')
	BEGIN
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
		
		SELECT 'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue,0,0,2
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue,0,0,2
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Breakfast'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Non-Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Dinner (Veg)'
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue,0,0,2
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
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
		
		SELECT 'Guest' AS ConsumerType,KH.GuestName,ServiceItem,(KD.Quantity) AS Quantity,
		CAST(KD.Amount AS DECIMAL(27,2)) AS Revenue,0,KH.CheckInId,0
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.GuestName,KD.Quantity,KD.Amount,KH.CheckInId

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Breakfast' AS ServiceItem,
		SUM(KD.BreakfastVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastVeg !=0  
		group by KD.GuestName,KD.BreakfastVeg,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Breakfast (Non-Veg)' AS ServiceItem,
		SUM(KD.BreakfastNonVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.GuestName,KD.BreakfastNonVeg,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Lunch (Veg)' AS ServiceItem,
		SUM(KD.LunchVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.GuestName,KD.LunchVeg,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Lunch (Non-Veg)' AS ServiceItem,
		SUM(KD.LunchNonVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg,CH.ClientId,KD.CheckInId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Dinner (Veg)' AS ServiceItem,
		SUM(KD.DinnerVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg,KD.CheckInId,CH.ClientId
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Guest' AS ConsumerType,KD.GuestName,'Dinner (Non-Veg)' AS ServiceItem,
		SUM(KD.DinnerNonVeg) AS Quantity,
		0 AS Revenue,CH.ClientId,KD.CheckInId,1
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KD.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KD.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) 
		AND KD.DinnerNonVeg !=0  
		group by KD.GuestName,KD.LunchNonVeg,KD.CheckInId,CH.ClientId

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
		
		SELECT  'Staff' AS ConsumerType,KH.UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue,0,0,2
		FROM WRBHBNewKOTUserEntryHdr KH
		JOIN WRBHBNewKOTUserEntryDtl KD  ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND   CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KH.UserName,KD.Quantity,KD.Price

		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT  'Staff' AS ConsumerType,'Outsource' AS UserName,ServiceItem,(KD.Quantity) AS Quantity,
		(0)*(KD.Quantity) AS Revenue,0,0,2
		FROM WRBHBOutsourceKOTHdr KH
		JOIN WRBHBOutsourceKOTDtl KD  ON KH.Id=KD.OutsourceKOTHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		WHERE KH.IsActive=1 AND KH.IsDeleted=0 AND
		KH.PropertyId=@PropertyId 
		AND  CONVERT(NVARCHAR,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103)  
		group by ServiceItem,KD.Quantity,KD.Price

	
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastVeg' AS ServiceItem,
		(KD.BreakfastVeg) AS Quantity,
		(KD.BreakfastVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId  AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) 
		AND KD.BreakfastVeg !=0  
		group by KD.UserName,KD.BreakfastVeg,CP.PerQuantityprice

		
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'BreakfastNonVeg' AS ServiceItem,
		(KD.BreakfastNonVeg) AS Quantity,
		(KD.BreakfastNonVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Breakfast'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.BreakfastNonVeg !=0  
		group by KD.UserName,KD.BreakfastNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchVeg' AS ServiceItem,
		(KD.LunchVeg) AS Quantity,
		(KD.LunchVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchVeg !=0  
		group by KD.UserName,KD.LunchVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'LunchNonVeg' AS ServiceItem,
		(KD.LunchNonVeg) AS Quantity,
		(KD.LunchNonVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Lunch (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.LunchNonVeg !=0  
		group by KD.UserName,KD.LunchNonVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerVeg' AS ServiceItem,
		(KD.DinnerVeg) AS Quantity,
		(KD.DinnerVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerVeg !=0  
		group by KD.UserName,KD.DinnerVeg,CP.PerQuantityprice
		
		INSERT INTO #Guest(ConsumerType,Name,ServiceItem,Quantity,Revenue,ClientId,ChkInId,Flag)
	    
		SELECT 'Staff' AS ConsumerType,KD.UserName,'DinnerNonVeg' AS ServiceItem,
		(KD.DinnerNonVeg) AS Quantity,
		(KD.DinnerNonVeg)*(0) AS Revenue,0,0,2
		FROM WRBHBKOTUser KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBMapVendor MP ON KH.PropertyId=MP.PropertyId AND MP.IsActive=1 AND MP.IsDeleted=0
		JOIN WRBHBVendorCost VC ON MP.VendorId=VC.VendorId AND VC.IsActive=1 AND VC.IsDeleted=0
		JOIN WRBHBContarctProductMaster CP ON VC.ItemId=Cp.Id AND CP.IsActive=1 AND CP.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId AND CP.ProductName='Dinner (Non-Veg)'
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(Date,@Str1,103) AND  CONVERT(Date,@Str2,103) AND KD.DinnerNonVeg !=0  
		group by KD.UserName,KD.DinnerNonVeg,CP.PerQuantityprice
	
		 
	 END
		
		
		CREATE TABLE #FinaR(ConsumerType NVARCHAR(100),Name NVARCHAR(100),ServiceItem NVARCHAR(100),
	    Quantity INT,Price DECIMAL(27,2),Revenue DECIMAL(27,2))
	    
	    INSERT INTO #FinaR(ConsumerType,Name,ServiceItem,Quantity,Price,Revenue)
	    
	 	SELECT ConsumerType,Name,ServiceItem,SUM(Quantity) AS Quantity,(SUM(Revenue)/SUM(Quantity)) AS Price,
		SUM(Revenue) AS Revenue
		FROM #Guest 
		WHERE Flag=0
		GROUP BY  ConsumerType,Name,ServiceItem
		
		
		INSERT INTO #FinaR(ConsumerType,Name,ServiceItem,Quantity,Price,Revenue)
	    
	 	SELECT DISTINCT G.ConsumerType,Name,G.ServiceItem,(Quantity) AS Quantity,Price,
		F.Price*(G.Quantity) AS  Revenue
		FROM #Guest G
		JOIN #SERVICRAMOUNT F ON  F.ClientId =G.ClientId AND F.ServiceName=G.ServiceItem
		WHERE G.Flag=1
		
		
		INSERT INTO #FinaR(ConsumerType,Name,ServiceItem,Quantity,Price,Revenue)
	    
	 	SELECT ConsumerType,Name,ServiceItem,SUM(Quantity) AS Quantity,0,
		SUM(Quantity)*(0)AS Revenue
		FROM #Guest 
		WHERE ConsumerType IN('Staff')
		GROUP BY ConsumerType,Name,ServiceItem
		 
		 
		SELECT ConsumerType,Name,ServiceItem,Quantity,Price,Revenue 
		FROM #FinaR
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
   