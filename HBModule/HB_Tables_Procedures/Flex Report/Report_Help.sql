-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Report_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Report_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:o2-06-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Report Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Report_Help](
@Action NVARCHAR(100),
@Pram1	 BIGINT,
@Pram2	 BIGINT,
@Pram3	 NVARCHAR(100),
@Pram4	 NVARCHAR(100),
@UserId  BIGINT)			
AS
BEGIN
IF @Action ='Property'  
 BEGIN 
    CREATE TABLE #NDD(RoomId BIGINT,PropertyId BIGINT)
    CREATE TABLE #Property(PropertyName NVARCHAR(100),ZId BIGINT,PropertyType NVARCHAR(100))   
	INSERT INTO #NDD(RoomId,PropertyId)  
    SELECT 0,CA.PropertyId FROM dbo.WRBHBContractManagementAppartment CA      
    JOIN dbo.WRBHBContractManagement C ON C.Id=CA.ContractId AND 
    LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
    AND C.IsActive=1 AND C.IsDeleted=0
    WHERE CA.IsActive=1 AND CA.IsDeleted=0  
       
    INSERT INTO #NDD(RoomId,PropertyId)     
    SELECT CR.RoomId,CR.PropertyId FROM dbo.WRBHBContractManagementTariffAppartment CR  
    JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId AND 
    LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
    AND C.IsActive=1 AND C.IsDeleted=0  
    WHERE  CR.IsActive=1 AND CR.IsDeleted=0  
    
   INSERT INTO #Property (PropertyName,ZId,PropertyType) 
   SELECT  PropertyName,Id ZId,Category PropertyType FROM dbo.WRBHBProperty   
   WHERE IsActive=1 AND IsDeleted=0 AND Category in('Internal Property') ; 
   
   INSERT INTO #Property (PropertyName,ZId,PropertyType) 
   SELECT  PropertyName,Id ZId,Category PropertyType FROM dbo.WRBHBProperty   
   WHERE IsActive=1 AND IsDeleted=0 AND Category in('Managed G H') AND
   Id IN(SELECT PropertyId FROM #NDD)  
   
  SELECT PropertyName,ZId,PropertyType FROM #Property
     
 END   
 IF @Action ='OccupancyChart'  
 BEGIN  
   CREATE TABLE #BookingRoom(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #BookingBed(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #BookingApartment(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #BookingCountRoom(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))   
     
   CREATE TABLE #BookingCountBed(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))   
     
   CREATE TABLE #BookingCountApartment(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),BookingLevel NVARCHAR(100),  
   GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))   
     
   CREATE TABLE #CheckIn(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   BookingLevel NVARCHAR(100),GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),
   RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #Occupancy(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   BookingLevel NVARCHAR(100),GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),
   RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #OccupancySplit(Id BIGINT,BookingId NVARCHAR(2000),BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   BookingLevel NVARCHAR(100),DT NVARCHAR(100),ClientName NVARCHAR(100),BookingCode NVARCHAR(100),  
   RoomType NVARCHAR(100),GuestCount BIGINT,CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,
   BStatus NVARCHAR(100))  
     
   CREATE TABLE #OccupancyFinal(Id BIGINT,BookingId BIGINT,RoomId BIGINT,BedId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ClientName NVARCHAR(100),BookingCode NVARCHAR(100),  
   Split BIT,UBookingId BIGINT,URoomId BIGINT,GuestCount BIGINT,CheckInTime NVARCHAR(100),
   TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #OccupancyFinalCount1(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),GuestCount BIGINT,  
   RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ClientName NVARCHAR(100),BookingCode NVARCHAR(100),  
   DT NVARCHAR(100),CheckInTime NVARCHAR(100),TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #OccupancyFinalCount2(Id BIGINT,BookingId BIGINT,BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ClientName NVARCHAR(100),BookingCode NVARCHAR(100),
   GuestCount BIGINT,RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #OccupancyFinalCountFinal(Id BIGINT,BookingId NVARCHAR(2000),BedId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),  
   CheckInDt NVARCHAR(2000),CheckOutDt NVARCHAR(2000),Type NVARCHAR(100),Occupancy NVARCHAR(100),  
   RoomType NVARCHAR(2000),BookingLevel NVARCHAR(2000),ClientName NVARCHAR(200),BookingCode NVARCHAR(2000),  
   DiffCheckInDt NVARCHAR(200),DiffCheckOutDt NVARCHAR(200),GuestCount BIGINT,CheckInTime NVARCHAR(100),
   TimeType NVARCHAR(100),RoomShiftFlage BIT,BStatus NVARCHAR(100))  
     
   CREATE TABLE #NDDCount(RoomId BIGINT,PropertyId BIGINT)  
     
   CREATE TABLE #BookingCount(BookingId BIGINT,RoomId BIGINT,GuestCount BIGINT,BookingLevel NVARCHAR(2000))  
     
   CREATE TABLE #OccupancyData(Data NVARCHAR(100))  
     
   CREATE TABLE #ApartmentBookingId(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(100),GuestCount BIGINT)  
     
   CREATE TABLE #ApartmentBookingIdCount(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(100),GuestCount BIGINT)  
     
   CREATE TABLE #ApartmentGuestName(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(2000),GuestCount BIGINT)  
     
   CREATE TABLE #DateSplit(DT NVARCHAR(100))  
     
   CREATE TABLE #DateROOM(DT NVARCHAR(100),RoomId BIGINT,RoomType NVARCHAR(100),CheckOutDate NVARCHAR(100),CurrentOutDate NVARCHAR(100))  
     
   CREATE TABLE #DateROOMS(DT NVARCHAR(100),RoomId BIGINT,RoomType NVARCHAR(100),CheckOutDate NVARCHAR(100),CurrentOutDate NVARCHAR(100))  
     
   CREATE TABLE #DateROOMS1(DT NVARCHAR(100),RoomId BIGINT,RoomType NVARCHAR(100),CheckOutDate NVARCHAR(100),CurrentOutDate NVARCHAR(100))  
     
   DECLARE @PropertyType NVARCHAR(100);   
     
   SELECT @PropertyType=Category FROM WRBHBProperty WHERE Id=@Pram2  
   --IF  @PropertyType='Internal Property'  
   --BEGIN  
    
    --GET DATA FROM BOOKING ROOM LEVEL  
    INSERT INTO #BookingRoom(Id,BookingId,RoomId,BedId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,RoomId,0,G.RoomType,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,
    CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND   
    --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    --AND CONVERT(DATE,@Pram4,103) --  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,CurrentStatus    
      
      
    INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    --AND CONVERT(DATE,@Pram4,103) AND   
    AND CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND  
    BookingPropertyId=@Pram2   
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.BookingCode!='0'  
    AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId AND CONVERT(date,BR.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BR.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))   
   -- AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,G.CurrentStatus   
      
    INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    AND CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103) AND    
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
   AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId AND CONVERT(date,BR.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BR.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))     
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
      
    INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    AND CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103) AND    
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
   AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId AND CONVERT(date,BR.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BR.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))    
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
     
    
    --GET DATA FROM BOOKING BED LEVEL  
    INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus        
    FROM WRBHBBooking B     
    JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND   
    --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    --AND CONVERT(DATE,@Pram4,103) --  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.BookingCode!='0'   
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
      
    INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
    --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    --AND CONVERT(DATE,@Pram4,103) AND   
    CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0   AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
   AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId AND CONVERT(date,BB.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BB.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103)) 
   
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
      
    INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,BedId,RoomId,BedType,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId   
    AND CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)AND  
    --AND CONVERT(DATE,@Pram4,103)    
    CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103)AND  
    --AND CONVERT(DATE,@Pram4,103)   
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0 AND ISNULL(G.CurrentStatus,'') !='Canceled'  
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.BookingCode!='0'  
   AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId AND CONVERT(date,BB.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BB.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))  
   -- AND G.BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO   
    --WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,BedId,RoomId,BedType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,   
    G.CurrentStatus
    
      
    INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,  
    CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId   
    AND CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)AND  
    --AND CONVERT(DATE,@Pram4,103)    
    CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103)AND  
    --AND CONVERT(DATE,@Pram4,103)   
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0 AND ISNULL(G.CurrentStatus,'') !='Canceled'  
    JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
    AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
    AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId AND CONVERT(date,BB.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
   AND CONVERT(date,BB.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))  
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM ,
    G.CurrentStatus  
      
      
      
    --GET DATA FROM BOOKING APARTMENT LEVEL  
    INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
    AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND      
    --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    --AND CONVERT(DATE,@Pram4,103) --  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
    AND A.IsActive=1 AND B.IsDeleted=0  
    JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' AND B.BookingCode!='0'  
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
      
    INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
    --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND      
    CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
    AND CONVERT(DATE,@Pram4,103) AND  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
    AND A.IsActive=1 AND B.IsDeleted=0  
    JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
    AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id AND CONVERT(date,BA.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
    AND CONVERT(date,BA.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))  
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
    G.CurrentStatus   
      
    INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus   
    FROM WRBHBBooking B     
    JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   
    AND CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103) AND  
    -- AND CONVERT(DATE,@Pram4,103) AND      
    CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103) AND  
    --AND CONVERT(DATE,@Pram4,103) AND  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
    AND A.IsActive=1 AND B.IsDeleted=0  
    JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
    AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id AND CONVERT(date,BA.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
    AND CONVERT(date,BA.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))    
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,G.CurrentStatus   
      
    INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
    SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
    CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus    
    FROM WRBHBBooking B     
    JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId   
    AND CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103) AND  
    -- AND CONVERT(DATE,@Pram4,103) AND      
    CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103) AND  
    --AND CONVERT(DATE,@Pram4,103) AND  
    BookingPropertyId=@Pram2  
    AND G.IsActive=1 AND G.IsDeleted=0  AND ISNULL(G.CurrentStatus,'') !='Canceled'
    JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
    AND A.IsActive=1 AND B.IsDeleted=0  
    JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'  
    WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND B.BookingCode!='0' 
    AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id AND CONVERT(date,BA.CheckInDt,103)=CONVERT(date,G.ChkInDt,103) 
    AND CONVERT(date,BA.CheckOutDt,103)=CONVERT(date,G.ChkOutDt,103))  
    --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
    GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,G.CurrentStatus  
    
   
   --END  
   --ELSE  
   --BEGIN  
   ------------Managed GH  
   ----GET DATA FROM BOOKING ROOM LEVEL  
   -- INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus    
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND   
   -- --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) --  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
      
   -- INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND  
   -- BookingPropertyId=@Pram2   
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId)  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
      
   -- --INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- --Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- AND CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103)  
   -- -- AND CONVERT(DATE,@Pram4,103) AND  
   -- AND BookingPropertyId=@Pram2   
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId)  
   ---- AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.RoomId=G.RoomId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.CurrentStatus,G.AMPM   
      
      
   -- INSERT INTO #BookingRoom(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,RoomId,G.RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,G.Occupancy,'Room',1,G.ExpectChkInTime,G.AMPM,  
   -- G.CurrentStatus   
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- AND CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103)  
   -- -- AND CONVERT(DATE,@Pram4,103) AND  
   -- AND BookingPropertyId=@Pram2   
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingRoom BR WHERE BR.RoomId=G.RoomId)  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,G.ExpectChkInTime,G.AMPM,G.CurrentStatus    
    
   -- --GET DATA FROM BOOKING BED LEVEL  
   -- INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND   
   -- --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) --  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   ---- AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus
        
          
   -- INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0   
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId)  
   ---- AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
      
   -- INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103)  
   -- AND BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0   
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId)  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
      
   -- INSERT INTO #BookingBed(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Single','Bed',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103)  
   -- AND BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0   
   -- JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
   -- AND G.BookingPropertyId=R.PropertyId --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingBed BB WHERE BB.BedId=G.BedId)  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.BedId=G.BedId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,BedId,RoomId,RoomNo,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,G.CurrentStatus    
      
   -- --GET DATA FROM BOOKING APARTMENT LEVEL  
   -- INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   -- AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND      
   -- --CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) --  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
   -- AND A.IsActive=1 AND B.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,G.CurrentStatus    
      
      
   -- INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- --AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- -- AND CONVERT(DATE,@Pram4,103) AND      
   -- CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   -- AND CONVERT(DATE,@Pram4,103) AND  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
   -- AND A.IsActive=1 AND B.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id )  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus    
      
   -- INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus     
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103) AND  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
   -- AND A.IsActive=1 AND B.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id )  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM ,
   -- G.CurrentStatus   
      
   -- INSERT INTO #BookingApartment(Id,BookingId,BedId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
   -- Type,Occupancy,BookingLevel,GuestCount,CheckInTime,TimeType,BStatus)   
   -- SELECT G.Id,BookingId,0,R.Id,RoomType,FirstName,CAST(CAST(G.ChkInDt AS NVARCHAR)+' '+G.ExpectChkInTime+' '+G.AMPM as DATETIME) ChkInDt,  
   -- CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,CurrentStatus,'Double','Apartment',1,G.ExpectChkInTime,G.AMPM ,
   -- G.CurrentStatus    
   -- FROM WRBHBBooking B     
   -- JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId AND  
   -- CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)  
   -- --AND CONVERT(DATE,@Pram4,103) AND   
   -- AND CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103) AND  
   -- BookingPropertyId=@Pram2  
   -- AND G.IsActive=1 AND G.IsDeleted=0  
   -- JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
   -- AND A.IsActive=1 AND B.IsDeleted=0  
   -- JOIN WRBHBPropertyRooms R ON R.ApartmentId=G.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 --AND R.RoomStatus='Active'  
   -- WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   -- AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment BA WHERE BA.RoomId=R.Id)  
   -- --AND BookingId NOT IN(SELECT BookingId FROM WRBHBChechkOutHdr CO WHERE CO.ApartmentId=G.ApartmentId AND CO.IsActive=1 AND CO.IsDeleted=0)  
   -- GROUP BY G.Id,BookingId,R.Id,RoomType,FirstName,ChkInDt,ChkOutDt,G.ExpectChkInTime,G.AMPM,
   -- G.CurrentStatus       
     
   --END  
      
    --Booking Guest Count ROOM LEVEL  
    INSERT INTO #BookingCount(BookingId,RoomId,GuestCount,BookingLevel)  
    SELECT BookingId,RoomId,COUNT(*),'Room' FROM #BookingRoom  
    GROUP BY BookingId,RoomId  
      
    --Booking Guest Count BED LEVEL  
    INSERT INTO #BookingCount(BookingId,RoomId,GuestCount,BookingLevel)  
    SELECT BookingId,RoomId,COUNT(*),'Bed' FROM #BookingBed  
    GROUP BY BookingId,RoomId  
      
    --Booking Guest Count Apartment LEVEL  
    INSERT INTO #BookingCount(BookingId,RoomId,GuestCount,BookingLevel)  
    SELECT BookingId,RoomId,COUNT(*),'Apartment' FROM #BookingApartment  
    GROUP BY BookingId,RoomId  
      
      
    --GET APARTMENT BOOKING ID FOR CONCAT GUEST NAME  
   INSERT INTO #ApartmentBookingId(BookingId ,PropertyId,GuestName,GuestCount)  
   SELECT BookingId,G.BookingPropertyId,FirstName,1   
   FROM WRBHBBooking B     
   JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   AND CONVERT(DATE,ChkInDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND    
   BookingPropertyId=@Pram2  
   AND G.IsActive=1 AND G.IsDeleted=0     
   WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
     
   INSERT INTO #ApartmentBookingId(BookingId ,PropertyId,GuestName,GuestCount)  
   SELECT BookingId,G.BookingPropertyId,FirstName,1   
   FROM WRBHBBooking B     
   JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   AND CONVERT(DATE,ChkOutDt,103) BETWEEN CONVERT(DATE,@Pram3,103)  
   AND CONVERT(DATE,@Pram4,103) AND  
   BookingPropertyId=@Pram2  
   AND G.IsActive=1 AND G.IsDeleted=0     
   WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment)  
     
   INSERT INTO #ApartmentBookingId(BookingId ,PropertyId,GuestName,GuestCount)  
   SELECT BookingId,G.BookingPropertyId,FirstName,1   
   FROM WRBHBBooking B     
   JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   AND CONVERT(DATE,ChkInDt,103) < CONVERT(DATE,@Pram3,103)  
   --AND CONVERT(DATE,@Pram4,103) AND      
   AND CONVERT(DATE,ChkOutDt,103) > CONVERT(DATE,@Pram4,103)  
   --AND CONVERT(DATE,@Pram4,103) AND  
   AND BookingPropertyId=@Pram2  
   AND G.IsActive=1 AND G.IsDeleted=0     
   WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment)  
     
   INSERT INTO #ApartmentBookingId(BookingId ,PropertyId,GuestName,GuestCount)  
   SELECT BookingId,G.BookingPropertyId,FirstName,1  
   FROM WRBHBBooking B     
   JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.Id =G.BookingId  
   AND CONVERT(DATE,ChkInDt,103) > CONVERT(DATE,@Pram3,103)      
   AND CONVERT(DATE,ChkOutDt,103) < CONVERT(DATE,@Pram4,103)    
   AND BookingPropertyId=@Pram2  
   AND G.IsActive=1 AND G.IsDeleted=0     
   WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
   AND B.Id NOT IN(SELECT BookingId FROM #BookingApartment) 
     
   INSERT INTO #ApartmentBookingIdCount(BookingId ,PropertyId ,GuestName,GuestCount)  
   SELECT BookingId ,PropertyId ,GuestName,GuestCount   
   FROM #ApartmentBookingId B WHERE B.BookingId IN(SELECT BookingId FROM #ApartmentBookingId   
   GROUP BY BookingId,PropertyId HAVING COUNT(*) =1)  
     
   INSERT INTO #ApartmentBookingIdCount(BookingId ,PropertyId ,GuestName,GuestCount)  
   SELECT BookingId ,PropertyId ,GuestName,GuestCount  
   FROM #ApartmentBookingId B WHERE B.BookingId IN(SELECT BookingId FROM #ApartmentBookingId   
   GROUP BY BookingId,PropertyId HAVING COUNT(*) >=2)     
     
   INSERT INTO #ApartmentGuestName(BookingId ,PropertyId ,GuestName)  
   SELECT T2.BookingId,T2.PropertyId ,(SELECT Substring((SELECT ', ' + CAST(t1.GuestName AS VARCHAR(1024))   
                      FROM   #ApartmentBookingId t1 WHERE  t1.BookingId = t2.BookingId   
                      FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName                      
   FROM #ApartmentBookingIdCount T2  
   WHERE T2.BookingId NOT IN(SELECT BookingId FROM #CheckIn)  
     
    
   --GET DATA FROM CHECKIN TABLE BED AND ROOMS ONLY  
   INSERT INTO #CheckIn(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,BookingLevel)   
   SELECT Id,BedId,BookingId,H.RoomId,RoomNo,H.GuestName,CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime+' '+TimeType as DATETIME) ChkInDt,  
   CONVERT(NVARCHAR,ChkoutDate,103) ChkOutDt,'CheckedIn','' FROM WrbHbCheckInHdr H   
   WHERE  PropertyId=@Pram2  AND H.IsActive=1 AND H.IsDeleted=0   
   AND TYPE NOT IN('Apartment')  
     
     
   --GET DATA FROM CHECKIN TABLE APARTMENT  
   INSERT INTO #CheckIn(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,BookingLevel)   
   SELECT H.Id,BedId,BookingId,R.Id,R.RoomNo,H.GuestName,CAST(CAST(CONVERT(DATE,ArrivalDate,103) AS NVARCHAR)+' '+ArrivalTime+' '+TimeType as DATETIME) ChkInDt,  
   CONVERT(NVARCHAR,ChkoutDate,103) ChkOutDt,'CheckedIn','' FROM WrbHbCheckInHdr H  
   JOIN WRBHBPropertyRooms R ON R.ApartmentId=H.ApartmentId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'   
   WHERE  H.PropertyId=@Pram2  AND H.IsActive=1 AND H.IsDeleted=0   
   AND TYPE IN('Apartment')  
  
    
   ---Room Level  
   INSERT INTO #BookingCountRoom(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingRoom B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingRoom   
   GROUP BY BookingId,RoomId HAVING COUNT(*) =1)  
     
   INSERT INTO #BookingCountRoom(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingRoom B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingRoom   
   GROUP BY BookingId,RoomId HAVING COUNT(*) >=2)  
     
   ---Bed Level  
   INSERT INTO #BookingCountBed(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingBed B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingBed   
   GROUP BY BookingId,RoomId HAVING COUNT(*) =1)  
     
   INSERT INTO #BookingCountBed(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingBed B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingBed   
   GROUP BY BookingId,RoomId HAVING COUNT(*) >=2)  
     
   ---Apartment Level  
   INSERT INTO #BookingCountApartment(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingApartment B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingApartment   
   GROUP BY BookingId,RoomId HAVING COUNT(*) =1)  
     
   INSERT INTO #BookingCountApartment(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)  
   SELECT B.Id,B.BedId,B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,B.BStatus   
   FROM #BookingApartment B  
   WHERE B.BookingId IN(SELECT BookingId FROM #BookingApartment   
   GROUP BY BookingId,RoomId HAVING COUNT(*) >=2)  
     
     
   --FILTER CHECKED IN Room LEVEL BOOKING ENTRY  
   INSERT INTO #Occupancy(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)   
   SELECT 0,T2.BedId,T2.BookingId,T2.RoomId,T2.RoomName, (SELECT Substring((SELECT ', ' + CAST(t1.GuestName AS VARCHAR(1024))   
                      FROM   #BookingRoom t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId=t2.RoomId  
                      FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName,T2.CheckInDt,T2.CheckOutDt,T2.Type,T2.Occupancy,T2.BookingLevel,T2.BStatus   
   FROM #BookingCountRoom T2  
   --WHERE T2.BookingId NOT IN(SELECT BookingId FROM #CheckIn)  
     
   --FILTER CHECKED IN Bed LEVEL BOOKING ENTRY  
   INSERT INTO #Occupancy(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)   
   SELECT 0,0,T2.BookingId,T2.RoomId,T2.RoomName, (SELECT Substring((SELECT ', ' + CAST(t1.GuestName AS VARCHAR(1024))   
                      FROM   #BookingBed t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId=t2.RoomId  
                      FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName,T2.CheckInDt,T2.CheckOutDt,T2.Type,T2.Occupancy,T2.BookingLevel,T2.BStatus   
   FROM #BookingCountBed T2  
   --WHERE T2.BookingId NOT IN(SELECT BookingId FROM #CheckIn)  
     
   --FILTER CHECKED IN Apartment LEVEL BOOKING ENTRY  
   INSERT INTO #Occupancy(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,BStatus)   
   SELECT 0,0,T2.BookingId,T2.RoomId,T2.RoomName, (SELECT Substring((SELECT ', ' + CAST(t1.GuestName AS VARCHAR(1024))   
                      FROM   #BookingApartment t1 WHERE  t1.BookingId = t2.BookingId and t1.RoomId=t2.RoomId  
                      FOR XML PATH('')), 3, 10000000) AS list) AS  GuestName,T2.CheckInDt,T2.CheckOutDt,T2.Type,T2.Occupancy,T2.BookingLevel,T2.BStatus   
   FROM #BookingCountApartment T2  
   
   --UPDATE CHECKED IN DATA ONLY  
   UPDATE #Occupancy SET CheckInDt=C.CheckInDt  
   FROM #Occupancy O  
   JOIN #CheckIn C ON O.BookingId=C.BookingId AND O.RoomId=C.RoomId 
     
	
   --UPDATE CHECKIN DATE  
   UPDATE #Occupancy SET CheckInDt=CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,O.CheckInDt,103)),103)    
   FROM #Occupancy O  
   WHERE CONVERT(TIME,CAST(O.CheckInDt AS DATETIME)) <CAST('11:00:00 AM' AS TIME)  
     
     
   ---UPDATE APARTMENT GUEST NAME  
   UPDATE #Occupancy SET GuestName=A.GuestName  
   FROM #Occupancy O  
   JOIN #ApartmentGuestName A ON O.BookingId=A.BookingId   
     
   ---UPDATE GUEST COUNT  
   UPDATE #Occupancy SET GuestCount=A.GuestCount  
   FROM #Occupancy O  
   JOIN #BookingCount A ON O.BookingId=A.BookingId AND O.RoomId=A.RoomId   
     
     
   --Get rooms are dedicated or non dedicater  
   --IF  @PropertyType='Internal Property'  
   --BEGIN  
    INSERT INTO #NDDCount(RoomId,PropertyId)  
    SELECT R.Id,R.PropertyId FROM dbo.WRBHBContractManagementAppartment CA  
    JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON  CA.ApartmentId=R.ApartmentId AND CA.PropertyId=@Pram2  
    AND R.IsActive=1 AND R.IsDeleted=0 AND CA.ApartmentId!=0  
    JOIN dbo.WRBHBContractManagement C ON C.Id=CA.ContractId AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
    AND C.IsActive=1 AND C.IsDeleted=0  
    WHERE CA.IsActive=1 AND CA.IsDeleted=0  
       
    INSERT INTO #NDDCount(RoomId,PropertyId)     
    SELECT CR.RoomId,CR.PropertyId FROM dbo.WRBHBContractManagementTariffAppartment CR  
    JOIN dbo.WRBHBContractManagement C ON C.Id=CR.ContractId AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
    AND C.IsActive=1 AND C.IsDeleted=0  
    WHERE CR.PropertyId=@Pram2 AND CR.IsActive=1 AND CR.IsDeleted=0  AND CR.RoomId!=0 
   --END  
   --ELSE  
   --BEGIN  
   -- INSERT INTO #NDDCount(RoomId,PropertyId)  
   -- SELECT R.Id,R.PropertyId FROM dbo.WRBHBPropertyBlocks B    
   -- JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId    
   -- AND B.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0      
   -- WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0   
   -- ORDER BY B.BlockName,R.RoomNo ASC  
   --END  
     
   INSERT INTO #OccupancyFinal(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,RoomType,  
   BookingLevel,BookingCode,ClientName,Split,GuestCount)  
   SELECT O.Id,O.BedId,BookingId,O.RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,'Dedicated',o.BookingLevel,  
   B.BookingCode,c.ClientName,0,O.GuestCount  
   FROM #Occupancy O  
   JOIN WRBHBBooking B WITH(NOLOCK) ON BookingId=B.Id  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId  
   WHERE RoomId IN(SELECT RoomId FROM #NDDCount)  
   GROUP BY O.Id,O.BedId,BookingId,O.RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,o.BookingLevel,  
   B.BookingCode,c.ClientName,GuestCount  
     
     
   INSERT INTO #OccupancyFinal(Id,BedId,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,RoomType,  
   BookingLevel,BookingCode,ClientName,Split,GuestCount)  
   SELECT O.Id,O.BedId,BookingId,O.RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,'NonDedicated',o.BookingLevel,  
   B.BookingCode,c.ClientName,0,O.GuestCount  
   FROM #Occupancy O  
   JOIN WRBHBBooking B WITH(NOLOCK) ON BookingId=B.Id  
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON  C.Id=B.ClientId  
   WHERE RoomId NOT IN(SELECT RoomId FROM #NDDCount)  
   GROUP BY O.Id,O.BedId,BookingId,O.RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,o.BookingLevel,  
   B.BookingCode,c.ClientName,GuestCount  
     
   
     
   --OCCUPANCY DATE   
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Days'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Total Room Nights(ND)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Occupied (ND)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Available (ND)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Occupancy % (ND)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Total Room Nights (D)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Occupied (D)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Available (D)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Occupancy % (D)'  
   INSERT INTO #OccupancyData(Data)  
   SELECT 'No.Of Guests (Dedicated and Non-Dedicated)'     
   INSERT INTO #OccupancyData(Data)  
   SELECT 'Occupancy % (ND + D)'  
     
     
   DECLARE @Tariff DECIMAL(27,2),@ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@Count INT;  
   DECLARE @DateDiff int,@i BIGINT,@HR NVARCHAR(100),@RoomId BIGINT,@BookingId BIGINT,@NoOfDays INT,  
   @RoomName NVARCHAR(100),@BookingLevel NVARCHAR(100),@CheckInId BIGINT,@PropertyId BIGINT,  
   @Type NVARCHAR(100),@Occupancy NVARCHAR(100),@SingleandMarkup DECIMAL(27,2),@Markup DECIMAL(27,2),  
   @GuestName NVARCHAR(100),@ApartmentId BIGINT,@BookingCode NVARCHAR(100),@ClientName NVARCHAR(100),  
   @BedId BIGINT,@Id BIGINT,@RoomType NVARCHAR(100),@GuestCount BIGINT;  
   --DateSplit   
   SELECT @NoOfDays=DATEDIFF(day, CONVERT(DATE,@Pram3,103), CONVERT(DATE,@Pram4,103))+1,  
   @i=0  
   WHILE (@NoOfDays>0)  
    BEGIN  
     INSERT INTO #DateSplit(DT)  
     SELECT CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@Pram3,103)),103)  
     SET @NoOfDays=@NoOfDays-1   
     SET @i=@i+1  
    END      
	   SELECT TOP 1 @RoomName=RoomName,@RoomId=RoomId,@BookingId=BookingId,@GuestName=GuestName,  
	   @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
	   @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
	   @Type=Type,@Occupancy=Occupancy,@BookingCode=BookingCode,@ClientName=ClientName,  
	   @BedId=BedId,@Id=Id,@RoomType=RoomType,@GuestCount=GuestCount  
	   FROM #OccupancyFinal  
   WHERE Split=0      
    WHILE (@NoOfDays>0)  
    BEGIN            
		INSERT INTO #OccupancySplit(BookingId,RoomId,DT,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		BookingLevel,ClientName,BookingCode,BedId,Id,RoomType,GuestCount)  
		SELECT @BookingId,@RoomId,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),  
		@RoomName,@GuestName,@ChkInDate,@ChkOutDate,@Type,@Occupancy,@BookingLevel,@ClientName,  
		@BookingCode,@BedId,@Id,@RoomType,@GuestCount  
	     
		SET @NoOfDays=@NoOfDays-1   
		SET @i=@i+1  
		IF @NoOfDays=0  
		BEGIN  
		 IF @BookingLevel='Bed'  
		 BEGIN  
			UPDATE #OccupancyFinal SET Split=1,UBookingId=@BookingId,URoomId=@BedId  WHERE BookingId=@BookingId AND RoomId=@RoomId   
			AND @Id=Id AND @BedId=BedId AND @ChkInDate=CheckInDt AND @ChkOutDate=CheckOutDt    
		 END  
		 ELSE  
		 BEGIN  
			UPDATE #OccupancyFinal SET Split=1,UBookingId=@BookingId,URoomId=@RoomId WHERE BookingId=@BookingId AND RoomId=@RoomId   		 
			AND @ChkInDate=CheckInDt AND @ChkOutDate=CheckOutDt  
		 END  
        
		 SELECT TOP 1 @RoomName=RoomName,@RoomId=RoomId,@BookingId=BookingId,@GuestName=GuestName,  
		 @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
		 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
		 @Type=Type,@Occupancy=Occupancy,@BookingCode=BookingCode,@ClientName=ClientName,  
		 @BedId=BedId,@Id=Id,@RoomType=RoomType,@GuestCount=GuestCount  
		 FROM #OccupancyFinal  
		 WHERE Split=0 
		 
		 IF @NoOfDays<=0
		 BEGIN
		    UPDATE #OccupancyFinal SET Split=1,UBookingId=@BookingId,URoomId=@BedId  WHERE BookingId=@BookingId AND RoomId=@RoomId   
			AND @Id=Id AND @ChkInDate=CheckInDt AND @ChkOutDate=CheckOutDt  AND @GuestName=GuestName  
			
			 SELECT TOP 1 @RoomName=RoomName,@RoomId=RoomId,@BookingId=BookingId,@GuestName=GuestName,  
			 @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103))+1,  
			 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
			 @Type=Type,@Occupancy=Occupancy,@BookingCode=BookingCode,@ClientName=ClientName,  
			 @BedId=BedId,@Id=Id,@RoomType=RoomType,@GuestCount=GuestCount  
			 FROM #OccupancyFinal  
			 WHERE Split=0 
		 END  
    END    
    END  
    
	INSERT INTO #OccupancyFinalCount1(BookingId,RoomId,DT,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,ClientName,BookingCode,RoomType,GuestCount)  
	SELECT BookingId,RoomId,DT,RoomName,GuestName,CONVERT(DATE,CheckInDt,103),CheckOutDt,Type,'Double',  
	BookingLevel,ClientName,BookingCode,RoomType,GuestCount   
	FROM #OccupancySplit B  
	WHERE GuestCount>1   
       
	INSERT INTO #OccupancyFinalCount1(BookingId,RoomId,DT,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,ClientName,BookingCode,RoomType,GuestCount)  
	SELECT BookingId,RoomId,DT,RoomName,GuestName,CONVERT(DATE,CheckInDt,103),CheckOutDt,Type,'Single',  
	BookingLevel,ClientName,BookingCode,RoomType,GuestCount   
	FROM #OccupancySplit B  
	WHERE  GuestCount=1  
       
       
   
   
  --TABLE 0 ROOMS IN THAT GIVEN PROPERTY  
   SELECT BookingCode,BookingId,RoomId,RoomName,GuestName,CONVERT(NVARCHAR,CAST(CheckInDt AS DATE),103) CheckInDt,CheckOutDt,Type,Occupancy,RoomType,  
   o.BookingLevel,ClientName,CheckInDt DiffCheckInDt,CheckOutDt DiffCheckOutDt,GuestCount,DT  
   FROM #OccupancyFinalCount1 O  
   WHERE CONVERT(DATE,DT,103) BETWEEN CONVERT(DATE,@Pram3,103) AND DATEADD(DAY,1,CONVERT(DATE,@Pram4,103))    
   GROUP BY BookingCode,BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,RoomType,  
   o.BookingLevel,ClientName,GuestCount,DT  
   ORDER BY RoomId ASC  
     
     
     
    --TABLE 1 ROOMS IN THAT GIVEN PROPERTY  
   --IF  @PropertyType='Internal Property'  
   --BEGIN  
    SELECT B.BlockName+'-'+A.ApartmentNo+'-'+R.RoomNo as Room,R.Id FROM dbo.WRBHBPropertyBlocks B     
    JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON B.Id=A.BlockId AND B.PropertyId=A.PropertyId   
    AND A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND a.Status='Active'  
    JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId AND A.Id=R.ApartmentId   
    AND A.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'     
    WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0   
    ORDER BY B.BlockName,A.ApartmentNo,R.RoomNo ASC  
   --END  
   --ELSE  
   --BEGIN  
   -- SELECT B.BlockName+'-'+R.RoomNo as Room,R.Id FROM dbo.WRBHBPropertyBlocks B    
   -- JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId    
   -- AND B.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0      
   -- WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0   
   -- ORDER BY B.BlockName,R.RoomNo ASC  
   --END 
   IF  @PropertyType='Internal Property'  
   BEGIN  
    --TABLE 2 DEDICATED COUNT  
	   SELECT COUNT(*) DDCount FROM #NDDCount   
	     
		--TABLE 3 PROPERTY ROOMS COUNT  
	   --IF  @PropertyType='Internal Property'  
	   --BEGIN  
		SELECT COUNT(*) NDDCount FROM dbo.WRBHBPropertyBlocks B     
		JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON B.Id=A.BlockId AND B.PropertyId=A.PropertyId   
		AND A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND a.Status='Active'  
		JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId AND A.Id=R.ApartmentId   
		AND A.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'    
		WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0  
   END  
  ELSE  
  BEGIN  
		SELECT COUNT(*) DDCount  FROM dbo.WRBHBPropertyBlocks B     
		JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON B.Id=A.BlockId AND B.PropertyId=A.PropertyId   
		AND A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND a.Status='Active'  
		JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId AND A.Id=R.ApartmentId   
		AND A.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'    
		WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0  
	    
		 --TABLE 2 DEDICATED COUNT 
		 SELECT COUNT(*) NDDCount  FROM dbo.WRBHBPropertyBlocks B     
		JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON B.Id=A.BlockId AND B.PropertyId=A.PropertyId   
		AND A.IsActive=1 AND A.IsDeleted=0 AND A.SellableApartmentType!='HUB' AND a.Status='Active'  
		JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId AND A.Id=R.ApartmentId   
		AND A.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0 AND R.RoomStatus='Active'    
		WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0 
	    --SELECT COUNT(*) NDDCount FROM #NDDCount
    
  END   
   -- SELECT COUNT(*) NDDCount FROM dbo.WRBHBPropertyBlocks B    
   -- JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON B.Id=R.BlockId    
   -- AND B.PropertyId=R.PropertyId AND R.IsActive=1 AND R.IsDeleted=0      
   -- WHERE B.PropertyId=@Pram2 AND  B.IsActive=1 AND B.IsDeleted=0   
      
   --END  
    -- TABLE 4 OCCUPANCY DATE  
   SELECT DATA FROM #OccupancyData  
     
   ---TABLE 5 APARTMENT GUEST COUNT  
   SELECT BookingId OldBookingId,BookingId,COUNT(*) Counts FROM #ApartmentBookingId  
   GROUP BY BookingId  
     
     
   INSERT INTO  #DateROOM(RoomId,DT,RoomType,CheckOutDate)  
   SELECT RoomId,o.DT,RoomType,o.CheckOutDt FROM #OccupancyFinalCount1 o  
   JOIN #DateSplit s ON o.DT=s.DT       
   GROUP BY RoomId,o.DT,RoomType,o.CheckOutDt  
   
   IF  @PropertyType='Internal Property'  
   BEGIN    
	   ---TABLE 6 GROUP BY NonDedicated OCCUPANCY ROOM  
	   INSERT INTO  #DateROOMS(RoomId,DT,RoomType)  
	   SELECT RoomId,DT,RoomType FROM #DateROOM  
	   WHERE RoomType='NonDedicated' AND DT!=CheckOutDate  
	   GROUP BY DT,RoomType,RoomId  
	   ORDER BY CONVERT(DATE,DT,103) ASC   
	     
	   SELECT COUNT(*) NDDCount,DT,RoomType   
	   FROM #DateROOMS  
	   GROUP BY DT,RoomType  
	     
	   ---TABLE 7 GROUP BY NonDedicated OCCUPANCY ROOM  
	   INSERT INTO  #DateROOMS1(RoomId,DT,RoomType)  
	   SELECT RoomId,DT,RoomType FROM #DateROOM  
	   WHERE RoomType!='NonDedicated' AND DT!=CheckOutDate  
	   GROUP BY DT,RoomType,RoomId  
	   ORDER BY CONVERT(DATE,DT,103) ASC   
	     
	   SELECT COUNT(*) DDCount,DT,RoomType   
	   FROM #DateROOMS1  
	   GROUP BY DT,RoomType  
   END
   ELSE
   BEGIN
		 ---TABLE 6 GROUP BY NonDedicated OCCUPANCY ROOM  
	   INSERT INTO  #DateROOMS1(RoomId,DT,RoomType)  
	   SELECT RoomId,DT,RoomType FROM #DateROOM  
	   WHERE RoomType!='NonDedicated' AND DT!=CheckOutDate  
	   GROUP BY DT,RoomType,RoomId  
	   ORDER BY CONVERT(DATE,DT,103) ASC   
	     
	   SELECT COUNT(*) NDDCount ,DT,RoomType   
	   FROM #DateROOMS1  
	   GROUP BY DT,RoomType 
	   
	   ---TABLE 7 GROUP BY NonDedicated OCCUPANCY ROOM  
	   INSERT INTO  #DateROOMS(RoomId,DT,RoomType)  
	   SELECT RoomId,DT,RoomType FROM #DateROOM  
	   WHERE RoomType='NonDedicated' AND DT!=CheckOutDate  
	   GROUP BY DT,RoomType,RoomId  
	   ORDER BY CONVERT(DATE,DT,103) ASC   
	     
	   SELECT COUNT(*) DDCount,DT,RoomType   
	   FROM #DateROOMS  
	   GROUP BY DT,RoomType 
   
   
   END  
   ---TABLE 8 GROUP BY DATE WISE Guest  
   SELECT SUM(GuestCount) NOGuest,DT  
   FROM #OccupancyFinalCount1 O  
   GROUP BY DT  
   
   ---TABLE 9 GROUP BY DATE WISE Guest  
   select @PropertyType PropertyType
     
 END  
 END  
  
  
  
  
   
 