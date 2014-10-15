SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_VendorInvoiceSettelement_Report') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_VendorInvoiceSettelement_Report
GO 

CREATE PROCEDURE Sp_VendorInvoiceSettelement_Report
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
IF @Action ='Property'
BEGIN
	SELECT InvoiceNo,InvoiceDate,InvoiceAmount,'UnPaid',COUNT(D.Id) POCount
	FROM WRBHBMapPOAndVendorPaymentHdr H
	JOIN WRBHBMapPOAndVendorPaymentDtls D WITH(NOLOCK) ON H.Id=D.MapPOAndVendorPaymentHdrId
	AND D.IsActive=1 AND D.IsDeleted=0 AND D.Adjustment!=D.POAmount
	WHERE H.IsActive=1 AND H.IsDeleted=0 
	GROUP BY InvoiceNo,InvoiceDate,InvoiceAmount
	
END
END