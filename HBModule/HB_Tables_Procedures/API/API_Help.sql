-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_API_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_API_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:21-Aug-2014
-- Description:	API
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_API_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@Str3 NVARCHAR(100),@Str4 NVARCHAR(100),
@Id1 BIGINT,@Id2 BIGINT,@Id3 BIGINT,@Id4 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'UPDATEAPI'
 BEGIN
  UPDATE WRBHBAPIHeader SET IsActive=0,IsDeleted=1,ModifiedBy=@Id1,
  ModifiedDate=GETDATE() WHERE Id=@Id2;
  --
  SELECT @Id2 AS Id;
 END
IF @Action = 'MMTdata'
 BEGIN
  CREATE TABLE #OCCPNCY(Occupancy NVARCHAR(100),RoomCaptured INT);
  INSERT INTO #OCCPNCY(Occupancy,RoomCaptured)
  SELECT Occupancy,RoomCaptured FROM WRBHBBookingPropertyAssingedGuest BG
  WHERE BG.IsActive=1 AND IsDeleted=0 AND BG.BookingId=@Id1
  GROUP BY Occupancy,RoomCaptured;
  --
  DECLARE @Single INT=0,@Dub INT=0;
  SET @Single = (SELECT COUNT(*) FROM #OCCPNCY WHERE Occupancy='Single');
  SET @Dub = (SELECT COUNT(*) FROM #OCCPNCY WHERE Occupancy='Double');
  --
  --SELECT @Single,@Dub,@Id1;
  SELECT C.CityCode,BP.PropertyId,BP.RatePlanCode,BP.RoomTypeCode,
  CAST(BG.ChkInDt AS VARCHAR),CAST(BG.ChkOutDt AS VARCHAR),
  @Single,@Dub,
  'shiv@hummingbirdindia.com',
  --'hotels-qa@makemytrip.com',
  BG.FirstName,BG.Title,BG.LastName FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND
  BG.BookingPropertyId=BP.PropertyId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=B.CityId
  WHERE B.Id=@Id1;
 END
IF @Action = 'FalseFlagLoad'
 BEGIN
  --SELECT 'No' AS Sts,@Str1 AS Strg;
  SELECT 'No' AS Sts,'Rooms are not available on the specified date range' AS Strg;
 END
IF @Action = 'TrueFlagLoad'
 BEGIN
  SELECT 'Yes' AS Sts;
 END
IF @Action = 'BookFalseFlagLoad'
 BEGIN
  --SELECT 'No' AS Sts,@Str1 AS Strg;
  SELECT 'No' AS Sts,'Rooms are not available on the specified date range' AS Strg;
 END
IF @Action = 'BookTrueFlagLoad'
 BEGIN
  SELECT 'Yes' AS Sts;
 END
IF @Action = 'SingleDoubleRateLoad'
 BEGIN
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=1 AND T.Tariffgroup='RoomRate';
  --
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=2 AND T.Tariffgroup='RoomRate';
 END
IF @Action = 'CityCode'
 BEGIN
  SELECT dbo.TRIM(CityCode) FROM WRBHBAPICityCode 
  WHERE ISNULL(CityCode,'') != '' --AND Id > 651
  ORDER BY Id ASC;
  --SELECT CityCode FROM WRBHBAPICityCode WHERE Id=267;
  --SELECT 'TCC';
  --SELECT 'NYT';  
  --SELECT * FROM WRBHBAPICityCode WHERE CityCode='NYT'  
 END 
IF @Action = 'GetCityId'
 BEGIN
  /*SELECT Id FROM WRBHBCity 
  WHERE ISNULL(CityCode,'') != '' AND IsActive=1 AND IsDeleted=0
  ORDER BY Id ASC;*/
  --
  --SELECT Id FROM WRBHBCity WHERE citycode IN ('DEL','JAI');
  --
  --SELECT 1107 AS Id; BANGLORE
  SELECT 0 AS Id; -- COIMBATORE
  --SELECT * FROM WRBHBCity WHERE CityCode='CJB'
  --SELECT * FROM WRBHBCity WHERE CityCode='BLR'
 END 
END
