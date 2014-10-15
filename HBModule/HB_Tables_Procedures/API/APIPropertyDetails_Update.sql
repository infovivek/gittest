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
 UPDATE WRBHBBookingProperty SET AvaRatePlanCode=@AvaRatePlanCode,
 AmountAfterTax=@AmountAfterTax,AmountBeforeTax=@AmountBeforeTax,
 AvailabilityResponseReferenceKey=@AvaResponseReferenceKey,
 BookHotelReservationIdvalue=@BookHotelReservationIdvalue,
 BookHotelReservationIdtype=@BookHotelReservationIdtype,
 BookResponseReferenceKey=@BookResponseReferenceKey
 --,ModifiedBy=@UsrId,ModifiedDate=GETDATE()
 WHERE PropertyId=@HotelId AND BookingId=@BookingId;
 --
 DECLARE @Cnt INT=0,@BookingCode BIGINT=0;
 SET @BookingCode=(SELECT ISNULL(BookingCode,0) FROM WRBHBBooking 
 WHERE Id=@BookingId);
 IF @BookingCode = 0
  BEGIN   
   SET @Cnt=(SELECT COUNT(*) FROM WRBHBBooking WHERE IsDeleted=0 AND 
   IsActive=1 AND BookingCode != 0);
   IF @Cnt = 0 BEGIN SET @BookingCode=1; END
   ELSE
    BEGIN
     SET @BookingCode=(SELECT TOP 1 BookingCode+1 FROM WRBHBBooking 
     WHERE IsDeleted=0 AND IsActive=1 AND BookingCode != 0 
     ORDER BY BookingCode DESC);
    END
  END
 --
 UPDATE WRBHBBooking SET BookingCode=@BookingCode
 --,ModifiedBy=@UsrId,ModifiedDate=GETDATE() 
 WHERE Id=@BookingId;
 --
 SELECT Id,BookingCode FROM WRBHBBooking WHERE Id=@BookingId;
END
GO
