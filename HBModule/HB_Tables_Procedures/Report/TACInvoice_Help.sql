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
--@Str NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT

)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	CREATE TABLE #TEMP (Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),BillNo BIGINT,CreatedDate NVARCHAR(100),InvoiceNo NVARCHAR(100),
	Property NVARCHAR(100),Amount DECIMAL(27,2),Tax DECIMAL(27,2),TotalAmount DECIMAL(27,2),Guests NVARCHAR(3000),
	Client NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),NOOfDays int,	PerdayRate decimal(27,2))
	
	SELECT PropertyName as Property,Id as ZId from WRBHBProperty WHERE IsActive=1 and IsDeleted=0
	ORDER BY PropertyName

	INSERT INTO #TEMP(BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,ChkInDate,
		ChkOutDate,NOOfDays,PerdayRate)
	
	SELECT C.CheckOutNo as BillId,Convert(NVARCHAR(100),CT.CreatedDate,103) AS CreatedDate,
	CT.TACInvoiceNo InvoiceNo,P.PropertyName Property,CT.MarkUpAmount as Amount,
	round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST,0) as Tax,CT.TACAmount TotalAmount,C.GuestName AS Guest,C.ClientName AS Client,
	CT.CheckInDate as ChkInDt,CT.CheckOutDate AS ChkOutDt,ct.NoOfDays,ct.Rate
	FROM WRBHBChechkOutHdr C 
	JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
	JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
	WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' 
		
	SELECT Id,BillNo,CreatedDate,InvoiceNo,Property,Amount,Tax,TotalAmount,Guests,Client,
	CONVERT(NVARCHAR,CONVERT(DATE,ChkInDate,103),110) AS CheckInDate,
				CONVERT(NVARCHAR,CONVERT(DATE,ChkOutDate,103),110) AS CheckOutDate,
				NOOfDays TotalDays,PerdayRate Perday FROM #TEMP	
 END
END