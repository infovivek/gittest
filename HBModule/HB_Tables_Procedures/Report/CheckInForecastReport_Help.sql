 
 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_CheckInForecastReport_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_CheckInForecastReport_Help
GO 

CREATE PROCEDURE Sp_CheckInForecastReport_Help
(
	@Action NVARCHAR(100)=NULL,
	@Pram1 NVARCHAR(100)=NULL,    --int
	@Pram2  NVARCHAR(100)=NULL,   --int
	@Pram3 NVARCHAR(100)=NULL,--@FromDate
	@Pram4  NVARCHAR(100)=NULL,--@ToDate
	@Pram5  NVARCHAR(100)=NULL,
	@UserId int
)
AS 
BEGIN 
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
--Sp_TariffBasedReports @Action='PageLoad',@Param1=0,@Param2=2014,@FromDate='',@ToDate='',@UserId=1
--drop  table #FIRSTDATAS;
--drop table #TFMODES;
--drop table #TFFINAL;
--drop table #MonthWise;
--drop table #MonthWiseFinal;
--drop table #MonthWiseFinalNew;

IF @Action ='Year'
		Begin 
			select Id , Years as label  from WRBHBFinancialYear
			where Years!=0
		END
 IF @Action ='PageLoad'
		Begin  
		  
		CREATE TABLE #FIRSTDATAS (CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT,
CheckInDate  NVARCHAR(100),NoOfDays bigint,TotalAmt decimal(27,2),PrintInvoice bit ,BillDate  Nvarchar(100),
TariffpaymentMode NVARCHAR(100))

 
CREATE TABLE #TFMODES(TariffPaymentMode NVARCHAR(200),BookingId BIGINT,GuestId BIGINT,RoomId BIGINT,
BookingPropertyId BIGINT,Tariff DECIMAL(27,2) ,CheckOutDate NVARCHAR(50),CheckInDate Nvarchar(100)
)

CREATE TABLE #TFFINAL(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),TotalDays Bigint )

CREATE TABLE #TFFINALS(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),
TotalDays Bigint ,IDE bigint NOt null primary Key Identity(1,1) )


CREATE TABLE #TEST(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TotalDays Bigint,
TariffPaymentMode NVARCHAR(100),PrintInvoice bit,CheckInDate  NVARCHAR(100),CheckOutDate NVARCHAR(50),BillDate Nvarchar(100)  )

CREATE TABLE #MonthWise(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)
 
CREATE TABLE #MonthWiseFinal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
TariffPaymentMode nvarchar(100),PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNew( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
PrintInvoice bit)

CREATE TABLE #MonthWiseFinalNewNet( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan NVARCHAR(200),FEb NVARCHAR(200),Mar NVARCHAR(200),Aprl NVARCHAR(200),may NVARCHAR(200),Jun NVARCHAR(200),
Jul NVARCHAR(200),Aug NVARCHAR(200),Sept NVARCHAR(200),Oct NVARCHAR(200),Nov NVARCHAR(200),Decm NVARCHAR(200),
PrintInvoice bit)
CREATE TABLE #MonthWiseFinalNewNetExtTotal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)
CREATE TABLE #MonthWiseGrandTotal ( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)

CREATE TABLE #ExternalNet(GuestId BIGINT,BookingId BIGINT,PropertyId BIGINT,ChkInHdrId BIGINT,
MarkUpAmount DECIMAL(27,2),CheckInDate NVARCHAR(50),CheckOutDate NVARCHAR(50))

CREATE TABLE #MonthWiseNet(CheckOutNo NVARCHAR(100),GuestName NVARCHAR(500),GuestId BIGINT,RoomId BIGINT,
Typess NVARCHAR(100),ClientName NVARCHAR(200),Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100),
ChkOutTariffTotal DECIMAL(27,2),CheckOutDate NVARCHAR(50),BookingId BIGINT,ChkoutId BIGINT,ChkInHdrId BIGINT ,TariffPaymentMode NVARCHAR(100), 
Jan DECIMAL(27,2),FEb DECIMAL(27,2),Mar DECIMAL(27,2),Aprl DECIMAL(27,2),may DECIMAL(27,2),Jun DECIMAL(27,2),
Jul DECIMAL(27,2),Aug DECIMAL(27,2),Sept DECIMAL(27,2),Oct DECIMAL(27,2),Nov DECIMAL(27,2),Decm DECIMAL(27,2),
PrintInvoice bit)
--truncate table #Test
		INSERT INTO #FIRSTDATAS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,CheckInDate,NoOfDays,
					TotalAmt,PrintInvoice,BillDate,TariffpaymentMode)
					
					SELECT DISTINCT CheckOutNo,GuestName,h.GuestId,H.RoomId,Type,ClientName,Property,PropertyId,PropertyType,
					 g.Tariff,CONVERT(NVARCHAR,G.ChkOutDt,103) ,H.BookingId,H.Id as ChkoutId,ChkInHdrId,CONVERT(NVARCHAR,H.CheckInDate,103) ChkInDt,NoOfDays,
					 g.Tariff   TotalAmt,PrintInvoice,BillDate,G.TariffPaymentMode 
					FROM WRBHBChechkOutHdr  H
					 join WRBHBBookingPropertyAssingedGuest G on H.BookingId=G.BookingId   AND H.RoomId=G.RoomId
					AND G.IsActive=1 and G.IsDeleted=0 
					WHERE H.IsActive=1 AND H.IsDeleted=0 AND CurrentStatus!='Canceled' 
					AND TariffPaymentMode!='Bill to Client' 
					
		INSERT INTO #FIRSTDATAS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,CheckInDate,NoOfDays,
					TotalAmt,PrintInvoice,BillDate,TariffpaymentMode)
					
				    SELECT DISTINCT CheckOutNo,GuestName,h.GuestId,H.RoomId,Type,ClientName,Property,PropertyId,PropertyType,
					 g.Tariff,CONVERT(NVARCHAR,G.ChkOutDt,103) ,H.BookingId,H.Id as ChkoutId,ChkInHdrId,CONVERT(NVARCHAR,H.CheckInDate,103) ChkInDt,NoOfDays,
					 g.Tariff    TotalAmt,PrintInvoice,BillDate,G.TariffPaymentMode 
					FROM WRBHBChechkOutHdr  H
					join WRBHBBedBookingPropertyAssingedGuest G on G.BookingId=H.BookingId 
					AND G.IsActive=1 and G.IsDeleted=0 AND H.BedId=G.BedId
					WHERE H.IsActive=1 AND H.IsDeleted=0 AND CurrentStatus!='Canceled' 
					AND TariffPaymentMode!='Bill to Client'	 
				 
		INSERT INTO #FIRSTDATAS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,CheckInDate,NoOfDays,
					TotalAmt,PrintInvoice,BillDate,TariffpaymentMode)
					
					SELECT DISTINCT CheckOutNo,GuestName,h.GuestId,H.RoomId,Type,ClientName,Property,PropertyId,PropertyType,
					 g.Tariff,CONVERT(NVARCHAR,G.ChkOutDt,103) ChkInDt ,H.BookingId,H.Id as ChkoutId,ChkInHdrId,CONVERT(NVARCHAR,H.CheckInDate,103) ChkInDt,NoOfDays,
					 g.Tariff   TotalAmt,PrintInvoice,BillDate ,G.TariffPaymentMode
					FROM WRBHBChechkOutHdr  H
					join WRBHBApartmentBookingPropertyAssingedGuest G on G.BookingId=H.BookingId 
					AND G.IsActive=1 and G.IsDeleted=0 --AND H.ApartmentId					
					WHERE H.IsActive=1 AND H.IsDeleted=0 AND CurrentStatus!='Canceled' 
					AND TariffPaymentMode!='Bill to Client' 
		 
--Truncate table #TFFINAL;
INSERT INTO #TEST( RoomId,CheckOutNo,GuestName,GuestId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
					TariffPaymentMode,PrintInvoice,TotalDays, BillDate) 
			SELECT distinct F.RoomId,0,GuestName,F.GuestId,Typess,ClientName,Property,PropertyId,
			PropertyType,ChkOutTariffTotal,F.CheckOutDate, F.CheckInDate,F.BookingId,0, ChkInHdrId ,
			F.TariffPaymentMode,ISNULL(PrintInvoice,0),NoOfDays, F.BillDate
			FROM #FIRSTDATAS F 
			--LEFT OUTER JOIN #TFMODES M  ON F.GuestId =M.GuestId and  F.BookingId=M.BookingId
			Group by GuestName,F.GuestId,F.RoomId,Typess,ClientName,Property,PropertyId,
			PropertyType,ChkOutTariffTotal,F.BillDate, F.CheckInDate,F.BookingId,ChkInHdrId ,
			F.TariffPaymentMode,PrintInvoice,NoOfDays, F.CheckOutDate
			 
	 UPDATE #TEST SET TotalDays=1 WHERE TotalDays=0;
	 		
		INSERT INTO #TFFINALS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays) 
			Select CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		    ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,PrintInvoice,TotalDays from  #TEST
			where YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2 AND YEAR(CONVERT(DATE,CheckInDate,103))=@Param2
			
		  

 -- Select * from #TFFINALS where PropertyType='Internal Property'  and PropertyId=2
  --  and MONTH(CONVERT(DATE,CheckOutDate,103))= 9
  -- order by BookingId
  --  return;
	 Declare  @Count BIGINT ,@j int,@Tariff DECIMAL(27,2),@NoOfDays BIGINT;   
	 Declare  @CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(500),@GuestId BIGINT,@RoomId BIGINT;
     Declare  @Typess NVARCHAR(100),@ClientName NVARCHAR(200),@Property NVARCHAR(200),@PropertyId BIGINT;
     Declare  @PropertyType NVARCHAR(100),@CheckOutDate NVARCHAR(50),@CheckInDate  NVARCHAR(100);
     Declare  @BookingId BIGINT,@ChkoutId BIGINT,@ChkInHdrId BIGINT ,@TariffPaymentMode NVARCHAR(100);
     Declare  @PrintInvoice bit, @IDE Bigint,@TotalDays BIGINT,@TAC DECIMAL(27,2);
        
    SELECT @Count=COUNT(*) FROM #TFFINALS  
    --Select @Count;
     
     SELECT TOP 1 @Tariff=ChkOutTariffTotal ,
    -- @NoOfDays=DATEDIFF(day,CAST(CheckInDate AS DATE),CAST(CheckOutDate AS DATE)),
     @NoOfDays= DATEDIFF(day, CONVERT(DATE,CheckOutDate ,103), CONVERT(DATE,CheckInDate ,103)),
     @CheckOutNo= CheckOutNo,@GuestName=GuestName,@GuestId=GuestId,@RoomId=RoomId,
     @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
     @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,@CheckInDate=CheckInDate,
     @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
     @PrintInvoice=PrintInvoice ,@J=0,@IDE=IDE ,@TotalDays=TotalDays FROM #TFFINALS 
   -- SELECT @NoOfDays;
     WHILE (@TotalDays>0)   
     BEGIN         
		 INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays)
		SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId, @Typess,@ClientName,@Property,@PropertyId, @PropertyType,
		@Tariff,CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate,103)),103),--@CheckOutDate,
		@CheckOutDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
		 @BookingId,@ChkoutId,@ChkInHdrId,
		@TariffPaymentMode, @PrintInvoice,1  
			 SET @J=@J+1  
			 SET @TotalDays=@TotalDays-1   
		IF @TotalDays=0  
			 BEGIN    
					DELETE FROM #TFFINALS WHERE IDE=@IDE
					
			     SELECT TOP 1 @Tariff=ChkOutTariffTotal , 
				 @NoOfDays= DATEDIFF(day, CONVERT(DATE,CheckOutDate,103), CONVERT(DATE,CheckInDate,103)),
				 @CheckOutNo= CheckOutNo,@GuestName=GuestName,@GuestId=GuestId,@RoomId=RoomId,
				 @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
				 @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,
				 @CheckInDate= CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(CheckInDate AS DATE)),103)  ,
				 @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
				 @PrintInvoice=PrintInvoice ,@J=0,@IDE=IDE ,@TotalDays=TotalDays FROM #TFFINALS 
			 END  
     END   
--		 Select * from #TFFINAL where PropertyId=1 and MONTH(CONVERT(DATE,CheckOutDate,103))= 9
--order by BookingId;return;

 --From Checkin Table i am Getting Data below
	 --truncate table #TFFINAL ; 
		      
     INSERT INTO #TFMODES(TariffPaymentMode,BookingId,GuestId,RoomId,BookingPropertyId,Tariff,CheckOutDate,CheckInDate)
			SELECT TariffPaymentMode,B.BookingId,B.GuestId,B.RoomId,BookingPropertyId,G.Tariff,
			CONVERT(Nvarchar(100),G.ChkOutDt,103) , CONVERT(Nvarchar(100),G.ChkInDt,103)CheckInDate
			FROM WRBHBCheckInHdr B 
			JOIN WRBHBBookingPropertyAssingedGuest G ON B.BookingId=G.BookingId and g.RoomId=b.RoomId and G.IsActive=1 AND B.IsDeleted=0
			WHERE B.IsActive=1 AND B.IsDeleted=0 AND CurrentStatus!='Canceled' AND TariffPaymentMode!='Bill to Client'

			--AND G.Tariff!=0
	 INSERT INTO #TFMODES(TariffPaymentMode,BookingId,GuestId,RoomId,BookingPropertyId,Tariff,CheckOutDate,CheckInDate)
			SELECT TariffPaymentMode,B.BookingId,B.GuestId,B.RoomId,BookingPropertyId,G.Tariff,
			CONVERT(Nvarchar(100),G.ChkOutDt,103) , CONVERT(Nvarchar(100),G.ChkInDt,103)CheckInDate
			FROM WRBHBCheckInHdr B 
			JOIN WRBHBBedBookingPropertyAssingedGuest G ON B.BookingId=G.BookingId and  B.BedId=g.BedId  AND G.IsActive=1 AND B.IsDeleted=0
			WHERE B.IsActive=1 AND B.IsDeleted=0 AND CurrentStatus!='Canceled' AND TariffPaymentMode!='Bill to Client'

	 INSERT INTO #TFMODES(TariffPaymentMode,BookingId,GuestId,RoomId,BookingPropertyId,Tariff,CheckOutDate,CheckInDate)	
			SELECT TariffPaymentMode,B.BookingId,B.GuestId,B.RoomId,BookingPropertyId,G.Tariff,
			CONVERT(Nvarchar(100),G.ChkOutDt,103) , CONVERT(Nvarchar(100),G.ChkInDt,103)CheckInDate
			FROM WRBHBCheckInHdr B 
			JOIN WRBHBApartmentBookingPropertyAssingedGuest G ON B.BookingId=G.BookingId and B.ApartmentId=g.ApartmentId  AND G.IsActive=1 AND B.IsDeleted=0
		   WHERE B.IsActive=1 AND B.IsDeleted=0 AND CurrentStatus!='Canceled' AND TariffPaymentMode!='Bill to Client'


   --Select * from #TFMODES where BookingId=2459
			INSERT INTO #TFFINALS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,PrintInvoice,TotalDays) 
				Select CheckInNo,GuestName,H.GuestId,H.RoomId,H.PropertyType,ClientName,h.Property,PropertyId,RoomNo, 
				B.Tariff,B.CheckOutDate,CONVERT(nvarchar(100),B.CheckInDate,103) ArrivalDate,
				H.BookingId,H.BookingId,h.Id,B.TariffPaymentMode,'0',
				DATEDIFF(day, CONVERT(DATE,B.CheckInDate,103), CONVERT(DATE,B.CheckOutDate ,103)) TotalDays 
				from #TFMODES B 
				LEFT OUTER JOIN WRBHBCheckInHdr H  ON H.GuestId =B.GuestId and  H.BookingId=B.BookingId
				and B.BookingPropertyId=H.PropertyId AND b.RoomId=h.RoomId
				where h.IsActive=1 and h.IsDeleted=0 and H.Id not in (Select ChkInHdrId from #TFFINAL) 
				and MONTH(CONVERT(DATE,B.CheckInDate,103)) ! = MONTH(CONVERT(DATE,B.CheckOutDate ,103)) 
				GROUP BY CheckInNo,GuestName,H.GuestId,H.RoomId,H.PropertyType,ClientName,h.Property,PropertyId,RoomNo, 
				B.Tariff,B.CheckOutDate, B.CheckInDate,H.BookingId,h.Id,B.TariffPaymentMode
			    --order by h.BookingId
			INSERT INTO #TFFINALS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,PrintInvoice,TotalDays) 
				Select DISTINCT CheckInNo,GuestName,H.GuestId,H.RoomId,H.PropertyType,ClientName,h.Property,PropertyId,RoomNo, 
				B.Tariff,B.CheckOutDate,CONVERT(nvarchar(100),B.CheckInDate,103) ArrivalDate,
				H.BookingId,H.BookingId,H.Id,B.TariffPaymentMode,'0',
				DATEDIFF(day, CONVERT(DATE,B.CheckInDate,103), CONVERT(DATE,B.CheckOutDate ,103)) TotalDays 
				from #TFMODES B 
			    LEFT OUTER   JOIN  WRBHBCheckInHdr H ON  H.BookingId=B.BookingId   and   B.GuestId=H.GuestId 
				and B.BookingPropertyId=H.PropertyId and b.RoomId=h.RoomId
				where H.IsActive=1 and H.IsDeleted=0  and H.Id not in (Select ChkInHdrId from #TFFINAL)
				and  MONTH(CONVERT(DATE,B.CheckInDate,103))    = MONTH(CONVERT(DATE,B.CheckOutDate ,103))
			    GROUP BY CheckInNo,GuestName,H.GuestId,H.RoomId,H.PropertyType,ClientName,h.Property,PropertyId,RoomNo, 
				B.Tariff,B.CheckOutDate, B.CheckInDate,H.BookingId,h.Id,B.TariffPaymentMode
			   -- order by h.BookingId
				 
		  
	 UPDATE #TFFINALS SET TotalDays=1 WHERE ISNULL(TotalDays,0)=0
		 
	 

     SELECT TOP 1 @Tariff=ChkOutTariffTotal ,
    -- @NoOfDays=DATEDIFF(day,CAST(CheckInDate AS DATE),CAST(CheckOutDate AS DATE)),
     @NoOfDays=TotalDays,--DATEDIFF(day, CONVERT(DATE,CheckInDate ,103), CONVERT(DATE,CheckOutDate,103)),
     @CheckOutNo= CheckOutNo,@GuestName=GuestName,@GuestId=GuestId,@RoomId=RoomId,
     @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
     @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,@CheckInDate=CheckInDate,
     @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
     @PrintInvoice=PrintInvoice ,@J=0,@TotalDays=TotalDays,@IDE=IDE   FROM #TFFINALS 
    --SELECT @NoOfDays;
     WHILE (@NoOfDays>0)   
     BEGIN         
		INSERT INTO #TFFINAL(CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
		ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice,TotalDays)
		SELECT  @CheckOutNo,@GuestName,@GuestId,@RoomId,  @PropertyType ,@ClientName,@Property,@PropertyId,@Typess  ,
		@Tariff, CONVERT(NVARCHAR,DATEADD(DAY,@J,CONVERT(DATE,@CheckInDate  ,103)),103),@CheckOutDate,--
		--@CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103)
		 @BookingId,@ChkoutId,@ChkInHdrId,
		@TariffPaymentMode, @PrintInvoice,1  
			 SET @J=@J+1  
			 SET @NoOfDays=@NoOfDays-1   
		IF @NoOfDays=0  
			 BEGIN    
			 
				 DELETE FROM #TFFINALS WHERE IDE=@IDE  --CheckOutNo =@CheckOutNo
					
			     SELECT TOP 1 @Tariff=ChkOutTariffTotal , 
				 @NoOfDays= TotalDays,-- DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103)),
				 @CheckOutNo= CheckOutNo,@GuestName=GuestName,@GuestId=GuestId,@RoomId=RoomId,
				 @Typess=Typess,@ClientName=ClientName,@Property=Property,@PropertyId=PropertyId,
				 @PropertyType=PropertyType,@CheckOutDate=CheckOutDate,
				 @CheckInDate= CheckInDate,--CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(CheckInDate AS DATE)),103)  ,
				 @BookingId=BookingId,@ChkoutId=ChkoutId,@ChkInHdrId=ChkInHdrId,@TariffPaymentMode=TariffPaymentMode,
				 @PrintInvoice=PrintInvoice ,@J=0 ,@IDE=IDE FROM #TFFINALS 
			 END 
			  
     END   
    -- Select * from #TFFINAL where PropertyId=2  and MONTH(CONVERT(DATE,CheckOutDate,103))= 9
    -- order by BookingId;return;
   --DROP TABLE #NDDCountForecast
     --DROP TABLE #NDDCountForecastNew
     --DROP TABLE #NDDCountForecastData
     --DROP TABLE #OutStandingInternal
      CREATE TABLE #NDDCountForecast(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100),MonthDiff bigint,
	  IDE BIGINT PRIMARY KEY IDENTITY(1,1));
	  
	  CREATE TABLE #NDDCountForecastNew(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100),MonthDiff bigint );
	  
	  CREATE TABLE #NDDCountForecastData(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(27,2),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100),StartDate NVARCHAR(100),EndDate NVARCHAR(100));
	  
	   CREATE TABLE #OutStandingInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,EntryType NVARCHAR(100),GTV DECIMAL(27,2))
	   
	  -- CREATE TABLE #RevanueDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	    
    -- --GET ROOMS ARE DEDICATED OR NON DEDICATER    
   INSERT INTO #NDDCountForecastData(ApartmentId,PropertyId,RoomId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate)  
   SELECT CA.ApartmentId,CA.PropertyId,0,Tariff,ContractType,CA.Property,C.RateInterval ,
   Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0)
   FROM dbo.WRBHBContractManagementAppartment CA       
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CA.ContractId AND 
   LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE CA.IsActive=1 AND CA.IsDeleted=0 AND CA.ApartmentId!=0 AND CA.PropertyId!=0  
      
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate)     
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval ,
     Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0) 
   FROM dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId   
   AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 AND CR.RoomId!=0  
     
   --GET ROOMS ARE DEDICATED Managed Contracts  
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type,StartDate,EndDate) 
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval,
     Convert(Date,c.StartDate,103),Convert(date,C.EndDate,0) 
   FROM  dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId AND   
   LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0  
   
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,
   Type,StartDate,EndDate,MonthDiff)  
   SELECT RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type, StartDate,EndDate,
    DATEDIFF(MONTH,   StartDate, EndDate)+1 as MonthDiff
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM(' Monthly ')  
  
   	 --TRUNCATE TABLE #TFFINAL
     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff,
      @PropertyType=PropertyType,@Property=PropertyName, @Typess=Type,
       @CheckOutDate=EndDate,@CheckInDate=StartDate,
        @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
 
    -- SELECT @NoOfDays;
     WHILE (@TotalDays>0)   
     BEGIN         
     INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property, Typess,
     CheckInDate,CheckOutDate,TotalDays,
     CheckOutNo,GuestName,GuestId,ClientName,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice)
		
		   SELECT  @RoomId,@PropertyId,@Tariff,'Managed G H',@Property,@Typess,
           CONVERT(NVARCHAR(100),@CheckOutDate,103),
           CONVERT(NVARCHAR,DATEADD(MONTH,@J,CAST(@CheckInDate AS DATE)),103),1,
           0 CheckOutNo,0 GuestName,0 GuestId,0 ClientName,
           0 BookingId,0 ChkoutId,0 ChkInHdrId,0 TariffPaymentMode,0 PrintInvoice
			 SET @J=@J+1  
			 SET @TotalDays=@TotalDays-1   
		IF @TotalDays=0  
			 BEGIN    
			 
				 DELETE FROM #NDDCountForecast WHERE IDE=@IDE 
					
			     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff, @PropertyType=PropertyType,
			     @Property=PropertyName, @Typess=Type,@CheckOutDate=EndDate,@CheckInDate=StartDate,
				 @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
			 END 
			  
     END 
     --sELECT * FROM #TFFINAL 
     --RETURN
       TRUNCATE TABLE #NDDCountForecast
   --   TRUNCATE TABLE #TFFINAL 
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,
   Type,StartDate,EndDate,MonthDiff)  
   SELECT RoomId,PropertyId,ApartmentId,    
   (Tariff)*(DATEDIFF(d,StartDate,EndDate)) Tariff,
   --DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,CONVERT(DATE,GETDATE(),103)),0)))),
   PropertyType,PropertyName,Type ,StartDate,EndDate,DATEDIFF(d,StartDate, EndDate)
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM('  Daily  ')
   
     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff,
     @PropertyType=PropertyType,@Property=PropertyName, @Typess=Type,
     @CheckOutDate=EndDate,@CheckInDate=StartDate,
     @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
 
    -- SELECT @NoOfDays;
     WHILE (@TotalDays>0)   
     BEGIN         
     INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property, Typess,
     CheckInDate,CheckOutDate,TotalDays,
     CheckOutNo,GuestName,GuestId,ClientName,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,PrintInvoice)
		
		   SELECT  @RoomId,@PropertyId,@Tariff,'Managed G H',@Property,@Typess,
           CONVERT(NVARCHAR(100),@CheckOutDate,103),
           CONVERT(NVARCHAR,DATEADD(DAY,@J,CAST(@CheckInDate AS DATE)),103),1,
           0 CheckOutNo,0 GuestName,0 GuestId,0 ClientName,
           0 BookingId,0 ChkoutId,0 ChkInHdrId,0 TariffPaymentMode,0 PrintInvoice
			 SET @J=@J+1  
			 SET @TotalDays=@TotalDays-1   
		IF @TotalDays=0  
			 BEGIN    
			 
				 DELETE FROM #NDDCountForecast WHERE IDE=@IDE 
					
			     SELECT TOP 1  @RoomId=RoomId,@PropertyId=PropertyId, @Tariff=Tariff, @PropertyType=PropertyType,
			     @Property=PropertyName, @Typess=Type,@CheckOutDate=EndDate,@CheckInDate=StartDate,
				 @J=0,@TotalDays=MonthDiff,@IDE=IDE   FROM #NDDCountForecast
			 END 
			  
     END 
   delete  from #TFFINAL where PropertyType='External Property'
   ---For Externals
   	  CREATE TABLE #ExternalForecastNew(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays bigint) 
	  
      CREATE TABLE #ExternalForecasts(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint)
	  truncate table  #ExternalForecasts
	    INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays 
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus IN ('Booking')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer  
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0   
		 AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0  
		 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
	--oly for cpp  below select Working	 
		 INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)--,G.CurrentStatus  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
	 	 AND G.IsActive=1 AND G.IsDeleted=0  and G.CurrentStatus in('CheckIn','CheckOut')
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecasts)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
	       
	   
		UPDATE #ExternalForecasts SET NofDays=NoOfDays FROM #ExternalForecasts S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut';

  --        UPDATE #ExternalForecasts SET NofDays=1 FROM #ExternalForecasts S
		--JOIN dbo.WRBHBCheckInHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		--S.Type='CheckIn' and NofDays=0;



    INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #ExternalForecasts
	WHERE Occupancy='Single'
	
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #ExternalForecasts
	WHERE Occupancy!='Single'
	GROUP BY BookingId,PropertyAssGustId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays
	
	-- Select * from #ExternalForecastNew  WHERE PropertyId=793  
	  --   order by BookingId;return;
	    --where PropertyId=456
		-- Delete from #TFFINAL where PropertyType='External Property'; 
     --truncate table #TFFINAL;
  --   return;
    Declare @Tacinvoice int;
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC
    FROM #ExternalForecastNew 
     --Select @NoOfDays
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice)
             
	 Select 0 RoomId,@PropertyId,@Tariff,'External Property'PropertyType,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice  --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecastNew  
		END   
         
    END  
   
   CREATE TABLE #Temp(CityName NVARCHAR(100),PropertyName NVARCHAR(100),CheckInDate NVARCHAR(100),
   CheckOutDate NVARCHAR(100),Online DECIMAL(27,2),BTC DECIMAL(27,2),PayToProperty DECIMAL(27,2))
   
   INSERT INTO #Temp(CityName,PropertyName,CheckInDate,CheckOutDate,Online,BTC,PayToProperty)
   SELECT C.CityName,P.PropertyName,CH.CheckInDate,CH.CheckOutDate
   FROM WRBHBChechkOutHdr CH
   JOIN WRBHBCity C ON CH.CityId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
   JOIN WRBHBProperty P ON Ch.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
   WHERE CH.IsActive=1 AND CH.IsDeleted=0 AND 
    month(CONVERT(DATE,CheckOutDate,103))=month(CONVERT(DATE,@Pram3,103))
   
   --Temp Table
   
--    Select * from #NDDCountForecast
--   --Select * from #OutStandingInternal where Tariff!=0
 --return
----All for looop data compltee here
----separat by monthwise			  
   --  Select * from #TFFINAL where PropertyType='External Property'-- and PropertyId=793
   --and MONTH(CONVERT(DATE,CheckOutDate,103))= 8
   --order by BookingId
   -- return;

 --Jan		 
		  INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,ChkOutTariffTotal,
			0,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 1
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 ---feb
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 2
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 --March
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 3
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Aprl
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 4
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--May
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 5
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--June
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 6
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--july
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 7
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Augs
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 8
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Sept
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,ChkOutTariffTotal,0, 0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 9
--oct
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 10
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Nov
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 11
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Decem
			INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 12
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
			
			

			
			Update #MonthWise set PropertyType=p.Category
			from #MonthWise M 
			join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
 
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT p.PropertyName,p.Category,p.Id,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,''PrintInvoice
	from #MonthWise F
	join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' 
	GROUP BY p.PropertyName,p.Category,p.Id  

	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where PropertyType='External Property'
	group by Property,PropertyId,PropertyType,TariffPaymentMode,PrintInvoice


	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,TariffPaymentMode,PrintInvoice)
	SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec,''TariffPaymentMode,PrintInvoice
	FROM #MonthWise  where PropertyType='MANAGED G H' 
	group by Property,PropertyId,PropertyType,PrintInvoice
	
	--SELECT p.PropertyName, m.PropertyType PropertyType,PropertyId,
	--sum(Jan),sum(Feb),sum(Mar) as March,sum(Aprl),sum(may),sum(Jun) as june,
	--sum(Jul) as jul,sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) as dec 
	--FROM #MonthWise m
	--join wrbhbproperty p on p.Id=m.PropertyId
	-- where m.PropertyType='External Property'
	
	--group by m.PropertyType,PropertyId,p.PropertyName 
	--return;  
 --   select * from #MonthWise where  PropertyId=762;
  --return
	  ---------------------------------------------------------------------------
	  -----final select for internal
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('Internal Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property,PropertyType,PropertyId, 
	    dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))   
		from #MonthWiseFinal where PropertyType='Internal Property'
		GROUP BY Property,PropertyType,PropertyId 

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal where PropertyType='Internal Property'

	  -----final select for External
	  
	   INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('External Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'online' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
		from #MonthWiseFinal 
		where PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinal 
		where PropertyType='External Property' and TariffPaymentMode='Direct'

		--INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		--select Property,PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm 
		--from #MonthWiseFinal where PropertyType='External Property'
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-External') Property,''PropertyType,''PropertyId, 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinal where PropertyType='External Property' 
		
	 INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
 -----final select for Managed
 
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('MANAGED G H') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property, 'MANAGED G H' PropertyType,PropertyId, 
		--Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm 
		dbo.CommaSeprate(ISNULL((Jan),0)), dbo.CommaSeprate(ISNULL((FEb),0)),
		dbo.CommaSeprate(ISNULL((Mar),0)),dbo.CommaSeprate(ISNULL((Aprl),0)),
		dbo.CommaSeprate(ISNULL((may),0)),dbo.CommaSeprate(ISNULL((Jun),0)),
		dbo.CommaSeprate(ISNULL((Jul),0)),dbo.CommaSeprate(ISNULL((Aug),0)),
		dbo.CommaSeprate(ISNULL((Sept),0)),dbo.CommaSeprate(ISNULL((Oct),0)),
		dbo.CommaSeprate(ISNULL((Nov),0)),dbo.CommaSeprate(ISNULL((Decm),0)) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' 
		--and Jan!=0 and FEb!=0 and Mar!=0 and Aprl!=0 and may!=0 and Jun!=0 
		-- and Jul!=0 and Aug!=0 and Sept!=0 and Oct!=0 and Nov!=0 and Decm!=0
			and (Jan+FEb+Mar+Aprl+may+Jun+Jul+Aug+Sept+Oct+Nov+Decm)!=0

		INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 COALESCE(upper('Total Amount-MANAGED GH'),'#FFFFFF') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		-- sum(Jan) ,sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' 

        INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
 --GrandTotal AMount
	INSERT INTO	#MonthWiseFinalNew( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		--sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal ;
		--update #MonthWiseFinalNew set PropertyId='' where PropertyType=''
		Select Property PropertyName,PropertyType,isnull(PropertyId,'') PropertyId, 
		isnull(Jan,'')JAN ,isnull(FEb,'') FEB,isnull(Mar,'')MARCH,isnull(Aprl,'')APRL,
		isnull(may,'')MAY,isnull(Jun,'')JUNE,isnull(Jul,'')JULY,isnull(Aug,'')AUG,
		isnull(Sept,'')SEPT,isnull(Oct,'')OCT,isnull(Nov,'')NOV,isnull(Decm,'')DEC,0 as SNo 
		from #MonthWiseFinalNew 
		--  Return;
		
 --	for second grid 
	
	 ---For Externals
         CREATE TABLE #ExternalForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),IDE INT PRIMARY KEY IDENTITY(1,1),NofDays Bigint)
	  
	    INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  ,
		 DATEDIFF(day, CONVERT(DATE,g.ChkInDt,103), CONVERT(DATE,G.ChkOutDt,103)) NofDays 
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus IN ('Booking')  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer  
	       
	        --GET CHECKOUT DATE   
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0   AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
		 
		  
		UPDATE #ExternalForecast SET NofDays=NoOfDays FROM #ExternalForecast S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut'
	   --where PropertyId=456
		-- Delete from #TFFINAL where PropertyType='External Property'; 
     truncate table #TFFINAL;
  --   return;
     
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC
    FROM #ExternalForecast  WHERE TAC=1  
     --Select @NoOfDays
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice)
             
	 Select 0 RoomId,@PropertyId,isnull(((@Tariff*@TAC)/100),0),'External Property'PropertyType,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice  --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecast WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecast  WHERE TAC=1 
		END   
         
    END  
   -- truncate table #TFFINAL;
  -- For tAc=0
  Declare @SingleandMarkup decimal(27,2), @SingleTariff  decimal(27,2),@Markup  decimal(27,2);
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,@SingleandMarkup=isnull(SingleandMarkup,0),
    @SingleTariff=isnull(SingleTariff,0),@Markup=Markup,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
    FROM #ExternalForecast  WHERE TAC=0  
    --  Select isnull((@SingleandMarkup-@SingleTariff),0)+@Markup as dd
    WHILE (@NoOfDays>0)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
             BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice)
             
	 Select 0 RoomId,@PropertyId,isnull((@SingleandMarkup-@SingleTariff),0)+@Markup,
	 'External Property'PropertyType,''Property,@Typess ,
     @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode, @Tacinvoice --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecast WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= NofDays,@Typess=Type,@GuestName=BookingLevel,
			@SingleandMarkup=isnull(SingleandMarkup,0),  @SingleTariff=isnull(SingleTariff,0),@Markup=Markup,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecast  WHERE TAC=0 
		END   
         
    END  
    --Select * from #TFFINAL where
    --MONTH(CONVERT(DATE,CheckOutDate,103))= 8;--where TariffPaymentMode='Direct'
    --return;
--INSERT INTO #ExternalNet(GuestId,BookingId,PropertyId,ChkInHdrId,MarkUpAmount,CheckInDate ,CheckOutDate)
--SELECT H.GuestId,H.BookingId,H.PropertyId,H.ChkInHdrId,T.MarkUpAmount,T.CheckInDate,T.CheckOutDate
--FROM  WRBHBChechkOutHdr H
--join WRBHBExternalChechkOutTAC T ON H.Id=T.ChkOutHdrId  AND T.IsActive=1 AND T.IsDeleted=0
--WHERE H.PrintInvoice=0 AND H.IsActive=1 AND H.IsDeleted=0 AND H.PropertyType='External Property' AND H.RoomId=0;
--		---Jan to december fo  2nd table
				 
 --Jan		 
		INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,ChkOutTariffTotal,
			0,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 1
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 ---feb
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
					
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 2
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
 --March
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 3
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Aprl
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 4
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--May
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			 SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 5
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--June
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
		   SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 6
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--july
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 7
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Augs
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,ChkOutTariffTotal,0,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 8
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Sept
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,ChkOutTariffTotal,0,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 9
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
					
					
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 10
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Nov
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
		    SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,0,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 11
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2
--Decem
			INSERT INTO	#MonthWiseNet( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
					ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,
					Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,0,
			0,0,0,0,0,0,0,0,0,0,ChkOutTariffTotal,PrintInvoice
			FROM #TFFINAL  WHERE
			MONTH(CONVERT(DATE,CheckOutDate,103))= 12
			AND YEAR(CONVERT(DATE,CheckOutDate,103))=@Param2


		  -----final select for internal
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('Internal Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 

		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select p.PropertyName ,p.Category,p.Id, 
	    dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
		from #MonthWiseFinal F
		join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
		where f.PropertyType='Internal Property' 
		GROUP BY p.PropertyName,p.Category,p.Id 

		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Total Amount-Internal') Property,''PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
		from #MonthWiseFinal where PropertyType='Internal Property'

	  -----final select for External
	  
	   INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('External Property') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'online' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,'BTC'PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))   
		from #MonthWiseFinal 
		WHERE PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,'Pay at property'PropertyType,''PropertyId, 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseNet 
		where PropertyType='External Property' and TariffPaymentMode='Direct';
  
        INSERT INTO #MonthWiseFinalNewNetExtTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'BTC' Property,'BTC'PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm)  
		from #MonthWiseFinal 
		WHERE PropertyType='External Property' and TariffPaymentMode='Bill To Company (BTC)'
	   INSERT INTO #MonthWiseFinalNewNetExtTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 'Pay at property' Property,'BTC'PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	    sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseNet 
		where PropertyType='External Property' and TariffPaymentMode='Direct';
		 
		 INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		 Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		 select top 1 upper('Total Amount-External') Property,''PropertyType,''PropertyId,
		 dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0))  
	     from #MonthWiseFinalNewNetExtTotal
	 -- Select * from #MonthWiseFinalNewNet  return;
  --  Select * from #TFFINAL  where PropertyType='External Property'  and PropertyId=456
   --   and PropertyId=456
     
      INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 '' Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
	  -----final select for Managed
 
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('MANAGED G H') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select Property, 'MANAGED G H' PropertyType,PropertyId, 
		dbo.CommaSeprate(ISNULL((Jan),0)), dbo.CommaSeprate(ISNULL((FEb),0)),
		dbo.CommaSeprate(ISNULL((Mar),0)),dbo.CommaSeprate(ISNULL((Aprl),0)),
		dbo.CommaSeprate(ISNULL((may),0)),dbo.CommaSeprate(ISNULL((Jun),0)),
		dbo.CommaSeprate(ISNULL((Jul),0)),dbo.CommaSeprate(ISNULL((Aug),0)),
		dbo.CommaSeprate(ISNULL((Sept),0)),dbo.CommaSeprate(ISNULL((Oct),0)),
		dbo.CommaSeprate(ISNULL((Nov),0)),dbo.CommaSeprate(ISNULL((Decm),0)) 
		from #MonthWiseFinal where PropertyType='MANAGED G H'
		--and (isnull(Jan,'')+isnull(FEb,'')+isnull(Mar,'')+isnull(Aprl,'')+isnull(may,'')+isnull(Jun,'')
		--+isnull(Jul,'')+isnull(Aug,'')+	isnull(Sept,'')+isnull(Oct,'')+isnull(Nov,'')+isnull(Decm,''))!=0
		and (Jan+FEb+Mar+Aprl+may+Jun+Jul+Aug+Sept+Oct+Nov+Decm)!=0

		
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 COALESCE(upper('Total Amount-MANAGED GH'),'#FFFFFF') Property,''PropertyType,''PropertyId, 
		 --sum(Jan) ,sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' 
 --Grand Total Sending
	    INSERT INTO	#MonthWiseGrandTotal( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId, 
		sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		from #MonthWiseFinal where PropertyType='MANAGED G H' or  PropertyType='Internal Property'
 --Grand Total Sending	 
		 INSERT INTO  #MonthWiseGrandTotal( Property,PropertyType,PropertyId, 
		 Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		 select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId,
		 sum(Jan),sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),
	     sum(Jul),sum(Aug),sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
	     from #MonthWiseFinalNewNetExtTotal
	     
		INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		select top 1 UPPER('') Property,''PropertyType,''PropertyId, 
		''Jan,''FEb,''Mar,''Aprl,''may,''Jun,''Jul,''Aug,''Sept,''Oct,''Nov,''Decm 
		from #MonthWiseFinal 
		
	     
	    INSERT INTO	#MonthWiseFinalNewNet( Property,PropertyType,PropertyId, 
		 Jan,FEb,Mar,Aprl,may,Jun,Jul,Aug,Sept,Oct,Nov,Decm)
		--select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId, 
		-- sum(Jan) ,sum(FEb),sum(Mar),sum(Aprl),sum(may),sum(Jun),sum(Jul),sum(Aug),
		-- sum(Sept),sum(Oct),sum(Nov),sum(Decm) 
		--from #MonthWiseGrandTotal  
		
		select top 1 upper('Grand Total') Property,''PropertyType,''PropertyId,
		dbo.CommaSeprate(ISNULL(sum(Jan),0)), dbo.CommaSeprate(ISNULL(sum(FEb),0)),
		dbo.CommaSeprate(ISNULL(sum(Mar),0)),dbo.CommaSeprate(ISNULL(sum(Aprl),0)),
		dbo.CommaSeprate(ISNULL(sum(may),0)),dbo.CommaSeprate(ISNULL(sum(Jun),0)),
		dbo.CommaSeprate(ISNULL(sum(Jul),0)),dbo.CommaSeprate(ISNULL(sum(Aug),0)),
		dbo.CommaSeprate(ISNULL(sum(Sept),0)),dbo.CommaSeprate(ISNULL(sum(Oct),0)),
		dbo.CommaSeprate(ISNULL(sum(Nov),0)),dbo.CommaSeprate(ISNULL(sum(Decm),0)) 
		from #MonthWiseGrandTotal  
	 
		Select Property PropertyName,PropertyType,PropertyId PropertyId, 
		isnull(Jan,'')JAN ,isnull(FEb,'') FEB,isnull(Mar,'')MARCH,isnull(Aprl,'')APRL,
		isnull(may,'')MAY,isnull(Jun,'')JUNE, ISNULL(JUL,'') JULY,
		 ISNULL(AUG,'') AUG,
		isnull(Sept,'')SEPT,isnull(Oct,'')OCT,isnull(Nov,'')NOV,isnull(Decm,'')DEC,0 as SNo 
		from #MonthWiseFinalNewNet  
		END
 END  
 
 
 
