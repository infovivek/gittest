-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ReportForeCast_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ReportForeCast_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:o2-06-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	Report Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_ReportForeCast_Help](
@Action NVARCHAR(100),
@Pram1	 BIGINT, 
@Pram2	 BIGINT,
@Pram3	 NVARCHAR(100),
@Pram4	 NVARCHAR(100),
@Pram5	 NVARCHAR(100),
@UserId  BIGINT)			
AS
BEGIN
--exec SP_ReportForeCast_Help @Action='BookingForecast',@Pram1=0,@Pram2=0,@Pram3='01/11/2014',@Pram4='',@Pram5='External Property',@UserId=1
IF @Action ='PropertyAndCity'
 BEGIN
	
	  CREATE TABLE #PROPERTYCITY(PropertyName NVARCHAR(100),Id BIGINT,Category NVARCHAR(100))
	  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
	  SELECT  'All Properties',0,'' 
	  IF @Pram5='All Properties'
	  BEGIN	
          INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
		  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
		  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('Internal Property','Managed G H','External Property')	  
	  END
	  ELSE
	  BEGIN 
		  IF(@Pram5='Internal Property')
		  BEGIN	
			  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
			  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
			  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('Internal Property','Managed G H')
		  END
		  ELSE
		  BEGIN
			  INSERT INTO #PROPERTYCITY(PropertyName,Id,Category)
			  SELECT  PropertyName,Id,Category FROM dbo.WRBHBProperty   
			  WHERE IsActive=1 AND IsDeleted=0 AND Category IN('External Property')
		  END
	  END
	  SELECT  PropertyName,Id ZId FROM #PROPERTYCITY 
	  
	  SELECT CityName,Id FROM WRBHBCity  
	  WHERE IsActive=1 AND IsDeleted=0 
	  --AND Category in('Internal Property','Managed G H') ;	  
 END 
 IF @Action ='BookingForecast'
 BEGIN 
	  	  
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
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),PrintInvoice bit)
 
CREATE TABLE #MonthWiseFinal( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),TariffPaymentMode nvarchar(100),PrintInvoice bit,Bookingid Bigint,CityId Bigint)

CREATE TABLE #MonthWiseFinal1( Property NVARCHAR(200),PropertyId BIGINT,PropertyType NVARCHAR(100), 
Tariff DECIMAL(27,2),Dedicat DECIMAL(27,2),Direct DECIMAL(27,2),Btc DECIMAL(27,2),Onlin DECIMAL(27,2),
Gtv DECIMAL(27,2),Total DECIMAL(27,2),TariffPaymentMode nvarchar(100),PrintInvoice bit)


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


Create Table #Temp1Final(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2),Pid Bigint,CityId Bigint )

Create Table #Temp1Finals(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2),Pid Bigint )

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
					AND TariffPaymentMode!='Bill to Client'  and h.IntermediateFlag=0
					
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
			--where YEAR(CONVERT(DATE,CheckOutDate,103))=@Pram2 AND YEAR(CONVERT(DATE,CheckInDate,103))=@Pram2
			
		  

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
  --Select * from #TFFINAL  
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
			--    truncate table #TFFINALS;
			INSERT INTO #TFFINALS( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,PropertyId,PropertyType,
			ChkOutTariffTotal,CheckOutDate,CheckInDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,PrintInvoice,TotalDays) 
			   
				SELECT DISTINCT BookingCode,FirstName,0,g.RoomId,P.Category,ClientName,P.PropertyName,
				g.BookingPropertyId,'Booked',g.Tariff,CONVERT(NVARCHAR,G.ChkOutDt,103) ChkoutDt,
				CONVERT(NVARCHAR,H.CheckInDate,103) ChkInDt,H.Id,0 as ChkoutId,0,
				G.TariffPaymentMode,0,DateDiff(DAY,H.CheckInDate,h.CheckOutDate)
				FROM WRBHBBooking  H
				join WRBHBBookingPropertyAssingedGuest G on G.BookingId=H.Id 
				AND G.IsActive=1 and G.IsDeleted=0 and g.CurrentStatus in('Booked')--,'Checkout','Checkin')--AND H.ApartmentId					
				JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId=P.Id AND P.IsActive=1	AND P.IsDeleted=0
				and p.Category in('Internal Property')  and h.id not in(Select BookingId from #TFFINALS)
				WHERE H.IsActive=1 AND H.IsDeleted=0 AND CurrentStatus!='Canceled' 
				AND TariffPaymentMode!='Bill to Client' and g.RoomShiftingFlag=0
				order by H.Id	 
		  
	 UPDATE #TFFINALS SET TotalDays=1 WHERE ISNULL(TotalDays,0)=0
		 
--	 truncate table #TFFINAL;
 
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
    -- Select * from #TFFINAL --where typ =2  and MONTH(CONVERT(DATE,CheckOutDate,103))= 9
  --  order by BookingId;return;
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
   delete  from #TFFINAL where PropertyType='External Property'-- and TariffPaymentMode='Direct'
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
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  AND G.CurrentStatus IN ('Booked')  
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
	       
	     INSERT INTO #ExternalForecasts(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays) 
Select Distinct C.id,Ag.guestid,Ag.RoomType,ag.FirstName,convert(nvarchar(100),Ag.ChkInDt,103) CheckinDate,
convert(nvarchar(100),Ag.ChkOutDt,103),'CheckIn' CurrentStatus,AG.Occupancy,'Room',Tariff,'MMT'Category,
--Ag.RoomId, C.clientname,S.HotalName,S.HotalId,'External Property',
ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,Bp.PropertyId Id ,
ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt) as nodays
--,DateDiff(day,Ag.ChkInDt,Ag.ChkOutDt)*AG.Tariff,
--0,convert(nvarchar(100),Ag.ChkInDt,103) ChkInDt,Ag.TariffPaymentMode
 --,AG.RackDouble,ag.RackSingle,Ag.BookingPropertyId ,S.HotalId,C.Id
from wrbhbbooking C
join  WRBHBBookingPropertyAssingedGuest AG WITH(NOLOCK) ON C.Id= AG.BookingId AND AG.IsActive = 1 and AG.IsDeleted = 0
join WRBHBStaticHotels S   WITH(NOLOCK) ON Ag.BookingPropertyId = S.HotalId and s.IsActive=1 and s.IsDeleted=0
JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON C.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		and  PropertyType='MMT' 
LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId=bp.PropertyId AND PA.IsDeleted=0  
 where Convert(date,Ag.ChkInDt,103)>= CONVERT(date,'01/09/2014',103)
  Group by C.id,Ag.guestid,Ag.RoomType,ag.FirstName,Ag.ChkInDt,Ag.ChkOutDt,CurrentStatus,
 AG.Occupancy,Tariff,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,s.HotalId ,
ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),Bp.PropertyId
 
-- Select * from WRBHBBookingProperty where PropertyType='MMT'

 
		UPDATE #ExternalForecasts SET NofDays=NoOfDays FROM #ExternalForecasts S
		JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		S.Type='CheckOut';

  --        UPDATE #ExternalForecasts SET NofDays=1 FROM #ExternalForecasts S
		--JOIN dbo.WRBHBCheckInHdr A WITH(NOLOCK) ON S.BookingId=A.BookingId AND
		--S.Type='CheckIn' and NofDays=0;


truncate table #ExternalForecastNew;
 --truncate table #TFFINAL;
    INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0) FROM #ExternalForecasts
	WHERE Occupancy='Single'
	
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,''PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,isnull(NofDays,0) FROM #ExternalForecasts
	WHERE Occupancy!='Single'
	GROUP BY BookingId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays
	
	
	 update #ExternalForecastNew set NofDays=1   where NofDays=0;
	
	-- Select * from  #TFFINAL --where category = 'MMT' 
 -- order by BookingId;return;
	-- Select * from #ExternalForecastNew where category = 'MMT'  
	----     order by BookingId;return;
	    --where PropertyId=456
		-- Delete from #TFFINAL where PropertyType='External Property'; 
     --truncate table #TFFINAL;
  --   return;
    Declare @Tacinvoice int;Declare @Category nvarchar(100);
    SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
    @NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
    @CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
    @TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE ,@Tacinvoice=TAC
    FROM #ExternalForecastNew 
      --Select @NoOfDays
    WHILE (@NoOfDays>=1)  
    BEGIN       
		    INSERT INTO #TFFINAL(RoomId,PropertyId,ChkOutTariffTotal,PropertyType,Property,Typess,
             CheckInDate,CheckOutDate,TotalDays,CheckOutNo,GuestName,GuestId,ClientName,
            BookingId,ChkoutId,ChkInHdrId,TariffPaymentMode,PrintInvoice)
             
	 Select 0 RoomId,@PropertyId,@Tariff,@Category,''Property,@Typess ,
	 @CheckOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@j,CONVERT(DATE,@CheckInDate,103)),103),1,
     0 CheckOutNo,@GuestName,@GuestId,''ClientName,@BookingId,0 ChkoutId,0 ChkInHdrId,
	 @TariffPaymentMode,@Tacinvoice  --from #ExternalForecast WHERE TAC=1 
	      
		SET @j=@j+1  
		SET @NoOfDays=isnull(@NoOfDays,0)-1
		IF isnull(@NoOfDays,0)=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew WHERE  IDE=@IDE  
	        
			SELECT TOP 1 @Tariff=Tariff,@GuestId=PropertyAssGustId,@BookingId=BookingId,
			@NoOfDays= isnull(NofDays,0),@Typess=Type,@GuestName=BookingLevel,@Category=Category,
			@CheckInDate=CheckInDt,@CheckOutDate=CheckOutDt,@PropertyId=PropertyId,@TAC=TACPer,
			@TariffPaymentMode=TariffPaymentMode,@j=0,@IDE=IDE  ,@Tacinvoice=TAC
			FROM #ExternalForecastNew  
		END    
    END  
    --Select * from  #TFFINAL where PropertyType like '%MMT%' 
  --return;
 --Tariff		 
		INSERT INTO	#MonthWise( CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
		PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
		TariffPaymentMode,Tariff,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice) 
			SELECT CheckOutNo,GuestName,GuestId,RoomId,Typess,ClientName,Property,
			PropertyId,PropertyType,ChkOutTariffTotal,CheckOutDate,BookingId,ChkoutId,ChkInHdrId,
			TariffPaymentMode,ChkOutTariffTotal,0 Dedicat,0 Direct,0 Btc,0 Onlin,0 Gtv,0 Total,PrintInvoice
			FROM #TFFINAL  WHERE
			month(CONVERT(DATE,CheckOutDate,103))=month(CONVERT(DATE,@Pram3,103))
             AND YEAR(CONVERT(DATE,CheckOutDate,103))=Year(CONVERT(DATE,@Pram3,103))
			--MONTH(CONVERT(DATE,CheckOutDate,103))= 10
		--	AND YEAR(CONVERT(DATE,CheckOutDate,103))=2014
  
 --select * from #TFFINAL where PropertyType not in('Internal Property','MANAGED G H')
		--and MONTH(CONVERT(DATE,CheckOutDate,103))= 11
   --order by BookingId
			--Update #MonthWise set PropertyType=p.Category
			--from #MonthWise M 
			--join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1 
 
--Select * from  #MonthWise  where PropertyType like '%MMT%'
 --order by BookingId 
 --return;
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(Tariff) Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId
	from #MonthWise F
	left outer join WRBHBProperty p on f.PropertyId=p.Id and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0  and TariffPaymentMode='Bill to Company (BTC)'  
	GROUP BY p.PropertyName,p.Category,p.Id  ,f.Bookingid,p.CityId
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	SELECT p.PropertyName,p.Category,p.Id,
	0  ,''TariffPaymentMode,0 Dedicat,sum(Tariff) Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	''PrintInvoice,f.Bookingid,P.CityId
	from #MonthWise F
	left outer join WRBHBProperty p on p.Id=f.PropertyId and p.IsActive=1 and p.IsDeleted=0 and p.Category='Internal Property'
	where f.PropertyType='Internal Property' and ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	GROUP BY p.PropertyName,p.Category,p.Id ,f.Bookingid,p.CityId
  
	 -- Select * from #MonthWise where PropertyType not  in('Internal Property','MANAGED G H')
	 --Return;
	 
	 
	--  UPDATE #MonthWise SET PropertyType = P.PropertyType 
	--  FROM #MonthWise F 
	--  JOIN WRBHBBookingProperty p WITH(NOLOCK) ON p.BookingId=F.BookingId AND P.IsActive=1 AND IsDeleted=0
	 
	UPDATE #MonthWise SET Property  = P.HotalName 
	 FROM #MonthWise F 
	 left outer JOIN  WRBHBStaticHotels p WITH(NOLOCK) ON p.HotalId=F.PropertyId AND P.IsActive=1 AND IsDeleted=0 
	 WHERE F.PropertyType='MMT'
	 
	 UPDATE #MonthWise SET Property = P.PropertyName 
	 FROM #MonthWise F 
	 left outer JOIN  WRBHBProperty p WITH(NOLOCK) ON p.Id=F.PropertyId  AND P.IsActive=1 AND IsDeleted=0
	 WHERE F.PropertyType='External Property'
	 
	 
	 
	 
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
   Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	Select p.Property,P.PropertyType,P.PropertyId, 
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, 0 Gtv,sum(P.Tariff) Total,
	''PrintInvoice,P.Bookingid,0--PP.CityId 
	from #MonthWise  p
--	left outer join wrbhbbooking PP on    p.BookingId=PP.Id   and pP.IsActive=1
--	left outer  JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON --P.PropertyId=BP.PropertyId and
--	p.BookingId=Bp.BookingId AND BP.IsActive=1	 AND BP.IsDeleted=0  --and Bp.PropertyType='ExP'
	 where P.PropertyType in ('External Property') and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Bill to Company (BTC)' 
	group by  p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,P.Bookingid 
	order by P.PropertyId
	 
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
   Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	Select p.Property,P.PropertyType,P.PropertyId, 
	0  ,''TariffPaymentMode,0 Dedicat,0 Direct,sum(P.Tariff) Btc,0 Onlin, 0 Gtv,sum(P.Tariff) Total,
	''PrintInvoice,P.Bookingid,0--PP.CityId 
	from #MonthWise  p
--	left outer join wrbhbbooking PP on    p.BookingId=PP.Id   and pP.IsActive=1
--	left outer  JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON --P.PropertyId=BP.PropertyId and
--	p.BookingId=Bp.BookingId AND BP.IsActive=1	 AND BP.IsDeleted=0  --and Bp.PropertyType='ExP'
	 where P.PropertyType in ('MMT') and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Bill to Company (BTC)' 
	group by  p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,P.Bookingid 
	order by P.PropertyId
	
	
	  INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
     Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	Select  p.Property,P.PropertyType, P.PropertyId,
	0  ,''TariffPaymentMode,0 Dedicat,Sum(P.ChkOutTariffTotal)  Direct,0 Btc,0 Onlin, 0 Gtv,Sum(P.ChkOutTariffTotal) Total,
	''PrintInvoice,p.BookingId,0--p.CityId
	from #MonthWise  p
	--left outer JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON P.PropertyId=BP.PropertyId
	-- AND BP.IsActive=1 AND BP.IsDeleted=0  and Bp.PropertyType='ExP' and p.BookingId=Bp.BookingId
	-- join WRBHBProperty PP on BP.PropertyId=pP.Id and pP.IsActive=1
	where P.PropertyType='External Property' and P.ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	group by   p.Property,P.PropertyType,TariffPaymentMode,P.PropertyId,p.BookingId--,Pp.CityId
	order by P.PropertyId
	
	
      UPDATE #MonthWiseFinal SET CityId = P.CityId 
	  FROM #MonthWiseFinal F 
	  JOIN WRBHBBooking p WITH(NOLOCK) ON p.Id=F.BookingId AND P.IsActive=1 AND IsDeleted=0
	 
       UPDATE #MonthWiseFinal SET PropertyType = 'External Property'
	  FROM #MonthWiseFinal F  
	  WHERE F.PropertyType='MMT';
	  
	 --  Select * from #MonthWise where PropertyType='External Property'
	  
	 --Select * from #MonthWise where propertyType='MMT'
	 -- return    
	 
     
	 		    
	--SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	--0  ,''TariffPaymentMode,0 Dedicat,sum(Tariff) Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,''PrintInvoice
	--FROM #MonthWise  where PropertyType='External Property' and ChkOutTariffTotal!=0 and TariffPaymentMode='Direct' 
	--group by Property,PropertyId,PropertyType,TariffPaymentMode,PrintInvoice
	--order by PropertyId
	
	 --return;
	
	INSERT INTO	#MonthWiseFinal( Property,PropertyType,PropertyId, 
	Tariff,TariffPaymentMode,Dedicat,Direct,Btc,Onlin,Gtv,Total,PrintInvoice,Bookingid,CityId)
	
	SELECT Property PropertyName,m.PropertyType PropertyType,m.PropertyId,
	0  ,''TariffPaymentMode,sum(Tariff) Dedicat,0 Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,
	PrintInvoice,m.Bookingid,P.CityId
	FROM #MonthWise m
	join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
	JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
	--left outer JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON BP.PropertyId=p.id and Bp.Isactive=1
	  where m.PropertyType='MANAGED G H' and TariffPaymentMode='0' and ChkOutTariffTotal!=0
	group by Property,m.PropertyId,m.PropertyType,PrintInvoice,m.Bookingid,P.CityId
	order by m.PropertyId
	
	--SELECT Property PropertyName,PropertyType PropertyType,PropertyId,
	-- 0  ,''TariffPaymentMode,sum(Tariff) Dedicat,0 Direct,0 Btc,0 Onlin, 0 Gtv,sum(Tariff) Total,''PrintInvoice,0 Bookingid
	--FROM #MonthWise  where PropertyType='MANAGED G H' and TariffPaymentMode='0' and ChkOutTariffTotal!=0
	--group by Property,PropertyId,PropertyType,PrintInvoice
	--order by PropertyId
	
	 --Select * from #MonthWiseFinal  
	 -- Return	
	
	 
	If(@Pram5='All Properties')
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
		--join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1
		--JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0  
		JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	Else
	Begin
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select C.CityName CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,m.PropertyId,'A',m.CityId
		from #MonthWiseFinal m
		--join WRBHBProperty P on m.PropertyId=p.Id and p.IsActive=1 
		--JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0  
		JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=m.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		where m.PropertyType=@Pram5
		group by  Property,m.PropertyId,m.PropertyType,C.CityName,m.CityId
		order by m.PropertyType
		
		Insert into #Temp1Final(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData,CityId)
		Select ''CityName, Property PropertyName ,
		Sum(Dedicat) DD,Sum(Direct) Direct,Sum(Btc) BTC,
		0 Online,Sum(Direct+Btc+Dedicat) Total,Sum(Direct+Btc+Dedicat) GTV,m.PropertyType,0 Id,'A',m.CityId
		from #MonthWiseFinal m
		where  m.PropertyId=0 --and p.IsActive=1
		--JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0 
		group by  Property,m.PropertyType,m.CityId--,C.CityName
		order by m.PropertyType
	End
	if(@Pram1=0)
	Begin
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,'A'OrderData
		From #Temp1Final 
		order by Category
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select ''CityName,'TOTAL'PropertyName,Sum(DD),Sum(Direct),Sum(BTC),Sum(Online),Sum(TOTAL),Sum(GTV),
		''Category,''Pid,'Z'OrderData
		From #Temp1Final
	End
	else
	Begin
	   	Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,'A'OrderData
		From #Temp1Final 
		Where CityId=@pram1
		order by Category
		Insert into #Temp1Finals(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData)
		Select ''CityName,'TOTAL'PropertyName,Sum(DD),Sum(Direct),Sum(BTC),Sum(Online),Sum(TOTAL),Sum(GTV),
		''Category,''Pid,'Z'OrderData
		From #Temp1Final
		Where CityId=@pram1
	End
	--Group  by CityName,PropertyName,Category,Pid,OrderData 
	Select CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,Pid,OrderData
	From #Temp1Finals
	order by OrderData
	
	
	
	
	
 END
END




	
	