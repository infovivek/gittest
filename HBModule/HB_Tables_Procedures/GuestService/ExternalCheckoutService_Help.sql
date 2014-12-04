-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExternalCheckoutService_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ExternalCheckoutService_Help]
GO 
-- ===============================================================================
-- Author: Anbu
-- Create date:19-05-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Check Out Service
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_ExternalCheckoutService_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,

@CheckInHdrId INT=NULL,
@StateId INT,
@BillFrom NVARCHAR(100)=NULL,
@BillTo NVARCHAR(100)=NULL)
AS
BEGIN
IF @Action='ProductLoad'
BEGIN

		CREATE TABLE #Final(ServiceItem NVARCHAR(100),Quantity INT,Amount DECIMAL(27,2),Date NVARCHAR(100),
		Id INT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))

		DECLARE @ClientId BIGINT,@PropertyId BIGINT,@BookingId BIGINT,@BookingLevel NVARCHAR(100),
		@SSPID BIGINT,@RoomId BIGINT,@ApartmentId BIGINT,@Count INT; 
		
		SELECT @BookingId=BookingId,@PropertyId=PropertyId
		FROM WRBHBCheckInHdr WHERE Id= CAST(@Str1 AS BIGINT)
		AND IsActive=1 AND IsDeleted=0
		
		SELECT @ClientId=ClientId,@BookingLevel=BookingLevel FROM WRBHBBooking WHERE Id= @BookingId
		AND IsActive=1 AND IsDeleted=0

		CREATE TABLE #SERVICRAMOUNT(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))  
		
		CREATE TABLE #SERVICRAMOUNTFinal(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))
		
		IF @BookingLevel='Room'
		BEGIN
			SELECT @SSPID=SSPId,@RoomId=RoomId FROM WRBHBBookingPropertyAssingedGuest
			WHERE GuestId=@CheckInHdrId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Bed'
		BEGIN
			SELECT @SSPID=SSPId,@RoomId=RoomId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE GuestId=@CheckInHdrId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Apartment'
		BEGIN
			SELECT @SSPID=SSPId,@ApartmentId=ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE GuestId=@CheckInHdrId AND BookingId=@BookingId;		
			
		END 
		
		--SSP
		IF ISNULL(@SSPID,0)!=0
		BEGIN
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
			SELECT S.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'SSP'
			FROM dbo.WRBHBSSPCodeGeneration G			
			JOIN dbo.WRBHBSSPCodeGenerationServices S WITH(NOLOCK) ON S.SSPCodeGenerationId=G.Id AND S.IsActive=1
			AND S.IsDeleted=0
			WHERE G.Id=@SSPID -- AND G.IsActive=1 AND G.IsDeleted=0
			
		END 
		ELSE 
		BEGIN
		--DEDICATED AND MANAGED GH
			IF @BookingLevel='Room'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Room'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0	
			END
			IF @BookingLevel='Bed'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Bed'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0
			END
			IF @BookingLevel='Apartment'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Apartment'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.ApartmentId=@ApartmentId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0						
			END
				
			--NON-DEDICATED
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'NonDedicatedContract'
			FROM WRBHBContractNonDedicated C
			JOIN WRBHBContractNonDedicatedApartment CM ON @PropertyId=CM.PropertyId AND CM.NondedContractId = C.Id AND CM.IsActive=1 AND CM.IsDeleted=0 
		    JOIN WRBHBContractNonDedicatedServices CS ON C.Id=CS.NondedContractId AND CS.IsActive=1 AND CS.IsDeleted=0
		    WHERE C.ClientId=@ClientId AND C.IsActive=1 AND C.IsDeleted=0	
		    
		    
		   		    
		END
		 
		 UPDATE #SERVICRAMOUNT SET Price=0 
		 WHERE Complimentary=1
		 
		INSERT INTO #SERVICRAMOUNTFinal(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
		SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,Id,TypeService,'ProductMaster' 
		FROM WRBHBContarctProductMaster 
		WHERE IsActive=1 AND IsDeleted=0
		
		UPDATE #SERVICRAMOUNTFinal SET Price=S.Price,Type=S.Type
		FROM  #SERVICRAMOUNTFinal O
		JOIN #SERVICRAMOUNT S ON O.ProductId=S.ProductId
		
		
		--KOT COUNT
		CREATE TABLE #Kot(ServiceItem NVARCHAR(100),Quantity INT,Date date,Id INT,PropertyId INT,TypeService NVARCHAR(100))
		
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Breakfast' AS ServiceItem,SUM(KD.BreakfastVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId ,'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.BreakfastVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
			
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Breakfast' AS ServiceItem,SUM(KD.BreakfastNonVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId ,'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.BreakfastNonVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
		
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Lunch (Veg)' AS ServiceItem,SUM(KD.LunchVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId ,'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.LunchVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
		
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Lunch (Non-Veg)' AS ServiceItem,SUM(KD.LunchNonVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId, 'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.LunchNonVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
		
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Dinner (Veg)' AS ServiceItem,SUM(KD.DinnerVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId ,'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.DinnerVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
		
		INSERT INTO #Kot(ServiceItem,Quantity,Date,Id,PropertyId,TypeService)
		SELECT 'Dinner (Non-Veg)' AS ServiceItem,SUM(KD.DinnerNonVeg) AS Quantity,KH.Date,
		KD.Id,KH.PropertyId ,'Food And Beverages' TypeService
		FROM WRBHBKOTDtls KD
		JOIN WRBHBKOTHdr KH ON KD.KOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0
		JOIN WRBHBCheckInHdr C ON KD.CheckInId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  AND KD.DinnerNonVeg !=0 
		AND C.Id=CAST(@Str1 AS BIGINT) AND ISNULL(KD.CheckOutServiceFlag,0) = 0
		group by KH.Date,KD.Id,KH.PropertyId
		
		
		
		
									
		INSERT #Final(ServiceItem,Quantity,Amount,Date,Id,ProductId,TypeService)
		SELECT K.ServiceItem,K.Quantity,(K.Quantity * S.Price) AS Amount,CONVERT(NVARCHAR(100),Date,103) AS Date,
		S.Id,S.ProductId,'Food And Beverages' TypeService FROM #Kot K
		JOIN #SERVICRAMOUNTFinal S ON K.ServiceItem=S.ServiceName
		
		
		--SNCK KOT
		INSERT #Final(ServiceItem,Quantity,Amount,Date,Id,ProductId,TypeService)
		SELECT ServiceItem,Quantity,CAST(ISNULL(Amount,0)as DECIMAL(27,2)) AS Amount,
		Convert(NVARCHAR(100),CAST(KH.Date as DATE),103) AS Date,
		KD.Id,KD.ItemId,'Food And Beverages' as ServiceType
		FROM WRBHBNewKOTEntryDtl KD  
		JOIN WRBHBNewKOTEntryHdr KH ON KD.NewKOTEntryHdrId=KH.Id AND KH.IsActive=1 AND KH.IsDeleted=0  
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.GuestId=@CheckInHdrId AND BookingId=@BookingId 
		AND ISNULL(KH.ChkoutServiceFlag,0) = 0;
		
		
		SELECT VAT,RestaurantST,BusinessSupportST ,Cess,HECess --,'Food And Beverages' as Type  
		FROM WRBHBTaxMaster  
		WHERE IsActive=1 AND IsDeleted=0 AND StateId=@StateId; 
		
		
		
		--SELECT ServiceItem,Quantity,Amount,Date,Id,ProductId AS ItemId, TypeService
		--FROM #Final
		--group by ServiceItem,Quantity,Amount,Date,Id,ProductId ,TypeService
		
		
		----Laundry
		INSERT #Final(ServiceItem,Quantity,Amount,Date,Id,ProductId,TypeService)
		SELECT ServiceItem,Quantity,CAST(ISNULL(Amount,0)as DECIMAL(27,2)) AS Amount,
		--Convert(NVARCHAR(100),LH.Date,103) AS Date,
		CONVERT(nvarchar(100),CAST(LH.Date as DATE),103) AS Date,
		LD.Id,LD.ItemId,LD.ServiceType
		FROM WRBHBLaundrServiceDtl LD 
		JOIN WRBHBLaundrServiceHdr LH ON LD.LaundryHdrId=LH.Id AND LH.IsActive=1 AND LH.IsDeleted=0  
		WHERE LD.IsActive=1 AND LD.IsDeleted=0 AND LH.GuestId=@CheckInHdrId AND BookingId=@BookingId and
		LD.ServiceType = 'Laundry' AND ISNULL(LH.ChkoutServiceFlag,0) = 0;
		
		----SELECT VAT,RestaurantST,BusinessSupportST ,Cess,HECess ,'Laundry' as Type  
		----FROM WRBHBTaxMaster  
		----WHERE IsActive=1 AND IsDeleted=0 AND StateId=@StateId; 
		
		
		------SELECT ServiceItem,Quantity,Amount,Date,Id,ProductId AS ItemId,'Laundry' TypeService
		------FROM #Final
		------group by ServiceItem,Quantity,Amount,Date,Id,ProductId 
		
		--Service
		INSERT #Final(ServiceItem,Quantity,Amount,Date,Id,ProductId,TypeService)
		SELECT ServiceItem,Quantity,CAST(ISNULL(Amount,0)as DECIMAL(27,2)) AS Amount,
	--	Convert(NVARCHAR(100),LH.Date,103) AS Date,
		CONVERT(nvarchar(100),CAST(LH.Date as DATE),103) AS Date,
		LD.Id,LD.ItemId,LD.ServiceType
		FROM WRBHBLaundrServiceDtl LD 
		JOIN WRBHBLaundrServiceHdr LH ON LD.LaundryHdrId=LH.Id AND LH.IsActive=1 AND LH.IsDeleted=0  
		WHERE LD.IsActive=1 AND LD.IsDeleted=0 AND LH.GuestId=@CheckInHdrId AND BookingId=@BookingId and
		LD.ServiceType = 'Services' and ISNULL(LH.ChkoutServiceFlag,0) = 0;
		
		----SELECT VAT,RestaurantST,BusinessSupportST ,Cess,HECess ,'Services' as Type  
		----FROM WRBHBTaxMaster  
		----WHERE IsActive=1 AND IsDeleted=0 AND StateId=@StateId; 
		
		
		CREATE TABLE #FinalService(ServiceItem NVARCHAR(100),Quantity INT,Amount DECIMAL(27,2),Date NVARCHAR(100),
		Id INT,ProductId BIGINT,TypeService NVARCHAR(100))
		INSERT INTO #FinalService(ServiceItem,Quantity,Amount,Date,Id,ProductId,TypeService)
		
		SELECT ServiceItem,Quantity,Amount,Date,Id,ProductId AS ItemId, TypeService
		FROM #Final
		--WHERE CONVERT(NVARCHAR(100),Date,103) BETWEEN CONVERT(NVARCHAR(100),@BillFrom,103) AND 
		--CONVERT(NVARCHAR(100),@BillTo,103)
		--WHERE CONVERT(date,Date,103) BETWEEN CONVERT(date,@BillFrom,103) AND 
		-- CONVERT(date,@BillTo,103)
		GROUP BY ServiceItem,Quantity,Amount,Date,Id,ProductId ,TypeService
		
	-- Final service Load in service grid frond end 	
	--Select @BillFrom,@BillTo;		
	
	
	
		SELECT ServiceItem,Quantity,Amount,Date,Id,ProductId AS ItemId, TypeService
		FROM #FinalService
		--WHERE CONVERT(NVARCHAR(100),Date,103) BETWEEN CONVERT(NVARCHAR(100),@BillFrom,103) AND 
		--CONVERT(NVARCHAR(100),@BillTo,103)
		 --WHERE CONVERT(date,Date,103) BETWEEN CONVERT(date,@BillFrom,103) AND 
		 --CONVERT(date,@BillTo,103)
		GROUP BY ServiceItem,Quantity,Amount,Date,Id,ProductId ,TypeService
		
		--Help Load
		SELECT ServiceName AS Item,Price AS PerQuantityprice,ProductId AS ItemId,
		TypeService
		FROM  #SERVICRAMOUNTFinal 
		
		
		---For our Test purpose
		--SELECT ServiceName AS Item,Price AS PerQuantityprice,ProductId AS ItemId,
		--TypeService,Type
		--FROM  #SERVICRAMOUNTFinal 
	
END
END

