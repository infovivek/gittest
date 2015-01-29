-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CheckIn_Select]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_CheckIn_Select]
GO
/*=============================================
Author Name  : shameem
Created Date : 22/05/2014 
Section  	 : Guest service
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CheckIn_Select](@Id INT=NULL)
AS
BEGIN
DECLARE @ResId INT;
IF @Id<>0 
BEGIN
SET @ResId=(SELECT BookingId FROM WRBHBCheckInHdr WHERE Id=@Id);
-- HEADER
SELECT RoomId,CAST((PropertyId) AS NVARCHAR(100)) as PropertyId,BookingId,
StateId,GuestId,RefGuestId,ChkInGuest,CheckInNo,convert(nvarchar(100),ArrivalDate,103) as ArrivalDate,ArrivalTime,
convert(nvarchar(100),ChkoutDate,103) as ChkoutDate,RoomNo,GuestName,ClientName,Property,MobileNo,
EmailId,Designation,Nationality,IdProof,ChkinAdvance,Tariff,
Direct,BTC,EmpCode,BookingCode,Image,Id,TimeType,Occupancy,RackTariffSingle,RackTariffDouble,
ApartmentId,BedId,ApartmentType,BedType,Type ,PropertyType,GuestImage,CheckStatus,SingleMarkupAmount,DoubleMarkupAmount,
ClientId,CityId,ServiceCharge,NewCheckInDate,NewCheckoutDate,TariffPaymentMode
FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id;



--Service Load 	new update below(28Oct)(Table 1)
		DECLARE @ApartmentId BIGINT,@ClientId1 BIGINT,@ApartmentId1 BIGINT,@BookingLevel NVARCHAR(100),
		@SSPID BIGINT,@GuestId BIGINT,@BookingId BIGINT,@PropertyId BIGINT,@RoomId1 BIGINT;
		SELECT @ClientId1=ClientId,@BookingLevel=Type,@GuestId=GuestId,@BookingId=BookingId,
		@RoomId1=RoomId,@ApartmentId1=ApartmentId,@PropertyId=PropertyId
		 FROM WRBHBCheckInHdr WHERE Id= @Id
		AND IsActive=1 AND IsDeleted=0
			
		--SELECT ClientId,Type,GuestId,BookingId,PropertyId,Property,RoomId,ApartmentId
		-- FROM WRBHBCheckInHdr WHERE Id= 3581
		--AND IsActive=1 AND IsDeleted=0	
		
		--return;
			
			-- Service Load to Check SSP
		CREATE TABLE #SERVICRAMOUNT(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))  
		
		
		CREATE TABLE #SERVICRAMOUNTFinal(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100),Type NVARCHAR(100))
		
		IF @BookingLevel='Room'
		BEGIN
		
			SELECT @SSPID=SSPId,@RoomId1=RoomId FROM WRBHBBookingPropertyAssingedGuest
			WHERE GuestId=@GuestId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Bed'
		BEGIN
			SELECT @SSPID=SSPId,@RoomId1=RoomId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE GuestId=@GuestId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Apartment'
		BEGIN
			SELECT @SSPID=SSPId,@ApartmentId1=ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE GuestId=@GuestId AND BookingId=@BookingId;		
			
		END 
		
		
		--SSP
		IF ISNULL(@SSPID,0)!=0
		BEGIN
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
			SELECT S.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'SSP'
			FROM dbo.WRBHBSSPCodeGeneration G			
			JOIN dbo.WRBHBSSPCodeGenerationServices S WITH(NOLOCK) ON S.SSPCodeGenerationId=G.Id AND S.IsActive=1
			AND S.IsDeleted=0
			WHERE G.Id=@SSPID  --AND G.IsActive=1 AND G.IsDeleted=0
			
		END 
		ELSE 
		BEGIN
		--DEDICATED AND MANAGED GH
			IF @BookingLevel='Room'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Room'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId1
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId1 AND H.IsActive=1 AND H.IsDeleted=0	
			END
			
			IF @BookingLevel='Bed'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Bed'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId1
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId1 AND H.IsActive=1 AND H.IsDeleted=0
			END
			IF @BookingLevel='Apartment'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'DedicatedContract Apartment'
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.ApartmentId=@ApartmentId1
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId1 AND H.IsActive=1 AND H.IsDeleted=0						
			END
				
			--NON-DEDICATED
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,'NonDedicatedContract'
			FROM WRBHBContractNonDedicated C
			JOIN WRBHBContractNonDedicatedApartment CM ON @PropertyId=CM.PropertyId AND CM.NondedContractId = C.Id AND CM.IsActive=1 AND CM.IsDeleted=0 
		    JOIN WRBHBContractNonDedicatedServices CS ON C.Id=CS.NondedContractId AND CS.IsActive=1 AND CS.IsDeleted=0
		    WHERE C.ClientId=@ClientId1 AND C.IsActive=1 AND C.IsDeleted=0	
		    
		
		    
		   		    
		END
		
		
		
		UPDATE #SERVICRAMOUNT SET Price=0 
		 WHERE Complimentary=1
		 
		INSERT INTO #SERVICRAMOUNTFinal(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
		SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,Id,TypeService,'ProductMaster' 
		FROM WRBHBContarctProductMaster 
		WHERE IsActive=1 AND IsDeleted=0
		
		
		
		UPDATE #SERVICRAMOUNTFinal SET Price=S.Price,Type=S.Type,Complimentary=S.Complimentary
		FROM  #SERVICRAMOUNTFinal O
		JOIN #SERVICRAMOUNT S ON O.ProductId=S.ProductId
		
		SELECT DISTINCT (ServiceName) AS ServiceItem,Price,ProductId,Complimentary
				FROM #SERVICRAMOUNTFinal
		
		----SELECT DISTINCT (ServiceName) AS ServiceItem,Price,ProductId,Complimentary
		----FROM #SERVICRAMOUNT 
			--SELECT DISTINCT (ServiceName) AS ServiceItem,Price,ProductId,Complimentary
			--FROM #SERVICRAMOUNT
		--DECLARE @SERVICRAMOUNT nvarchar(100);
		--SET @SERVICRAMOUNT = (select COUNT(*) from #SERVICRAMOUNT);
		--	IF(ISNULL(@SERVICRAMOUNT,0) = 0)
		--	BEGIN
		--		INSERT INTO #SERVICRAMOUNTFinal(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Type)
		--		SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,Id,TypeService,'ProductMaster' 
		--		FROM WRBHBContarctProductMaster 
		--		WHERE IsActive=1 AND IsDeleted=0
				
		--		SELECT DISTINCT (ServiceName) AS ServiceItem,Price,ProductId,Complimentary
		--		FROM #SERVICRAMOUNTFinal  
		--	END
		--	ELSE
		--	BEGIN
		--		SELECT DISTINCT (ServiceName) AS ServiceItem,Price,ProductId,Complimentary
		--		FROM #SERVICRAMOUNT  
		--	END



END

ELSE
 
BEGIN
SELECT ChkInGuest as GuestName,BookingCode,CheckInNo,Id,
CONVERT(VARCHAR(100),ArrivalDate,103) AS ArrivalDate,Property 
FROM WRBHBCheckInHdr
WHERE IsDeleted=0 AND IsActive=1  ORDER BY Id DESC;


END

END
GO



