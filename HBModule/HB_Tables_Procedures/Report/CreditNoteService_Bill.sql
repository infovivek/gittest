-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CreditNoteService_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteService_Bill]
GO
/*=============================================
Author Name  : Anbu
Created Date : 09/02/2015 
Section  	 : Report
Purpose  	 : SP_CreditNoteService_Bill
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CreditNoteService_Bill]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL
)
AS
BEGIN
IF @Action='PageLoad'
	BEGIN
		DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@LOGO VARCHAR(MAX),
		@ClientAddress NVARCHAR(500),@ClientId BIGINT;  
		
		SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)  
		SET @Address=(SELECT Address FROM WRBHBCompanyMaster)  
		SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
		
		SELECT @ClientId=H.ClientId  FROM WRBHBChechkOutHdr H
		JOIN WRBHBCreditNoteServiceHdr I WITH(NOLOCK) ON H.Id=I.CheckOutId
		WHERE I.Id=@Id1
		SELECT @ClientAddress=CAddress1+','+CCity+','+CState+','+CPincode FROM WRBHBClientManagement H   
		WHERE H.Id=@ClientId
		
		
	    CREATE TABLE #Service(CrdNoteNo NVARCHAR(100),InVoiceNo NVARCHAR(100),Item NVARCHAR(100),ServiceAmount DECIMAL(27,2),
		Quantity int,NetAmount DECIMAL(27,2),TotalAmount DECIMAL(27,2),Des NVARCHAR(100),HdrId INT,ChkInVoiceNo NVARCHAR(100))
		INSERT INTO #Service(CrdNoteNo,InVoiceNo,Item,ServiceAmount,Quantity,NetAmount,
		TotalAmount,Des,HdrId,ChkInVoiceNo)
		SELECT CreditNoteNo AS CrdNoteNo,CrdInVoiceNo AS InVoiceNo,Type AS Item,ServiceAmount,SUM(Quantity),SUM(Total) AS NetAmount,
		TotalAmount,Description,Ch.Id,CH.ChkOutInVoiceNo AS  ChkInVoiceNo  
		FROM WRBHBCreditNoteServiceDtls CD
		JOIN WRBHBCreditNoteServiceHdr  CH ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
		WHERE CH.Id= @Id1 AND CD.Quantity !=0
		GROUP BY CreditNoteNo,CrdInVoiceNo,Type,ServiceAmount,
		TotalAmount,Description,Ch.Id,CH.ChkOutInVoiceNo
	
		CREATE TABLE #Service1(ChkOutId INT,HdrId INT,
		CrdNoteNo NVARCHAR(100),InVoiceNo NVARCHAR(100),VAT DECIMAL(27,2),ServiceFB DECIMAL(27,2),ServiceOT DECIMAL(27,2))
		INSERT INTO #Service1(ChkOutId,CrdNoteNo,InVoiceNo,VAT,ServiceFB,ServiceOT,HdrId)
		
		SELECT DISTINCT Ch.CheckOutId, CreditNoteNo AS CrdNoteNo,CrdInVoiceNo AS InVoiceNo,
		SUM(ServiceAmount*H.VATPer/100) AS VAT,SUM(Ch.ServiceTaxFB) AS ServiceTaxFB,SUM(ServiceTaxOthers) AS ServiceTaxOthers,CH.Id
		FROM WRBHBCreditNoteServiceDtls CD
		JOIN WRBHBCreditNoteServiceHdr  CH ON CD.CrdServiceHdrId=CH.Id AND CH.IsActive=1
		JOIN WRBHBChechkOutHdr H ON Ch.CheckOutId=H.Id
		WHERE CH.Id= @Id1 AND CD.Quantity !=0 
		GROUP BY  Ch.CheckOutId,CreditNoteNo,CrdInVoiceNo,CH.Id
		
		
		
		
		 SELECT DISTINCT h.GuestName as GuestName,h.Name,h.Stay,h.Type,d.Type as BookingLevel,convert(nvarchar(100),
		 h.CheckOutDate,103) as BillDate,h.ClientName,h.CheckOutNo,s1.InVoiceNo AS InVoiceNo,  
		 TotalAmount as NetAmount,s1.ServiceAmount AS SerivceNet,
		 s1.Quantity as Quantity,s1.Item AS Item ,s2.VAT AS VAT,s2.ServiceFB AS SerivceTax,s1.NetAmount AS TotalAmount,
		 convert(nvarchar(100),d.ArrivalDate,103)as ArrivalDate,s1.Des AS Description,  
		(p.PropertyName+','+p.Propertaddress) as Propertyaddress,(c.CityName+','+  
		 s.StateName+','+p.Postal) as Propcity,c.CityName,s.StateName,p.Postal,  
		 p.Phone,p.Email,@CompanyName as CompanyName,@LOGO AS logo,  
		 CONVERT(nvarchar(100),h.BillFromDate,103) ChkinDT,CONVERT(nvarchar(100),h.BillEndDate,103) as ChkoutDT,
		 'Regd Office : No. 122, Amarjyothi Layout, Domlur, Bangalore - 560071'+'.'+'www.hummingbirdindia.com'  AS CompanyAddress,
		 @ClientAddress as Address,S1.ChkInVoiceNo AS PIInvoice,
		 'VAT @ '+CAST(H.VATPer AS NVARCHAR)+'%' VATPer,
		 'Service Tax @ '+CAST(H.RestaurantSTPer AS NVARCHAR)+'%' ServiceFB,
		 'Service Tax @ '+CAST(12.36 AS NVARCHAR)+'%' STPer,s2.ServiceOT AS ServiceOT ,
		 CONVERT(nvarchar(100),h.CreatedDate,103) as InVoicedate,
		 'Rupees : '+dbo.fn_NtoWord(ROUND(s1.TotalAmount,0),'','') AS AmtWords
		   
		 FROM #Service s1
		 JOIN #Service1 s2 ON s1.HdrId=s2.HdrId
		 JOIN WRBHBChechkOutHdr h ON s2.ChkOutId=h.Id AND h.IsActive=1 
		 join WRBHBCheckInHdr d on h.ChkInHdrId = d.Id  
		 join WRBHBProperty p on d.PropertyId = p.Id 
		 join WRBHBState s on s.Id=p.StateId
		 join WRBHBCity c on c.Id=p.CityId 
		 join WRBHBBooking b on b.Id = d.BookingId 	
		 join WRBHBTaxMaster t on t.StateId=s.Id   
		 where h.IsActive = 1 and h.IsDeleted = 0 
		
	
		 		
		
	 
END
END



