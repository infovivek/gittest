-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExternalCheckoutTAC_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ExternalCheckoutTAC_Help]
GO 
-- ===============================================================================
-- Author: Shameem
-- Create date:09-07-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	External Check Out
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_ExternalCheckoutTAC_Help]
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
DECLARE @Cnt INT;
IF @Action='PageLoad'
	BEGIN
	SET @Cnt=(SELECT COUNT(*) FROM WRBHBExternalChechkOutTAC)
		IF @Cnt=0 BEGIN SELECT 1 AS TACInvoiceNo;
	END
	ELSE 
	BEGIN
	SELECT TOP 1 CAST(TACInvoiceNo AS INT)+1 AS TACInvoiceNo FROM WRBHBExternalChechkOutTAC
		ORDER BY Id DESC;
	END
	-- Room Level Property booked and direct booked (External Property)
	    
		select distinct A.PropertyId As PropertyId,(A.PropertyName+','+H.CityName+','+H.StateName) as PropertyName
		--,PU.UserId,P.Category
		FROM WRBHBBooking H
		join WRBHBBookingGuestDetails D on H.Id = D.BookingId AND D.IsActive = 1 and D.IsDeleted = 0
		join WRBHBBookingProperty A on d.BookingId= A.BookingId AND A.IsActive = 1 and A.IsDeleted = 0
		join WRBHBBookingPropertyAssingedGuest AG on D.BookingId= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
		join WRBHBProperty P on P.Id = A.PropertyId and P.IsActive = 1 and A.IsDeleted = 0
		join WRBHBPropertyUsers PU on PU.PropertyId = P.Id and PU.IsActive = 1 and PU.IsDeleted = 0
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0

		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0
		WHERE  H.Status IN('Booked','Direct Booked')  
		and H.Cancelstatus !='Canceled'
		and P.Category in ('External Property','Managed G H') 
		--and CONVERT(varchar(100),AG.ChkInDt,103) =  CONVERT(nvarchar(100),GETDATE(),103)
		
	--	and PU.UserId=@UserId 
		
		 -- Item Load
    
       SELECT (ProductName) as Item,Id
       FROM WRBHBContarctProductMaster		
       where IsActive = 1 and IsDeleted = 0
    END
    
If @Action = 'GuestName'
	BEGIN
		SELECT  GuestName,GuestId,StateId,Id AS CheckInHdrId,PropertyId,RoomId,ApartmentId,
		BookingId,BedId,Type as Level--PropertyId,Property--,PropertyType
		From WRBHBCheckInHdr
		WHERE IsActive=1 AND IsDeleted=0 AND 
	    PropertyId = @PropertyId and
		PropertyType in ('External Property','Managed G H') 
		--and 
	--	CONVERT(nvarchar(100),ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) and
	--	Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr  )
		 
		SELECT DISTINCT U.FirstName AS label,U.Id AS Data FROM WRBHBUser U
		JOIN WRBHBPropertyUsers P ON U.Id=P.UserId AND P.IsActive=1 AND P.IsDeleted=0
		WHERE P.UserType in ('Resident Managers','Assistant Resident Managers') AND 
		U.IsActive=1 AND U.IsDeleted=0 and P.PropertyId = @PropertyId
	END
	
	--select * from WRBHBBookingProperty
IF @Action='CHKINROOMDETAILS'
	BEGIN
	-- Check in date,check out date, payment mode
	CREATE TABLE #LEVEL(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
		TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100),TAC nvarchar(100))
		DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)
		
	If @BookingLevel = 'Room' 
	BEGIN
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode,TAC)
		select CONVERT(nvarchar(100),d.ChkInDt,103),CONVERT(nvarchar(100),d.ChkOutDt,103),
		d.TariffPaymentMode,d.ServicePaymentMode ,h.TAC
		from  WRBHBBookingProperty h 
		join WRBHBBookingPropertyAssingedGuest d on h.BookingId= d.BookingId
		where d.GuestId  = @GuestId and d.BookingId = @BookingId
	END
		DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100),@TariffPaymentMode nvarchar(100),
		@ServicePaymentMode nvarchar(100),@TAC Bit;
	    set @ChkInDate =( SELECT ChkInDate FROM #LEVEL)	
		set @ChkOutDate =( SELECT ChkOutDate FROM #LEVEL)
		set @TariffPaymentMode =(SELECT TariffPaymentMode FROM #LEVEL)
		set @ServicePaymentMode =(SELECT ServicePaymentMode FROM #LEVEL)
		set @TAC =(SELECT TAC from #LEVEL)
		
		 
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
		
		SELECT ClientName,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,
		Id From  WRBHBCheckInHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0
	--Day Count
		CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)
		INSERT INTO #CountDays (NoofDays,CheckInHdrId)
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,
		Id--,ArrivalDate
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;
		
		If @TariffPaymentMode ='Direct'
		BEGIN
		--	Tax Calculation in External Property 
		CREATE TABLE #ServiceTax(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT)
		
		CREATE TABLE #ServiceTax2(ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),Id BIGINT,
		DATE NVARCHAR(100))
		
		CREATE TABLE #ExTariff(Tariff DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),
		SingleMarkupAmount DECIMAL(27,2),DoubleMarkupAmount DECIMAL(27,2),
		Occupancy nvarchar(100),Date nvarchar(100),ServiceTax DECIMAL(27,2),BusinessSupportST DECIMAL(27,2))
		
		CREATE TABLE #FINALTAX(Tariff DECIMAL(27,2),Amount DECIMAL(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
		BusinessSupportST DECIMAL(27,2),ST DECIMAL(27,2),BST DECIMAL(27,2),NetAmount decimal(27,2))
		
		CREATE TABLE #FINAL(Tariff DECIMAL(27,2),Amount DECIMAL(27,2),Occupancy nvarchar(100),Date nvarchar(100),ServiceTax decimal(27,2),
		BusinessSupportST DECIMAL(27,2),ST DECIMAL(27,2),BST DECIMAL(27,2),NetAmount decimal(27,2))
		
		DECLARE @Occupancy nvarchar(100);
		SET @Occupancy=(select Occupancy from WRBHBCheckInHdr where Id = @CheckInHdrId)
		
-- Service Tax
		INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
		SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
		FROM WRBHBTaxMaster
		WHERE CONVERT(nvarchar(100),Date,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
		CONVERT(nvarchar(100),@ChkOutDate,103)		
		AND IsActive=1 AND IsDeleted=0 
		--AND StateId=@StateId
		
		INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
		SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
		FROM WRBHBTaxMaster
		WHERE CONVERT(nvarchar(100),DateTo,103) between CONVERT(nvarchar(100),@ChkInDate,103) and
		CONVERT(nvarchar(100),@ChkOutDate,103)		
		AND IsActive=1 AND IsDeleted=0 
		--AND StateId=@StateId
		
		INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
		SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
		FROM WRBHBTaxMaster
		WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),@ChkInDate,103)	
		AND IsActive=1 AND IsDeleted=0 
		--AND StateId=@StateId
		
		INSERT INTO #ServiceTax(ServiceTax,BusinessSupportST,FromDT,ToDT,Id)
		SELECT ISNULL(ServiceTaxOnTariff,0),ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),Id		
		FROM WRBHBTaxMaster
		WHERE CONVERT(nvarchar(100),@ChkOutDate,103)<= CONVERT(nvarchar(100),DateTo,103)		
		AND IsActive=1 AND IsDeleted=0 
		--AND StateId=@StateId
		
	--select * from #ExTariff
		DECLARE @Tariff DECIMAL(27,2),@RackTariffSingle decimal(27,2),@RackTariffDouble decimal(27,2),
		@SingleMarkupAmount DECIMAL(27,2),@DoubleMarkupAmount DECIMAL(27,2),@Dt1 DateTime ,@prtyId BIGINT,
		@chktime NVARCHAR(100),@TimeType NVARCHAR(100),@chkouttime NVARCHAR(100);
		DECLARE @DateDiff int,@i int,@HR NVARCHAR(100),@MIN INT,@OutPutSEC INT,@OutPutHour INT,
		@NoOfDays INT ;
		
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
		SELECT @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,@Tariff=Tariff,
		@RackTariffSingle=RackTariffSingle,@RackTariffDouble=RackTariffDouble,@SingleMarkupAmount = SingleMarkupAmount,
	    @DoubleMarkupAmount = DoubleMarkupAmount,@i=0,
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
		Select @DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60) 
	-- this is 12 hour Format	
		--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes 
		IF(UPPER(@TimeType)=UPPER('AM'))
		 BEGIN
			IF(CAST(@chktime AS TIME)<CAST('11:00:00' AS TIME))
			BEGIN
				SELECT @NoOfDays=@NoOfDays+1
				INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
				SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
				CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)
			--	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)
			END		 
		 END	
		 --GET AFTER 1 CL CHECKOUT TIME TARIFF ADD  AND ABOVE ONE HR TARIFF ADD  
		 IF(@OutPutHour>1)
		 BEGIN
			SELECT @NoOfDays=@NoOfDays+1
			INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
			SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
			CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		--	SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		 END	
		  --DAYS TARIFF ADD	
		 			
		 WHILE (@DateDiff>0)
		 BEGIN	
			SELECT @NoOfDays=@NoOfDays+1					
			INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
			SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
			CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
			--SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
			SET @i=@i+1
			SET @DateDiff=@DateDiff-1    
	--		Select @i,@DateDiff		
	     END
	      END		
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
				if (@NoOfDays =1)
				begin
					SELECT @NoOfDays=@NoOfDays 
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
				end
				else
				begin
					SELECT @NoOfDays=@NoOfDays +1
					INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
		--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)
				
				end
		    END
		    
		    --DAYS TARIFF ADD
	--	    select @NoOfDays,@DateDiff
			WHILE (@DateDiff>0)
			BEGIN	
				SELECT @NoOfDays=@NoOfDays+1				
				INSERT INTO #ExTariff(Tariff,RackTariffSingle,RackTariffDouble,SingleMarkupAmount,DoubleMarkupAmount,Occupancy,Date)
				SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,@SingleMarkupAmount,@DoubleMarkupAmount,@Occupancy,
				CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
	--			SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)
				SET @i=@i+1
				SET @DateDiff=@DateDiff-1			               
			END			
		END		
		IF @TAC='0'
		BEGIN
		--(Agreed TARIFF SINGLE)
		INSERT INTO #FINALTAX(Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,Date,ST,BST,NetAmount)
		SELECT d.Tariff,ISNULL(d.SingleMarkupAmount,0),isnull(d.Tariff*h.ServiceTax/100,0),
		isnull(d.SingleMarkupAmount*h.BusinessSupportST/100,0),d.Occupancy ,d.Date,h.ServiceTax,h.BusinessSupportST,
		ISNULL(d.SingleMarkupAmount,0)
		FROM #ServiceTax2 h
		join #ExTariff d on h.DATE = d.Date
		WHERE Occupancy ='Single' 
		
		--(Agreed TARIFF DOUBLE)
		INSERT INTO #FINALTAX(Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,Date,ST,BST,NetAmount)
		SELECT Tariff,ISNULL(d.DoubleMarkupAmount,0),isnull(d.Tariff*h.ServiceTax/100,0),
		isnull(d.SingleMarkupAmount*h.BusinessSupportST/100,0),d.Occupancy ,d.Date,h.ServiceTax,h.BusinessSupportST,
		ISNULL(d.DoubleMarkupAmount,0)
		FROM #ServiceTax2 h
		join #ExTariff d on h.DATE = d.Date
		WHERE Occupancy ='Double'
		END
		ELSE
		BEGIN
		--(RACK TARIFF SINGLE)
		INSERT INTO #FINALTAX(Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,Date,ST,BST,NetAmount)
		SELECT Tariff,ISNULL(d.Tariff-d.RackTariffSingle,0),isnull(d.Tariff*h.ServiceTax/100,0),
		isnull(d.Tariff*d.BusinessSupportST/100,0),d.Occupancy ,d.Date,h.ServiceTax,h.BusinessSupportST,
		ISNULL(d.Tariff-d.RackTariffSingle,0)
		FROM #ServiceTax2 h
		join #ExTariff d on h.DATE = d.Date
		WHERE Occupancy ='Single' 
		
		--(RACK TARIFF DOUBLE)
		INSERT INTO #FINALTAX(Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,Date,ST,BST,NetAmount)
		SELECT Tariff,ISNULL(d.Tariff-d.RackTariffDouble,0),isnull(d.Tariff*h.ServiceTax/100,0),
		isnull(d.Tariff*d.BusinessSupportST/100,0),d.Occupancy ,d.Date,h.ServiceTax,h.BusinessSupportST,
		ISNULL(d.Tariff-d.RackTariffDouble,0)
		FROM #ServiceTax2 h
		join #ExTariff d on h.DATE = d.Date
		WHERE Occupancy ='Double'
		end
		
		INSERT INTO #FINAL(Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,ST,BST,NetAmount)
		SELECT sum(isnull(Tariff,0)),(isnull(Amount,0)),sum(isnull(ServiceTax,0)),
		sum(isnull(BusinessSupportST,0)),Occupancy,ST,BST,sum(ISNULL(NetAmount,0))
		FROM #FINALTAX
		GROUP BY Tariff,Amount,ServiceTax,BusinessSupportST,Occupancy,ST,BST,NetAmount
		
		SELECT @NoOfDays as NoofDays --FROM #Tariff
		SELECT TARIFF as NetTariff,Amount,ServiceTax,BusinessSupportST,Occupancy,ST,BST,NetAmount FROM #FINAL
    END
END

END


