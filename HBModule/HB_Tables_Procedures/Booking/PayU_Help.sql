-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PayU_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_PayU_Help]
GO
CREATE PROCEDURE [dbo].[SP_PayU_Help](@Action NVARCHAR(100),@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100),@Str3 NVARCHAR(100),@Str4 NVARCHAR(100),@Str5 NVARCHAR(100),
@Str6 NVARCHAR(100))
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'BookingDtlsLoad'
 BEGIN  
  DECLARE @BookingLevel NVARCHAR(100),@BookingId BIGINT,@TotAmt NVARCHAR(100);
  SELECT @BookingLevel = BookingLevel,@BookingId = Id FROM WRBHBBooking 
  WHERE REPLACE(RowId,'-','') = @Str1;
  CREATE TABLE #TMP(DtTime INT,Dt INT,Tariff DECIMAL(27,2),RoomCaptured INT,Diff INT);
  CREATE TABLE #Amt(Dayss DECIMAL(27,2),Tariff DECIMAL(27,2));
  /*IF @BookingLevel = 'Room'
   BEGIN
    INSERT INTO #TMP(DtTime,Dt,Tariff,RoomCaptured,Diff)
    SELECT DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)),
    DATEDIFF(HOUR,ChkInDt,ChkOutDt),PG.Tariff,PG.RoomCaptured,
    DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)) - 
    DATEDIFF(HOUR,ChkInDt,ChkOutDt)
    FROM WRBHBBookingPropertyAssingedGuest PG
    WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND PG.BookingId = @BookingId
    GROUP BY RoomCaptured,ChkInDt,ChkOutDt,Tariff,ExpectChkInTime,AMPM;
    INSERT INTO #Amt(Dayss,Tariff)
    SELECT CASE WHEN Diff > 0 THEN (DtTime / 24) + 1 ELSE (Dt / 24) END,Tariff FROM #TMP;
    SELECT @TotAmt = CAST(CAST(SUM(Dayss * Tariff) AS INT) AS VARCHAR) 
    FROM #Amt;
   END
  IF @BookingLevel = 'Bed'
   BEGIN    
    INSERT INTO #TMP(DtTime,Dt,Tariff,RoomCaptured,Diff)
    SELECT DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)),
    DATEDIFF(HOUR,ChkInDt,ChkOutDt),PG.Tariff,PG.RoomCaptured,
    DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)) - 
    DATEDIFF(HOUR,ChkInDt,ChkOutDt)
    FROM WRBHBBedBookingPropertyAssingedGuest PG
    WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND PG.BookingId = @BookingId
    GROUP BY RoomCaptured,ChkInDt,ChkOutDt,Tariff,ExpectChkInTime,AMPM;
    INSERT INTO #Amt(Dayss,Tariff)
    SELECT CASE WHEN Diff > 0 THEN (DtTime / 24) + 1 ELSE (Dt / 24) END,Tariff FROM #TMP;
    SELECT @TotAmt = CAST(CAST(SUM(Dayss * Tariff) AS INT) AS VARCHAR) 
    FROM #Amt;
   END
  IF @BookingLevel = 'Apartment'
   BEGIN    
    INSERT INTO #TMP(DtTime,Dt,Tariff,RoomCaptured,Diff)
    SELECT DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)),
    DATEDIFF(HOUR,ChkInDt,ChkOutDt),PG.Tariff,PG.RoomCaptured,
    DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
    CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
    CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)) - 
    DATEDIFF(HOUR,ChkInDt,ChkOutDt)
    FROM WRBHBApartmentBookingPropertyAssingedGuest PG
    WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND PG.BookingId = @BookingId
    GROUP BY RoomCaptured,ChkInDt,ChkOutDt,Tariff,ExpectChkInTime,AMPM;
    INSERT INTO #Amt(Dayss,Tariff)
    SELECT CASE WHEN Diff > 0 THEN (DtTime / 24) + 1 ELSE (Dt / 24) END,Tariff FROM #TMP;
    SELECT @TotAmt = CAST(CAST(SUM(Dayss * Tariff) AS INT) AS VARCHAR) 
    FROM #Amt;
   END*/
  INSERT INTO #TMP(DtTime,Dt,Tariff,RoomCaptured,Diff)
  SELECT DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)),
  DATEDIFF(HOUR,ChkInDt,ChkOutDt),PG.Tariff,PG.RoomCaptured,
  DATEDIFF(HOUR,CAST(CAST(PG.ChkInDt AS VARCHAR)+' '+
  CAST(PG.ExpectChkInTime+' '+PG.AMPM AS VARCHAR) AS DATETIME),
  CAST(CAST(PG.ChkOutDt AS VARCHAR)+' '+'11:59:00 AM' AS DATETIME)) - 
  DATEDIFF(HOUR,ChkInDt,ChkOutDt)
  FROM WRBHBBookingPropertyAssingedGuest PG
  WHERE PG.IsActive = 1 AND PG.IsDeleted = 0 AND PG.BookingId = @BookingId
  GROUP BY RoomCaptured,ChkInDt,ChkOutDt,Tariff,ExpectChkInTime,AMPM;
  INSERT INTO #Amt(Dayss,Tariff)
  SELECT CASE WHEN Diff > 0 THEN (DtTime / 24) + 1 ELSE (Dt / 24) END,Tariff 
  FROM #TMP;
  SELECT @TotAmt = CAST(CAST(SUM(Dayss * Tariff) AS INT) AS VARCHAR) 
  FROM #Amt;
  --'key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10|Salt' 
  SELECT  
  'HBo1sB|'+REPLACE(RowId,'-','')+'|'+@TotAmt+'|hotel|sakthi|sakthi@in.in|||||||||||HOJgYflb',
  'https://secure.payu.in/_payment',REPLACE(RowId,'-',''),'HBo1sB',@TotAmt,'sakthi',
  'sakthi@in.in','1234567890','hotel',
  'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  'Invalid Process.'  
  FROM WRBHBBooking WHERE REPLACE(RowId,'-','') = @Str1;
  --SELECT  
  --'gtKFFx|'+REPLACE(RowId,'-','')+'|'+@TotAmt+'|hotel|sakthi|sakthi@in.in|||||||||||eCwWELxi',
  --'https://test.payu.in/_payment',REPLACE(RowId,'-',''),'gtKFFx',@TotAmt,'sakthi',
  --'sakthi@in.in','1234567890','hotel',
  --'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  --'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  --'Invalid Process.'  
  --FROM WRBHBBooking WHERE REPLACE(RowId,'-','') = @Str1;
  --SELECT  
  --'gtKFFx|'+REPLACE(RowId,'-','')+'|'+@TotAmt+'|hotel|sakthi|sakthi@in.in|||||||||||eCwWELxi',
  --'https://test.payu.in/_payment',REPLACE(RowId,'-',''),'gtKFFx',@TotAmt,'sakthi',
  --'sakthi@in.in','1234567890','hotel',
  --'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  --'http://www.staysimplyfied.com/paymentgateway/success.aspx',
  --'Invalid Process.'  
  --FROM WRBHBBooking WHERE REPLACE(RowId,'-','') = @Str1;
 END
/*IF @Action = 'HeaderInsert'
 BEGIN
  DECLARE @InsId BIGINT;
  INSERT INTO WrbHBPayU(BookingRowId)VALUES(@Str1)
  SELECT Id FROM WrbHBPayU WHERE Id = @@IDENTITY;
 END
IF @Action = 'HeaderUpdate'
 BEGIN
  UPDATE WrbHBPayU SET Sendhash = @Str6 WHERE BookingRowId = @Str1 AND
  Id = @Str3;
 END*/
END