 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TACInvoice_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TACInvoice_Search
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TACInvoice Search
		Purpose  	: TACInvoice Search
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
CREATE PROCEDURE Sp_TACInvoice_Search
(
--@Action		NVARCHAR(100),
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		INT,
@Id			INT,
@PId		INT
)
AS
BEGIN												--drop table #TEMP
	CREATE TABLE #TEMP (Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),BillNo BIGINT,CreatedDate NVARCHAR(100),
	InvoiceNo NVARCHAR(100),Property NVARCHAR(100),PropertyId bigint,Amount DECIMAL(27,2),Tax DECIMAL(27,2),
	TotalAmount DECIMAL(27,2),Guests NVARCHAR(3000),Client NVARCHAR(100),ChkInDate NVARCHAR(100),
	ChkOutDate NVARCHAR(100),NOOfDays int,	PerdayRate decimal(27,2))
	
		INSERT INTO #TEMP(BillNo,CreatedDate,InvoiceNo,Property,PropertyId,Amount,Tax,TotalAmount,Guests,
		Client,ChkInDate,ChkOutDate,NOOfDays,PerdayRate)
	
		SELECT C.CheckOutNo as BillId,Convert(NVARCHAR(100),CT.CreatedDate,103) AS CreatedDate,
		CT.TACInvoiceNo InvoiceNo,P.PropertyName Property,C.PropertyId,CT.MarkUpAmount as Amount,
		CT.TotalBusinessSupportST as Tax,CT.TACAmount TotalAmount,C.GuestName AS Guest,C.ClientName AS Client,
		CT.CheckInDate as ChkInDt,CT.CheckOutDate AS ChkOutDt,ct.NoOfDays,ct.Rate
		FROM WRBHBChechkOutHdr C 
		JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
	    JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
	    WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' 
--NON IS GIVEN	
	IF @PId=0 AND @FromDate='' AND @ToDate='' 
	BEGIN
		SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate FROM #TEMP
	END
--ONLY PROPERTY IS GIVEN		
	IF @PId!=0 AND @FromDate='' AND @ToDate='' 
	BEGIN
		SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate,NOOfDays TotalDays,PerdayRate Perday 
		FROM #TEMP WHERE PropertyId=@PId
	END

--FROM DATE AND TO DATE ARE GIVEN		
	IF @PId=0 AND @FromDate!='' AND @ToDate!='' 
	BEGIN
		SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate ,NOOfDays TotalDays,PerdayRate Perday,NOOfDays TotalDays,PerdayRate Perday 
		FROM #TEMP WHERE CONVERT(DATE,CreatedDate,103) BETWEEN CONVERT(DATE,@FromDate,103)
		AND CONVERT(DATE,@ToDate,103) 
	END
--PROPERTY,FROM DATE AND TO DATE ARE GIVEN		
	IF @PId!=0 AND @FromDate!='' AND @ToDate!='' 
	BEGIN
		SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate ,NOOfDays TotalDays,PerdayRate Perday
		FROM #TEMP  WHERE CONVERT(DATE,CreatedDate,103) BETWEEN CONVERT(DATE,@FromDate,103)
		AND CONVERT(DATE,@ToDate,103) AND PropertyId=@PId
	END
END