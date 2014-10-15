

-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExternalCheckout_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ExternalCheckout_Help]
GO 
-- ===============================================================================
-- Author: Shameem
-- Create date:09-07-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	External Check Out
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_ExternalCheckout_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@CheckInHdrId INT=NULL,
--@Tariff DECIMAL(27,2)=NULL,
@StateId INT=NULL,
@PropertyId INT=NULL,
@UserId INT=NULL
)
AS
BEGIN
DECLARE @Cnt INT,@StateId1 int;
set @StateId1 = 17;
IF @Action='ServiceEntry'  
 BEGIN
	UPDATE WRBHBChechkOutHdr SET  ServiceEntryFlag=1 where Id=@CheckInHdrId
 END
IF @Action='PageLoad'
	BEGIN
	SET @Cnt=(SELECT COUNT(*) FROM WRBHBChechkOutHdr)
		IF @Cnt=0 BEGIN SELECT 1 AS CheckoutNo;
	END
	ELSE 
	BEGIN
	SELECT TOP 1 CAST(CheckoutNo AS INT)+1 AS CheckoutNo FROM WRBHBChechkOutHdr
		ORDER BY Id DESC;
	END
	
	
	-- Room Level Property booked and direct booked (External Property)
	    create table #Prop (ZId int,PropertyName NVARCHAR(100))
	    insert into #Prop(ZId,PropertyName)
	    
		select distinct P.Id As PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBCheckInHdr CH on CH.BookingId = AG.BookingId and CH.IsActive = 1 and CH.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		join wrbhbcity C on C.Id = H.cityId and C.IsActive = 1
		join wrbhbstate s on S.Id = H.StateId and s.IsActive = 1
		WHERE  H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and P.Category in ('External Property','Managed G H','Client Prefered') 
		
		--and CONVERT(varchar(100),AG.ChkInDt,103) =  CONVERT(nvarchar(100),GETDATE(),103)
		
	--	and PU.UserId=@UserId 
		
 		select ZId,PropertyName from #Prop GROUP BY ZId,PropertyName
		select count(*) AS PropertyCount,ZId,PropertyName from #Prop GROUP BY ZId,PropertyName 
 		 
 		 -- Item Load
    
       CREATE TABLE #Service(Item NVARCHAR(100),PerQuantityprice DECIMAL(27,2),Id INT,TypeService NVARCHAR(100))  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Food And Beverages'  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Laundry'  

		SELECT Item,PerQuantityprice,Id as ItemId,TypeService  
		FROM #Service 
       
END 
If @Action = 'GuestName'
BEGIN
	--	SELECT  GuestName,GuestId,StateId,Id AS CheckInHdrId,PropertyId,RoomId,ApartmentId,
	--	BookingId,BedId,Type as Level--PropertyId,Property--,PropertyType
	--	From WRBHBCheckInHdr
	--	WHERE IsActive=1 AND IsDeleted=0 AND 
	--    PropertyId = @PropertyId and
	--	PropertyType in ('External Property','Managed G H') 
	--	--and 
	----	CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and
	--	AND Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
	--	IsActive = 1 and IsDeleted = 0 )
		CREATE TABLE #GUEST(GuestName NVARCHAR(100),GuestId INT,StateId INT,CheckInHdrId INT,  
		PropertyId INT,RoomId INT,ApartmentId INT,BookingId INT,BedId INT,Type NVARCHAR(100),Flag int)  

		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag)  

		SELECT  GuestName,GuestId,StateId,Id AS CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type as Level,0 as Flag  
		From WRBHBCheckInHdr  
		WHERE IsActive=1 AND IsDeleted=0 AND   
		PropertyType in ('External Property' , 'Managed G H','Client Prefered') and  
		PropertyId = @PropertyId and  
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0  )  and
		Id not in (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where IsActive = 1 and IsDeleted = 0)

		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag)  

		SELECT  GuestName,GuestId,StateId,Id AS CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type as Level,0 as Flag  
		From WRBHBCheckInHdr  
		WHERE IsActive=1 AND IsDeleted=0 AND   
		PropertyType in ('External Property','Managed G H','Client Prefered') and  
		PropertyId = @PropertyId and  
		-- CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and  
		Id  IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 ) 
		
		and Id  not IN (Select ChkInHdrId FRom WRBHBExternalChechkOutTAC where isnull(Flag,0) = 1 and  
		IsActive = 1 and IsDeleted = 0 ) 

		SELECT  GuestName,GuestId,StateId, CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type as Level  
		FROM #GUEST 
		 
		SELECT DISTINCT U.FirstName AS label,U.Id AS Data FROM WRBHBUser U
		JOIN WRBHBPropertyUsers P ON U.Id=P.UserId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE P.UserType in ('Resident Managers','Assistant Resident Managers') AND 
		U.IsActive=1 AND U.IsDeleted=0 and P.PropertyId = @PropertyId
	END
	
IF @Action='CHKINROOMDETAILS'
BEGIN
		Declare @CID bigint;
		--Select isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId and Flag=0 and
		--IsActive = 1 and IsDeleted = 0
		set @CID=(Select top 1 isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId and Flag=0
		and IsActive= 1 and IsDeleted =0)  
 --select @CID  
	IF(ISNULL(@CID,0)=0)  
	BEGIN  
	
			CREATE TABLE #LEVEL(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
			TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC nvarchar(100))
			DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);
			SET @BookingId=(SELECT BookingId FROM WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
			SET @GuestId=(SELECT GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
			SET @BookingLevel=(SELECT Type from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive = 1 and IsDeleted =0)
--select @GuestId ,@BookingId
		IF @BookingLevel = 'Room' 
		BEGIN
			INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC)
			SELECT CONVERT(nvarchar(100),min(d.ChkInDt),103),CONVERT(nvarchar(100),max(d.ChkOutDt),103),
			d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC
			FROM  WRBHBBookingProperty h 
			JOIN WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId and
			h.PropertyId = d.BookingPropertyId
			AND h.IsActive = 1 and
			h.IsDeleted = 0
			where d.GuestId  = @GuestId and d.BookingId = @BookingId and d.IsActive = 1 and d.IsDeleted = 0
			group by d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC
		END
	
			DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100),@TariffPaymentMode nvarchar(100),
			@ServicePaymentMode nvarchar(100),@TAC nvarchar(100);
			SET @ChkInDate =( SELECT ChkInDate FROM #LEVEL)	
			SET @ChkOutDate =( SELECT ChkOutDate FROM #LEVEL)
			SET @TariffPaymentMode =(SELECT TariffPaymentMode FROM #LEVEL)
			SET @ServicePaymentMode =(SELECT ServicePaymentMode FROM #LEVEL)
			SET @TAC=(SELECT TAC from #LEVEL)
		 
			SELECT Property,
			CONVERT(nvarchar(100),@ChkInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate,103) as Stay,Tariff,
			CONVERT(nvarchar(100),@ChkOutDate,103) as ChkoutDate,CONVERT(nvarchar(100),@ChkInDate,103) as CheckInDate
			FROM WRBHBCheckInHdr
			WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId;
		
		
	--BillDate 
			SELECT CONVERT(varchar(103),@ChkOutDate,103) as BillDate
		
	--Type
			SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr
			WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
		
			SELECT ClientName,ClientId,CityId,ServiceCharge as ServiceChargeChk,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,
			Id From  WRBHBCheckInHdr  
			WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
	--Day Count
			CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)
			INSERT INTO #CountDays (NoofDays,CheckInHdrId)
			SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,
			Id--,ArrivalDate
			FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;
		
	--	Tax Calculation in External Property 
			CREATE TABLE #ServiceTax(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT)

			CREATE TABLE #ServiceTax2(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT,
			DATE NVARCHAR(100))

			CREATE TABLE #ExTariff(Tariff DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),
			STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),LTRack decimal(27,2),
			Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),SingleMarkupAmount DECIMAL(27,2),DoubleMarkupAmount DECIMAL(27,2),)

			CREATE TABLE #FINALTAX(Tariff DECIMAL(27,2),STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),
			LTRack decimal(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
			Amount DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),BST DECIMAL(27,2),NetAmountTAC decimal(27,2),ST DECIMAL(27,2))

			CREATE TABLE #FINAL(Tariff DECIMAL(27,2),STAgreed Decimal(27,2),LTAgreed Decimal(27,2),STRack decimal(27,2),
			LTRack decimal(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
			Amount DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),BST DECIMAL(27,2),NetAmountTAC decimal(27,2),ST DECIMAL(27,2))


			DECLARE @Occupancy NVARCHAR(100);
			SET @Occupancy=(SELECT Occupancy FROM WRBHBCheckInHdr WHERE Id = @CheckInHdrId)
		
	--IF @Occupancy = 'Single'
	--	BEGIN
	--		INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date)
	--		SELECT Tariff,RackSingle,0,STonAgreed,LTonAgreed,STonRack,LTonRack,Occupancy,convert(nvarchar(100),ChkInDt,103)
	--		FROM WRBHBBookingPropertyAssingedGuest
	--		WHERE IsActive = 1 AND IsDeleted = 0 
	--		AND GuestId = @GuestId and BookingId = @BookingId
	--	END	
	--IF	@Occupancy = 'Double'
	--	BEGIN
	--		INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date)
	--		SELECT Tariff,0,RackDouble,STonAgreed,LTonAgreed,STonRack,LTonRack,Occupancy,convert(nvarchar(100),ChkInDt,103)
	--		FROM WRBHBBookingPropertyAssingedGuest
	--		WHERE IsActive = 1 AND IsDeleted = 0 
	--		AND GuestId = @GuestId and BookingId = @BookingId
	--	END
-- Service Tax
			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),Date,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
			CONVERT(nvarchar(100),@ChkOutDate,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1


			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),DateTo,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
			CONVERT(nvarchar(100),@ChkOutDate,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1

			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),@ChkInDate,103)	
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1
		
--Select @ChkOutDate;
			INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
			SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
			FROM WRBHBTaxMaster
			WHERE CONVERT(nvarchar(100),@ChkOutDate,103)<= CONVERT(nvarchar(100),DateTo,103)		
			AND IsActive=1 AND IsDeleted=0 
			AND StateId=@StateId1	
			group by ServiceTaxOnTariff,BusinessSupportST,Date,DateTo,Id
	-- select * from #ServiceTax;
	---return;
	--select * from #ExTariff
			DECLARE @Tariff DECIMAL(27,2),@RackTariffSingle DECIMAL(27,2),@RackTariffDouble DECIMAL(27,2),@Dt1 DateTime ,@prtyId BIGINT,
			@chktime NVARCHAR(100),@TimeType NVARCHAR(100),@chkouttime NVARCHAR(100);
			DECLARE @DateDiff int,@i int,@HR NVARCHAR(100),@MIN INT,@OutPutSEC INT,@OutPutHour INT,
			@NoOfDays INT,@STAgreed DECIMAL(27,2),@LTAgreed DECIMAL(27,2),@STRack DECIMAL(27,2),@LTRack DECIMAL(27,2),
			@SingleMarkupAmount DECIMAL(27,2),@DoubleMarkupAmount DECIMAL(27,2);
		
		
			SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1			
			FROM #ServiceTax;		
			WHILE (@DateDiff>=0)
			BEGIN
				INSERT INTO #ServiceTax2(ServiceTax,BusinessSupportST,FromDT,ToDT,DATE)
				SELECT TOP 1 ServiceTax,BusinessSupportST,FromDT,ToDT,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,FromDT,103)),103)
				FROM #ServiceTax
				SET @i=@i+1
				SET @DateDiff=@DateDiff-1			
				IF @DateDiff=0
				BEGIN
					DELETE FROM #ServiceTax
					WHERE Id IN(SELECT TOP 1 Id FROM #ServiceTax)
					SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1			
					FROM #ServiceTax;
				END
			END  
		
			SET @HR=(select CheckIn from WRBHBProperty where Id = @CheckInHdrId)
			--TARIFF SPLIT FOR CHECK IN TO CHECK OUT 
			SELECT @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,@Tariff=Tariff,@RackTariffSingle=RackTariffSingle,
			@RackTariffDouble=RackTariffDouble,@i=0,@SingleMarkupAmount = SingleMarkupAmount,
			@DoubleMarkupAmount = DoubleMarkupAmount,
			--	@RackTariff=RackTariff,
			@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr where Id=@CheckInHdrId
		
			IF @HR='12'		
			BEGIN
			-- To Check Time
			SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
			CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
			CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+'12:00:00',CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
			CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
			CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+@chkouttime) AS M
			);
			IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END
			ELSE BEGIN SELECT @MIN AS M END	
	--this is 24 hour  for mat
			SELECT @DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60) 
	-- this is 12 hour Format	
		--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes 
			IF(UPPER(@TimeType)=UPPER('AM'))
			BEGIN
				IF(CAST(@chktime AS TIME)<CAST('11:00:00' AS TIME))
				BEGIN
					SELECT @NoOfDays=@NoOfDays+1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount
				--	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)
				END		 
			END		 
		 --GET AFTER 1 CL CHECKOUT TIME TARIFF ADD  AND ABOVE ONE HR TARIFF ADD  
			IF(@OutPutHour>1)
			BEGIN
				IF(@NoOfDays = 1)
				BEGIN
					SELECT @NoOfDays=@NoOfDays 
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount
				END
				ELSE
				BEGIN
					SELECT @NoOfDays=@NoOfDays + 1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount
				END
			
		 
			--SELECT @NoOfDays=@NoOfDays+1
			--INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
			--SingleMarkupAmount,DoubleMarkupAmount)
			--SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
			--CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount
		--	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
			END	
		 --DAYS TARIFF ADD	
		 			
			WHILE (@DateDiff>0)
			BEGIN	
					SELECT @NoOfDays=@NoOfDays+1					
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,@DoubleMarkupAmount
					--SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
					SET @i=@i+1
					SET @DateDiff=@DateDiff-1   
			
			 END
		     
			 END--hr end		
			 
			 ELSE 
			 BEGIN
		 --Get Date Differance
					SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
					CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+
					CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+@chktime,CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
					CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+
					CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+@chkouttime) AS M
					);
					IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END
					ELSE BEGIN SELECT @MIN AS M END	
					--this is 24 hour  for mat
					Select @i=0,@DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60) 
			-- this is 12 hour Format	
			--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes  		
		    
		   --ABOVE 1 HR IT WILL WORK
		   --select @OutPutHour;
			IF(@OutPutHour>1)
			BEGIN
			IF (@NoOfDays = 1)
				BEGIN
					SELECT @NoOfDays=@NoOfDays 
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount
				END
				ELSE
				BEGIN
					SELECT @NoOfDays=@NoOfDays + 1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
					SingleMarkupAmount,DoubleMarkupAmount)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
					@DoubleMarkupAmount
				
				END
				
	--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		    END
		    
		    --DAYS TARIFF ADD
		  --  select @NoOfDays,@DateDiff
		    
			WHILE (@DateDiff>0)
			BEGIN	
				SELECT @NoOfDays=@NoOfDays 	+1			
				INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,STAgreed,LTAgreed,STRack,LTRack,Occupancy,Date,
				SingleMarkupAmount,DoubleMarkupAmount)
				SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@STAgreed,@LTAgreed,@STRack,@LTRack,@Occupancy,
				CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@SingleMarkupAmount,
				@DoubleMarkupAmount
	--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
				SET @i=@i+1
				SET @DateDiff=@DateDiff-1			               
			END			
		END		
		
	--	select * from #ExTariff
	--	SELECT @TariffPaymentMode;
	--	select @NoOfDays,@DateDiff
		IF @TariffPaymentMode IN('Bill to Company (BTC)','Bill to Client')
		BEGIN
		--select @TAC
			IF @TAC=0
				BEGIN
			--	
			--(RACK TARIFF SINGLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffSingle*LTRack)/100,0),
				ISNULL((RackTariffSingle*STRack)/100,0),Occupancy ,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.SingleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single'
				
				--(RACK TARIFF Double)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double'
				set @TAC=1
			END
			ELSE
			BEGIN
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffSingle*LTRack)/100,0),
				ISNULL((RackTariffSingle*STRack)/100,0),Occupancy ,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.SingleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single'
			
				--(RACK TARIFF Double)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,ISNULL((Tariff*STAgreed)/100,0),ISNULL((Tariff*LTAgreed)/100,0),ISNULL((RackTariffDouble*LTRack)/100,0),
				ISNULL((RackTariffDouble*STRack)/100,0),Occupancy,ISNULL((Tariff*h.ServiceTax)/100,0),'0.00' as Amount,'0.00' as BusinessSupportST,
				'0.00' as BST,ISNULL(d.DoubleMarkupAmount,0) as NetAmountTAC,h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double'
			--set @TAC=1
			END
		END
		--ELSE
		--BEGIN
		--IF @TAC=0
		--      BEGIN
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Single'
				
		--		--(RACK TARIFF Double)
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Double'
		--		set @TAC=0
		--	END
		--	ELSE
		--	BEGIN 
		
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Single'
				
		--		--(RACK TARIFF Double)
		--		INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--		BusinessSupportST,BST,NetAmountTAC,ST)
		--		SELECT Tariff,0,0,0,0,Occupancy ,'0.00' as ServiceTax,'0.00' as Amount,'0.00' as BusinessSupportST,
		--		'0.00' as BST,'0.00' as NetAmountTAC,h.ServiceTax
		--		FROM #ServiceTax2 h
		--		join #ExTariff d on h.DATE = d.Date
		--		WHERE Occupancy ='Double'
		--			SET @TAC=0
		--	END
		--END
	--	select @TAC AS AC,@TariffPaymentMode;
	--	select * from #FINALTAX
--	select * from #ServiceTax2
	--select * from #ExTariff
		If @TariffPaymentMode ='Direct'
		BEGIN
			IF @TAC='0'
			BEGIN
				--(Agreed TARIFF SINGLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT d.Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.SingleMarkupAmount,0),
				isnull(d.SingleMarkupAmount*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.SingleMarkupAmount,0),h.ServiceTax
				FROM #ServiceTax2 h
				right outer join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single' AND ISNULL(h.ServiceTax,0)!=0
		
		--(Agreed TARIFF DOUBLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.DoubleMarkupAmount,0),
				isnull(d.DoubleMarkupAmount*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.DoubleMarkupAmount,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double' AND ISNULL(h.ServiceTax,0)!=0
		
		END
		ELSE
		BEGIN
		--(RACK TARIFF SINGLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.Tariff-d.RackTariffSingle,0),
				isnull(d.Tariff*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.Tariff-d.RackTariffSingle,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Single' AND ISNULL(h.ServiceTax,0)!=0
		
		--(RACK TARIFF DOUBLE)
				INSERT INTO #FINALTAX(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
				BusinessSupportST,BST,NetAmountTAC,ST)
				SELECT Tariff,0,0,0,0,d.Occupancy,isnull(d.Tariff*h.ServiceTax/100,0),ISNULL(d.Tariff-d.RackTariffDouble,0),
				isnull(d.Tariff*h.BusinessSupportST/100,0),h.BusinessSupportST,
				ISNULL(d.Tariff-d.RackTariffDouble,0),h.ServiceTax
				FROM #ServiceTax2 h
				join #ExTariff d on h.DATE = d.Date
				WHERE Occupancy ='Double' AND ISNULL(h.ServiceTax,0)!=0
		--SET @TAC=1
			END
		END
		
		--select 'dfgdfg'
		
		--select * from #FINALTAX
		INSERT INTO #FINAL(Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,BusinessSupportST,BST,NetAmountTAC,ST)
		SELECT sum(isnull(Tariff,0)),SUM(isnull(STAgreed,0)),SUM(isnull(LTAgreed,0)),SUM(isnull(STRack,0)),
		SUM(isnull(LTRack,0)),Occupancy,sum(isnull(ServiceTax,0)),(ISNULL(Amount,0)),SUM(ISNULL(BusinessSupportST,0)),
		ISNULL(BST,0),SUM(ISNULL(NetAmountTAC,0)),ISNULL(ST,0)
		FROM #FINALTAX
		GROUP BY Tariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,BusinessSupportST,
		BST,NetAmountTAC,ST
		
		SELECT @NoOfDays as NoofDays --FROM #Tariff
		
		SELECT DISTINCT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		BusinessSupportST,BST,NetAmountTAC ,ST FROM #FINAL
		group by TARIFF ,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		BusinessSupportST,BST,NetAmountTAC ,ST
		
	
		--select * from #FINAL
		--SELECT @TAC;
		--IF @TAC=0
		-- BEGIN
		 
		--	SELECT @NoOfDays as NoofDays --FROM #Tariff
		--	SELECT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--	BusinessSupportST,BST,NetAmountTAC ,ST FROM #FINAL where NetAmountTAC!=0
		--END
		--ELSE
		--BEGIN
		--select 'dsfsdf'
		--	SELECT @NoOfDays as NoofDays --FROM #Tariff
		--	SELECT TARIFF as NetTariff,STAgreed,LTAgreed,STRack,LTRack,Occupancy,ServiceTax,Amount,
		--	BusinessSupportST,BST,NetAmountTAC,ST FROM #FINAL where NetAmountTAC=0
		--END
	--END
	
		SELECT COUNT(Id) AS Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId   
		 
		SELECT COUNT(d.CheckOutHdrId) AS Id2 FROM WRBHBChechkOutHdr h  
		JOIN WRBHBCheckOutServiceHdr d ON h.Id = d.CheckOutHdrId  
		--join WRBHBCheckOutServiceDtls cs on d.Id= cs.CheckOutServceHdrId  
		WHERE h.ChkInHdrId= @CheckInHdrId  
		 
		 
		 
		SELECT Id  
		FROM WRBHBChechkOutHdr WHERE ChkInHdrId = @CheckInHdrId  
		 
		SELECT COUNT(Tariff) AS Tariff FROM #FINAL  
		
		CREATE TABLE #TariffSet(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  

		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCash d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Tariff'  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCard d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCheque d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCompanyInvoice d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Tariff'  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentNEFT d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  

		-- Service  
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Service'  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Service'  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Service'  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Service'  
		 
		 
		 INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and d.Payment='Service'  
		 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated'  
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  
		 
		 
		 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated' 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Consolidated'  
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Consolidated'  
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  



		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = ch.Id  
		where ch.ChkInHdrId=@CheckInHdrId AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Consolidated' 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   
     
     
  
   --   DECLARE @TEMPConsolidate1 NVARCHAR(100)  
   --SELECT @TEMPConsolidate1=PaymentStatus FROM #TariffSet   
   --WHERE BillType='Consolidate'  
     
   --IF ISNULL(@TEMPConsolidate1,'')='Paid'  
   --BEGIN   
   -- DELETE FROM #TariffSet   
   -- WHERE BillType!='Consolidate'  
   --END   
  
  
		SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
		FROM  #TariffSet
		
		--Name  
		  SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		  WHERE ChkInHdrId=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   
	        
	        
		  -- TARIFF FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND D.IsDeleted = 0   
		  AND H.ChkInHdrId = @CheckInHdrId  
		  -- SERVICE FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		  FROM WRBHBCheckOutServiceHdr H  
		  JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.ChkInHdrId=@CheckInHdrId  
		  -- CONSOLIDATE FOR ADD PAYMENTS  
		  SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND  
		  H.ChkInHdrId = @CheckInHdrId  
	        
	        
		  SELECT COUNT(*) AS UnPaid FROM  #TariffSet  WHERE PaymentStatus = 'UnPaid'  
		 
    END  
	 else-- for checkout done with flag 0  
 begin  
 
		SELECT Property,Stay,ChkOutTariffAdays  AS Tariff,  
		CONVERT(NVARCHAR(100),CheckOutDate,103) AS ChkoutDate,CONVERT(NVARCHAR(100),CheckInDate,103) AS CheckInDate  
		FROM WRBHBChechkOutHdr WHERE  Id=@CID and  IsActive=1 and IsDeleted=0 and Flag=0  

		--BillDate   
		SELECT CONVERT(VARCHAR(103),CheckOutDate ,103) AS BillDate   
		FROM WRBHBChechkOutHdr  WHERE   Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  

		--Type  
		SELECT GuestName AS Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr  
		WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  

		CREATE TABLE #PaymentMode1(TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100))  
		-- DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)  
  
  
		If @BookingLevel = 'Room'   
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode  
			  from WRBHBBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END  
		If @BookingLevel = 'Bed'  
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode   
			  from WRBHBBedBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END   
		If @BookingLevel = 'Apartment'  
		BEGIN  
			INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			select TariffPaymentMode,ServicePaymentMode   
			from WRBHBApartmentBookingPropertyAssingedGuest  
			where GuestId = @GuestId and BookingId = @BookingId  
		END  

		DECLARE @TariffPaymentModes nvarchar(100),@ServicePaymentModes nvarchar(100);  
		set @TariffPaymentModes =( SELECT top 1 TariffPaymentMode FROM #PaymentMode1)   
		set @ServicePaymentModes =( SELECT top 1 ServicePaymentMode FROM #PaymentMode1)  
		--SELECT ClientName,Direct,BTC,Id From  WRBHBCheckInHdr    
		--WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
    
		SELECT ClientName,@TariffPaymentModes as TariffPaymentMode,@ServicePaymentModes as ServicePaymentMode,  
		Id From  WRBHBCheckInHdr    
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
		--Day Count  
		CREATE TABLE #CountDays1(NoofDays INT,CheckInHdrId INT)  
		INSERT INTO #CountDays1(NoofDays,CheckInHdrId)  
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,  
		Id--,ArrivalDate  
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;  



		Select 0 as M;  

		Select NoOfDays from WRBHBChechkOutHdr  where  Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  

		select ChkOutTariffTotal NetTariff,ChkOutTariffLT LuxuryTax,  
		ChkOutTariffST1 ServiceTax,0 LT,0 ST  from WRBHBChechkOutHdr   
		where   Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  

		SELECT COUNT(Id) as Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId   
     
		SELECT COUNT(d.CheckOutHdrId) as Id2 from WRBHBChechkOutHdr h  
		join WRBHBCheckOutServiceHdr d on h.Id = d.CheckOutHdrId   
		where h.ChkInHdrId= @CheckInHdrId and h.  
		IsActive=1 and h.IsDeleted=0  
		SELECT Id from WRBHBChechkOutHdr   
		where Id=@CID and IsActive=1 and IsDeleted=0 and Flag=0  
		 
		select 1 as Tariff;--this is doubt value 
		 
		DECLARE @CheckOutId BIGINT;
		 
		 SELECT @CheckOutId=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 AND IsActive = 1 and IsDeleted = 0
		  
		CREATE TABLE #TariffSet1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId AND d.IsActive=1 AND d.IsDeleted=0 
		
	
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSetFinal(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet1
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffs(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CID AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CID AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
		
		DECLARE @TSCOUNT  INT;
		SELECT @TSCOUNT=COUNT(*) FROM  #Tariffs
        
        IF @TSCOUNT=2
        BEGIN
			INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffs  
			group by BillNo
		END
		
		
		update #Tariffs set NetAmount=isnull(d.NetAmount,0),OutStanding=(t.Amount-isnull(d.NetAmount,0)) 
		from #Tariffs t
		left outer Join  #TariffSetFinal d on t.BillType=d.BillType
		
		
		DECLARE @TARIFAMT11 DECIMAL(27,2),@SERVICEAMT11 DECIMAL(27,2)  
		SET @TARIFAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1 where BillType='Tariff')  
		SET @SERVICEAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1  where BillType='Service')  
		-- select @TARIFAMT11,@SERVICEAMT11  
		--update #TariffSet1 set  NetAmount = @TARIFAMT11  where BillType='Tariff' ;  
		--update #TariffSet1 set  NetAmount = @SERVICEAMT11  where BillType='Service' ;  

		--CREATE TABLE #TafFin(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
        
		--INSERT INTO #TafFin(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,isnull(T1.Amount,0) Amount, (ISNULL(T2.NetAmount,0)) NetAmount,  
		--ISNULL(T1.Amount,0)-(ISNULL(T2.NetAmount,0)) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffs T1  
		--LEFT   JOIN #TariffSet1 T2 ON T1.BillType=T2.BillType  
		--group by T1.BillNo,T1.BillType,T1.Amount,T2.NetAmount,T1.PaymentStatus  
		
        update #Tariffs set PaymentStatus='Paid'  
        where Amount=NetAmount;  
        
       
        
		DECLARE @TARIFAMT DECIMAL(27,2),@SERVICEAMT DECIMAL(27,2),@CONSOLIAMT DECIMAL(27,2)  
		SET @TARIFAMT=(SELECT OutStanding from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT=(SELECT OutStanding from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT=(SELECT OutStanding from #Tariffs  where BillType='Consolidate')  

		DECLARE @TARIFAMT1 DECIMAL(27,2),@SERVICEAMT1 DECIMAL(27,2),@CONSOLIAMT1 DECIMAL(27,2)  
		SET @TARIFAMT1=(SELECT NetAmount from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT1=(SELECT NetAmount from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT1=(SELECT NetAmount from #Tariffs  where BillType='Consolidate')  
        
     
           
		DELETE  FROM   #Tariffs  WHERE BillType='Consolidate'  
		and round((@TARIFAMT1+@SERVICEAMT1),0)!=0  

		DECLARE @TEMPConsolidate NVARCHAR(100),@Netamount1 decimal(27,2)  
		SELECT @TEMPConsolidate=PaymentStatus FROM #Tariffs   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate,'')='Paid'  
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END 

		SELECT @Netamount1=NetAmount FROM #Tariffs   
		WHERE BillType='Consolidate' 

		IF cast(ISNULL(@Netamount1,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END
		 
        SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id FROM #Tariffs; 
         
		 
		SELECT  Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CID AND IsActive=1 AND IsDeleted=0   
		GROUP BY Name

		-- TARIFF FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@TARIFAMT,0),0) AS ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND D.IsDeleted = 0 AND H.Id = @CID  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@SERVICEAMT,0),0) AS ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.Id=@CID;  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL( ROUND((@TARIFAMT+@SERVICEAMT),0),0) AS ConsolidateAmount 
		--FROM #Tariffs  
		--WHERE ROUND((@TARIFAMT+@SERVICEAMT),0)!=0  
		SELECT 1 AS UnPaid;    
		
		END  
	 END 	
END			
			 
		
	IF @Action='IMAGEUPLOAD'  
	BEGIN 
		UPDATE WRBHBChechkOutPaymentCompanyInvoice SET FileLoad=@Str1 
		WHERE Id=@CheckInHdrId ---CompanyInvoice Id IS IN @CheckInHdrId
	END 
	IF @Action='Print'
		BEGIN
	
		DECLARE @CheckOutId1 BIGINT;
		 
		 --SELECT @CheckOutId1=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 --AND IsActive = 1 and IsDeleted = 0
		
		  select @CheckOutId1=@CheckInHdrId
		  
		 
		  
		CREATE TABLE #TariffSet2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId1 AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId1 AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId1 AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId1 AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId1 AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSetFinal2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet2
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffsa(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckOutId1 AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckOutId1 AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
  
    
        DECLARE @TSCOUNT1  INT;
		SELECT @TSCOUNT1=COUNT(*) FROM  #Tariffsa
        
        IF @TSCOUNT1=2
        BEGIN
			INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffsa  
			group by BillNo
		END
		
		
		
		update #Tariffsa set NetAmount=d.NetAmount,OutStanding=(t.Amount-d.NetAmount) 
		from #Tariffsa t
		Join  #TariffSetFinal2 d on t.BillType=d.BillType 

		
		
		dECLARE @TARIFAMT111 DECIMAL(27,2),@SERVICEAMT111 DECIMAL(27,2)  
		SET @TARIFAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2 where BillType='Tariff')  
		SET @SERVICEAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2  where BillType='Service')  
		--select @TARIFAMT111,@SERVICEAMT111  
		update #TariffSet2 set  NetAmount = @TARIFAMT111  where BillType='Tariff' ;  
		update #TariffSet2 set  NetAmount = @SERVICEAMT111  where BillType='Service' ;  
   

		CREATE TABLE #TafFin1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,T1.Amount,ISNULL(T2.NetAmount,0) NetAmount,  
		--ISNULL(T1.Amount,0)-ISNULL(T2.NetAmount,0) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffsa T1  
		--left  outer  JOIN #TariffSet2 T2 ON T1.BillType=T2.BillType  
         
        
       
       
		--CREATE TABLE #TafFin22(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin22(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--select BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus   
		--from  #TafFin1 		
		--group by BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus ;  
		--  select * from #TafFin22  

		dECLARE @TARIFAMTs DECIMAL(27,2),@SERVICEAMTs DECIMAL(27,2)  
		SET @TARIFAMTs=(SELECT OutStanding from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMTs=(SELECT OutStanding from #Tariffsa  where BillType='Service')  
		

		dECLARE @TARIFAMT1s DECIMAL(27,2),@SERVICEAMT1s DECIMAL(27,2)  
		SET @TARIFAMT1s=(SELECT NetAmount from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMT1s=(SELECT NetAmount from #Tariffsa  where BillType='Service')  

		  
		   
		delete  from   #Tariffsa  where BillType='Consolidate'  
		and round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  

		DECLARE @TEMPConsolidate1 NVARCHAR(100),@Netamount decimal(27,2),@PamentMode Nvarchar(100)   
		SELECT @TEMPConsolidate1=PaymentStatus FROM #Tariffsa   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate1,'') = 'Paid'  
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END   
		
		SELECT @Netamount=sum(NetAmount) FROM #Tariffsa   
		WHERE BillType='Consolidate' 


		IF cast(ISNULL(@Netamount,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END  
		
		update #Tariffsa set PaymentStatus='Paid'  
		where Amount=@Netamount;
		   --select * from #TafFin22
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #Tariffs  
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #TariffSet1  
		
		Select  BillNo,BillType,Amount,SUM(NetAmount) NetAmount,Amount-SUM(NetAmount) OutStanding,PaymentStatus,
		0 AS Id from #Tariffsa
		group by BillNo,BillType,Amount,PaymentStatus
		
      --Name  
        
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE ChkInHdrId=@PropertyId AND IsActive=1 AND IsDeleted=0   

		-- TARIFF FOR ADD PAYMENTS   
		--@PropertyId(CheckOut Id Temp... send)  
		SELECT isnull(round(@TARIFAMTs,0),0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND D.IsDeleted = 0  
		AND H.Id = @PropertyId  

		-- SERVICE FOR ADD PAYMENTS  
		SELECT isnull(round(@SERVICEAMTs,0),0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.Id=@PropertyId;  
		-- CONSOLIDATE FOR ADD PAYMENTS  

		SELECT distinct isnull(round((@TARIFAMT1s+@SERVICEAMT1s),0),0) AS ConsolidateAmount 
		--from #TafFin22  
		--WHERE round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  
		
		    
	END	
		
IF @Action='Prints'  
  BEGIN   
		CREATE TABLE #Tariff1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
     
     
        -- CAST(ISNULL(KH.TotalAmount,0)as DECIMAL(27,2)) AS Amount  
           
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT  DISTINCT CH.CheckOutNo,'Service' AS BillType,round(ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckInHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  


		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT DISTINCT CO.CheckOutNo,'Consolidate' AS BillType,round(CO.ChkOutTariffNetAmount+CS.ChkOutServiceNetAmount,0) AS Amount,  
		0.00 AS NetAmount,  
		0.00 as OutStanding,'Unpaid' as PaymentStatus   
		FROM WRBHBChechkOutHdr CO  
		JOIN WRBHBCheckOutServiceHdr CS ON CO.Id=CS.CheckOutHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  
		WHERE CO.Id=@CheckInHdrId AND CO.IsActive=1 AND CO.IsDeleted=0;  

		SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
			 FROM  #Tariff1   
         
        
      --Name  
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   


		-- TARIFF FOR ADD PAYMENTS  
		SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND D.IsDeleted = 0   
		AND H.Id = @CheckInHdrId  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.Id=@CheckInHdrId  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND  
		H.Id = @CheckInHdrId  
        
        
  END   
  
  IF @Action='PaidUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,Flag = 1
	   WHERE ChkInHdrId = @CheckInHdrId 
	   --UPDATE WRBHBExternalChechkOutTAC set PaymentStatus = 'Paid'  
	   --WHERE ChkInHdrId = @CheckInHdrId  
  END   
IF @Action='ServiceUpdate'  
  BEGIN  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  
  END   
IF @Action='ConUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'UnPaid'  
	   WHERE ChkInHdrId = @CheckInHdrId  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'UnPaid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  END 
		



