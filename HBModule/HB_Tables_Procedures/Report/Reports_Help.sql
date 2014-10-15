-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Reports_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Reports_Help]
GO 
-- ===============================================================================
-- Author:Sakthi
-- Create date:May-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Bed Level Booking
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Reports_Help](@Action NVARCHAR(100),
@FromDt NVARCHAR(100),@ToDt NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),
@Str3 NVARCHAR(100),@Str4 NVARCHAR(100),
@Id1 BIGINT,@Id2 BIGINT,@Id3 BIGINT,@Id4 BIGINT)
AS
BEGIN
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
IF @Action = 'DatewiseBookingCnt'
 BEGIN
  -- Get Day Count
  SELECT DATEDIFF(DAY, @FromDt, DATEADD(MONTH, 1, @FromDt)) AS Cnt;
  -- Get Data Between Dates
  CREATE TABLE #TMP(BookedUsrId BIGINT,Cnt INT,Name NVARCHAR(100),
  BookedDt NVARCHAR(100));
  INSERT INTO #TMP(BookedUsrId,Cnt,Name,BookedDt)
  SELECT BookedUsrId,COUNT(BookedUsrId) AS Cnt,
  U.FirstName+' '+U.LastName AS Name,
  SUBSTRING(CONVERT(VARCHAR(100),B.BookedDt,103),0,3) AS BookedDt 
  FROM WRBHBBooking B
  LEFT OUTER JOIN WRBHBUser U WITH(NOLOCK)ON U.Id=B.BookedUsrId
  WHERE B.IsActive=1 AND B.IsDeleted=0 AND BookingCode != 0 AND
  MONTH(BookedDt) = @Id1 AND YEAR(BookedDt) = @Id2
  GROUP BY BookedUsrId,CONVERT(VARCHAR(100),B.BookedDt,103),
  U.FirstName,U.LastName 
  ORDER BY CONVERT(VARCHAR(100),B.BookedDt,103) ASC;
  -- Using PIVOT function to values assigned  
  CREATE TABLE #TABLE(Id INT,Name NVARCHAR(100),D01 INT,D02 INT,D03 INT,
  D04 INT,D05 INT,D06 INT,D07 INT,D08 INT,D09 INT,D10 INT,D11 INT,D12 INT,
  D13 INT,D14 INT,D15 INT,D16 INT,D17 INT,D18 INT,D19 INT,D20 INT,D21 INT,
  D22 INT,D23 INT,D24 INT,D25 INT,D26 INT,D27 INT,D28 INT,D29 INT,D30 INT,
  D31 INT);
  INSERT INTO #TABLE(Id,Name,D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,
  D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,
  D30,D31)
  SELECT * FROM #TMP
  PIVOT (SUM(Cnt) FOR BookedDt IN([01],[02],[03],[04],[05],[06],
  [07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
  [21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31])) AS DSD;
  --
  --select * from #TABLE;return;
  -- Isnull check in Final Select
  CREATE TABLE #TABLE1(Name NVARCHAR(100),D01 INT,D02 INT,D03 INT,
  D04 INT,D05 INT,D06 INT,D07 INT,D08 INT,D09 INT,D10 INT,D11 INT,D12 INT,
  D13 INT,D14 INT,D15 INT,D16 INT,D17 INT,D18 INT,D19 INT,D20 INT,D21 INT,
  D22 INT,D23 INT,D24 INT,D25 INT,D26 INT,D27 INT,D28 INT,D29 INT,D30 INT,
  D31 INT,Tot INT);
  INSERT INTO #TABLE1(Name,D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,
  D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,
  D30,D31,Tot)
  SELECT Name,ISNULL(D01,0) AS D01,ISNULL(D02,0) AS D02,ISNULL(D03,0) AS D03,
  ISNULL(D04,0) AS D04,ISNULL(D05,0) AS D05,ISNULL(D06,0) AS D06,
  ISNULL(D07,0) AS D07,ISNULL(D08,0) AS D08,ISNULL(D09,0) AS D09,
  ISNULL(D10,0) AS D10,ISNULL(D11,0) AS D11,ISNULL(D12,0) AS D12,
  ISNULL(D13,0) AS D13,ISNULL(D14,0) AS D14,ISNULL(D15,0) AS D15,
  ISNULL(D16,0) AS D16,ISNULL(D17,0) AS D17,ISNULL(D18,0) AS D18,
  ISNULL(D19,0) AS D19,ISNULL(D20,0) AS D20,ISNULL(D21,0) AS D21,
  ISNULL(D22,0) AS D22,ISNULL(D23,0) AS D23,ISNULL(D24,0) AS D24,
  ISNULL(D25,0) AS D25,ISNULL(D26,0) AS D26,ISNULL(D27,0) AS D27,
  ISNULL(D28,0) AS D28,ISNULL(D29,0) AS D29,ISNULL(D30,0) AS D30,
  ISNULL(D31,0) AS D31,ISNULL(D01,0)+ISNULL(D02,0)+ISNULL(D03,0)+
  ISNULL(D04,0)+ISNULL(D05,0)+ISNULL(D06,0)+ISNULL(D07,0)+ISNULL(D08,0)+
  ISNULL(D09,0)+ISNULL(D10,0)+ISNULL(D11,0)+ISNULL(D12,0)+ISNULL(D13,0)+
  ISNULL(D14,0)+ISNULL(D15,0)+ISNULL(D16,0)+ISNULL(D17,0)+ISNULL(D18,0)+
  ISNULL(D19,0)+ISNULL(D20,0)+ISNULL(D21,0)+ISNULL(D22,0)+ISNULL(D23,0)+
  ISNULL(D24,0)+ISNULL(D25,0)+ISNULL(D26,0)+ISNULL(D27,0)+ISNULL(D28,0)+
  ISNULL(D29,0)+ISNULL(D30,0)+ISNULL(D31,0) AS Tot FROM #TABLE;
  --
  --select * from #TABLE1;return;
  --
  DECLARE @Cnt INT=(SELECT COUNT(*) FROM #TABLE1);
  IF @Cnt != 0
   BEGIN
    INSERT INTO #TABLE1(Name,D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,
    D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,
    D30,D31,Tot) 
    SELECT 'Grand Total',SUM(ISNULL(D01,0))AS D01,SUM(ISNULL(D02,0)) AS D02,
    SUM(ISNULL(D03,0)) AS D03,SUM(ISNULL(D04,0)) AS D04,
    SUM(ISNULL(D05,0)) AS D05,SUM(ISNULL(D06,0)) AS D06,
    SUM(ISNULL(D07,0)) AS D07,SUM(ISNULL(D08,0)) AS D08,
    SUM(ISNULL(D09,0)) AS D09,SUM(ISNULL(D10,0)) AS D10,
    SUM(ISNULL(D11,0)) AS D11,SUM(ISNULL(D12,0)) AS D12,
    SUM(ISNULL(D13,0)) AS D13,SUM(ISNULL(D14,0)) AS D14,
    SUM(ISNULL(D15,0)) AS D15,SUM(ISNULL(D16,0)) AS D16,
    SUM(ISNULL(D17,0)) AS D17,SUM(ISNULL(D18,0)) AS D18,
    SUM(ISNULL(D19,0)) AS D19,SUM(ISNULL(D20,0)) AS D20,
    SUM(ISNULL(D21,0)) AS D21,SUM(ISNULL(D22,0)) AS D22,
    SUM(ISNULL(D23,0)) AS D23,SUM(ISNULL(D24,0)) AS D24,
    SUM(ISNULL(D25,0)) AS D25,SUM(ISNULL(D26,0)) AS D26,
    SUM(ISNULL(D27,0)) AS D27,SUM(ISNULL(D28,0)) AS D28,
    SUM(ISNULL(D29,0)) AS D29,SUM(ISNULL(D30,0)) AS D30,
    SUM(ISNULL(D31,0)) AS D31,SUM(ISNULL(D01,0)+ISNULL(D02,0)+ISNULL(D03,0)+
    ISNULL(D04,0)+ISNULL(D05,0)+ISNULL(D06,0)+ISNULL(D07,0)+ISNULL(D08,0)+
    ISNULL(D09,0)+ISNULL(D10,0)+ISNULL(D11,0)+ISNULL(D12,0)+ISNULL(D13,0)+
    ISNULL(D14,0)+ISNULL(D15,0)+ISNULL(D16,0)+ISNULL(D17,0)+ISNULL(D18,0)+
    ISNULL(D19,0)+ISNULL(D20,0)+ISNULL(D21,0)+ISNULL(D22,0)+ISNULL(D23,0)+
    ISNULL(D24,0)+ISNULL(D25,0)+ISNULL(D26,0)+ISNULL(D27,0)+ISNULL(D28,0)+
    ISNULL(D29,0)+ISNULL(D30,0)+ISNULL(D31,0)) AS Tot
    FROM #TABLE;
   END
  --
  SELECT * FROM #TABLE1;
 END
END