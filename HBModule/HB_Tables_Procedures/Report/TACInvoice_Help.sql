SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TACInvoice_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TACInvoice_Help
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TAC Invoice Help
Purpose  	: TAC Invoice Help
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

CREATE PROCEDURE Sp_TACInvoice_Help
(
@Action NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT,

@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@PId		BIGINT,
@Str        Nvarchar(100),
@Id1        BIGINT 
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	CREATE TABLE #TEMP (Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),BillNo BIGINT,CreatedDate NVARCHAR(100),InvoiceNo NVARCHAR(100),
	Property NVARCHAR(100),Amount DECIMAL(27,2),Tax DECIMAL(27,2),TotalAmount DECIMAL(27,2),Guests NVARCHAR(3000),
	Client NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),NOOfDays int,	PerdayRate decimal(27,2),Location Nvarchar(1000))
	
	SELECT PropertyName as Property,Id as ZId from WRBHBProperty WHERE IsActive=1 and IsDeleted=0
	ORDER BY PropertyName

	INSERT INTO #TEMP(BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate,NOOfDays,PerdayRate,Location)
	
	SELECT C.CheckOutNo as BillId,Convert(NVARCHAR(100),CT.CreatedDate,103) AS CreatedDate,
	CT.TACInvoiceNo InvoiceNo,P.PropertyName Property,CT.MarkUpAmount as Amount,
	round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST,0) as Tax,CT.TACAmount TotalAmount,
	C.GuestName AS Guest,C.ClientName AS Client,
	CONVERT(NVARCHAR,CT.CheckInDate,103) as ChkInDt,CONVERT(NVARCHAR,CT.CheckOutDate,103) AS ChkOutDt,
	ct.NoOfDays,ct.Rate,ci.CityName as Location
	FROM WRBHBChechkOutHdr C 
	JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
	JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
	 Left outer join WRBHBCity Ci on C.CityId=ci.Id and Ci.IsActive=1 and Ci.IsDeleted=0
	WHERE C.IsActive=1 and c.IsDeleted=0 AND   p.Category NOT IN('Managed G H','Internal Property') 
		
	SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,
	ChkInDate  AS ChkInDate,ChkOutDate
	AS ChkOutDate,NOOfDays TotalDays,PerdayRate Perday,Location FROM #TEMP	
 END
 
 
 if @Action='DataLoad'
 BEGIN												--drop table #TEMP
	CREATE TABLE #TEMPs (Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),BillNo BIGINT,CreatedDate NVARCHAR(100),
	InvoiceNo NVARCHAR(100),Property NVARCHAR(100),PropertyId bigint,Amount DECIMAL(27,2),Tax DECIMAL(27,2),
	TotalAmount DECIMAL(27,2),Guests NVARCHAR(3000),Client NVARCHAR(100),ChkInDate NVARCHAR(100),
	ChkOutDate NVARCHAR(100),NOOfDays int,	PerdayRate decimal(27,2),Location Nvarchar(1000))
	
	CREATE TABLE #TEMPNew (Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),BillNo BIGINT,CreatedDate NVARCHAR(100),
	InvoiceNo NVARCHAR(100),Property NVARCHAR(100),PropertyId bigint,Amount DECIMAL(27,2),Tax DECIMAL(27,2),
	TotalAmount DECIMAL(27,2),Guests NVARCHAR(3000),Client NVARCHAR(100),ChkInDate NVARCHAR(100),
	ChkOutDate NVARCHAR(100),NOOfDays int,	PerdayRate decimal(27,2),Location Nvarchar(1000))
	
	
		INSERT INTO #TEMPs(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate,Location)
	
		SELECT C.CheckOutNo as BillId, convert(date, CT.BillDate,103) ,
		CT.TACInvoiceNo InvoiceNo,P.PropertyName Property,C.PropertyId,CT.MarkUpAmount as Amount,
		CT.TotalBusinessSupportST as Tax,CT.TACAmount TotalAmount,C.GuestName AS Guest,C.ClientName AS Client,
		CT.CheckInDate as ChkInDt,CT.CheckOutDate AS ChkOutDt,ct.NoOfDays,ct.Rate,Ci.CityName 
		FROM WRBHBChechkOutHdr C 
		JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
	    JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
	    Left outer join WRBHBCity Ci on C.CityId=ci.Id and Ci.IsActive=1 and Ci.IsDeleted=0
	    WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category NOT IN('Managed G H','Internal Property')
--NON IS GIVEN	
	IF @PId=0 AND @FromDate='' AND @ToDate='' 
	BEGIN
		INSERT INTO #TEMPNew(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate,Location)
		SELECT  BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate,NOOfDays TotalDays ,PerdayRate Perday ,Location  FROM #TEMPs
	END
--ONLY PROPERTY IS GIVEN		
	IF @PId!=0 AND @FromDate='' AND @ToDate='' 
	BEGIN
		INSERT INTO #TEMPNew(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate,Location)
		SELECT  BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate,NOOfDays TotalDays ,PerdayRate Perday ,Location 
		FROM #TEMPs WHERE PropertyId=@PId
	END

--FROM DATE AND TO DATE ARE GIVEN		
	IF @PId=0 AND @FromDate!='' AND @ToDate!='' 
	BEGIN
		INSERT INTO #TEMPNew(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate,Location)
		SELECT BillNo,Convert(NVARCHAR(100),CAST(CreatedDate as DATE),103)  AS CreatedDate, 
		InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,Client,CONVERT(NVARCHAR,ChkInDate,103) 
		AS ChkInDate,CONVERT(NVARCHAR,ChkOutDate,103) AS ChkOutDate ,
		NOOfDays TotalDays,PerdayRate Perday,Location 
		FROM #TEMPs 
		WHERE  CreatedDate  BETWEEN Convert(date,@FromDate,103) AND Convert(date,@ToDate,103); 
	END
--PROPERTY,FROM DATE AND TO DATE ARE GIVEN		
	IF @PId!=0 AND @FromDate!='' AND @ToDate!='' 
	BEGIN
		INSERT INTO #TEMPNew(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate,Location)
		SELECT BillNo,Convert(NVARCHAR(100),CAST(CreatedDate as DATE),103),InvoiceNo,Property,PropertyId,Amount,
		Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate ,NOOfDays TotalDays,PerdayRate Perday,Location 
		FROM #TEMPs 
		where  PropertyId=@PId and
		CreatedDate BETWEEN CONVERT(DATE,@FromDate,103)AND CONVERT(DATE,@ToDate,103);
	END
	    SELECT Id,BillNo,  CreatedDate  AS CreatedDate, 
		InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,CONVERT(NVARCHAR,ChkInDate,103) 
		AS ChkInDate,CONVERT(NVARCHAR,ChkOutDate,103) AS ChkOutDate ,
		NOOfDays TotalDays,PerdayRate Perday, Location 
		FROM #TEMPNew 
	
	End
 
END