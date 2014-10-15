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
		--drop table #BookingForecast
		--drop table #BookingCountForecast
		--drop table #CheckInForecast
		--drop table #CheckOutForecast
		--drop table #OccupancyForecast
		--drop table #CheckInForecastFinal
		--drop table #OccupancyFinalForecast
		--drop table #NDDCountForecast
		--drop table #OccupancyDataForecast
		--drop table #ApartmentBookingIdForecast
		--drop table #ApartmentBookingIdCountForecast
		--drop table #ApartmentGuestNameForecast
		--drop table #RevanueBookingForecast
		--drop table #OutStandingBookingForecast
		--drop table #ExternalForecast
		--drop table #OutStanding
		--drop table #RevanueNDD
		--drop table #RevanueDD
		--drop table #RevanueExternalTAC
		--drop table #RevanueExternalMarkUp
		--drop table #CheckInRevanueExternalTAC
		--drop table #CheckInRevanueExternalMarkUp
		--drop table #CheckInRevanueNDD
		--drop table #CheckInRevanueDD
		--drop table #RevanueCheckInForecast
		--drop table #ManagedDedicated
		--drop table #OutStandingFinal
		--drop table #CPPCountForecast
		--drop table #CPP
		--drop table #CheckInForecastExternal
		--drop table #CheckOutForecastExternal
		--drop table #FinalBookingForeCast
		--drop table #FinalCheckInForeCast
		--drop table #RevanueNDDInternal 
		--drop table #RevanueNDDFinalInternal 
		--drop table #RevanueDDInternal 
		--drop table #CheckInRevanueNDDInternal 
		--drop table #CheckInRevanueDDInternal
		--drop table #OutStandingInternal
		--drop table #OutStandingFinalInternal
		--drop table #RevanueNDDExternal
		--drop table #RevanueDDExternal
		
	  CREATE TABLE #FinalBookingForeCast(PropertyId BIGINT,CityName NVARCHAR(100),PropertyName NVARCHAR(100),
	  NDDRevenue DECIMAL(27,2),DDRevenue DECIMAL(27,2),TOTAL DECIMAL(27,2),OutStanding DECIMAL(27,2),
	  Category NVARCHAR(100),GTV DECIMAL(27,2),ActualTariff DECIMAL(27,2))

	  CREATE TABLE #FinalCheckInForeCast(PropertyId BIGINT,CityName NVARCHAR(100),PropertyName NVARCHAR(100),
	  NDDRevenue DECIMAL(27,2),DDRevenue DECIMAL(27,2),TOTAL DECIMAL(27,2),OutStanding DECIMAL(27,2),
	  Category NVARCHAR(100),GTV DECIMAL(27,2),ActualTariff DECIMAL(27,2))
	
	  CREATE TABLE #BookingForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PropertyType NVARCHAR(100),ApartmentId BIGINT)
	  
	  CREATE TABLE #BookingCountForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,DataGetType NVARCHAR(100)) 
	  
	  CREATE TABLE #CheckInForecast(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1))
	  
	  CREATE TABLE #CheckInForecastExternal(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),NofDays BIGINT)
	  
	  CREATE TABLE #CheckInForecastExternalNew(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),NofDays BIGINT)
	  
	  CREATE TABLE #CheckOutForecast(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,DataGetType NVARCHAR(100),
	  NoOfDays BIGINT,PID INT PRIMARY KEY IDENTITY(1,1))
	  
	  CREATE TABLE #CheckOutForecastExternal(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1))
	  
	  CREATE TABLE #CheckOutForecastCPP(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),CurrentStatus NVARCHAR(100),NofDays INT)
	  
	  CREATE TABLE #BookingForecastCPP(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),CurrentStatus NVARCHAR(100))
	  
	  CREATE TABLE #BookingForecastCPPFinal(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),CurrentStatus NVARCHAR(100))
	  
	  CREATE TABLE #CheckOutForecastCPPLoopData(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),CurrentStatus NVARCHAR(100),NofDays INT,
	  CurrentDate NVARCHAR(100))
	  
	  CREATE TABLE #BookingForecastCPPLoopData(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(100),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),PropertyAssGustId BIGINT,
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),ApartmentId BIGINT,
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1),CurrentStatus NVARCHAR(100),
	  CurrentDate NVARCHAR(100))
	  
	  CREATE TABLE #OccupancyForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,DataGetType NVARCHAR(100))
	  
	  CREATE TABLE #CheckInForecastFinal(BookingId BIGINT,CheckInId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,DataGetType NVARCHAR(100),
	  ApartmentId BIGINT,IDE INT PRIMARY KEY IDENTITY (1,1),NoOfDays BIGINT)
	  
	  CREATE TABLE #OccupancyFinalForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,DataGetType NVARCHAR(100),
	  IDE INT PRIMARY KEY IDENTITY (1,1))
	  
	  CREATE TABLE #ExternalForecast(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1))
	  
	  CREATE TABLE #ExternalForecastNew(BookingId BIGINT,RoomId BIGINT,RoomName NVARCHAR(100),GuestName NVARCHAR(2000),
	  CheckInDt NVARCHAR(100),CheckOutDt NVARCHAR(100),Type NVARCHAR(100),Occupancy NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),Tariff DECIMAL(27,2),Category NVARCHAR(100),
	  ServicePaymentMode NVARCHAR(100),TariffPaymentMode NVARCHAR(100),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),Markup DECIMAL(27,2),PropertyId BIGINT,TAC BIT,TACPer DECIMAL(27,2),
	  PropertyAssGustId BIGINT,DataGetType NVARCHAR(100),PID INT PRIMARY KEY IDENTITY(1,1))
	  
	  
	  CREATE TABLE #NDDCountForecast(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100))
	  
	  CREATE TABLE #NDDCountForecastData(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100),
	  PropertyName NVARCHAR(100),Type NVARCHAR(100))
	  
	  CREATE TABLE #OccupancyDataForecast(Data NVARCHAR(100))
	  
	  CREATE TABLE #ApartmentBookingIdForecast(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(100),Category NVARCHAR(100))
	  
	  CREATE TABLE #ApartmentBookingIdCountForecast(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(100))
	  
	  CREATE TABLE #ApartmentGuestNameForecast(BookingId BIGINT,PropertyId BIGINT,GuestName NVARCHAR(100))
	  
	  CREATE TABLE #ManagedDedicated(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100))
	  
	  CREATE TABLE #CPPCountForecast(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100))
	  
	  CREATE TABLE #CPP(RoomId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,Tariff DECIMAL(22,7),PropertyType NVARCHAR(100))
	  
	  CREATE TABLE #RevanueBookingForecast(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),TariffPaymentMode NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,TACPer DECIMAL(27,2),TACRevenue DECIMAL(27,2),MarkUp DECIMAL(27,2),GTV DECIMAL(27,2)) 
	  
	  CREATE TABLE #RevanueCheckInForecast(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,ApartmentId BIGINT,RoomId BIGINT,GTV DECIMAL(27,2),
	  TariffPaymentMode NVARCHAR(100))
	  
	  CREATE TABLE #OutStandingBookingForecast(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,GTV DECIMAL(27,2)) 
	  
	  CREATE TABLE #RevanueExternalTAC(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,TACPer DECIMAL(27,2),TACRevenue DECIMAL(27,2),
	  TariffPaymentMode NVARCHAR(100),GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueExternalMarkUp(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,MarkUp DECIMAL(27,2),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),MarkupRevenue DECIMAL(27,2),TariffPaymentMode NVARCHAR(100),
	  GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueExternalTAC(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,TACPer DECIMAL(27,2),TACRevenue DECIMAL(27,2),
	  TariffPaymentMode NVARCHAR(100),GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueExternalMarkUp(Tariff DECIMAL(27,2),RackTariff DECIMAL(27,2),NoOfDays NVARCHAR(100),
	  RoomType NVARCHAR(100),BookingLevel NVARCHAR(100),ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),
	  BookingId BIGINT,PropertyId BIGINT,MarkUp DECIMAL(27,2),SingleTariff DECIMAL(27,2),
	  SingleandMarkup DECIMAL(27,2),MarkupRevenue DECIMAL(27,2),TariffPaymentMode NVARCHAR(100),GTV DECIMAL(27,2))
	  
	  CREATE TABLE #OutStanding(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,EntryType NVARCHAR(100),GTV DECIMAL(27,2))
	  
	  CREATE TABLE #OutStandingFinal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #OutStandingInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,EntryType NVARCHAR(100),GTV DECIMAL(27,2))
	  
	  CREATE TABLE #OutStandingFinalInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueNDD(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueNDDFinal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueDD(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueNDDExternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueDDExternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueNDD(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueDD(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))  
	  
	  CREATE TABLE #RevanueNDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueNDDFinalInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #RevanueDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueNDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #CheckInRevanueDDInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  CREATE TABLE #BookingOutStandingFinalInternal(Tariff DECIMAL(27,2),ActualTariff DECIMAL(27,2),PropertyId BIGINT,GTV DECIMAL(27,2))
	  
	  

   DECLARE @Tariff DECIMAL(27,2),@ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@Count INT;  
   DECLARE @DateDiff int,@i BIGINT,@HR NVARCHAR(100),@RoomId BIGINT,@BookingId BIGINT,@NoOfDays INT,  
   @RoomType NVARCHAR(100),@BookingLevel NVARCHAR(100),@CheckInId BIGINT,@PropertyId BIGINT,  
   @TACPer DECIMAL(27,2),@SingleTariff DECIMAL(27,2),@SingleandMarkup DECIMAL(27,2),@Markup DECIMAL(27,2),  
   @TariffPaymentMode NVARCHAR(100),@PropertyAssGustId BIGINT,@ApartmentId BIGINT,@CHeckOutTime NVARCHAR(100),
   @CHeckInTime NVARCHAR(100),@IDE INT;  
     
    -- --GET ROOMS ARE DEDICATED OR NON DEDICATER    
   INSERT INTO #NDDCountForecastData(ApartmentId,PropertyId,RoomId,Tariff,PropertyType,PropertyName,Type)  
   SELECT CA.ApartmentId,CA.PropertyId,0,Tariff,ContractType,CA.Property,C.RateInterval 
   FROM dbo.WRBHBContractManagementAppartment CA       
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CA.ContractId AND 
   LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '),LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0  AND
   CONVERT(DATE,@Pram3,103) BETWEEN CONVERT(DATE,C.StartDate,103) AND CONVERT(DATE,C.EndDate,103) 
   WHERE CA.IsActive=1 AND CA.IsDeleted=0 AND CA.ApartmentId!=0 AND CA.PropertyId!=0  
      
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type)     
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval  
   FROM dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId   
   AND LTRIM(ContractType)IN(LTRIM(' Dedicated Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0 AND
   CONVERT(DATE,@Pram3,103) BETWEEN CONVERT(DATE,C.StartDate,103) AND CONVERT(DATE,C.EndDate,103)  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0 AND CR.RoomId!=0  
     
   --GET ROOMS ARE DEDICATED Managed Contracts  
   INSERT INTO #NDDCountForecastData(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type)  
   SELECT CR.RoomId,CR.PropertyId,0,Tariff,ContractType,CR.Property,C.RateInterval   
   FROM  dbo.WRBHBContractManagementTariffAppartment CR  
   JOIN dbo.WRBHBContractManagement C WITH(NOLOCK) ON C.Id=CR.ContractId AND   
   LTRIM(ContractType)IN(LTRIM(' Managed Contracts '))   
   AND C.IsActive=1 AND C.IsDeleted=0 AND
   CONVERT(DATE,@Pram3,103) BETWEEN CONVERT(DATE,C.StartDate,103) AND CONVERT(DATE,C.EndDate,103)  
   WHERE  CR.IsActive=1 AND CR.IsDeleted=0 AND CR.PropertyId!=0  
   
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type)  
   SELECT RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type 
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM(' Monthly ')  
   
   INSERT INTO #NDDCountForecast(RoomId,PropertyId,ApartmentId,Tariff,PropertyType,PropertyName,Type)  
   SELECT RoomId,PropertyId,ApartmentId,(Tariff*DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,CONVERT(DATE,@Pram3,103)),0)))),
   PropertyType,PropertyName,Type 
   FROM #NDDCountForecastData
   WHERE LTRIM(Type)=LTRIM('  Daily  ')
   
    IF @Pram2!=0    
    BEGIN  
		---------------Internal start  
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKINDATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckInDate',  
		 BP.PropertyType 
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))   
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) AND   
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType  
	      
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKOUTDATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckOutDate',  
		 BP.PropertyType    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103))  
		 AND  BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.RoomId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType 
	    
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckOutDate',  
		 BP.PropertyType  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103))  
		 AND  BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.RoomId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType 
	     
	      
		 --GET DATA FROM BOOKING BED LEVEL CHECKIN COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckInDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))   
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) 
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))       
		 --JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 ---AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType  
	       
	       
		  --GET DATA FROM BOOKING BED LEVEL CHECKOUT COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,-1,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,1,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103))
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 ---JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 --AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.BedId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType 
	     
		 --GET DATA FROM BOOKING BED CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE 
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) <  DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 --JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 --AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.BedId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)   
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType  
	       
	      
		 --GET DATA FROM BOOKING APARTMENT LEVEL CHECKIN DATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckInDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))
		 AND DATEADD(d,1,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) 
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId  
	       
	       
		 --GET DATA FROM BOOKING APARTMENT LEVEL CHECKOUT DATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) 
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0      
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.ApartmentId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId
	     
		  --GET DATA FROM BOOKING APARTMENT CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND BookingPropertyId=@Pram2  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0      
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.ApartmentId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId   
	       
	       
		--GET CHECKOUT DATE	
		--ROOM LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,
		 CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 AND B.RoomId=CO.RoomId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,CO.CheckInDate,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 AND B.RoomId=CO.RoomId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 		
		 CONVERT(DATE,CO.CheckOutDate,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays 
		 		  
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.RoomId=CO.RoomId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,CO.CheckInDate,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,CO.CheckOutDate,103)>CONVERT(DATE,@Pram3,103) 
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays  		   
		
		 --Bed LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,
		 CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.BedId=CO.BedId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.BedId=CO.BedId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.BedId=CO.BedId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,B.ChkOutDt,103)>CONVERT(DATE,@Pram3,103)
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 --APARTMENT LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.ApartmentId=CO.ApartmentId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.ApartmentId=CO.ApartmentId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,CO.CheckInDate,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BookingPropertyId=@Pram2 --AND B.ApartmentId=CO.ApartmentId 
		 AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkInDt,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,B.ChkOutDt,103)>CONVERT(DATE,@Pram3,103)
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CO.CheckInDate,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays	
		 
		SELECT * FROM #CheckOutForecast
		RETURN
		 --GET DATA FROM CHECKIN TABLE 
		 --ROOM 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId 
		 AND H.RoomId=b.RoomId    AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 --AND B.BookingId  NOT IN(SELECT BookingId FROM #CheckInForecast)
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.RoomId=H.RoomId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		  AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.RoomId=B.RoomId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)     
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy   
		 
		
		 --BED
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		  AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)  
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		  AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		 
		  AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 
		 ---APARTMENT
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)  
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode  
		 
		
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId) 
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 AND h.PropertyId=@Pram2
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode    
		        
	
		   ---------------External start 
		 --EXTERNAL DATE CHECK IN DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2  AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer  
	       
	      
		 --EXTERNAL DATE CHECK OUT DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		 AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer 
	     
		 --EXTERNAL DATE CHECK OUT DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer 
	      
	      
		  --GET CHECKOUT DATE   
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
		 
		 
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		  
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))     
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		 
	    
		 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))     
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		  
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus  
		 
		 
		 ------CPP
		 --CPP DATE CHECK IN DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),G.CurrentStatus  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2  AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
	       
	      
		 --CPP DATE CHECK OUT DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),G.CurrentStatus  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		 AND B.Id NOT IN(SELECT BookingId FROM #BookingForecastCPP) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer ,G.CurrentStatus 
	     
		 --CPP DATE CHECK OUT DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0) ,G.CurrentStatus 
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND p.Id=@Pram2 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND B.Id NOT IN(SELECT BookingId FROM #BookingForecastCPP)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus  
		 
		 --CPP CHECKOUT DATA
		 INSERT INTO #CheckOutForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,NofDays)		  
		 SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)) 
		 FROM #BookingForecastCPP
		 WHERE CurrentStatus IN('CheckOut')
		 
		 --CPP CHECKIN DATA
		 INSERT INTO #CheckOutForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,NofDays)		  
		 SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)) 
		 FROM #BookingForecastCPP
		 WHERE BookingId NOT IN (SELECT BookingId FROM  #CheckOutForecastCPP)
		 AND CurrentStatus IN('CheckIn')		 
       
    END   
    ELSE  
    BEGIN    
		---------------Internal start  
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKINDATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckInDate',  
		 BP.PropertyType 
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))   
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) AND		 
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType  
	      
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKOUTDATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckOutDate',  
		 BP.PropertyType    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103))		 
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.RoomId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType 
	    
		 --GET DATA FROM BOOKING ROOM LEVEL CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,'CheckOutDate',  
		 BP.PropertyType  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103)) 		  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))  
		 JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.RoomId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,BP.PropertyType 
	     
	      
		 --GET DATA FROM BOOKING BED LEVEL CHECKIN COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckInDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))   
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103))		  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))       
		 --JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 ---AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType  
	       
	       
		  --GET DATA FROM BOOKING BED LEVEL CHECKOUT COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,-1,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,1,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 --AND YEAR(CONVERT(DATE,ChkOutDt,103))=YEAR(CONVERT(DATE,@Pram3,103))		
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 ---JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 --AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.BedId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType 
	     
		 --GET DATA FROM BOOKING BED CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE 
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType)   
		 SELECT G.BookingId,BedId,BedType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Single','Bed',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType   
		 FROM WRBHBBooking B     
		 JOIN WRBHBBedBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) <  DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBedBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 --JOIN WRBHBPropertyRooms R WITH(NOLOCK) ON R.Id=G.RoomId AND R.IsActive=1 AND R.IsDeleted=0  
		 --AND G.BookingPropertyId=R.PropertyId AND R.RoomStatus='Active'  
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.BedId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)   
		 GROUP BY G.BookingId,BedId,BedType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType  
	       
	      
		 --GET DATA FROM BOOKING APARTMENT LEVEL CHECKIN DATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckInDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))
		 AND DATEADD(d,1,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103))		  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId  
	       
	       
		 --GET DATA FROM BOOKING APARTMENT LEVEL CHECKOUT DATE COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 --AND YEAR(CONVERT(DATE,ChkInDt,103))=YEAR(CONVERT(DATE,@Pram3,103))		 
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0      
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.ApartmentId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId
	     
		  --GET DATA FROM BOOKING APARTMENT CHECKIN BEFORE MONTH AND CHECKOUT AFTER MONTH COMPARE  
		 INSERT INTO #BookingForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,DataGetType,PropertyType,ApartmentId)   
		 SELECT G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking','Double','Apartment',G.Tariff,Category,  
		 '','',0,0,0,P.Id,'CheckOutDate',BP.PropertyType,G.ApartmentId   
		 FROM WRBHBBooking B     
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))    
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBApartmentBookingProperty BP WITH(NOLOCK) ON  BP.BookingId=B.Id AND G.BookingPropertyTableId=BP.Id  
		 --AND UPPER(BP.PropertyType)NOT IN (UPPER('Ddp'),UPPER('MGH'))      
		 JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  G.BookingPropertyId=A.PropertyId AND G.ApartmentId=A.Id  
		 AND A.IsActive=1 AND B.IsDeleted=0      
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 AND G.ApartmentId NOT IN(SELECT RoomId FROM #BookingForecast TB WHERE TB.BookingId=G.BookingId)  
		 GROUP BY G.BookingId,G.ApartmentId,G.ApartmentType,FirstName,ChkInDt,ChkOutDt,G.Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,P.Id,BP.PropertyType,ApartmentId   
	       
	       
		--GET CHECKOUT DATE	
		--ROOM LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.RoomId=CO.RoomId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.RoomId=CO.RoomId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 		
		 CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays 
		 		  
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Room',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,B.Occupancy,CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.RoomId=CO.RoomId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,B.ChkOutDt,103)>CONVERT(DATE,@Pram3,103) 
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.RoomId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,
		 B.Occupancy,CO.NoOfDays  		   
		
		 --Bed LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BedId=CO.BedId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BedId=CO.BedId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Bed',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Single',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.BedId=CO.BedId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND 
		 CONVERT(DATE,B.ChkInDt,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,B.ChkOutDt,103)>CONVERT(DATE,@Pram3,103)
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.BedId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 --APARTMENT LEVEL
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.ApartmentId=CO.ApartmentId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.ApartmentId=CO.ApartmentId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))) 
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays
		 
		 
		 INSERT INTO #CheckOutForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,Tariff,PropertyId,TariffPaymentMode,Occupancy,NoOfDays)  
		 SELECT CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckOut','','Apartment',
		 B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,'Double',CO.NoOfDays  
		 FROM WRBHBChechkOutHdr CO 
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON CO.BookingId=B.BookingId AND
		 B.ApartmentId=CO.ApartmentId AND B.IsActive=1 AND B.IsDeleted=0
		 WHERE CO.IsActive=1 AND CO.IsDeleted=0 AND  
		 CONVERT(DATE,B.ChkInDt,103)<CONVERT(DATE,@Pram3,103) AND
		 CONVERT(DATE,B.ChkOutDt,103)>CONVERT(DATE,@Pram3,103)
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckOutForecast TB WHERE TB.BookingId=B.BookingId)
		 GROUP BY CO.BookingId,CO.ChkInHdrId,CO.ApartmentId,CO.Type,CO.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.Tariff,B.BookingPropertyId,B.TariffPaymentMode,CO.NoOfDays	
		 
		
		 --GET DATA FROM CHECKIN TABLE 
		 --ROOM 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId 
		 AND H.RoomId=b.RoomId    AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 --AND B.BookingId  NOT IN(SELECT BookingId FROM #CheckInForecast)
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.RoomId=H.RoomId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		  AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.RoomId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Room',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,B.Occupancy 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.RoomId=B.RoomId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		
		 AND B.RoomId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)     
		 GROUP BY B.BookingId,B.RoomId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt ,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode,B.Occupancy   
		 
		
		 --BED
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		  AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)  
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		  AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.BedId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Bed',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Single' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBBedBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND B.BookingPropertyId=H.PropertyId
		 AND B.BedId=H.BedId     AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		 
		  AND B.BedId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.BedId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 
		 ---APARTMENT
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)  
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode  
		 
		
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))          
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId) 
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode 
		 
		 
		 INSERT INTO #CheckInForecast(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
		 Type,BookingLevel,Category,PropertyId,ApartmentId,Tariff,TariffPaymentMode,Occupancy)   
		 SELECT B.BookingId,0,B.ApartmentId,H.Type,H.GuestName,CONVERT(NVARCHAR,B.ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,B.ChkOutDt,103) ChkOutDt,'CheckedIn','','Apartment',B.BookingPropertyId,H.ApartmentId,
		 B.Tariff ,B.TariffPaymentMode,'Double' 
		 FROM WrbHbCheckInHdr H
		 JOIN WRBHBApartmentBookingPropertyAssingedGuest B WITH(NOLOCK) ON B.BookingId=H.BookingId  AND 
		 B.BookingPropertyId=H.PropertyId   AND H.ApartmentId=B.ApartmentId  AND B.IsActive=1 AND B.IsDeleted=0
		 --JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0  
		 WHERE H.IsActive=1 AND H.IsDeleted=0 
		 AND CONVERT(DATE,B.ChkInDt,103) < DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103))  
		 AND CONVERT(DATE,B.ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))) 		
		 AND B.ApartmentId  NOT IN(SELECT RoomId FROM #CheckInForecast TI WHERE TI.BookingId=B.BookingId) 
		 AND H.Id  NOT IN(SELECT CheckInId FROM #CheckOutForecast TC WHERE TC.BookingId=B.BookingId)   
		 GROUP BY B.BookingId,B.ApartmentId,H.Type,H.GuestName,B.ChkInDt,  
		 B.ChkOutDt,B.BookingPropertyId,H.ApartmentId,B.Tariff ,B.TariffPaymentMode     
		        
			
		   ---------------External start 
		 --EXTERNAL DATE CHECK IN DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer  
	       
	      
		 --EXTERNAL DATE CHECK OUT DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		 AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer 
	     
		 --EXTERNAL DATE CHECK OUT DATE WISE  
		 INSERT INTO #ExternalForecast(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0)  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer 
	      
	      
		  --GET CHECKOUT DATE   
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)  
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))    
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut')  		  
		-- AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
		 
		 
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103)) 
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		  
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))     
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckOut') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		 
	    
		 --GET DATA FROM CHECKIN TABLE 
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))     
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn')  		  
		 --AND B.Id NOT IN(SELECT BookingId FROM #ExternalForecast) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))     
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus 
		  
		  
		 INSERT INTO #CheckInForecastExternal(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,NofDays)   
		 SELECT G.BookingId,RoomId,G.RoomType,FirstName,CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,G.CurrentStatus,G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),
		 DATEDIFF(day, CONVERT(DATE,ChkInDt,103), CONVERT(DATE,ChkOutDt,103))  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType!='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND G.CurrentStatus IN ('CheckIn') 
		 AND B.Id NOT IN(SELECT BookingId FROM #CheckInForecastExternal)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,FirstName,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,
		 G.CurrentStatus  
		 
		 
		 ------CPP
		 --CPP DATE CHECK IN DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,'',CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),G.CurrentStatus  
		 FROM WRBHBBooking B  
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId     
		 AND CONVERT(DATE,ChkInDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'  
		 GROUP BY G.BookingId,RoomId,G.RoomType,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus   
	       
	      
		 --CPP DATE CHECK OUT DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,'',CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0),G.CurrentStatus  
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkOutDt,103) BETWEEN DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND DATEADD(d,0,DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103))))  
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property'  
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled' 
		 AND B.Id NOT IN(SELECT BookingId FROM #BookingForecastCPP) 
		 GROUP BY G.BookingId,RoomId,G.RoomType,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus  
	     
		 --CPP DATE CHECK OUT DATE WISE  
		 INSERT INTO #BookingForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus)   
		 SELECT G.BookingId,RoomId,G.RoomType,'',CONVERT(NVARCHAR,ChkInDt,103) ChkInDt,  
		 CONVERT(NVARCHAR,ChkOutDt,103) ChkOutDt,'Booking',G.Occupancy,'Room',Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,  
		 ISNULL(PA.TAC,0),ISNULL(PA.TACPer,0) ,G.CurrentStatus 
		 FROM WRBHBBooking B     
		 JOIN WRBHBBookingPropertyAssingedGuest G WITH(NOLOCK) ON B.Id =G.BookingId  
		 AND CONVERT(DATE,ChkInDt,103) < DATEADD(d,0,DATEADD(dd,-(DAY(CONVERT(DATE,@Pram3,103))-1),CONVERT(DATE,@Pram3,103)))  
		 AND CONVERT(DATE,ChkOutDt,103) > DATEADD(dd,-(DAY(DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))),DATEADD(mm,1,CONVERT(DATE,@Pram3,103)))   
		 AND G.IsActive=1 AND G.IsDeleted=0  
		 JOIN dbo.WRBHBBookingProperty BP WITH(NOLOCK)ON B.Id=BP.BookingId AND BP.IsActive=1 AND BP.IsDeleted=0  
		 AND BP.Id=G.BookingPropertyTableId AND PropertyType='CPP'       
		 JOIN WRBHBProperty P WITH(NOLOCK) ON G.BookingPropertyId= P.Id AND P.IsActive=1 AND P.IsDeleted=0 AND p.Category='External Property'  
		 AND P.Category='External Property' 
		 LEFT OUTER JOIN WRBHBPropertyAgreements PA WITH(NOLOCK) ON PA.IsActive=1 AND PA.PropertyId= P.Id AND PA.IsDeleted=0  
		 WHERE B.IsActive=1 AND B.IsDeleted=0 AND ISNULL(B.CancelStatus,'')!='Canceled'
		 AND B.Id NOT IN(SELECT BookingId FROM #BookingForecastCPP)  
		 GROUP BY G.BookingId,RoomId,G.RoomType,ChkInDt,ChkOutDt,G.Occupancy,Tariff,Category,  
		 ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,P.Id,PA.TAC,PA.TACPer,G.CurrentStatus  
		 
		 --CHECKOUT DATA FOR CPP
		 INSERT INTO #CheckOutForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,NofDays)		  
		 SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)) 		 
		 FROM #BookingForecastCPP
		 WHERE CurrentStatus IN('CheckOut') 
		 
		 --CHECKIN  DATA FOR CPP
		 INSERT INTO #CheckOutForecastCPP(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,NofDays)		  
		 SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
		 BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
		 PropertyId,TAC,TACPer,CurrentStatus,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)) 		 
		 FROM #BookingForecastCPP
		 WHERE BookingId NOT IN (SELECT BookingId FROM  #CheckOutForecastCPP)
		 AND CurrentStatus IN('CheckIn')    
      
    END  
    
	
   
    ----------Internal  
     --MANAGED AND DEDICATED  
    INSERT INTO  #ManagedDedicated(PropertyId,ApartmentId,RoomId,PropertyType)  
    SELECT PropertyId,ApartmentId,RoomId,PropertyType   
    FROM #BookingForecast  
    WHERE PropertyType IN(UPPER('Ddp'))  
    GROUP BY PropertyId,ApartmentId,RoomId,PropertyType  
      
    INSERT INTO  #ManagedDedicated(PropertyId,ApartmentId,RoomId,PropertyType)  
    SELECT PropertyId,0,0,PropertyType   
    FROM #BookingForecast  
    WHERE PropertyType IN(UPPER('MGH'))  
    GROUP BY PropertyId,PropertyType 
    
    --BOOKING START
    --FIND COUNT BOOKING FOR DOUBLE   
    INSERT INTO #OccupancyForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,
    BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode)  
    SELECT B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,B.Type,
    Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode   
    FROM #BookingForecast B  
    WHERE Occupancy='Single' AND Category='Internal Property'   
    GROUP BY B.BookingId,B.RoomId,B.RoomName,B.GuestName,B.CheckInDt,B.CheckOutDt,
    B.Type,Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode 
     
      
    INSERT INTO #OccupancyForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode)  
    SELECT B.BookingId,B.RoomId,B.RoomName,'',B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,Tariff ,PropertyId,Category ,TariffPaymentMode 
    FROM #BookingForecast B    
    WHERE Occupancy='Double' AND Category='Internal Property' 
    GROUP BY B.BookingId,B.RoomId,B.RoomName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,
    BookingLevel,Tariff ,PropertyId,Category,TariffPaymentMode 
    
    INSERT INTO #OccupancyForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode)  
    SELECT B.BookingId,B.RoomId,B.RoomName,'',B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,BookingLevel,Tariff ,PropertyId,Category,TariffPaymentMode  
    FROM #BookingForecast B    
    WHERE Occupancy='Triple' AND Category='Internal Property' 
    GROUP BY B.BookingId,B.RoomId,B.RoomName,B.CheckInDt,B.CheckOutDt,B.Type,Occupancy,
    BookingLevel,Tariff ,PropertyId,Category ,TariffPaymentMode 
      
    
    --FINAL BOOKING ENTRY  
    INSERT INTO #OccupancyFinalForecast(BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,  
    Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode)  
    SELECT BookingId,RoomId,RoomName,GuestName,CONVERT(DATE,CheckInDt,103),CONVERT(DATE,CheckOutDt,103),Type,  
    Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode   
    FROM #OccupancyForecast 
    GROUP BY BookingId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,  
    Occupancy,BookingLevel,Tariff,PropertyId,Category,TariffPaymentMode   
     
     
    --CHECKIN START 
      
    --CHECKED IN DATA   
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,C.GuestName,
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.ApartmentId,
    C.TariffPaymentMode  ,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt ,103))
 -- DATEDIFF(day,CAST(CheckInDt AS DATE),CAST(CheckOutDt AS DATE))
    FROM  #CheckInForecast C  
    WHERE Occupancy='Single'   
    GROUP BY C.BookingId,C.RoomId,C.RoomName,C.GuestName,
    C.CheckInDt,C.CheckOutDt,C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,
    C.ApartmentId,C.TariffPaymentMode  
    
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,'',
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.ApartmentId,
    C.TariffPaymentMode,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt ,103))
--DATEDIFF(day,CAST(C.CheckInDt AS DATE),CAST(C.CheckOutDt AS DATE))  
    FROM  #CheckInForecast C  
    where Occupancy='Double'   
    GROUP BY C.BookingId,C.RoomId,C.RoomName,
    C.CheckInDt,C.CheckOutDt,C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,
    C.ApartmentId,C.TariffPaymentMode  
    
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,'',
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.ApartmentId,
    C.TariffPaymentMode  ,DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt ,103)) 
    FROM  #CheckInForecast C  
    WHERE  Occupancy='Triple'   
    GROUP BY C.BookingId,C.RoomId,C.RoomName,
    C.CheckInDt,C.CheckOutDt,C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,
    C.ApartmentId,C.TariffPaymentMode     
    
   
    --CHECKED OUT DATA   
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,C.GuestName,
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,0,
    C.TariffPaymentMode  ,NoOfDays
    FROM  #CheckOutForecast C      
    WHERE  Occupancy='Single'    
    GROUP BY C.BookingId,C.RoomId,C.RoomName,C.GuestName,C.CheckInDt,C.CheckOutDt,
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.TariffPaymentMode,NoOfDays
    
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,'',
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,0,
    C.TariffPaymentMode  ,NoOfDays
    FROM  #CheckOutForecast C      
    WHERE Occupancy='Double'  
    GROUP BY C.BookingId,C.RoomId,C.RoomName,C.CheckInDt,C.CheckOutDt,
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.TariffPaymentMode,NoOfDays
    
    INSERT INTO #CheckInForecastFinal(BookingId,CheckInId,RoomId,RoomName,GuestName,CheckInDt,CheckOutDt,  
    Type,Occupancy,BookingLevel,Tariff,PropertyId,ApartmentId,TariffPaymentMode,NoOfDays)   
    SELECT C.BookingId,0,C.RoomId,C.RoomName,'',
    CONVERT(DATE,C.CheckInDt,103),CONVERT(DATE,C.CheckOutDt,103),  
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,0,
    C.TariffPaymentMode  ,NoOfDays
    FROM  #CheckOutForecast C      
    WHERE   Occupancy='Triple'
    GROUP BY C.BookingId,C.RoomId,C.RoomName,C.CheckInDt,C.CheckOutDt,
    C.Type,C.Occupancy,C.BookingLevel,C.Tariff,C.PropertyId,C.TariffPaymentMode  ,NoOfDays  
    
   UPDATE #CheckInForecastFinal SET NoOfDays=1 WHERE NoOfDays=0;
   
   -- SELECT *  FROM #CheckInForecastFinal WHERE TYPE!='CheckOut'
   -- ORDER BY BookingId ASC
   --RETURN
    
    --DECLARE @Tariff DECIMAL(27,2),@ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100),@Count INT;  
    --DECLARE @DateDiff int,@i BIGINT,@HR NVARCHAR(100),@RoomId BIGINT,@BookingId BIGINT,@NoOfDays INT,  
    --@RoomType NVARCHAR(100),@BookingLevel NVARCHAR(100),@CheckInId BIGINT,@PropertyId BIGINT,  
    --@TACPer DECIMAL(27,2),@SingleTariff DECIMAL(27,2),@SingleandMarkup DECIMAL(27,2),@Markup DECIMAL(27,2),  
    --@TariffPaymentMode NVARCHAR(100),@ApartmentId BIGINT,@CHeckOutTime NVARCHAR(100);  
  -- select * from #CheckInForecastFinal where TariffPaymentMode='Direct'
    SELECT  @CHeckOutTime=' 11:59:00 AM',@CHeckInTime=' 12:00:00 PM'
    
    
    --CHECK IN REVENUE   
    SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
    @NoOfDays=NoOfDays--DATEDIFF(day,CAST(CheckInDt+@CHeckInTime AS DATETIME),CAST(CheckOutDt+@CHeckOutTime AS DATETIME))
    ,--DATEDIFF(day,CAST(CheckInDt AS DATE),CAST(CheckOutDt AS DATE)),  
    @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
    @PropertyId=PropertyId,@ApartmentId=ApartmentId,@IDE=IDE,@TariffPaymentMode=TariffPaymentMode  
    FROM #CheckInForecastFinal
    --sELECT @NoOfDays   
    ---DATEDIFF(day,CAST(CheckInDt+@CHeckInTime AS DATETIME),CAST(CheckOutDt+@CHeckOutTime AS DATETIME))
    WHILE (@NoOfDays>0)  
    BEGIN
		        
		INSERT INTO #RevanueCheckInForecast(Tariff,RackTariff,NoOfDays,BookingLevel,ChkInDate,ChkOutDate,  
		BookingId,PropertyId,ApartmentId,RoomId,TariffPaymentMode)  
		SELECT @Tariff,@Tariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CAST(@ChkInDate AS DATE)),103),@BookingLevel,  
		@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@ApartmentId,@RoomId,@TariffPaymentMode  
		SET @NoOfDays=@NoOfDays-1   
		SET @i=@i+1  
		IF @NoOfDays=0  
		BEGIN   
		 DELETE FROM #CheckInForecastFinal WHERE IDE=@IDE 
	        
		 SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
		 @NoOfDays=NoOfDays,--DATEDIFF(day,CAST(CheckInDt+@CHeckInTime AS DATETIME),CAST(CheckOutDt+@CHeckOutTime AS DATETIME)),
		 --DATEDIFF(day,CAST(CheckInDt AS DATE),CAST(CheckOutDt AS DATE)),  
		 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
		 @PropertyId=PropertyId,@ApartmentId=ApartmentId,@IDE=IDE,@TariffPaymentMode=TariffPaymentMode  
		 FROM #CheckInForecastFinal     
    END    
    END 
    
   SELECT * FROM #RevanueCheckInForecast
   where   MONTH(CONVERT(DATE,NoOfDays,103)) =9 
   order by BookingId   
     
   Return
     --BOOKING REVANUE  
     SELECT @Count=COUNT(*) FROM #OccupancyFinalForecast  
     SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,  
     @NoOfDays=DATEDIFF(day,CAST(CheckInDt AS DATE),CAST(CheckOutDt AS DATE)),  
     @RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
     @PropertyId=PropertyId,@i=0,@TariffPaymentMode=TariffPaymentMode ,@IDE=IDE 
     FROM #OccupancyFinalForecast  
     WHILE (@NoOfDays>0)  
     BEGIN         
		 INSERT INTO #RevanueBookingForecast(Tariff,RackTariff,NoOfDays,RoomType,BookingLevel,  
		 ChkInDate,ChkOutDate,BookingId,PropertyId,TariffPaymentMode)  
		 SELECT @Tariff,@Tariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CAST(@ChkInDate AS DATE)),103),@RoomType,
		 @BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@TariffPaymentMode  
	       
		 SET @i=@i+1  
		 SET @NoOfDays=@NoOfDays-1  
		 IF @NoOfDays=0  
		 BEGIN 	  
				DELETE FROM #OccupancyFinalForecast WHERE IDE=@IDE  

				SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,  
				@NoOfDays=DATEDIFF(day,CAST(CheckInDt AS DATE),CAST(CheckOutDt AS DATE)),  
				@RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
				@PropertyId=PropertyId,@i=0,@TariffPaymentMode=TariffPaymentMode,@IDE=IDE  
				FROM #OccupancyFinalForecast 
     END          
     END
    
    UPDATE #ManagedDedicated SET PropertyType='Managed Contracts' WHERE PropertyType='MGH' 
     
    --Outstanding AMOUNT FOR MANAGED GUEST PROPERTY WISE  
    INSERT INTO #OutStandingInternal(Tariff ,PropertyId,EntryType )  
    SELECT N.Tariff,N.PropertyId,'Managed Contracts' FROM #NDDCountForecast N  
    --JOIN #ManagedDedicated M ON  M.PropertyId=N.PropertyId AND M.PropertyType=LTRIM(N.PropertyType)  
    WHERE LTRIM(N.PropertyType)=LTRIM(' Managed Contracts ')  
      
     --Outstanding AMOUNT FOR DEDICATED PROPERTY WISE, APARTMENT WISE  
    INSERT INTO #OutStandingInternal(Tariff,PropertyId,EntryType )  
    SELECT N.Tariff,N.PropertyId,'Dedicated' FROM #NDDCountForecast N  
   -- JOIN #ManagedDedicated M ON  M.PropertyId=N.PropertyId AND M.ApartmentId=N.ApartmentId AND N.RoomId=M.RoomId  
    WHERE LTRIM(N.PropertyType)!=LTRIM(' Managed Contracts ')  
      
    
    
    --BOOKING
    ---BTC AMOUNT
    INSERT INTO #BookingOutStandingFinalInternal(Tariff ,PropertyId,GTV)
    SELECT SUM(ISNULL(RackTariff,0)),PropertyId,SUM(ISNULL(RackTariff,0)) 
    FROM #RevanueBookingForecast  
    WHERE MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103))=YEAR(CONVERT(DATE,@Pram3,103))
    AND TariffPaymentMode='Bill to Company (BTC)'     
    GROUP BY PropertyId 
    
   
    --DEDICATED AND NON DEDICATED REVENUS  
    INSERT INTO #RevanueDDInternal(Tariff ,PropertyId,GTV)  
    SELECT SUM(ISNULL(Tariff,0)) ,PropertyId,SUM(ISNULL(Tariff,0)) 
    FROM #OutStandingInternal  
    WHERE EntryType !='Outstanding'  
    GROUP BY PropertyId  
    
        
    --BOOKING REVENUE AMOUNT FOR PROPERTY WISE  
    INSERT INTO #RevanueNDDFinal(Tariff ,PropertyId)  
    SELECT SUM(ISNULL(RackTariff,0)),PropertyId 
    FROM #RevanueBookingForecast  
    WHERE MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103))=YEAR(CONVERT(DATE,@Pram3,103))
    AND TariffPaymentMode='Direct'      
    GROUP BY PropertyId 
    
    --BOOKING REVENUE AMOUNT FOR PROPERTY WISE,LONG STAY FOR THIS CHECKIN GIVEN DAYS BUT NOT IN BOOKING,  
    INSERT INTO #RevanueNDDFinal(Tariff ,PropertyId)  
    SELECT SUM(ISNULL(RackTariff,0)),RC.PropertyId
    FROM #RevanueCheckInForecast RC      
    WHERE MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103))=YEAR(CONVERT(DATE,@Pram3,103))  
    AND BookingId NOT IN(SELECT BookingId FROM #RevanueBookingForecast)     
    GROUP BY RC.PropertyId    
   
   ---CHECKIN
    --FILTER MANAGED PROPERTY APARTMENT  
    DELETE FROM #RevanueCheckInForecast   
    WHERE PropertyId IN (SELECT PropertyId FROM #NDDCountForecast)  
      
    --FILTER DEDICATED PROPERTY APARTMENT  
    DELETE FROM #RevanueCheckInForecast   
    WHERE ApartmentId IN (SELECT N.ApartmentId FROM #RevanueCheckInForecast RC  
    JOIN #NDDCountForecast N ON N.ApartmentId=RC.ApartmentId AND RC.RoomId=N.RoomId AND N.PropertyId=RC.PropertyId  
    WHERE RC.RoomId=0)  
      
    --FILTER DEDICATED PROPERTY ROOM  
    DELETE FROM #RevanueCheckInForecast   
    WHERE RoomId IN (SELECT N.RoomId FROM #RevanueCheckInForecast RC  
    JOIN #NDDCountForecast N ON N.ApartmentId=RC.ApartmentId AND RC.RoomId=N.RoomId AND N.PropertyId=RC.PropertyId  
    WHERE RC.ApartmentId=0)  
     
    --BTC Outstanding AMOUNT FOR PROPERTY WISE  
    INSERT INTO #OutStandingFinalInternal(Tariff ,PropertyId,GTV)  
    SELECT SUM(ISNULL(RackTariff,0)),RC.PropertyId,SUM(ISNULL(RackTariff,0))
    FROM #RevanueCheckInForecast RC      
    WHERE MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103))=YEAR(CONVERT(DATE,@Pram3,103))
    AND TariffPaymentMode='Bill to Company (BTC)'        
    GROUP BY RC.PropertyId
     
    --CHECKIN REVENUE AMOUNT FOR PROPERTY WISE,FILTER DEDICATED PROPERTY APARTMENT  
    INSERT INTO #CheckInRevanueNDDInternal(Tariff ,PropertyId,GTV)  
    SELECT SUM(ISNULL(RackTariff,0)),RC.PropertyId,SUM(ISNULL(RackTariff,0))
    FROM #RevanueCheckInForecast RC       
    WHERE MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103))=YEAR(CONVERT(DATE,@Pram3,103))
    AND TariffPaymentMode='Direct'            
    GROUP BY RC.PropertyId
      
     
    INSERT INTO #RevanueNDDInternal(Tariff ,PropertyId,GTV)  
    SELECT SUM(ISNULL(Tariff,0)) ,PropertyId,SUM(ISNULL(Tariff,0)) 
    FROM #RevanueNDDFinal     
    GROUP BY PropertyId  
      
    ---------External  
    ---CHECK OUT OUTSTANDING AMOUNT      
     --INSERT INTO #OutStandingBookingForecast(Tariff,RackTariff,NoOfDays,BookingLevel,ChkInDate,ChkOutDate,BookingId,PropertyId)     
     --SELECT C.Tariff,C.Tariff,B.CheckOutDt,B.BookingLevel,C.CheckInDt,B.CheckOutDt,C.BookingId,C.PropertyId  
     --FROM  #CheckOutForecastExternal C  
     --JOIN #ExternalForecast B ON C.BookingId=B.BookingId AND B.Category='External Property'  
    
    UPDATE #CheckInForecastExternal SET  NofDays=NoOfDays FROM #CheckInForecastExternal S
    JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK)  ON S.BookingId=A.BookingId AND 
    S.Type='CheckOut'
    
    --CHECK IN REVEVENU SPLIT SINGLE AND DOUBLE
	INSERT INTO #CheckInForecastExternalNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #CheckInForecastExternal
	WHERE Occupancy='Single'
	
	INSERT INTO #CheckInForecastExternalNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays)
	SELECT BookingId,PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays FROM #CheckInForecastExternal
	WHERE Occupancy!='Single'
	GROUP BY BookingId,PropertyAssGustId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer,NofDays
	
	--bOOKING REVEVENU SPLIT SINGLE AND DOUBLE
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer)
	SELECT BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer FROM #ExternalForecast
	WHERE Occupancy='Single'
	
	INSERT INTO #ExternalForecastNew(BookingId,PropertyAssGustId,RoomName,GuestName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer)
	SELECT BookingId,PropertyAssGustId,RoomName,'',CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer FROM #ExternalForecast
	WHERE Occupancy!='Single'
	GROUP BY BookingId,PropertyAssGustId,RoomName,CheckInDt,CheckOutDt,Type,Occupancy,  
	BookingLevel,Tariff,Category,ServicePaymentMode,TariffPaymentMode,SingleTariff,SingleandMarkup,Markup,  
	PropertyId,TAC,TACPer
		 
	
		 
    
    --NofDays   
    DECLARE @PID INT;    
    --BOOKING REVENUE FOR TAC  
    SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
    @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
    @RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
    @PropertyId=PropertyId,@TACPer=TACPer,@TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
    FROM #ExternalForecastNew WHERE TAC=1  
    WHILE (@NoOfDays>0)  
    BEGIN       
		INSERT INTO #RevanueExternalTAC(Tariff,RackTariff,TACPer,TACRevenue,NoOfDays,RoomType,BookingLevel,  
		ChkInDate,ChkOutDate,BookingId,PropertyId,TariffPaymentMode)  
		SELECT @Tariff,@Tariff,@TACPer,(@Tariff*@TACPer)/100,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
		@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@TariffPaymentMode  
	      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN 	
		    DELETE FROM #ExternalForecastNew WHERE  PID=@PID  
	        
		    SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
			@RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
			@PropertyId=PropertyId,@TACPer=TACPer,@TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID    
			FROM #ExternalForecastNew WHERE TAC=1  
		END   
         
    END  
       
     --BOOKING REVENUE FOR MARKUP  
    SELECT @Count=COUNT(*) FROM #ExternalForecastNew WHERE TAC=0  
      
    SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
    @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
    @RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
    @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
    @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
    FROM #ExternalForecastNew WHERE TAC=0  
      
    WHILE (@NoOfDays>0)  
    BEGIN            
		INSERT INTO #RevanueExternalMarkUp(Tariff,RackTariff,MarkupRevenue,NoOfDays,RoomType,BookingLevel,  
		ChkInDate,ChkOutDate,BookingId,PropertyId,SingleTariff,SingleandMarkup,Markup,TariffPaymentMode)  
		SELECT @Tariff,@Tariff,(@SingleandMarkup-@SingleTariff)+@Markup,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
		@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@SingleTariff,@SingleandMarkup,@Markup,  
		@TariffPaymentMode      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN  
		  DELETE FROM #ExternalForecastNew WHERE PID=@PID 
	       
		  SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
		  @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
		  @RoomType=RoomType,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
		  @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
		  @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
		  FROM #ExternalForecastNew WHERE TAC=0  
		END     
    END  
     
   
    ---CHECK IN REVANUE AMOUNT FOR MARKUP     
    SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
    @NoOfDays=NofDays,  
    @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
    @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
    @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
    FROM #CheckInForecastExternalNew WHERE TAC=0  
      
    WHILE (@NoOfDays>0)  
    BEGIN                
		INSERT INTO #CheckInRevanueExternalMarkUp(Tariff,RackTariff,MarkupRevenue,NoOfDays,RoomType,BookingLevel,  
		ChkInDate,ChkOutDate,BookingId,PropertyId,SingleTariff,SingleandMarkup,Markup,TariffPaymentMode)  
		SELECT @Tariff,@Tariff,(@SingleandMarkup-@SingleTariff)+@Markup,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
		@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@SingleTariff,@SingleandMarkup,@Markup,  
		@TariffPaymentMode   
	      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1  
	       
		IF @NoOfDays=0  
		BEGIN   
		 DELETE FROM #CheckInForecastExternalNew WHERE PID=@PID   
		 AND TAC=0  
	        
		 SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
		 @NoOfDays=NofDays,  
		 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
		 @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
		 @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
		 FROM #CheckInForecastExternalNew WHERE TAC=0     
	END    
    END  
    
    ---CHECK IN REVANUE AMOUNT FOR TAC   
   SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
   @NoOfDays=NofDays,  
   @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
   @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
   @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
   FROM #CheckInForecastExternalNew WHERE TAC=1  
      
    WHILE (@NoOfDays>0)  
    BEGIN                
		INSERT INTO #CheckInRevanueExternalTAC(Tariff,RackTariff,TACPer,TACRevenue,NoOfDays,RoomType,BookingLevel,  
		ChkInDate,ChkOutDate,BookingId,PropertyId,TariffPaymentMode)  
		SELECT @Tariff,@Tariff,@TACPer,(@Tariff*@TACPer)/100,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
		@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@TariffPaymentMode   
	      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1   
	      
		IF @NoOfDays=0  
		BEGIN   
		 DELETE FROM #CheckInForecastExternalNew WHERE PID=@PID   
		 AND TAC=1  
	        
		 SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
		 @NoOfDays=NofDays,  
		 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
		 @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
		 @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
		 FROM #CheckInForecastExternalNew WHERE TAC=1     
		END    
    END 
     
    --BOOKING REVENUE AMOUNT FOR PROPERTY WISE TAC  
    INSERT INTO #RevanueDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(0),PropertyId,SUM(Tariff),SUM(RackTariff) 
    FROM #RevanueExternalTAC  
    WHERE LTRIM(TariffPaymentMode)IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')      
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
     
    
    INSERT INTO #RevanueDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(TACRevenue),PropertyId,SUM(Tariff),SUM(0) 
    FROM #RevanueExternalTAC  
    WHERE TariffPaymentMode='Direct'  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
     --BOOKING REVENUE AMOUNT FOR PROPERTY WISE MARKUP .
      
    INSERT INTO #RevanueDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(0),PropertyId,SUM(Tariff),SUM(RackTariff)  
    FROM #RevanueExternalMarkUp  
    WHERE TariffPaymentMode IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
    INSERT INTO #RevanueDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(MarkupRevenue),PropertyId,SUM(Tariff),SUM(0) 
    FROM #RevanueExternalMarkUp      
    WHERE TariffPaymentMode='Direct'  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
    
    
    
   
     
     
    --CHECK IN START  
    --CHECKIN REVENUE AMOUNT FOR PROPERTY WISE TAC  
    INSERT INTO #RevanueNDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(0),PropertyId,SUM(Tariff),SUM(RackTariff) 
    FROM #CheckInRevanueExternalTAC  
    WHERE LTRIM(TariffPaymentMode)IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
    INSERT INTO #RevanueNDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(TACRevenue),PropertyId,SUM(Tariff),SUM(0) 
    FROM #CheckInRevanueExternalTAC  
    WHERE TariffPaymentMode='Direct'  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
     --CHECKIN REVENUE AMOUNT FOR PROPERTY WISE MARKUP  
    INSERT INTO #RevanueNDD(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(0),PropertyId ,SUM(Tariff),SUM(RackTariff)
    FROM #CheckInRevanueExternalMarkUp  
    WHERE TariffPaymentMode IN (LTRIM('Bill to Company (BTC)'),'Bill to Company(BTC)')  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
      
    INSERT INTO #RevanueNDD(Tariff ,PropertyId,GTV,ActualTariff )  
    SELECT SUM(MarkupRevenue),PropertyId ,SUM(Tariff),SUM(0)
    FROM #CheckInRevanueExternalMarkUp  
    WHERE TariffPaymentMode='Direct'  
    AND MONTH(CONVERT(DATE,NoOfDays,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,NoOfDays,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
     
    
   
    
    ---CPP Start
    UPDATE #CheckOutForecastCPP SET  NofDays=NoOfDays FROM #CheckOutForecastCPP S
    JOIN dbo.WRBHBChechkOutHdr A WITH(NOLOCK)  ON S.BookingId=A.BookingId AND 
    S.Type='CheckOut'
    
    
    SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
    @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
    @RoomType=Type,@BookingLevel=Occupancy,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
    @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
    @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
    FROM #BookingForecastCPP WHERE TAC=0  
      
    WHILE (@NoOfDays>0)  
    BEGIN            
		INSERT INTO #BookingForecastCPPLoopData(Tariff,Markup,CurrentDate,Type,Occupancy,  
		CheckInDt,CheckOutDt,BookingId,PropertyId,SingleTariff,SingleandMarkup,TariffPaymentMode)  
		SELECT @Tariff,(@SingleandMarkup-@SingleTariff)+@Markup,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),@RoomType,  
		@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@SingleTariff,@SingleandMarkup,  
		@TariffPaymentMode      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1  
		IF @NoOfDays=0  
		BEGIN  
		  DELETE FROM #BookingForecastCPP WHERE PID=@PID 
	       
		  SELECT TOP 1 @Tariff=Tariff,@PropertyAssGustId=PropertyAssGustId,@BookingId=BookingId,  
		  @NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDt,103), CONVERT(DATE,CheckOutDt,103)),  
		  @RoomType=Type,@BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,  
		  @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
		  @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
		  FROM #BookingForecastCPP WHERE TAC=0  
		END     
    END  
   
   ---CHECK IN and Checkout REVANUE AMOUNT  
   SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
   @NoOfDays=NofDays,  
   @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
   @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
   @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
   FROM #CheckOutForecastCPP   
   
  
      
    WHILE (@NoOfDays>0)  
    BEGIN                
		INSERT INTO #CheckOutForecastCPPLoopData(Tariff,TACPer,TAC,CurrentDate,Type,BookingLevel,  
		CheckInDt,CheckOutDt,BookingId,PropertyId,TariffPaymentMode)  
		SELECT @Tariff,@TACPer,(@Tariff*@TACPer)/100,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),
		@RoomType,@BookingLevel,@ChkInDate,@ChkOutDate,@BookingId,@PropertyId,@TariffPaymentMode   
	      
		SET @i=@i+1  
		SET @NoOfDays=@NoOfDays-1   
	      
		IF @NoOfDays=0  
		BEGIN   
		 DELETE FROM #CheckOutForecastCPP WHERE PID=@PID   
		   
	        
		 SELECT TOP 1 @Tariff=Tariff,@RoomId=RoomId,@BookingId=BookingId,@CheckInId=CheckInId,  
		 @NoOfDays=NofDays,  
		 @BookingLevel=BookingLevel,@ChkInDate=CheckInDt,@ChkOutDate=CheckOutDt,@i=0,  
		 @PropertyId=PropertyId,@SingleTariff=SingleTariff,@SingleandMarkup=SingleandMarkup,@Markup=Markup,  
		 @TariffPaymentMode=TariffPaymentMode,@i=0,@PID=PID   
		 FROM #CheckOutForecastCPP     
		END    
    END 
    
    --BOOKING CPP GTV DATA
    INSERT INTO #RevanueDD(Tariff ,PropertyId,GTV,ActualTariff)
    SELECT 0,PropertyId,SUM(Tariff),0
    FROM #BookingForecastCPPLoopData  
    WHERE   
    MONTH(CONVERT(DATE,CurrentDate,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,CurrentDate,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId 
    
    --CHECKIN AND CHECKOUT CPP DATA
    INSERT INTO #RevanueNDD(Tariff ,PropertyId,GTV,ActualTariff )
    SELECT 0,PropertyId,SUM(Tariff),0
    FROM #CheckOutForecastCPPLoopData  
    WHERE   
    MONTH(CONVERT(DATE,CurrentDate,103)) = MONTH(CONVERT(DATE,@Pram3,103))  
    AND YEAR(CONVERT(DATE,CurrentDate,103)) =YEAR(CONVERT(DATE,@Pram3,103))   
    GROUP BY PropertyId  
     
    
     
     --Sum all Externrl booking and CPP
    INSERT INTO #RevanueDDExternal(Tariff ,PropertyId,GTV,ActualTariff)  
    SELECT SUM(Tariff),PropertyId,SUM(GTV),SUM(ActualTariff) FROM #RevanueDD 
    GROUP BY PropertyId 
    
    ---SUM ALL CHECKIN DATA EXTERNAL and CPP
    INSERT INTO #RevanueNDDExternal(Tariff ,PropertyId,GTV,ActualTariff)
    SELECT SUM(Tariff),PropertyId,SUM(GTV),SUM(ActualTariff) FROM #RevanueNDD 
    GROUP BY PropertyId 
    
    
    IF @Pram2=0  
    BEGIN  
      IF @Pram1=0  
         BEGIN   
     ----Internal  
      --BOOKING FORECAST 
                 
       INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,
       Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
       (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,
       (ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)),0 
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId  
       LEFT OUTER JOIN #RevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
       LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #BookingOutStandingFinalInternal O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category IN ('Internal Property','Managed G H')  
       AND P.IsActive=1 and P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
         
       --CHECKIN FORECAST   
       INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,
       Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
       (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,
       Category,(ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)),0  
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0  
       LEFT OUTER JOIN #CheckInRevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
       LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStandingFinalInternal O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category IN ('Internal Property','Managed G H')  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
        
       -----External  
       --BOOKINGG FORECAST  
       INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,
       Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
       (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV,0), 
       ISNULL(DR.ActualTariff,0)       
       FROM WRBHBProperty P   
       JOIN WRBHBCity C ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0     
       LEFT OUTER JOIN #RevanueDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category='External Property'  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
         
       --CHECKIN FORECAST  
       INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,
       Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
       (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV,0),
       ISNULL(DR.ActualTariff,0) 
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0     
       LEFT OUTER JOIN #RevanueNDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category='External Property'  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
     END  
     ELSE  
     BEGIN  
     ------------Internal  
     --BOOKING FORECAST
       
       INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,
       ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
       (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,
       Category,(ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)),0        
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.Id=@Pram1 AND  C.IsActive=1 AND C.IsDeleted=0  
       LEFT OUTER JOIN #RevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
       LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #BookingOutStandingFinalInternal O ON  P.Id=O.PropertyId  
       WHERE Category IN ('Internal Property','Managed G H')  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
         
       --CHECKIN FORECAST          
       INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
       (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,
       Category,(ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)),0  
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.Id=@Pram1 AND C.IsActive=1 and C.IsDeleted=0  
       LEFT OUTER JOIN #CheckInRevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
       LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStandingFinalInternal O ON  P.Id=O.PropertyId  
       WHERE Category IN ('Internal Property','Managed G H')  
       AND P.IsActive=1 and P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
         
       -----------External  
       --BOOKINGG FORECAST  
       INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
       (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV,0),ISNULL(DR.ActualTariff,0)  
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0     
       LEFT OUTER JOIN #RevanueDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category='External Property'  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC  
         
       --CHECKIN FORECAST  
       INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
       SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
       (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV,0),ISNULL(DR.ActualTariff ,0) 
       FROM WRBHBProperty P   
       JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.Id=@Pram1 AND C.IsActive=1 AND C.IsDeleted=0    
       LEFT OUTER JOIN #RevanueNDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
       LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
       WHERE Category='External Property'  
       AND P.IsActive=1 AND P.IsDeleted=0  
       ORDER BY LTRIM(p.PropertyName),LTRIM(C.CityName) ASC   
       
     END    
    END  
    ELSE  
    BEGIN      
    
     ------------Internal  
     --BOOKING FORECAST  
      INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)   
      SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
      (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,
      Category,(ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)) ,0      
      FROM WRBHBProperty P   
      JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0  
      LEFT OUTER JOIN #RevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
      LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
      LEFT OUTER JOIN #BookingOutStandingFinalInternal O WITH(NOLOCK) ON  P.Id=O.PropertyId  
      WHERE Category IN ('Internal Property','Managed G H') AND P.Id=@Pram2  
      AND P.IsActive=1 AND P.IsDeleted=0  
        
      --CHECKIN FORECAST   
      INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
      SELECT C.CityName,P.PropertyName,ISNULL(NR.Tariff,0) NDDRevenue,ISNULL(DR.Tariff,0) DDRevenue,  
      (ISNULL(NR.Tariff,0)+ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,
      Category,(ISNULL(NR.GTV,0)+ISNULL(DR.GTV,0)+ISNULL(o.GTV,0)) ,0 
      FROM WRBHBProperty P   
      JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0  
      LEFT OUTER JOIN #CheckInRevanueNDDInternal NR WITH(NOLOCK) ON P.Id=NR.PropertyId  
      LEFT OUTER JOIN #RevanueDDInternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
      LEFT OUTER JOIN #OutStandingFinalInternal O WITH(NOLOCK) ON  P.Id=O.PropertyId  
      WHERE Category IN ('Internal Property','Managed G H') AND P.Id=@Pram2  
      AND P.IsActive=1 AND P.IsDeleted=0  
        
        
      ----------External  
      --BOOKINGG FORECAST  
       INSERT INTO #FinalBookingForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
      SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
      (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV ,0),
      ISNULL(DR.ActualTariff,0)      
      FROM WRBHBProperty P   
      JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0      
      LEFT OUTER JOIN #RevanueDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
      LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
      WHERE Category='External Property' AND P.Id=@Pram2  
      AND P.IsActive=1 AND P.IsDeleted=0  
        
        
      --CHECKIN FORECAST  
      INSERT INTO #FinalCheckInForeCast(CityName,PropertyName,NDDRevenue,DDRevenue,TOTAL,OutStanding,Category,GTV,ActualTariff)  
      SELECT C.CityName,P.PropertyName,ISNULL(DR.Tariff,0) DDRevenue,0,  
      (ISNULL(DR.Tariff,0)) TOTAL,ISNULL(O.Tariff,0) OutStanding,Category,ISNULL(DR.GTV,0),ISNULL(DR.ActualTariff,0)  
      FROM WRBHBProperty P   
      JOIN WRBHBCity C WITH(NOLOCK) ON C.Id=P.CityId AND C.IsActive=1 AND C.IsDeleted=0    
      LEFT OUTER JOIN #RevanueNDDExternal DR WITH(NOLOCK) ON P.Id=DR.PropertyId  
      LEFT OUTER JOIN #OutStanding O WITH(NOLOCK) ON  P.Id=O.PropertyId  
      WHERE Category='External Property' AND P.Id=@Pram2  
      AND P.IsActive=1 AND P.IsDeleted=0  
            
    END
    CREATE TABLE #FINALBOOKINGREVEVANETOTAL(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
    Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
    Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2)) 
    
    CREATE TABLE #FINALCHECKINREVEVANETOTAL(CityName NVARCHAR(100),PropertyName NVARCHAR(100),
    Direct DECIMAL(27,2),BTC DECIMAL(27,2),DD DECIMAL(27,2),Online DECIMAL(27,2),
    Category NVARCHAR(100),OrderData NVARCHAR(100),GTV DECIMAL(27,2),TOTAL DECIMAL(27,2))
      
    IF @Pram5='All Properties'  
	BEGIN
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'  
		FROM #FinalBookingForeCast  
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z'   
		FROM #FINALBOOKINGREVEVANETOTAL
		
		--SELECT BOOKING FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALBOOKINGREVEVANETOTAL
		WHERE (DD+Direct+BTC+Online+GTV)!=0
		ORDER BY OrderData ASC
		
	
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'  
		FROM #FinalCheckInForeCast  
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z'
		FROM #FINALCHECKINREVEVANETOTAL
		
		--CHECK IN FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALCHECKINREVEVANETOTAL
		WHERE (DD+Direct+BTC+Online+GTV)!=0 
		ORDER BY OrderData ASC	
		
	END  
	ELSE  
	BEGIN  
	IF @Pram5='External Property'  
	BEGIN 
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'  
		FROM #FinalBookingForeCast 
		WHERE Category=@Pram5 
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z' 
		FROM #FINALBOOKINGREVEVANETOTAL
		WHERE Category=@Pram5	
		 
		 --SELECT BOOKING FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALBOOKINGREVEVANETOTAL
		WHERE (DD+Direct+BTC+Online+GTV)!=0
		ORDER BY OrderData ASC
		
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'   
		FROM #FinalCheckInForeCast 
		WHERE Category=@Pram5 
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z'
		FROM #FINALCHECKINREVEVANETOTAL		
		WHERE Category=@Pram5 
		
		--CHECK IN FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALCHECKINREVEVANETOTAL 
		WHERE (DD+Direct+BTC+Online+GTV)!=0
		ORDER BY OrderData ASC
	END   
	ELSE  
	BEGIN 
	IF @Pram5='Internal Property'  
	BEGIN
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'  
		FROM #FinalBookingForeCast 
		WHERE Category IN ('Internal Property')  
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z' 
		FROM #FINALBOOKINGREVEVANETOTAL
		WHERE Category IN ('Internal Property')  	
		 
		--SELECT BOOKING FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALBOOKINGREVEVANETOTAL
		WHERE (DD+Direct+BTC+Online+GTV)!=0
		ORDER BY OrderData ASC
		
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)
		SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
		GTV,Category,'A'   
		FROM #FinalCheckInForeCast 
		WHERE Category IN ('Internal Property')  
		ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
		
		INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
		SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z'
		FROM #FINALCHECKINREVEVANETOTAL
		WHERE Category IN ('Internal Property') 
		
		--CHECK IN FORECAST REVENU
		SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
		FROM #FINALCHECKINREVEVANETOTAL 
		WHERE (DD+Direct+BTC+Online+GTV)!=0
		ORDER BY OrderData ASC
		END
		ELSE
		BEGIN
			INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
			SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
			GTV,Category,'A'  
			FROM #FinalBookingForeCast 
			WHERE Category IN ('Managed G H')  
			ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
			
			INSERT INTO #FINALBOOKINGREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
			SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z' 
			FROM #FINALBOOKINGREVEVANETOTAL
			WHERE Category IN ('Managed G H')  	
			 
			--SELECT BOOKING FORECAST REVENU
			SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
			FROM #FINALBOOKINGREVEVANETOTAL
			WHERE (DD+Direct+BTC+Online+GTV)!=0
			ORDER BY OrderData ASC
			
			INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)
			SELECT CityName,PropertyName,DDRevenue,NDDRevenue,ActualTariff+OutStanding,0,DDRevenue+NDDRevenue+ActualTariff+OutStanding,
			GTV,Category,'A'   
			FROM #FinalCheckInForeCast 
			WHERE Category IN ('Managed G H')  
			ORDER BY LTRIM(PropertyName),LTRIM(CityName) ASC 
			
			INSERT INTO #FINALCHECKINREVEVANETOTAL(CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData)  
			SELECT 'Total','',SUM(DD),SUM(Direct),SUM(BTC),SUM(Online),SUM(TOTAL),SUM(GTV),'','Z'
			FROM #FINALCHECKINREVEVANETOTAL
			WHERE Category IN ('Managed G H') 
			
			--CHECK IN FORECAST REVENU
			SELECT CityName,PropertyName,DD,Direct,BTC,Online,TOTAL,GTV,Category,OrderData
			FROM #FINALCHECKINREVEVANETOTAL 
			WHERE (DD+Direct+BTC+Online+GTV)!=0
			ORDER BY OrderData ASC
		
		END
	END  
	END  
	END
END




	
	