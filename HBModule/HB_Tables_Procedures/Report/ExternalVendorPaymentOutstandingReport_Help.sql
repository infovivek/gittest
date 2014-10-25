-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ExternalVendorPaymentOutstandingReport_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ExternalVendorPaymentOutstandingReport_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:27-06-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	BOOKING
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_ExternalVendorPaymentOutstandingReport_Help]
(@Action NVARCHAR(100),@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),
@ChkInDt NVARCHAR(100),@ChkOutDt NVARCHAR(100),@Id1 BIGINT,@Id2 BIGINT,
@Id3 BIGINT,@PropertyId BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'POBased'
 BEGIN
  CREATE TABLE #TABLE(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingCode INT,
  BookingId INT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),GuestId INT,
  ClientName NVARCHAR(100),ClientId INT,RoomCaptured INT,ChkOutId INT);
  -- Canceled Booking : Begin
  INSERT INTO #TABLE(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,
  TotalAmount,BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  Guest,GuestId,ClientName,ClientId,RoomCaptured,ChkOutId)
  SELECT BP.PropertyId,P.PropertyName,B.PONo,B.PONoId,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,0 AS Used,
  --DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS Unused,
  0 AS Unused,
  BG.Tariff AS RatePerDay,0 AS TotalTariff,0 AS TotalLuxuryTax,
  0 AS TotalServiceTax,0 AS TotalTax,0 AS TotalAmount,
  B.BookingCode,B.Id AS BookingId,
  CONVERT(VARCHAR(100),BG.ChkInDt,103)+' - '+
  CONVERT(VARCHAR(100),BG.ChkOutDt,103) AS StayDuration,
  CONVERT(VARCHAR(100),BG.CreatedDate,103) AS PODate,
  BG.CurrentStatus AS BookingStatus,
  CG.FirstName+' '+CG.LastName AS Guest,BG.GuestId,C.ClientName,B.ClientId,
  BG.RoomCaptured,0
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON 
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK)ON
  CG.CltmgntId=C.Id AND CG.CltmgntId=B.ClientId AND CG.Id=BG.GuestId
  WHERE --B.IsActive=1 AND B.IsDeleted=0 AND 
  (ISNULL(B.CancelStatus,'')='Canceled' OR BG.CurrentStatus !='CheckOut') AND 
  BP.PropertyType='ExP' AND
  B.BookingLevel='Room' AND CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
  CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103);
  -- Canceled Booking : End
  -- Check Out Booking : Begin
  CREATE TABLE #TMPTABLE(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalLuxuryTax DECIMAL(27,2),
  TotalServiceTax DECIMAL(27,2),BookingCode INT,BookingId INT,
  StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),GuestId INT,
  ClientName NVARCHAR(100),ClientId INT,RoomCaptured INT,CheckOutHdrId INT);
  INSERT INTO #TMPTABLE(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalLuxuryTax,TotalServiceTax,BookingCode,BookingId,
  StayDuration,PODate,BookingStatus,Guest,GuestId,ClientName,ClientId,
  RoomCaptured,CheckOutHdrId)
  SELECT BP.PropertyId,P.PropertyName,B.PONo,B.PONoId,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
  ISNULL(DATEDIFF(DAY,CONVERT(DATE,CO.CheckInDate,103),
  CONVERT(DATE,CO.CheckOutDate,103)),0) AS Used,
  ISNULL(DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) - 
  DATEDIFF(DAY,CONVERT(DATE,CO.CheckInDate,103),
  CONVERT(DATE,CO.CheckOutDate,103)),0) AS Unused,
  BG.Tariff AS RatePerDay,
  ISNULL(CO.LTAgreedAmount,0)+ISNULL(CO.LTRackAmount,0) AS TotalLuxuryTax,
  ISNULL(CO.STAgreedAmount,0)+ISNULL(CO.STRackAmount,0) AS TotalServiceTax,    
  B.BookingCode,B.Id AS BookingId,
  ISNULL(CONVERT(VARCHAR(100),CONVERT(DATE,CO.CheckInDate,103),103)+' - '+
  CONVERT(VARCHAR(100),CONVERT(DATE,BG.ChkOutDt,103),103),'') AS StayDuration,
  CONVERT(VARCHAR(100),BG.CreatedDate,103) AS PODate,
  BG.CurrentStatus AS BookingStatus,
  CG.FirstName+' '+CG.LastName AS Guest,BG.GuestId,C.ClientName,B.ClientId,
  BG.RoomCaptured,ISNULL(BG.CheckOutHdrId,0)
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON 
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK)ON
  CG.CltmgntId=C.Id AND CG.CltmgntId=B.ClientId AND CG.Id=BG.GuestId
  LEFT OUTER JOIN WRBHBChechkOutHdr CO WITH(NOLOCK)ON 
  CO.BookingId=B.Id AND CO.Id=BG.CheckOutHdrId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND ISNULL(B.CancelStatus,'')='' AND 
  BP.PropertyType='ExP' AND B.BookingLevel='Room' AND 
  BG.CurrentStatus='CheckOut' AND CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
  CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103);
  --
  INSERT INTO #TABLE(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,Guest,GuestId,
  ClientName,ClientId,RoomCaptured,ChkOutId)
  SELECT PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,RatePerDay*Used AS TotalTariff,TotalLuxuryTax,
  TotalServiceTax,TotalLuxuryTax+TotalServiceTax AS TotalTax,
  RatePerDay * Used+TotalLuxuryTax+TotalServiceTax AS TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,Guest,GuestId,
  ClientName,ClientId,RoomCaptured,CheckOutHdrId FROM #TMPTABLE;
  -- Check Out Booking : End 
  CREATE TABLE #TABLE1(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingCode INT,
  BookingId INT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),ClientName NVARCHAR(100),ClientId INT,
  RoomCaptured INT,ChkOutId INT);
  INSERT INTO #TABLE1(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId)
  SELECT PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId FROM #TABLE
  GROUP BY PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId; 
  --
  CREATE TABLE #TABLE2(Guest NVARCHAR(100),BookingId INT,RoomCaptured INT);
  INSERT INTO #TABLE2(Guest,BookingId,RoomCaptured)
  SELECT STUFF((SELECT ', ' + BA.Guest
  FROM #TABLE BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured
  FOR XML PATH('')),1,1,'') AS Guest,B.BookingId,B.RoomCaptured
  FROM #TABLE AS B
  GROUP BY B.BookingId,B.RoomCaptured;
  --
  CREATE TABLE #PO(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingId BIGINT,
  BookingCode BIGINT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),ClientName NVARCHAR(100),
  ClientId INT,RoomCaptured INT,ChkOutId BIGINT);
  INSERT INTO #PO(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingId,BookingCode,StayDuration,PODate,BookingStatus,Guest,ClientName,
  ClientId,RoomCaptured,ChkOutId)
  SELECT ISNULL(T1.PropertyId,0),ISNULL(T1.PropertyName,''),
  ISNULL(T1.PONo,''),ISNULL(T1.PONoId,0),ISNULL(T1.POQty,0),ISNULL(T1.Used,0),
  ISNULL(T1.Unused,0),ISNULL(T1.RatePerDay,0),ISNULL(T1.TotalTariff,0),
  ISNULL(T1.TotalLuxuryTax,0),ISNULL(T1.TotalServiceTax,0),
  ISNULL(T1.TotalTax,0),ISNULL(T1.TotalAmount,0),ISNULL(T2.BookingId,0),
  ISNULL(T1.BookingCode,0),ISNULL(T1.StayDuration,''),ISNULL(T1.PODate,''),
  ISNULL(T1.BookingStatus,''),ISNULL(T2.Guest,''),ISNULL(T1.ClientName,''),
  ISNULL(T1.ClientId,0),ISNULL(T2.RoomCaptured,0),ISNULL(T1.ChkOutId,0) 
  FROM #TABLE1 T1
  LEFT OUTER JOIN #TABLE2 T2 ON T1.BookingId=T2.BookingId
  WHERE T1.BookingId=T2.BookingId AND T1.RoomCaptured=T2.RoomCaptured;
  IF @PropertyId != 0
   BEGIN
    SELECT * FROM #PO WHERE PropertyId=@PropertyId ORDER BY PONoId ASC;
   END
  ELSE
   BEGIN
    SELECT * FROM #PO ORDER BY PONoId ASC;
   END  
 END
IF @Action = 'StayBased'
 BEGIN
  CREATE TABLE #TABLEStay(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingCode INT,
  BookingId INT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),GuestId INT,
  ClientName NVARCHAR(100),ClientId INT,RoomCaptured INT,ChkOutId INT,
  ChkInDt DATE);
  INSERT INTO #TABLEStay(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,Guest,GuestId,
  ClientName,ClientId,RoomCaptured,ChkOutId,ChkInDt)
  SELECT BP.PropertyId,P.PropertyName,B.PONo,B.PONoId,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,0 AS Used,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS Unused,BG.Tariff AS RatePerDay,
  0 AS TotalTariff,0 AS TotalLuxuryTax,0 AS TotalServiceTax,0 AS TotalTax,
  0 AS TotalAmount,B.BookingCode,B.Id AS BookingId,
  CONVERT(VARCHAR(100),BG.ChkInDt,103)+' - '+
  CONVERT(VARCHAR(100),BG.ChkOutDt,103) AS StayDuration,
  CONVERT(VARCHAR(100),BG.CreatedDate,103) AS PODate,
  BG.CurrentStatus AS BookingStatus,CG.FirstName+' '+CG.LastName AS Guest,
  BG.GuestId,C.ClientName,B.ClientId,BG.RoomCaptured,0,BG.ChkInDt
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON 
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK)ON
  CG.CltmgntId=C.Id AND CG.CltmgntId=B.ClientId AND CG.Id=BG.GuestId
  WHERE --ISNULL(B.CancelStatus,'')='Canceled' AND 
  BP.PropertyType='ExP' AND
  (ISNULL(B.CancelStatus,'')='Canceled' OR BG.CurrentStatus !='CheckOut') AND 
  B.BookingLevel='Room' AND BG.ChkInDt BETWEEN 
  CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103)
  ORDER BY B.PONoId ASC;
  -- Check Out Booking : Begin
  CREATE TABLE #TMPTABLEStay(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalLuxuryTax DECIMAL(27,2),
  TotalServiceTax DECIMAL(27,2),BookingCode INT,BookingId INT,
  StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),GuestId INT,
  ClientName NVARCHAR(100),ClientId INT,RoomCaptured INT,CheckOutHdrId INT,
  ChkInDt DATE);
  INSERT INTO #TMPTABLEStay(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalLuxuryTax,TotalServiceTax,BookingCode,BookingId,
  StayDuration,PODate,BookingStatus,Guest,GuestId,ClientName,ClientId,
  RoomCaptured,CheckOutHdrId,ChkInDt)
  SELECT BP.PropertyId,P.PropertyName,B.PONo,B.PONoId,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
  ISNULL(DATEDIFF(DAY,CONVERT(DATE,CO.CheckInDate,103),
  CONVERT(DATE,CO.CheckOutDate,103)),0) AS Used,
  ISNULL(DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) - 
  DATEDIFF(DAY,CONVERT(DATE,CO.CheckInDate,103),
  CONVERT(DATE,CO.CheckOutDate,103)),0) AS Unused,
  BG.Tariff AS RatePerDay,
  ISNULL(CO.LTAgreedAmount,0)+ISNULL(CO.LTRackAmount,0) AS TotalLuxuryTax,
  ISNULL(CO.STAgreedAmount,0)+ISNULL(CO.STRackAmount,0) AS TotalServiceTax,    
  B.BookingCode,B.Id AS BookingId,
  ISNULL(CONVERT(VARCHAR(100),CONVERT(DATE,CO.CheckInDate,103),103)+' - '+
  CONVERT(VARCHAR(100),CONVERT(DATE,BG.ChkOutDt,103),103),'') AS StayDuration,
  CONVERT(VARCHAR(100),BG.CreatedDate,103) AS PODate,
  BG.CurrentStatus AS BookingStatus,
  CG.FirstName+' '+CG.LastName AS Guest,BG.GuestId,C.ClientName,B.ClientId,
  BG.RoomCaptured,ISNULL(BG.CheckOutHdrId,0),BG.ChkInDt
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON 
  BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK)ON
  CG.CltmgntId=C.Id AND CG.CltmgntId=B.ClientId AND CG.Id=BG.GuestId
  LEFT OUTER JOIN WRBHBChechkOutHdr CO WITH(NOLOCK)ON 
  CO.BookingId=B.Id AND CO.Id=BG.CheckOutHdrId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BG.IsActive=1 AND 
  BG.IsDeleted=0 AND ISNULL(B.CancelStatus,'')='' AND 
  BP.PropertyType='ExP' AND B.BookingLevel='Room' AND 
  BG.CurrentStatus='CheckOut' AND CONVERT(DATE,CO.CheckInDate,103) BETWEEN 
  CONVERT(DATE,@ChkInDt,103) AND CONVERT(DATE,@ChkOutDt,103);
  --
  INSERT INTO #TABLEStay(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,Guest,GuestId,
  ClientName,ClientId,RoomCaptured,ChkOutId,ChkInDt)
  SELECT PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,RatePerDay*Used AS TotalTariff,TotalLuxuryTax,
  TotalServiceTax,TotalLuxuryTax+TotalServiceTax AS TotalTax,
  RatePerDay * Used+TotalLuxuryTax+TotalServiceTax AS TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,Guest,GuestId,
  ClientName,ClientId,RoomCaptured,CheckOutHdrId,ChkInDt FROM #TMPTABLEStay;
  -- Check Out Booking : End
  CREATE TABLE #TABLE1Stay(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingCode INT,
  BookingId INT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),ClientName NVARCHAR(100),ClientId INT,
  RoomCaptured INT,ChkOutId INT,ChkInDt DATE);
  INSERT INTO #TABLE1Stay(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId,ChkInDt)
  SELECT PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId,ChkInDt
  FROM #TABLEStay
  GROUP BY PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingCode,BookingId,StayDuration,PODate,BookingStatus,
  ClientName,ClientId,RoomCaptured,ChkOutId,ChkInDt; 
  --
  CREATE TABLE #TABLE2Stay(Guest NVARCHAR(100),BookingId INT,RoomCaptured INT);
  INSERT INTO #TABLE2Stay(Guest,BookingId,RoomCaptured)
  SELECT STUFF((SELECT ', ' + BA.Guest
  FROM #TABLEStay BA 
  WHERE BA.BookingId=B.BookingId AND BA.RoomCaptured=B.RoomCaptured
  FOR XML PATH('')),1,1,'') AS Guest,B.BookingId,B.RoomCaptured
  FROM #TABLEStay AS B
  GROUP BY B.BookingId,B.RoomCaptured;
  --
  CREATE TABLE #Stay(PropertyId INT,PropertyName NVARCHAR(100),
  PONo NVARCHAR(100),PONoId INT,POQty INT,Used INT,Unused INT,
  RatePerDay DECIMAL(27,2),TotalTariff DECIMAL(27,2),
  TotalLuxuryTax DECIMAL(27,2),TotalServiceTax DECIMAL(27,2),
  TotalTax DECIMAL(27,2),TotalAmount DECIMAL(27,2),BookingId BIGINT,
  BookingCode BIGINT,StayDuration NVARCHAR(100),PODate NVARCHAR(100),
  BookingStatus NVARCHAR(100),Guest NVARCHAR(100),ClientName NVARCHAR(100),
  ClientId INT,RoomCaptured INT,ChkOutId BIGINT,ChkInDt DATE);
  INSERT INTO #Stay(PropertyId,PropertyName,PONo,PONoId,POQty,Used,Unused,
  RatePerDay,TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
  BookingId,BookingCode,StayDuration,PODate,BookingStatus,Guest,ClientName,
  ClientId,RoomCaptured,ChkOutId,ChkInDt)
  SELECT ISNULL(T1.PropertyId,0),ISNULL(T1.PropertyName,''),
  ISNULL(T1.PONo,''),ISNULL(T1.PONoId,0),ISNULL(T1.POQty,0),ISNULL(T1.Used,0),
  ISNULL(T1.Unused,0),ISNULL(T1.RatePerDay,0),ISNULL(T1.TotalTariff,0),
  ISNULL(T1.TotalLuxuryTax,0),ISNULL(T1.TotalServiceTax,0),
  ISNULL(T1.TotalTax,0),ISNULL(T1.TotalAmount,0),ISNULL(T2.BookingId,0),
  ISNULL(T1.BookingCode,0),ISNULL(T1.StayDuration,''),ISNULL(T1.PODate,''),
  ISNULL(T1.BookingStatus,''),ISNULL(T2.Guest,''),ISNULL(T1.ClientName,''),
  ISNULL(T1.ClientId,0),ISNULL(T2.RoomCaptured,0),ISNULL(T1.ChkOutId,0),
  CONVERT(NVARCHAR,CONVERT(DATE,T1.ChkInDt,103),110) AS ChkInDt
  FROM #TABLE1Stay T1
  LEFT OUTER JOIN #TABLE2Stay T2 ON T1.BookingId=T2.BookingId
  WHERE T1.BookingId=T2.BookingId AND T1.RoomCaptured=T2.RoomCaptured;
  --
  IF @PropertyId != 0
   BEGIN
    SELECT * FROM #Stay WHERE PropertyId=@PropertyId ORDER BY ChkInDt ASC;
   END
  ELSE
   BEGIN
    SELECT * FROM #Stay ORDER BY ChkInDt ASC;
   END  
 END
END
/* BEGIN
  CREATE TABLE #TEMP(PropertyName NVARCHAR(100),PONoId BIGINT,PONo NVARCHAR(100),
  POQty INT,Used INT,UnUsed INT,TariffPerDay DECIMAL(27,2),
  TotalTariff DECIMAL(27,2),TotalLuxuryTax DECIMAL(27,2),
  TotalServiceTax DECIMAL(27,2),TotalTax DECIMAL(27,2),
  TotalAmount DECIMAL(27,2),BookingCode NVARCHAR(100),ChkInDt DATE,
  ChkOutDt DATE,StayDuration NVARCHAR(100),PODate DATE,Status NVARCHAR(100),
  GuestName NVARCHAR(100),ClientName NVARCHAR(100),BookingId BIGINT,
  BookingPropertyId BIGINT,GuestId BIGINT,RoomCaptured BIGINT);
  IF @Str3 = 'PO'
   BEGIN
    -- Cancelled
    INSERT INTO #TEMP(PropertyName,PONoId,PONo,POQty,Used,UnUsed,TariffPerDay,
    TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
    BookingCode,ChkInDt,ChkOutDt,StayDuration,PODate,Status,GuestName,
    ClientName,BookingId,BookingPropertyId,GuestId,RoomCaptured)
    SELECT P.PropertyName,B.PONoId,B.PONo,
	DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,0 AS Used,0 AS UnUsed,
	BG.Tariff AS TariffPerDay,0 AS TotalTariff,0 AS TotalLuxuryTax,
	0 AS TotalServiceTax,0 AS TotalTax,0 AS TotalAmount,B.BookingCode,
	BG.ChkInDt,BG.ChkOutDt,
	CAST(BG.ChkInDt AS VARCHAR)+' - '+CAST(BG.ChkOutDt AS VARCHAR) 
	AS StayDuration,
	CONVERT(DATE,BG.CreatedDate,103) AS PODate,
	B.CancelStatus,CG.FirstName+' '+CG.LastName AS GuestName,
	C.ClientName,BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.RoomCaptured
	FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
	WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
	LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
	LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
	LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
	WITH(NOLOCK)ON CG.CltmgntId=C.Id AND CG.Id=BG.GuestId
	WHERE B.CancelStatus='Canceled' AND B.BookingLevel='Room' AND
	CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
	CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
	BP.PropertyType='ExP' ORDER BY B.PONoId;
	-- Check Out Booking Id
	CREATE TABLE #TMPCHKOUT(BookingId BIGINT);
	INSERT INTO #TMPCHKOUT(BookingId)
	SELECT B.Id FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
	WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id	
	WHERE B.CancelStatus != 'Canceled' AND B.BookingLevel='Room' AND
	CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
	CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103) AND
	BP.PropertyType='ExP' GROUP BY B.Id;
	-- CheckOut Date, Tax & Tariff
	CREATE TABLE #TMPCO(BookingId BIGINT,GuestName NVARCHAR(100),
	ChkInDt DATE,ChkOutDt DATE,PropertyId BIGINT);
	INSERT INTO #TMPCO(BookingId,GuestName,ChkInDt,ChkOutDt,PropertyId)
	SELECT T.BookingId,CIH.GuestName,CIH.ArrivalDate,
	CONVERT(DATE,COH.BillDate,103),CIH.PropertyId FROM #TMPCHKOUT T	
	LEFT OUTER JOIN WRBHBCheckInHdr CIH WITH(NOLOCK)ON
	CIH.BookingId=T.BookingId
	LEFT OUTER JOIN WRBHBChechkOutHdr COH WITH(NOLOCK)ON 
	COH.BookingId=T.BookingId AND COH.ChkInHdrId=CIH.Id
	WHERE CIH.BookingId=T.BookingId AND COH.BookingId=T.BookingId;
	--
	SELECT B.BookingCode,DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
	DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS Used,
	(CAST(DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS INT)-
	CAST(DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS INT)) AS UnUsed 
	FROM #TMPCO T
	LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id=T.BookingId
	LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
	P.Id=T.PropertyId
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
	BG.BookingId=B.Id AND BG.BookingPropertyId=P.Id
	LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON
	C.Id=B.ClientId
	---
	SELECT P.PropertyName,B.PONoId,B.PONo,
	DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,0 AS Used,0 AS UnUsed,
	BG.Tariff AS TariffPerDay,0 AS TotalTariff,0 AS TotalLuxuryTax,
	0 AS TotalServiceTax,0 AS TotalTax,0 AS TotalAmount,B.BookingCode,
	BG.ChkInDt,BG.ChkOutDt,
	CAST(BG.ChkInDt AS VARCHAR)+' - '+CAST(BG.ChkOutDt AS VARCHAR) 
	AS StayDuration,
	CONVERT(DATE,BG.CreatedDate,103) AS PODate,
	B.CancelStatus,CG.FirstName+' '+CG.LastName AS GuestName,
	C.ClientName,BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.RoomCaptured
	FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
	LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
	WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
	LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
	LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
	LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG
	WITH(NOLOCK)ON CG.CltmgntId=C.Id AND CG.Id=BG.GuestId
	WHERE B.CancelStatus != 'Canceled' AND B.BookingLevel='Room' AND
	CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
	CONVERT(DATE,@Str1,103) AND CONVERT(DATE,@Str2,103) AND
	BP.PropertyType='ExP';
   END
  ELSE
   BEGIN
    INSERT INTO #TEMP(PropertyName,PONoId,PONo,POQty,Used,UnUsed,TariffPerDay,
    TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,TotalAmount,
    BookingCode,ChkInDt,ChkOutDt,StayDuration,PODate,Status,GuestName,
    ClientName,BookingId,BookingPropertyId,GuestId,RoomCaptured)
    SELECT P.PropertyName,B.PONoId,B.PONo,
    DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,0 AS Used,0 AS UnUsed,
    BG.Tariff AS TariffPerDay,0 AS TotalTariff,0 AS TotalLuxuryTax,
    0 AS TotalServiceTax,0 AS TotalTax,0 AS TotalAmount,B.BookingCode,
    BG.ChkInDt,BG.ChkOutDt,
    CAST(BG.ChkInDt AS VARCHAR)+' - '+CAST(BG.ChkOutDt AS VARCHAR) 
    AS StayDuration,CONVERT(DATE,BG.CreatedDate,103) AS PODate,
    B.CancelStatus,CG.FirstName+' '+CG.LastName AS GuestName,
    C.ClientName,BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.RoomCaptured
    FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
    WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG 
    WITH(NOLOCK)ON CG.CltmgntId=C.Id AND CG.Id=BG.GuestId
    WHERE B.CancelStatus='Canceled' AND B.BookingLevel='Room' AND
    BG.ChkInDt BETWEEN CONVERT(DATE,@Str1,103) AND 
    CONVERT(DATE,@Str2,103) AND BP.PropertyType='ExP' 
    ORDER BY B.PONoId;
   END
  IF @Id1 = 0
   BEGIN
    SELECT * FROM #TEMP;
   END
  ELSE
   BEGIN
    SELECT * FROM #TEMP WHERE BookingPropertyId=@Id1;
   END
 END 
IF @Action = 'PageLoad'
 BEGIN
  
  CREATE TABLE #TMPBookingId(BookingId BIGINT,PODt DATE);
  INSERT INTO #TMPBookingId(BookingId,PODt)
  SELECT B.Id,CONVERT(DATE,BG.CreatedDate,103) FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
  WITH(NOLOCK)ON BG.BookingId=B.Id
  WHERE BP.PropertyType='ExP' AND CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103)
  GROUP BY B.Id,BG.CreatedDate ORDER BY BG.CreatedDate;
  --------------
  SELECT P.PropertyName,P.Id,B.PONo,B.Id,
DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
BG.Tariff,BG.RoomCaptured,

B.BookingCode,CONVERT(DATE,BG.CreatedDate,103),B.ClientId,
  B.PONo,B.BookingCode,B.CheckInDate,B.CheckOutDate
   FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG 
  WITH(NOLOCK)ON BG.BookingId=B.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=BP.PropertyId
  WHERE BP.PropertyType='ExP' AND CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103)
  ORDER BY BG.CreatedDate;
  ---------- Final Select ( oproximate)  
  SELECT B.BookingCode,BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.Tariff,
  DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,BG.RoomCaptured
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  WHERE CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
  CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103) AND
  BP.PropertyType='ExP';
  --- 01 july 
  SELECT P.PropertyName,B.PONo,DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
0 AS Used,0 AS UnUsed,BG.Tariff AS TariffPerDay,
CAST(DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS INT) * BG.Tariff AS
TotalTariff,0 AS TotalLuxuryTax,0 AS TotalServiceTax,
0 AS TotalTax,0 AS TotalAmount,B.BookingCode,
CAST(BG.ChkInDt AS VARCHAR)+' - '+CAST(BG.ChkOutDt AS VARCHAR) AS StayDuration,
CONVERT(VARCHAR,BG.CreatedDate,103) AS PODate,B.Status,
CG.FirstName+' '+CG.LastName AS GuestName,
C.ClientName,
BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.RoomCaptured  
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId=B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
  WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
  LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
  P.Id = BG.BookingPropertyId
  LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
  LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG 
  WITH(NOLOCK)ON CG.CltmgntId=C.Id AND CG.Id=BG.GuestId  
  WHERE CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
  CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103) AND
  BP.PropertyType='ExP' ORDER BY B.PONoId;
  -- 2nd July
  CREATE TABLE #TMP(PropertyName NVARCHAR(100),PONo NVARCHAR(100),
POQty INT,Used INT,UnUsed INT,TariffPerDay DECIMAL(27,2),
TotalTariff DECIMAL(27,2),TotalLuxuryTax DECIMAL(27,2),
TotalServiceTax DECIMAL(27,2),TotalTax DECIMAL(27,2),
TotalAmount DECIMAL(27,2),BookingCode NVARCHAR(100),
StayDuration NVARCHAR(100),PODate NVARCHAR(100),
Status NVARCHAR(100),GuestName NVARCHAR(100),
ClientName NVARCHAR(100),BookingId BIGINT,
BookingPropertyId BIGINT,GuestId BIGINT,RoomCaptured BIGINT);
INSERT INTO #TMP(PropertyName,PONo,POQty,Used,UnUsed,TariffPerDay,
TotalTariff,TotalLuxuryTax,TotalServiceTax,TotalTax,
TotalAmount,BookingCode,StayDuration,PODate,Status,GuestName,
ClientName,BookingId,BookingPropertyId,GuestId,RoomCaptured)
SELECT P.PropertyName,B.PONo,DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS POQty,
0 AS Used,0 AS UnUsed,BG.Tariff AS TariffPerDay,
CAST(DATEDIFF(DAY,BG.ChkInDt,BG.ChkOutDt) AS INT) * BG.Tariff AS
TotalTariff,0 AS TotalLuxuryTax,0 AS TotalServiceTax,
0 AS TotalTax,0 AS TotalAmount,B.BookingCode,
CAST(BG.ChkInDt AS VARCHAR)+' - '+CAST(BG.ChkOutDt AS VARCHAR) AS StayDuration,
CONVERT(VARCHAR,BG.CreatedDate,103) AS PODate,B.Status,
CG.FirstName+' '+CG.LastName AS GuestName,
C.ClientName,BG.BookingId,BG.BookingPropertyId,BG.GuestId,BG.RoomCaptured
FROM WRBHBBooking B
LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
BP.BookingId=B.Id
LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG
WITH(NOLOCK)ON BG.BookingId=B.Id AND BG.BookingPropertyTableId=BP.Id
LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON 
P.Id = BG.BookingPropertyId
LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id=B.ClientId
LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG 
WITH(NOLOCK)ON CG.CltmgntId=C.Id AND CG.Id=BG.GuestId  
WHERE CONVERT(DATE,BG.CreatedDate,103) BETWEEN 
CONVERT(DATE,'01/06/2014',103) AND CONVERT(DATE,'30/06/2014',103) AND
BP.PropertyType='ExP' ORDER BY B.PONoId;
 END
END
*/