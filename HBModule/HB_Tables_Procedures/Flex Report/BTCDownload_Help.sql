-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCDownloads_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BTCDownloads_Help]
GO 
-- ===============================================================================
-- Author:Anbu
-- Create date:27-FEB-2015
-- ModifiedBy :          , ModifiedDate: 
-- Description:	BTCDownload Files
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BTCDownloads_Help]
(@Action NVARCHAR(100),
@FromDt NVARCHAR(100),
@ToDt NVARCHAR(100),
@Str1 NVARCHAR(100),
@Id1 BIGINT,
@Id2 BIGINT
)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
	IF @Action = 'PageLoad'
	BEGIN
		SELECT ClientName,Id AS ClientId FROM WRBHBClientManagement
		WHERE ISNULL(BTC,0)=1
		ORDER BY ClientName ASC
	END
	IF @Action = 'ClientLoad'
	BEGIN
		CREATE TABLE #BTC(BookingCode INT,GuestName NVARCHAR(100),BookingId INT,GuestId INT,Type NVARCHAR(100))
		
		INSERT INTO #BTC(BookingCode,GuestName,BookingId,GuestId,Type)
		SELECT B.BookingCode,(BB.FirstName+''+BB.LastName) AS GuestName,
		BB.BookingId,BB.GuestId,'Bed' AS Type FROM WRBHBBooking B
		JOIN WRBHBBedBookingPropertyAssingedGuest BB WITH(NOLOCK)ON B.Id=BB.BookingId AND BB.IsActive=1
		WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
		AND B.ClientId=@Id1
		
		INSERT INTO #BTC(BookingCode,GuestName,BookingId,GuestId,Type)
		SELECT B.BookingCode,(AB.FirstName+''+AB.LastName) AS GuestName,
		AB.BookingId,AB.GuestId,'Apartment' AS Type FROM WRBHBBooking B
		JOIN WRBHBApartmentBookingPropertyAssingedGuest AB WITH(NOLOCK)ON B.Id=AB.BookingId AND AB.IsActive=1
		WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
		AND B.ClientId=@Id1
		
		INSERT INTO #BTC(BookingCode,GuestName,BookingId,GuestId,Type)
		SELECT B.BookingCode,(RB.FirstName+''+RB.LastName) AS GuestName,
		RB.BookingId,RB.GuestId,'Room' AS Type FROM WRBHBBooking B
		JOIN WRBHBBookingPropertyAssingedGuest RB WITH(NOLOCK)ON B.Id=RB.BookingId AND RB.IsActive=1
		WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
		AND B.ClientId=@Id1
		
		SELECT BookingCode,GuestName,BookingId,GuestId,Type FROM #BTC
	END
IF @Action = 'GuestLoad'
	BEGIN
		CREATE TABLE #BTCFile(BookingCode INT,GuestName NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),FilePath NVARCHAR(100))
		IF @Str1='Bed'
		BEGIN
			INSERT INTO #BTCFile(BookingCode,GuestName,ChkInDate,ChkOutDate,FilePath)
			SELECT B.BookingCode,(BB.FirstName+''+BB.LastName) AS GuestName,
			BB.ChkInDt AS ChkInDate,BB.ChkOutDt AS ChkOutDate,ISNULL(BB.BTCFilePath,'')
			AS BTCPath  FROM WRBHBBooking B
			JOIN WRBHBBedBookingPropertyAssingedGuest BB WITH(NOLOCK)ON B.Id=BB.BookingId AND BB.IsActive=1
			WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
			AND BB.BookingId=@Id2 AND BB.GuestId=@Id1
		END
		ELSE
		IF @Str1='Apartment'
		BEGIN
			INSERT INTO #BTCFile(BookingCode,GuestName,ChkInDate,ChkOutDate,FilePath)
			SELECT B.BookingCode,(BB.FirstName+''+BB.LastName) AS GuestName,
			BB.ChkInDt AS ChkInDate,BB.ChkOutDt AS ChkOutDate,ISNULL(BB.BTCFilePath,'')
			AS BTCPath  FROM WRBHBBooking B
			JOIN WRBHBApartmentBookingPropertyAssingedGuest BB WITH(NOLOCK)ON B.Id=BB.BookingId AND BB.IsActive=1
			WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
			AND BB.BookingId=@Id2 AND BB.GuestId=@Id1
		END
		ELSE
		IF @Str1='Room'
		BEGIN
			INSERT INTO #BTCFile(BookingCode,GuestName,ChkInDate,ChkOutDate,FilePath)
			SELECT B.BookingCode,(BB.FirstName+''+BB.LastName) AS GuestName,
			BB.ChkInDt AS ChkInDate,BB.ChkOutDt AS ChkOutDate,ISNULL(BB.BTCFilePath,'')
			AS BTCPath  FROM WRBHBBooking B
			JOIN WRBHBBookingPropertyAssingedGuest BB WITH(NOLOCK)ON B.Id=BB.BookingId AND BB.IsActive=1
			WHERE ISNULL(TariffPaymentMode,0)='Bill to Company (BTC)' AND B.IsActive=1
			AND BB.BookingId=@Id2 AND BB.GuestId=@Id1
		END
		DECLARE @File NVARCHAR(100)
		SET @File=(SELECT FilePath FROM #BTCFile)
		IF @File !=''
		BEGIN
		SELECT BookingCode,GuestName,CONVERT(NVARCHAR,ChkInDate,103),
		CONVERT(NVARCHAR,ChkOutDate,103),FilePath FROM #BTCFile
		END
		ELSE
		BEGIN
			SELECT B.BookingCode,(BB.FirstName+''+BB.LastName) AS GuestName,
			CONVERT(NVARCHAR,BB.ChkInDt,103) AS ChkInDate,CONVERT(NVARCHAR,BB.ChkOutDt,103) AS ChkOutDate,ISNULL(CC.FileLoad,'')
			AS BTCPath  FROM WRBHBBooking B
			JOIN WRBHBBookingPropertyAssingedGuest BB WITH(NOLOCK)ON B.Id=BB.BookingId AND BB.IsActive=1
			JOIN WRBHBChechkOutHdr C WITH(NOLOCK)ON BB.CheckOutHdrId=C.Id AND BB.IsActive=1
			JOIN WRBHBChechkOutPaymentCompanyInvoice CC  WITH(NOLOCK)ON C.Id=CC.ChkOutHdrId AND BB.IsActive=1
			WHERE  BB.BookingId=@Id2 AND BB.GuestId=@Id1
		END
	END
END



