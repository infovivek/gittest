-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Booking_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Booking_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:25-03-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	BOOKING
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Booking_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@StateId BIGINT,@CityId BIGINT,
@ClientId BIGINT,@PropertyId BIGINT,@GradeId BIGINT,
@Id1 BIGINT,@Id2 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'PageLoad'
 BEGIN
 -- client
  SELECT C.ClientName,C.BCity AS ClientPlace,C.Id,
  ISNULL(U.UserName,'') AS SalesId,
  ISNULL(U1.UserName,'') AS CRMId FROM WRBHBClientManagement C
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=C.SalesExecutiveId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  WHERE C.IsDeleted=0 AND C.IsActive=1
  ORDER BY C.ClientName ASC;
 -- date
  SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS CDt,
  CONVERT(VARCHAR(100),DATEADD(DAY,1,GETDATE()),103) AS NDt;
  --
  SELECT TrackingNo,Id FROM WRBHBBooking WHERE IsActive=1 AND 
  IsDeleted=0 AND TrackingNo != 0 AND Status='RmdPty';
 END
IF @Action = 'CityLoad'
 BEGIN
  SELECT CityName,Id FROM WRBHBCity 
  WHERE IsDeleted=0 AND IsActive=1 AND StateId=@StateId
  ORDER BY CityName ASC;
 END
IF @Action = 'GetAPIData'
 BEGIN
  SELECT TOP 1 Id,citycode FROM WRBHBAPIHeader
  WHERE IsActive=1 AND IsDeleted=0 AND CityId=@CityId AND
  ISNULL(citycode,'') != '' ORDER BY Id DESC;
 END
IF @Action = 'Tab1_Next'
 BEGIN
  -- state
  SELECT StateName,Id AS ZId FROM WRBHBState 
  WHERE IsActive=1 ORDER BY StateName;
  -- client BOOKER DTLS
  SELECT FirstName AS label,Email,Id 
  FROM WRBHBClientManagementAddNewClient
  WHERE IsDeleted = 0 AND IsActive = 1 AND ContactType = 'Booker' AND
  CltmgntId = @ClientId AND ISNULL(FirstName,'') != ''
  ORDER BY FirstName ASC;
  /*CREATE TABLE #Mail(label NVARCHAR(100),Email NVARCHAR(100),Id INT);
  INSERT INTO #Mail(label,Email,Id)
  SELECT 'Shiv','shiv@hummingbirdindia.com',1;  
  INSERT INTO #Mail(label,Email,Id)
  SELECT 'Girish','girish@hummingbirdindia.com',1;
  SELECT label,Email,Id FROM #Mail;*/
  -- Guest Exists Begin
  CREATE TABLE #BookedGuest(Sts NVARCHAR(100),GuestId BIGINT,
  ChkInDt DATE,ChkOutDt DATE);
  -- Booked Rooms Begin
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Room',PG.GuestId,PG.ChkInDt,ChkOutDt 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Room',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Room',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Room',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME);
  -- Booked Rooms End
  -- Booked Beds Begin
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Bed',PG.GuestId,PG.ChkInDt,PG.ChkOutDt
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Bed',PG.GuestId,PG.ChkInDt,PG.ChkOutDt
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Bed',PG.GuestId,PG.ChkInDt,PG.ChkOutDt
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Bed',PG.GuestId,PG.ChkInDt,PG.ChkOutDt
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME);
  -- Booked Beds End
  -- Booked Apartment Begin
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Apartment',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Apartment',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Apartment',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME);
  --
  INSERT INTO #BookedGuest(Sts,GuestId,ChkInDt,ChkOutDt)
  SELECT 'Apartment',PG.GuestId,PG.ChkInDt,PG.ChkOutDt 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME);
  -- Booked Apartment End
  --SET @Str1='20752,20751,20750,20749,20748,20747,20746,20731,20745,20744';
  CREATE TABLE #GstId(Id INT,GuestId BIGINT);
  INSERT INTO #GstId(Id,GuestId)
  SELECT * FROM dbo.Split(@Str1, ',');
  --
  CREATE TABLE #GUEST(GuestId BIGINT,Sts NVARCHAR(100),ChkInDt DATE,
  ChkOutDt DATE);
  INSERT INTO #GUEST(GuestId,Sts,ChkInDt,ChkOutDt)
  SELECT GuestId,Sts,ChkInDt,ChkOutDt FROM #BookedGuest
  WHERE GuestId IN (SELECT GuestId FROM #GstId)
  GROUP BY GuestId,Sts,ChkInDt,ChkOutDt;
  --
  DECLARE @Cnt INT = (SELECT COUNT(*) FROM #GUEST);
  IF @Cnt > 0
   BEGIN
    SELECT 'Guest Name : '+dbo.TRIM(ISNULL(C.FirstName,''))+' '+
    CASE WHEN dbo.TRIM(ISNULL(C.LastName,'')) = '.' OR 
              dbo.TRIM(ISNULL(C.LastName,'')) = ',' THEN ''
         ELSE dbo.TRIM(ISNULL(C.LastName,'')) END+', '+
    G.Sts+' Level Booking, '+'CheckIn Date : '+
    CONVERT(VARCHAR(100),G.ChkInDt,106)+', CheckOut Date : '+
    CONVERT(VARCHAR(100),G.ChkOutDt,106) AS Guest FROM #GUEST G
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest C
    WITH(NOLOCK)ON C.Id=G.GuestId
    ORDER BY C.Id;
   END
  ELSE
   BEGIN
    SELECT * FROM #GUEST;
   END
  -- Guest Exists End
 END
IF @Action = 'GuestDelete'
 BEGIN
  DELETE FROM WRBHBBookingGuestDetails WHERE Id=@Id1;
 END
IF @Action = 'Tab2_to_Tab3_Dtls'
 BEGIN
  -- TAB3 PROPERTY LOAD
  SELECT PropertyType+' - '+PropertyName AS label,
  CAST(PropertyId AS NVARCHAR) AS PropertyId,Id,PropertyType 
  FROM WRBHBBookingProperty
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  -- TAB3 GUEST LOAD
  SELECT GuestId,EmpCode,FirstName,LastName,0 AS Tick,1 AS Chk,
  FirstName+'  '+LastName AS Name 
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
 END
IF @Action = 'RmdPty_GuestDtls'
 BEGIN
  IF @Id2 = 123
   BEGIN
    DELETE FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id1;
   END
  -- tab 1 Guest Dlts
  SELECT GuestId,GradeId,EmpCode,Title,FirstName,LastName,Grade,Designation,
  EmailId,MobileNo,Nationality,Id FROM WRBHBBookingGuestDetails
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  -- tab 3 Guest Details
  SELECT GuestId,EmpCode,FirstName,LastName,Id AS BookingGuestTableId,
  0 AS Tick,1 AS Chk,FirstName+'  '+LastName AS Name  
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  -- Tab3 Property Load
  SELECT PropertyType+' - '+PropertyName AS label,PropertyId,Id,
  PropertyType FROM WRBHBBookingProperty
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
  -- Payment
  IF EXISTS (SELECT NULL FROM WRBHBBookingTrackingPayment 
  WHERE Success=1 AND BookingId = @Id1)
   BEGIN
    SELECT SUM(ISNULL(TotalAmount,0)) AS Amount 
    FROM WRBHBBookingTrackingPayment WHERE Success=1 AND BookingId = @Id1;
   END
  ELSE
   BEGIN
    SELECT '' AS Amount;
   END
 END
IF @Action = 'TrackingNoDtls'
 BEGIN
  SELECT ClientId,ClientName,CONVERT(VARCHAR,CheckInDate,103) AS CheckInDate,
  ExpectedChkInTime,CONVERT(VARCHAR,CheckOutDate,103) AS CheckOutDate,
  Sales,CRM,AMPM FROM WRBHBBooking WHERE Id=@Id1;
  -- tab 1 Guest Dlts
  SELECT GuestId,GradeId,EmpCode,Title,FirstName,LastName,Grade,Designation,
  EmailId,MobileNo,Nationality,Id
  FROM WRBHBBookingGuestDetails
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@Id1;
 END
IF @Action = 'AdvPaid_Save'
 BEGIN
  INSERT INTO WRBHBBookingAdvanceAmountPaid(BookingId,ClientId,PaymentMode,
  Name,Amount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,
  IsDeleted,RowId)
  VALUES(@Id1,@ClientId,@Str1,@Str2,@StateId,@Id2,GETDATE(),@Id2,GETDATE(),
  1,0,NEWID());
 END
/*IF @Action = 'GuestExists_Validation'
 BEGIN
  CREATE TABLE #BookedGuest1(Sts NVARCHAR(100),GuestId BIGINT);
  -- Booked Rooms Begin
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Room',PG.GuestId 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Room',PG.GuestId 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Room',PG.GuestId 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Room',PG.GuestId 
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  -- Booked Rooms End
  -- Booked Beds Begin
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Bed',PG.GuestId
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Bed',PG.GuestId
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Bed',PG.GuestId
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Bed',PG.GuestId
  FROM WRBHBBedBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) GROUP BY PG.GuestId;
  -- Booked Beds End
  -- Booked Apartment Begin
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Apartment',PG.GuestId 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Apartment',PG.GuestId 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Apartment',PG.GuestId 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME)
  GROUP BY PG.GuestId;
  --
  INSERT INTO #BookedGuest1(Sts,GuestId)
  SELECT 'Apartment',PG.GuestId 
  FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) GROUP BY PG.GuestId;
  -- Booked Apartment End
  SET @Str1='20752,20751,20750,20749,20748,20747,20746,20731,20745,20744';
  CREATE TABLE #GstId1(Id INT,GuestId BIGINT);
  INSERT INTO #GstId(Id,GuestId)
  SELECT * FROM dbo.Split(@Str1, ',');
  --  
  SELECT GuestId,Sts FROM #BookedGuest1
  WHERE GuestId IN (SELECT GuestId FROM #GstId1)
  GROUP BY GuestId,Sts;
 END*/
IF @Action = 'Property'
 BEGIN
  IF @Id2 = 123
   BEGIN
    /*DECLARE @TMPDeletePropertyId BIGINT = 0,@TMPPropertyType NVARCHAR(100)='';
    SELECT TOP 1 @TMPDeletePropertyId=PropertyId,@TMPPropertyType=PropertyType
    FROM WRBHBBookingProperty WHERE BookingId=@Id1;
    IF @TMPPropertyType = 'MMT'
     BEGIN
      DELETE FROM WRBHBAPIHotelHeader
      WHERE HotelId=@TMPDeletePropertyId AND HeaderId=@StateId;
      DELETE FROM WRBHBAPIRateMealPlanInclusionDtls
      WHERE HotelId=@TMPDeletePropertyId AND HeaderId=@StateId;
      DELETE FROM WRBHBAPIRoomRateDtls
      WHERE HotelId=@TMPDeletePropertyId AND HeaderId=@StateId;
      DELETE FROM WRBHBAPIRoomTypeDtls
      WHERE HotelId=@TMPDeletePropertyId AND HeaderId=@StateId;
      DELETE FROM WRBHBAPITariffDtls
      WHERE HotelId=@TMPDeletePropertyId AND HeaderId=@StateId;
     END*/
    DELETE FROM WRBHBBooking WHERE Id=@Id1;
    DELETE FROM WRBHBBookingGuestDetails WHERE BookingId=@Id1;
    DELETE FROM WRBHBBookingProperty WHERE BookingId=@Id1;
    DELETE FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@Id1;
   END
  DECLARE @StarFlag BIT=0,@StarId INT=0;
  DECLARE @MinValue DECIMAL(27,2)=0,@MaxValue DECIMAL(27,2)=0;
  DECLARE @StarCnt INT=0;
-- # Contract managed GH #
  CREATE TABLE #ExistingManagedGHProperty(RoomId BIGINT);
  -- Booked Room Begin
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;   
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103);*/
  -- Booked Room End
  -- Booked BED Begin
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  -- 
  INSERT INTO #ExistingManagedGHProperty(RoomId)
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Managed G H' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId GROUP BY PG.RoomId;
  -- Booked BED End
  -- Avaliable M G H Property
  CREATE TABLE #ManagedGH(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100));
  INSERT INTO #ManagedGH(PropertyName,Id,GetType,PropertyType)  
  SELECT P.PropertyName,P.Id,'Contract','MGH'
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId = P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId = A.Id
  LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D WITH(NOLOCK)ON
  D.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON 
  H.Id=D.ContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
  H.ContractType=' Managed Contracts ' AND R.IsActive=1 AND
  R.IsDeleted=0 AND P.CityId=@CityId AND H.ClientId=@ClientId AND
  P.Category='Managed G H' AND A.IsActive = 1 AND A.IsDeleted = 0 AND
  A.Status = 'Active' AND R.RoomStatus = 'Active' AND
  A.SellableApartmentType != 'HUB' AND 
  R.Id NOT IN (SELECT RoomId FROM #ExistingManagedGHProperty)
  GROUP BY P.PropertyName,P.Id;
-- # Dedicated #
  CREATE TABLE #ExistingDedicatedProperty(RoomId BIGINT);
  CREATE TABLE #ExDdPApartmnt(ApartmentId BIGINT);
  -- Booked Room Begin
  INSERT INTO #ExistingDedicatedProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;  
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingDedicatedProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingDedicatedProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExistingDedicatedProperty(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103);*/
  -- Booked Room End
  -- Booked Apartment Begin
  INSERT INTO #ExDdPApartmnt(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId; 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  --
  INSERT INTO #ExDdPApartmnt(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  --
  INSERT INTO #ExDdPApartmnt(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.ApartmentId;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103);*/
  -- 
  INSERT INTO #ExDdPApartmnt(ApartmentId) 
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId GROUP BY PG.ApartmentId; 
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103);*/
  -- Booked Apartment End
  -- Avaliable Property
  CREATE TABLE #Dedicated(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100));
  CREATE TABLE #TmpDedicated(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100));
  -- Room
  INSERT INTO #TmpDedicated(PropertyName,Id,GetType,PropertyType)
  SELECT P.PropertyName,P.Id,'Contract','DdP'
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D WITH(NOLOCK)ON
  P.Id=D.PropertyId
  LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON 
  H.Id=D.ContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
  H.ContractType=' Dedicated Contracts ' AND 
  H.BookingLevel='Room' AND P.CityId=@CityId AND H.ClientId=@ClientId AND
  D.RoomId NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty);
  -- Apartment
  INSERT INTO #TmpDedicated(PropertyName,Id,GetType,PropertyType)
  SELECT P.PropertyName,P.Id,'Contract','DdP' FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBContractManagementAppartment D
  WITH(NOLOCK)ON D.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
  R.PropertyId=D.PropertyId AND R.ApartmentId=D.ApartmentId
  LEFT OUTER JOIN WRBHBContractManagement H WITH(NOLOCK)ON 
  H.Id=D.ContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND
  R.IsActive=1 AND R.IsDeleted=0 AND 
  H.ContractType=' Dedicated Contracts ' AND H.BookingLevel='Apartment' AND
  H.ClientId=@ClientId AND P.CityId=@CityId AND
  D.ApartmentId NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt);
  --
  INSERT INTO #Dedicated(PropertyName,Id,GetType,PropertyType)
  SELECT PropertyName,Id,GetType,PropertyType FROM #TmpDedicated D
  GROUP BY PropertyName,Id,GetType,PropertyType;
-- # Get Minimum Value & Maximum Value # Begin
  IF @GradeId != 0
   BEGIN
    SET @StarCnt=(SELECT COUNT(*) FROM WRBHBClientGradeValue G
    LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
    G.Id=GV.ClientGradeValueId
    WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
    GV.IsDeleted=0 AND G.GradeId=@GradeId AND GV.CityId=@CityId AND
    G.ClientId=@ClientId);
    IF @StarCnt != 0
     BEGIN
      SELECT TOP 1 @StarFlag=ValueStarRatingFlag 
      FROM WRBHBClientGradeValue G
      LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
      G.Id=GV.ClientGradeValueId
      WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
      GV.IsDeleted=0 AND G.GradeId=@GradeId AND GV.CityId=@CityId AND
      G.ClientId=@ClientId;
      -- Star Grade 
      IF @StarFlag = 1
       BEGIN
        SELECT TOP 1 @StarId=ISNULL(StarRatingId,0) 
        FROM WRBHBClientGradeValue G
        LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
        G.Id=GV.ClientGradeValueId
        WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
        GV.IsDeleted=0 AND G.GradeId=@GradeId AND GV.CityId=@CityId AND
        G.ClientId=@ClientId;
       END
      IF @StarFlag = 0
       BEGIN
        SELECT TOP 1 @MinValue=ISNULL(MinValue,0),@MaxValue=ISNULL(MaxValue,0) 
        FROM WRBHBClientGradeValue G
        LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
        G.Id=GV.ClientGradeValueId
        WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
        GV.IsDeleted=0 AND G.GradeId=@GradeId AND GV.CityId=@CityId AND
        G.ClientId=@ClientId;
       END    
     END
    /*SELECT @MinValue=ISNULL(MinValue,0),@MaxValue=ISNULL(MaxValue,0) 
    FROM WRBHBClientGradeValue G
    LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
    G.Id=GV.ClientGradeValueId
    WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
    GV.IsDeleted=0 AND G.GradeId=@GradeId AND GV.CityId=@CityId AND
    G.ClientId=@ClientId;*/
   END
  IF @GradeId = 0 AND @Str1 != ''
   BEGIN
    SET @StarCnt=(SELECT COUNT(*) FROM WRBHBClientGradeValue G
    LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
    G.Id=GV.ClientGradeValueId
    WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
    GV.IsDeleted=0 AND G.Grade=@Str1 AND GV.CityId=@CityId AND
    G.ClientId=@ClientId);
    IF @StarCnt != 0
     BEGIN
      SELECT TOP 1 @StarFlag=ValueStarRatingFlag 
      FROM WRBHBClientGradeValue G
      LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
      G.Id=GV.ClientGradeValueId
      WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
      GV.IsDeleted=0 AND G.Grade=@Str1 AND GV.CityId=@CityId AND
      G.ClientId=@ClientId;
      IF @StarFlag=1
       BEGIN
        SELECT TOP 1 @StarId=StarRatingId FROM WRBHBClientGradeValue G
        LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
        G.Id=GV.ClientGradeValueId
        WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
        GV.IsDeleted=0 AND G.Grade=@Str1 AND GV.CityId=@CityId AND
        G.ClientId=@ClientId;
       END
      ELSE
       BEGIN
        SELECT TOP 1 @MinValue=ISNULL(MinValue,0),@MaxValue=ISNULL(MaxValue,0) 
        FROM WRBHBClientGradeValue G
        LEFT OUTER JOIN WRBHBClientGradeValueDetails GV WITH(NOLOCK)ON
        G.Id=GV.ClientGradeValueId
        WHERE G.IsActive=1 AND G.IsDeleted=0 AND GV.IsActive=1 AND 
        GV.IsDeleted=0 AND G.Grade=@Str1 AND GV.CityId=@CityId AND
        G.ClientId=@ClientId;
       END
      END    
   END
-- # Get Minimum Value & Maximum Value # End
-- # Client Prefered # Begin
  CREATE TABLE #ClientPrefered(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  TripleTariff DECIMAL(27,2));
  IF @StarCnt != 0
   BEGIN
    IF @StarFlag = 1
     BEGIN
      INSERT INTO #ClientPrefered(PropertyName,Id,GetType,PropertyType,
      RoomType,SingleTariff,DoubleTariff)
      SELECT P.PropertyName,P.Id,'Contract','CPP',D.RoomType,
      D.TariffSingle,D.TariffDouble FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
      P.Id=D.PropertyId
      LEFT OUTER JOIN WRBHBContractClientPref_Header H WITH(NOLOCK)ON 
      H.Id=D.HeaderId
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
      D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND  
      H.ClientId=@ClientId AND P.CityId=@CityId AND P.PropertyType=@StarId;
     END
    IF @StarFlag = 0
     BEGIN
      INSERT INTO #ClientPrefered(PropertyName,Id,GetType,PropertyType,
      RoomType,SingleTariff,DoubleTariff)
      SELECT P.PropertyName,P.Id,'Contract','CPP',D.RoomType,
      D.TariffSingle,D.TariffDouble FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
      D.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBContractClientPref_Header H WITH(NOLOCK)ON 
	  H.Id=D.HeaderId
	  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
	  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
	  P.CityId=@CityId AND H.ClientId=@ClientId AND 
	  D.TariffSingle BETWEEN @MinValue AND @MaxValue;
     END
   END
  ELSE
   BEGIN
    INSERT INTO #ClientPrefered(PropertyName,Id,GetType,PropertyType,
    RoomType,SingleTariff,DoubleTariff)
    SELECT P.PropertyName,P.Id,'Contract','CPP',D.RoomType,
    D.TariffSingle,D.TariffDouble FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
    P.Id=D.PropertyId
    LEFT OUTER JOIN WRBHBContractClientPref_Header H WITH(NOLOCK)ON 
    H.Id=D.HeaderId
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
    D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND  
    H.ClientId=@ClientId AND P.CityId=@CityId;
   END
-- # Client Prefered # End
-- # Internal # Begin
  -- Existing Begin
  CREATE TABLE #ExistingInternalProperty(RoomId BIGINT);
  -- Dedicated Rooms
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT RoomId FROM WRBHBContractManagementTariffAppartment
  WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0;
  -- Dedicated Apartment
  INSERT INTO #ExistingInternalProperty(RoomId)  
  SELECT R.Id FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBContractManagementAppartment T 
  WITH(NOLOCK)ON T.ApartmentId=R.ApartmentId
  WHERE R.IsActive=1 AND R.IsDeleted=0 AND T.IsActive=1 AND 
  T.IsDeleted=0 AND T.ApartmentId != 0 
  AND R.ApartmentId=T.ApartmentId;
  -- Room Booked Begin
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  --PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  --CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;
  -- 
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  --PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  --CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;
  -- 
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId; 
  --PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  --CONVERT(DATE,@ChkOutDt,103) AND
  --PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  --CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;
  -- 
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND*/
  -- Room Booked End
  -- Bed Booked Begin
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId AND P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId AND P.CityId=@CityId GROUP BY PG.RoomId; 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId) 
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId AND P.CityId=@CityId GROUP BY PG.RoomId;  
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  PG.BookingPropertyId=P.Id
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND P.IsActive=1 AND 
  P.IsDeleted=0 AND P.Category='Internal Property' AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND 
  P.CityId=@CityId GROUP BY PG.RoomId;
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND 
  P.CityId=@CityId;*/
  -- Bed Booked End
  -- Apartment Booked Begin
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT R.Id FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
  PG.ApartmentId=R.ApartmentId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
  PG.IsDeleted=0 AND P.IsActive=1 AND P.IsDeleted=0 AND 
  P.Category='Internal Property' AND R.ApartmentId=PG.ApartmentId AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY R.Id; 
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT R.Id FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
  PG.ApartmentId=R.ApartmentId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
  PG.IsDeleted=0 AND P.IsActive=1 AND P.IsDeleted=0 AND 
  P.Category='Internal Property' AND R.ApartmentId=PG.ApartmentId AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY R.Id; 
  /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT R.Id FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
  PG.ApartmentId=R.ApartmentId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
  PG.IsDeleted=0 AND P.IsActive=1 AND P.IsDeleted=0 AND 
  P.Category='Internal Property' AND R.ApartmentId=PG.ApartmentId AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  P.CityId=@CityId GROUP BY R.Id;
  /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND
  PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
  CONVERT(DATE,@ChkOutDt,103) AND P.CityId=@CityId;*/
  --
  INSERT INTO #ExistingInternalProperty(RoomId)
  SELECT R.Id FROM WRBHBPropertyRooms R
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
  WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
  PG.ApartmentId=R.ApartmentId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id=PG.BookingPropertyId
  WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
  PG.IsDeleted=0 AND P.IsActive=1 AND P.IsDeleted=0 AND 
  P.Category='Internal Property' AND R.ApartmentId=PG.ApartmentId AND 
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
  CAST(@ChkInDt AS DATETIME) AND
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
  CAST(@ChkOutDt AS DATETIME) AND P.CityId=@CityId
  GROUP BY R.Id;
  /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
  PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND 
  P.CityId=@CityId;*/
  -- Apartment Booked End
  -- Existing End
  CREATE TABLE #Intrnl(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),
  RoomType NVARCHAR(100),SingleTariff DECIMAL(27,2),
  DoubleTariff DECIMAL(27,2),DiscountModeRS BIT,
  DiscountModePer BIT,DiscountAllowed DECIMAL(27,2));
  -- Contract Non Dedicated Internal Property
  INSERT INTO #Intrnl(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
  DiscountAllowed)
  SELECT P.PropertyName,P.Id,'Contract','InP','Standard',
  T.RoomTarif,T.DoubleTarif,1,1,0 FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  JOIN WRBHBContractNonDedicatedApartment T WITH(NOLOCK)ON 
  T.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBContractNonDedicated H WITH(NOLOCK)ON 
  H.Id=T.NondedContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND 
  R.IsDeleted=0 AND T.IsActive=1 AND T.IsDeleted=0 AND H.IsActive=1 AND 
  H.IsDeleted=0 AND H.ClientId=@ClientId AND P.CityId=@CityId AND
  A.Status='Active' AND R.RoomStatus='Active' AND
  A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND A.IsDeleted=0 AND
  R.Id NOT IN (SELECT RoomId FROM #ExistingInternalProperty)
  GROUP BY P.PropertyName,P.Id,T.RoomTarif,T.DoubleTarif;
  -- Internal Property
  INSERT INTO #Intrnl(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
  DiscountAllowed)
  SELECT P.PropertyName,P.Id,'Property','InP','Standard',
  R.RackTariff,R.DoubleOccupancyTariff,R.DiscountModeRS,
  R.DiscountModePer,R.DiscountAllowed FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=P.Id AND R.ApartmentId=A.Id
  WHERE P.IsDeleted=0 AND P.IsActive=1 AND 
  P.Category='Internal Property' AND P.CityId=@CityId AND 
  A.Status='Active' AND R.RoomStatus='Active' AND
  R.IsActive=1 AND R.IsDeleted=0 AND
  A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND A.IsDeleted=0 AND 
  R.Id NOT IN (SELECT RoomId FROM #ExistingInternalProperty) AND
  P.Id NOT IN (SELECT D.PropertyId FROM WRBHBContractNonDedicated H
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D
  WITH(NOLOCK)ON H.Id=D.NondedContractId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=D.PropertyId
  WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND D.IsDeleted=0
  AND P.IsActive=1 AND P.IsDeleted=0 AND H.ClientId=@ClientId AND  
  P.CityId=@CityId)
  GROUP BY P.PropertyName,P.Id,R.RackTariff,
  R.DoubleOccupancyTariff,R.DiscountModeRS,R.DiscountModePer,
  R.DiscountAllowed;
  -- # Internal Min & Max    
  CREATE TABLE #Internal(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  DiscountModeRS BIT,DiscountModePer BIT,DiscountAllowed DECIMAL(27,2));
  IF @StarCnt != 0
   BEGIN
    IF @StarFlag = 1
     BEGIN
      INSERT INTO #Internal(PropertyName,Id,GetType,PropertyType,RoomType,
      SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
      DiscountAllowed)
      SELECT I.PropertyName,I.Id,I.GetType,I.PropertyType,I.RoomType,
      I.SingleTariff,I.DoubleTariff,I.DiscountModeRS,I.DiscountModePer,
      I.DiscountAllowed FROM #Intrnl I
      LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=I.Id      
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType=@StarId;
     END
    IF @StarFlag = 0
     BEGIN
      INSERT INTO #Internal(PropertyName,Id,GetType,PropertyType,RoomType,
      SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
      DiscountAllowed)
      SELECT PropertyName,Id,GetType,PropertyType,RoomType,
      SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
      DiscountAllowed FROM #Intrnl
      WHERE SingleTariff BETWEEN @MinValue AND @MaxValue;
     END
   END
  ELSE
   BEGIN
    INSERT INTO #Internal(PropertyName,Id,GetType,PropertyType,RoomType,
    SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
    DiscountAllowed)
    SELECT PropertyName,Id,GetType,PropertyType,RoomType,
    SingleTariff,DoubleTariff,DiscountModeRS,DiscountModePer,
    DiscountAllowed FROM #Intrnl;
   END   
-- # Internal # End
  ------- # Markup
  DECLARE @Markup DECIMAL(27,2)=0,@Flag BIT=0,@MarkupId BIGINT=0;
  DECLARE @Per DECIMAL(27,2)=0,@Rs DECIMAL(27,2)=0;  
  SET @Flag=(SELECT Flag FROM WRBHBMarkup WHERE IsActive=1 AND 
  IsDeleted=0);
  SET @MarkupId=(SELECT Id FROM WRBHBMarkup WHERE IsActive=1 AND 
  IsDeleted=0);
  IF @Flag = 0
   BEGIN
    SET @Rs=(SELECT Value FROM WRBHBMarkup 
    WHERE IsActive=1 AND IsDeleted=0);
    SET @Per = 0;
   END
  ELSE
   BEGIN
    SET @Per=(SELECT Value FROM WRBHBMarkup 
    WHERE IsActive=1 AND IsDeleted=0);
    SET @Rs = 0;
   END
  ------- # Markup
  CREATE TABLE #ExternalNOTINProperty(PropertyId BIGINT);
  INSERT INTO #ExternalNOTINProperty(PropertyId)
  SELECT D.PropertyId FROM WRBHBContractClientPref_Header H
  LEFT OUTER JOIN WRBHBContractClientPref_Details D 
  WITH(NOLOCK)ON D.HeaderId=H.Id
  WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.ClientId=@ClientId
  GROUP BY D.PropertyId;
-- # External # Begin
  CREATE TABLE #External1(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  TripleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
  DoubleandMarkup DECIMAL(27,2),TripleandMarkup DECIMAL(27,2),
  TAC BIT,MarkupId BIGINT,TaxAdded NVARCHAR(100));
  -- Non Dedicated Property
  INSERT INTO #External1(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
  DoubleandMarkup,TripleandMarkup,TAC,MarkupId,TaxAdded)
  SELECT P.PropertyName,P.Id,'Contract','ExP',D.ApartMentType,
  D.RoomTarif,D.DoubleTarif,D.TripleTarif,D.RoomTarif,D.DoubleTarif,
  D.TripleTarif,1,0,'' FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
  P.Id=D.PropertyId
  LEFT OUTER JOIN WRBHBContractNonDedicated H WITH(NOLOCK)ON 
  H.Id=D.NondedContractId
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND D.IsActive=1 AND 
  D.IsDeleted=0 AND H.IsActive=1 AND H.IsDeleted=0 AND 
  P.CityId=@CityId AND H.ClientId=@ClientId AND
  P.Category='External Property' AND 
  P.Id NOT IN (SELECT PropertyId FROM #ExternalNOTINProperty);
  --
  --select * from #External1;return;
  -- 
  INSERT INTO #ExternalNOTINProperty(PropertyId)
  SELECT D.PropertyId FROM WRBHBContractNonDedicated H
  LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
  H.Id=D.NondedContractId WHERE H.IsDeleted=0 AND H.IsActive=1 AND 
  D.IsDeleted=0 AND D.IsActive=1 AND H.ClientId=@ClientId;
  --  
  -- Property
  INSERT INTO #External1(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,MarkupId,TaxAdded)
  SELECT P.PropertyName,P.Id,'Property','ExP',R.RoomType,
  R.RackSingle,R.RackDouble,R.RackTriple,R.RackSingle,
  R.RackDouble,R.RackTriple,A.TAC,0,
  --CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'Y' ELSE 'N' END
  CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'N' ELSE 'T' END
  FROM WRBHBProperty P
  LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON 
  A.PropertyId=P.Id
  LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
  R.AgreementId=A.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND A.IsActive=1 AND 
  A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND P.CityId=@CityId 
  AND P.Category='External Property' AND A.TAC = 1 AND 
  P.Id NOT IN (SELECT PropertyId FROM #ExternalNOTINProperty);
  --
  --select * from #External1;return;
  --
 IF @Flag = 0
  BEGIN
   INSERT INTO #External1(PropertyName,Id,GetType,PropertyType,RoomType,
   SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
   TripleandMarkup,TAC,MarkupId,TaxAdded)
   SELECT P.PropertyName,P.Id,'Property','ExP',R.RoomType,
   R.RackSingle,R.RackDouble,R.RackTriple,
   CASE WHEN R.RackSingle > 0 THEN R.RackSingle+@Rs ELSE R.RackSingle END,
   CASE WHEN R.RackDouble > 0 THEN R.RackDouble+@Rs ELSE R.RackDouble END,
   CASE WHEN R.RackTriple > 0 THEN R.RackTriple+@Rs ELSE R.RackTriple END,
   A.TAC,@MarkupId,
   --CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'Y' ELSE 'N' END 
   CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'N' ELSE 'T' END
   FROM WRBHBProperty P
   LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON 
   A.PropertyId=P.Id
   LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
   R.AgreementId=A.Id
   WHERE P.IsActive=1 AND P.IsDeleted=0 AND A.IsActive=1 AND 
   A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND P.CityId=@CityId 
   AND P.Category='External Property' AND A.TAC = 0 AND
   P.Id NOT IN (SELECT PropertyId FROM #ExternalNOTINProperty);
  END
 ELSE
  BEGIN
   IF @Per != 0
    BEGIN
     INSERT INTO #External1(PropertyName,Id,GetType,PropertyType,RoomType,
     SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
     DoubleandMarkup,TripleandMarkup,TAC,MarkupId,TaxAdded)
     SELECT P.PropertyName,P.Id,'Property','ExP',R.RoomType,
     R.RackSingle,R.RackDouble,R.RackTriple,
     R.RackSingle+ROUND((R.RackSingle * @Per)/100,0),
     R.RackDouble+ROUND((R.RackDouble * @Per)/100,0),
     CASE WHEN R.RackTriple > 0 THEN 
     R.RackTriple+ROUND((R.RackTriple * @Per)/100,0)
     ELSE R.RackTriple END,A.TAC,@MarkupId,
     --CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'Y' ELSE 'N' END
     CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'N' ELSE 'T' END
     FROM WRBHBProperty P
     LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON 
     A.PropertyId=P.Id
     LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
     R.AgreementId=A.Id
     WHERE P.IsActive=1 AND P.IsDeleted=0 AND A.IsActive=1 AND 
     A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND P.CityId=@CityId 
     AND P.Category='External Property' AND A.TAC = 0 AND
     P.Id NOT IN (SELECT PropertyId FROM #ExternalNOTINProperty);
    END
   ELSE
    BEGIN
     INSERT INTO #External1(PropertyName,Id,GetType,PropertyType,RoomType,
     SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
     DoubleandMarkup,TripleandMarkup,TAC,MarkupId,TaxAdded)
     SELECT P.PropertyName,P.Id,'Property','ExP',R.RoomType,
     R.RackSingle,R.RackDouble,R.RackTriple,R.RackSingle,R.RackDouble,
     R.RackTriple,A.TAC,@MarkupId,
     --CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'Y' ELSE 'N' END
     CASE WHEN ISNULL(R.Inclusive,0) = 1 THEN 'N' ELSE 'T' END
     FROM WRBHBProperty P
     LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON 
     A.PropertyId=P.Id
     LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
     R.AgreementId=A.Id
     WHERE P.IsActive=1 AND P.IsDeleted=0 AND A.IsActive=1 AND 
     A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND P.CityId=@CityId 
     AND P.Category='External Property' AND A.TAC = 0 AND
     P.Id NOT IN (SELECT PropertyId FROM #ExternalNOTINProperty);
    END   
  END
 CREATE TABLE #TMPPTY(PropertyId BIGINT,RoomType NVARCHAR(100));
 INSERT INTO #TMPPTY(PropertyId,RoomType)
 SELECT Id,RoomType FROM #External1 GROUP BY Id,RoomType;
 -- Get Facility Begin
 CREATE TABLE #TMPFacility(PropertyId BIGINT,RoomType NVARCHAR(100),
 Facility NVARCHAR(100));
 INSERT INTO #TMPFacility(PropertyId,RoomType,Facility)
 SELECT E.PropertyId,E.RoomType,R.Facility FROM #TMPPTY E
 LEFT OUTER JOIN WRBHBPropertyAgreements A WITH(NOLOCK)ON
 A.PropertyId=E.PropertyId
 LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges R WITH(NOLOCK)ON
 R.AgreementId=A.Id
 WHERE A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0
 AND R.RoomType=E.RoomType;
 --
 CREATE TABLE #Facility(PropertyId BIGINT,RoomType NVARCHAR(100),
 Facility NVARCHAR(100));
 INSERT INTO #Facility(PropertyId,RoomType,Facility)
 SELECT E.PropertyId,E.RoomType,ISNULL(F.Facility,'') FROM #TMPPTY E
 LEFT OUTER JOIN #TMPFacility F ON F.PropertyId=E.PropertyId
 AND E.RoomType=F.RoomType; 
 -- Get Facility End 
 CREATE TABLE #External(PropertyName NVARCHAR(100),Id BIGINT,
 GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
 SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
 TripleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
 DoubleandMarkup DECIMAL(27,2),TripleandMarkup DECIMAL(27,2),
 TAC BIT,Facility NVARCHAR(100),MarkupId BIGINT,TaxAdded NVARCHAR(100));
 IF @StarCnt != 0
  BEGIN
   --select * from #External1;
   --select @MinValue,@MaxValue,@StarFlag;
   IF @StarFlag = 1
    BEGIN
     INSERT INTO #External(PropertyName,Id,GetType,PropertyType,RoomType,
     SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
     DoubleandMarkup,TripleandMarkup,TAC,Facility,MarkupId,TaxAdded)
     SELECT E.PropertyName,E.Id,E.GetType,E.PropertyType,E.RoomType,
     E.SingleTariff,E.DoubleTariff,E.TripleTariff,E.SingleandMarkup,
     E.DoubleandMarkup,E.TripleandMarkup,E.TAC,F.Facility,E.MarkupId,
     E.TaxAdded FROM #External1 E
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=E.Id
     JOIN #Facility F ON F.PropertyId=E.Id
     WHERE P.IsActive=1 AND P.IsDeleted=0 AND P.PropertyType=@StarId
     AND E.RoomType=F.RoomType AND E.Id=F.PropertyId;
    END
   IF @StarFlag = 0
    BEGIN
     INSERT INTO #External(PropertyName,Id,GetType,PropertyType,RoomType,
     SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
     DoubleandMarkup,TripleandMarkup,TAC,Facility,MarkupId,TaxAdded)
     SELECT E.PropertyName,E.Id,E.GetType,E.PropertyType,E.RoomType,
     E.SingleTariff,E.DoubleTariff,E.TripleTariff,E.SingleandMarkup,
     E.DoubleandMarkup,E.TripleandMarkup,E.TAC,F.Facility,E.MarkupId,
     E.TaxAdded FROM #External1 E
     LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=E.Id
     LEFT OUTER JOIN #Facility F ON F.PropertyId=E.Id AND
     E.RoomType=F.RoomType
     WHERE E.SingleandMarkup BETWEEN @MinValue AND @MaxValue;
     --select * from #External;return;
    END
  END
 ELSE
  BEGIN   
   INSERT INTO #External(PropertyName,Id,GetType,PropertyType,RoomType,
   SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,
   DoubleandMarkup,TripleandMarkup,TAC,Facility,MarkupId,TaxAdded)
   SELECT E.PropertyName,E.Id,E.GetType,E.PropertyType,E.RoomType,
   E.SingleTariff,E.DoubleTariff,E.TripleTariff,E.SingleandMarkup,
   E.DoubleandMarkup,E.TripleandMarkup,E.TAC,F.Facility,E.MarkupId,
   E.TaxAdded FROM #External1 E
   LEFT OUTER JOIN #Facility F ON F.PropertyId=E.Id AND
   E.RoomType=F.RoomType;
  END
-- #External # END
-- API data BEGIN
  CREATE TABLE #GETTariffs(HotelId BIGINT,RoomRatePlanCode NVARCHAR(100),
  AvailableCount INT,RoomRateTypeCode BIGINT,Single INT,
  SingleRoomRate DECIMAL(27,2),SingleTaxes DECIMAL(27,2),
  SingleRoomDiscount DECIMAL(27,2),Dub INT,DubRoomRate DECIMAL(27,2),
  DubTaxes DECIMAL(27,2),DubRoomDiscount DECIMAL(27,2));
  --
  INSERT INTO #GETTariffs(HotelId,RoomRatePlanCode,RoomRateTypeCode,
  AvailableCount,Single,SingleRoomRate,SingleTaxes,SingleRoomDiscount,
  Dub,DubRoomRate,DubTaxes,DubRoomDiscount)
  --  
  SELECT H.HotelId,RR.RoomRateratePlanCode,RR.RoomRateroomTypeCode,
  RR.RoomRateavailableCount,T11.RoomTariffroomNumber,T11.Tariffamount,
  ISNULL(T12.Tariffamount,0),ISNULL(T13.Tariffamount,0),
  T21.RoomTariffroomNumber,T21.Tariffamount,ISNULL(T22.Tariffamount,0),
  ISNULL(T23.Tariffamount,0)
  FROM WRBHBAPIHotelHeader H
  LEFT OUTER JOIN WRBHBAPIRoomRateDtls RR WITH(NOLOCK)ON
  RR.HotelId=H.HotelId AND RR.RoomRateavailStatus='B' AND
  RR.HeaderId=H.HeaderId AND RR.RoomRateavailableCount >= @PropertyId
  LEFT OUTER JOIN WRBHBAPITariffDtls T11
  WITH(NOLOCK)ON T11.RoomRateHdrId=RR.Id AND T11.RoomTariffroomNumber=1 AND
  T11.Tariffgroup='RoomRate' AND T11.HeaderId=H.HeaderId AND
  T11.HotelId=H.HotelId
  LEFT OUTER JOIN WRBHBAPITariffDtls T12
  WITH(NOLOCK)ON T12.RoomRateHdrId=RR.Id AND T12.RoomTariffroomNumber=1 AND
  T12.Tariffgroup='Taxes' AND T12.HeaderId=H.HeaderId AND
  T12.HotelId=H.HotelId
  LEFT OUTER JOIN WRBHBAPITariffDtls T13
  WITH(NOLOCK)ON T13.RoomRateHdrId=RR.Id AND T13.RoomTariffroomNumber=1 AND
  T13.Tariffgroup='RoomDiscount' AND T13.HeaderId=H.HeaderId AND
  T13.HotelId=H.HotelId
  LEFT OUTER JOIN WRBHBAPITariffDtls T21
  WITH(NOLOCK)ON T21.RoomRateHdrId=RR.Id AND T21.RoomTariffroomNumber=2 AND
  T21.Tariffgroup='RoomRate' AND T21.HeaderId=H.HeaderId AND
  T21.HotelId=H.HotelId
  LEFT OUTER JOIN WRBHBAPITariffDtls T22
  WITH(NOLOCK)ON T22.RoomRateHdrId=RR.Id AND T22.RoomTariffroomNumber=2 AND
  T22.Tariffgroup='Taxes' AND T22.HeaderId=H.HeaderId AND
  T22.HotelId=H.HotelId
  LEFT OUTER JOIN WRBHBAPITariffDtls T23
  WITH(NOLOCK)ON T23.RoomRateHdrId=RR.Id AND T23.RoomTariffroomNumber=2 AND
  T23.Tariffgroup='RoomDiscount' AND T23.HeaderId=H.HeaderId AND
  T23.HotelId=H.HotelId
  WHERE ISNULL(RR.RoomRateratePlanCode,'') != '' AND
  ISNULL(RR.RoomRateroomTypeCode,'') != '' AND H.HeaderId=@StateId 
  --AND H.HotelId  IN ('20120928153050770','201304030953079210')
  GROUP BY H.HotelId,RR.RoomRateratePlanCode,RR.RoomRateroomTypeCode,
  RR.RoomRateavailableCount,T11.RoomTariffroomNumber,T11.Tariffamount,
  T21.RoomTariffroomNumber,T21.Tariffamount,T12.Tariffamount,T22.Tariffamount,
  T13.Tariffamount,T23.Tariffamount;
  --
  --SELECT * FROM #GETTariffs;RETURN;
  --
  CREATE TABLE #APITariff(HotelId BIGINT,RoomRatePlanCode NVARCHAR(100),
  RoomRateTypeCode NVARCHAR(100),AvailableCount INT,SingleTariff DECIMAL(27,2),
  DoubleTariff DECIMAL(27,2));
  --
  INSERT INTO #APITariff(HotelId,RoomRatePlanCode,RoomRateTypeCode,
  AvailableCount,SingleTariff,DoubleTariff)
  --
  SELECT HotelId,RoomRatePlanCode,RoomRateTypeCode,AvailableCount,
  (SingleRoomRate+SingleTaxes)-SingleRoomDiscount AS Single,
  (DubRoomRate+DubTaxes)-DubRoomDiscount AS Dub FROM #GETTariffs;
  --
  DECLARE @MMTId BIGINT=0,@MMTPer DECIMAL(27,2)=0;
  IF EXISTS (SELECT NULL FROM WRBHBMMTMarkup WHERE IsActive=1 AND IsDeleted=0)
   BEGIN
    SELECT TOP 1 @MMTPer=ISNULL(MMTMarkup,0),@MMTId=Id FROM WRBHBMMTMarkup
    WHERE IsActive=1 AND IsDeleted=0;
   END  
  --
  --SELECT @MMTId,@MMTPer;
  --HOTELNAMEEMPTY
/*CREATE TABLE #APIHOTELNAMEEMPTY(HotalName NVARCHAR(100),HotelId BIGINT,
  RoomRatePlanCode NVARCHAR(100),RoomRateTypeCode NVARCHAR(100),
  RoomTypename NVARCHAR(100),GetType NVARCHAR(100),PropertyType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
  InclusionCode NVARCHAR(1000),Phone NVARCHAR(100),Email NVARCHAR(1000),
  Area NVARCHAR(1000),StarRating NVARCHAR(100));
  --
  INSERT INTO #APIHOTELNAMEEMPTY(HotalName,HotelId,RoomRatePlanCode,
  RoomRateTypeCode,RoomTypename,GetType,PropertyType,SingleTariff,DoubleTariff,
  SingleandMarkup,DoubleandMarkup,InclusionCode,Phone,Email,Area,
  StarRating)
  --
  SELECT SH.HotalName,T.HotelId,T.RoomRatePlanCode,T.RoomRateTypeCode,
  RT.RoomTypename,'API','MMT',T.SingleTariff,T.DoubleTariff,  
  CASE WHEN @MMTPer > 0 THEN 
  ROUND(T.SingleTariff+(T.SingleTariff*@MMTPer)/100,0) 
  ELSE T.SingleTariff END AS SingleandMarkup,
  CASE WHEN @MMTPer > 0 THEN 
  ROUND(T.DoubleTariff+(T.DoubleTariff*@MMTPer)/100,0)
  ELSE T.DoubleTariff END AS DoubleandMarkup,
  ISNULL(I.InclusionCode,''),ISNULL(SH.Phone,''),ISNULL(SH.Email,''),
  SH.Area,SH.StarRating
  FROM #APITariff T
  LEFT OUTER JOIN WRBHBStaticHotals SH WITH(NOLOCK)ON SH.HotalId=T.HotelId
  LEFT OUTER JOIN WRBHBAPIHotelHeader H WITH(NOLOCK)ON H.HotelId=T.HotelId
  LEFT OUTER JOIN WRBHBAPIRoomTypeDtls RT WITH(NOLOCK)ON RT.HotelId=T.HotelId 
  AND RT.RoomTypecode=T.RoomRateTypeCode AND RT.HeaderId=H.HeaderId
  LEFT OUTER JOIN WRBHBAPIRateMealPlanInclusionDtls I WITH(NOLOCK)ON
  I.HotelId=T.HotelId AND I.RatePlanCode=T.RoomRatePlanCode AND 
  I.HeaderId=H.HeaderId
  WHERE H.HeaderId=@StateId;*/
  --
  CREATE TABLE #API(HotalName NVARCHAR(100),HotelId BIGINT,
  RoomRatePlanCode NVARCHAR(100),RoomRateTypeCode NVARCHAR(100),
  RoomTypename NVARCHAR(100),GetType NVARCHAR(100),PropertyType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
  InclusionCode NVARCHAR(1000),Phone NVARCHAR(100),Email NVARCHAR(1000),
  Area NVARCHAR(1000),StarRating NVARCHAR(100),MealPlan NVARCHAR(100));
  --
  INSERT INTO #API(HotalName,HotelId,RoomRatePlanCode,RoomRateTypeCode,
  RoomTypename,GetType,PropertyType,SingleTariff,DoubleTariff,
  SingleandMarkup,DoubleandMarkup,InclusionCode,Phone,Email,Area,
  StarRating,MealPlan)
  --
  SELECT SH.HotalName,T.HotelId,
  --T.HotelId AS HotalName,T.HotelId,
  T.RoomRatePlanCode,T.RoomRateTypeCode,
  RT.RoomTypename,'API','MMT',T.SingleTariff,T.DoubleTariff,  
  CASE WHEN @MMTPer > 0 THEN 
  ROUND(T.SingleTariff+(T.SingleTariff*@MMTPer)/100,0) 
  ELSE T.SingleTariff END AS SingleandMarkup,
  CASE WHEN @MMTPer > 0 THEN 
  ROUND(T.DoubleTariff+(T.DoubleTariff*@MMTPer)/100,0)
  ELSE T.DoubleTariff END AS DoubleandMarkup,
  ISNULL(I.InclusionCode,''),ISNULL(SH.Phone,''),ISNULL(SH.Email,''),
  ISNULL(SH.Area,'') AS Area,SH.StarRating,I.MealPlan
  FROM #APITariff T
  LEFT OUTER JOIN WRBHBStaticHotels SH WITH(NOLOCK)ON SH.HotalId=T.HotelId
  LEFT OUTER JOIN WRBHBAPIHotelHeader H WITH(NOLOCK)ON H.HotelId=T.HotelId
  LEFT OUTER JOIN WRBHBAPIRoomTypeDtls RT WITH(NOLOCK)ON RT.HotelId=T.HotelId 
  AND RT.RoomTypecode=T.RoomRateTypeCode AND RT.HeaderId=H.HeaderId
  LEFT OUTER JOIN WRBHBAPIRateMealPlanInclusionDtls I WITH(NOLOCK)ON
  I.HotelId=T.HotelId AND I.RatePlanCode=T.RoomRatePlanCode AND 
  I.HeaderId=H.HeaderId
  WHERE H.HeaderId=@StateId AND ISNULL(SH.HotalName,'') != '';
  --
  --HotalName COUNT(*) FROM #APIHOTELNAMEEMPTY;
  --SELECT * FROM #API;RETURN
-- API data END
  CREATE TABLE #Property(PropertyName NVARCHAR(100),Id BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  TripleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
  DoubleandMarkup DECIMAL(27,2),TripleandMarkup DECIMAL(27,2),
  TAC BIT,Facility NVARCHAR(100),DiscountModeRS BIT,DiscountModePer BIT,
  DiscountAllowed DECIMAL(27,2),MarkupId BIGINT,TaxAdded NVARCHAR(100));
  --- Managed G H
  INSERT INTO #Property(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,DiscountModeRS,DiscountModePer,
  DiscountAllowed,MarkupId,TaxAdded)
  SELECT PropertyName,Id,GetType,PropertyType,'',0,0,0,0,0,0,0,
  'CP',0,0,0,0,'' FROM #ManagedGH 
  GROUP BY PropertyName,Id,GetType,PropertyType
  ORDER BY PropertyName ASC;
  -- Dedicated
  INSERT INTO #Property(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,DiscountModeRS,DiscountModePer,
  DiscountAllowed,MarkupId,TaxAdded)
  SELECT P.PropertyName,I.Id,I.GetType,I.PropertyType,'',0,0,0,0,0,0,0,
  'CP',0,0,0,0,'' FROM #Dedicated I
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=I.Id
  LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=I.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=I.Id AND A.BlockId=B.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=I.Id AND R.ApartmentId=A.Id AND R.BlockId=B.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND
  A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
  A.Status='Active' AND R.RoomStatus='Active' AND
  A.SellableApartmentType != 'HUB' AND
  R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty) AND
  A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt)
  GROUP BY P.PropertyName,I.Id,I.GetType,I.PropertyType
  ORDER BY PropertyName ASC;
  -- Client Prefered
  INSERT INTO #Property(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,DiscountModeRS,DiscountModePer,
  DiscountAllowed,MarkupId,TaxAdded)
  SELECT PropertyName,Id,GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,0,SingleTariff,DoubleTariff,0,0,'CP',0,0,0,0,'' 
  FROM #ClientPrefered 
  GROUP BY PropertyName,Id,GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,SingleTariff,DoubleTariff
  ORDER BY PropertyName ASC;
  -- #Internal
  INSERT INTO #Property(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,DiscountModeRS,DiscountModePer,
  DiscountAllowed,MarkupId,TaxAdded)
  SELECT I.PropertyName,I.Id,I.GetType,I.PropertyType,I.RoomType,
  I.SingleTariff,I.DoubleTariff,0,I.SingleTariff,I.DoubleTariff,0,0,'CP',
  I.DiscountModeRS,I.DiscountModePer,I.DiscountAllowed,0,'' FROM #Internal I
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=I.Id
  LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=I.Id
  LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
  A.PropertyId=I.Id AND A.BlockId=B.Id
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
  R.PropertyId=I.Id AND R.ApartmentId=A.Id AND R.BlockId=B.Id
  WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND
  A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
  A.Status='Active' AND R.RoomStatus='Active' AND
  A.SellableApartmentType != 'HUB' AND 
  R.Id NOT IN (SELECT RoomId FROM #ExistingInternalProperty)
  GROUP BY I.PropertyName,I.Id,I.GetType,I.PropertyType,I.RoomType,
  I.SingleTariff,I.DoubleTariff,I.SingleTariff,I.DoubleTariff,
  I.DiscountModeRS,I.DiscountModePer,I.DiscountAllowed 
  ORDER BY PropertyName ASC;
  -- #External
  INSERT INTO #Property(PropertyName,Id,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,DiscountModeRS,DiscountModePer,
  DiscountAllowed,MarkupId,TaxAdded)
  SELECT PropertyName,Id,GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,0,0,0,MarkupId,TaxAdded FROM #External
  GROUP BY PropertyName,Id,GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Facility,MarkupId,TaxAdded ORDER BY PropertyName ASC; 
  --
  --SELECT * FROM #Property;RETURN;
  --- Property select
  CREATE TABLE #FINAL(PropertyName NVARCHAR(100),PropertyId BIGINT,
  GetType NVARCHAR(100),PropertyType NVARCHAR(100),RoomType NVARCHAR(100),
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  TripleTariff DECIMAL(27,2),SingleandMarkup DECIMAL(27,2),
  DoubleandMarkup DECIMAL(27,2),TripleandMarkup DECIMAL(27,2),TAC BIT,
  Inclusions NVARCHAR(100),DiscountModeRS BIT,DiscountModePer BIT,
  DiscountAllowed DECIMAL(27,2),Phone NVARCHAR(100),Email NVARCHAR(100),
  Locality NVARCHAR(100),LocalityId BIGINT,MarkupId BIGINT,
  SingleandMarkup1 DECIMAL(27,2),DoubleandMarkup1 DECIMAL(27,2),
  TripleandMarkup1 DECIMAL(27,2),StarRating NVARCHAR(100),
  TaxAdded NVARCHAR(100),RatePlanCode NVARCHAR(100),
  RoomTypeCode NVARCHAR(100),MealPlan NVARCHAR(100));
  -- Property data
  INSERT INTO #FINAL(PropertyName,PropertyId,GetType,PropertyType,RoomType,
  SingleTariff,DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,
  TripleandMarkup,TAC,Inclusions,DiscountModeRS,DiscountModePer,
  DiscountAllowed,Phone,Email,Locality,LocalityId,MarkupId,SingleandMarkup1,
  DoubleandMarkup1,TripleandMarkup1,StarRating,TaxAdded,RatePlanCode,
  RoomTypeCode,MealPlan)
  SELECT TP.PropertyName,TP.Id AS PropertyId,TP.GetType,TP.PropertyType,
  TP.RoomType,TP.SingleTariff,TP.DoubleTariff,TP.TripleTariff,
  TP.SingleandMarkup,TP.DoubleandMarkup,TP.TripleandMarkup,TP.TAC,
  TP.Facility AS Inclusions,TP.DiscountModeRS,TP.DiscountModePer,
  TP.DiscountAllowed,P.Phone,ISNULL(P.Email,'') AS Email,L.Locality,
  L.Id AS LocalityId,TP.MarkupId,
  TP.SingleandMarkup AS SingleandMarkup1,
  TP.DoubleandMarkup AS DoubleandMarkup1,
  TP.TripleandMarkup AS TripleandMarkup1,
  CASE WHEN T.PropertyType = '1 Star' THEN '1'
       WHEN T.PropertyType = '2 Star' THEN '2'
       WHEN T.PropertyType = '3 Star' THEN '3'
       WHEN T.PropertyType = '4 Star' THEN '4'
       WHEN T.PropertyType = '5 Star' THEN '5'
       WHEN T.PropertyType = '6 Star' THEN '6'
       WHEN T.PropertyType = '7 Star' THEN '7'
       WHEN T.PropertyType = '7+ Star' THEN '7+'
       WHEN T.PropertyType = 'Serviced Appartments' THEN 'S A'
       ELSE T.PropertyType END AS StarRating,TP.TaxAdded,'','',''
  /*,CASE WHEN TP.PropertyType = 'ExP' AND TP.GetType = 'Contract' THEN '#242020'
   WHEN TP.PropertyType = 'ExP' AND TP.GetType = 'Property' THEN '#770E0E'
   WHEN TP.PropertyType = 'InP' AND TP.GetType = 'Contract' THEN '#27B25C'
   WHEN TP.PropertyType = 'InP' AND TP.GetType = 'Property' THEN '#DA0EB8'
   WHEN TP.PropertyType = 'CPP' AND TP.GetType = 'Contract' THEN '#0E6DDA'
   WHEN TP.PropertyType = 'DdP' AND TP.GetType = 'Contract' THEN '#C1DFCD'
   WHEN TP.PropertyType = 'MGH' AND TP.GetType = 'Contract' THEN '#0EF466'
   ELSE '#FFFFFF' END AS Color*/
  FROM #Property TP
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=TP.Id
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId
  LEFT OUTER JOIN WRBHBPropertyType T WITH(NOLOCK)ON T.Id=P.PropertyType;
  -- API data
  IF @MaxValue != 0
   BEGIN
    INSERT INTO #FINAL(PropertyName,PropertyId,GetType,PropertyType,RoomType,
    RatePlanCode,RoomTypeCode,SingleTariff,DoubleTariff,TripleTariff,
    SingleandMarkup,DoubleandMarkup,TripleandMarkup,TAC,Inclusions,
    DiscountModeRS,DiscountModePer,DiscountAllowed,Phone,Email,Locality,
    LocalityId,MarkupId,SingleandMarkup1,DoubleandMarkup1,TripleandMarkup1,
    StarRating,TaxAdded,MealPlan)    
    SELECT HotalName,HotelId,GetType,PropertyType,RoomTypename,RoomRatePlanCode,
    RoomRateTypeCode,SingleTariff,DoubleTariff,0,SingleandMarkup,
    DoubleandMarkup,0,0,InclusionCode,0,0,0,Phone,Email,Area,0,@MMTId,
    SingleandMarkup AS SingleandMarkup1,DoubleandMarkup,0,StarRating,'',
    MealPlan FROM #API
    WHERE SingleandMarkup BETWEEN @MinValue AND @MaxValue
    ORDER BY HotalName,SingleandMarkup ASC;
   END
  ELSE
   BEGIN
    INSERT INTO #FINAL(PropertyName,PropertyId,GetType,PropertyType,RoomType,
    RatePlanCode,RoomTypeCode,SingleTariff,DoubleTariff,TripleTariff,
    SingleandMarkup,DoubleandMarkup,TripleandMarkup,TAC,Inclusions,
    DiscountModeRS,DiscountModePer,DiscountAllowed,Phone,Email,Locality,
    LocalityId,MarkupId,SingleandMarkup1,DoubleandMarkup1,TripleandMarkup1,
    StarRating,TaxAdded,MealPlan)    
    SELECT HotalName,HotelId,GetType,PropertyType,RoomTypename,RoomRatePlanCode,
    RoomRateTypeCode,SingleTariff,DoubleTariff,0,SingleandMarkup,
    DoubleandMarkup,0,0,InclusionCode,0,0,0,Phone,Email,Area,0,@MMTId,
    SingleandMarkup AS SingleandMarkup1,DoubleandMarkup,0,StarRating,'',
    MealPlan FROM #API
    ORDER BY HotalName,SingleandMarkup ASC;
   END
  --
  --SELECT * FROM #FINAL;RETURN;
  -- Get CPP Property Id
  CREATE TABLE #CPPPropertyId(PropertyId BIGINT);
  INSERT INTO #CPPPropertyId(PropertyId)
  SELECT PropertyId FROM #FINAL 
  WHERE GetType = 'Contract' AND PropertyType = 'CPP'
  GROUP BY PropertyId;
  --
  DECLARE @CPPPropertyCnt INT = (SELECT COUNT(*) FROM #CPPPropertyId);
  IF @CPPPropertyCnt != 0
   BEGIN
    -- Get CPP Property Email & Phone
    CREATE TABLE #CPPProperty(PropertyId BIGINT,RoomType NVARCHAR(100),
    ContactPhone NVARCHAR(100),Email NVARCHAR(100));
    INSERT INTO #CPPProperty(PropertyId,RoomType,ContactPhone,Email)
    SELECT D.PropertyId,ISNULL(D.RoomType,''),ISNULL(D.ContactPhone,''),
    ISNULL(D.Email,'') FROM WRBHBContractClientPref_Header H
    LEFT OUTER JOIN WRBHBContractClientPref_Details D WITH(NOLOCK)ON
    D.HeaderId=H.Id
    WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.IsActive=1 AND D.IsDeleted=0 AND
    H.ClientId=@ClientId AND (ISNULL(D.ContactPhone,'') != '' OR
    ISNULL(D.Email,'') != '') AND
    D.PropertyId IN(SELECT PropertyId FROM #CPPPropertyId)
    GROUP BY D.PropertyId,ISNULL(D.RoomType,''),ISNULL(D.ContactPhone,''),
    ISNULL(D.Email,'');
    --
    --SELECT * FROM #CPPProperty;RETURN;
    --
    UPDATE #FINAL SET Phone = CPP.ContactPhone,Email = CPP.Email
    FROM #CPPProperty CPP 
    WHERE #FINAL.PropertyId = CPP.PropertyId AND #FINAL.RoomType = CPP.RoomType;
   END  
  --*/
  SELECT PropertyName,CAST(PropertyId AS NVARCHAR) AS PropertyId,
  GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,TripleandMarkup,
  TAC,Inclusions,DiscountModeRS,DiscountModePer,DiscountAllowed,Phone,Email,
  Locality,LocalityId,MarkupId,SingleandMarkup1,DoubleandMarkup1,
  TripleandMarkup1,StarRating,TaxAdded,0 AS Tick,1 AS Chk,'' AS Markup,0 AS Id,
  RatePlanCode,RoomTypeCode,@StateId AS APIHdrId,MealPlan 
  FROM #FINAL; 
  --
  --SELECT COUNT(*) FROM #FINAL; 
  -- Recommended Property
  /*CREATE TABLE #GuestId(Id INT,GuestId BIGINT);
  INSERT INTO #GuestId(Id,GuestId)
  SELECT * FROM dbo.Split(@Str2, ',');
  CREATE TABLE #GuestProperty(PropertyId BIGINT);
  INSERT INTO #GuestProperty(PropertyId)
  SELECT BP.BookingPropertyId FROM #GuestId G
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BP WITH(NOLOCK)ON
  G.GuestId=BP.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BP.BookingPropertyId
  WHERE P.CityId=@CityId
  GROUP BY BP.BookingPropertyId;*/
  --
  CREATE TABLE #ZAXS(BookingId BIGINT, PropertyId BIGINT);
  INSERT INTO #ZAXS(BookingId, PropertyId)
  SELECT B.Id,BG.BookingPropertyId FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND BG.IsActive = 1 AND
  BG.IsDeleted = 0 AND B.ClientId = @ClientId AND B.CityId = @CityId
  GROUP BY B.Id,BG.BookingPropertyId;
  --
  CREATE TABLE #ZAXSQA(PropertyCnt BIGINT, PropertyId BIGINT);
  INSERT INTO #ZAXSQA(PropertyCnt, PropertyId)
  SELECT COUNT(PropertyId),PropertyId FROM #ZAXS GROUP BY PropertyId;
  --SELECT * FROM #ZAXSQA;
  --SELECT * FROM #FINAL WHERE PropertyId IN (SELECT PropertyId FROM #ZAXSQA);
  SELECT F.PropertyName,CAST(Z.PropertyId AS NVARCHAR) AS PropertyId,
  F.GetType,F.PropertyType,F.RoomType,F.SingleTariff,F.DoubleTariff,
  F.TripleTariff,F.SingleandMarkup,F.DoubleandMarkup,F.TripleandMarkup,
  F.TAC,F.Inclusions,F.DiscountModeRS,F.DiscountModePer,F.DiscountAllowed,
  F.Phone,F.Email,F.Locality,F.LocalityId,F.MarkupId,F.SingleandMarkup1,
  F.DoubleandMarkup1,F.TripleandMarkup1,F.StarRating,F.TaxAdded,0 AS Tick,
  1 AS Chk,'' AS Markup,0 AS Id,F.RatePlanCode,F.RoomTypeCode,
  @StateId AS APIHdrId,F.MealPlan  FROM #ZAXSQA Z
  LEFT OUTER JOIN #FINAL F WITH(NOLOCK) ON Z.PropertyId = F.PropertyId
  WHERE F.PropertyId = Z.PropertyId ORDER BY Z.PropertyCnt ASC;
  /*SELECT P.PropertyName,CAST(TP.Id AS NVARCHAR) AS PropertyId,
  TP.GetType,TP.PropertyType,
  TP.RoomType,TP.SingleTariff,TP.DoubleTariff,TP.TripleTariff,
  TP.SingleandMarkup,TP.DoubleandMarkup,TP.TripleandMarkup,TP.TAC,
  TP.Facility AS Inclusions,TP.DiscountModeRS,TP.DiscountModePer,
  TP.DiscountAllowed,P.Phone,ISNULL(P.Email,'') AS Email,
  ISNULL(L.Locality,'') AS Locality,ISNULL(L.Id,0) AS LocalityId,
  0 AS Tick,1 AS Chk,'' AS Markup,0 AS Id,TP.MarkupId,
  TP.SingleandMarkup AS SingleandMarkup1,
  TP.DoubleandMarkup AS DoubleandMarkup1,
  TP.TripleandMarkup AS TripleandMarkup1,
  CASE WHEN T.PropertyType = '1 Star' THEN '1'
       WHEN T.PropertyType = '2 Star' THEN '2'
       WHEN T.PropertyType = '3 Star' THEN '3'
       WHEN T.PropertyType = '4 Star' THEN '4'
       WHEN T.PropertyType = '5 Star' THEN '5'
       WHEN T.PropertyType = '6 Star' THEN '6'
       WHEN T.PropertyType = '7 Star' THEN '7'
       WHEN T.PropertyType = '7+ Star' THEN '7+'
       WHEN T.PropertyType = 'Serviced Appartments' THEN 'S A'
       ELSE T.PropertyType END AS StarRating,TP.TaxAdded
  /*,CASE
   WHEN TP.PropertyType = 'ExP' AND TP.GetType = 'Contract' THEN '#242020'
   WHEN TP.PropertyType = 'ExP' AND TP.GetType = 'Property' THEN '#770E0E'
   WHEN TP.PropertyType = 'InP' AND TP.GetType = 'Contract' THEN '#27B25C'
   WHEN TP.PropertyType = 'InP' AND TP.GetType = 'Property' THEN '#DA0EB8'
   WHEN TP.PropertyType = 'CPP' AND TP.GetType = 'Contract' THEN '#0E6DDA'
   WHEN TP.PropertyType = 'DdP' AND TP.GetType = 'Contract' THEN '#C1DFCD'
   WHEN TP.PropertyType = 'MGH' AND TP.GetType = 'Contract' THEN '#0EF466'
   ELSE '#FFFFFF' END AS Color*/
  FROM #Property TP
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=TP.Id
  LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK)ON L.Id=P.LocalityId
  LEFT OUTER JOIN WRBHBPropertyType T WITH(NOLOCK)ON T.Id=P.PropertyType
  LEFT OUTER JOIN #GuestProperty G WITH(NOLOCK) ON G.PropertyId=TP.Id
  WHERE TP.Id=G.PropertyId;
  SELECT PropertyName,CAST(PropertyId AS NVARCHAR) AS PropertyId,
  GetType,PropertyType,RoomType,SingleTariff,
  DoubleTariff,TripleTariff,SingleandMarkup,DoubleandMarkup,TripleandMarkup,
  TAC,Inclusions,DiscountModeRS,DiscountModePer,DiscountAllowed,Phone,Email,
  Locality,LocalityId,MarkupId,SingleandMarkup1,DoubleandMarkup1,
  TripleandMarkup1,StarRating,TaxAdded,0 AS Tick,1 AS Chk,'' AS Markup,0 AS Id,
  RatePlanCode,RoomTypeCode,@StateId AS APIHdrId,MealPlan 
  FROM #FINAL WHERE PropertyId IN (SELECT PropertyId FROM #GuestProperty);*/
 END
IF @Action = 'BookingPropertyDtls'
 BEGIN
  -- @Id1 - Booking Property Table Id  ()
  -- Booking Id
  DECLARE @BookingId BIGINT;  
  SET @BookingId=(SELECT TOP 1 BookingId FROM WRBHBBookingProperty 
  WHERE Id=@Id1);  
  -- Client Id
  SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId);
  -- Get Type & Property Type
  DECLARE @GetType NVARCHAR(100),@PropertyType NVARCHAR(100);
  SELECT @GetType=GetType,@PropertyType=PropertyType 
  FROM WRBHBBookingProperty WHERE Id=@Id1;
  -- GradeId
  SET @GradeId=(SELECT GradeId FROM WRBHBBooking WHERE Id=@BookingId);
  -- Payment Mode
  CREATE TABLE #PAYMENT(label NVARCHAR(100));
  IF @PropertyType = 'MMT' AND @GetType = 'API'
   BEGIN
    INSERT INTO #PAYMENT(label) SELECT 'Bill to Company (BTC)';
   END
  ELSE
   BEGIN
    DECLARE @BTC BIT=0;
    SET @BTC=(SELECT BTC FROM WRBHBClientManagement WHERE Id=@ClientId);
    IF @BTC = 1
     BEGIN
      INSERT INTO #PAYMENT(label) SELECT 'Bill to Company (BTC)';
      INSERT INTO #PAYMENT(label) SELECT 'Direct';
     END
    ELSE
     BEGIN
      INSERT INTO #PAYMENT(label) SELECT 'Direct';
     END
    IF @PropertyType = 'CPP'
     BEGIN
      INSERT INTO #PAYMENT(label) SELECT 'Bill to Client';    
     END
   END  
  SELECT label FROM #PAYMENT;
  -- SSP START
  DECLARE @sspcnt INT=0;
  CREATE TABLE #SSP(label NVARCHAR(100),Id BIGINT,
  SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),
  TripleTariff DECIMAL(27,2));
  SET @sspcnt=(SELECT COUNT(*) FROM WRBHBSSPCodeGeneration S
  WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Room' AND 
  S.ClientId=@ClientId AND S.PropertyId=@PropertyId);  
  IF @sspcnt != 0
   BEGIN
    INSERT INTO #SSP(label,Id,SingleTariff,DoubleTariff,TripleTariff)
    SELECT 'Please Select SSP',0,0,0,0;
    INSERT INTO #SSP(label,Id,SingleTariff,DoubleTariff,TripleTariff)
    SELECT S.SSPName AS label,S.Id,S.SingleTariff,S.DoubleTariff,
    S.TripleTariff FROM WRBHBSSPCodeGeneration S
    WHERE S.IsActive=1 AND S.IsDeleted=0 AND S.BookingLevel='Room' AND 
    S.ClientId=@ClientId AND S.PropertyId=@PropertyId;
   END  
  SELECT label,Id,SingleTariff,DoubleTariff,TripleTariff FROM #SSP;
  -- SSP END
  --SELECT @GetType,@PropertyType;RETURN;
  --
  IF @PropertyType = 'MGH'
   BEGIN
    CREATE TABLE #ExistingManagedGHProperty1(RoomId BIGINT);
    -- Booked Room Begin
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;   
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId)
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.RoomId;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND*/
    -- Booked Room End
    -- Booked BED Begin
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    -- 
    INSERT INTO #ExistingManagedGHProperty1(RoomId)
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.RoomId;
    -- Booked BED End
    -- Avaliable Rooms
    SELECT B.BlockName+'-'+A.ApartmentNo+' - '+R.RoomNo AS label,R.Id AS RoomId,
    BP.SingleandMarkup,BP.DoubleandMarkup,BP.TripleandMarkup  
    FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON
    B.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
    A.PropertyId = P.Id AND A.BlockId = B.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
    R.BlockId=B.Id AND R.PropertyId=P.Id AND R.ApartmentId = A.Id
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.PropertyId=P.Id 
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND 
    B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND 
    P.Id=@PropertyId AND P.Category='Managed G H' AND 
    BP.Id=@Id1 AND
    R.Id NOT IN (SELECT RoomId FROM #ExistingManagedGHProperty1);
   END
  IF @PropertyType = 'DdP'
   BEGIN 
    CREATE TABLE #ExDdPApartmnt1(ApartmentId BIGINT);
    CREATE TABLE #ExistingDedicatedProperty1(RoomId BIGINT);
    -- Booked Room Begin
    INSERT INTO #ExistingDedicatedProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingDedicatedProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingDedicatedProperty1(RoomId) 
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExistingDedicatedProperty1(RoomId)
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.RoomId;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
    PG.BookingPropertyId=@PropertyId;*/
    -- Booked Room End
    -- Booked Apartment Begin
    INSERT INTO #ExDdPApartmnt1(ApartmentId) 
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #ExDdPApartmnt1(ApartmentId) 
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #ExDdPApartmnt1(ApartmentId) 
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #ExDdPApartmnt1(ApartmentId) 
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.ApartmentId;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
    PG.BookingPropertyId=@PropertyId;*/
    -- Booked Apartment End
    -- Avaliable Rooms
    CREATE TABLE #DdP(label NVARCHAR(100),RoomId BIGINT,
    SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
    TripleandMarkup DECIMAL(27,2));
    INSERT INTO #DdP(label,RoomId,SingleandMarkup,DoubleandMarkup,
    TripleandMarkup)
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
    R.Id AS RoomId,BP.SingleandMarkup,BP.DoubleandMarkup,
    BP.TripleandMarkup FROM WRBHBContractManagementTariffAppartment D
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
    R.PropertyId=D.PropertyId AND R.Id=D.RoomId    
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
    BP.PropertyId=D.PropertyId
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND 
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND 
    A.IsActive=1 AND A.IsDeleted=0 AND 
    A.SellableApartmentType != 'HUB' AND
    A.Status='Active' AND R.RoomStatus='Active' AND
    BP.Id=@Id1 AND D.PropertyId=@PropertyId AND
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1) 
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
    --
    INSERT INTO #DdP(label,RoomId,SingleandMarkup,DoubleandMarkup,
    TripleandMarkup)
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
    R.Id AS RoomId,BP.SingleandMarkup,BP.DoubleandMarkup,
    BP.TripleandMarkup FROM WRBHBContractManagementAppartment D
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
    R.PropertyId=D.PropertyId
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId AND
    A.Id=D.ApartmentId
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON 
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
    BP.PropertyId=D.PropertyId
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND 
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND 
    A.IsActive=1 AND A.IsDeleted=0 AND 
    A.SellableApartmentType != 'HUB' AND
    A.Status='Active' AND R.RoomStatus='Active' AND
    BP.Id=@Id1 AND D.PropertyId=@PropertyId AND
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1) 
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
    --
    SELECT label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup 
    FROM #DdP 
    GROUP BY label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup
    ORDER BY label,RoomId;
   END  
  IF @PropertyType = 'InP'
   BEGIN
    -- Get Property All Rooms 
    CREATE TABLE #Tmp_InternalRoom(label NVARCHAR(100),RoomId BIGINT,
    SingleandMarkup DECIMAL(27,2),DoubleandMarkup DECIMAL(27,2),
    TripleandMarkup DECIMAL(27,2));
    INSERT INTO #Tmp_InternalRoom(label,RoomId,SingleandMarkup,
    DoubleandMarkup,TripleandMarkup)
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
    R.RoomType AS label,R.Id AS RoomId,
    BP.SingleandMarkup+BP.Markup,BP.DoubleandMarkup+BP.Markup,
    CASE WHEN BP.TripleandMarkup > 0 THEN BP.TripleandMarkup+BP.Markup
    ELSE BP.TripleandMarkup END AS TripleandMarkup 
    FROM WRBHBProperty P
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
    A.PropertyId=P.Id AND A.BlockId=B.Id
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
    R.PropertyId=P.Id AND R.ApartmentId=A.Id
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON 
    BP.PropertyId=P.Id
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND 
    R.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
    B.IsActive=1 AND B.IsDeleted=0 AND 
    A.SellableApartmentType != 'HUB' AND
    A.Status='Active' AND R.RoomStatus='Active' AND
    P.Id=@PropertyId AND BP.Id=@Id1;
-- Property Booked Rooms Begin
    CREATE TABLE #BookedRoomsInP(RoomId BIGINT,Sts NVARCHAR(100));
    -- Dedicated Rooms
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT RoomId,'Dedicated Room' 
    FROM WRBHBContractManagementTariffAppartment
    WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND
    PropertyId=@PropertyId;
    -- Dedicated Apartment
    INSERT INTO #BookedRoomsInP(RoomId,Sts)  
    SELECT R.Id,'Dedicated Apartment' FROM WRBHBPropertyRooms R
    LEFT OUTER JOIN WRBHBContractManagementAppartment T 
    WITH(NOLOCK)ON T.ApartmentId=R.ApartmentId
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND T.IsActive=1 AND 
    T.IsDeleted=0 AND T.ApartmentId != 0 AND 
    R.ApartmentId=T.ApartmentId AND T.PropertyId=@PropertyId;
    -- Booked Rooms Begin
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT PG.RoomId,'Room Booking' FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.RoomId;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND
    PG.BookingPropertyId=@PropertyId;*/
    -- Booked Rooms End
    -- Booked Beds Begin
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Bed Booking' 
    FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Bed Booking'
    FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Bed Booking'
    FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #BookedRoomsInP(RoomId,Sts) 
    SELECT PG.RoomId,'Bed Booking'
    FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY PG.RoomId;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND 
    PG.BookingPropertyId=@PropertyId;*/
    -- Booked Beds End
    -- Booked Apartment Begin
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
    PG.ApartmentId=R.ApartmentId
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND 
    PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
    PG.ApartmentId=R.ApartmentId
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
    /*PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND 
    PG.BookingPropertyId=@PropertyId;*/
    --
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
    PG.ApartmentId=R.ApartmentId
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN 
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.BookingPropertyId=@PropertyId GROUP BY R.Id;
    /*PG.ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND
    PG.ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND 
    CONVERT(DATE,@ChkOutDt,103) AND 
    PG.BookingPropertyId=@PropertyId;*/
    -- 
    INSERT INTO #BookedRoomsInP(RoomId,Sts)
    SELECT R.Id,'Apartment Booking' FROM WRBHBPropertyRooms R
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND
    PG.ApartmentId=R.ApartmentId
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND 
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND 
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <= 
    CAST(@ChkInDt AS DATETIME) AND
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
    GROUP BY R.Id;
    /*PG.ChkInDt <= CONVERT(DATE,@ChkInDt,103) AND
    PG.ChkOutDt >= CONVERT(DATE,@ChkOutDt,103) AND 
    PG.BookingPropertyId=@PropertyId;*/
    -- Booked Apartment End
-- Property Booked Rooms End
    -- Avaliable Rooms
    --select * from #Tmp_InternalRoom;
    --select * from #BookedRoomsInP;RETURN;
    SELECT label,RoomId,SingleandMarkup,DoubleandMarkup,TripleandMarkup 
    FROM #Tmp_InternalRoom
    WHERE RoomId NOT IN (SELECT RoomId FROM #BookedRoomsInP);
   END
  IF @PropertyType = 'CPP'
   BEGIN
    SELECT BP.RoomType AS label,0 AS RoomId,BP.SingleandMarkup,
    BP.DoubleandMarkup,BP.TripleandMarkup FROM WRBHBBookingProperty BP
    WHERE BP.IsActive=1 AND IsDeleted=0 AND BP.PropertyId=@PropertyId 
    AND BP.Id=@Id1;
   END
  IF @PropertyType = 'ExP'
   BEGIN
    SELECT BP.RoomType AS label,0 AS RoomId,
    BP.SingleandMarkup+BP.Markup AS SingleandMarkup,
    BP.DoubleandMarkup+BP.Markup AS DoubleandMarkup,
    CASE WHEN BP.TripleandMarkup > 0 THEN BP.TripleandMarkup+BP.Markup
    ELSE BP.TripleandMarkup END AS TripleandMarkup 
    FROM WRBHBBookingProperty BP
    WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND BP.PropertyId=@PropertyId
    AND BP.Id=@Id1;
   END
  IF @PropertyType = 'MMT'
   BEGIN
    SELECT BP.RoomType AS label,0 AS RoomId,
    BP.SingleandMarkup+BP.Markup AS SingleandMarkup,
    BP.DoubleandMarkup+BP.Markup AS DoubleandMarkup,
    CASE WHEN BP.TripleandMarkup > 0 THEN BP.TripleandMarkup+BP.Markup
    ELSE BP.TripleandMarkup END AS TripleandMarkup 
    FROM WRBHBBookingProperty BP
    WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND BP.Id=@Id1;
   END
   -- Tab 3 Guest Details
  SELECT GuestId,EmpCode,FirstName,LastName,Id AS BookingGuestTableId,
  0 AS Tick,1 AS Chk,FirstName+'  '+LastName AS Name 
  FROM WRBHBBookingGuestDetails 
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@BookingId;
  --
  SELECT 'Direct' AS label;
 END
IF @Action = 'CustomFields'
 BEGIN
  -- Field Name
  CREATE TABLE #Column(FieldName NVARCHAR(100),Mandatory BIT,Id INT);
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column1,Column1Mandatory,1 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column2,Column2Mandatory,2 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column3,Column3Mandatory,3 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column4,Column4Mandatory,4 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column5,Column5Mandatory,5 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column6,Column6Mandatory,6 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column7,Column7Mandatory,7 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column8,Column8Mandatory,8 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column9,Column9Mandatory,9 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  INSERT INTO #Column(FieldName,Mandatory,Id)
  SELECT Column10,Column10Mandatory,10 FROM WRBHBClientColumns
  WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @ClientId;
  --
  SELECT FieldName,Mandatory,Id FROM #Column;
  -- Column 1 Field ValueS
  CREATE TABLE #Column1Values(label NVARCHAR(100));
  INSERT INTO #Column1Values(label)
  SELECT DISTINCT Column1 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column1,'') != '';
  --
  SELECT label FROM #Column1Values ORDER BY label ASC;
  -- Column 2 Field ValueS
  CREATE TABLE #Column2Values(label NVARCHAR(100));
  INSERT INTO #Column2Values(label)
  SELECT DISTINCT Column2 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column2,'') != '';
  --
  SELECT label FROM #Column2Values ORDER BY label ASC;
  -- Column 3 Field ValueS
  CREATE TABLE #Column3Values(label NVARCHAR(100));
  INSERT INTO #Column3Values(label)
  SELECT DISTINCT Column3 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column3,'') != '';
  --
  SELECT label FROM #Column3Values ORDER BY label ASC;
  -- Column 4 Field ValueS
  CREATE TABLE #Column4Values(label NVARCHAR(100));
  INSERT INTO #Column4Values(label)
  SELECT DISTINCT Column4 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column4,'') != '';
  --
  SELECT label FROM #Column4Values ORDER BY label ASC;
  -- Column 5 Field ValueS
  CREATE TABLE #Column5Values(label NVARCHAR(100));
  INSERT INTO #Column5Values(label)
  SELECT DISTINCT Column5 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column5,'') != '';
  --
  SELECT label FROM #Column5Values ORDER BY label ASC;
  -- Column 6 Field ValueS
  CREATE TABLE #Column6Values(label NVARCHAR(100));
  INSERT INTO #Column6Values(label)
  SELECT DISTINCT Column6 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column6,'') != '';
  --
  SELECT label FROM #Column6Values ORDER BY label ASC;
  -- Column 7 Field ValueS
  CREATE TABLE #Column7Values(label NVARCHAR(100));
  INSERT INTO #Column7Values(label)
  SELECT DISTINCT Column7 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column7,'') != '';
  --
  SELECT label FROM #Column7Values ORDER BY label ASC;
  -- Column 8 Field ValueS
  CREATE TABLE #Column8Values(label NVARCHAR(100));
  INSERT INTO #Column8Values(label)
  SELECT DISTINCT Column8 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column8,'') != '';
  --
  SELECT label FROM #Column8Values ORDER BY label ASC;
  -- Column 9 Field ValueS
  CREATE TABLE #Column9Values(label NVARCHAR(100));
  INSERT INTO #Column9Values(label)
  SELECT DISTINCT Column9 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column9,'') != '';
  --
  SELECT label FROM #Column9Values ORDER BY label ASC;
  -- Column 10 Field ValueS
  CREATE TABLE #Column10Values(label NVARCHAR(100));
  INSERT INTO #Column10Values(label)
  SELECT DISTINCT Column10 FROM WRBHBClientManagementAddClientGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND CltmgntId = @ClientId AND
  ISNULL(Column10,'') != '';
  --
  SELECT label FROM #Column10Values ORDER BY label ASC;
  -- Guest Existing data
  SELECT ISNULL(Column1,'') AS Column1,ISNULL(Column2,'') AS Column2,
  ISNULL(Column3,'') AS Column3,ISNULL(Column4,'') AS Column4,
  ISNULL(Column5,'') AS Column5,ISNULL(Column6,'') AS Column6,
  ISNULL(Column7,'') AS Column7,ISNULL(Column8,'') AS Column8,
  ISNULL(Column9,'') AS Column9,ISNULL(Column10,'') AS Column10
  FROM WRBHBClientManagementAddClientGuest
  WHERE Id = @Id1 AND CltmgntId = @ClientId;
 END
END