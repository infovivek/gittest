SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_RoomShifting_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_RoomShifting_Insert]
GO   
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (July/22/2014)  >
Section  	: Room Shifting Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Description of Changes
********************************************************************************************************	
Sakthi          3rd & 4th Dec   Process alterations - rework
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_RoomShifting_Insert](@BookingId BIGINT,  
@FromRoomId INT,@ToRoomId INT,@ChkInDt NVARCHAR(100),  
@ChkOutDt NVARCHAR(100),@ToRoomNo NVARCHAR(100),  
@BookingLevel NVARCHAR(100),@UsrId BIGINT,@RoomCaptured INT,  
@CurrentStatus NVARCHAR(100),@TariffMode NVARCHAR(100),  
@ServiceMode NVARCHAR(100),@Type NVARCHAR(100))  
AS  
BEGIN
DECLARE @PropertyType NVARCHAR(100) = ''; 
CREATE TABLE #AssignedGuestTableId(Id BIGINT); 
CREATE TABLE #TMPPP(Id BIGINT, DayCnt INT);
DECLARE @EChkInDt DATE,@EChkOutDt DATE,@NowChkInDt DATE,@NowChkOutDt DATE;
DECLARE @Stay NVARCHAR(100) = 'stay@hummingbirdindia.com';
DECLARE @ClientName NVARCHAR(100),@ClientName1 NVARCHAR(100);
CREATE TABLE #QAZXSW(Id INT,Name NVARCHAR(100));
CREATE TABLE #Mail(Id INT,Email NVARCHAR(100));
DECLARE @BookingPropertyId BIGINT;
DECLARE @UnsettledCHhkInDt DATE;
IF @BookingLevel = 'Room'  
 BEGIN  
  -- get PropertyType  
  SELECT TOP 1 @PropertyType = BP.PropertyType FROM WRBHBBookingProperty BP  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId = BP.BookingId AND BG.BookingPropertyId = BP.PropertyId AND  
  BG.BookingPropertyTableId = BP.Id  
  WHERE BP.BookingId = @BookingId GROUP BY BP.PropertyType;
  -- Get Booking Property Assinged Guest Table Id
  INSERT INTO #AssignedGuestTableId(Id)
  SELECT Id FROM WRBHBBookingPropertyAssingedGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
  RoomCaptured = @RoomCaptured AND RoomId = @FromRoomId AND
  BookingId = @BookingId;	  
  -- Get Room Apartment Id
  DECLARE @RoomApartmentId BIGINT = 0;
  SELECT @RoomApartmentId = ISNULL(ApartmentId,0) FROM WRBHBPropertyRooms 
  WHERE Id = @ToRoomId;
  IF @Type = 'Shift'
   BEGIN
    IF @PropertyType IN ('InP','MGH','DdP') AND @CurrentStatus = 'Booked'
     BEGIN
      -- Get Booking Property Assinged Guest Table Id
      INSERT INTO #AssignedGuestTableId(Id)
      SELECT Id FROM WRBHBBookingPropertyAssingedGuest
      WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
      RoomCaptured = @RoomCaptured AND RoomId = @FromRoomId AND
      BookingId=@BookingId;
      -- new insert
      INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
      BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
      ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
      ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
      AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
      RoomShiftingFlag,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
      @ToRoomNo,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
      CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
      ServicePaymentMode,TariffPaymentMode,
      CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',
      RoomCaptured,@RoomApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title,
      Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,
      Column10,BTCFilePath FROM WRBHBBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
     END    
	IF @PropertyType IN ('InP','MGH','DdP') AND @CurrentStatus = 'CheckIn'
	 BEGIN
	  -- from room Id & to room Id not same
	  IF @FromRoomId != @ToRoomId 
	   BEGIN
	    INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
	    BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
	    ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,RoomCaptured,
	    ApartmentId,RackSingle,RackDouble,RackTriple,PtyChkInTime,PtyChkInAMPM,
	    PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,LTonAgreed,LTonRack,STonAgreed,
	    STonRack,CurrentStatus,CheckInHdrId,RoomShiftingFlag,Title,Column1,Column2,
	    Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,
	    BTCFilePath)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,@ToRoomNo,
	    Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,CreatedBy,
	    CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,ServicePaymentMode,
	    TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,RoomCaptured,
	    @RoomApartmentId,
	    RackSingle,RackDouble,RackTriple,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,
	    PtyChkOutAMPM,PtyGraceTime,LTonAgreed,LTonRack,STonAgreed,STonRack,
	    CurrentStatus,CheckInHdrId,0,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,BTCFilePath
	    FROM WRBHBBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END
	  IF @FromRoomId = @ToRoomId
	   BEGIN
	    INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
	    BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
	    ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,RoomCaptured,
	    ApartmentId,RackSingle,RackDouble,RackTriple,PtyChkInTime,PtyChkInAMPM,
	    PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,LTonAgreed,LTonRack,STonAgreed,
	    STonRack,CurrentStatus,CheckInHdrId,RoomShiftingFlag,Title,Column1,Column2,
	    Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,
	    BTCFilePath)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,@ToRoomNo,
	    Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,CreatedBy,
	    CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,RoomCaptured,
	    @RoomApartmentId,
	    RackSingle,RackDouble,RackTriple,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,
	    PtyChkOutAMPM,PtyGraceTime,LTonAgreed,LTonRack,STonAgreed,STonRack,
	    CurrentStatus,CheckInHdrId,0,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,BTCFilePath
	    FROM WRBHBBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,IsActive = 0,
	    IsDeleted = 0,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END 
	  --
	  INSERT INTO #TMPPP(Id, DayCnt)
	  SELECT Id,DATEDIFF(DAY,ChkInDt,ChkOutDt)
	  FROM WRBHBBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured AND
	  BookingId = @BookingId;
	  --
	  UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0
	  WHERE Id IN (SELECT Id FROM #TMPPP WHERE DayCnt <= 0);
	  --
	  SELECT ChkInDt,ChkOutDt,Id,RoomShiftingFlag 
	  FROM WRBHBBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
	  RoomCaptured = @RoomCaptured AND RoomShiftingFlag = 0;
	 END
	 -- UPDATE PAYMENT MODE
	 UPDATE WRBHBBookingPropertyAssingedGuest SET TariffPaymentMode = @TariffMode,
	 ServicePaymentMode = @ServiceMode WHERE BookingId = @BookingId AND 
	 IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured;  
    END
  IF @Type = 'Stay'
   BEGIN
    IF @CurrentStatus = 'Booked'    
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
      --
      INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
      BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
      ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
      ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
      AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
      RoomShiftingFlag,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
      RoomType,Tariff,RoomId,BookingPropertyId,BookingPropertyTableId,
      CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
      ServicePaymentMode,TariffPaymentMode,
      CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',
      RoomCaptured,@RoomApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title,
      Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,
      Column10,BTCFilePath FROM WRBHBBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    --IF @CurrentStatus IN('CheckIn','UnSettled')
    IF @CurrentStatus IN('CheckIn','UnSettled')
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
      --
      INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
      BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
      ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
      ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
      AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
      RoomShiftingFlag,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
      RoomType,Tariff,RoomId,BookingPropertyId,BookingPropertyTableId,
      CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
      ServicePaymentMode,TariffPaymentMode,
      --CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,
      ChkInDt,CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,
      RoomCaptured,@RoomApartmentId,RackSingle,RackDouble,RackTriple,
      PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
      LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title,
      Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,
      Column10,BTCFilePath FROM WRBHBBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    -- UPDATE PAYMENT MODE
    UPDATE WRBHBBookingPropertyAssingedGuest SET TariffPaymentMode = @TariffMode,  
    ServicePaymentMode = @ServiceMode WHERE BookingId = @BookingId AND 
    IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured;  
    -- modification mail data 
    -- Dataset TABLE 0
    SELECT B.BookingCode,U.Email,B.Status,B.CancelRemarks,B.ClientName,
    U.UserName,U.MobileNumber,
    DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),  
    CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest  
    FROM WRBHBBooking B  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UsrId  
    WHERE B.Id=@BookingId;
    -- Dataset TABLE 1  
    SELECT TOP 1 Logo,@Stay FROM WRBHBCompanyMaster WHERE IsActive = 1
    ORDER BY Id DESC;  
    -- Dataset TABLE 2  
    SELECT ISNULL(BP.PropertyName,''),BP.PropertyName+','+Propertaddress+','+  
    L.Locality+','+C.CityName+','+S.StateName+' - '+Postal  
    FROM WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId  
    LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id  
    LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId   
    WHERE BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset TABLE 3  
    SELECT BP.PropertyName, ISNULL(U.FirstName,'')UserName,  
    ISNULL(U.Email,'')Email,ISNULL(U.MobileNumber,'')PhoneNumber,  
    ISNULL(BP.Email,'') AS Email  
    FROM dbo.WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id = PU.PropertyId   
    AND PU.IsActive=1 AND PU.IsDeleted=0 AND   
    UserType in('Resident Managers','Assistant Resident Managers')  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId  
    WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND  
    BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset Table 4  
    SELECT dbo.TRIM(ClientBookerEmail) FROM WRBHBBooking WHERE Id=@BookingId;  
    -- dataset table 5  
    SELECT dbo.TRIM(EmailId) FROM WRBHBBookingGuestDetails 
    WHERE BookingId = @BookingId AND GuestId IN
    (SELECT GuestId FROM WRBHBBookingPropertyAssingedGuest 
    WHERE BookingId = @BookingId AND
    RoomCaptured = @RoomCaptured) AND ISNULL(EmailId,'') != ''
    GROUP BY EmailId;  
    -- dataset table 6  
    SELECT dbo.TRIM(Email) FROM dbo.WRBHBClientManagementAddNewClient   
    WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND  
    CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);  
    --dataset table 7  
    SELECT ClientLogo FROM WRBHBClientManagement   
    WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B  
    JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId   
    AND P.IsActive=1 AND P.IsDeleted=0 WHERE B.Id=@BookingId);  
    --dataset table 8
    SELECT @ClientName = dbo.TRIM(ISNULL(ClientName,'')) FROM WRBHBClientManagement
    WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId);
    --
    INSERT INTO #QAZXSW(Id,Name)
    SELECT * FROM dbo.Split(@ClientName,' ');
    SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
    --    
    SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName  
    FROM WRBHBBookingPropertyAssingedGuest BA   
    WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND  
    BA.Id IN (SELECT Id FROM #AssignedGuestTableId)  
    FOR XML PATH('')),1,1,'') AS Name,
    CONVERT(VARCHAR(100),@EChkInDt,103),CONVERT(VARCHAR(100),@EChkOutDt,103),
    CONVERT(VARCHAR(100),@NowChkInDt,103),CONVERT(VARCHAR(100),@NowChkOutDt,103),
    --@ChkInDt,@ChkOutDt,
    B.ExpectChkInTime+' '+B.AMPM,DATEDIFF(DAY,@NowChkInDt,@NowChkOutDt),
    CASE WHEN @TariffMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @TariffMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @TariffMode END,
    CASE WHEN @ServiceMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @ServiceMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @ServiceMode END
    FROM WRBHBBookingPropertyAssingedGuest AS B  
    WHERE B.Id IN (SELECT Id FROM #AssignedGuestTableId);
    --dataset table 9
    CREATE TABLE #SENDeMAIL(Email VARCHAR(MAX));
    SET @BookingPropertyId = (SELECT TOP 1 BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @BookingId);
    IF @PropertyType = 'CPP'
     BEGIN
      INSERT INTO #SENDeMAIL(Email)
      SELECT ISNULL(D.Email,'') FROM WRBHBContractClientPref_Header H
      LEFT OUTER JOIN WRBHBContractClientPref_Details D
      WITH(NOLOCK)ON D.HeaderId = H.Id
      WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND D.IsActive = 1 AND
      D.IsDeleted = 0 AND ISNULL(D.Email,'') != '' AND
      H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId) 
      AND D.PropertyId = @BookingPropertyId
      GROUP BY ISNULL(D.Email,''); 
     END
    ELSE
     BEGIN
      INSERT INTO #SENDeMAIL(Email)      
      SELECT ISNULL(Email,'') FROM WRBHBProperty WHERE Id = @BookingPropertyId;
     END
    /*;WITH tmp(DataItem,Email) AS
    (
      SELECT LEFT(Email, CHARINDEX(',',Email+',')-1),
      STUFF(Email, 1, CHARINDEX(',',Email+','), '') FROM #SENDeMAIL
      UNION ALL
      SELECT LEFT(Email, CHARINDEX(',',Email+',')-1),
      STUFF(Email, 1, CHARINDEX(',',Email+','), '') FROM tmp
      WHERE Email > ''
    )
    SELECT dbo.TRIM(DataItem) AS Email FROM tmp WHERE DataItem != '' GROUP BY DataItem;*/
    SELECT dbo.TRIM(Email) AS Email FROM #SENDeMAIL WHERE Email != '' 
    GROUP BY Email;
   END
 END
IF @BookingLevel = 'Bed'  
 BEGIN
  -- get PropertyType    
  SELECT TOP 1 @PropertyType = BP.PropertyType FROM WRBHBBedBookingProperty BP  
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId = BP.BookingId AND BG.BookingPropertyId = BP.PropertyId AND  
  BG.BookingPropertyTableId = BP.Id  
  WHERE BP.BookingId = @BookingId GROUP BY BP.PropertyType;
  -- Get Booking Property Assinged Guest Table Id
  INSERT INTO #AssignedGuestTableId(Id)
  SELECT Id FROM WRBHBBedBookingPropertyAssingedGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
  RoomCaptured = @RoomCaptured AND BedId = @FromRoomId AND
  BookingId = @BookingId;
  -- get room id & apartment id
  DECLARE @BedRoomId BIGINT;
  SELECT @BedRoomId = RoomId FROM WRBHBPropertyRoomBeds WHERE Id = @ToRoomId;
  DECLARE @BedApartmentId BIGINT;
  SELECT @BedApartmentId = ApartmentId FROM WRBHBPropertyRooms 
  WHERE Id = @BedRoomId;
  --
  --select @BookingLevel,@Type;return;
  --
  IF @Type = 'Shift'
   BEGIN
    IF @PropertyType IN ('InP','MGH') AND @CurrentStatus = 'Booked'
     BEGIN
      -- Get Booking Property Assinged Guest Table Id
      INSERT INTO #AssignedGuestTableId(Id)
      SELECT Id FROM WRBHBBedBookingPropertyAssingedGuest
      WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
      RoomCaptured = @RoomCaptured AND BedId = @FromRoomId AND
      BookingId=@BookingId;
      -- new insert
      INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
      PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
      Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
      RoomCaptured,RoomShiftingFlag)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
      @BedRoomId,@ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,
      ServicePaymentMode,TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),
      CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',CreatedBy,CreatedDate,
      @UsrId,GETDATE(),1,0,NEWID(),@BedApartmentId,RackTariff,
      PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,PtyChkOutTime,PtyGraceTime,
      CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,Column6,
      Column7,Column8,Column9,Column10,BTCFilePath,RoomCaptured,0
      FROM WRBHBBedBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);      
      -- Update existing entry
      UPDATE WRBHBBedBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
     END    
	IF @PropertyType IN ('InP','MGH') AND @CurrentStatus = 'CheckIn'
	 BEGIN
	  -- from room Id & to room Id not same
	  IF @FromRoomId != @ToRoomId 
	   BEGIN
	    INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
	    BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
	    CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
	    ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
	    PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
	    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
	    RoomCaptured,RoomShiftingFlag)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
	    @BedRoomId,@ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,
	    ServicePaymentMode,TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,CreatedBy,CreatedDate,
	    @UsrId,GETDATE(),1,0,NEWID(),@BedApartmentId,RackTariff,
	    PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,PtyChkOutTime,PtyGraceTime,
	    CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,Column6,
	    Column7,Column8,Column9,Column10,BTCFilePath,RoomCaptured,0
	    FROM WRBHBBedBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBBedBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END
	  IF @FromRoomId = @ToRoomId
	   BEGIN
	    INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
	    BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
	    CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
	    ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
	    PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
	    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
	    RoomCaptured,RoomShiftingFlag)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
	    @BedRoomId,@ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,
	    ServicePaymentMode,TariffPaymentMode,ChkInDt,
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,CreatedBy,CreatedDate,
	    @UsrId,GETDATE(),1,0,NEWID(),@BedApartmentId,RackTariff,
	    PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,PtyChkOutTime,PtyGraceTime,
	    CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,Column6,
	    Column7,Column8,Column9,Column10,BTCFilePath,RoomCaptured,0
	    FROM WRBHBBedBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBBedBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,IsActive = 0,
	    IsDeleted = 0,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END 
	  --
	  INSERT INTO #TMPPP(Id, DayCnt)
	  SELECT Id,DATEDIFF(DAY,ChkInDt,ChkOutDt)
	  FROM WRBHBBedBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured AND
	  BookingId = @BookingId;
	  --
	  UPDATE WRBHBBedBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0
	  WHERE Id IN (SELECT Id FROM #TMPPP WHERE DayCnt <= 0);
	  --
	  SELECT ChkInDt,ChkOutDt,Id,RoomShiftingFlag 
	  FROM WRBHBBedBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
	  RoomCaptured = @RoomCaptured AND RoomShiftingFlag = 0;
	 END
	 -- UPDATE PAYMENT MODE
     UPDATE WRBHBBedBookingPropertyAssingedGuest 
     SET TariffPaymentMode = @TariffMode,ServicePaymentMode = @ServiceMode 
     WHERE BookingId = @BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
     RoomCaptured = @RoomCaptured;  
    END
  IF @Type = 'Stay'
   BEGIN
    IF @CurrentStatus = 'Booked'    
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBedBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
      --
      INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
      PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
      Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
      RoomCaptured,RoomShiftingFlag)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,BedType,Tariff,RoomId,
      BedId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),
      '12:00:00','PM',CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
      ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
      PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
      Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
      RoomCaptured,0 FROM WRBHBBedBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBBedBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBedBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    --IF @CurrentStatus IN('CheckIn','UnSettled')
    IF @CurrentStatus IN('CheckIn','UnSettled')
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBedBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;      
      --
      INSERT INTO WRBHBBedBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,BedType,Tariff,RoomId,BedId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      ApartmentId,RackTariff,PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,
      PtyChkOutTime,PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,
      Column4,Column5,Column6,Column7,Column8,Column9,Column10,BTCFilePath,
      RoomCaptured,RoomShiftingFlag)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,BedType,Tariff,RoomId,
      BedId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,
      CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),ApartmentId,RackTariff,
      PtyChkInAMPM,PtyChkOutAMPM,PtyChkInTime,PtyChkOutTime,PtyGraceTime,
      CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,Column6,Column7,
      Column8,Column9,Column10,BTCFilePath,RoomCaptured,0 
      FROM WRBHBBedBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBBedBookingPropertyAssingedGuest SET IsActive = 0,IsDeleted = 0,
      ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBedBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    --
    --select @BookingLevel,@Type;return;
    -- UPDATE PAYMENT MODE
    UPDATE WRBHBBedBookingPropertyAssingedGuest 
    SET TariffPaymentMode = @TariffMode,ServicePaymentMode = @ServiceMode 
    WHERE BookingId = @BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
    RoomCaptured = @RoomCaptured;
    -- modification mail data 
    -- Dataset TABLE 0
    SELECT B.BookingCode,U.Email,B.Status,B.CancelRemarks,B.ClientName,
    U.UserName,U.MobileNumber,
    DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),  
    CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest  
    FROM WRBHBBooking B  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UsrId  
    WHERE B.Id=@BookingId;
    -- Dataset TABLE 1  
    SELECT TOP 1 Logo,@Stay FROM WRBHBCompanyMaster WHERE IsActive = 1
    ORDER BY Id DESC;  
    -- Dataset TABLE 2  
    SELECT ISNULL(BP.PropertyName,''),BP.PropertyName+','+Propertaddress+','+  
    L.Locality+','+C.CityName+','+S.StateName+' - '+Postal  
    FROM WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId  
    LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id  
    LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId   
    WHERE BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset TABLE 3  
    SELECT BP.PropertyName, ISNULL(U.FirstName,'')UserName,  
    ISNULL(U.Email,'')Email,ISNULL(U.MobileNumber,'')PhoneNumber,  
    ISNULL(BP.Email,'') AS Email  
    FROM dbo.WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id = PU.PropertyId   
    AND PU.IsActive=1 AND PU.IsDeleted=0 AND   
    UserType in('Resident Managers','Assistant Resident Managers')  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId  
    WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND  
    BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBBedBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset Table 4  
    SELECT dbo.TRIM(ClientBookerEmail) FROM WRBHBBooking WHERE Id=@BookingId;  
    -- dataset table 5  
    SELECT dbo.TRIM(EmailId) FROM WRBHBBookingGuestDetails 
    WHERE BookingId = @BookingId AND GuestId IN
    (SELECT GuestId FROM WRBHBBedBookingPropertyAssingedGuest 
    WHERE BookingId = @BookingId AND RoomCaptured = @RoomCaptured) 
    GROUP BY EmailId;  
    -- dataset table 6  
    SELECT dbo.TRIM(Email) FROM dbo.WRBHBClientManagementAddNewClient   
    WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND  
    CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId); 
    --
    --select @BookingLevel,@Type;return; 
    --dataset table 7  
    SELECT ClientLogo FROM WRBHBClientManagement   
    WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B  
    JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId   
    AND P.IsActive=1 AND P.IsDeleted=0 WHERE B.Id=@BookingId);  
    --dataset table 8
    --
    SELECT @ClientName = dbo.TRIM(ISNULL(ClientName,'')) FROM WRBHBClientManagement
    WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId);
    --
    --select @BookingLevel,@Type,@ClientName;return;
    --
    INSERT INTO #QAZXSW(Id,Name)
    SELECT * FROM dbo.Split(@ClientName,' ');
    SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
    --
    --select @BookingLevel,@Type,@ClientName1;return;
    --   
    SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName  
    FROM WRBHBBedBookingPropertyAssingedGuest BA   
    WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND  
    BA.Id IN (SELECT Id FROM #AssignedGuestTableId)  
    FOR XML PATH('')),1,1,'') AS Name,
    CONVERT(VARCHAR(100),@EChkInDt,103),CONVERT(VARCHAR(100),@EChkOutDt,103),
    CONVERT(VARCHAR(100),@NowChkInDt,103),CONVERT(VARCHAR(100),@NowChkOutDt,103),
    B.ExpectChkInTime+' '+B.AMPM,
    DATEDIFF(DAY,@NowChkInDt,@NowChkOutDt),
    CASE WHEN @TariffMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @TariffMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @TariffMode END,
    CASE WHEN @ServiceMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @ServiceMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @ServiceMode END
    FROM WRBHBBedBookingPropertyAssingedGuest AS B  
    WHERE B.Id IN (SELECT Id FROM #AssignedGuestTableId);
    --dataset table 9
    SELECT '' AS Email;
   END
 END
IF @BookingLevel = 'Apartment'  
 BEGIN  
  -- get PropertyType  
  SELECT TOP 1 @PropertyType = BP.PropertyType 
  FROM WRBHBApartmentBookingProperty BP  
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId = BP.BookingId AND BG.BookingPropertyId = BP.PropertyId AND  
  BG.BookingPropertyTableId = BP.Id  
  WHERE BP.BookingId = @BookingId;
  -- Get Booking Property Assinged Guest Table Id
  INSERT INTO #AssignedGuestTableId(Id)
  SELECT Id FROM WRBHBApartmentBookingPropertyAssingedGuest
  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
  RoomCaptured = @RoomCaptured AND ApartmentId = @FromRoomId AND
  BookingId=@BookingId;
  IF @Type = 'Shift'
   BEGIN
    IF @PropertyType IN ('InP','DdP') AND @CurrentStatus = 'Booked'
     BEGIN      
      -- new insert
      INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
      BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
      @ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),
      '12:00:00','PM',CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,0,BTCFilePath 
      FROM WRBHBApartmentBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);      
      -- Update existing entry
      UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsActive = 0,
      IsDeleted = 0,ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
     END    
	IF @PropertyType IN ('InP','DdP') AND @CurrentStatus = 'CheckIn'
	 BEGIN	  
	  -- from room Id & to room Id not same
	  IF @FromRoomId != @ToRoomId 
	   BEGIN
	    INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
	    BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
	    CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
	    RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
	    PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
	    BTCFilePath)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
	    @ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),
	    ExpectChkInTime,AMPM,CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
	    RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
	    PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,RoomCaptured,0,BTCFilePath 
	    FROM WRBHBApartmentBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END
	  IF @FromRoomId = @ToRoomId
	   BEGIN
	    INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
	    FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
	    BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
	    CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
	    RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
	    PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
	    BTCFilePath)
	    SELECT BookingId,EmpCode,FirstName,LastName,GuestId,@ToRoomNo,Tariff,
	    @ToRoomId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
	    TariffPaymentMode,ChkInDt,CONVERT(DATE,@ChkOutDt,103),
	    ExpectChkInTime,AMPM,CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
	    RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
	    PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
	    Column6,Column7,Column8,Column9,Column10,RoomCaptured,0,BTCFilePath 
	    FROM WRBHBApartmentBookingPropertyAssingedGuest
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	    -- Update existing entry
	    UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET ModifiedBy = @UsrId,
	    ModifiedDate = GETDATE(),RoomShiftingFlag = 1,IsActive = 0,IsDeleted = 0,
	    CancelRemarks = 'Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
	    @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
	    CAST(@ToRoomId AS VARCHAR),ChkOutDt = CONVERT(DATE,@ChkInDt,103)
	    WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
	   END 
	  --
	  INSERT INTO #TMPPP(Id, DayCnt)
	  SELECT Id,DATEDIFF(DAY,ChkInDt,ChkOutDt)
	  FROM WRBHBApartmentBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured AND
	  BookingId = @BookingId;
	  --
	  UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsActive = 0,
	  IsDeleted = 0 WHERE Id IN (SELECT Id FROM #TMPPP WHERE DayCnt <= 0);
	  --
	  SELECT ChkInDt,ChkOutDt,Id,RoomShiftingFlag 
	  FROM WRBHBApartmentBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND
	  RoomCaptured = @RoomCaptured AND RoomShiftingFlag = 0;
	 END
	 -- UPDATE PAYMENT MODE
	 UPDATE WRBHBApartmentBookingPropertyAssingedGuest 
	 SET TariffPaymentMode = @TariffMode,ServicePaymentMode = @ServiceMode 
	 WHERE BookingId = @BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
	 RoomCaptured = @RoomCaptured;
    END
  IF @Type = 'Stay'
   BEGIN
    IF @CurrentStatus = 'Booked'    
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBApartmentBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;      
      --
      INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
      BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,ApartmentType,Tariff,
      ApartmentId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),
      '12:00:00','PM',CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,0,BTCFilePath 
      FROM WRBHBApartmentBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsActive = 0,
      IsDeleted = 0,ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBApartmentBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    --IF @CurrentStatus IN('CheckIn','UnSettled')
    IF @CurrentStatus IN('CheckIn','UnSettled')
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBApartmentBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;
      --
      INSERT INTO WRBHBApartmentBookingPropertyAssingedGuest(BookingId,EmpCode,
      FirstName,LastName,GuestId,ApartmentType,Tariff,ApartmentId,SSPId,
      BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,AMPM,CreatedBy,
      CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,RoomShiftingFlag,
      BTCFilePath)
      SELECT BookingId,EmpCode,FirstName,LastName,GuestId,ApartmentType,Tariff,
      ApartmentId,SSPId,BookingPropertyId,BookingPropertyTableId,ServicePaymentMode,
      TariffPaymentMode,ChkInDt,CONVERT(DATE,@ChkOutDt,103),
      ExpectChkInTime,AMPM,CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),
      RackTariff,PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,
      PtyGraceTime,CurrentStatus,Title,Column1,Column2,Column3,Column4,Column5,
      Column6,Column7,Column8,Column9,Column10,RoomCaptured,0,BTCFilePath 
      FROM WRBHBApartmentBookingPropertyAssingedGuest
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      -- Update existing entry
      UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET IsActive = 0,
      IsDeleted = 0,ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
      CancelRemarks = 'Stay'+','+@ChkInDt+','+@ChkOutDt+','+
      @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
      CAST(@ToRoomId AS VARCHAR),RoomShiftingFlag = 1
      WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
      --
      SELECT @NowChkInDt = MIN(ChkInDt),@NowChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBApartmentBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
     END
    -- UPDATE PAYMENT MODE
    UPDATE WRBHBApartmentBookingPropertyAssingedGuest 
    SET TariffPaymentMode = @TariffMode,ServicePaymentMode = @ServiceMode 
    WHERE BookingId = @BookingId AND IsActive = 1 AND IsDeleted = 0 AND 
    RoomCaptured = @RoomCaptured;
    -- modification mail data 
    -- Dataset TABLE 0
    SELECT B.BookingCode,U.Email,B.Status,B.CancelRemarks,B.ClientName,
    U.UserName,U.MobileNumber,
    DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),  
    CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest  
    FROM WRBHBBooking B  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UsrId  
    WHERE B.Id=@BookingId;
    -- Dataset TABLE 1  
    SELECT TOP 1 Logo,@Stay FROM WRBHBCompanyMaster WHERE IsActive = 1
    ORDER BY Id DESC;  
    -- Dataset TABLE 2  
    SELECT ISNULL(BP.PropertyName,''),BP.PropertyName+','+Propertaddress+','+  
    L.Locality+','+C.CityName+','+S.StateName+' - '+Postal  
    FROM WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId  
    LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id  
    LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId   
    WHERE BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBApartmentBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset TABLE 3  
    SELECT BP.PropertyName, ISNULL(U.FirstName,'')UserName,  
    ISNULL(U.Email,'')Email,ISNULL(U.MobileNumber,'')PhoneNumber,  
    ISNULL(BP.Email,'') AS Email  
    FROM dbo.WRBHBProperty BP  
    LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id = PU.PropertyId   
    AND PU.IsActive=1 AND PU.IsDeleted=0 AND   
    UserType in('Resident Managers','Assistant Resident Managers')  
    LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId  
    WHERE BP.IsActive=1 AND BP.IsDeleted=0 AND  
    BP.Id = (SELECT TOP 1 BookingPropertyId   
    FROM WRBHBApartmentBookingPropertyAssingedGuest WHERE BookingId = @BookingId);  
    -- Dataset Table 4  
    SELECT dbo.TRIM(ClientBookerEmail) FROM WRBHBBooking WHERE Id=@BookingId;  
    -- dataset table 5  
    SELECT dbo.TRIM(EmailId) FROM WRBHBBookingGuestDetails 
    WHERE BookingId = @BookingId AND GuestId IN
    (SELECT GuestId FROM WRBHBApartmentBookingPropertyAssingedGuest
    WHERE BookingId = @BookingId AND RoomCaptured = @RoomCaptured);  
    -- dataset table 6  
    SELECT dbo.TRIM(Email) FROM dbo.WRBHBClientManagementAddNewClient   
    WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND  
    CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);  
    --dataset table 7  
    SELECT ClientLogo FROM WRBHBClientManagement   
    WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B  
    JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId   
    AND P.IsActive=1 AND P.IsDeleted=0 WHERE B.Id=@BookingId);  
    --dataset table 8
    SELECT @ClientName = dbo.TRIM(ISNULL(ClientName,'')) FROM WRBHBClientManagement
    WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId);
    INSERT INTO #QAZXSW(Id,Name)
    SELECT * FROM dbo.Split(@ClientName,' ');
    SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
    --    
    SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName  
    FROM WRBHBApartmentBookingPropertyAssingedGuest BA   
    WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND  
    BA.Id IN (SELECT Id FROM #AssignedGuestTableId)  
    FOR XML PATH('')),1,1,'') AS Name,
    CONVERT(VARCHAR(100),@EChkInDt,103),CONVERT(VARCHAR(100),@EChkOutDt,103),
    CONVERT(VARCHAR(100),@NowChkInDt,103),CONVERT(VARCHAR(100),@NowChkOutDt,103),
    B.ExpectChkInTime+' '+B.AMPM,DATEDIFF(DAY,@NowChkInDt,@NowChkOutDt),
    CASE WHEN @TariffMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @TariffMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @TariffMode END,
    CASE WHEN @ServiceMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN @ServiceMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE @ServiceMode END    
    FROM WRBHBApartmentBookingPropertyAssingedGuest AS B  
    WHERE B.Id IN (SELECT Id FROM #AssignedGuestTableId);
    --dataset table 9
    SELECT '' AS Email;
   END
 END
END