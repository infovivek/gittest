-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingMailResend_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingMailResend_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:2-Jun-2014
-- Description:	BOOKING
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BookingMailResend_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),
@Str3 NVARCHAR(100),@Str4 NVARCHAR(100),
@Id1 BIGINT,@Id2 BIGINT,@Id3 BIGINT,@Id4 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'Client_Property_Load'
 BEGIN
  -- Client
  SELECT ClientName,Id FROM WRBHBClientManagement
  WHERE IsActive=1 AND IsDeleted=0 ORDER BY ClientName ASC;
  -- Property
  SELECT PropertyName,Id AS ZId FROM WRBHBProperty
  WHERE IsActive=1 AND IsDeleted=0 ORDER BY PropertyName ASC;
  -- User Email Id
  SELECT ISNULL(Email,'') AS Email FROM WRBHBUser WHERE Id=@Id1;
 END
IF @Action = 'BookingLoad'
 BEGIN
  CREATE TABLE #TMP(BookingCode BIGINT,Id BIGINT,
  BookingLevelId NVARCHAR(100),ClientId INT,PropertyId INT);
  INSERT INTO #TMP(BookingCode,Id,BookingLevelId,ClientId,PropertyId)
  -- Room Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId,
  B.ClientId,BG.BookingPropertyId 
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
  BP.BookingId=B.Id --AND BP.PropertyType != 'MMT'
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyId=BP.PropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked'
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId
  UNION ALL
  -- Bed Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId ,
  B.ClientId,BG.BookingPropertyId 
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked'
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId
  UNION ALL
  -- Apartment Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId,
  B.ClientId,BG.BookingPropertyId  
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked'
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId;
  IF @Id1 != 0 AND @Id2 = 0
   BEGIN
    SELECT BookingCode,Id,BookingLevelId FROM #TMP
    WHERE ClientId=@Id1 ORDER BY BookingCode DESC;
   END
  IF @Id1 = 0 AND @Id2 != 0
   BEGIN
    SELECT BookingCode,Id,BookingLevelId FROM #TMP
    WHERE PropertyId=@Id2 ORDER BY BookingCode DESC;
   END
  IF @Id1 != 0 AND @Id2 != 0
   BEGIN
    SELECT BookingCode,Id,BookingLevelId FROM #TMP
    WHERE ClientId=@Id1 AND PropertyId=@Id2
    ORDER BY BookingCode DESC;
   END
  IF @Id1 = 0 AND @Id2 = 0
   BEGIN
    SELECT BookingCode,Id,BookingLevelId FROM #TMP
    ORDER BY BookingCode DESC;
   END
 END
END
