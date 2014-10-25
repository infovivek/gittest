SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_SearchInvoiceAnnexure_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_SearchInvoiceAnnexure_Help]
GO
/*=============================================
Author Name  :  
Created Date : 03/04/2014 
Section  	 :  
Purpose  	 :  
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_SearchInvoiceAnnexure_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
--@Str3 NVARCHAR(100)=NULL,
@Id1 INT=NULL,
@Id2 INT=NULL,
--@Id3 INT=NULL, 
@UserId INT=NULL
)
AS
BEGIN
IF @Action ='Pageload'
   
 Begin
  Create Table #SepratebyComma(CheckoutId Bigint, Id int Primary Key identity(1,1))
   Create Table #Annuxer(InvoiceNumber NVARCHAR(500),BookingCode  NVARCHAR(100),Property NVARCHAR(500),
 ClientName NVARCHAR(500),CityName NVARCHAR(500),GuestNam NVARCHAR(500),CheckInDate NVARCHAR(500),
 CheckOutDate NVARCHAR(500),NoOfDays BIGINT,Rate DECIMAL(27,2),ST DECIMAL(27,2),Amount DECIMAL(27,2),
 Amounts DECIMAL(27,2),selectRadio INT,ChkoutId BIGINT)
 

DECLARE @id VARCHAR(MAX)

SET @id =  '1152,1153,1154,1155,1159,1160,'


WHILE CHARINDEX(',', @id) > 0 
BEGIN

    DECLARE @tmpstr VARCHAR(50)
     SET @tmpstr = SUBSTRING(@id, 1, ( CHARINDEX(',', @id) - 1 ))

    INSERT  INTO #SepratebyComma (CheckoutId)VALUES  (@tmpstr)
    SET @id = SUBSTRING(@id, CHARINDEX(',', @id) + 1, LEN(@id))
    --Select @id,@tmpstr
END 

DECLARE @Cnt int,@Chkid Bigint=0;
   SET @Cnt=(SELECT COUNT(*) FROM #SepratebyComma); 
   while @Cnt>0
   begin
          Set @Chkid=(Select top 1 CheckoutId from  #SepratebyComma
           order by Id desc )
           
            INSERT INTO #Annuxer(InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,Rate,ST,Amount,Amounts,selectRadio,ChkoutId)
			
			SELECT CT.TACInvoiceNo InvoiceNumber,B.BookingCode,P.PropertyName Property,C.ClientName AS ClientName,B.CityName,C.GuestName AS GuestName ,
			CT.CheckInDate as CheckInDate,CT.CheckOutDate AS CheckOutDate,
			c.NoOfDays,Ct.Rate,round(ct.ChkOutTariffHECess+ct.ChkOutTariffCess+CT.TotalBusinessSupportST,0) as ST,
			CT.MarkupAmount  as Amount,CT.TACAmount Amounts,0 as selectRadio ,C.Id as ChkoutId
			--,'CheckOut'Status,'TAC' as PropertyCat,'Tariff' BillType 
			FROM WRBHBChechkOutHdr C 
			join WRBHBBooking B on c.BookingId=B.Id and B.IsActive=1 and B.IsDeleted=0
			JOIN WRBHBExternalChechkOutTAC CT ON CT.ChkOutHdrId = C.Id and ct.IsActive=1 and ct.IsDeleted=0
			JOIN WRBHBProperty P ON P.Id=CT.PropertyId and c.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0
			WHERE C.IsActive=1 and c.IsDeleted=0 AND p.Category!='Managed G H' and C.Id=@Chkid
			ORDER BY   c.id desc 
			dELETE FROM #SepratebyComma WHERE CheckoutId=@Chkid ;
			  Set @Cnt=(SELECT COUNT(*) FROM #SepratebyComma)
   End


            SELECT InvoiceNumber,BookingCode,Property,ClientName,CityName,GuestNam,
			CheckInDate,CheckOutDate,NoOfDays,Rate,ST,Amount,Amounts,selectRadio,ChkoutId
			FROM #Annuxer
End
end 
--WIZA8BW2PN
--IYPESZEALN
