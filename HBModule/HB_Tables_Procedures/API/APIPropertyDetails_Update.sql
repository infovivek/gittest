SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIPropertyDetails_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIPropertyDetails_Update]
GO   
/* 
Author Name : Sakthi
Created Date : sep 12 2014
Section  	: API Property Details Update
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	
Sakthi          16 Dec 2014      Payment Flag added & Condtions Apply
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIPropertyDetails_Update](
@AvaRatePlanCode NVARCHAR(100),@AmountAfterTax DECIMAL(27,2),
@AmountBeforeTax DECIMAL(27,2),@AvaResponseReferenceKey NVARCHAR(100),
@BookHotelReservationIdvalue NVARCHAR(100),@HotelId BIGINT,
@BookHotelReservationIdtype NVARCHAR(100),@BookingId BIGINT,
@BookResponseReferenceKey NVARCHAR(100),@UsrId BIGINT) 
AS
BEGIN
 UPDATE WRBHBBookingProperty SET AvaRatePlanCode = @AvaRatePlanCode,
 AmountAfterTax = @AmountAfterTax,AmountBeforeTax = @AmountBeforeTax,
 AvailabilityResponseReferenceKey = @AvaResponseReferenceKey,
 BookHotelReservationIdvalue = @BookHotelReservationIdvalue,
 BookHotelReservationIdtype = @BookHotelReservationIdtype,
 BookResponseReferenceKey = @BookResponseReferenceKey
 WHERE PropertyId = @HotelId AND BookingId = @BookingId;
 --
 DECLARE @Cnt INT = 0,@BookingCode BIGINT = 0,@PaymentFlag BIT = 0;
 SELECT @BookingCode = ISNULL(BookingCode,0),@PaymentFlag = PaymentFlag 
 FROM WRBHBBooking WHERE Id = @BookingId;
 IF @PaymentFlag = 1
  BEGIN
   IF @BookingCode = 0
    BEGIN
     SET @Cnt = (SELECT COUNT(*) FROM WRBHBBooking WHERE IsDeleted = 0 AND
     IsActive = 1 AND BookingCode != 0);
     IF @Cnt = 0 
      BEGIN 
       SET @BookingCode=1; 
      END
     ELSE
      BEGIN
       SET @BookingCode = (SELECT TOP 1 BookingCode + 1 FROM WRBHBBooking
       WHERE IsDeleted = 0 AND IsActive = 1 AND BookingCode != 0
       ORDER BY BookingCode DESC);
      END
    UPDATE WRBHBBooking SET BookingCode = @BookingCode WHERE Id = @BookingId;
    END
   --
   DECLARE @MMTPONoId BIGINT = 0,@MMTPONo NVARCHAR(100) = '';
   IF EXISTS (SELECT NULL FROM WRBHBBooking WHERE MMTPONoId != 0)
    BEGIN
     SET @MMTPONoId = (SELECT TOP 1 MMTPONoId + 1 FROM WRBHBBooking 
     WHERE MMTPONoId != 0 ORDER BY MMTPONoId DESC);
    END
   ELSE 
    BEGIN 
     SET @MMTPONoId = 1; 
    END
   --
   IF EXISTS (SELECT NULL FROM WRBHBBooking
   WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND 
   YEAR(CreatedDate) = YEAR(GETDATE()) AND MMTPONo != '')
    BEGIN
     SELECT TOP 1 @MMTPONo = SUBSTRING(MMTPONo,0,13) + '0' +
     CAST(CAST(SUBSTRING(MMTPONo,13,LEN(MMTPONo)) AS INT) + 1 AS VARCHAR)
     FROM WRBHBBooking WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND
     YEAR(CreatedDate) = YEAR(GETDATE()) AND MMTPONo != ''
     ORDER BY MMTPONoId DESC;
    END
   ELSE
    BEGIN
     SELECT @MMTPONo = 'MMT/' + CAST(YEAR(GETDATE()) AS VARCHAR) + '-' +
     CAST(SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),4,2) AS VARCHAR) + '/01';
    END
   --
   UPDATE WRBHBBooking SET MMTPONo = @MMTPONo,MMTPONoId = @MMTPONoId
   WHERE Id = @BookingId;
 END
 --
 SELECT Id,BookingCode FROM WRBHBBooking WHERE Id=@BookingId;
END
GO
