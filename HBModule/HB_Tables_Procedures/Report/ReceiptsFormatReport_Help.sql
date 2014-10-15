SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ReceiptsFormats_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_ReceiptsFormats_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (15/09/2014)  >
Section  	: SP_ReceiptsFormats Help
Purpose  	: SP_ReceiptsFormats Help
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

CREATE PROCEDURE dbo.[SP_ReceiptsFormats_Help]
(
@Action NVARCHAR(100),
@Id		BIGINT,
@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100))
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF(@Action='POSerch')
BEGIN
	CREATE TABLE #Booking(GetType NVARCHAR(100),BookingId INT,BillId INT,InVoiceNo NVARCHAR(100),
	PropertyName NVARCHAR(100),ClientName NVARCHAR(100),MasterClientName NVARCHAR(100),
	Guest NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),CityName NVARCHAR(100),
	NoOfDays INT,Amount DECIMAL(27,2),BillDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),BillType NVARCHAR(100))

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	SELECT 'Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON B.Id=BT.BookingId AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON BP.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType='Contract' AND BT.PropertyType='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	
	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	SELECT 'Non-Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON B.Id=BT.BookingId AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON BP.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType !='Contract' AND BT.PropertyType !='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	SELECT 'Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,
	CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBBedBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON BP.BookingPropertyTableId=BT.Id AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON BP.BedId=CH.BedId AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType='Contract' AND BT.PropertyType='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	SELECT 'Non-Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBBedBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON BP.BookingPropertyTableId=BT.Id AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON  BP.BedId=CH.BedId AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType !='Contract' AND BT.PropertyType !='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	
	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate
	

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	select 'Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBApartmentBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON BP.BookingPropertyTableId=BT.Id AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON BP.ApartmentId=CH.ApartmentId AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType='Contract' AND BT.PropertyType='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate
	
	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,NoOfDays,Amount,BillDate,BillStartDate,BillEndDate,BillType)

	SELECT 'Non-Dedicated' AS GetType,B.BookingCode AS BookingId,CH.Id AS BillId,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,(BP.FirstName+''+BP.LastName) AS Guest,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate,'Bill'AS BillType
	FROM WRBHBBooking  B
	JOIN WRBHBApartmentBookingPropertyAssingedGuest BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0
	JOIN WRBHBBookingProperty BT WITH(NOLOCK)ON BP.BookingPropertyTableId=BT.Id AND BT.IsActive=1 AND BT.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK)ON BP.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	JOIN WRBHBClientManagement C WITH(NOLOCK)ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement M WITH(NOLOCK)ON C.MasterClientId=M.Id AND M.IsActive=1 AND M.IsDeleted=0
	JOIN WRBHBChechkOutHdr CH WITH(NOLOCK)ON BP.ApartmentId=CH.ApartmentId AND CH.IsActive=1 AND CH.IsDeleted=0 
	WHERE BT.GetType !='Contract' AND BT.PropertyType !='DdP' AND 
	CONVERT(Date,CH.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	
	GROUP BY B.BookingCode ,CH.Id,CH.InVoiceNo,P.PropertyName,
	C.ClientName,M.ClientName ,BP.FirstName,BP.LastName,CH.CheckInDate,CH.CheckOutDate,
	B.CityName,CH.NoOfDays,CH.ChkOutTariffNetAmount,CH.BillDate,CH.BillFromDate,CH.BillEndDate
	
	CREATE TABLE #CheckOut(Type NVARCHAR(100),PaymentMode NVARCHAR(100),ChkId INT) 

	INSERT INTO #CheckOut(Type,PaymentMode,ChkId)
	
	SELECT  CP.Payment,CP.CCBrand,C.Id FROM  WRBHBChechkOutHdr C
	JOIN WRBHBChechkOutPaymentCard CP WITH(NOLOCK)ON C.Id=CP.ChkOutHdrId AND CP.IsActive=1 AND CP.IsDeleted=0
	WHERE CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	GROUP BY CP.Payment,CP.CCBrand,C.Id

	INSERT INTO #CheckOut(Type,PaymentMode,ChkId)
	
	SELECT  CP.Payment,CP.PaymentMode,C.Id 
	FROM  WRBHBChechkOutHdr C
	JOIN WRBHBChechkOutPaymentCash CP WITH(NOLOCK)ON C.Id=CP.ChkOutHdrId AND CP.IsActive=1 AND CP.IsDeleted=0
	WHERE CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	INSERT INTO #CheckOut(Type,PaymentMode,ChkId)
	
	SELECT  CP.Payment,CP.PaymentMode,C.Id FROM  WRBHBChechkOutHdr C
	JOIN WRBHBChechkOutPaymentCheque CP WITH(NOLOCK)ON C.Id=CP.ChkOutHdrId AND CP.IsActive=1 AND CP.IsDeleted=0
	WHERE CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	GROUP BY CP.Payment,CP.PaymentMode,C.Id
	
	INSERT INTO #CheckOut(Type,PaymentMode,ChkId)
	
	SELECT  CP.Payment,CP.PaymentMode,C.Id FROM  WRBHBChechkOutHdr C
	JOIN WRBHBChechkOutPaymentCompanyInvoice CP WITH(NOLOCK)ON C.Id=CP.ChkOutHdrId AND CP.IsActive=1 AND CP.IsDeleted=0
	WHERE CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	GROUP BY CP.Payment,CP.PaymentMode,C.Id

	INSERT INTO #CheckOut(Type,PaymentMode,ChkId)
	
	SELECT CP.Payment,CP.PaymentMode,C.Id
	FROM  WRBHBChechkOutHdr C
	JOIN WRBHBChechkOutPaymentNEFT CP WITH(NOLOCK)ON C.Id=CP.ChkOutHdrId AND CP.IsActive=1 AND CP.IsDeleted=0
	WHERE CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	GROUP BY CP.Payment,CP.PaymentMode,C.Id
	
	CREATE TABLE #Final(Id bigint IDENTITY(1,1)  NOT NULL PRIMARY KEY,BookingType NVARCHAR(100),
	BookingId INT,BillId INT,InVoiceNo NVARCHAR(100),
	PropertyName NVARCHAR(100),ClientName NVARCHAR(100),MasterClientName NVARCHAR(100),
	GuestName NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),Location NVARCHAR(100),
	NoOfDays INT,TotalAmount DECIMAL(27,2),Type NVARCHAR(100),PaymentMode NVARCHAR(100),BillDate NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),
	BillType NVARCHAR(100))
	
	INSERT INTO #Final(BookingType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	GuestName,CheckInDate,CheckOutDate,Location,NoOfDays,TotalAmount,Type,PaymentMode,BillDate,BillStartDate,
	BillEndDate,BillType)
	
	SELECT B.GetType AS BookingType,B.BookingId,B.BillId,B.InVoiceNo,B.PropertyName,B.ClientName,
	B.MasterClientName,B.Guest AS GuestName,B.CheckInDate,B.CheckOutDate,B.CityName As Location,B.NoOfDays,
	B.Amount AS TotalAmount,C.Type,C.PaymentMode,B.BillDate,B.BillStartDate,
	B.BillEndDate,B.BillType 
	FROM #Booking B
	JOIN #CheckOut C ON B.BillId=C.ChkId
	
	SELECT Id AS SNo,BookingType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,
	MasterClientName,GuestName,CheckInDate,CheckOutDate,Location,NoOfDays,
	TotalAmount,Type,PaymentMode,BillDate,BillStartDate,
	BillEndDate,BillType  FROM #Final
	

END
END