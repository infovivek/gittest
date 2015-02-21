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
-- ModifiedBy :Anbu, ModifiedDate:01/01/2015
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
	IF @StartDt = ''
	   BEGIN
		SET @StartDt=CONVERT(VARCHAR(100),DATEADD(DAY,-1,GETDATE()),103);
		SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt,@StartDt AS FrmDt;
		SELECT ClientName,Id FROM WRBHBClientManagement 
		WHERE IsActive=1 AND IsDeleted=0;
		EXEC [dbo].[BookingReport] 'BookingDtls',@StartDt,@StartDt,@ClientId;    
	   END
	  ELSE
	   BEGIN
		EXEC [dbo].[BookingReport] 'BookingDtls',@StartDt,@EndDt,@ClientId;
	   END  
	 END
 END
IF @Action = 'BookingDtls'
 BEGIN
  CREATE TABLE #TMP(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt DATE,
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100));
  --
  CREATE TABLE #TariffDivision(RoomCapturedCnt INT,RoomCaptured BIGINT,
  BookingId BIGINT,GuestId BIGINT,Tariff DECIMAL(27,2),
  DividedTariff DECIMAL(27,2));
  --
  CREATE TABLE #Result(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt DATE,
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),SNo BIGINT IDENTITY(1,1));
  IF @ClientId = 0
   BEGIN
    -- Property & Contract - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    
    -- Property & Contract - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - CheckOut,Booked & CheckIn - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel;
    -- Property & Contract - Canceled & No Show - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - CheckOut,Booked & CheckIn - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)   
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - Canceled & No Show - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND 
    BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- API - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103)
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- API - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN
    CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
    B.BookingCode != 0
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel;
    -- Tariff Division
    INSERT INTO #TariffDivision(RoomCapturedCnt,RoomCaptured,BookingId,GuestId,
    Tariff,DividedTariff)
    SELECT COUNT(RoomCaptured),RoomCaptured,BookingId,GuestId,Tariff,
    ROUND(Tariff / CAST(COUNT(RoomCaptured) AS INT),0)
    FROM #TMP GROUP BY RoomCaptured,BookingId,GuestId,Tariff;
    --
    --SELECT COUNT(*) FROM #TMP;
    --SELECT COUNT(*) FROM #TariffDivision;
    -- Result
    INSERT INTO #Result(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,StayDays,TotTarif,TariffPaymentMode,
    RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel)
    SELECT T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,CASE
    WHEN T.PropertyType = 'ExP' THEN 'External'
    WHEN T.PropertyType = 'InP' THEN 'Internal'
    WHEN T.PropertyType = 'MGH' THEN 'G H'
    WHEN T.PropertyType = 'CPP' THEN 'C P P'
    WHEN T.PropertyType = 'DdP' THEN 'Dedicated'
    WHEN T.PropertyType = 'MMT' THEN 'M M T' END AS PropertyType,
    T.PropertyId,T.CityName,T.CityId,T.GuestName,T1.GuestId,T.ChkInDt,T.ChkOutDt,
    T1.DividedTariff,DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS StayDays,
    T1.DividedTariff * DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS TotTarif,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel FROM #TMP T
    LEFT OUTER JOIN #TariffDivision T1 WITH(NOLOCK)ON 
    T.BookingId = T1.BookingId AND T.GuestId = T1.GuestId AND
    T.RoomCaptured = T1.RoomCaptured
    GROUP BY T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,T.PropertyType,T.PropertyId,T.CityName,T.CityId,
    T.GuestName,T1.GuestId,T.ChkInDt,T.ChkOutDt,T1.DividedTariff,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel;
     
   
   END
  
  ELSE
   BEGIN
   
    -- Property & Contract - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('Property','Contract') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - CheckOut,Booked & CheckIn - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel;
    -- Property & Contract - Canceled & No Show - Bed
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,BG.Id,
    BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBedBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBedBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Bed' AND BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND 
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.Id,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - CheckOut,Booked & CheckIn - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND BP.GetType IN ('Property','Contract') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- Property & Contract - Canceled & No Show - Apartment
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.PropertyName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBApartmentBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Apartment' AND 
    BP.GetType IN ('Property','Contract') AND
    ISNULL(BG.RoomShiftingFlag,0) = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.PropertyName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.ApartmentId,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    -- API - CheckOut,Booked & CheckIn - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,
    CONVERT(DATE,B.BookedDt,103),ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.IsActive = 1 AND BG.IsDeleted = 0 AND B.BookingCode != 0 AND 
    BG.CurrentStatus IN ('CheckOut','Booked','CheckIn') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel;
    
   
    -- API - Canceled & No Show - Room
    INSERT INTO #TMP(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,TariffPaymentMode,RoomCaptured,CurrentStatus,
    BookerName,BookedDt,Column1,Column2,Column3,Column4,Column5,Column6,
    Column7,Column8,Column9,Column10,BookingLevel)
    SELECT B.BookingCode,B.Id,ISNULL(MC.ClientName,C.ClientName),C.ClientName,
    B.ClientId,U.FirstName,P.HotalName,BP.PropertyType,BP.PropertyId,
    Cty.CityName,B.CityId,CCG.FirstName+' '+CCG.LastName,BG.GuestId,
    MIN(BG.ChkInDt),MAX(BG.ChkOutDt),BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,CONVERT(DATE,B.BookedDt,103),
    ISNULL(BG.Column1,''),ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),
    ISNULL(BG.Column4,''),ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),
    ISNULL(BG.Column7,''),ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),
    ISNULL(BG.Column10,''),B.BookingLevel FROM WRBHBBooking B
    LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
    BP.BookingId = B.Id
    LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
    BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
    BG.BookingPropertyId = BP.PropertyId
    LEFT OUTER JOIN WRBHBClientManagement C WITH(NOLOCK)ON C.Id = B.ClientId
    LEFT OUTER JOIN WRBHBMasterClientManagement MC WITH(NOLOCK)ON
    MC.Id = C.MasterClientId
    LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id = C.CRMId
    LEFT OUTER JOIN WRBHBCity Cty WITH(NOLOCK)ON Cty.Id = B.CityId
    LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CCG WITH(NOLOCK)ON
    CCG.CltmgntId = B.ClientId AND CCG.Id = BG.GuestId
    LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
    P.HotalId = BG.BookingPropertyId
    LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON U1.Id = B.BookedUsrId
    WHERE B.BookingLevel = 'Room' AND BP.GetType IN ('API') AND
    BG.RoomShiftingFlag = 0 AND BG.CurrentStatus IN ('Canceled','No Show') AND
    CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
    CONVERT(DATE,@EndDt,103) AND B.BookingCode != 0 AND B.ClientId = @ClientId
    GROUP BY B.BookingCode,B.Id,MC.ClientName,C.ClientName,B.ClientId,U.FirstName,
    P.HotalName,BP.PropertyType,BP.PropertyId,Cty.CityName,B.CityId,
    CCG.FirstName,CCG.LastName,BG.GuestId,BG.Tariff,BG.TariffPaymentMode,
    BG.RoomCaptured,BG.CurrentStatus,U1.UserName,B.BookedDt,ISNULL(BG.Column1,''),
    ISNULL(BG.Column2,''),ISNULL(BG.Column3,''),ISNULL(BG.Column4,''),
    ISNULL(BG.Column5,''),ISNULL(BG.Column6,''),ISNULL(BG.Column7,''),
    ISNULL(BG.Column8,''),ISNULL(BG.Column9,''),ISNULL(BG.Column10,''),
    B.BookingLevel;
    -- Tariff Division
    INSERT INTO #TariffDivision(RoomCapturedCnt,RoomCaptured,BookingId,GuestId,
    Tariff,DividedTariff)
    SELECT COUNT(RoomCaptured),RoomCaptured,BookingId,GuestId,Tariff,
    ROUND(Tariff / CAST(COUNT(RoomCaptured) AS INT),0)
    FROM #TMP GROUP BY RoomCaptured,BookingId,GuestId,Tariff;
    --
    --SELECT COUNT(*) FROM #TMP;
    --SELECT COUNT(*) FROM #TariffDivision;
    -- Result
    INSERT INTO #Result(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
    CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
    GuestId,ChkInDt,ChkOutDt,Tariff,StayDays,TotTarif,TariffPaymentMode,
    RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
    Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel)
    SELECT T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,CASE
    WHEN T.PropertyType = 'ExP' THEN 'External'
    WHEN T.PropertyType = 'InP' THEN 'Internal'
    WHEN T.PropertyType = 'MGH' THEN 'G H'
    WHEN T.PropertyType = 'CPP' THEN 'C P P'
    WHEN T.PropertyType = 'DdP' THEN 'Dedicated'
    WHEN T.PropertyType = 'MMT' THEN 'M M T' END AS PropertyType,
    T.PropertyId,T.CityName,T.CityId,T.GuestName,T1.GuestId,T.ChkInDt,T.ChkOutDt,
    T1.DividedTariff,DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS StayDays,
    T1.DividedTariff * DATEDIFF(DAY,T.ChkInDt,T.ChkOutDt) AS TotTarif,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel FROM #TMP T
    LEFT OUTER JOIN #TariffDivision T1 WITH(NOLOCK)ON 
    T.BookingId = T1.BookingId AND T.GuestId = T1.GuestId AND
    T.RoomCaptured = T1.RoomCaptured
    GROUP BY T.BookingCode,T1.BookingId,T.MasterClientName,T.ClientName,T.ClientId,
    T.CRMName,T.PropertyName,T.PropertyType,T.PropertyId,T.CityName,T.CityId,
    T.GuestName,T1.GuestId,T.ChkInDt,T.ChkOutDt,T1.DividedTariff,
    T.TariffPaymentMode,T1.RoomCaptured,T.CurrentStatus,T.BookerName,
    T.BookedDt,T.Column1,T.Column2,T.Column3,T.Column4,T.Column5,T.Column6,
    T.Column7,T.Column8,T.Column9,T.Column10,T.BookingLevel;
   END


  CREATE TABLE #Final(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),Markup DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt NVARCHAR(100),
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),Occupancy NVARCHAR(100))
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Direct' AND BG.Occupancy='Single'
  ORDER BY BookingCode,RoomCaptured;
  
  
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Direct' AND BG.Occupancy='Double'
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Direct' AND BG.Occupancy='Triple'
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,
  (R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100+R.Tariff*BG.STonAgreed/100),
  (BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Single' AND ISNULL(BP.ExpWithTax,0)=0
  ORDER BY BookingCode,RoomCaptured;
  
   
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,
  R.Tariff,(BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Single' AND ISNULL(BP.ExpWithTax,0)=1
  ORDER BY BookingCode,RoomCaptured;
 
 
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100
  +R.Tariff*BG.STonAgreed/100 AS Tariff,
  (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Double' AND ISNULL(BP.ExpWithTax,0)=0
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,
  (BP.DoubleandMarkup1-BP.DoubleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Double' AND ISNULL(BP.ExpWithTax,0)=1
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+R.Tariff*BG.LTonAgreed/100+R.Tariff*BG.LTonRack/100
  +R.Tariff*BG.STonAgreed/100 AS Tariff,(BP.TripleandMarkup1-Bp.TripleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Triple' AND ISNULL(BP.ExpWithTax,0)=0
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.TripleandMarkup1-Bp.TripleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='External' AND R.TariffPaymentMode='Bill to Company (BTC)' AND BG.Occupancy='Triple' AND ISNULL(BP.ExpWithTax,0)=1
  AND R.RoomCaptured=BG.RoomCaptured
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
  
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff+ 
  R.Tariff*ISNULL(BG.LTonAgreed,0)/100+ R.Tariff*ISNULL(BG.STonAgreed,0)/100
  +R.Tariff*ISNULL(BG.LTonRack,0)/100 AS Tariff,0 AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='C P P' AND ISNULL(BP.ExpWithTax,0)=0
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
  
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,R.ClientName AS ClientName,R.ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,0 AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  WHERE R.PropertyType='C P P' AND ISNULL(BP.ExpWithTax,0)=1
  ORDER BY BookingCode,RoomCaptured;
  
  
  
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
  
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.SingleandMarkup1-BP.SingleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  LEFT OUTER JOIN WRBHBStaticHotels ST ON Bp.PropertyId=ST.Id AND ST.IsActive=1
  WHERE R.PropertyType='M M T' AND BG.Occupancy='Single'
  ORDER BY BookingCode,RoomCaptured;
 
  
   
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,
  (BP.DoubleandMarkup1-Bp.DoubleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy  FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  LEFT OUTER JOIN WRBHBStaticHotels ST ON Bp.PropertyId=ST.Id AND ST.IsActive=1
  WHERE R.PropertyType='M M T' AND BG.Occupancy='Double'
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
   
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,(BP.TripleandMarkup1-BP.TripleTariff) AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,BG.Occupancy FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BG.RoomType=BP.RoomType AND BP.IsActive=1
  LEFT OUTER JOIN WRBHBStaticHotels ST ON Bp.PropertyId=ST.Id AND ST.IsActive=1
  WHERE R.PropertyType='M M T'  AND BG.Occupancy='Triple'
  ORDER BY BookingCode,RoomCaptured;
  
  INSERT INTO #Final(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,Occupancy)
  
  SELECT DISTINCT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,0 AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,'Single' FROM #Result R
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG ON R.BookingId=BG.BookingId AND R.GuestId=BG.GuestId AND BG.IsActive=1
  LEFT OUTER JOIN WRBHBBookingProperty BP ON R.BookingId=BP.BookingId AND BP.IsActive=1
  WHERE R.PropertyType NOT IN('External','C P P','M M T')
  ORDER BY BookingCode,RoomCaptured;
  
  CREATE TABLE #FinalResult(BookingCode BIGINT,BookingId BIGINT,
  MasterClientName NVARCHAR(100),ClientName NVARCHAR(100),ClientId BIGINT,
  CRMName NVARCHAR(100),PropertyName NVARCHAR(100),PropertyType NVARCHAR(100),
  PropertyId BIGINT,CityName NVARCHAR(100),CityId BIGINT,
  GuestName NVARCHAR(100),GuestId BIGINT,ChkInDt DATE,ChkOutDt DATE,
  Tariff DECIMAL(27,2),Markup DECIMAL(27,2),StayDays INT,TotTarif DECIMAL(27,2),
  TariffPaymentMode NVARCHAR(100),RoomCaptured BIGINT,
  CurrentStatus NVARCHAR(100),BookerName NVARCHAR(100),BookedDt NVARCHAR(100),
  Column1 NVARCHAR(100),Column2 NVARCHAR(100),Column3 NVARCHAR(100),
  Column4 NVARCHAR(100),Column5 NVARCHAR(100),Column6 NVARCHAR(100),
  Column7 NVARCHAR(100),Column8 NVARCHAR(100),Column9 NVARCHAR(100),
  Column10 NVARCHAR(100),BookingLevel NVARCHAR(100),SNo BIGINT IDENTITY(1,1),EmpCode NVARCHAR(100))
  
  INSERT INTO #FinalResult(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,Markup*StayDays AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,CG.EmpCode FROM #Final R
  JOIN WRBHBClientManagementAddClientGuest CG ON R.ClientId=CG.CltmgntId AND CG.IsActive=1
  WHERE R.PropertyType  IN('External','C P P','M M T') 
  GROUP BY BookingCode,R.BookingId,MasterClientName,ClientName,ClientId,
  R.CRMName,R.PropertyName,R.PropertyType,R.PropertyId,R.CityName,R.CityId,
  R.GuestName,R.GuestId,R.ChkInDt,R.ChkOutDt,R.Markup,R.StayDays,R.TotTarif,R.Tariff,
  R.TariffPaymentMode,R.RoomCaptured,R.CurrentStatus,R.BookerName,R.BookedDt,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel,CG.EmpCode
  ORDER BY BookingCode,RoomCaptured;
  
   
  
  INSERT INTO #FinalResult(BookingCode,BookingId,MasterClientName,ClientName,ClientId,
  CRMName,PropertyName,PropertyType,PropertyId,CityName,CityId,GuestName,
  GuestId,ChkInDt,ChkOutDt,Tariff,Markup,StayDays,TotTarif,TariffPaymentMode,
  RoomCaptured,CurrentStatus,BookerName,BookedDt,Column1,Column2,Column3,
  Column4,Column5,Column6,Column7,Column8,Column9,Column10,BookingLevel,EmpCode)
  
  SELECT BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  R.ChkInDt AS CheckInDt,R.ChkOutDt AS CheckOutDt,R.Tariff,Markup*StayDays AS Markup,
  StayDays AS StayDays,TotTarif AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,CG.EmpCode FROM #Final R
  JOIN WRBHBClientManagementAddClientGuest CG ON R.ClientId=CG.CltmgntId AND CG.IsActive=1
  AND R.GuestId=CG.Id
  WHERE  R.PropertyType NOT IN('External','C P P','M M T') 
  GROUP BY BookingCode,R.BookingId,MasterClientName,ClientName,ClientId,
  R.CRMName,R.PropertyName,R.PropertyType,R.PropertyId,R.CityName,R.CityId,
  R.GuestName,R.GuestId,R.ChkInDt,R.ChkOutDt,R.Markup,R.StayDays,R.TotTarif,R.Tariff,
  R.TariffPaymentMode,R.RoomCaptured,R.CurrentStatus,R.BookerName,R.BookedDt,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel,CG.EmpCode
  ORDER BY BookingCode,RoomCaptured;
  
  SELECT SNo AS SNo,BookingCode AS BookingCode,R.BookingId,
  MasterClientName AS MasterClientName,ClientName AS ClientName,ClientId,
  CRMName AS CRMName,R.PropertyName AS PropertyName,
  R.PropertyType AS PropertyCategory,R.PropertyId,CityName AS City,CityId,
  ISNULL(GuestName,'') AS GuestName,R.GuestId,
  CONVERT(NVARCHAR,R.ChkInDt,103) AS CheckInDt,CONVERT(NVARCHAR,R.ChkOutDt,103) AS CheckOutDt,ROUND(R.Tariff,0) AS Tariff,
  ISNULL(Markup,0) AS MarkUp,StayDays AS StayDays,ROUND(R.Tariff,0)*R.StayDays AS TotalTariff,
  R.TariffPaymentMode AS TariffPaymentMode,R.RoomCaptured,R.CurrentStatus AS Status,
  BookerName AS UserName,CONVERT(VARCHAR(100),BookedDt,103) AS BookingDate,
  R.Column1,R.Column2,R.Column3,R.Column4,R.Column5,R.Column6,R.Column7,R.Column8,R.Column9,R.Column10,
  BookingLevel AS BookingLevel,EmpCode FROM #FinalResult R 
  
  ORDER BY SNo;
  
  
 ---For dynamic change header
 IF(@ClientId !=0)
 BEGIN 
  SELECT ISNULL(Column1,'') Column1,ISNULL(Column2,'') Column2,ISNULL(Column3,'') Column3,
  ISNULL(Column4,'') Column4,ISNULL(Column5,'') Column5,ISNULL(Column6,'') Column6,
  ISNULL(Column7,'') Column7,ISNULL(Column8,'') Column8,ISNULL(Column9,'') Column9,ISNULL(Column10,'') Column10
  FROM WRBHBClientColumns 
  WHERE ClientId=@ClientId AND IsActive=1 AND IsDeleted=0
 END
  SELECT 'Column1','Column2','Column3','Column4','Column5','Column6','Column7','Column8','Column9','Column10'
  
  
 END
END
/*  CREATE TABLE #FINAL(BookingCode INT,ClientName NVARCHAR(100),
  PropertyName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDt NVARCHAR(100),
  CheckOutDt NVARCHAR(100),StayDays INT,UserName NVARCHAR(100),
  Tariff DECIMAL(27,2),Status NVARCHAR(100),BookingLevel NVARCHAR(100),
  BookingId BIGINT,GuestId BIGINT,AssignedGuestTableId BIGINT,ClientId BIGINT,
  CRMId BIGINT,CRMName NVARCHAR(100),PropertyId BIGINT,
  MasterClientName NVARCHAR(100),MasterClientId BIGINT,BookingDate NVARCHAR(100),
  TariffPaymentMode NVARCHAR(100));
  -- Room Level Booking : Cancel : Begin
  -- Get Canceled & No Show Booking Id : Begin  
  -- Property
  CREATE TABLE #Tbl1(RoomCapturedCnt INT,RoomCaptured INT,BookingId BIGINT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  --INSERT INTO #Tbl1(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,Tariff)  
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff,
  BG.GuestId
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId=B.Id AND BG.BookingPropertyTableId = BP.Id   
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room' AND 
  ISNULL(B.CancelStatus,'') IN ('Canceled','No Show') AND 
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
  BP.GetType IN ('Property','Contract') 
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff,BG.GuestId;
  --
  --SELECT * FROM #Tbl1 ORDER BY BookingId ASC;
  return;
  -- MMT
  CREATE TABLE #Tbl1MMT(RoomCapturedCnt INT,RoomCaptured INT,BookingId BIGINT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2));
  INSERT INTO #Tbl1MMT(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,
  Tariff)  
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room' AND 
  ISNULL(B.CancelStatus,'') IN ('Canceled','No Show') AND 
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
  BP.PropertyType IN ('MMT')
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff;
  --
  SELECT * FROM #Tbl1 ORDER BY BookingId ASC;
  SELECT * FROM #Tbl1MMT ORDER BY BookingId ASC;RETURN; 
  -- Get Canceled & No Show Booking Guest Id & Tariff
  -- PROPERTY 
  CREATE TABLE #Tbl2(BookingId BIGINT,GuestId BIGINT,DividedTariff DECIMAL(27,2));
  INSERT INTO #Tbl2(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #Tbl1 S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured;
  -- MMT
  CREATE TABLE #Tbl2MMT(BookingId INT,GuestId INT,DividedTariff DECIMAL(27,2));
  INSERT INTO #Tbl2MMT(BookingId,GuestId,DividedTariff)
  SELECT B.BookingId,B.GuestId,S.DividedTariff
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #Tbl1MMT S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured;
  --
  --SELECT * FROM #Tbl2 ORDER BY BookingId ASC;
  --SELECT * FROM #Tbl2MMT ORDER BY BookingId ASC;RETURN;
  -- Cancel Booking
  -- PROPERTY
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,CheckInDt,
  CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,BookingId,GuestId,
  AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,MasterClientName,
  MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName,
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,RB.Id,C.Id,
  C.CRMId,U1.FirstName+' '+U1.LastName,P.Id,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),RB.TariffPaymentMode
  FROM #Tbl2 A
  LEFT OUTER JOIN WRBHBBooking B WITH(NOLOCK)ON B.Id = A.BookingId
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
  -- MMT
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.HotalName,
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName, 
  CONVERT(VARCHAR(100),RB.ChkInDt,103) AS CheckInDt,
  CONVERT(VARCHAR(100),RB.ChkOutDt,103) AS CheckOutDt,
  DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,RB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.HotalId,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),
  RB.TariffPaymentMode
  FROM #Tbl2MMT A
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
  LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
  P.HotalId = RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room';
  -- Room Level Booking : Cancel : End
  --SELECT * FROM #FINAL ORDER BY BookingId ASC;RETURN;
  -- Room Level Booking : Booked & Direct Booked : Begin
  -- Get Booking Id
  -- PROPERTY
  CREATE TABLE #SDD(RoomCapturedCnt INT,RoomCaptured INT,BookingId BIGINT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2),RoomId BIGINT);
  INSERT INTO #SDD(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,
  Tariff,RoomId)
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff,
  BG.RoomId
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')='' AND
  B.BookingLevel='Room' AND BG.IsActive=1 AND BG.IsDeleted=0 AND
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
  BP.GetType IN ('Property','Contract')
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff,BG.RoomId;
  -- MMT
  CREATE TABLE #SDDMMT(RoomCapturedCnt INT,RoomCaptured INT,BookingId BIGINT,
  DividedTariff DECIMAL(27,2),Tariff DECIMAL(27,2),RoomId BIGINT);
  INSERT INTO #SDDMMT(RoomCapturedCnt,RoomCaptured,BookingId,DividedTariff,
  Tariff,RoomId)
  SELECT COUNT(BG.RoomCaptured),BG.RoomCaptured,B.Id,
  ROUND(BG.Tariff/CAST(COUNT(BG.RoomCaptured) AS INT),0),BG.Tariff,
  BG.RoomId
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON
  BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'') = '' AND
  B.BookingLevel='Room' AND BG.IsActive=1 AND BG.IsDeleted=0 AND
  CONVERT(DATE,BG.CreatedDate,103) BETWEEN
  CONVERT(DATE,@StartDt,103) AND CONVERT(DATE,@EndDt,103) AND
  BP.PropertyType IN ('MMT')
  GROUP BY B.Id,BG.RoomCaptured,BG.Tariff,BG.RoomId;
  -- Get Booking Guest Id & Tariff
  -- PROPERTY 
  CREATE TABLE #ASD(BookingId BIGINT,GuestId BIGINT,DividedTariff DECIMAL(27,2),
  RoomId BIGINT);
  INSERT INTO #ASD(BookingId,GuestId,DividedTariff,RoomId)
  SELECT B.BookingId,B.GuestId,S.DividedTariff,B.RoomId
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #SDD S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured AND
  IsActive=1 AND IsDeleted=0 AND B.RoomId=S.RoomId;
  --
  --SELECT * FROM #ASD;RETURN;
  -- MMT
  CREATE TABLE #ASDMMT(BookingId BIGINT,GuestId BIGINT,DividedTariff DECIMAL(27,2),
  RoomId BIGINT);
  INSERT INTO #ASDMMT(BookingId,GuestId,DividedTariff,RoomId)
  SELECT B.BookingId,B.GuestId,S.DividedTariff,B.RoomId
  FROM WRBHBBookingPropertyAssingedGuest B
  LEFT OUTER JOIN #SDDMMT S WITH(NOLOCK)ON S.BookingId=B.BookingId
  WHERE B.BookingId=S.BookingId AND B.RoomCaptured=S.RoomCaptured AND
  IsActive=1 AND IsDeleted=0 AND B.RoomId=S.RoomId;
  -- ROOM LEVEL BOOKING
  -- PROPERTY
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName, 
  CONVERT(VARCHAR(100),MIN(RB.ChkInDt),103) AS CheckInDt,
  CONVERT(VARCHAR(100),MAX(RB.ChkOutDt),103) AS CheckOutDt,
  SUM(DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt)) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,0,--RB.Id,
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
  B.BookingLevel,B.Id,RB.GuestId,C.Id,C.CRMId,U1.FirstName,U1.LastName,
  P.Id,MC.ClientName,MC.Id,RB.CreatedDate,RB.TariffPaymentMode;
  --
  --SELECT * FROM #FINAL;RETURN;
  -- MMT
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.HotalName,
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName, 
  CONVERT(VARCHAR(100),MIN(RB.ChkInDt),103) AS CheckInDt,
  CONVERT(VARCHAR(100),MAX(RB.ChkOutDt),103) AS CheckOutDt,
  SUM(DATEDIFF(DAY,RB.ChkInDt,RB.ChkOutDt)) AS StayDays,
  U.FirstName+' '+U.LastName AS UserName,A.DividedTariff AS Tariff,
  RB.CurrentStatus AS Status,B.BookingLevel,B.Id,RB.GuestId,0,--RB.Id,
  C.Id,C.CRMId,U1.FirstName+' '+U1.LastName,P.HotalId,MC.ClientName,MC.Id,
  CONVERT(VARCHAR(100),RB.CreatedDate,103),RB.TariffPaymentMode
  FROM #ASDMMT A
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
  LEFT OUTER JOIN WRBHBStaticHotels P WITH(NOLOCK)ON 
  P.HotalId = RB.BookingPropertyId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.BookingLevel='Room' AND
  RB.IsActive=1 AND RB.IsDeleted=0 AND A.BookingId=RB.BookingId AND
  A.RoomId=RB.RoomId AND A.GuestId=RB.GuestId
  GROUP BY B.BookingCode,C.ClientName,P.HotalName,CG.FirstName,
  CG.LastName,U.FirstName,U.LastName,A.DividedTariff,RB.CurrentStatus,
  B.BookingLevel,B.Id,RB.GuestId,C.Id,C.CRMId,U1.FirstName,U1.LastName,
  P.HotalId,MC.ClientName,MC.Id,RB.CreatedDate,RB.TariffPaymentMode;
  -- Room Level Booking : Booked & Direct Booked : End
  --SELECT * FROM #FINAL ORDER BY BookingId ASC;RETURN;
  -- Bed Level Booking : Direct Booked : Begin
  INSERT INTO #FINAL(BookingCode,ClientName,PropertyName,GuestName,
  CheckInDt,CheckOutDt,StayDays,UserName,Tariff,Status,BookingLevel,
  BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,CRMName,PropertyId,
  MasterClientName,MasterClientId,BookingDate,TariffPaymentMode)
  SELECT B.BookingCode,C.ClientName,P.PropertyName,
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName,
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
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName,
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
  CREATE TABLE #ATbl1(ApartmentIdCnt INT,ApartmentId BIGINT,BookingId BIGINT,
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
  CREATE TABLE #ATbl2(BookingId BIGINT,GuestId BIGINT,DividedTariff DECIMAL(27,2));
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
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName, 
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
  CREATE TABLE #ATbl3(ApartmentIdCnt INT,ApartmentId BIGINT,BookingId BIGINT,
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
  CREATE TABLE #ATbl4(BookingId BIGINT,GuestId BIGINT,DividedTariff DECIMAL(27,2));
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
  ISNULL(CG.FirstName,'')+' '+ISNULL(CG.LastName,'') AS GuestName, 
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
  -- Property Category & City Name : Begin
  CREATE TABLE #CategoryCity(BookingId BIGINT,City NVARCHAR(100),
  Category NVARCHAR(100));
  -- Room
  INSERT INTO #CategoryCity(BookingId,City,Category)
  SELECT B.Id,C.CityName,CASE 
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'MGH' THEN 'G H'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'CPP' THEN 'C P P '
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'DdP' THEN 'Dedicated'
  WHEN BP.GetType = 'API' AND BP.PropertyType = 'MMT' THEN 'M M T'
  ELSE BP.PropertyType END FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBBookingProperty BP WITH(NOLOCK)ON BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
  BG.BookingPropertyId = BP.PropertyId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND B.BookingCode != 0 AND 
  B.BookingLevel = 'Room' AND
  CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
  CONVERT(DATE,@EndDt,103)
  GROUP BY B.Id,B.CityId,C.CityName,BP.PropertyType,BP.GetType;
  -- Apartment
  INSERT INTO #CategoryCity(BookingId,City,Category)
  SELECT B.Id,C.CityName,CASE 
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'MGH' THEN 'G H'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'CPP' THEN 'C P P '
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'DdP' THEN 'Dedicated'
  WHEN BP.GetType = 'API' AND BP.PropertyType = 'MMT' THEN 'M M T'
  ELSE BP.PropertyType END FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBApartmentBookingProperty BP 
  WITH(NOLOCK)ON BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
  BG.BookingPropertyId = BP.PropertyId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND B.BookingCode != 0 AND 
  B.BookingLevel = 'Apartment' AND
  CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
  CONVERT(DATE,@EndDt,103) 
  GROUP BY B.Id,B.CityId,C.CityName,BP.PropertyType,BP.GetType;
  -- Bed
  INSERT INTO #CategoryCity(BookingId,City,Category)
  SELECT B.Id,C.CityName,CASE 
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'ExP' THEN 'External'
  WHEN BP.GetType = 'Property' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'InP' THEN 'Internal'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'MGH' THEN 'G H'
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'CPP' THEN 'C P P '
  WHEN BP.GetType = 'Contract' AND BP.PropertyType = 'DdP' THEN 'Dedicated'
  WHEN BP.GetType = 'API' AND BP.PropertyType = 'MMT' THEN 'M M T'
  ELSE BP.PropertyType END FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBApartmentBookingProperty BP 
  WITH(NOLOCK)ON BP.BookingId = B.Id
  LEFT OUTER JOIN WRBHBApartmentBookingPropertyAssingedGuest BG WITH(NOLOCK)ON
  BG.BookingId = B.Id AND BG.BookingPropertyTableId = BP.Id AND
  BG.BookingPropertyId = BP.PropertyId
  LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id = B.CityId
  WHERE B.IsActive = 1 AND B.IsDeleted = 0 AND B.BookingCode != 0 AND 
  B.BookingLevel = 'Bed' AND
  CONVERT(DATE,B.BookedDt,103) BETWEEN CONVERT(DATE,@StartDt,103) AND 
  CONVERT(DATE,@EndDt,103) 
  GROUP BY B.Id,B.CityId,C.CityName,BP.PropertyType,BP.GetType;
  -- Property Category & City Name : End
  CREATE TABLE #TABLE(SNo INT IDENTITY(1,1),BookingCode NVARCHAR(100),
  Status NVARCHAR(100),BookingLevel NVARCHAR(100),ClientName NVARCHAR(100),
  PropertyName NVARCHAR(100),GuestName NVARCHAR(100),CheckInDt NVARCHAR(100),
  CheckOutDt NVARCHAR(100),StayDays INT,UserName NVARCHAR(100),
  Tariff DECIMAL(27,2),BookingId BIGINT,GuestId BIGINT,AssignedGuestTableId BIGINT,
  ClientId BIGINT,CRMId BIGINT,CRMName NVARCHAR(100),PropertyId BIGINT,
  MasterClientName NVARCHAR(100),MasterClientId BIGINT,BookingDate NVARCHAR(100),
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
  CONVERT(NVARCHAR(100),CheckInDt,103) AS CheckInDt,
    CONVERT(NVARCHAR(100),CheckOutDt,103) AS CheckOutDt,
  StayDays,ISNULL(UserName,'') AS UserName,Tariff,
  T.BookingId,GuestId,AssignedGuestTableId,ClientId,CRMId,
  ISNULL(CRMName,'') AS CRMName,PropertyId,BookingDate,
  ISNULL(MasterClientName,'') AS MasterClientName,MasterClientId,SNo,
  ISNULL(TariffPaymentMode,'') AS TariffPaymentMode,
  StayDays * Tariff AS TotalTariff,ISNULL(C.Category,'') AS PropertyCategory,
  ISNULL(C.City,'') AS City
  FROM #TABLE T
  LEFT OUTER JOIN #CategoryCity C WITH(NOLOCK)ON T.BookingId = C.BookingId 
  WHERE ISNULL(UserName,'') NOT IN ('VivekAdmonk','VivekAdmonk');
 END
END*/  
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