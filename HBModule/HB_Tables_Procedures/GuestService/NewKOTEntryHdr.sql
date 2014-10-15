-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_NewKOTEntry_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_NewKOTEntry_Help]
GO 
-- ===============================================================================
-- Author: Anbu
-- Create date:23-05-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	New KOT Entry
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_NewKOTEntry_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
@SSId BIGINT=NULL,
@Id BIGINT=NULL)

AS
BEGIN
If @Action ='PageLoad'
	BEGIN
		SELECT DISTINCT P.PropertyName Property,P.Id AS PropertyId	
		FROM WRBHBPropertyUsers  PU 
		JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE PU.UserId=@Id AND 
		P.Category IN('Internal Property','Managed G H') AND
		PU.IsActive=1 AND PU.IsDeleted=0 AND PU.UserType IN('Resident Managers' ,'Assistant Resident Managers')
		
		
		SELECT CONVERT(varchar(103),GETDATE(),103) as KOTDate
		
	END
If @Action ='Property'
	
		BEGIN
			SELECT DISTINCT H.GuestName AS GuestName,(p.Category) AS GetTypeId,H.RoomNo AS RoomNoId,H.BookingCode AS BookingCodeId,
			H.ClientName AS ClientNameId,ISNULL(H.GuestId,0) as GuestId,ISNULL(H.PropertyId,0) as PropertyId,H.RoomId,
			H.BookingId,H.Id 
			FROM WRBHBCheckInHdr H
			join WRBHBProperty p on p.Id = h.PropertyId AND P.IsActive=1 AND P.IsDeleted=0
			WHERE H.PropertyId = @Id AND -- GETDATE() BETWEEN  H.ArrivalDate AND H.ChkoutDate AND 
			H.IsActive=1 AND H.IsDeleted=0 AND
			p.Category = 'Internal Property' AND  H.Id NOT IN(SELECT ChkInHdrId FROM WRBHBChechkOutHdr)
					
   
	--UserKOT
	     SELECT DISTINCT UserId,UserName,PropertyId,'Internal Property' AS GetTypeId	FROM WRBHBPropertyUsers  
	     WHERE IsActive=1 AND IsDeleted=0 AND PropertyId=@Id
	     AND UserType IN('Resident Managers' ,'Assistant Resident Managers');
	    END
If @Action ='Date'
	
		BEGIN
			SELECT DISTINCT H.GuestName AS GuestName,(p.Category) AS GetTypeId,H.RoomNo AS RoomNoId,H.BookingCode  AS BookingCodeId,
			H.ClientName AS ClientNameId,ISNULL(H.GuestId,0) as GuestId,ISNULL(H.PropertyId,0) as PropertyId,H.RoomId,
			H.BookingId,H.Id 
			FROM WRBHBCheckInHdr H
			join WRBHBProperty p on p.Id = h.PropertyId 
			WHERE H.PropertyId = @Id AND CONVERT(date,@Str2,103) BETWEEN  H.ArrivalDate AND H.ChkoutDate AND
			H.IsActive=1 AND H.IsDeleted=0 AND
			p.Category = 'Internal Property' AND  H.Id NOT IN(SELECT ChkInHdrId FROM WRBHBChechkOutHdr)
					
   	--UserKOT
	     SELECT DISTINCT UserId,UserName,PropertyId,'Internal Property' AS GetTypeId	FROM WRBHBPropertyUsers  
	     WHERE IsActive=1 AND IsDeleted=0 AND PropertyId=@Id
	     AND UserType IN('Resident Managers' ,'Assistant Resident Managers');
	    
		
END
If @Action ='GuestName'
		
		CREATE TABLE #Final(ServiceItem NVARCHAR(100),Quantity INT,Amount DECIMAL(27,2),Date NVARCHAR(100),
		Id INT,ProductId BIGINT,TypeService NVARCHAR(100))

		DECLARE @ClientId BIGINT,@PropertyId BIGINT,@BookingId BIGINT,@BookingLevel NVARCHAR(100),
		@SSPID BIGINT,@RoomId BIGINT,@ApartmentId BIGINT,@Count INT; 
		
		SELECT @BookingId=BookingId,@PropertyId=PropertyId
		FROM WRBHBCheckInHdr WHERE Id= @Id
		AND IsActive=1 AND IsDeleted=0
		
		SELECT @ClientId=ClientId,@BookingLevel=BookingLevel FROM WRBHBBooking WHERE Id= @BookingId
		AND IsActive=1 AND IsDeleted=0
		
		CREATE TABLE #SERVICRAMOUNT(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100))  
		
		CREATE TABLE #SERVICRAMOUNTFinal(Id BIGINT,Complimentary BIT,ServiceName NVARCHAR(100),Price DECIMAL(27,2),
		Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100))
		
		IF @BookingLevel='Room'
		BEGIN
			SELECT @SSPID=SSPId,@RoomId=RoomId FROM WRBHBBookingPropertyAssingedGuest
			WHERE GuestId=@SSId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Bed'
		BEGIN
			SELECT @SSPID=SSPId,@RoomId=RoomId FROM WRBHBBedBookingPropertyAssingedGuest
			WHERE GuestId=@SSId AND BookingId=@BookingId;
		END
		IF @BookingLevel='Apartment'
		BEGIN
			SELECT @SSPID=SSPId,@ApartmentId=ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest
			WHERE GuestId=@SSId AND BookingId=@BookingId;		
		END 
		--SSP
		IF ISNULL(@SSPID,0)!=0
		BEGIN
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
			SELECT S.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService
			FROM dbo.WRBHBSSPCodeGeneration G			
			JOIN dbo.WRBHBSSPCodeGenerationServices S WITH(NOLOCK) ON S.SSPCodeGenerationId=G.Id AND S.IsActive=1
			AND S.IsDeleted=0
			WHERE G.Id=@SSPID AND G.IsActive=1 AND G.IsDeleted=0 AND TypeService='Food And Beverages'
			AND S.ServiceName !='Breakfast' AND S.ServiceName !='Lunch (Non-Veg)' AND S.ServiceName !='Lunch (Veg)' 
		    AND S.ServiceName !='Dinner (Veg)'	AND S.ServiceName !='Dinner (Non-Veg)'
		END 
		ELSE 
		BEGIN
		--DEDICATED AND MANAGED GH
			IF @BookingLevel='Room'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0 AND TypeService='Food And Beverages'
				 AND CS.ServiceName !='Breakfast' AND CS.ServiceName !='Lunch (Non-Veg)' AND CS.ServiceName !='Lunch (Veg)' 
					AND CS.ServiceName !='Dinner (Veg)'	AND CS.ServiceName !='Dinner (Non-Veg)'	
			END
			IF @BookingLevel='Bed'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementTariffAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.RoomId=@RoomId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0 AND TypeService='Food And Beverages'
				 AND CS.ServiceName !='Breakfast' AND CS.ServiceName !='Lunch (Non-Veg)' AND CS.ServiceName !='Lunch (Veg)' 
		AND CS.ServiceName !='Dinner (Veg)'	AND CS.ServiceName !='Dinner (Non-Veg)'
			END
			IF @BookingLevel='Apartment'
			BEGIN
				 INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
				 SELECT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService
				 FROM dbo.WRBHBContractManagement H
				 JOIN WRBHBContractManagementAppartment CM WITH(NOLOCK) ON H.Id=CM.ContractId AND CM.ApartmentId=@ApartmentId
				 AND CM.IsActive=1 AND CM.IsDeleted=0
				 JOIN WRBHBContractManagementServices CS ON H.Id=CS.ContractId AND CS.IsActive=1 AND CS.IsDeleted=0
				 WHERE  H.ClientId=@ClientId AND H.IsActive=1 AND H.IsDeleted=0	AND TypeService='Food And Beverages'	
				 AND CS.ServiceName !='Breakfast' AND CS.ServiceName !='Lunch (Non-Veg)' AND CS.ServiceName !='Lunch (Veg)' 
		AND CS.ServiceName !='Dinner (Veg)'	AND CS.ServiceName !='Dinner (Non-Veg)'				
			END	
			--NON-DEDICATED
			INSERT INTO #SERVICRAMOUNT(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
			SELECT DISTINCT CS.Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService
			FROM WRBHBContractNonDedicated C
			JOIN WRBHBContractNonDedicatedApartment CM ON @PropertyId=CM.PropertyId AND CM.IsActive=1 AND CM.IsDeleted=0 
		    JOIN WRBHBContractNonDedicatedServices CS ON C.Id=CS.NondedContractId AND CS.IsActive=1 AND CS.IsDeleted=0
		    AND CS.ServiceName !='Breakfast' AND CS.ServiceName !='Lunch (Non-Veg)' AND CS.ServiceName !='Lunch (Veg)' 
		AND CS.ServiceName !='Dinner (Veg)'	AND CS.ServiceName !='Dinner (Non-Veg)'
		    WHERE C.ClientId=@ClientId AND C.IsActive=1 AND C.IsDeleted=0	AND TypeService='Food And Beverages'
		   END 
		INSERT INTO #SERVICRAMOUNTFinal(Id,Complimentary,ServiceName,Price,Enable,ProductId,TypeService)
		SELECT Id,ISComplimentary,ProductName,PerQuantityprice,Enable,Id,TypeService
		FROM WRBHBContarctProductMaster 
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		AND ProductName !='Breakfast' AND ProductName !='Lunch (Non-Veg)' AND ProductName !='Lunch (Veg)' 
		AND ProductName !='Dinner (Veg)'	AND ProductName !='Dinner (Non-Veg)'
		
		UPDATE #SERVICRAMOUNTFinal SET Price=S.Price
		FROM  #SERVICRAMOUNTFinal O
		JOIN #SERVICRAMOUNT S ON O.ProductId=S.ProductId
		
		
				
	    SELECT ServiceName AS ServiceItem,1 AS Quantity,Price,(1*Price) AS Amount,ProductId As ItemId,0 AS Id 
	    FROM #SERVICRAMOUNTFinal

If @Action = 'Show'
BEGIN
--select GuestId,GuestName,GetType,PropertyId,PropertyName
--from WRBHBNewKOTEntryHdr 
--where IsActive =  1 and IsDeleted = 0 and
--GuestId = @Id


select d.ServiceItem as ServiceItem,d.Quantity as Quantity,d.Price as Price,
d.Amount as Amount,d.ItemId,d.Id
from WRBHBNewKOTEntryHdr h
join WRBHBNewKOTEntryDtl d on h.Id = d.NewKOTEntryHdrId and
d.IsActive = 1 and d.IsDeleted = 0
where h.IsActive = 1 and h.IsDeleted = 0 and
h.GuestId = @Id

END
END



