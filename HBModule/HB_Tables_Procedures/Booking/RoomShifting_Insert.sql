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
IF @BookingLevel = 'Room'  
 BEGIN  
  -- UPDATE PAYMENT MODE & Expected checkin time  
  UPDATE WRBHBBookingPropertyAssingedGuest SET TariffPaymentMode = @TariffMode,  
  ServicePaymentMode = @ServiceMode WHERE BookingId = @BookingId AND 
  IsActive = 1 AND IsDeleted = 0 AND RoomCaptured = @RoomCaptured;
  -- get PropertyType  
  DECLARE @PropertyType NVARCHAR(100) = '';  
  SELECT TOP 1 @PropertyType = BP.PropertyType FROM WRBHBBookingProperty BP  
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON  
  BG.BookingId = BP.BookingId AND BG.BookingPropertyId = BP.PropertyId AND  
  BG.BookingPropertyTableId = BP.Id  
  WHERE BP.BookingId = @BookingId GROUP BY BP.PropertyType;  
  CREATE TABLE #AssignedGuestTableId(Id BIGINT);
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
      RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
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
	  -- Get Booking Property Assinged Guest Table Id
	  INSERT INTO #AssignedGuestTableId(Id)
	  SELECT Id FROM WRBHBBookingPropertyAssingedGuest
	  WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
	  RoomCaptured = @RoomCaptured AND RoomId = @FromRoomId AND
	  BookingId = @BookingId;
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
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,RoomCaptured,ApartmentId,
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
	    CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,RoomCaptured,ApartmentId,
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
	  CREATE TABLE #TMPPP(Id BIGINT, DayCnt INT);
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
    END
  IF @Type = 'Stay'
   BEGIN
    DECLARE @EChkInDt DATE,@EChkOutDt DATE;
    DECLARE @NowChkInDt DATE,@NowChkOutDt DATE;
    --IF @PropertyType != ''
    IF @CurrentStatus = 'Booked'    
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
      -- Get Booking Property Assinged Guest Table Id
      INSERT INTO #AssignedGuestTableId(Id)
      SELECT Id FROM WRBHBBookingPropertyAssingedGuest
      WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
      RoomCaptured = @RoomCaptured AND RoomId = @FromRoomId AND
      BookingId = @BookingId;
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
      RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
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
    IF @CurrentStatus = 'CheckIn'    
     BEGIN
      --
      SELECT @EChkInDt = MIN(ChkInDt),@EChkOutDt = MAX(ChkOutDt)      
      FROM WRBHBBookingPropertyAssingedGuest  
      WHERE IsActive = 1 AND IsDeleted = 0 AND BookingId = @BookingId AND  
      RoomCaptured = @RoomCaptured;  
      -- Get Booking Property Assinged Guest Table Id
      INSERT INTO #AssignedGuestTableId(Id)
      SELECT Id FROM WRBHBBookingPropertyAssingedGuest
      WHERE IsActive = 1 AND IsDeleted = 0 AND RoomShiftingFlag = 0 AND
      RoomCaptured = @RoomCaptured AND RoomId = @FromRoomId AND
      BookingId = @BookingId;
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
      CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,AMPM,
      RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
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
    SELECT TOP 1 Logo FROM WRBHBCompanyMaster WHERE IsActive = 1
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
    SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@BookingId;  
    -- dataset table 5  
    SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@BookingId;  
    -- dataset table 6  
    SELECT Email FROM dbo.WRBHBClientManagementAddNewClient   
    WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND  
    CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);  
    --dataset table 7  
    SELECT ClientLogo FROM WRBHBClientManagement   
    WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B  
    JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId   
    AND P.IsActive=1 AND P.IsDeleted=0 WHERE B.Id=@BookingId);  
    --dataset table 8  
    --SELECT Id FROM #AssignedGuestTableId
    --
    DECLARE @ClientName NVARCHAR(100),@ClientName1 NVARCHAR(100);
    SELECT @ClientName = ClientName FROM WRBHBClientManagement
    WHERE Id = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId);
    CREATE TABLE #QAZXSW(Id INT,Name NVARCHAR(100));
    INSERT INTO #QAZXSW(Id,Name)
    SELECT * FROM dbo.Split(@ClientName,' ');
    SET @ClientName1 = (SELECT TOP 1 Name FROM #QAZXSW);
    --
    /*CREATE TABLE #QAZXSW(Name NVARCHAR(100),EChkInDt NVARCHAR(100),
    EChkOutDt NVARCHAR(100),NowChkInDt NVARCHAR(100),NowChkOutDt NVARCHAR(100),
    ExpectChkInTime NVARCHAR(100),DayDiff INT,TariffPaymentMode NVARCHAR(100),
    ServicePaymentMode NVARCHAR(100));  
    INSERT INTO #QAZXSW(Name,EChkInDt,EChkOutDt,NowChkInDt,NowChkOutDt,
    ExpectChkInTime,DayDiff,TariffPaymentMode,ServicePaymentMode)*/
    SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName  
    FROM WRBHBBookingPropertyAssingedGuest BA   
    WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND  
    BA.Id IN (SELECT Id FROM #AssignedGuestTableId)  
    FOR XML PATH('')),1,1,'') AS Name,  
    --CONVERT(VARCHAR(100),B.ChkInDt,103),CONVERT(VARCHAR(100),B.ChkOutDt,103),
    CONVERT(VARCHAR(100),@EChkInDt,103),CONVERT(VARCHAR(100),@EChkOutDt,103),
    CONVERT(VARCHAR(100),@NowChkInDt,103),CONVERT(VARCHAR(100),@NowChkOutDt,103),
    --@ChkInDt,@ChkOutDt,
    B.ExpectChkInTime+' '+B.AMPM,  
    --DATEDIFF(DAY,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103)),
    DATEDIFF(DAY,@NowChkInDt,@NowChkOutDt),
    CASE WHEN B.TariffPaymentMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN B.TariffPaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE B.TariffPaymentMode END,
    CASE WHEN B.ServicePaymentMode = 'Direct' THEN 'Direct<br>(Cash/Card)'
         WHEN B.ServicePaymentMode = 'Bill to Client' THEN 'Bill to '+@ClientName1 
         ELSE B.ServicePaymentMode END
    FROM WRBHBBookingPropertyAssingedGuest AS B  
    WHERE B.Id IN (SELECT Id FROM #AssignedGuestTableId);
    --dataset table 9
    CREATE TABLE #Mail(Id INT,Email NVARCHAR(100));
    DECLARE @BookingPropertyId BIGINT = (SELECT TOP 1 BookingPropertyId 
    FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @BookingId);
    IF @PropertyType = 'CPP'
     BEGIN
      SELECT ISNULL(D.Email,'') FROM WRBHBContractClientPref_Header H
      LEFT OUTER JOIN WRBHBContractClientPref_Details D
      WITH(NOLOCK)ON D.HeaderId = H.Id
      WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND D.IsActive = 1 AND
      D.IsDeleted = 0 AND 
      H.ClientId = (SELECT ClientId FROM WRBHBBooking WHERE Id = @BookingId) 
      AND D.PropertyId = @BookingPropertyId
      GROUP BY ISNULL(D.Email,''); 
     END
    ELSE
     BEGIN      
      SELECT ISNULL(Email,'') FROM WRBHBProperty WHERE Id = @BookingPropertyId;
     END
   END
 END
END
