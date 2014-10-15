-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[BookingReport]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[BookingReport]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:
-- ModifiedBy :Sakthi, ModifiedDate:14/07/2014
-- Description:	BOOKING
-- =================================================================================
CREATE PROCEDURE [dbo].[BookingReport](@Action NVARCHAR(100),  
@StartDt NVARCHAR(100),@EndDt NVARCHAR(100),@ClientId INT)  
AS  
BEGIN  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF
IF @Action = 'BookingDtls'
 BEGIN
  CREATE TABLE #FINAL(BookingCode INT,ClientName NVARCHAR(100),
  PropertyName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDt NVARCHAR(100),
  CheckOutDt NVARCHAR(100),StayDays INT,UserName NVARCHAR(100),
  Tariff DECIMAL(27,2),Status NVARCHAR(100),BookingLevel NVARCHAR(100),
  BookingId INT,GuestId INT,AssignedGuestTableId INT,ClientId INT,
  CRMId INT,CRMName NVARCHAR(100),PropertyId INT,
  MasterClientName NVARCHAR(100),MasterClientId INT,BookingDate NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100));
  -- Room Level Booking : Cancel : Begin
  -- Get Canceled Booking Id
  CREATE TABLE #Tbl1(RoomCapturedCnt INT,RoomCaptured INT,BookingId INT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #Tbl1(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,
  Tariff)  
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff
  FROM WRBHBBooking B
  JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=B.Id   
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room' AND 
  ISNULL(B.CancelStatus,'') IN ('Canceled','No Show') AND 
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff;
  -- Get Canceled Booking Guest Id & Tariff 
  CREATE TABLE #Tbl2(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2));
  INSERT INTO #Tbl2(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #Tbl1 S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured;
  -- Cancel Booking
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,RB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),
  RB.TariffPaymentMode
  FROM #Tbl2 A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=A.BookingId
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=A.BookingId AND RB.GuestId=A.GuestId 
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=A.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room';
  -- Room Level Booking : Cancel : End
  -- Room Level Booking : Booked & Direct Booked : Begin
  -- Get Booking Id
  CREATE TABLE #SDD(RoomCapturedCnt INT,RoomCaptured INT,BookingId INT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2),RoomId INT);
  INSERT INTO #SDD(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,
  Tariff,RoomId)
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff,
  BG.RoomId
  FROM WRBHBBooking B
  JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=B.Id   
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')='' AND
  B.BookingLevel='Room' AND BG.IsActive=1 AND BG.IsDeleted=0 AND
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff,BG.RoomId;
  -- Get Booking Guest Id & Tariff 
  CREATE TABLE #ASD(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2),
  RoomId INT);
  INSERT INTO #ASD(BookingId,GuestId,DividedTariff,RoomId)
  SELECT B.BookingId,B.GuestId,S.DividedTariff,B.RoomId
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #SDD S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured AND
  IsActive=1 AND IsDeleted=0 AND B.RoomId=S.RoomId;
  --
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),MIN(RB.ChkInDt),103) AS CheckInDt,
  CONVERT(VARCHAR(100),MAX(RB.ChkOutDt),103) AS CheckOutDt,
  SUM(DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt)) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,
  0,--RB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),
  RB.TariffPaymentMode
  FROM #ASD A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=A.BookingId
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=A.BookingId AND RB.GuestId=A.GuestId 
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=A.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room' AND
  RB.IsActive=1 AND RB.IsDeleted=0 AND A.BookingId=RB.BookingId AND
  A.RoomId=RB.RoomId AND A.GuestId=RB.GuestId
  GROUP BY B.BookingCode,C.ClientName,P.PropertyName,CG.FirstName,
  CG.LastName,U.FirstName,U.LastName,A.DividedTariff,RB.CurrentStatus,
  B.BookingLevel,B.Id,RB.GuestId,C.Id,C.CRMId,U1.FirstName,
  U1.LastName,P.Id,MC.ClientName,MC.Id,RB.CreatedDate,RB.TariffPaymentMode;
  -- Room Level Booking : Booked & Direct Booked : End
  -- Bed Level Booking : Direct Booked : Begin
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName,
  CONVERT(VARCHAR(100),BB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),BB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,BB.ChkInDt,BB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,BB.Tariff,
  BB.CurrentStatus AS Status,B.BookingLevel,B.Id,BB.GuestId,BB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),BB.CreatedDate,103),
  BB.TariffPaymentMode
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BB
  WITH(NOLOCK)ON BB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=BB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=BB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Bed' AND
  ISNULL(B.CancelStatus,'')='' AND BB.IsActive=1 AND BB.IsDeleted=0 AND 
  CONVERT(DATE,BB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103);
  -- Bed Level Booking : Direct Booked : End
  -- Bed Level Booking : Cancel : Begin
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName,
  CONVERT(VARCHAR(100),BB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),BB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,BB.ChkInDt,BB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,BB.Tariff,
  BB.CurrentStatus AS Status,B.BookingLevel,B.Id,BB.GuestId,BB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),BB.CreatedDate,103),
  BB.TariffPaymentMode
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BB
  WITH(NOLOCK)ON BB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=BB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=BB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Bed' AND
  ISNULL(B.CancelStatus,'') IN ('Canceled','No Show') AND  
  CONVERT(DATE,BB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103);
  -- Bed Level Booking : Cancel : End
  -- Apartment Level Booking : Cancel : Begin
  -- Get Canceled Booking Id
  CREATE TABLE #ATbl1(ApartmentIdCnt INT,ApartmentId INT,BookingId INT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #ATbl1(ApartmentIdCnt,ApartmentId,BookingId,DividedTariff,Tariff)  
  SELECT COUNT(BG.ApartmentId),BG.ApartmentId,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.ApartmentId) AS INT),0),BG.Tariff
  FROM WRBHBBooking B
  JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=B.Id   
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Apartment' AND 
  ISNULL(B.CancelStatus,'') IN ('Canceled','No Show') AND
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  GROUP BY B.Id,BG.ApartmentId,BG.Tariff;
  -- Get Canceled Booking Guest Id & Tariff 
  CREATE TABLE #ATbl2(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2));
  INSERT INTO #ATbl2(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff
  FROM WRBHBApartmentBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #ATbl1 S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.ApartmentId=S.ApartmentId;
  -- Cancel Booking
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode) 
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,RB.Id,C.Id,
  C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),RB.TariffPaymentMode 
  FROM #ATbl2 A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=A.BookingId
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=A.BookingId AND RB.GuestId=A.GuestId 
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=A.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Apartment';
  -- Apartment Level Booking : Cancel : End
  -- Apartment Level Booking : Direct Booked : Begin
  -- Get Booking Id
  CREATE TABLE #ATbl3(ApartmentIdCnt INT,ApartmentId INT,BookingId INT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #ATbl3(ApartmentIdCnt,ApartmentId,BookingId,DividedTariff,Tariff)  
  SELECT COUNT(BG.ApartmentId),BG.ApartmentId,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.ApartmentId) AS INT),0),BG.Tariff
  FROM WRBHBBooking B
  JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=B.Id   
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')='' AND
  B.BookingLevel='Apartment' AND BG.IsActive=1 AND BG.IsDeleted=0 AND
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  GROUP BY B.Id,BG.ApartmentId,BG.Tariff;
  -- Get Booking Guest Id & Tariff 
  CREATE TABLE #ATbl4(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2));
  INSERT INTO #ATbl4(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff
  FROM WRBHBApartmentBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #ATbl3 S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.ApartmentId=S.ApartmentId AND
  IsActive=1 AND IsDeleted=0;
  --
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,RB.Id,C.Id,
  C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),RB.TariffPaymentMode
  FROM #ATbl4 A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=A.BookingId
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=A.BookingId AND RB.GuestId=A.GuestId 
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
  MC.Id=C.MasterClientId
  LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id=C.CRMId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=A.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Apartment' AND
  RB.IsActive=1 AND RB.IsDeleted=0;
  -- Apartment Level Booking : Direct Booked : End
  /*SELECT BookingCode,Status,BookingLevel,ClientName,PropertyName,
  GuestName,CheckInDt,CheckOutDt,StayDays,UserName,Tariff,
  BookingId,GuestId,AssignedGuestTableId FROM #FINAL
  ORDER BY BookingCode ASC;*/
  ---
  
  CREATE TABLE #TABLE(SNo INT IDENTITY(1,1),BookingCode NVARCHAR(100),
  Status NVARCHAR(100),BookingLevel NVARCHAR(100),ClientName NVARCHAR(100),
  PropertyName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDt NVARCHAR(100),
  CheckOutDt NVARCHAR(100),StayDays INT,UserName NVARCHAR(100),
  Tariff DECIMAL(27,2),BookingId INT,GuestId INT,AssignedGuestTableId INT,
  ClientId INT,CRMId INT,CRMName NVARCHAR(100),PropertyId INT,
  MasterClientName NVARCHAR(100),MasterClientId INT,BookingDate NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100));
  IF @ClientId = 0
   BEGIN
    INSERT INTO #TABLE(BookingCode,Status,BookingLevel,ClientName,PropertyName,
    GuestName,CheckInDt,CheckOutDt,StayDays,UserName,Tariff,BookingId,GuestId,
    AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
    MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
    SELECT BookingCode,Status,BookingLevel,ClientName,PropertyName,GuestName,
    CheckInDt,CheckOutDt,StayDays,UserName,Tariff,BookingId,GuestId,
    AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
    MasterClientName,MasterClientId,BookingDate,TariffPaymentMode FROM #FINAL
    ORDER BY BookingCode ASC;
   END
  ELSE
   BEGIN
    INSERT INTO #TABLE(BookingCode,Status,BookingLevel,ClientName,PropertyName,
    GuestName,CheckInDt,CheckOutDt,StayDays,UserName,Tariff,BookingId,GuestId,
    AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
    MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
    SELECT BookingCode,Status,BookingLevel,ClientName,PropertyName,GuestName,
    CheckInDt,CheckOutDt,StayDays,UserName,Tariff,BookingId,GuestId,
    AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
    MasterClientName,MasterClientId,BookingDate,
    ISNULL(TariffPaymentMode,'') AS TariffPaymentMode FROM #FINAL
    WHERE ClientId=@ClientId ORDER BY BookingCode ASC;
   END
  --
  SELECT BookingCode,Status,BookingLevel,ISNULL(ClientName,'') AS ClientName,
  ISNULL(PropertyName,'') AS PropertyName,ISNULL(GuestName,'') AS GuestName,
  CheckInDt,CheckOutDt,StayDays,ISNULL(UserName,'') AS UserName,Tariff,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,
  ISNULL(CRMName,'') AS CRMName,PropertyId,BookingDate,
  ISNULL(MasterClientName,'') AS MasterClientName,MasterClientId,SNo,
  ISNULL(TariffPaymentMode,'') AS TariffPaymentMode,
  StayDays * Tariff AS TotalTariff
  FROM #TABLE T 
  WHERE ISNULL(UserName,'') NOT IN ('VivekAdmonk','VivekAdmonk');
 END
END  
/*IF @Action = 'Load'  
 BEGIN
  -- Room Level Booking: Occupancy - Single
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  U.FirstName+' '+U.LastName AS UserName,RB.Tariff,
  CASE WHEN B.Status='Direct Booked' THEN 'Booked'
       WHEN B.Status='Booked' THEN B.Status
       WHEN B.Status='Canceled' THEN B.Status
       ELSE B.Status END AS Status
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=RB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND RB.Occupancy='Single' AND
  RB.IsActive=1 AND RB.IsDeleted=0 AND
  CONVERT(DATE,RB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103);
  -- Room Level Booking : Occupancy - Double
  CREATE TABLE #SDD(RoomCapturedCnt INT,RoomCaptured INT,BookingId INT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #SDD(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,Tariff)
  SELECT COUNT(RoomCaptured),RoomCaptured,BookingId,
  ROUND(Tariff/CAST(COUNT(RoomCaptured) AS INT),0),Tariff 
  FROM WRBHBBookingPropertyAssingedGuest WHERE Occupancy='Double' AND
  IsActive=1 AND IsDeleted=0
  GROUP BY BookingId,RoomCaptured,Tariff
  --
  CREATE TABLE #ASD(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2));
  INSERT INTO #ASD(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff 
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #SDD S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured AND
  IsActive=1 AND IsDeleted=0
  --
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  CASE WHEN B.Status='Direct Booked' THEN 'Booked'
       WHEN B.Status='Booked' THEN B.Status
       WHEN B.Status='Canceled' THEN B.Status
       ELSE B.Status END AS Status
  FROM #ASD A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=A.BookingId
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest RB
  WITH(NOLOCK)ON RB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=RB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=RB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND
  RB.IsActive=1 AND RB.IsDeleted=0 AND
  CONVERT(DATE,RB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103);
  -- Bed Level Booking
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName,
  CONVERT(VARCHAR(100),BB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),BB.ChkOutDt,103) AS CheckOutDt,
  U.FirstName+' '+U.LastName AS UserName,BB.Tariff,
  CASE WHEN B.Status='Direct Booked' THEN 'Booked'
       WHEN B.Status='Booked' THEN B.Status
       WHEN B.Status='Canceled' THEN B.Status
       ELSE B.Status END AS Status
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BB
  WITH(NOLOCK)ON BB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=BB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=BB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BB.IsActive=1 AND 
  BB.IsDeleted=0 AND CONVERT(DATE,BB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  -- Apartment Level Booking
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  CG.FirstName+' '+CG.LastName AS GuestName,
  CONVERT(VARCHAR(100),AB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),AB.ChkOutDt,103) AS CheckOutDt,
  U.FirstName+' '+U.LastName AS UserName,AB.Tariff,
  CASE WHEN B.Status='Direct Booked' THEN 'Booked'
       WHEN B.Status='Booked' THEN B.Status
       WHEN B.Status='Canceled' THEN B.Status
       ELSE B.Status END AS Status
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest AB
  WITH(NOLOCK)ON AB.BookingId=B.Id
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
  C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=AB.CreatedBy
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
  WITH(NOLOCK)ON CG.Id=AB.GuestId
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON
  P.Id=AB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND AB.IsActive=1 AND 
  AB.IsDeleted=0 AND CONVERT(DATE,AB.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
  ORDER BY B.BookingCode;
 END  
END*/