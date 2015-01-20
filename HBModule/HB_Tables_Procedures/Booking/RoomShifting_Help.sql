-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_RoomShifting_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_RoomShifting_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:2-Jun-2014
-- Description:	Room Shifting Help
-- =================================================================================
/*********************************************************************************************************
'Name			Date			Description of Changes
********************************************************************************************************	
Sakthi          3rd & 4th Dec 2014   Process alterations - rework
********************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_RoomShifting_Help](@Action NVARCHAR(100),  
@Str1 NVARCHAR(100),@BookingLevel NVARCHAR(100),@ChkInDt NVARCHAR(100),  
@ChkOutDt NVARCHAR(100),@BookingId BIGINT,@RoomId BIGINT,@Id1 BIGINT,  
@Id2 BIGINT)  
AS  
BEGIN  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF  
IF @Action = 'BookingLoad'  
 BEGIN  
  -- Get CheckIn & Booked Booking  
  CREATE TABLE #TMP(BookingCode BIGINT,BookingId BIGINT,Guest NVARCHAR(100),  
  RoomId BIGINT,RoomCaptured INT,CurrentStatus NVARCHAR(100),  
  PropertyName NVARCHAR(100),RoomType NVARCHAR(100),PropertyType NVARCHAR(100),
  BookingLevel NVARCHAR(100));
  -- Room
  INSERT INTO #TMP(BookingCode,BookingId,Guest,RoomId,RoomCaptured,  
  CurrentStatus,PropertyName,RoomType,PropertyType,BookingLevel)  
  SELECT B.BookingCode,BG.BookingId,  
  BG.FirstName+' '+BG.LastName AS Guest,BG.RoomId,BG.RoomCaptured,  
  BG.CurrentStatus,BP.PropertyName,BG.RoomType,BP.PropertyType,
  B.BookingLevel   
  FROM WRBHBBooking B  
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON  
  BP.BookingId=B.Id    
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON   
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId    
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BG.IsActive=1 AND BG.IsDeleted=0 AND  
  BG.CurrentStatus IN ('CheckIn','Booked') AND B.BookingLevel = 'Room' AND 
  BP.PropertyType IN ('InP','MGH','DdP','ExP','CPP') AND
  ISNULL(RoomShiftingFlag,0) = 0 AND B.BookingCode != 0;
  /*-- Bed
  INSERT INTO #TMP(BookingCode,BookingId,Guest,RoomId,RoomCaptured,  
  CurrentStatus,PropertyName,RoomType,PropertyType,BookingLevel)  
  SELECT B.BookingCode,BG.BookingId,  
  BG.FirstName+' '+BG.LastName AS Guest,BG.BedId,BG.RoomCaptured,  
  BG.CurrentStatus,BP.PropertyName,BG.BedType,BP.PropertyType,
  B.BookingLevel   
  FROM WRBHBBooking B  
  LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON  
  BP.BookingId=B.Id    
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON   
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId    
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BG.IsActive=1 AND BG.IsDeleted=0 AND  
  BG.CurrentStatus IN ('CheckIn','Booked') AND B.BookingLevel = 'Bed' AND 
  BP.PropertyType IN ('InP','MGH') AND
  ISNULL(RoomShiftingFlag,0) = 0 AND B.BookingCode != 0;
  -- Apartment
  INSERT INTO #TMP(BookingCode,BookingId,Guest,RoomId,RoomCaptured,  
  CurrentStatus,PropertyName,RoomType,PropertyType,BookingLevel)  
  SELECT B.BookingCode,BG.BookingId,  
  BG.FirstName+' '+BG.LastName AS Guest,BG.ApartmentId,BG.RoomCaptured,  
  BG.CurrentStatus,BP.PropertyName,BG.ApartmentType,BP.PropertyType,
  B.BookingLevel   
  FROM WRBHBBooking B  
  LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON  
  BP.BookingId=B.Id    
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON   
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId    
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BG.IsActive=1 AND BG.IsDeleted=0 AND  
  BG.CurrentStatus IN ('CheckIn','Booked') AND B.BookingLevel = 'Apartment' AND 
  BP.PropertyType IN ('InP','DdP') AND
  ISNULL(RoomShiftingFlag,0) = 0 AND B.BookingCode != 0;*/
  -- Get Guest in CheckIn & Booked Booking
  CREATE TABLE #TMP1(Guest NVARCHAR(100),BookingCode INT,BookingId INT,  
  RoomId INT,RoomCapturedId INT,BookingLevelId NVARCHAR(100),  
  CurrentStatus NVARCHAR(100),PropertyName NVARCHAR(100),
  RoomType NVARCHAR(100),PropertyType NVARCHAR(100));
  INSERT INTO #TMP1(Guest,BookingCode,BookingId,RoomId,RoomCapturedId,  
  BookingLevelId,CurrentStatus,PropertyName,RoomType,PropertyType)  
  SELECT STUFF((SELECT ', ' + BA.Guest FROM #TMP BA   
  WHERE BA.BookingId = B.BookingId AND BA.RoomId = B.RoomId AND  
  BA.RoomCaptured = B.RoomCaptured  
  FOR XML PATH('')),1,1,'') AS Guest,B.BookingCode,B.BookingId,  
  B.RoomId,B.RoomCaptured AS RoomCapturedId,B.BookingLevel,  
  B.CurrentStatus,B.PropertyName,B.RoomType,B.PropertyType FROM #TMP AS B   
  GROUP BY B.BookingCode,B.BookingId,B.RoomCaptured,B.RoomId,B.CurrentStatus,  
  B.PropertyName,B.RoomType,B.PropertyType,B.BookingLevel;
  --
  IF @Str1 = 'Shift'
   BEGIN
    SELECT T.BookingCode,T.BookingId,T.BookingLevelId,T.CurrentStatus,
    T.Guest,T.PropertyName,T.RoomId,T.RoomCapturedId,T.RoomType AS RoomNoId
    FROM #TMP1 T WHERE PropertyType IN ('InP','MGH','DdP')
    GROUP BY T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,
    T.BookingLevelId,T.PropertyName,T.RoomType,T.CurrentStatus
    ORDER BY T.BookingCode,T.RoomCapturedId ASC;
   END
  IF @Str1 = 'Stay'
   BEGIN
    SELECT T.BookingCode,T.BookingId,T.BookingLevelId,T.CurrentStatus,
    T.Guest,T.PropertyName,T.RoomId,T.RoomCapturedId,T.RoomType AS RoomNoId
    FROM #TMP1 T
    GROUP BY T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,
    T.BookingLevelId,T.PropertyName,T.RoomType,T.CurrentStatus
    ORDER BY T.BookingCode,T.RoomCapturedId ASC;
   END  
 END  
IF @Action = 'DateLoad'  
 BEGIN  
  DECLARE @CurrentStatus NVARCHAR(100)='',@PtyType NVARCHAR(100) = '';
  DECLARE @TariffPaymentMode NVARCHAR(100)='',@ServicePaymentMode NVARCHAR(100)='';    
  DECLARE @EChkInDt DATE,@EChkOutDt DATE,@ChkInDtStart DATE;
  DECLARE @ChkInDtEnd DATE,@ChkOutDtStart DATE;
  DECLARE @AChkInDt DATE,@AChkOutDt DATE,@Flag NVARCHAR(100);
  DECLARE @MOPCount INT=0;
  --
  SELECT @MOPCount = COUNT(*) FROM WRBHBUserRoles UR
  LEFT OUTER JOIN WRBHBRoles R WITH(NOLOCK)ON R.Id = UR.RolesId
  WHERE UR.IsActive = 1 AND UR.IsDeleted = 0 AND
  R.IsActive = 1 AND R.IsDeleted = 0 AND 
  UR.RolesId IN (2,14,21,23) AND UR.UserId = @Id2;
  -- Get CheckIn & CheckOut Date in Room Level
  IF @BookingLevel = 'Room'
   BEGIN
    -- Get CurrentStatus & Property Type
    SELECT TOP 1 @PtyType = BP.PropertyType,@CurrentStatus = BG.CurrentStatus,
    @TariffPaymentMode = BG.TariffPaymentMode,
    @ServicePaymentMode = BG.ServicePaymentMode
    FROM WRBHBBookingProperty BP
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND
    BG.BookingPropertyId=BP.PropertyId
    WHERE BG.IsActive = 1 AND BG.IsDeleted = 0 AND BP.IsActive = 1 AND
    BP.IsDeleted = 0 AND BP.BookingId = @BookingId AND
    BG.RoomCaptured = @Id1 ORDER BY BG.Id DESC;
    --
    IF @Str1 = 'Shift'
     BEGIN
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),@ChkInDtEnd = MAX(ChkOutDt),
        @ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @ChkInDtStart;
        SET @AChkOutDt = @ChkInDtEnd;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt,
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103);
        SET @Flag = 'Yes';
       END
     END  
    IF @Str1 = 'Stay'
     BEGIN
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),
        @ChkInDtEnd = MAX(ChkOutDt),@ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @EChkInDt;
        SET @AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
     END    
   END
  -- Get CheckIn & CheckOut Date in Bed Level
  IF @BookingLevel = 'Bed'
   BEGIN
    -- Get CurrentStatus & Property Type
    SELECT TOP 1 @PtyType = BP.PropertyType,@CurrentStatus = BG.CurrentStatus,
    @TariffPaymentMode = BG.TariffPaymentMode,
    @ServicePaymentMode = BG.ServicePaymentMode
    FROM WRBHBBedBookingProperty BP
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND
    BG.BookingPropertyId=BP.PropertyId
    WHERE BG.IsActive = 1 AND BG.IsDeleted = 0 AND BP.IsActive = 1 AND
    BP.IsDeleted = 0 AND BP.BookingId = @BookingId AND
    BG.RoomCaptured = @Id1 ORDER BY BG.Id DESC;
    --
    --select @Str1,@CurrentStatus;return;
    --
    IF @Str1 = 'Shift'
     BEGIN
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),@ChkInDtEnd = MAX(ChkOutDt),
        @ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @ChkInDtStart;
        SET @AChkOutDt = @ChkInDtEnd;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt,
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103);
        SET @Flag = 'Yes';
       END
     END  
    IF @Str1 = 'Stay'
     BEGIN
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),
        @ChkInDtEnd = MAX(ChkOutDt),@ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBBedBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @EChkInDt;
        SET @AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
     END    
   END
  -- Get CheckIn & CheckOut Date in Apartment Level
  IF @BookingLevel = 'Apartment'
   BEGIN
    -- Get CurrentStatus & Property Type
    SELECT TOP 1 @PtyType = BP.PropertyType,@CurrentStatus = BG.CurrentStatus,
    @TariffPaymentMode = BG.TariffPaymentMode,
    @ServicePaymentMode = BG.ServicePaymentMode
    FROM WRBHBApartmentBookingProperty BP
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND
    BG.BookingPropertyId=BP.PropertyId
    WHERE BG.IsActive = 1 AND BG.IsDeleted = 0 AND BP.IsActive = 1 AND
    BP.IsDeleted = 0 AND BP.BookingId = @BookingId AND
    BG.RoomCaptured = @Id1 ORDER BY BG.Id DESC;
    --
    IF @Str1 = 'Shift'
     BEGIN
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),@ChkInDtEnd = MAX(ChkOutDt),
        @ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @ChkInDtStart;
        SET @AChkOutDt = @ChkInDtEnd;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt,
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103);
        SET @Flag = 'Yes';
       END
     END  
    IF @Str1 = 'Stay'
     BEGIN
      IF @CurrentStatus = 'Booked'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = CONVERT(DATE,DATEADD(YEAR,-1,GETDATE()),103),
        @ChkInDtEnd = CONVERT(DATE,DATEADD(YEAR,1,GETDATE()),103),
        @ChkOutDtStart = CONVERT(DATE,DATEADD(DAY,1,@ChkInDtStart),103),
        @AChkInDt = @EChkInDt,@AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
      IF @CurrentStatus = 'CheckIn'
       BEGIN
        SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1;
        SELECT @ChkInDtStart = MIN(ChkInDt),
        @ChkInDtEnd = MAX(ChkOutDt),@ChkOutDtStart = DATEADD(DAY,1,MIN(ChkInDt))
        FROM WRBHBApartmentBookingPropertyAssingedGuest
        WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
        RoomCaptured = @Id1 AND ISNULL(RoomShiftingFlag,0) = 0;
        SET @AChkInDt = @EChkInDt;
        SET @AChkOutDt = @EChkOutDt;
        SET @Flag = 'Yes';
       END
     END    
   END
  -- Get Existing Checkindate,Checkoutdate,Payment Modes & Property Type
  SELECT @EChkInDt AS EChkInDt,@EChkOutDt AS EChkOutDt,
  @ChkInDtStart AS ChkInDtStart,@ChkInDtEnd AS ChkInDtEnd,
  @ChkOutDtStart AS ChkOutDtStart,@Flag AS Flag,@AChkInDt AS AChkInDt,
  @AChkOutDt AS AChkOutDt,@CurrentStatus AS CurrentStatus,@MOPCount AS MOPCount,
  @PtyType AS PropertyType,@TariffPaymentMode AS TariffPaymentMode,
  @ServicePaymentMode AS ServicePaymentMode;   
  -- Get Payment Modes from Client
  IF @PtyType = 'MMT'
   BEGIN
    SELECT 'Bill to Company (BTC)' AS label;
    SELECT 'Direct' AS label;
   END
  ELSE
   BEGIN
    CREATE TABLE #PAYMENT(label NVARCHAR(100));
    DECLARE @BTC BIT = (SELECT ISNULL(BTC,0) FROM WRBHBClientManagement
    WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId));
    IF @BTC = 1
     BEGIN
      INSERT INTO #PAYMENT(label) SELECT 'Bill to Company (BTC)';
     END
    IF @PtyType = 'CPP'
     BEGIN
      INSERT INTO #PAYMENT(label) SELECT 'Bill to Client';
     END
    INSERT INTO #PAYMENT(label) SELECT 'Direct';
    --
    SELECT label FROM #PAYMENT ORDER BY label ASC;
    SELECT label FROM #PAYMENT ORDER BY label ASC;
   END
 END  
IF @Action = 'AvaliableRooms'  
 BEGIN
  -- Get Type & Property Type & Property Id  
  DECLARE @GetType NVARCHAR(100),@PropertyType NVARCHAR(100),@PropertyId INT;
  IF @BookingLevel = 'Room'
   BEGIN
    SELECT TOP 1 @GetType=GetType,@PropertyType=PropertyType,
    @PropertyId=PropertyId FROM WRBHBBookingProperty
    WHERE Id IN (SELECT BookingPropertyTableId
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@BookingId);  
   END
  IF @BookingLevel = 'Bed'
   BEGIN
    SELECT TOP 1 @GetType=GetType,@PropertyType=PropertyType,
    @PropertyId=PropertyId FROM WRBHBBedBookingProperty
    WHERE Id IN (SELECT BookingPropertyTableId
    FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId=@BookingId);
   END
  IF @BookingLevel = 'Apartment'
   BEGIN
    SELECT TOP 1 @GetType=GetType,@PropertyType=PropertyType,
    @PropertyId=PropertyId FROM WRBHBApartmentBookingProperty
    WHERE Id IN (SELECT BookingPropertyTableId
    FROM WRBHBApartmentBookingPropertyAssingedGuest WHERE BookingId=@BookingId);
   END
  CREATE TABLE #BokedRoom(RoomId BIGINT);
  -- Booked Room Begin
  INSERT INTO #BokedRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BokedRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BokedRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BokedRoom(RoomId)
  SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId;
  -- Booked Room End
  CREATE TABLE #BokedBed(BedId BIGINT, RoomId BIGINT);
  -- Booked Bed Begin
  INSERT INTO #BokedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND    
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BokedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BokedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BokedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.RoomId,PG.BedId;  
  -- Booked BED End
  CREATE TABLE #BokedApartment(ApartmentId BIGINT);
  -- Booked Apartment Begin  
  INSERT INTO #BokedApartment(ApartmentId)   
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;  
  --  
  INSERT INTO #BokedApartment(ApartmentId)   
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;  
  --  
  INSERT INTO #BokedApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;  
  --   
  INSERT INTO #BokedApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId
  GROUP BY PG.ApartmentId;
  -- Booked Apartment End
  -- Dedicated Room
  CREATE TABLE #DedicatedRoomsInP(RoomId BIGINT);
  INSERT INTO #DedicatedRoomsInP(RoomId)
  SELECT RoomId FROM WRBHBContractManagementTariffAppartment
  WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND PropertyId=@PropertyId;
  -- Dedicated Apartment
  CREATE TABLE #DedicatedApartmentInP(ApartmentId BIGINT);
  INSERT INTO #DedicatedApartmentInP(ApartmentId)
  SELECT T.ApartmentId FROM WRBHBContractManagementAppartment T
  WHERE T.IsActive=1 AND T.IsDeleted=0 AND T.ApartmentId != 0;
  --
  CREATE TABLE #TMPTABLE(label NVARCHAR(100),RoomId BIGINT);  
  --
  IF @BookingLevel = 'Room'
   BEGIN
    IF @PropertyType = 'MGH'
     BEGIN
      INSERT INTO #TMPTABLE(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
      R.Id AS RoomId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
      A.PropertyId=P.Id AND A.BlockId = B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
      R.BlockId=B.Id AND R.PropertyId=P.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND
      B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
      P.Id=@PropertyId AND P.Category='Managed G H' AND
      A.IsActive = 1 AND A.IsDeleted = 0 AND A.Status = 'Active' AND
      A.SellableApartmentType != 'HUB' AND R.RoomStatus = 'Active' AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedBed) AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoomsInP) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartmentInP) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;
     END
    IF @PropertyType = 'DdP'
     BEGIN
      -- Dedicated ROOM
      CREATE TABLE #DdP(label NVARCHAR(100),RoomId BIGINT);
      INSERT INTO #DdP(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
      R.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND 
      A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
      A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
      R.RoomStatus='Active' AND A.PropertyId = @PropertyId AND 
      A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
      LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D
      WITH(NOLOCK)ON D.ContractId=H.Id
      WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
      D.IsDeleted=0 AND H.ClientId=(SELECT ClientId FROM WRBHBBooking 
      WHERE Id = @BookingId) AND H.ContractType=' Dedicated Contracts ' AND
      D.PropertyId = @PropertyId) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedBed);  
      -- Dedicated apartment  
      INSERT INTO #DdP(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
      R.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND 
      A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
      A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
      R.RoomStatus='Active' AND A.PropertyId = @PropertyId AND 
      A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
      LEFT OUTER JOIN WRBHBContractManagementAppartment D
      WITH(NOLOCK)ON D.ContractId=H.Id
      WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
      D.IsDeleted=0 AND H.ClientId=(SELECT ClientId FROM WRBHBBooking 
      WHERE Id = @BookingId) AND H.ContractType=' Dedicated Contracts ' AND
      D.PropertyId = @PropertyId) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedBed);
      --  
      INSERT INTO #TMPTABLE(label,RoomId)
      SELECT label,RoomId FROM #DdP GROUP BY label,RoomId ORDER BY label;
     END
    IF @PropertyType = 'InP'
     BEGIN
      -- Get Property All Rooms
      INSERT INTO #TMPTABLE(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+R.RoomType AS 
      label,R.Id AS RoomId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
      R.PropertyId=P.Id AND R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND
      R.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND
      B.IsActive=1 AND B.IsDeleted=0 AND A.SellableApartmentType != 'HUB' AND
      A.Status='Active' AND R.RoomStatus='Active' AND P.Id=@PropertyId AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedBed) AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoomsInP) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartmentInP)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo ASC;
     END
   END
  IF @BookingLevel = 'Bed'
   BEGIN
    IF @PropertyType = 'MGH'
     BEGIN
      INSERT INTO #TMPTABLE(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+RB.BedNO AS label,
      B.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON 
      A.PropertyId=P.Id AND A.BlockId = B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
      R.BlockId=B.Id AND R.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyRoomBeds RB WITH(NOLOCK)ON
      RB.RoomId = R.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND
      B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
      RB.IsActive = 1 AND RB.IsDeleted = 0 AND
      P.Id=@PropertyId AND P.Category='Managed G H' AND
      A.IsActive = 1 AND A.IsDeleted = 0 AND A.Status = 'Active' AND
      A.SellableApartmentType != 'HUB' AND R.RoomStatus = 'Active' AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT BedId FROM #BokedBed) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoomsInP) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartmentInP)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo,RB.BedNO;
     END    
    IF @PropertyType = 'InP'
     BEGIN
      -- Get Property All Rooms
      INSERT INTO #TMPTABLE(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+R.RoomType+
      ' - '+RB.BedNO AS label,RB.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
      R.PropertyId=P.Id AND R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBPropertyRoomBeds RB WITH(NOLOCK)ON
      RB.RoomId = R.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND
      R.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND
      RB.IsActive = 1 AND RB.IsDeleted = 0 AND
      B.IsActive=1 AND B.IsDeleted=0 AND A.SellableApartmentType != 'HUB' AND
      A.Status='Active' AND R.RoomStatus='Active' AND P.Id=@PropertyId AND
      A.Id NOT IN (SELECT ApartmentId FROM #BokedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BokedRoom) AND
      R.Id NOT IN (SELECT BedId FROM #BokedBed) AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoomsInP) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartmentInP)
      ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo ASC;
     END
   END
  -- Avaliable rooms  
  SELECT label,RoomId FROM #TMPTABLE;  
 END  
IF @Action = 'AvaliableFromRoom'  
 BEGIN
  DECLARE @GetType1 NVARCHAR(100),@PropertyType1 NVARCHAR(100),@PropertyId1 INT;
  IF @BookingLevel = 'Room'
   BEGIN
    -- Get Type & Property Type & Property Id
    SELECT TOP 1 @GetType1=GetType,@PropertyType1=PropertyType,
    @PropertyId1=PropertyId FROM WRBHBBookingProperty
    WHERE Id IN (SELECT BookingPropertyTableId
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@BookingId
    GROUP BY BookingPropertyTableId);  
   END
  IF @BookingLevel = 'Bed'
   BEGIN
    -- Get Type & Property Type & Property Id
    SELECT TOP 1 @GetType1=GetType,@PropertyType1=PropertyType,
    @PropertyId1=PropertyId FROM WRBHBBedBookingProperty
    WHERE Id IN (SELECT BookingPropertyTableId
    FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId=@BookingId
    GROUP BY BookingPropertyTableId);
   END
  IF @BookingLevel = 'Apartment'
   BEGIN
    -- Get Type & Property Type & Property Id      
    SELECT TOP 1 @GetType1=GetType,@PropertyType1=PropertyType,  
    @PropertyId1=PropertyId FROM WRBHBApartmentBookingProperty   
    WHERE Id IN (SELECT BookingPropertyTableId  
    FROM WRBHBApartmentBookingPropertyAssingedGuest WHERE BookingId=@BookingId  
    GROUP BY BookingPropertyTableId);  
   END
  CREATE TABLE #AgedGst(Id BIGINT);
  CREATE TABLE #DedicatedRoom(RoomId BIGINT);
  INSERT INTO #DedicatedRoom(RoomId)
  SELECT RoomId FROM WRBHBContractManagementTariffAppartment
  WHERE RoomId != 0 AND PropertyId = @PropertyId1;
  CREATE TABLE #DedicatedApartment(ApartmentId BIGINT);
  INSERT INTO #DedicatedApartment(ApartmentId)
  SELECT ApartmentId FROM WRBHBContractManagementAppartment
  WHERE ApartmentId != 0 AND PropertyId = @PropertyId1;
  CREATE TABLE #TMPTABLE1(label NVARCHAR(100),RoomId BIGINT);
  DECLARE @AvaRoomCnt INT;
  CREATE TABLE #BookedRoom(RoomId BIGINT,BookingLevel NVARCHAR(100));
  -- Booked Room Begin
  INSERT INTO #BookedRoom(RoomId,BookingLevel)
  SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BookedRoom(RoomId,BookingLevel)
  SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BookedRoom(RoomId,BookingLevel)
  SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
  --   
  INSERT INTO #BookedRoom(RoomId,BookingLevel)
  SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1
  GROUP BY PG.RoomId;
  -- Booked Room End
  CREATE TABLE #BookedBed(BedId BIGINT, RoomId BIGINT);
  -- Booked Bed Begin
  INSERT INTO #BookedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND    
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BookedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BookedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId,PG.BedId;  
  --   
  INSERT INTO #BookedBed(BedId, RoomId)
  SELECT PG.BedId,PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1
  GROUP BY PG.RoomId,PG.BedId;  
  -- Booked BED End
  CREATE TABLE #BookedApartment(ApartmentId BIGINT);
  -- Booked Apartment Begin  
  INSERT INTO #BookedApartment(ApartmentId)   
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
  --  
  INSERT INTO #BookedApartment(ApartmentId)   
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
  --  
  INSERT INTO #BookedApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
  CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
  PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
  --   
  INSERT INTO #BookedApartment(ApartmentId)
  SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
  WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
  CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
  CAST(@ChkInDt AS DATETIME) AND  
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
  CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1  
  GROUP BY PG.ApartmentId;
  -- Booked Apartment End
  IF @BookingLevel = 'Room'
   BEGIN    
    INSERT INTO #AgedGst(Id)  
    SELECT Id FROM WRBHBBookingPropertyAssingedGuest 
    WHERE BookingId=@BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
    RoomId = @RoomId AND RoomCaptured = @Id1 AND 
    ISNULL(RoomShiftingFlag,0) = 0;  
    --
    CREATE TABLE #RoomBookedRoom(RoomId BIGINT,BookingLevel NVARCHAR(100));
    -- Booked Room Begin
    INSERT INTO #RoomBookedRoom(RoomId,BookingLevel)
    SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #RoomBookedRoom(RoomId,BookingLevel)
    SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #RoomBookedRoom(RoomId,BookingLevel)
    SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #RoomBookedRoom(RoomId,BookingLevel)
    SELECT PG.RoomId,'Room' FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst)  GROUP BY PG.RoomId;
    -- Booked Room End        
    IF @PropertyType1 = 'MGH'
     BEGIN
      -- Avaliable Rooms
      INSERT INTO #TMPTABLE1(label,RoomId)
      SELECT B.BlockName+' - '+R.RoomNo AS label,R.Id AS RoomId
      FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON
      B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId = B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON
      R.BlockId=B.Id AND R.PropertyId=P.Id AND R.ApartmentId = A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND
      B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND
      P.Id=@PropertyId1 AND P.Category='Managed G H' AND  
      R.Id NOT IN (SELECT RoomId FROM #RoomBookedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedBed) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoom) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartment);
     END  
    IF @PropertyType1 = 'DdP'
     BEGIN      
      -- Avaliable Rooms
      CREATE TABLE #DdP1(label NVARCHAR(100),RoomId BIGINT);
      INSERT INTO #DdP1(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
      R.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND 
      A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
      A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
      R.RoomStatus='Active' AND A.PropertyId = @PropertyId1 AND 
      A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
      LEFT OUTER JOIN WRBHBContractManagementTariffAppartment D
      WITH(NOLOCK)ON D.ContractId=H.Id
      WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
      D.IsDeleted=0 AND H.ClientId=(SELECT ClientId FROM WRBHBBooking 
      WHERE Id = @BookingId) AND H.ContractType=' Dedicated Contracts ' AND
      D.PropertyId = @PropertyId1) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedBed);  
      -- Dedicated apartment  
      INSERT INTO #DdP(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,
      R.Id FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND 
      A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
      A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
      R.RoomStatus='Active' AND A.PropertyId = @PropertyId1 AND 
      A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
      LEFT OUTER JOIN WRBHBContractManagementAppartment D
      WITH(NOLOCK)ON D.ContractId=H.Id
      WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
      D.IsDeleted=0 AND H.ClientId=(SELECT ClientId FROM WRBHBBooking 
      WHERE Id = @BookingId) AND H.ContractType=' Dedicated Contracts ' AND
      D.PropertyId = @PropertyId1) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedBed);  
      --  
      INSERT INTO #TMPTABLE1(label,RoomId)  
      SELECT label,RoomId FROM #DdP1   
      GROUP BY label,RoomId ORDER BY label;  
     END    
    IF @PropertyType1 = 'InP'  
     BEGIN  
      -- Get Property All Rooms   
      INSERT INTO #TMPTABLE1(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+  
      R.RoomType AS label,R.Id AS RoomId  
      FROM WRBHBProperty P  
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id  
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
      A.PropertyId=P.Id AND A.BlockId=B.Id  
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON  
      R.PropertyId=P.Id AND R.ApartmentId=A.Id  
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND R.IsActive=1 AND   
      R.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND   
      B.IsActive=1 AND B.IsDeleted=0 AND   
      A.SellableApartmentType != 'HUB' AND  
      A.Status='Active' AND R.RoomStatus='Active' AND  
      P.Id=@PropertyId1 AND
      R.Id NOT IN (SELECT RoomId FROM #RoomBookedRoom) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedBed) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment) AND
      R.Id NOT IN (SELECT * FROM #DedicatedRoom) AND
      A.Id NOT IN (SELECT * FROM #DedicatedApartment);
     END
   END
  IF @BookingLevel = 'Bed'
   BEGIN    
    INSERT INTO #AgedGst(Id)  
    SELECT Id FROM WRBHBBedBookingPropertyAssingedGuest 
    WHERE BookingId=@BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
    BedId = @RoomId AND RoomCaptured = @Id1 AND 
    ISNULL(RoomShiftingFlag,0) = 0;
    --    
    CREATE TABLE #BedBookedBed(BedId BIGINT)
    -- Booked Bed Begin      
    INSERT INTO #BedBookedBed(BedId)
    SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.BedId;  
    --   
    INSERT INTO #BedBookedBed(BedId)
    SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.BedId;  
    --   
    INSERT INTO #BedBookedBed(BedId)
    SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.BedId;  
    --   
    INSERT INTO #BedBookedBed(BedId)
    SELECT PG.BedId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND
    PG.Id NOT IN (SELECT Id FROM #AgedGst)
    GROUP BY PG.BedId;  
    -- Booked BED End
    IF @PropertyType1 = 'MGH'
     BEGIN
      INSERT INTO #TMPTABLE1(label,RoomId)
      SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
      CAST(B.BedNO AS VARCHAR) AS label,B.Id AS BedId
      FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId=PB.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
      R.PropertyId=P.Id AND R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
      B.RoomId=R.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND 
      PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
      A.SellableApartmentType != 'HUB' AND A.Status='Active' AND 
      R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active' AND
      B.IsActive=1 AND B.IsDeleted=0 AND P.Category='Managed G H' AND   
      P.Id=@PropertyId1 AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoom) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedRoom) AND
      B.Id NOT IN (SELECT BedId FROM #BedBookedBed) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
      ORDER BY PB.BlockName,A.ApartmentNo,R.RoomNo,B.Id;
     END        
    IF @PropertyType1 = 'InP'  
     BEGIN
      SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
      CAST(B.BedNO AS VARCHAR) AS label,B.Id AS BedId
      FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId=PB.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
      R.PropertyId=P.Id AND R.ApartmentId=A.Id
      LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
      B.RoomId=R.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND 
      PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND 
      A.SellableApartmentType != 'HUB' AND A.Status='Active' AND 
      R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active' AND
      B.IsActive=1 AND B.IsDeleted=0 AND P.Category='Internal Property' AND   
      P.Id=@PropertyId1 AND
      R.Id NOT IN (SELECT RoomId FROM #DedicatedRoom) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartment) AND
      R.Id NOT IN (SELECT RoomId FROM #BookedRoom) AND  
      B.Id NOT IN (SELECT BedId FROM #BedBookedBed) AND
      A.Id NOT IN (SELECT ApartmentId FROM #BookedApartment)
      ORDER BY PB.BlockName,A.ApartmentNo,R.RoomNo,B.Id;
     END
   END
  IF @BookingLevel = 'Apartment'
   BEGIN
    INSERT INTO #AgedGst(Id)  
    SELECT Id FROM WRBHBApartmentBookingPropertyAssingedGuest 
    WHERE BookingId=@BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
    ApartmentId = @RoomId AND RoomCaptured = @Id1 AND 
    ISNULL(RoomShiftingFlag,0) = 0;  
    --
    CREATE TABLE #ApartmentBookedApartment(ApartmentId BIGINT);
    -- Booked Room Begin
    INSERT INTO #ApartmentBookedApartment(ApartmentId)
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --   
    INSERT INTO #ApartmentBookedApartment(ApartmentId)
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --   
    INSERT INTO #ApartmentBookedApartment(ApartmentId)
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --   
    INSERT INTO #ApartmentBookedApartment(ApartmentId)
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst)  GROUP BY PG.ApartmentId;
    -- Booked Room End      
    IF @PropertyType1 = 'DdP'
     BEGIN      
      INSERT INTO #TMPTABLE1(label,RoomId)
      SELECT B.BlockName+' - '+A.ApartmentNo+' - '+A.SellableApartmentType AS label,
      A.Id AS ApartmentId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON B.PropertyId=P.Id 
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON A.BlockId=B.Id
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId=A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND 
      A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND
      A.Status='Active' AND R.IsActive=1 AND R.IsDeleted=0 AND
      R.RoomStatus='Active' AND A.PropertyId = @PropertyId1 AND 
      A.Id IN (SELECT D.ApartmentId FROM WRBHBContractManagement H
      LEFT OUTER JOIN WRBHBContractManagementAppartment D
      WITH(NOLOCK)ON D.ContractId=H.Id
      WHERE H.IsActive=1 AND D.IsDeleted=0 AND D.IsActive=1 AND
      D.IsDeleted=0 AND H.ClientId=(SELECT ClientId FROM WRBHBBooking 
      WHERE Id = @BookingId) AND H.ContractType=' Dedicated Contracts ' AND
      D.PropertyId = @PropertyId1) AND
      A.Id NOT IN (SELECT ApartmentId FROM #ApartmentBookedApartment) AND
      A.Id NOT IN (SELECT ApartmentId FROM WRBHBPropertyRooms
      WHERE Id IN (SELECT RoomId FROM #BookedRoom)) AND
      A.Id NOT IN (SELECT ApartmentId FROM WRBHBPropertyRooms
      WHERE Id IN (SELECT RoomId FROM #BookedBed))
      ORDER BY B.BlockName,A.ApartmentNo;
     END    
    IF @PropertyType1 = 'InP'  
     BEGIN  
      -- Get Property All Rooms   
      INSERT INTO #TMPTABLE1(label,RoomId)
      SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+A.SellableApartmentType AS 
      label,A.Id AS ApartmentId FROM WRBHBProperty P
      LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
      LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
      A.PropertyId=P.Id AND A.BlockId=PB.Id 
      LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.ApartmentId = A.Id
      WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
      PB.IsDeleted=0 AND P.Category='Internal Property' AND 
      A.SellableApartmentType != 'HUB' AND A.IsActive=1 AND A.IsDeleted=0 AND 
      A.Status='Active' AND R.IsActive = 1 AND R.IsDeleted = 0 AND
      R.RoomStatus = 'Active' AND P.Id=@PropertyId1 AND 
      A.RackTariff=(SELECT Tariff FROM WRBHBApartmentBookingProperty
      WHERE BookingId = @BookingId) AND
      A.Id NOT IN (SELECT ApartmentId FROM #ApartmentBookedApartment) AND
      A.Id NOT IN (SELECT ApartmentId FROM WRBHBPropertyRooms
      WHERE Id IN (SELECT RoomId FROM #BookedRoom)) AND
      A.Id NOT IN (SELECT ApartmentId FROM WRBHBPropertyRooms
      WHERE Id IN (SELECT RoomId FROM #BookedBed)) AND
      A.Id NOT IN (SELECT ApartmentId FROM WRBHBPropertyRooms
      WHERE Id IN (SELECT RoomId FROM #DedicatedRoom)) AND
      A.Id NOT IN (SELECT ApartmentId FROM #DedicatedApartment);
     END    
   END
  -- Avaliable rooms
  SET @AvaRoomCnt =(SELECT COUNT(*) FROM #TMPTABLE1 WHERE RoomId = @RoomId);
  IF @AvaRoomCnt = 0
   BEGIN
    SELECT '*  Room Not Avliable' AS RoomSts;
   END
  ELSE
   BEGIN
    SELECT '' AS RoomSts;
   END
 END 
END
