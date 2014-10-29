SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_MapVendorandPO_Report') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_MapVendorandPO_Report
GO 

CREATE PROCEDURE Sp_MapVendorandPO_Report
(
@Action			NVARCHAR(100)=NULL,	
@PropertyId		BIGINT,
@FromDate		NVARCHAR(100)=NULL,
@ToDate			NVARCHAR(100)=NULL,
@Param1			NVARCHAR(100)=NULL,
@Param2			BIGINT =NULL,
@UserId			BIGINT	
)
AS 
BEGIN 
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
--VENDOR SETTLEMENT 
IF @Action ='PropertySearch'
BEGIN
	CREATE TABLE #InvoiceData(checks BIT,InvoiceNo NVARCHAR(100),InvoiceDate NVARCHAR(100),
	InvoiceAmount DECIMAL(27,2),Status NVARCHAR(100),POCount NVARCHAR(100),InvoiceId BIGINT,
	Adjusment DECIMAL(27,2))
	
	CREATE TABLE #InvoiceDataAdjusment(InvoiceAmount DECIMAL(27,2),InvoiceId BIGINT,
	Adjusment DECIMAL(27,2))
	
	CREATE TABLE #TACInvoiceData(checks BIT,TACInvoiceNo NVARCHAR(100),BillDate NVARCHAR(100),Total DECIMAL(27,2),
	TACAmount DECIMAL(27,2),TotalBusinessSupportST DECIMAL(27,2),TACId BIGINT,Adjusment DECIMAL(27,2),
	AdjusementAmount DECIMAL(27,2))
	
	CREATE TABLE #TACInvoiceDataAdjusment(InvoiceAmount DECIMAL(27,2),TACId BIGINT,
	Adjusment DECIMAL(27,2))
	
	CREATE TABLE #AdvanceAmount(AdvanceAmount DECIMAL(27,2),Id BIGINT,AdjusmentAmount DECIMAL(27,2))
	
	CREATE TABLE #AdvanceAdjusment(AdvanceAmount DECIMAL(27,2),Id BIGINT,AdjusmentAmount DECIMAL(27,2))
	
	----ADJUSTMENT AMOUNT TAKE
	--INSERT INTO #InvoiceDataAdjusment(InvoiceAmount,InvoiceId,Adjusment)
	--SELECT SUM(InvoiceAmount),InvoiceId,SUM(Adjusment) FROM WRBHBVendorSettlementInvoiceAmount
	--GROUP BY InvoiceId
	
	
	
	--MAP INVOICE AMOUNT TAKE
	INSERT INTO #InvoiceData(checks ,InvoiceNo,InvoiceDate,InvoiceAmount,Status,POCount,InvoiceId,
	Adjusment)
	SELECT 0 checks,InvoiceNo,CONVERT(NVARCHAR,InvoiceDate,103) InvoiceDate,InvoiceAmount,'UnPaid' Status,
	COUNT(D.Id) POCount,H.Id InvoiceId,0 Adjusment
	FROM WRBHBMapPOAndVendorPaymentHdr H
	JOIN WRBHBMapPOAndVendorPaymentDtls D WITH(NOLOCK) ON H.Id=D.MapPOAndVendorPaymentHdrId
	AND D.IsActive=1 AND D.IsDeleted=0 
	WHERE H.IsActive=1 AND H.IsDeleted=0 AND H.PropertyId=@PropertyId
	AND H.Id NOT IN(SELECT InvoiceId FROM WRBHBVendorSettlementInvoiceAmount S WHERE S.IsActive=1 AND S.IsDeleted=0) 
	GROUP BY InvoiceNo,InvoiceDate,InvoiceAmount,H.Id
	
	
	----ALREAY ADJUSMENT AMOUNT UBDATE
	--UPDATE #InvoiceData SET InvoiceAmount=A.InvoiceAmount-S.Adjusment
	--FROM #InvoiceData A 
	--JOIN #InvoiceDataAdjusment S ON A.InvoiceId=S.InvoiceId 
	
	
	SELECT checks ,InvoiceNo,InvoiceDate,InvoiceAmount,Status,POCount,InvoiceId,
	Adjusment,0 PaidAmount FROM #InvoiceData
	 
	
	
	--GET TAC AMOUNT	
	INSERT INTO #TACInvoiceData(checks,TACInvoiceNo,BillDate,Total,TACAmount,TotalBusinessSupportST,TACId,Adjusment,
	AdjusementAmount)
	SELECT  0 checks,TACInvoiceNo,CONVERT(NVARCHAR,BillDate,103) BillDate,TACAmount Total,NoOfDays*Rate TACAmount,
	TotalBusinessSupportST,Id TACId,0 Adjusment,TACAmount AdjusementAmount
	FROM WRBHBExternalChechkOutTAC H
	WHERE TACInvoiceNo!='0' AND TACAmount!=0 AND ISNULL(SettlementFlag,0)=0 AND 
	PropertyType='External Property' AND PropertyId=@PropertyId
	
	--GET TAC ADJUSEMENT AMOUNT 
	INSERT INTO #TACInvoiceDataAdjusment(InvoiceAmount,TACId,Adjusment)
	SELECT SUM(A.Total),A.TACId,SUM(A.Adjusment) FROM WRBHBVendorSettlementTACInvoiceAmount A
	JOIN #TACInvoiceData S ON A.TACId=S.TACId
	GROUP BY A.TACId
	
	--ALREAY ADJUSMENT AMOUNT UBDATE
	UPDATE #TACInvoiceData SET AdjusementAmount=A.AdjusementAmount-S.Adjusment
	FROM #TACInvoiceData A 
	JOIN #TACInvoiceDataAdjusment S ON A.TACId=S.TACId 
	
	
	SELECT checks,TACInvoiceNo,BillDate,Total,TACAmount,TotalBusinessSupportST,TACId,Adjusment,
	AdjusementAmount FROM #TACInvoiceData
	
	--ADVANCE AMOUNT TAKEN
	INSERT INTO #AdvanceAmount(AdvanceAmount,Id,AdjusmentAmount)
	SELECT AdvanceAmount,Id,0 AdjusmentAmount FROM WRBHBVendorAdvancePayment
	WHERE IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	AND ISNULL(SettlementFlag,0)=0
	
	INSERT INTO #AdvanceAdjusment(Id,AdjusmentAmount)
	SELECT VendorAdvancePaymentId,SUM(AdjusementAmount) FROM WRBHBVendorSettlementAdjusmentAdvanceAmount A
	JOIN #AdvanceAmount S ON S.Id=A.VendorAdvancePaymentId
	GROUP BY VendorAdvancePaymentId
	
	--UPDATE ADJUSEMENT ADVANCE
	UPDATE #AdvanceAmount SET AdvanceAmount=A.AdvanceAmount-S.AdjusmentAmount
	FROM #AdvanceAmount A 
	JOIN #AdvanceAdjusment S ON A.Id=S.Id 
	
	SELECT AdvanceAmount,Id,0 AdjusmentAmount FROM #AdvanceAmount
	
	SELECT SUM(ISNULL(AdvanceAmount,0)) AdvanceAmount FROM #AdvanceAmount
	
END
IF @Action ='Property'
BEGIN
	SELECT PropertyName,Id ZId FROM  WRBHBProperty 
	WHERE Category='External Property' AND IsDeleted=0 AND IsActive=1
	
	SELECT ClientName,Id ZId FROM  dbo.WRBHBClientManagement 
	WHERE IsDeleted=0 AND IsActive=1
	
END
IF @Action ='POSerch'
BEGIN
	CREATE TABLE #InvoicDateCheckout(checks BIT,PONo NVARCHAR(100),GuestName NVARCHAR(100),StayDuration NVARCHAR(100),
	BookingCode NVARCHAR(100),POAmount DECIMAL(27,2),CheckOutId BIGINT,BookingId BIGINT,
	Flag Bit,TID INT PRIMARY KEY IDENTITY(1,1),GuestId INT )
	
	CREATE TABLE #InvoicDateBooking(PONo NVARCHAR(100),GuestName NVARCHAR(100),StayDuration NVARCHAR(100),
	BookingCode NVARCHAR(100),POAmount DECIMAL(27,2),BookingId BIGINT,GuestId BIGINT,
	CheckInDt NVARCHAR(100),CheckOutDT NVARCHAR(100),
	Flag Bit,TID INT PRIMARY KEY IDENTITY(1,1))
	
	CREATE TABLE #InvoicDate(PONo NVARCHAR(100),GuestName NVARCHAR(100),StayDuration NVARCHAR(100),
	BookingCode NVARCHAR(100),POAmount DECIMAL(27,2),BookingId BIGINT,GuestId BIGINT,
	CheckInDt NVARCHAR(100),CheckOutDT NVARCHAR(100),
	Flag Bit,TID INT PRIMARY KEY IDENTITY(1,1),Tariff DECIMAL(27,2),NoOfDaysCount INT)
	
	CREATE TABLE #InvoicDateFinal(PONo NVARCHAR(100),GuestName NVARCHAR(100),StayDuration NVARCHAR(100),
	BookingCode NVARCHAR(100),POAmount DECIMAL(27,2),BookingId BIGINT,GuestId BIGINT,
	CheckInDt NVARCHAR(100),CheckOutDT NVARCHAR(100),checks BIT,CheckOutStayDuration NVARCHAR(100),
	Flag Bit,TID INT PRIMARY KEY IDENTITY(1,1),Tariff DECIMAL(27,2),NoOfDaysCount INT,BillAmount DECIMAL(27,2),
	CheckOutId BIGINT,MapPOAndVendorPaymentDtlsId BIGINT,Adjustment DECIMAL(27,2),OrderData NVARCHAR(100))
	
	CREATE TABLE #InvoicDateAdjusment(PONo NVARCHAR(100),GuestName NVARCHAR(100),StayDuration NVARCHAR(100),
	BookingCode NVARCHAR(100),POAmount DECIMAL(27,2),BookingId BIGINT,GuestId BIGINT,
	CheckInDt NVARCHAR(100),CheckOutDT NVARCHAR(100),checks BIT,CheckOutStayDuration NVARCHAR(100),
	Flag Bit,TID INT PRIMARY KEY IDENTITY(1,1),Tariff DECIMAL(27,2),NoOfDaysCount INT,BillAmount DECIMAL(27,2),
	CheckOutId BIGINT,MapPOAndVendorPaymentDtlsId BIGINT,Adjustment DECIMAL(27,2),OrderData NVARCHAR(100))
	
	--checkout PO amount
	INSERT INTO #InvoicDateCheckout(checks,PONo,GuestName,StayDuration,BookingCode,POAmount,CheckOutId,BookingId,
	Flag,GuestId)
	SELECT 0 checks,B.PONo PONo,G.FirstName GuestName,H.Stay StayDuration,B.BookingCode BookingCode,
	H.ChkOutTariffTotal POAmount,H.Id CheckOutId,B.Id BookingId,0,H.GuestId
	FROM  WRBHBChechkOutHdr H
	JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0
	JOIN dbo.WRBHBBookingPropertyAssingedGuest  G WITH(NOLOCK) ON B.Id=G.BookingId AND H.GuestId=G.GuestId
	AND H.PropertyId=G.BookingPropertyId AND G.IsActive=1 AND G.IsDeleted=0 AND
	CONVERT(DATE,G.ChkOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
	JOIN dbo.WRBHBBookingProperty  P WITH(NOLOCK) ON P.BookingId=B.Id AND
	P.Id=G.BookingPropertyTableId AND P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType='ExP'
	WHERE H.IsDeleted=0 AND H.IsActive=1 AND H.PropertyId=@PropertyId AND
	ISNULL(InVoiceNo,'')!='' AND
	H.Id NOT  IN(SELECT CheckOutId FROM WRBHBMapPOAndVendorPaymentDtls WHERE IsActive=1 AND IsDeleted=0
	AND (POAmount-Adjustment)=0 )
	GROUP BY B.PONo,G.FirstName,H.Stay,B.BookingCode,H.ChkOutTariffTotal,H.Id,B.Id,h.GuestId	
	ORDER BY H.Id ASC
	
	
	--BOOKING TARIFF AMOUNT
	INSERT INTO #InvoicDateBooking(GuestName,POAmount,BookingId,GuestId,
	CheckInDt,CheckOutDT,Flag)
	SELECT G.FirstName,G.Tariff,G.BookingId,G.GuestId,
	CONVERT(NVARCHAR,G.ChkInDt,103),CONVERT(NVARCHAR,G.ChkOutDt,103),0
	FROM #InvoicDateCheckout B
	JOIN dbo.WRBHBBookingPropertyAssingedGuest  G WITH(NOLOCK) ON B.BookingId=G.BookingId 
	AND G.IsActive=1 AND G.IsDeleted=0 AND G.GuestId=B.GuestId
	
	
	
	DECLARE @COUNT INT,@CheckInDT NVARCHAR(100),@CheckOutDT NVARCHAR(100),@TID INT,
	@BookingId INT,@Tariff DECIMAL(27,2)
	
	SELECT @COUNT=COUNT(*) FROM #InvoicDateBooking WHERE Flag=0
	
	SELECT TOP 1 @BookingId=BookingId,@Tariff=POAmount
	FROM  #InvoicDateBooking 
	WHERE Flag=0 
	ORDER BY TID ASC
		
	WHILE @COUNT>0
	BEGIN
		SELECT TOP 1 @CheckInDT=CheckInDt
		FROM  #InvoicDateBooking 
		WHERE Flag=0 AND BookingId=@BookingId
		ORDER BY TID ASC
		
		SELECT TOP 1 @CheckOutDT=CheckOutDT
		FROM  #InvoicDateBooking 
		WHERE Flag=0 AND BookingId=@BookingId
		ORDER BY TID DESC 
		
		
		INSERT INTO #InvoicDate(POAmount,BookingId,StayDuration,NoOfDaysCount,Tariff)
		
		SELECT DATEDIFF(day, CONVERT(DATE,@CheckInDT,103), CONVERT(DATE,@CheckOutDT,103))* @Tariff,
		@BookingId,@CheckInDT+' To '+@CheckOutDT,
		DATEDIFF(day, CONVERT(DATE,@CheckInDT,103),CONVERT(DATE,@CheckOutDT,103)),
		@Tariff
		
		UPDATE #InvoicDateBooking SET Flag=1 WHERE BookingId=@BookingId
		
		SELECT @COUNT=COUNT(*) FROM #InvoicDateBooking WHERE Flag=0
		
		SELECT TOP 1 @BookingId=BookingId,@Tariff=POAmount
		FROM  #InvoicDateBooking 
		WHERE Flag=0 
		ORDER BY TID ASC
	
	END
	
	INSERT INTO #InvoicDateFinal(checks,PONo,GuestName,StayDuration,CheckOutStayDuration,BookingCode,POAmount,
	BillAmount,CheckOutId,BookingId,GuestId,MapPOAndVendorPaymentDtlsId,Adjustment,OrderData)
	SELECT 0 checks,B.PONo PONo,B.GuestName,G.StayDuration,B.StayDuration,B.BookingCode BookingCode,
	G.POAmount POAmount,B.POAmount BillAmount,B.CheckOutId,B.BookingId,B.GuestId,0,0,'Z'
	FROM #InvoicDateCheckout B
	JOIN #InvoicDate  G WITH(NOLOCK) ON B.BookingId=G.BookingId
	
	
	--ADJUSEMENT AMOUT TAKEN REMAINING AMOUNT
	INSERT INTO #InvoicDateAdjusment(checks,PONo,GuestName,StayDuration,CheckOutStayDuration,BookingCode,POAmount,
	BillAmount,CheckOutId,BookingId,GuestId,MapPOAndVendorPaymentDtlsId,Adjustment,OrderData)	
	SELECT 0,PONo,GuestName,StayDuration,'',BookingCode,0,0,CheckOutId,
	BookingId,0,0,SUM(Adjustment),'A'
	FROM WRBHBMapPOAndVendorPaymentDtls
	WHERE (POAmount-Adjustment)!=0 AND Adjustment!=0
	GROUP BY PONo,GuestName,StayDuration,BookingCode,CheckOutId,
	BookingId	
	
	--UPDATE ADJUSEMENT AMOUT
	UPDATE #InvoicDateFinal SET Adjustment = A.Adjustment
	FROM #InvoicDateAdjusment A 
	JOIN #InvoicDateFinal S ON S.CheckOutId=A.CheckOutId
	
	SELECT checks,PONo,GuestName,StayDuration,CheckOutStayDuration,BookingCode,POAmount-Adjustment POAmount,
	BillAmount-Adjustment BillAmount,CheckOutId,BookingId,GuestId,MapPOAndVendorPaymentDtlsId,Adjustment
	FROM #InvoicDateFinal	
	ORDER BY OrderData
	
	
END
IF @Action ='IMAGEUPLOAD'
BEGIN
	 UPDATE WRBHBMapPOAndVendorPaymentHdr SET FilePath=@Param1 WHERE Id=@Param2	
END
IF @Action ='ExternalInvoice'
BEGIN   
		CREATE TABLE #ExternalDate(BookingDate NVARCHAR(100),BillNumber NVARCHAR(100),PropertyName NVARCHAR(100),
		CompanyName NVARCHAR(100),GuestName NVARCHAR(100),BillStartDate NVARCHAR(100),
		BillEndDate NVARCHAR(100),NoOFDays BIGINT,Tariff DECIMAL(27,2),MarkUpTotalTariff DECIMAL(27,2),
		ServiceTax DECIMAL(27,2),VendorTariff DECIMAL(27,2),VendorTotal DECIMAL(27,2),DifferanceAmount DECIMAL(27,2),
		PropertyId BIGINT,ClientId BIGINT,VendorInvoiceNo NVARCHAR(100),ModeOfPayment NVARCHAR(100),
		PaymentStatus NVARCHAR(100),CheckOutHdrId BIGINT,InvoiceId BIGINT)	
		
		CREATE TABLE #ExternalDateFinal(BookingDate NVARCHAR(100),BillNumber NVARCHAR(100),PropertyName NVARCHAR(100),
		CompanyName NVARCHAR(100),GuestName NVARCHAR(100),BillStartDate NVARCHAR(100),
		BillEndDate NVARCHAR(100),NoOFDays BIGINT,Tariff DECIMAL(27,2),MarkUpTotalTariff DECIMAL(27,2),
		ServiceTax DECIMAL(27,2),VendorTariff DECIMAL(27,2),VendorTotal DECIMAL(27,2),DifferanceAmount DECIMAL(27,2),
		PropertyId BIGINT,ClientId BIGINT,PID INT PRIMARY KEY IDENTITY(1,1),TotalHBAmount DECIMAL(27,2),
		VendorInvoiceNo NVARCHAR(100),ModeOfPayment NVARCHAR(100),PaymentStatus NVARCHAR(100),CheckOutHdrId BIGINT)	
		
		DECLARE @CountTotal INT;
		
		INSERT INTO #ExternalDate(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
		BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
		PropertyId,ClientId,CheckOutHdrId,PaymentStatus)
		
		SELECT CONVERT(NVARCHAR,H.CreatedDate,110) BookingDate,H.InVoiceNo BillNumber,PP.PropertyName,
		C.ClientName,G.FirstName GuestName,CONVERT(NVARCHAR,CONVERT(DATE,H.CheckInDate,103),110) BillFromDate,
		CONVERT(NVARCHAR,CONVERT(DATE,H.CheckOutDate,103),110) BillEndDate,
		H.NoOFDays,G.Tariff,H.NoOFDays*G.Tariff ,H.ChkOutTariffST1+H.ChkOutTariffST3+
		H.ChkOutTariffCess+H.ChkOutTariffHECess ServiceTax,P.SingleTariff AggredTariff,
		P.SingleTariff*H.NoOFDays AggredTariffTotal,
		(H.NoOFDays*G.Tariff)-(P.SingleTariff*H.NoOFDays) DiffreanceAmount,PP.Id,C.Id,H.Id,'Payment Yet to Receive'   
		FROM  WRBHBChechkOutHdr H
		JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN dbo.WRBHBBookingPropertyAssingedGuest  G WITH(NOLOCK) ON B.Id=G.BookingId AND H.GuestId=G.GuestId
		AND H.PropertyId=G.BookingPropertyId AND G.IsActive=1 AND G.IsDeleted=0 AND
		CONVERT(DATE,G.ChkOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
		JOIN dbo.WRBHBBookingProperty  P WITH(NOLOCK) ON P.BookingId=B.Id AND
		P.Id=G.BookingPropertyTableId AND P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType='ExP'
		JOIN WRBHBProperty PP WITH(NOLOCK) ON PP.Id=H.PropertyId AND PP.IsActive=1 AND PP.IsDeleted=0 
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0 
		WHERE H.IsDeleted=0 AND H.IsActive=1 AND G.Occupancy='Single'
		ORDER BY H.Id ASC
		
		
		
		INSERT INTO #ExternalDate(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
		BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
		PropertyId,ClientId,CheckOutHdrId,PaymentStatus)
		SELECT CONVERT(NVARCHAR,H.CreatedDate,110) BookingDate,H.InVoiceNo BillNumber,PP.PropertyName,
		C.ClientName,G.FirstName GuestName,CONVERT(NVARCHAR,CONVERT(DATE,H.CheckInDate,103),110) BillFromDate,
		CONVERT(NVARCHAR,CONVERT(DATE,H.CheckOutDate,103),110) BillEndDate,
		H.NoOFDays,G.Tariff,H.NoOFDays*G.Tariff,H.ChkOutTariffST1+H.ChkOutTariffST3+
		H.ChkOutTariffCess+H.ChkOutTariffHECess ServiceTax,P.DoubleTariff AggredTariff,
		P.DoubleTariff*H.NoOFDays AggredTariffTotal,
		(H.NoOFDays*G.Tariff)-(P.DoubleTariff*H.NoOFDays) DiffreanceAmount,PP.Id,C.Id,H.Id,'Payment Yet to Receive'      
		FROM  WRBHBChechkOutHdr H
		JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN dbo.WRBHBBookingPropertyAssingedGuest  G WITH(NOLOCK) ON B.Id=G.BookingId AND H.GuestId=G.GuestId
		AND H.PropertyId=G.BookingPropertyId AND G.IsActive=1 AND G.IsDeleted=0 AND
		CONVERT(DATE,G.ChkOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
		JOIN dbo.WRBHBBookingProperty  P WITH(NOLOCK) ON P.BookingId=B.Id AND
		P.Id=G.BookingPropertyTableId AND P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType='ExP'
		JOIN WRBHBProperty PP WITH(NOLOCK) ON PP.Id=H.PropertyId AND PP.IsActive=1 AND PP.IsDeleted=0 
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0 
		WHERE H.IsDeleted=0 AND H.IsActive=1 AND G.Occupancy='Double'
		ORDER BY H.Id ASC
		
		
		INSERT INTO #ExternalDate(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
		BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
		PropertyId,ClientId,CheckOutHdrId,PaymentStatus)
		SELECT CONVERT(NVARCHAR,H.CreatedDate,110) BookingDate,H.InVoiceNo BillNumber,PP.PropertyName,
		C.ClientName,G.FirstName GuestName,CONVERT(NVARCHAR,CONVERT(DATE,H.CheckInDate,103),110) BillFromDate,
		CONVERT(NVARCHAR,CONVERT(DATE,H.CheckOutDate,103),110) BillEndDate,
		H.NoOFDays,G.Tariff,H.NoOFDays*G.Tariff,H.ChkOutTariffST1+H.ChkOutTariffST3+
		H.ChkOutTariffCess+H.ChkOutTariffHECess ServiceTax,P.TripleTariff AggredTariff,
		P.TripleTariff*H.NoOFDays AggredTariffTotal,
		(H.NoOFDays*G.Tariff)-(P.TripleTariff*H.NoOFDays) DiffreanceAmount,PP.Id,C.Id,H.Id,'Payment Yet to Receive'      
		FROM  WRBHBChechkOutHdr H
		JOIN WRBHBBooking B WITH(NOLOCK) ON B.Id=H.BookingId AND B.IsActive=1 AND B.IsDeleted=0
		JOIN dbo.WRBHBBookingPropertyAssingedGuest  G WITH(NOLOCK) ON B.Id=G.BookingId AND H.GuestId=G.GuestId
		AND H.PropertyId=G.BookingPropertyId AND G.IsActive=1 AND G.IsDeleted=0 AND
		CONVERT(DATE,G.ChkOutDt,103) BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103)
		JOIN dbo.WRBHBBookingProperty  P WITH(NOLOCK) ON P.BookingId=B.Id AND
		P.Id=G.BookingPropertyTableId AND P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType='ExP'
		JOIN WRBHBProperty PP WITH(NOLOCK) ON PP.Id=H.PropertyId AND PP.IsActive=1 AND PP.IsDeleted=0 
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id=B.ClientId AND C.IsActive=1 AND C.IsDeleted=0 
		WHERE H.IsDeleted=0 AND H.IsActive=1 AND G.Occupancy='Triple'
		ORDER BY H.Id ASC
		
		--TAC NO UPDATE
		UPDATE #ExternalDate SET BillNumber=TACInvoiceNo FROM  #ExternalDate H
		JOIN WRBHBExternalChechkOutTAC D ON H.CheckOutHdrId=D.ChkOutHdrId
		WHERE BillNumber='0'		
		
		--PAYMENT MODE UPDATE
		UPDATE #ExternalDate SET ModeOfPayment=ISNULL(BTC,'') FROM  #ExternalDate H
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId=D.Id 	
		
		
		--PAYMENT MODE UPDATE
		UPDATE #ExternalDate SET ModeOfPayment=ISNULL(Direct,'') FROM  #ExternalDate H
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId=D.Id AND ISNULL(ModeOfPayment,'')=''
		
		
		--VENDOR INVOICE NO UPDATE
		UPDATE #ExternalDate SET VendorInvoiceNo=ISNULL(H1.InvoiceNo,''),InvoiceId=H1.Id FROM  #ExternalDate H
		JOIN WRBHBMapPOAndVendorPaymentDtls D ON H.CheckOutHdrId=D.CheckOutId
		JOIN dbo.WRBHBMapPOAndVendorPaymentHdr H1 ON H1.Id=D.MapPOAndVendorPaymentHdrId
		
		--PAYMENT  UPDATE
		UPDATE #ExternalDate SET PaymentStatus='Payment Received' FROM  #ExternalDate H
		JOIN dbo.WRBHBVendorSettlementInvoiceAmount D ON H.InvoiceId=D.InvoiceId
		
		
		IF @Param1='All'
		BEGIN
		
			INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
			BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
			PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
			SELECT ISNULL(BookingDate,'') BookingDate,ISNULL(BillNumber,'') BillNumber,ISNULL(PropertyName,'') PropertyName,
			ISNULL(CompanyName,'')CompanyName,ISNULL(GuestName,'')GuestName,ISNULL(BillStartDate,'')BillStartDate,
			ISNULL(BillEndDate,'') BillEndDate,ISNULL(NoOFDays,0) NoOFDays,ISNULL(Tariff,0) Tariff,
			ISNULL(MarkUpTotalTariff,0) MarkUpTotalTariff,ISNULL(ServiceTax,0) ServiceTax,
			ISNULL(VendorTariff,0) VendorTariff,ISNULL(VendorTotal,0) VendorTotal,
			ISNULL(DifferanceAmount,0) DifferanceAmount,
			PropertyId,ClientId,ISNULL(ServiceTax,0)+ISNULL(MarkUpTotalTariff,0),
			ISNULL(ModeOfPayment,''),ISNULL(VendorInvoiceNo,''),PaymentStatus 
			FROM #ExternalDate
			WHERE BillNumber NOT IN('0','')
			
			SELECT @CountTotal=COUNT(* ) FROM #ExternalDateFinal
		
			IF @CountTotal!=0
			BEGIN
				INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
				BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
				PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
				
				SELECT 'Total','','','','','','',SUM(NoOFDays),SUM(Tariff),SUM(MarkUpTotalTariff),SUM(ServiceTax),
				SUM(VendorTariff),SUM(VendorTotal),SUM(DifferanceAmount),0,0,SUM(TotalHBAmount),'','',''
				FROM #ExternalDateFinal
			END
			
			SELECT BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
			BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
			PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus FROM #ExternalDateFinal
			
			SELECT TOP 1 MarkUpTotalTariff,DifferanceAmount,DifferanceAmount/MarkUpTotalTariff*100 PER
			FROM #ExternalDateFinal
			ORDER BY PID DESC
					
		END
		ELSE
		BEGIN		
			IF @PropertyId !=0
			BEGIN
				INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
				BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
				PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
				SELECT ISNULL(BookingDate,'') BookingDate,ISNULL(BillNumber,'') BillNumber,ISNULL(PropertyName,'') PropertyName,
				ISNULL(CompanyName,'')CompanyName,ISNULL(GuestName,'')GuestName,ISNULL(BillStartDate,'')BillStartDate,
				ISNULL(BillEndDate,'') BillEndDate,ISNULL(NoOFDays,0) NoOFDays,ISNULL(Tariff,0) Tariff,
				ISNULL(MarkUpTotalTariff,0) MarkUpTotalTariff,ISNULL(ServiceTax,0) ServiceTax,
				ISNULL(VendorTariff,0) VendorTariff,ISNULL(VendorTotal,0) VendorTotal,
				ISNULL(DifferanceAmount,0) DifferanceAmount,
				PropertyId,ClientId ,ISNULL(ServiceTax,0)+ISNULL(MarkUpTotalTariff,0),
				ISNULL(ModeOfPayment,''),ISNULL(VendorInvoiceNo,''),PaymentStatus  
				FROM #ExternalDate WHERE PropertyId=@PropertyId
				AND  BillNumber NOT IN('0','')
				
				SELECT @CountTotal=COUNT(* ) FROM #ExternalDateFinal
		
				IF @CountTotal!=0
				BEGIN
					INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
					BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
					PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
					SELECT 'Total','','','','','','',SUM(NoOFDays),SUM(Tariff),SUM(MarkUpTotalTariff),SUM(ServiceTax),SUM(VendorTariff),
					SUM(VendorTotal),SUM(DifferanceAmount),0,0,SUM(TotalHBAmount),'','',''
					FROM #ExternalDateFinal
				END
				SELECT BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
				BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
				PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus
				FROM #ExternalDateFinal
				
				SELECT TOP 1 MarkUpTotalTariff,DifferanceAmount,DifferanceAmount/MarkUpTotalTariff*100 PER
				FROM #ExternalDateFinal
				ORDER BY PID DESC
			
			END		
			IF @Param2 !=0
			BEGIN
				INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
				BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
				PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
				SELECT ISNULL(BookingDate,'') BookingDate,ISNULL(BillNumber,'') BillNumber,ISNULL(PropertyName,'') PropertyName,
				ISNULL(CompanyName,'')CompanyName,ISNULL(GuestName,'')GuestName,ISNULL(BillStartDate,'')BillStartDate,
				ISNULL(BillEndDate,'') BillEndDate,ISNULL(NoOFDays,0) NoOFDays,ISNULL(Tariff,0) Tariff,
				ISNULL(MarkUpTotalTariff,0) MarkUpTotalTariff,ISNULL(ServiceTax,0) ServiceTax,
				ISNULL(VendorTariff,0) VendorTariff,ISNULL(VendorTotal,0) VendorTotal,
				ISNULL(DifferanceAmount,0) DifferanceAmount,
				PropertyId,ClientId,ISNULL(ServiceTax,0)+ISNULL(MarkUpTotalTariff,0),
				ISNULL(ModeOfPayment,''),ISNULL(VendorInvoiceNo,''),PaymentStatus   
				FROM #ExternalDate WHERE ClientId=@Param2 AND  BillNumber NOT IN('0','')
				
				SELECT @CountTotal=COUNT(* ) FROM #ExternalDateFinal
		
				IF @CountTotal!=0
				BEGIN
					INSERT INTO #ExternalDateFinal(BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
					BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
					PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus)
					SELECT 'Total','','','','','','',SUM(NoOFDays),SUM(Tariff),SUM(MarkUpTotalTariff),SUM(ServiceTax),SUM(VendorTariff),
					SUM(VendorTotal),SUM(DifferanceAmount),0,0,SUM(TotalHBAmount),'','',''
					FROM #ExternalDateFinal
				END
				
				SELECT BookingDate,BillNumber,PropertyName,CompanyName,GuestName,BillStartDate,
				BillEndDate,NoOFDays,Tariff,MarkUpTotalTariff,ServiceTax,VendorTariff,VendorTotal,DifferanceAmount,
				PropertyId,ClientId,TotalHBAmount,ModeOfPayment,VendorInvoiceNo,PaymentStatus
				FROM #ExternalDateFinal
				
				SELECT TOP 1 MarkUpTotalTariff,DifferanceAmount,DifferanceAmount/MarkUpTotalTariff*100 PER
				FROM #ExternalDateFinal
				ORDER BY PID DESC
		END
		END
	END
END