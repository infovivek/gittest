-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_NewSnackKOT_Bill]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_NewSnackKOT_Bill]
GO
/*=============================================
Author Name  : shameem
Created Date : 03/03/2013 
Section  	 : Report
Purpose  	 : Guest Checkout
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_NewSnackKOT_Bill]
(@Action NVARCHAR(100)=NULL,
@Id INT=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 INT=NULL
)
AS
BEGIN
IF @Action='PageLoad'
	BEGIN
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100);
	
	
	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
	
	SELECT distinct H.GuestName as Name,CONVERT(VARCHAR(100),H.Date,103) AS ArrivalDate,
	H.RoomNo,BA.BookingId,H.ClientName,CAST(ISNULL(H.TotalAmount,0)as DECIMAL(27,2)) AS TotalAmount,
	H.Id,D.ServiceItem AS Item,d.Quantity,D.Price,CAST(ISNULL(D.Amount,0)as DECIMAL(27,2)) as NetAmount,
	BA.ChkInDt,BA.ChkOutDt,P.PropertyName,P.Propertaddress
	FROM WRBHBNewKOTEntryHdr H
	JOIN WRBHBNewKOTEntryDtl D ON H.Id = D.NewKOTEntryHdrId AND D.IsActive = 1 AND D.IsDeleted=0
	JOIN WRBHBBookingPropertyAssingedGuest BA ON H.GuestId=BA.GuestId AND BA.IsActive=1 AND BA.IsDeleted=0
	JOIN WRBHBProperty P ON BA.BookingPropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	WHERE D.IsActive=1 AND D.IsDeleted = 0 AND  H.GuestId = @Id 
	
	
	END
END	
	