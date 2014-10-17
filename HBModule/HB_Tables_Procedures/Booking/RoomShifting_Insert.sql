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
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_RoomShifting_Insert](@BookingId BIGINT,
@FromRoomId INT,@ToRoomId INT,@ChkInDt NVARCHAR(100),
@ChkOutDt NVARCHAR(100),@ToRoomNo NVARCHAR(100),
@BookingLevel NVARCHAR(100),@UsrId BIGINT,@RoomCaptured INT,
@CurrentStatus NVARCHAR(100),@TariffMode NVARCHAR(100),
@ServiceMode NVARCHAR(100))
AS
BEGIN
IF @BookingLevel = 'Room'
 BEGIN
  -- UPDATE PAYMENT MODE
  UPDATE WRBHBBookingPropertyAssingedGuest SET TariffPaymentMode = @TariffMode,
  ServicePaymentMode = @ServiceMode WHERE BookingId = @BookingId AND
  RoomCaptured = @RoomCaptured;
  --
  DECLARE @PropertyType NVARCHAR(100) = '';
  SELECT TOP 1 @PropertyType = BP.PropertyType FROM WRBHBBookingProperty BP
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=BP.BookingId AND BG.BookingPropertyId=BP.PropertyId AND
  BG.BookingPropertyTableId=BP.Id
  WHERE BP.BookingId = @BookingId GROUP BY BP.PropertyType;
  CREATE TABLE #AssignedGuestTableId(Id BIGINT);
  IF @PropertyType IN ('ExP')
   BEGIN
    IF @ToRoomId = 0
    BEGIN
     -- get booking property assinged guest table id     
     INSERT INTO #AssignedGuestTableId(Id)
     SELECT Id FROM WRBHBBookingPropertyAssingedGuest
     WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
     RoomCaptured=@RoomCaptured AND BookingId=@BookingId;
     -- insert same values but date changed
     INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
     FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
     BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
     ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
     ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
     AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
     RoomShiftingFlag,Title)
     SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
     RoomType,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
     CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
     ServicePaymentMode,TariffPaymentMode,
     ChkInDt,CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,
     AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title
     FROM WRBHBBookingPropertyAssingedGuest
     WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
     -- Update existing entry
     UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,
     ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
     CancelRemarks='Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
     @TariffMode+','+@ServiceMode,
     RoomShiftingFlag=1 WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
    END
   END
  IF @PropertyType IN ('InP','MGH','DdP')
   BEGIN
    IF @ToRoomId != 0
     BEGIN
      IF @BookingLevel = 'Room' AND @CurrentStatus = 'Booked'
       BEGIN
        -- Get Booking Property Assinged Guest Table Id
        INSERT INTO #AssignedGuestTableId(Id)
        SELECT Id FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
        RoomCaptured=@RoomCaptured AND RoomId=@FromRoomId AND
        BookingId=@BookingId;
        --
        INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
        FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
        BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
        ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
        ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
        AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
        PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
        LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
        RoomShiftingFlag,Title)
        SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
        @ToRoomNo,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
        CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
        ServicePaymentMode,TariffPaymentMode,
        CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',
        RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
        PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
        LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
        -- Update existing entry
        UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,
        ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
        CancelRemarks='Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
        @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
        CAST(@ToRoomId AS VARCHAR),
        RoomShiftingFlag=1
        WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
       END
      IF @BookingLevel = 'Room' AND @CurrentStatus = 'CheckIn'
       BEGIN
        -- Get Booking Property Assinged Guest Table Id
        INSERT INTO #AssignedGuestTableId(Id)
        SELECT Id FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
        RoomCaptured=@RoomCaptured AND RoomId=@FromRoomId AND
        BookingId=@BookingId;
        --
        INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
        FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
        BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
        ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
        ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
        AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
        PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
        LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
        RoomShiftingFlag,Title)
        SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
        @ToRoomNo,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
        CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
        ServicePaymentMode,TariffPaymentMode,
        CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',
        RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
        PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
        LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title
        FROM WRBHBBookingPropertyAssingedGuest
        WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
        -- Update existing entry
        UPDATE WRBHBBookingPropertyAssingedGuest SET ModifiedBy=@UsrId,
        ModifiedDate=GETDATE(),RoomShiftingFlag=1,
        CancelRemarks='Room Shifting'+','+@ChkInDt+','+@ChkOutDt+','+
        @TariffMode+','+@ServiceMode+','+CAST(@FromRoomId AS VARCHAR)+','+
        CAST(@ToRoomId AS VARCHAR),
        ChkOutDt=CONVERT(DATE,@ChkInDt,103)
        WHERE Id IN (SELECT Id FROM #AssignedGuestTableId);
        -- Same CheckIn date is inactive room
        UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1
        WHERE Id IN (SELECT Id FROM WRBHBBookingPropertyAssingedGuest
        WHERE IsActive=1 AND IsDeleted=0 AND RoomCaptured=@RoomCaptured AND 
        BookingId=@BookingId AND ChkInDt=ChkOutDt);
       END
     END
   END
   ---TABLE 0
   SELECT B.BookingCode,U.Email,B.Status,B.CancelRemarks,B.ClientName,
   U.UserName,U.MobileNumber,
   DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
   CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest
   FROM WRBHBBooking B
   LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UsrId
   WHERE B.Id=@BookingId;
   ---TABLE 1
   SELECT Logo FROM WRBHBCompanyMaster;
   ---TABLE 2
   SELECT ISNULL(BP.PropertyName,''),BP.PropertyName+','+Propertaddress+','+
   L.Locality+','+C.CityName+','+S.StateName+' - '+Postal
   FROM WRBHBProperty BP
   LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
   LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
   LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId 
   WHERE BP.Id = (SELECT TOP 1 BookingPropertyId 
   FROM WRBHBBookingPropertyAssingedGuest WHERE BookingId = @BookingId);
   ---TABLE 3
   SELECT BP.PropertyName, ISNULL(PU.UserName,'')UserName,
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
   SELECT STUFF((SELECT ', '+BA.Title+'. '+BA.FirstName+'  '+BA.LastName
   FROM WRBHBBookingPropertyAssingedGuest BA 
   WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured AND
   BA.Id IN (SELECT Id FROM #AssignedGuestTableId)
   FOR XML PATH('')),1,1,'') AS Name,
   CONVERT(VARCHAR(100),B.ChkInDt,103),
   CONVERT(VARCHAR(100),B.ChkOutDt,103),@ChkInDt,@ChkOutDt,
   B.ExpectChkInTime+' '+B.AMPM,
   DATEDIFF(DAY,CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103)),
   B.TariffPaymentMode,B.ServicePaymentMode
   FROM WRBHBBookingPropertyAssingedGuest AS B
   WHERE B.Id IN (SELECT Id FROM #AssignedGuestTableId);
 END
END
GO
 /*IF @BookingLevel = 'Room' AND @CurrentStatus = 'CheckIn'
  BEGIN   
   -- Get Booking Property Assinged Guest Table Id
   CREATE TABLE #TMP(Id BIGINT);
   INSERT INTO #TMP(Id)
   SELECT Id FROM WRBHBBookingPropertyAssingedGuest
   WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
   RoomCaptured=@RoomCaptured AND RoomId=@FromRoomId AND
   BookingId=@BookingId;
   -- Update Room Shifting Flag
   UPDATE WRBHBBookingPropertyAssingedGuest SET RoomShiftingFlag=1,
   ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
   ChkOutDt=CONVERT(DATE,@ChkInDt,103)
   WHERE Id IN (SELECT Id FROM #TMP);
   -- Same CheckIn date is inactive room
   UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1
   WHERE Id IN (SELECT Id FROM WRBHBBookingPropertyAssingedGuest
   WHERE IsActive=1 AND IsDeleted=0 AND RoomCaptured=@RoomCaptured AND 
   BookingId=@BookingId AND ChkInDt=ChkOutDt)
   -- New Insert Same Guest & Different RoomId
   INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
   FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
   BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
   ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
   ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
   AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
   PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
   LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
   RoomShiftingFlag)   
   SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
   @ToRoomNo,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
   CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
   ServicePaymentMode,TariffPaymentMode,
   CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00',
   'PM',RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
   PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
   LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0   
   FROM WRBHBBookingPropertyAssingedGuest
   WHERE Id IN (SELECT Id FROM #TMP);
   --
   SELECT Id,RowId FROM WRBHBBookingPropertyAssingedGuest 
   WHERE Id=@@IDENTITY;
  END
 /*--
     DECLARE @ExistsCnt1 INT = 0,@ExistsCnt2 INT = 0;
     SET @ExistsCnt1 = (SELECT COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId) AND 
     ChkInDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103));
     SET @ExistsCnt2 = (SELECT COUNT(*) FROM WRBHBBookingPropertyAssingedGuest
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId) AND 
     ChkOutDt BETWEEN CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103));*/
 IF @BookingLevel = 'Room' AND @CurrentStatus = 'Booked'
  BEGIN
   
   IF @ToRoomId = 0
    BEGIN
     -- get booking property assinged guest table id     
     INSERT INTO #AssingedGuestTableId(Id)
     SELECT Id FROM WRBHBBookingPropertyAssingedGuest
     WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
     RoomCaptured=@RoomCaptured AND BookingId=@BookingId;
     -- insert same values but date changed
     INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
     FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
     BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
     ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
     ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
     AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
     RoomShiftingFlag,Title)
     SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
     RoomType,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
     CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
     ServicePaymentMode,TariffPaymentMode,
     ChkInDt,CONVERT(DATE,@ChkOutDt,103),ExpectChkInTime,
     AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title
     FROM WRBHBBookingPropertyAssingedGuest
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId);
     -- Update existing entry
     UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,
     ModifiedBy=@UsrId,ModifiedDate=GETDATE(),CancelRemarks='Room Shifting',
     RoomShiftingFlag=1
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId);
    END
   IF @ToRoomId != 0
    BEGIN
     -- get booking property assinged guest table id     
     INSERT INTO #AssingedGuestTableId(Id)
     SELECT Id FROM WRBHBBookingPropertyAssingedGuest
     WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
     RoomCaptured=@RoomCaptured AND BookingId=@BookingId AND
     RoomId=@FromRoomId;     
     -- insert same values but date changed
     INSERT INTO WRBHBBookingPropertyAssingedGuest(BookingId,EmpCode,
     FirstName,LastName,GuestId,Occupancy,RoomType,Tariff,RoomId,
     BookingPropertyId,BookingPropertyTableId,CreatedBy,CreatedDate,
     ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,SSPId,
     ServicePaymentMode,TariffPaymentMode,ChkInDt,ChkOutDt,ExpectChkInTime,
     AMPM,RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,
     RoomShiftingFlag,Title)
     SELECT BookingId,EmpCode,FirstName,LastName,GuestId,Occupancy,
     @ToRoomNo,Tariff,@ToRoomId,BookingPropertyId,BookingPropertyTableId,
     CreatedBy,CreatedDate,@UsrId,GETDATE(),1,0,NEWID(),SSPId,
     ServicePaymentMode,TariffPaymentMode,
     CONVERT(DATE,@ChkInDt,103),CONVERT(DATE,@ChkOutDt,103),'12:00:00','PM',
     RoomCaptured,ApartmentId,RackSingle,RackDouble,RackTriple,
     PtyChkInTime,PtyChkInAMPM,PtyChkOutTime,PtyChkOutAMPM,PtyGraceTime,
     LTonAgreed,LTonRack,STonAgreed,STonRack,CurrentStatus,CheckInHdrId,0,Title
     FROM WRBHBBookingPropertyAssingedGuest
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId);     
     -- Update Room In Booked Status
     UPDATE WRBHBBookingPropertyAssingedGuest SET IsActive=0,IsDeleted=1,
     ModifiedBy=@UsrId,ModifiedDate=GETDATE(),CancelRemarks='Room Shifting',
     RoomShiftingFlag=1
     WHERE Id IN (SELECT Id FROM #AssingedGuestTableId);
    END
   /*-- Update Room In Booked Status
   UPDATE WRBHBBookingPropertyAssingedGuest SET RoomType=@ToRoomNo,
   RoomId=@ToRoomId,ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
   ChkInDt=CONVERT(DATE,@ChkInDt,103),ChkOutDt=CONVERT(DATE,@ChkOutDt,103),
   CancelRemarks='Room Shifting'
   WHERE IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0 AND
   RoomCaptured=@RoomCaptured AND RoomId=@FromRoomId AND
   BookingId=@BookingId;*/
   SELECT Id,RowId FROM WRBHBBookingPropertyAssingedGuest
   WHERE RoomCaptured=@RoomCaptured AND BookingId=@BookingId AND
   IsActive=1 AND IsDeleted=0 AND RoomShiftingFlag=0;
  END*/
