SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_InternalInvoiceReport_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_InternalInvoiceReport_Help]

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

CREATE PROCEDURE dbo.[SP_InternalInvoiceReport_Help]
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
	BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),CHId INT)

	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,BillStartDate,BillEndDate,CHId)
	
	SELECT DISTINCT 'Dedicated' AS GetType,B.BookingCode,H.Id AS BillId,H.InVoiceNo,P.PropertyName,
	C.ClientName,MC.ClientName,H.GuestName AS Guest,H.CheckInDate,H.CheckOutDate,
	B.CityName,H.CheckInDate,H.CheckOutDate,H.Id
	FROM WRBHBChechkOutHdr H
	JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
	JOIN WRBHBBookingProperty  BT WITH(NOLOCK) ON B.Id=BT.BookingId  AND B.IsActive=1	AND B.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
	JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId
	JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
	WHERE BT.GetType='Contract' AND BT.PropertyType='DdP' AND
	CONVERT(Date,H.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	
	GROUP BY B.BookingCode ,H.Id,H.InVoiceNo,P.PropertyName,
	C.ClientName,MC.ClientName ,H.GuestName,H.CheckInDate,H.CheckOutDate,
	B.CityName,H.BillFromDate,H.BillEndDate
	
	INSERT INTO #Booking(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,BillStartDate,BillEndDate,CHId)

	SELECT DISTINCT 'Non-Dedicated' AS GetType,B.BookingCode,H.Id AS BillId,H.InVoiceNo,P.PropertyName,
	C.ClientName,MC.ClientName,H.GuestName AS Guest,H.CheckInDate,H.CheckOutDate,
	B.CityName,H.CheckInDate,H.CheckOutDate,H.Id
	FROM WRBHBChechkOutHdr H
	JOIN WRBHBBooking  B WITH(NOLOCK) ON H.BookingId=B.Id AND B.IsActive=1	AND B.IsDeleted=0
	JOIN WRBHBBookingProperty  BT WITH(NOLOCK) ON B.Id=BT.BookingId  AND B.IsActive=1	AND B.IsDeleted=0
	JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
	JOIN WRBHBCity CC WITH(NOLOCK) ON CC.Id=P.CityId
	JOIN WRBHBClientManagement C WITH(NOLOCK) ON B.ClientId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBMasterClientManagement MC WITH(NOLOCK) ON C.MasterClientId=MC.Id AND MC.IsActive=1 AND MC.IsDeleted=0
	WHERE BT.GetType='Contract' AND BT.PropertyType !='DdP' AND BT.PropertyType !='ExP' AND
	CONVERT(Date,H.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	GROUP BY B.BookingCode ,H.Id,H.InVoiceNo,P.PropertyName,
	C.ClientName,MC.ClientName ,H.GuestName,H.CheckInDate,H.CheckOutDate,
	B.CityName,H.BillFromDate,H.BillEndDate

	CREATE TABLE #Tariff(Amount DECIMAL(27,2),LT DECIMAL(27,2),STT DECIMAL(27,2),STTC DECIMAL(27,2),
	STC DECIMAL(27,2),Miscellaneous DECIMAL(27,2),COId INT)
	
	INSERT #Tariff(Amount,LT,STT,STTC,STC,COId)
	
	SELECT ISNULL(ChkOutTariffTotal,0),ISNULL(ChkOutTariffLT,0),ISNULL(ChkOutTariffST1,0),
	(ISNULL(ChkOutTariffST3,0)+ISNULL(ChkOutTariffCess,0)+ISNULL(ChkOutTariffHECess,0))AS ST,
	ISNULL(ChkOutTariffSC,0),Id 
	FROM #Booking B
	JOIN WRBHBChechkOutHdr  T ON B.BillId=T.Id AND T.IsActive=1 AND T.IsDeleted=0
	WHERE CONVERT(Date,BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)

	CREATE TABLE #Service(FBAmount DECIMAL(27,2),SAmount DECIMAL(27,2),LAmount DECIMAL(27,2),
	VAT DECIMAL(27,2),ST DECIMAL(27,2),STC DECIMAL(27,2),SC DECIMAL(27,2),CID INT,
	Mis DECIMAL(27,2),Otherservices DECIMAL(27,2))
	
	INSERT INTO #Service(FBAmount,SAmount,LAmount,VAT,ST,STC,SC,CID,Mis,Otherservices)
	
	SELECT ISNULL(SUM(CS.ChkOutSerAmount),0) AS FBAmount,0 AS SAmount,0 AS LAmount,ISNULL(CH.ChkOutServiceVat,0),
	ISNULL(CH.ChkOutServiceST,0),(ISNULL(CH.ChkOutServiceST,0)+ISNULL(CH.Cess,0)+ISNULL(CH.HECess,0)) AS STC,0 AS SC,C.Id,
	ISNULL(CH.MiscellaneousAmount,0),ISNULL(CH.OtherService,0)
	FROM #Booking B
	JOIN WRBHBChechkOutHdr  C ON B.BillId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBCheckOutServiceHdr CH ON C.Id=CH.CheckOutHdrId AND CH.IsActive=1 AND CH.IsDeleted=0
	JOIN WRBHBCheckOutServiceDtls CS ON C.Id=CS.CheckOutServceHdrId AND CS.IsActive=1 AND CS.IsDeleted=0
	WHERE CS.TypeService='Food And Beverages' AND
	CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	group by CH.ChkOutServiceAmtl,CH.ChkOutServiceVat,CH.OtherService,CH.ChkOutServiceST,CH.Cess,CH.HECess
	,C.Id,CH.MiscellaneousAmount,CH.OtherService
	
	INSERT INTO #Service(FBAmount,SAmount,LAmount,VAT,ST,STC,SC,CID,Mis,Otherservices)
	SELECT 0 AS FBAmount,ISNULL(SUM(CS.ChkOutSerAmount),0) AS SAmount,0 AS LAmount,ISNULL(CH.ChkOutServiceVat,0),
	ISNULL(CH.ChkOutServiceST,0),(ISNULL(CH.ChkOutServiceST,0)+ISNULL(CH.Cess,0)+ISNULL(CH.HECess,0)) AS STC,0 AS SC,C.Id,
	ISNULL(CH.MiscellaneousAmount,0),ISNULL(CH.OtherService,0)
	from #Booking B
	JOIN WRBHBChechkOutHdr  C ON B.BillId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBCheckOutServiceHdr CH ON C.Id=CH.CheckOutHdrId AND CH.IsActive=1 AND CH.IsDeleted=0
	JOIN WRBHBCheckOutServiceDtls CS ON C.Id=CS.CheckOutServceHdrId AND CS.IsActive=1 AND CS.IsDeleted=0
	WHERE CS.TypeService='Services' AND
	CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
	group by CH.ChkOutServiceAmtl,CH.ChkOutServiceVat,CH.OtherService,CH.ChkOutServiceST,CH.Cess,CH.HECess
	,C.Id,CH.MiscellaneousAmount,CH.OtherService
	
	INSERT INTO #Service(FBAmount,SAmount,LAmount,VAT,ST,STC,SC,CID,Mis,Otherservices)
	SELECT 0 AS FBAmount,0 AS SAmount,ISNULL(SUM(CS.ChkOutSerAmount),0) AS LAmount,ISNULL(CH.ChkOutServiceVat,0),
	ISNULL(CH.ChkOutServiceST,0),(ISNULL(CH.ChkOutServiceST,0)+ISNULL(CH.Cess,0)+ISNULL(CH.HECess,0)) AS STC,0 AS SC,C.Id,
	ISNULL(CH.MiscellaneousAmount,0),ISNULL(CH.OtherService,0)
	from #Booking B
	JOIN WRBHBChechkOutHdr  C ON B.BillId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
	JOIN WRBHBCheckOutServiceHdr CH ON C.Id=CH.CheckOutHdrId AND CH.IsActive=1 AND CH.IsDeleted=0
	JOIN WRBHBCheckOutServiceDtls CS ON C.Id=CS.CheckOutServceHdrId AND CS.IsActive=1 AND CS.IsDeleted=0
	WHERE  CS.TypeService='Laundry' AND  (CS.ChkOutSerAmount)!=0 and
	CONVERT(Date,C.BillDate,103) BETWEEN CONVERT(Date,@Str1,103) AND CONVERT(Date,@Str2,103)
    group by CH.ChkOutServiceAmtl,CH.ChkOutServiceVat,CH.OtherService,CH.ChkOutServiceST,CH.Cess,CH.HECess
	,C.Id,CH.MiscellaneousAmount,CH.OtherService
	
	CREATE TABLE #Final(Id bigint IDENTITY(1,1)  NOT NULL PRIMARY KEY,GetType NVARCHAR(100),
	BookingId INT,BillId INT,InVoiceNo NVARCHAR(100),PropertyName NVARCHAR(100),ClientName NVARCHAR(100),
	MasterClientName NVARCHAR(100),Guest NVARCHAR(100),CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),
	CityName NVARCHAR(100),BillStartDate NVARCHAR(100),BillEndDate NVARCHAR(100),TotalAmount DECIMAL(27,2),
	Amount DECIMAL(27,2),FBAmount DECIMAL(27,2),SAmount DECIMAL(27,2),LAmount DECIMAL(27,2),Mis DECIMAL(27,2),
	OtherService DECIMAL(27,2),LT DECIMAL(27,2),STT DECIMAL(27,2),STTC DECIMAL(27,2),STC DECIMAL(27,2),
	SC DECIMAL(27,2),VAT DECIMAL(27,2)) 

	INSERT INTO #Final(GetType,BookingId,BillId,InVoiceNo,PropertyName,ClientName,MasterClientName,
	Guest,CheckInDate,CheckOutDate,CityName,BillStartDate,
	BillEndDate,TotalAmount,Amount,FBAmount,SAmount,LAmount,Mis,OtherService,LT,STT,STTC,
	STC,SC,VAT)
	
	SELECT B.GetType,B.BookingId,B.BillId,B.InVoiceNo,B.PropertyName,B.ClientName,B.MasterClientName,
	B.Guest,B.CheckInDate,B.CheckOutDate,B.CityName,B.BillStartDate,B.BillEndDate,(ISNULL(T.Amount,0)+
	ISNULL(S.FBAmount,0)+ISNULL(S.SAmount,0)+ISNULL(S.LAmount,0)+ISNULL(T.LT,0)+ISNULL(S.Mis,0)+
	ISNULL(S.Otherservices,0)+ISNULL(T.STT,0)+ISNULL(S.ST,0)
	+ISNULL(T.STTC,0)+ISNULL(S.STC,0)+ISNULL(T.STC,0)+ISNULL(S.SC,0)+ISNULL(S.VAT,0)) AS Total,
	ISNULL(T.Amount,0) AS Amount,ISNULL(S.FBAmount,0) AS FBAmount,ISNULL(S.SAmount,0) AS SAmount,
	ISNULL(S.LAmount,0) AS LAmount,ISNULL(S.Mis,0) AS Mis,ISNULL(S.Otherservices,0) AS OtherService,
	ISNULL(T.LT,0) AS LT,ISNULL(T.STT,0) AS STT,ISNULL(T.STTC,0) AS STTC,ISNULL(S.STC,0) AS STC,
	(ISNULL(T.STC,0)+ISNULL(S.SC,0)) AS SC,ISNULL(S.VAT,0)AS VAT
	FROM #Booking B
	LEFT OUTER JOIN #Tariff T ON B.CHId=T.COId
	LEFT OUTER JOIN #Service S ON T.COId=S.CID
		
	SELECT Id AS SNo,GetType AS BookingType,BookingId AS BookingCode,BillId,InVoiceNo,PropertyName,
	ClientName,MasterClientName,Guest AS GuestName,CheckInDate,CheckOutDate,CityName AS Location,
	BillStartDate,BillEndDate,ISNULL(TotalAmount,0) AS TotalAmount,Amount,FBAmount AS FoodAndBeverages,SAmount AS Service,
	LAmount AS Laundry,Mis AS Miscellaneous,OtherService AS OtherService,LT AS LuxuryTax,STT,STTC,
	STC,SC AS ServiceCharge,VAT FROM #Final
	group by Id  ,GetType ,BookingId  ,BillId,InVoiceNo,PropertyName,
	ClientName,MasterClientName,Guest  ,CheckInDate,CheckOutDate,CityName ,
	BillStartDate,BillEndDate,TotalAmount,Amount,FBAmount ,SAmount,
	LAmount ,Mis ,OtherService ,LT ,STT,STTC,
	STC,SC,VAT
	
	
	END
END



