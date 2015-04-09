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
  SELECT dbo.TRIM(C.CityCode),BP.PropertyId,dbo.TRIM(BP.RatePlanCode),dbo.TRIM(BP.RoomTypeCode),
  CAST(BG.ChkInDt AS VARCHAR),CAST(BG.ChkOutDt AS VARCHAR),
  @Single,@Dub,
  'shiv@hummingbirdindia.com',
  --'hotels-qa@makemytrip.com',
  dbo.TRIM(BG.FirstName),dbo.TRIM(BG.Title),dbo.TRIM(BG.LastName) FROM WRBHBBooking B
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
  IF @Str2 = '123'
   BEGIN
    SELECT 'No' AS Sts,'Cannot process. New Tariff Updated.' AS Strg;
   END
  ELSE
   BEGIN
    SELECT 'No' AS Sts,
    'Rooms are not available on the specified date range' AS Strg;
   END
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
  --SINGLE ROOM RATE
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=1 AND T.Tariffgroup='RoomRate';
  --DOUBLE ROOM RATE
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=2 AND T.Tariffgroup='RoomRate';
  --SINGLE ROOM TAX
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=1 AND T.Tariffgroup='Taxes';
  --DOUBLE ROOM TAX
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=2 AND T.Tariffgroup='Taxes';
  --SINGLE ROOM DISCOUNT
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=1 AND T.Tariffgroup='RoomDiscount';
  --DOUBLE ROOM DISCOUNT
  SELECT T.Tariffamount FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK) ON T.RoomRateHdrId=RR.Id AND
  T.HeaderId=RR.HeaderId AND T.HotelId=RR.HotelId
  WHERE RR.HeaderId=@Id1 AND RR.HotelId=@Str1 AND
  RR.RoomRateratePlanCode=@Str2 AND RR.RoomRateroomTypeCode=@Str3 AND
  T.RoomTariffroomNumber=2 AND T.Tariffgroup='RoomDiscount';
  -- diff
  SELECT 2;
 END
IF @Action = 'CityCode'
 BEGIN
  SELECT '';  
  SELECT dbo.TRIM(CityCode) FROM WRBHBAPICityCode 
  WHERE ISNULL(CityCode,'') IN ('BLR','BOM','DEL','GOI','JAI','MAA','PNQ','XCR')
  ORDER BY Id ASC;
  SELECT dbo.TRIM(CityCode) FROM WRBHBAPICityCode 
  WHERE ISNULL(CityCode,'') != '' ORDER BY Id ASC;
  /*SELECT dbo.TRIM(CityCode) FROM WRBHBAPICityCode 
  WHERE ISNULL(CityCode,'') != '' AND
  ISNULL(CityCode,'') NOT IN ('BLR','BOM','DEL','GOI','JAI','MAA','PNQ','XCR')
  ORDER BY Id ASC;*/  
  --SELECT 'BLR';
  --SELECT 'BOM';
  --SELECT 'DEL';
  --SELECT 'GOI';
  --SELECT 'JAI';
  --SELECT 'MAA';
  --SELECT 'PNQ';
  --SELECT 'XCR';
 END 
IF @Action = 'GetCityCode'
 BEGIN
  --SELECT '';
  SELECT CityCode FROM WRBHBCITY
  WHERE ISNULL(CityCode,'') != '' GROUP BY CityCode;
  --SELECT CityCode FROM WRBHBAPIHeader WHERE IsActive = 1 AND
  --CityCode NOT IN (SELECT CityCode FROM WRBHBAPIHeader WHERE IsActive = 1 AND 
  --CityId = 0 AND CityCode NOT IN ('JAI')) GROUP BY CityCode;
  --SELECT CityCode FROM WRBHBCity WHERE Id IN (0);
  --SELECT * FROM WRBHBCity WHERE CityCode = 'BOM';
  --SELECT CityCode FROM WRBHBCity WHERE IsActive = 1 AND IsDeleted = 0 AND
  --ISNULL(CityCode,'') != '' GROUP BY CityCode ORDER BY CityCode ASC;
 END
IF @Action = 'GetCityId'
 BEGIN
  /*SELECT Id FROM WRBHBCity 
  WHERE ISNULL(CityCode,'') != '' AND IsActive = 1 AND IsDeleted = 0
  ORDER BY Id ASC;*/
  --select Id from WRBHBCity where Id in (2423)
  select Id from WRBHBCity where Id in (0)
  --SELECT 1107 AS Id; --BANGLORE
  --SELECT 2423 AS Id; --COIMBATORE
  --SELECT * FROM WRBHBCity WHERE CityCode='CJB'
  --SELECT * FROM WRBHBCity WHERE CityCode='BLR'
  --SELECT 0 AS Id;
  /*---------------
  select a.CityCode,a.CityId,count(b.HotelCount),b.HotelCount,a.IsActive 
  from WRBHBAPIHeader a
  left outer join WRBHBAPIHotelHeader b on b.HeaderId=a.Id
  group by a.CityCode,a.CityId,b.HotelCount,a.IsActive;
  --------------
  select * from WRBHBAPIHeader
  select * from WRBHBAPIHotelHeader
  select * from WRBHBAPIRateMealPlanInclusionDtls
  select * from WRBHBAPIRoomRateDtls
  select * from WRBHBAPIRoomTypeDtls
  select * from WRBHBAPITariffDtls
  /*truncate table WRBHBAPIHeader
  truncate table WRBHBAPIHotelHeader
  truncate table WRBHBAPIRateMealPlanInclusionDtls
  truncate table WRBHBAPIRoomRateDtls
  truncate table WRBHBAPIRoomTypeDtls
  truncate table WRBHBAPITariffDtls*/
  -------------
  select count(*) from WRBHBAPIHeader--581
  select count(*) from WRBHBAPIHotelHeader--11162
  select COUNT(*) from WRBHBAPIRateMealPlanInclusionDtls--25924
  select COUNT(*) from WRBHBAPIRoomRateDtls--25924
  select COUNT(*) from WRBHBAPIRoomTypeDtls--21224
  select COUNT(*) from WRBHBAPITariffDtls--117572
  -------------*/
 END
IF @Action = 'MMTTariffTaxesUpdate'
 BEGIN
  UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id1
  WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '1');
  UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id2
  WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '2');  
  IF EXISTS(SELECT NULL FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'Taxes' AND RoomTariffroomNumber = '1')
   BEGIN
    UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id3
    WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'Taxes' AND RoomTariffroomNumber = '1');
   END
  ELSE
   BEGIN
    INSERT INTO WRBHBAPITariffDtls(HeaderId,HotelId,RoomRateHdrId,
    RoomTariffroomNumber,Tarifftype,Tariffgroup,Tariffamount)
    SELECT T.HeaderId,T.HotelId,T.RoomRateHdrId,T.RoomTariffroomNumber,
    'Taxes','Taxes',@Id3 FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '1';
   END
  IF EXISTS(SELECT NULL FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'Taxes' AND RoomTariffroomNumber = '2')
   BEGIN
    UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id4
    WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'Taxes' AND RoomTariffroomNumber = '2');
   END
  ELSE
   BEGIN
    INSERT INTO WRBHBAPITariffDtls(HeaderId,HotelId,RoomRateHdrId,
    RoomTariffroomNumber,Tarifftype,Tariffgroup,Tariffamount)
    SELECT T.HeaderId,T.HotelId,T.RoomRateHdrId,T.RoomTariffroomNumber,
    'Taxes','Taxes',@Id3 FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '2';
   END
 END
IF @Action = 'MMTDiscountUpdate'
 BEGIN
  IF EXISTS(SELECT NULL FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'RoomDiscount' AND RoomTariffroomNumber = '1')
   BEGIN
    UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id1
    WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomDiscount' AND RoomTariffroomNumber = '1');
   END
  ELSE
   BEGIN
    INSERT INTO WRBHBAPITariffDtls(HeaderId,HotelId,RoomRateHdrId,
    RoomTariffroomNumber,Tarifftype,Tariffgroup,Tariffamount)
    SELECT T.HeaderId,T.HotelId,T.RoomRateHdrId,T.RoomTariffroomNumber,
    'RoomDiscount','RoomDiscount',@Id3 FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '1';
   END
  IF EXISTS(SELECT NULL FROM WRBHBAPIRoomRateDtls RR
  LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
  T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
  WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
  RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
  T.Tariffgroup = 'RoomDiscount' AND RoomTariffroomNumber = '2')
   BEGIN
    UPDATE WRBHBAPITariffDtls SET Tariffamount = @Id2
    WHERE Id IN (SELECT T.Id FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomDiscount' AND RoomTariffroomNumber = '2');
   END
  ELSE
   BEGIN
    INSERT INTO WRBHBAPITariffDtls(HeaderId,HotelId,RoomRateHdrId,
    RoomTariffroomNumber,Tarifftype,Tariffgroup,Tariffamount)
    SELECT T.HeaderId,T.HotelId,T.RoomRateHdrId,T.RoomTariffroomNumber,
    'RoomDiscount','RoomDiscount',@Id3 FROM WRBHBAPIRoomRateDtls RR
    LEFT OUTER JOIN WRBHBAPITariffDtls T WITH(NOLOCK)ON 
    T.HeaderId = RR.HeaderId AND T.RoomRateHdrId = RR.Id
    WHERE RR.HotelId = @Str1 AND RR.RoomRateratePlanCode = @Str2 AND
    RR.RoomRateroomTypeCode = @Str3 AND RR.HeaderId = @Str4 AND
    T.Tariffgroup = 'RoomRate' AND RoomTariffroomNumber = '2';
   END
 END
IF @Action = 'MMTWindowsService'
 BEGIN
  SELECT '';
  --SELECT 'CJB';SELECT '2015-03-26','2015-03-27';
  --SELECT CityCode FROM WRBHBCity WHERE ISNULL(CityCode,'') != '' GROUP BY CityCode ORDER BY CityCode ASC;SELECT '2015-03-30','2015-03-31';
  --SELECT CityCode FROM WRBHBCity WHERE ISNULL(CityCode,'') != '' GROUP BY CityCode ORDER BY CityCode ASC;SELECT CAST(CONVERT(DATE,DATEADD(DAY,6,GETDATE()),103) AS VARCHAR),CAST(CONVERT(DATE,DATEADD(DAY,7,GETDATE()),103) AS VARCHAR);
 END
END
