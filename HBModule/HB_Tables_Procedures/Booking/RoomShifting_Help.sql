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
-- Description:	BOOKING
-- =================================================================================
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
  -- Get CheckIn Booking  
  CREATE TABLE #TMP(BookingCode INT,BookingId INT,Guest NVARCHAR(100),  
  RoomId INT,RoomCaptured INT,CurrentStatus NVARCHAR(100),  
  PropertyName NVARCHAR(100),RoomType NVARCHAR(100));  
  INSERT INTO #TMP(BookingCode,BookingId,Guest,RoomId,RoomCaptured,  
  CurrentStatus,PropertyName,RoomType)  
  SELECT B.BookingCode,BG.BookingId,  
  BG.FirstName+' '+BG.LastName AS Guest,BG.RoomId,BG.RoomCaptured,  
  BG.CurrentStatus,BP.PropertyName,BG.RoomType   
  FROM WRBHBBooking B  
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON  
  BP.BookingId=B.Id    
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON   
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId    
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BG.IsActive=1 AND BG.IsDeleted=0 AND  
  BG.CurrentStatus IN ('CheckIn','Booked') AND  
  B.BookingLevel='Room' AND --BP.PropertyType NOT IN ('MMT','CPP') AND  
  BP.PropertyType IN ('InP','MGH','DdP','ExP') AND   
  --BG.RoomId != 0 AND   
  ISNULL(RoomShiftingFlag,0) = 0;-- AND   
  --CONVERT(DATE,BG.ChkOutDt,103) >= CONVERT(DATE,GETDATE(),103);  
  -- Guest Joined in RoomId  
  CREATE TABLE #TMP1(Guest NVARCHAR(100),BookingCode INT,BookingId INT,  
  RoomId INT,RoomCapturedId INT,BookingLevelId NVARCHAR(100),  
  CurrentStatus NVARCHAR(100),PropertyName NVARCHAR(100),RoomType NVARCHAR(100));  
  INSERT INTO #TMP1(Guest,BookingCode,BookingId,RoomId,RoomCapturedId,  
  BookingLevelId,CurrentStatus,PropertyName,RoomType)  
  SELECT STUFF((SELECT ', ' + BA.Guest  
  FROM #TMP BA   
  WHERE BA.BookingId=B.BookingId AND BA.RoomId=B.RoomId AND  
  BA.RoomCaptured=B.RoomCaptured  
  FOR XML PATH('')),1,1,'') AS Guest,B.BookingCode,B.BookingId,  
  B.RoomId,B.RoomCaptured AS RoomCapturedId,'Room' AS BookingLevelId,  
  B.CurrentStatus,B.PropertyName,B.RoomType FROM #TMP AS B   
  GROUP BY B.BookingCode,B.BookingId,B.RoomCaptured,B.RoomId,B.CurrentStatus,  
  B.PropertyName,B.RoomType;  
  -- Get CheckOut Date   
  CREATE TABLE #TMP2(Guest NVARCHAR(100),BookingCode INT,BookingId INT,  
  RoomId INT,RoomCapturedId INT,BookingLevelId NVARCHAR(100),  
  ChkOutDtId NVARCHAR(100),CurrentStatus NVARCHAR(100),  
  PropertyName NVARCHAR(100),RoomType NVARCHAR(100));  
  INSERT INTO #TMP2(Guest,BookingCode,BookingId,RoomId,RoomCapturedId,  
  BookingLevelId,ChkOutDtId,CurrentStatus,PropertyName,RoomType)  
  SELECT T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,CONVERT(VARCHAR(100),B.ChkOutDt,103) AS ChkOutDtId,  
  T.CurrentStatus,T.PropertyName,T.RoomType FROM #TMP1 T  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK)ON  
  B.BookingId=T.BookingId AND B.RoomId=T.RoomId  
  WHERE B.IsActive=1 AND IsDeleted=0 AND B.RoomShiftingFlag=0 AND  
  B.BookingId=T.BookingId AND B.RoomId=T.RoomId AND   
  B.RoomCaptured=T.RoomCapturedId;  
  -- GET  
  SELECT T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,T.ChkOutDtId,T.PropertyName,-- AS PropertyNameId,  
  T.RoomType AS RoomNoId,T.CurrentStatus FROM #TMP2 T    
  GROUP BY T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,T.ChkOutDtId,T.PropertyName,T.RoomType,T.CurrentStatus  
  ORDER BY T.BookingCode,T.RoomCapturedId ASC;  
  --  
  --DROP TABLE #TMP,#TMP1,#TMP2;  
  --  
  SELECT CAST(YEAR(GETDATE()) AS VARCHAR)+'/'+  
  CAST(MONTH(GETDATE()) AS VARCHAR)+'/'+  
  CAST(DAY(GETDATE()) AS VARCHAR) AS ChkInDt,  
  CAST(YEAR(GETDATE()) AS VARCHAR)+'/'+  
  CAST(MONTH(GETDATE()) AS VARCHAR)+'/'+  
  CAST(DAY(GETDATE())+1 AS VARCHAR) AS ChkOutDt;  
 END  
IF @Action = 'DateLoad'  
 BEGIN  
  DECLARE @CurrentStatus NVARCHAR(100) = '',@PtyType NVARCHAR(100) = '';  
  SELECT TOP 1 @PtyType = BP.PropertyType,@CurrentStatus = BG.CurrentStatus   
  FROM WRBHBBookingProperty BP  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId  
  WHERE BG.IsActive = 1 AND BG.IsDeleted = 0 AND BP.IsActive = 1 AND  
  BP.IsDeleted = 0 AND BP.BookingId = @BookingId AND   
  BG.RoomCaptured = @Id1 ORDER BY BG.Id DESC;  
  --  
  DECLARE @DtCnt INT=0,@FromDt DATE,@ToDt DATE,@Dtt DATE;  
  SET @DtCnt=(SELECT COUNT(*) FROM WRBHBBookingPropertyAssingedGuest  
  WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@BookingId AND  
  RoomId=@RoomId AND ISNULL(RoomShiftingFlag,0)=0 AND  
  RoomCaptured=@Id1 AND  
  CONVERT(DATE,GETDATE(),103) BETWEEN  
  CONVERT(DATE,ChkInDt,103) AND CONVERT(DATE,ChkOutDt,103));  
  IF @DtCnt = 0  
   BEGIN  
    SELECT @FromDt=ChkInDt,@ToDt=ChkOutDt,@Dtt=ChkInDt   
    FROM WRBHBBookingPropertyAssingedGuest  
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@BookingId AND  
    RoomId=@RoomId AND ISNULL(RoomShiftingFlag,0)=0 AND RoomCaptured=@Id1;  
   END  
  ELSE  
   BEGIN  
    SELECT @FromDt=CONVERT(DATE,GETDATE(),103),@ToDt=ChkOutDt,@Dtt=ChkInDt   
    FROM WRBHBBookingPropertyAssingedGuest  
    WHERE IsActive=1 AND IsDeleted=0 AND BookingId=@BookingId AND  
    RoomId=@RoomId AND ISNULL(RoomShiftingFlag,0)=0 AND RoomCaptured=@Id1;  
   END  
  IF @PtyType NOT IN ('InP','MGH','DdP') AND @CurrentStatus NOT IN ('CheckIn')  
   BEGIN  
    SELECT CAST(YEAR(@FromDt) AS VARCHAR)+'/'+CAST(MONTH(@FromDt) AS VARCHAR)  
    +'/'+CAST(DAY(@FromDt) AS VARCHAR) AS ChkInRangeStart,  
    CAST(YEAR(@ToDt) AS VARCHAR)+'/'+CAST(MONTH(@ToDt) AS VARCHAR)+'/'+  
    CAST(DAY(@ToDt) AS VARCHAR) AS ChkInRangeEnd,  
    CAST(YEAR(@FromDt) AS VARCHAR)+'/'+CAST(MONTH(@FromDt) AS VARCHAR)  
    +'/'+CAST(DAY(@FromDt)+1 AS VARCHAR) AS ChkOutRangeStart,  
    CAST(YEAR(@Dtt) AS VARCHAR)+'/'+CAST(MONTH(@Dtt) AS VARCHAR)  
    +'/'+CAST(DAY(@Dtt) AS VARCHAR) AS ChkInRangeStart1;  
   END  
  ELSE  
   BEGIN  
    SELECT CAST(YEAR(DATEADD(DAY,-1,@FromDt)) AS VARCHAR)+'/'+  
    CAST(MONTH(DATEADD(DAY,-1,@FromDt)) AS VARCHAR)+'/'+  
    CAST(DAY(DATEADD(DAY,-1,@FromDt)) AS VARCHAR) AS ChkInRangeStart,  
    CAST(YEAR(@ToDt) AS VARCHAR)+'/'+  
    CAST(MONTH(@ToDt) AS VARCHAR)+'/'+  
    CAST(DAY(@ToDt) AS VARCHAR) AS ChkInRangeEnd,  
    CAST(YEAR(@FromDt) AS VARCHAR)+'/'+  
    CAST(MONTH(@FromDt) AS VARCHAR)+'/'+  
    CAST(DAY(@FromDt) AS VARCHAR) AS ChkOutRangeStart,  
    CAST(YEAR(@Dtt) AS VARCHAR)+'/'+  
    CAST(MONTH(@Dtt) AS VARCHAR)+'/'+  
    CAST(DAY(@Dtt) AS VARCHAR) AS ChkInRangeStart1;  
   END  
  --  
  SELECT TOP 1 BP.PropertyType,BG.TariffPaymentMode,  
  BG.ServicePaymentMode FROM WRBHBBookingProperty BP  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId=BP.BookingId AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId  
  WHERE BG.IsActive=1 AND BG.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BP.BookingId=@BookingId AND   
  BG.RoomCaptured = @Id1  
  GROUP BY BP.PropertyType,BG.TariffPaymentMode,BG.ServicePaymentMode;  
  --  
  DECLARE @BTC BIT=0;  
  CREATE TABLE #PAYMENT(label NVARCHAR(100));  
  SET @BTC=(SELECT ISNULL(BTC,0) FROM WRBHBClientManagement  
  WHERE Id=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId));  
  IF @BTC = 1  
   BEGIN  
    INSERT INTO #PAYMENT(label) SELECT 'Bill to Company (BTC)';  
    INSERT INTO #PAYMENT(label) SELECT 'Direct';  
   END  
  ELSE  
   BEGIN  
    INSERT INTO #PAYMENT(label) SELECT 'Direct';  
   END  
  --  
  SELECT * FROM #PAYMENT;    
 END  
IF @Action = 'AvaliableRooms'  
 BEGIN  
  -- Get Type & Property Type & Property Id  
 DECLARE @GetType NVARCHAR(100),@PropertyType NVARCHAR(100),@PropertyId INT;  
  SELECT TOP 1 @GetType=GetType,@PropertyType=PropertyType,  
  @PropertyId=PropertyId FROM WRBHBBookingProperty   
  WHERE Id = (SELECT BookingPropertyTableId  
  FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@BookingId  
  GROUP BY BookingPropertyTableId);  
  --  
  CREATE TABLE #TMPTABLE(label NVARCHAR(100),RoomId BIGINT);  
  --  
/*  -- Get Check In Date & Check Out Date  
  DECLARE @ChkInDt NVARCHAR(100),@ChkOutDt NVARCHAR(100);  
  SELECT TOP 1 @ChkInDt=(CAST(ChkInDt AS VARCHAR)+' '+  
  CAST(ExpectChkInTime+' '+AMPM AS VARCHAR)),  
  @ChkOutDt=CAST(ChkOutDt AS VARCHAR)+' '+'11:59:00 AM'  
  FROM WRBHBBookingPropertyAssingedGuest  
  WHERE BookingId=@BookingId AND RoomId=@RoomId AND RoomShiftingFlag=0;*/  
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
    --   
    INSERT INTO #ExistingManagedGHProperty1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
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
    -- Booked Room End  
    -- Avaliable Rooms  
    INSERT INTO #TMPTABLE(label,RoomId)  
    SELECT B.BlockName+' - '+R.RoomNo AS label,R.Id AS RoomId       
    FROM WRBHBProperty P  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON  
    B.PropertyId=P.Id  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON   
    R.BlockId=B.Id AND R.PropertyId=P.Id   
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND   
    B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND   
    P.Id=@PropertyId AND P.Category='Managed G H' AND  
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
    --   
    INSERT INTO #ExistingDedicatedProperty1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
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
    -- Booked Room End  
    -- Booked Apartment Begin  
    INSERT INTO #ExDdPApartmnt1(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;  
    --  
    INSERT INTO #ExDdPApartmnt1(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.ApartmentId;  
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
    -- Booked Apartment End  
    -- Avaliable Rooms  
    CREATE TABLE #DdP(label NVARCHAR(100),RoomId BIGINT);  
    INSERT INTO #DdP(label,RoomId)  
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,  
    R.Id AS RoomId FROM WRBHBContractManagementTariffAppartment D  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON  
    R.PropertyId=D.PropertyId AND R.Id=D.RoomId      
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON   
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId  
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND   
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND   
    A.IsActive=1 AND A.IsDeleted=0 AND   
    A.SellableApartmentType != 'HUB' AND  
    A.Status='Active' AND R.RoomStatus='Active' AND  
    D.PropertyId=@PropertyId AND  
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND  
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1)   
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;  
    --  
    INSERT INTO #DdP(label,RoomId)  
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,  
    R.Id AS RoomId FROM WRBHBContractManagementAppartment D  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON  
    R.PropertyId=D.PropertyId  
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId AND  
    A.Id=D.ApartmentId  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON   
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId  
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND   
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND   
    A.IsActive=1 AND A.IsDeleted=0 AND   
    A.SellableApartmentType != 'HUB' AND  
    A.Status='Active' AND R.RoomStatus='Active' AND  
    D.PropertyId=@PropertyId AND  
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty1) AND  
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt1)   
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;  
    --  
    INSERT INTO #TMPTABLE(label,RoomId)  
    SELECT label,RoomId FROM #DdP   
    GROUP BY label,RoomId ORDER BY RoomId;  
   END    
  IF @PropertyType = 'InP'  
   BEGIN  
    -- Get Property All Rooms   
    CREATE TABLE #Tmp_InternalRoom(label NVARCHAR(100),RoomId BIGINT);  
    INSERT INTO #Tmp_InternalRoom(label,RoomId)  
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
    P.Id=@PropertyId;  
-- Property Booked Rooms Begin  
    CREATE TABLE #BookedRoomsInP(RoomId BIGINT);  
    -- Dedicated Rooms  
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT RoomId FROM WRBHBContractManagementTariffAppartment  
    WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND  
    PropertyId=@PropertyId;  
    -- Dedicated Apartment  
    INSERT INTO #BookedRoomsInP(RoomId)    
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBContractManagementAppartment T   
    WITH(NOLOCK)ON T.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND T.IsActive=1 AND   
    T.IsDeleted=0 AND T.ApartmentId != 0 AND   
    R.ApartmentId=T.ApartmentId AND T.PropertyId=@PropertyId;  
    -- Booked Rooms Begin  
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --  
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId  
    GROUP BY PG.RoomId;  
    -- Booked Rooms End  
    -- Booked Beds Begin  
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --  
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId  
    GROUP BY PG.RoomId;  
    -- Booked Beds End  
    -- Booked Apartment Begin  
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG  
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND  
    PG.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND   
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY R.Id;      
    --  
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG  
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND  
    PG.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND   
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId GROUP BY R.Id;      
    --  
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
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
    --   
    INSERT INTO #BookedRoomsInP(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
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
    --  
    --select * from #BookedRoomsInP;  
    --select * from #Tmp_InternalRoom;return;  
    INSERT INTO #TMPTABLE(label,RoomId)  
    SELECT label,RoomId FROM #Tmp_InternalRoom  
    WHERE RoomId NOT IN (SELECT RoomId FROM #BookedRoomsInP);  
   END  
  -- Avaliable rooms  
  SELECT label,RoomId FROM #TMPTABLE;  
 END  
IF @Action = 'AvaliableFromRoom'  
 BEGIN  
  -- Get Type & Property Type & Property Id  
  DECLARE @GetType1 NVARCHAR(100),@PropertyType1 NVARCHAR(100),@PropertyId1 INT;  
  SELECT TOP 1 @GetType1=GetType,@PropertyType1=PropertyType,  
  @PropertyId1=PropertyId FROM WRBHBBookingProperty   
  WHERE Id = (SELECT BookingPropertyTableId  
  FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@BookingId  
  GROUP BY BookingPropertyTableId);  
  --  
  CREATE TABLE #AgedGst(Id BIGINT);  
  INSERT INTO #AgedGst(Id)  
  SELECT Id FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId=@BookingId AND  
  RoomId=@RoomId AND RoomCaptured=@Id1 AND ISNULL(RoomShiftingFlag,0)=0;  
  --  
  CREATE TABLE #TMPTABLE1(label NVARCHAR(100),RoomId BIGINT);  
  --  
/*  -- Get Check In Date & Check Out Date  
  DECLARE @ChkInDt NVARCHAR(100),@ChkOutDt NVARCHAR(100);  
  SELECT TOP 1 @ChkInDt=(CAST(ChkInDt AS VARCHAR)+' '+  
  CAST(ExpectChkInTime+' '+AMPM AS VARCHAR)),  
  @ChkOutDt=CAST(ChkOutDt AS VARCHAR)+' '+'11:59:00 AM'  
  FROM WRBHBBookingPropertyAssingedGuest  
  WHERE BookingId=@BookingId AND RoomId=@RoomId AND RoomShiftingFlag=0;*/  
  IF @PropertyType1 = 'MGH'  
   BEGIN  
    CREATE TABLE #ExistingManagedGHProperty12(RoomId BIGINT);  
    -- Booked Room Begin  
    INSERT INTO #ExistingManagedGHProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingManagedGHProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingManagedGHProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingManagedGHProperty12(RoomId)  
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst)  
    GROUP BY PG.RoomId;  
    -- Booked Room End  
    -- Avaliable Rooms  
    INSERT INTO #TMPTABLE1(label,RoomId)  
    SELECT B.BlockName+' - '+R.RoomNo AS label,R.Id AS RoomId       
    FROM WRBHBProperty P  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON  
    B.PropertyId=P.Id  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON   
    R.BlockId=B.Id AND R.PropertyId=P.Id   
    WHERE P.IsActive=1 AND P.IsDeleted=0 AND B.IsActive=1 AND   
    B.IsDeleted=0 AND R.IsActive=1 AND R.IsDeleted=0 AND   
    P.Id=@PropertyId1 AND P.Category='Managed G H' AND  
    R.Id NOT IN (SELECT RoomId FROM #ExistingManagedGHProperty12);  
   END  
  IF @PropertyType1 = 'DdP'  
   BEGIN   
    CREATE TABLE #ExDdPApartmnt12(ApartmentId BIGINT);  
    CREATE TABLE #ExistingDedicatedProperty12(RoomId BIGINT);  
    -- Booked Room Begin  
    INSERT INTO #ExistingDedicatedProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingDedicatedProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingDedicatedProperty12(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #ExistingDedicatedProperty12(RoomId)  
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst)  
    GROUP BY PG.RoomId;  
    -- Booked Room End  
    -- Booked Apartment Begin  
    INSERT INTO #ExDdPApartmnt12(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --  
    INSERT INTO #ExDdPApartmnt12(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --  
    INSERT INTO #ExDdPApartmnt12(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND  
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.ApartmentId;  
    --   
    INSERT INTO #ExDdPApartmnt12(ApartmentId)   
    SELECT PG.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1  
    GROUP BY PG.ApartmentId;  
    -- Booked Apartment End  
    -- Avaliable Rooms  
    CREATE TABLE #DdP1(label NVARCHAR(100),RoomId BIGINT);  
    INSERT INTO #DdP1(label,RoomId)  
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,  
    R.Id AS RoomId FROM WRBHBContractManagementTariffAppartment D  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON  
    R.PropertyId=D.PropertyId AND R.Id=D.RoomId      
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON   
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId  
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND   
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND   
    A.IsActive=1 AND A.IsDeleted=0 AND   
    A.SellableApartmentType != 'HUB' AND  
    A.Status='Active' AND R.RoomStatus='Active' AND  
    D.PropertyId=@PropertyId1 AND  
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty12) AND  
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt12)   
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;  
    --  
    INSERT INTO #DdP1(label,RoomId)  
    SELECT B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo AS label,  
    R.Id AS RoomId FROM WRBHBContractManagementAppartment D  
    LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON  
    R.PropertyId=D.PropertyId  
    LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
    A.PropertyId=D.PropertyId AND A.Id=R.ApartmentId AND  
    A.Id=D.ApartmentId  
    LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON   
    B.PropertyId=D.PropertyId AND B.Id=A.BlockId  
    WHERE D.IsDeleted=0 AND D.IsActive=1 AND R.IsDeleted=0 AND   
    R.IsActive=1 AND B.IsDeleted=0 AND B.IsActive=1 AND   
    A.IsActive=1 AND A.IsDeleted=0 AND   
    A.SellableApartmentType != 'HUB' AND  
    A.Status='Active' AND R.RoomStatus='Active' AND  
    D.PropertyId=@PropertyId1 AND  
    R.Id NOT IN (SELECT RoomId FROM #ExistingDedicatedProperty12) AND  
    A.Id NOT IN (SELECT ApartmentId FROM #ExDdPApartmnt12)   
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo;  
    --  
    INSERT INTO #TMPTABLE1(label,RoomId)  
    SELECT label,RoomId FROM #DdP1   
    GROUP BY label,RoomId ORDER BY RoomId;  
   END    
  IF @PropertyType1 = 'InP'  
   BEGIN  
    -- Get Property All Rooms   
    CREATE TABLE #Tmp_InternalRoom1(label NVARCHAR(100),RoomId BIGINT);  
    INSERT INTO #Tmp_InternalRoom1(label,RoomId)  
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
    P.Id=@PropertyId1;  
-- Property Booked Rooms Begin  
    CREATE TABLE #BookedRoomsInP1(RoomId BIGINT);  
    -- Dedicated Rooms  
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT RoomId FROM WRBHBContractManagementTariffAppartment  
    WHERE IsActive=1 AND IsDeleted=0 AND RoomId != 0 AND  
    PropertyId=@PropertyId1;  
    -- Dedicated Apartment  
    INSERT INTO #BookedRoomsInP1(RoomId)    
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBContractManagementAppartment T   
    WITH(NOLOCK)ON T.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND T.IsActive=1 AND   
    T.IsDeleted=0 AND T.ApartmentId != 0 AND   
    R.ApartmentId=T.ApartmentId AND T.PropertyId=@PropertyId1;  
    -- Booked Rooms Begin  
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --  
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT PG.RoomId FROM WRBHBBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1 AND  
    PG.Id NOT IN (SELECT Id FROM #AgedGst)  
    GROUP BY PG.RoomId;  
    -- Booked Rooms End  
    -- Booked Beds Begin  
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --  
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP1(RoomId)   
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY PG.RoomId;  
    --   
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT PG.RoomId FROM WRBHBBedBookingPropertyAssingedGuest PG  
    WHERE PG.IsActive=1 AND PG.IsDeleted=0 AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1  
    GROUP BY PG.RoomId;  
    -- Booked Beds End  
    -- Booked Apartment Begin  
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG  
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND  
    PG.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND   
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY R.Id;      
    --  
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG  
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND  
    PG.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND   
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND   
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) BETWEEN   
    CAST(@ChkInDt AS DATETIME) AND CAST(@ChkOutDt AS DATETIME) AND  
    PG.BookingPropertyId=@PropertyId1 GROUP BY R.Id;      
    --  
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
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
    PG.BookingPropertyId=@PropertyId1 GROUP BY R.Id;  
    --   
    INSERT INTO #BookedRoomsInP1(RoomId)  
    SELECT R.Id FROM WRBHBPropertyRooms R  
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest PG  
    WITH(NOLOCK)ON PG.BookingPropertyId=R.PropertyId AND  
    PG.ApartmentId=R.ApartmentId  
    WHERE R.IsActive=1 AND R.IsDeleted=0 AND PG.IsActive=1 AND   
    PG.IsDeleted=0 AND R.ApartmentId=PG.ApartmentId AND   
    CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+  
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME) <=   
    CAST(@ChkInDt AS DATETIME) AND  
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME) >=  
    CAST(@ChkOutDt AS DATETIME) AND PG.BookingPropertyId=@PropertyId1  
    GROUP BY R.Id;  
    --  
    --select * from #BookedRoomsInP;  
    --select * from #Tmp_InternalRoom;return;  
    INSERT INTO #TMPTABLE1(label,RoomId)  
    SELECT label,RoomId FROM #Tmp_InternalRoom1  
    WHERE RoomId NOT IN (SELECT RoomId FROM #BookedRoomsInP1);  
   END  
  -- Avaliable rooms  
  DECLARE @AvaRoomCnt INT;  
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
  
--drop table #TMP;  
/*IF @Action = 'BookingLoad'  
 BEGIN  
  -- Get CheckIn Booking  
  CREATE TABLE #TMP(BookingCode INT,BookingId INT,Guest NVARCHAR(100),  
  RoomId INT,RoomCaptured INT,CurrentStatus NVARCHAR(100));  
  INSERT INTO #TMP(BookingCode,BookingId,Guest,RoomId,RoomCaptured,  
  CurrentStatus)  
  SELECT B.BookingCode,BG.BookingId,  
  BG.FirstName+' '+BG.LastName AS Guest,BG.RoomId,BG.RoomCaptured,  
  BG.CurrentStatus   
  FROM WRBHBBooking B  
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON  
  BP.BookingId=B.Id    
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON   
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id AND  
  BG.BookingPropertyId=BP.PropertyId    
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BP.IsActive=1 AND  
  BP.IsDeleted=0 AND BG.IsActive=1 AND BG.IsDeleted=0 AND  
  BG.CurrentStatus IN ('CheckIn','Booked') AND  
  B.BookingLevel='Room' AND BP.PropertyType != 'MMT' AND   
  --BG.RoomId != 0 AND   
  ISNULL(RoomShiftingFlag,0) = 0 AND   
  CONVERT(DATE,BG.ChkOutDt,103) >= CONVERT(DATE,GETDATE(),103);  
  -- Guest Joined in RoomId  
  CREATE TABLE #TMP1(Guest NVARCHAR(100),BookingCode INT,BookingId INT,  
  RoomId INT,RoomCapturedId INT,BookingLevelId NVARCHAR(100),  
  CurrentStatus NVARCHAR(100));  
  INSERT INTO #TMP1(Guest,BookingCode,BookingId,RoomId,RoomCapturedId,  
  BookingLevelId,CurrentStatus)  
  SELECT STUFF((SELECT ', ' + BA.Guest  
  FROM #TMP BA   
  WHERE BA.BookingId=B.BookingId AND BA.RoomId=B.RoomId AND  
  BA.RoomCaptured=B.RoomCaptured  
  FOR XML PATH('')),1,1,'') AS Guest,B.BookingCode,B.BookingId,  
  B.RoomId,B.RoomCaptured AS RoomCapturedId,'Room' AS BookingLevelId,  
  B.CurrentStatus FROM #TMP AS B   
  GROUP BY B.BookingCode,B.BookingId,B.RoomCaptured,B.RoomId,B.CurrentStatus;  
  -- Get CheckOut Date   
  CREATE TABLE #TMP2(Guest NVARCHAR(100),BookingCode INT,BookingId INT,  
  RoomId INT,RoomCapturedId INT,BookingLevelId NVARCHAR(100),  
  ChkOutDtId NVARCHAR(100),CurrentStatus NVARCHAR(100));  
  INSERT INTO #TMP2(Guest,BookingCode,BookingId,RoomId,RoomCapturedId,  
  BookingLevelId,ChkOutDtId,CurrentStatus)  
  SELECT T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,CONVERT(VARCHAR(100),B.ChkOutDt,103) AS ChkOutDtId,  
  T.CurrentStatus FROM #TMP1 T  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK)ON  
  B.BookingId=T.BookingId AND B.RoomId=T.RoomId  
  WHERE B.IsActive=1 AND IsDeleted=0 AND B.RoomShiftingFlag=0 AND  
  B.BookingId=T.BookingId AND B.RoomId=T.RoomId AND   
  B.RoomCaptured=T.RoomCapturedId;  
  -- GET  
  SELECT T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,T.ChkOutDtId,P.PropertyName AS PropertyNameId,  
  B.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+R.RoomType   
  AS RoomNoId,T.CurrentStatus FROM #TMP2 T  
  LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON R.Id=T.RoomId  
  JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON   
  A.Id=R.ApartmentId  
  LEFT OUTER JOIN WRBHBPropertyBlocks B WITH(NOLOCK)ON   
  B.Id=R.BlockId  
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON  
  P.Id=R.PropertyId  
  WHERE R.Id=T.RoomId  
  GROUP BY T.Guest,T.BookingCode,T.BookingId,T.RoomId,T.RoomCapturedId,  
  T.BookingLevelId,T.ChkOutDtId,P.PropertyName,B.BlockName,A.ApartmentNo,  
  R.RoomNo,R.RoomType,T.CurrentStatus  
  ORDER BY T.BookingCode ASC;  
  --  
  DROP TABLE #TMP,#TMP1,#TMP2;  
  --  
  SELECT CAST(YEAR(GETDATE()) AS VARCHAR)+'/'+  
  CAST(MONTH(GETDATE()) AS VARCHAR)+'/'+  
  CAST(DAY(GETDATE()) AS VARCHAR) AS ChkInDt,  
  CAST(YEAR(GETDATE()) AS VARCHAR)+'/'+  
  CAST(MONTH(GETDATE()) AS VARCHAR)+'/'+  
  CAST(DAY(GETDATE())+1 AS VARCHAR) AS ChkOutDt;  
 END*/  
