-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Report]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Report]
GO 
CREATE PROCEDURE [dbo].[SP_Booking_Report](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ClientId INT)			
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'MMTBookingDtls'
 BEGIN
  CREATE TABLE #TMP(BookingCode BIGINT,MMTId NVARCHAR(100),
  ClientName NVARCHAR(100),Occupancy NVARCHAR(100),Tariff DECIMAL(27,2),
  SingleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
  DoubleTariff DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
  MMTSingle DECIMAL(27,2),MMTDouble DECIMAL(27,2),
  BookingId BIGINT,RoomCaptured INT,Name NVARCHAR(100),
  PropertyName NVARCHAR(100),BeforeTaxTariff DECIMAL(27,2),
  AfterTaxTariff DECIMAL(27,2));
  INSERT INTO #TMP(BookingCode,MMTId,ClientName,Occupancy,Tariff,
  SingleTariff,SingleandMarkup,DoubleTariff,DoubleandMarkup,MMTSingle,
  MMTDouble,BookingId,RoomCaptured,Name,PropertyName,
  BeforeTaxTariff,AfterTaxTariff)
  SELECT B.BookingCode,BP.BookHotelReservationIdvalue,C.ClientName,
  BG.Occupancy,BG.Tariff,BP.SingleTariff,
  BP.SingleandMarkup1 AS SingleandMarkup,
  BP.DoubleTariff,BP.DoubleandMarkup1 AS DoubleandMarkup,
  BP.SingleRoomRate + BP.SingleTaxes - BP.SingleRoomDiscount AS 
  MMTSingle,BP.DubRoomRate + BP.DubTaxes - BP.DubRoomDiscount AS MMTDouble,
  B.Id,BG.RoomCaptured,BG.FirstName+' '+BG.LastName,BP.PropertyName,
  BP.AmountBeforeTax,BP.AmountAfterTax 
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  B.Id = BP.BookingId
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  B.Id = BG.BookingId AND BP.Id = BG.BookingPropertyTableId AND
  BP.PropertyId = BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  B.ClientId = C.Id
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND
  BP.IsActive = 1 AND BP.IsDeleted = 0 AND
  BP.PropertyType = 'MMT' AND B.MMTPONo != '' AND
  B.BookedDt BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
  GROUP BY B.BookingCode,BP.BookHotelReservationIdvalue,C.ClientName,
  BG.Occupancy,BG.Tariff,BP.SingleTariff,BP.SingleandMarkup1,
  BP.DoubleTariff,BP.DoubleandMarkup1,
  BP.SingleRoomRate,BP.SingleTaxes,BP.SingleRoomDiscount,
  BP.DubRoomRate,BP.DubTaxes,BP.DubRoomDiscount,
  B.Id,BG.RoomCaptured,BG.FirstName,BG.LastName,BG.Id,BP.PropertyName,
  BP.AmountBeforeTax,BP.AmountAfterTax;
  --
  CREATE TABLE #TMP1(Name NVARCHAR(100),BookingCode BIGINT,MMTId NVARCHAR(100),
  ClientName NVARCHAR(100),Occupancy NVARCHAR(100),Tariff DECIMAL(27,2),
  SingleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
  DoubleTariff DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
  MMTSingle DECIMAL(27,2),MMTDouble DECIMAL(27,2),
  PropertyName NVARCHAR(100),BeforeTaxTariff DECIMAL(27,2),
  AfterTaxTariff DECIMAL(27,2));
  INSERT INTO #TMP1(Name,BookingCode,MMTId,ClientName,Occupancy,Tariff,
  SingleTariff,SingleandMarkup,DoubleTariff,DoubleandMarkup,MMTSingle,
  MMTDouble,PropertyName,BeforeTaxTariff,AfterTaxTariff)
  SELECT STUFF((SELECT ', '+T1.Name FROM #TMP T1 
  WHERE T1.BookingId = T2.BookingId AND T1.RoomCaptured = T2.RoomCaptured
  FOR XML PATH('')),1,1,'') AS Name,T2.BookingCode,T2.MMTId,T2.ClientName,
  T2.Occupancy,T2.Tariff,T2.SingleTariff,T2.SingleandMarkup,T2.DoubleTariff,
  T2.DoubleandMarkup,T2.MMTSingle,T2.MMTDouble,T2.PropertyName,
  T2.BeforeTaxTariff,T2.AfterTaxTariff FROM #TMP T2
  GROUP BY T2.BookingCode,T2.MMTId,T2.ClientName,
  T2.Occupancy,T2.Tariff,T2.SingleTariff,T2.SingleandMarkup,T2.DoubleTariff,
  T2.DoubleandMarkup,T2.MMTSingle,T2.MMTDouble,T2.PropertyName,
  T2.BookingId,T2.RoomCaptured,T2.BeforeTaxTariff,T2.AfterTaxTariff;
  --
  SELECT BookingCode,MMTId AS MMTCode,ClientName,Occupancy,
  CASE WHEN Occupancy = 'Double' THEN DoubleTariff
  ELSE SingleTariff END AS Tariff,
  Tariff AS TariffandMarkup,AfterTaxTariff FROM #TMP1; 
 END
IF @Action = 'BookingHRPolicyOverride'
 BEGIN
  CREATE TABLE #HR(BookingCode BIGINT,BookingId BIGINT,Name NVARCHAR(100),
  Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),PropertyName NVARCHAR(100),
  RoomCaptured INT,EmpCode NVARCHAR(100),GradeId BIGINT,CityId BIGINT,
  CityName NVARCHAR(100),ClientId BIGINT,ClientName NVARCHAR(100),
  Grade NVARCHAR(100),BookingLevel NVARCHAR(100));
  -- Room
  INSERT INTO #HR(BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  RoomCaptured,EmpCode,GradeId,CityId,CityName,ClientId,ClientName,Grade,
  BookingLevel)
  SELECT B.BookingCode,B.Id,BPG.FirstName+' '+BPG.LastName,BPG.Tariff,
  BPG.Occupancy,BP.PropertyName,BPG.RoomCaptured,BG.EmpCode,
  BG.GradeId,B.CityId,C.CityName,B.ClientId,CM.ClientName,GM.Grade,'Room'
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
  BG.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BPG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BPG.BookingPropertyTableId = BP.Id AND
  BPG.BookingPropertyId = BP.PropertyId AND
  BPG.GuestId = BG.GuestId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK)ON CM.Id = B.ClientId
  LEFT OUTER JOIN WRBHBGradeMaster GM WITH(NOLOCK)ON GM.Id = BG.GradeId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BG.IsActive = 1 AND
  BG.IsDeleted = 0 AND BP.IsActive = 1 AND BP.IsDeleted = 0 AND
  BG.GradeId != 0 AND B.GradeId = 0 AND BPG.Tariff != 0 AND
  B.BookingLevel = 'Room' AND B.ClientId = @ClientId AND
  B.BookedDt BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
  GROUP BY B.BookingCode,B.Id,BPG.FirstName,BPG.LastName,BPG.Tariff,
  BPG.Occupancy,BP.PropertyName,BPG.RoomCaptured,BPG.GuestId,BG.EmpCode,
  BG.GradeId,B.CityId,B.ClientId,CM.ClientName,C.CityName,GM.Grade;
  -- Bed
  INSERT INTO #HR(BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  RoomCaptured,EmpCode,GradeId,CityId,CityName,ClientId,ClientName,Grade,
  BookingLevel)
  SELECT B.BookingCode,B.Id,BPG.FirstName+' '+BPG.LastName,BPG.Tariff,
  'Bed',BP.PropertyName,2,BG.EmpCode,BG.GradeId,B.CityId,C.CityName,
  B.ClientId,CM.ClientName,GM.Grade,'Bed'
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
  BG.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BPG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BPG.BookingPropertyTableId = BP.Id AND
  BPG.BookingPropertyId = BP.PropertyId AND
  BPG.GuestId = BG.GuestId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK)ON CM.Id = B.ClientId
  LEFT OUTER JOIN WRBHBGradeMaster GM WITH(NOLOCK)ON GM.Id = BG.GradeId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BG.IsActive = 1 AND
  BG.IsDeleted = 0 AND BP.IsActive = 1 AND BP.IsDeleted = 0 AND
  BG.GradeId != 0 AND B.GradeId = 0 AND BPG.Tariff != 0 AND
  B.BookingLevel = 'Bed' AND B.ClientId = @ClientId AND
  B.BookedDt BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
  GROUP BY B.BookingCode,B.Id,BPG.FirstName,BPG.LastName,BPG.Tariff,
  BP.PropertyName,BPG.GuestId,BG.EmpCode,BG.GradeId,B.CityId,B.ClientId,
  CM.ClientName,C.CityName,GM.Grade;
  -- Apartment
  INSERT INTO #HR(BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  RoomCaptured,EmpCode,GradeId,CityId,CityName,ClientId,ClientName,Grade)
  SELECT B.BookingCode,B.Id,BPG.FirstName+' '+BPG.LastName,BPG.Tariff,
  'Apartment',BP.PropertyName,2,BG.EmpCode,
  BG.GradeId,B.CityId,C.CityName,B.ClientId,CM.ClientName,GM.Grade
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
  BG.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BPG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BPG.BookingPropertyTableId = BP.Id AND
  BPG.BookingPropertyId = BP.PropertyId AND
  BPG.GuestId = BG.GuestId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK)ON CM.Id = B.ClientId
  LEFT OUTER JOIN WRBHBGradeMaster GM WITH(NOLOCK)ON GM.Id = BG.GradeId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BG.IsActive = 1 AND
  BG.IsDeleted = 0 AND BP.IsActive = 1 AND BP.IsDeleted = 0 AND
  BG.GradeId != 0 AND B.GradeId = 0 AND BPG.Tariff != 0 AND
  B.BookingLevel = 'Apartment' AND B.ClientId = @ClientId AND
  B.BookedDt BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
  GROUP BY B.BookingCode,B.Id,BPG.FirstName,BPG.LastName,BPG.Tariff,
  BP.PropertyName,BPG.GuestId,BG.EmpCode,BG.GradeId,B.CityId,B.ClientId,
  CM.ClientName,C.CityName,GM.Grade;
  -- CHECK TOTAL COUNT
  --SELECT COUNT(*) FROM #HR;
  --
  CREATE TABLE #GradeMaxVal(GradeId BIGINT,CityId BIGINT,Val NVARCHAR(100));
  INSERT INTO #GradeMaxVal(GradeId,CityId,Val)
  SELECT HR.GradeId,HR.CityId,
  CASE WHEN ISNULL(CG.ValueStarRatingFlag,0) = 0 THEN 
  CAST(CG.MaxValue AS VARCHAR)
  ELSE PT.PropertyType END FROM #HR HR
  LEFT OUTER JOIN WRBHBClientGradeValue CG WITH(NOLOCK)ON 
  HR.GradeId = CG.GradeId AND HR.ClientId = CG.ClientId
  LEFT OUTER JOIN WRBHBClientGradeValueDetails CGV WITH(NOLOCK)ON
  CG.Id = CGV.ClientGradeValueId AND HR.CityId = CGV.CityId  
  LEFT OUTER JOIN WRBHBPropertyType PT WITH(NOLOCK)ON 
  CG.StarRatingId = PT.Id
  WHERE CG.IsActive = 1 AND CG.IsDeleted = 0 AND
  CGV.IsActive = 1 AND CGV.IsDeleted = 0
  GROUP BY HR.GradeId,HR.CityId,CG.ValueStarRatingFlag,PT.PropertyType,
  CG.MaxValue;
  --
  CREATE TABLE #SDF(BookingCode BIGINT,BookingId BIGINT,Name NVARCHAR(100),
  Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),PropertyName NVARCHAR(100),
  RoomCaptured INT,EmpCode NVARCHAR(100),GradeId BIGINT,CityId BIGINT,
  CityName NVARCHAR(100),ClientId BIGINT,ClientName NVARCHAR(100),
  Grade NVARCHAR(100),Val NVARCHAR(100));
  INSERT INTO #SDF(BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  RoomCaptured,EmpCode,GradeId,CityId,CityName,ClientId,ClientName,Grade,Val)
  SELECT T1.BookingCode,T1.BookingId,T1.Name,T1.Tariff,T1.Occupancy,
  T1.PropertyName,T1.RoomCaptured,T1.EmpCode,T1.GradeId,T1.CityId,T1.CityName,
  T1.ClientId,T1.ClientName,T1.Grade,
  CASE WHEN ISNULL(T2.Val,'') = '' THEN '0.00'
  ELSE T2.Val END FROM #HR T1
  LEFT OUTER JOIN #GradeMaxVal T2 WITH(NOLOCK)ON 
  T1.GradeId = T2.GradeId AND T1.CityId = T2.CityId
  GROUP BY T1.BookingCode,T1.BookingId,T1.Name,T1.Tariff,T1.Occupancy,
  T1.PropertyName,T1.RoomCaptured,T1.EmpCode,T1.GradeId,T1.CityId,T1.CityName,
  T1.ClientId,T1.ClientName,T1.Grade,T2.Val;
  -- 
  --SELECT BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  --RoomCaptured,EmpCode,GradeId,CityId,CityName,ClientId,ClientName,Grade,Val
  --FROM #SDF;
  --
  SELECT BookingCode,ClientName,EmpCode,Name AS GuestName,Occupancy,
  PropertyName,Grade,Val AS GradeMaxValue,Tariff,CityName FROM #SDF;
 END
IF @Action = 'HRPolicyOverride'
 BEGIN
  CREATE TABLE #ASD(BookingCode BIGINT,BookingId BIGINT,Name NVARCHAR(100),
  Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),PropertyName NVARCHAR(100),
  RoomCaptured INT);
  INSERT INTO #ASD(BookingCode,BookingId,Name,Tariff,Occupancy,PropertyName,
  RoomCaptured)
  SELECT B.BookingCode,B.Id,BPG.FirstName+' '+BPG.LastName,BPG.Tariff,
  BPG.Occupancy,BP.PropertyName,BPG.RoomCaptured
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingGuestDetails BG WITH(NOLOCK)ON
  B.Id = BG.BookingId
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  B.Id = BP.BookingId
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BPG WITH(NOLOCK)ON
  B.Id = BG.BookingId AND BP.Id = BPG.BookingPropertyTableId AND
  BP.PropertyId = BPG.BookingPropertyId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BG.IsActive = 1 AND
  BG.IsDeleted = 0 AND BP.IsActive = 1 AND BP.IsDeleted = 0 AND
  BG.GradeId != 0 AND B.GradeId = 0 AND BPG.Tariff != 0 AND
  B.ClientId = @ClientId AND
  B.BookedDt BETWEEN CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103)
  GROUP BY B.BookingCode,B.Id,BPG.FirstName,BPG.LastName,BPG.Tariff,
  BPG.Occupancy,BP.PropertyName,BPG.RoomCaptured,BPG.GuestId;
  --
  --SELECT * FROM #ASD;RETURN;
  --
  CREATE TABLE #ASDF(BookingCode BIGINT,GuestName NVARCHAR(100),
  Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),PropertyName NVARCHAR(100),
  BookingId BIGINT,RoomCaptured BIGINT);
  INSERT INTO #ASDF(GuestName,BookingCode,Occupancy,Tariff,PropertyName,
  BookingId,RoomCaptured)
  SELECT STUFF((SELECT ', '+T1.Name FROM #ASD T1 
  WHERE T1.BookingId = T2.BookingId AND T1.RoomCaptured = T2.RoomCaptured
  FOR XML PATH('')),1,1,'') AS GuestName,T2.BookingCode,
  T2.Occupancy,T2.Tariff,T2.PropertyName,T2.BookingId,
  T2.RoomCaptured FROM #ASD T2
  GROUP BY T2.BookingCode,T2.Occupancy,T2.Tariff,T2.PropertyName,
  T2.BookingId,T2.RoomCaptured;
  --
  --SELECT * FROM #ASDF;RETURN;
  /*--
  CREATE TABLE #ASDFA(BookingCode BIGINT,GuestName NVARCHAR(100),
  Tariff DECIMAL(27,2),Occupancy NVARCHAR(100),PropertyName NVARCHAR(100),
  EmpCode NVARCHAR(100),BookingId BIGINT,RoomCaptured BIGINT);
  INSERT INTO #ASDFA(EmpCode,GuestName,BookingCode,Occupancy,Tariff,
  PropertyName,BookingId,RoomCaptured)
  SELECT STUFF((SELECT ', '+T1.EmpCode FROM #ASDF T1 
  WHERE T1.BookingId = T2.BookingId AND T1.RoomCaptured = T2.RoomCaptured
  FOR XML PATH('')),1,1,'') AS EmpCode,T2.GuestName,T2.BookingCode,
  T2.Occupancy,T2.Tariff,T2.PropertyName,T2.BookingId,T2.RoomCaptured 
  FROM #ASDF T2
  GROUP BY T2.BookingCode,T2.Occupancy,T2.Tariff,T2.PropertyName,
  T2.BookingId,T2.RoomCaptured,T2.EmpCode,T2.GuestName;
  --*/
  SELECT BookingCode,GuestName,Tariff,Occupancy,PropertyName 
  FROM #ASDF 
  --GROUP BY BookingCode,GuestName,Tariff,Occupancy,PropertyName
  --ORDER BY BookingCode;
 END
END
	 