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
  BookingLevelId NVARCHAR(100),ClientId INT,PropertyId INT,HBStay NVARCHAR(100));
  INSERT INTO #TMP(BookingCode,Id,BookingLevelId,ClientId,PropertyId,HBStay)
  -- Room Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId,
  B.ClientId,BG.BookingPropertyId,ISNULL(B.HBStay,'') 
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
  BP.BookingId=B.Id --AND BP.PropertyType != 'MMT'
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyId=BP.PropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked' AND B.BookingCode != 0
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId,ISNULL(B.HBStay,'')
  UNION ALL
  -- Bed Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId ,
  B.ClientId,BG.BookingPropertyId,ISNULL(B.HBStay,'')
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked' AND B.BookingCode != 0
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId,ISNULL(B.HBStay,'')
  UNION ALL
  -- Apartment Level Booking
  SELECT B.BookingCode,B.Id,B.BookingLevel AS BookingLevelId,
  B.ClientId,BG.BookingPropertyId,ISNULL(B.HBStay,'')
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND BG.CurrentStatus='Booked' AND B.BookingCode != 0
  GROUP BY B.BookingCode,B.Id,B.BookingLevel,B.ClientId,
  BG.BookingPropertyId,ISNULL(B.HBStay,'');
  IF @Str1 = 'HBStay'
   BEGIN
    SELECT BookingCode,Id,BookingLevelId FROM #TMP
    WHERE ClientId=@Id1 AND HBStay = 'StayCorporateHB' ORDER BY BookingCode DESC;
   END
  ELSE
   BEGIN
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
IF @Action = 'Client_Property_Load_hbstay'
 BEGIN
  -- MasterClient,Client
  DECLARE @TmpStr NVARCHAR(100) = '',@ClientId BIGINT = 0;
  SELECT TOP 1 @TmpStr = Designation,@ClientId = ClientId FROM WrbhbTravelDesk 
  WHERE IsActive = 1 AND IsDeleted = 0 AND Id = @Id1;
  --
  SELECT @TmpStr AS TmpStr;
  --
  IF @TmpStr = 'MasterClient'
   BEGIN
    SELECT ClientName,Id FROM WRBHBClientManagement
    WHERE IsActive=1 AND IsDeleted=0 AND MasterClientId = @ClientId 
    ORDER BY ClientName ASC;
   END
  ELSE
   BEGIN
    SELECT ClientName,Id FROM WRBHBClientManagement
    WHERE IsActive=1 AND IsDeleted=0 AND Id = @ClientId 
    ORDER BY ClientName ASC;
   END
  -- User Email Id
  SELECT dbo.TRIM(ISNULL(Email,'')) AS Email FROM WrbhbTravelDesk WHERE Id = @Id1;
 END
END
