
GO
/****** Object:  StoredProcedure [dbo].[Sp_CheckoutIntermediate_Help]    Script Date: 11/07/2014 10:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================
-- Author: Anbu
-- Create date:08-05-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Check Out
-- =================================================================================
ALTER PROCEDURE [dbo].[Sp_CheckoutIntermediate_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@BillFrom NVARCHAR(100),
@BillTo NVARCHAR(100),
@CheckInHdrId INT=NULL,
@ExtraMatters DECIMAL(27,2)=NULL,
@StateId INT=NULL,
@PropertyId INT=NULL,

@UserId INT=NULL
)
AS
BEGIN
DECLARE @Cnt INT;

IF @Action='ServiceEntry'  
 BEGIN
	UPDATE WRBHBChechkOutHdr SET  ServiceEntryFlag=1 where Id=@CheckInHdrId
 END
IF @Action='PageLoad'  
	BEGIN  
   
   
		SET @Cnt=(SELECT COUNT(*) FROM WRBHBChechkOutHdr)  
		IF @Cnt=0 BEGIN SELECT 1 AS CheckoutNo;  
	END  
    
	ELSE   
	BEGIN  
		SELECT TOP 1 CAST(CheckoutNo AS INT)+1 AS CheckoutNo FROM WRBHBChechkOutHdr  
		where IsActive = 1 and IsDeleted = 0
		ORDER BY Id DESC;  
	END  
 -- Property  
		--select distinct D.Id As PropertyId,(D.PropertyName+','+C.CityName) as PropertyName  
		----,PU.UserId  
		--FROM WRBHBCheckInHdr H  
		--join WRBHBProperty D on H.PropertyId = D.Id and D.IsActive = 1 and D.IsDeleted = 0  
		--join WRBHBCity C on C.Id = D.CityId and C.IsActive = 1 and D.IsDeleted = 0  
		--join WRBHBPropertyUsers PU on PU.PropertyId = D.Id and PU.IsActive = 1 and PU.IsDeleted = 0  
		--join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0  
		--join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0  
		--where H.IsActive = 1 and H.IsDeleted = 0   
		--and H.PropertyType = 'Internal Property'  
		---- and CONVERT(nvarchar(100),H.ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103)  
		--and PU.UserId=@UserId  
		-- --where H.IsActive = 1 and H.IsDeleted = 0 and  
		--CONVERT(nvarchar(100),H.ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103) 
		CREATE TABLE #ChkProp (ZId BIGINT,PropertyName NVARCHAR(100)) 
		INSERT INTO #ChkProp (ZId,PropertyName)
		SELECT  D.Id As PropertyId,(D.PropertyName+','+C.CityName) as PropertyName  
		--,PU.UserId  
		FROM WRBHBCheckInHdr H  
		join WRBHBProperty D on H.PropertyId = D.Id and D.IsActive = 1 and D.IsDeleted = 0  
		join WRBHBCity C on C.Id = D.CityId and C.IsActive = 1 and D.IsDeleted = 0  
		join WRBHBPropertyUsers PU on PU.PropertyId = D.Id and PU.IsActive = 1 and PU.IsDeleted = 0  
		join WRBHBUser U on   PU.UserId =U.Id and pu.IsActive = 1 and PU.IsDeleted = 0  
		join WRBHBUserRoles R on  U.Id =R.UserId  and R.IsActive = 1 and R.IsDeleted = 0  
		where H.IsActive = 1 and H.IsDeleted = 0   
		and H.PropertyType in ('Internal Property','Client Prefered')  
		-- and CONVERT(nvarchar(100),H.ChkoutDate,103) = CONVERT(nvarchar(100),GETDATE(),103)  
		and PU.UserId=@UserId 
		GROUP BY D.Id,D.PropertyName,C.CityName
		select ZId,PropertyName from #ChkProp GROUP BY ZId,PropertyName
		select count(*) AS PropertyCount,ZId,PropertyName from #ChkProp GROUP BY ZId,PropertyName 
    
   
    
      
         
 
 -- drop table #Service  
    -- Item Load  
		CREATE TABLE #Service(Item NVARCHAR(100),PerQuantityprice DECIMAL(27,2),Id INT,TypeService NVARCHAR(100))  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Food And Beverages'  
		INSERT INTO #Service(Item,PerQuantityprice,Id,TypeService)  
		SELECT (ProductName) as Item,PerQuantityprice,Id,TypeService  
		FROM WRBHBContarctProductMaster    
		where IsActive = 1 and IsDeleted = 0  
		and TypeService = 'Laundry'  

		SELECT Item,PerQuantityprice,Id as ItemId,TypeService  
		FROM #Service  
         
         
END   
  
If @Action = 'GuestName'  
BEGIN  
		CREATE TABLE #GUEST(GuestName NVARCHAR(100),GuestId INT,StateId INT,CheckInHdrId INT,  
		PropertyId INT,RoomId INT,ApartmentId INT,BookingId INT,BedId INT,Type NVARCHAR(100),Flag int,
		BookingCode nvarchar(100),ChkInDT nvarchar(100),ChkOutDT nvarchar(100))  

		 -- New Entry Room
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT   h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt --,ChkoutDate
		From WRBHBCheckInHdr h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		isnull(d.RoomShiftingFlag,0)=0 and d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0 
		and ISNULL(IntermediateFlag,0)=0)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
 -- New Entry Bed	
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT   h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt --,ChkoutDate
		From WRBHBCheckInHdr h
		join WRBHBBedBookingPropertyAssingedGuest d on h.bookingId = d.bookingId and
		h.GuestId=d.GuestId and d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		 d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and
		h.Id NOT IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
 -- New Entry Apartment
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT   h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode,h.NewCheckInDate,d.ChkOutDt --,ChkoutDate
		From WRBHBCheckInHdr h
		join WRBHBApartmentBookingPropertyAssingedGuest d on h.bookingId = d.bookingId and
		h.GuestId=d.GuestId and d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and
		h.Id NOT IN (Select ChkInHdrId FROM WRBHBChechkOutHdr where IsActive = 1 and IsDeleted = 0)
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
	-- Flag 0 Entry	Room
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		isnull(d.RoomShiftingFlag,0)=0 and --d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 and Status = 'UnSettled')
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
	-- Flag 0 Entry Bed	
		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBedBookingPropertyAssingedGuest d on h.BookingId = d.BookingId and
		h.GuestId = d.GuestId  and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		--d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 and Status = 'UnSettled' )
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
	-- Flag 0 Entry Apartment
			
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBApartmentBookingPropertyAssingedGuest d on h.BookingId = d.BookingId and
		h.GuestId = d.GuestId and d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and -- d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(Flag,0) = 0 and  
		IsActive = 1 and IsDeleted = 0 and Status = 'UnSettled')
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt
		
-- Intermediate Flag 1 Entry Room
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBookingPropertyAssingedGuest d on h.Id = d.CheckInHdrId and
		h.BookingId = d.BookingId and h.GuestId = d.GuestId and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		isnull(d.RoomShiftingFlag,0)=0 and --d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 0 and IsDeleted = 0 )
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest	,h.NewCheckInDate,d.ChkOutDt
		
-- Intermediate Flag 1 Entry Bed	
		
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT  h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBBedBookingPropertyAssingedGuest d on h.BookingId = d.BookingId and
		h.GuestId = d.GuestId  and
		d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and  
		--d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 0 and IsDeleted = 0 )
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode ,h.ChkInGuest	,h.NewCheckInDate,d.ChkOutDt
		
-- Intermediate Flag 1 Entry Apartment
			
		INSERT INTO #GUEST(GuestName,GuestId,StateId,CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type,Flag,BookingCode,ChkInDT,ChkOutDT)
		
		SELECT h.ChkInGuest,h.GuestId,h.StateId,h.Id AS CheckInHdrId,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type as Level,0 as Flag,h.BookingCode  ,h.NewCheckInDate,d.ChkOutDt
		From WRBHBCheckInHdr h
		join WRBHBApartmentBookingPropertyAssingedGuest d on h.BookingId = d.BookingId and
		h.GuestId = d.GuestId and d.IsActive=1 and d.IsDeleted=0
		WHERE h.IsActive=1 AND h.IsDeleted=0 AND   
		PropertyType = 'Internal Property' and  
		PropertyId = @PropertyId and -- d.CurrentStatus = 'CheckIn' and
		--CONVERT(date,d.ChkOutDt,103) between CONVERT(date,d.ChkInDt,103) AND 
		--CONVERT(date,DATEADD(DAY,1,CONVERT(DATE,GETDATE(),103)),103) and   
		h.Id  IN (Select ChkInHdrId FRom WRBHBChechkOutHdr where isnull(IntermediateFlag,0) = 1 and  
		IsActive = 0 and IsDeleted = 0 )
		group by h.GuestName,h.GuestId,h.StateId,h.Id ,h.PropertyId,h.RoomId,h.ApartmentId,  
		h.BookingId,h.BedId,h.Type,h.BookingCode,h.ChkInGuest,h.NewCheckInDate,d.ChkOutDt

		SELECT  GuestName,GuestId,StateId, CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type as Level,BookingCode ,ChkInDT as CheckInDate,ChkOutDT as CheckOutDate
		FROM #GUEST  
		group by GuestName,GuestId,StateId, CheckInHdrId,PropertyId,RoomId,ApartmentId,  
		BookingId,BedId,Type ,BookingCode ,ChkInDT,ChkOutDT
		
		
		

-- Load Resident Managers,Assistant RM
		SELECT DISTINCT U.FirstName AS label,U.Id AS Data FROM WRBHBUser U  
		JOIN WRBHBPropertyUsers P ON U.Id=P.UserId AND P.IsActive=1 AND P.IsDeleted=0  
		WHERE P.UserType in ('Resident Managers','Assistant Resident Managers') AND   
		U.IsActive=1 AND U.IsDeleted=0 and P.PropertyId = @PropertyId  
    
    
    
  --Select isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId  
 END  
  
  
 IF @Action = 'GuestDetails'
 BEGIN
 
		SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr  
		WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0 
 
		CREATE TABLE #LEVEL(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),Id BIGINT,
		TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100))  
		DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100),@CheckInTime NVARCHAR(100),
		@NewCheckInDate NVARCHAR(100),@NewCheckInTimeType NVARCHAR(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
 --select @BookingId,@GuestId,@BookingLevel
If @BookingLevel = 'Room'   
	BEGIN  
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode)  
		--select top 1 CONVERT(nvarchar(100),min(ChkInDt),103),CONVERT(nvarchar(100),max(ChkOutDt),103) , 
		--TariffPaymentMode,ServicePaymentMode  
		--from WRBHBBookingPropertyAssingedGuest  
		--where GuestId = 29544 and BookingId = 4976 
		--group by TariffPaymentMode,ServicePaymentMode  
		--and IsDeleted=0 and IsActive=1 
		select top 1 CONVERT(nvarchar(100),(ChkInDt),103),CONVERT(nvarchar(100),(ChkOutDt),103) , 
		TariffPaymentMode,ServicePaymentMode  
		from WRBHBBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId 
		--group by TariffPaymentMode,ServicePaymentMode  ,ChkInDt,ChkOutDt
		order by Id desc
		--and IsDeleted=0 and IsActive=1 
		
	END  
If @BookingLevel = 'Bed'  
	BEGIN  
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode )  
		--select CONVERT(nvarchar(100),min(ChkInDt),103),CONVERT(nvarchar(100),max(ChkOutDt),103),
		--TariffPaymentMode,ServicePaymentMode     
		--from WRBHBBedBookingPropertyAssingedGuest  
		--where GuestId = @GuestId and BookingId = @BookingId  
		--group by TariffPaymentMode,ServicePaymentMode  
		--and IsDeleted=0 and IsActive=1 
		select CONVERT(nvarchar(100),(ChkInDt),103),CONVERT(nvarchar(100),(ChkOutDt),103),
		TariffPaymentMode,ServicePaymentMode     
		from WRBHBBedBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId  
		order by Id desc
	END   
If @BookingLevel = 'Apartment'  
	BEGIN  
		INSERT INTO #LEVEL(ChkInDate,ChkOutDate,TariffPaymentMode,ServicePaymentMode  )  
		select CONVERT(nvarchar(100),(ChkInDt),103),CONVERT(nvarchar(100),(ChkOutDt),103)  ,
		TariffPaymentMode,ServicePaymentMode   
		from WRBHBApartmentBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId 
		order by Id desc
		--group by TariffPaymentMode,ServicePaymentMode  
		--and IsDeleted=0 and IsActive=1  
	END   
		DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100);  
		set @ChkInDate =( SELECT TOP 1 ChkInDate FROM #LEVEL)   
		set @ChkOutDate =( SELECT TOP 1 ChkOutDate FROM #LEVEL)  
		
		
   
		SELECT  @CheckInTime=ArrivalTime,@NewCheckInTimeType=TimeType,
		@NewCheckInDate=convert(nvarchar(100),Cast(NewCheckInDate as DATE),103)	FROM WRBHBCheckInHdr  
		WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId
  
   
	IF(UPPER(@NewCheckInTimeType)=UPPER('AM'))  
	BEGIN  
		IF(CAST(@CheckInTime AS TIME)<CAST('11:00:00' AS TIME))  
		BEGIN 
			select @NewCheckInDate=CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@NewCheckInDate,103)),103)
		END
		 
		ELSE
		BEGIN
			SELECT @NewCheckInDate=convert(nvarchar(100),@NewCheckInDate,103)
		END
	END
	ELSE -- new added this else 
	BEGIN
		SELECT @NewCheckInDate=convert(nvarchar(100),@NewCheckInDate,103)
	END
	 
		SELECT Property,  
		CONVERT(NVARCHAR(100),ArrivalDate,103)+' To '+CONVERT(NVARCHAR(100),@ChkOutDate,103) AS Stay,Tariff,  
		CONVERT(NVARCHAR(100),@ChkOutDate,103) as ChkoutDate,CONVERT(NVARCHAR(100),@NewCheckInDate,103) AS CheckInDate  
		FROM WRBHBCheckInHdr  
		WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId;  
    
    
 --BillDate   
		SELECT CONVERT(NVARCHAR(103),@ChkOutDate,103) as BillDate 
		
		DECLARE @TariffPaymentMode nvarchar(100),@ServicePaymentMode nvarchar(100);  
		set @TariffPaymentMode =( SELECT TOP 1 TariffPaymentMode FROM #LEVEL)   
		set @ServicePaymentMode =( SELECT TOP 1 ServicePaymentMode FROM #LEVEL)  
		--SELECT ClientName,Direct,BTC,Id From  WRBHBCheckInHdr    
		--WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
   
		SELECT ClientName,ClientId,CityId,ServiceCharge,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,  
		Id From  WRBHBCheckInHdr    
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
		--Day Count  
		--CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)  
		--INSERT INTO #CountDays (NoofDays,CheckInHdrId)  
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,  
		Id--,ArrivalDate  
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId; 
 END
   
   
IF @Action='CHKINROOMDETAILS'  
BEGIN  
	
		Declare @CID bigint;
		--Select isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId and Flag=0 and
		--IsActive = 1 and IsDeleted = 0
		set @CID=(Select top 1 isnull(Id,0) as chekoutId from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId and Flag=0
		and IsActive= 1 and IsDeleted =0)  
 
IF(ISNULL(@CID,0)=0)  
BEGIN  

	CREATE TABLE #LEVEL1(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100),Id BIGINT)  
		--DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100),@CheckInTime NVARCHAR(100),
		--@NewCheckInDate NVARCHAR(100),@NewCheckInTimeType NVARCHAR(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId and IsActive =1 and IsDeleted =0)  
 --select @BookingId,@GuestId,@BookingLevel
	If @BookingLevel = 'Room'  
	BEGIN 
		INSERT INTO #LEVEL1(ChkInDate,ChkOutDate) 
		--select S@BillFrom,@BillTo 
		select @BillFrom,@BillTo-- CONVERT(nvarchar(100),min(ChkInDt),103),CONVERT(nvarchar(100),max(ChkOutDt),103)  
		from WRBHBBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId 
		--and IsDeleted=0 and IsActive=1 
	END  
	If @BookingLevel = 'Bed'  
	BEGIN  
		INSERT INTO #LEVEL1(ChkInDate,ChkOutDate)  
		select @BillFrom,@BillTo
		--select CONVERT(nvarchar(100),min(ChkInDt),103),CONVERT(nvarchar(100),max(ChkOutDt),103)   
		from WRBHBBedBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId  
		--and IsDeleted=0 and IsActive=1 
	END   
	If @BookingLevel = 'Apartment'  
	BEGIN  
		INSERT INTO #LEVEL1(ChkInDate,ChkOutDate)  
		select @BillFrom,@BillTo
		--select CONVERT(nvarchar(100),min(ChkInDt),103),CONVERT(nvarchar(100),max(ChkOutDt),103)   
		from WRBHBApartmentBookingPropertyAssingedGuest  
		where GuestId = @GuestId and BookingId = @BookingId 
		--and IsDeleted=0 and IsActive=1  
	END   
	--	DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100);  
		set @ChkInDate =( SELECT TOP 1 ChkInDate FROM #LEVEL1)   
		set @ChkOutDate =( SELECT TOP 1 ChkOutDate FROM #LEVEL1)  
		
		
   
		SELECT  @CheckInTime=ArrivalTime,@NewCheckInTimeType=TimeType	FROM WRBHBCheckInHdr  
		WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId
  
	IF(UPPER(@NewCheckInTimeType)=UPPER('AM'))  
	BEGIN  
		IF(CAST(@CheckInTime AS TIME)<CAST('11:00:00' AS TIME))  
		BEGIN 
			select @NewCheckInDate=CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)
		END
		 
		ELSE
		BEGIN
			SELECT @NewCheckInDate=@ChkInDate
		END
	end
	else -- new added this else 
	begin
		SELECT @NewCheckInDate=@ChkInDate
	end
		SELECT Property,  
		CONVERT(nvarchar(100),@NewCheckInDate,103)+' To '+CONVERT(nvarchar(100),@ChkOutDate,103) as Stay,Tariff,  
		CONVERT(nvarchar(100),@ChkOutDate,103) as ChkoutDate,CONVERT(nvarchar(100),@NewCheckInDate,103) as CheckInDate  
		FROM WRBHBCheckInHdr  
		WHERE IsActive = 1 and IsDeleted = 0 and Id =@CheckInHdrId;  
    
    
 --BillDate   
		SELECT CONVERT(varchar(103),@ChkOutDate,103) as BillDate  
    
 ----AdditionalDays  
 -- --BillTime  
 --    DECLARE @MIN INT;  
 -- SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(ArrivalDate) AS VARCHAR)+'-'+  
 -- CAST(MONTH(ArrivalDate) AS VARCHAR)+'-'+  
 -- CAST(DAY(ArrivalDate) AS VARCHAR)+' '+ArrivalTime,GETDATE()) AS M  
 -- FROM WRBHBCheckInHdr H WHERE H.Id=@CheckInHdrId);  
 -- IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END  
 -- ELSE BEGIN SELECT @MIN AS M END   
 ----this is 24 hour  for mat  
 -- Select @MIN/1440 as NoDays,(@MIN % 1440)/60 as NoHours,(@MIN % 60) as NoMinutes   
 ---- this is 12 hour Format   
 -- Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes   
   
 --Type  
		SELECT GuestName as Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr  
		WHERE  Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  

		CREATE TABLE #PaymentMode(TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100))  
		-- DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)  
  
  
If @BookingLevel = 'Room'   
	BEGIN  
		INSERT INTO #PaymentMode(TariffPaymentMode,ServicePaymentMode)  
		SELECT TariffPaymentMode,ServicePaymentMode  
		FROM WRBHBBookingPropertyAssingedGuest  
		WHERE GuestId = @GuestId and BookingId = @BookingId  --AND IsActive = 1 and IsDeleted = 0
	END  
If @BookingLevel = 'Bed'  
	BEGIN  
		INSERT INTO #PaymentMode(TariffPaymentMode,ServicePaymentMode)  
		SELECT TariffPaymentMode,ServicePaymentMode   
		FROM WRBHBBedBookingPropertyAssingedGuest  
		WHERE GuestId = @GuestId and BookingId = @BookingId  --AND IsActive = 1 and IsDeleted = 0
	END   
If @BookingLevel = 'Apartment'  
	BEGIN  
		INSERT INTO #PaymentMode(TariffPaymentMode,ServicePaymentMode)  
		SELECT TariffPaymentMode,ServicePaymentMode   
		FROM WRBHBApartmentBookingPropertyAssingedGuest  
		WHERE GuestId = @GuestId and BookingId = @BookingId  --AND IsActive = 1 and IsDeleted = 0
	END  
  
	--	DECLARE @TariffPaymentMode nvarchar(100),@ServicePaymentMode nvarchar(100);  
		set @TariffPaymentMode =( SELECT TOP 1 TariffPaymentMode FROM #PaymentMode)   
		set @ServicePaymentMode =( SELECT TOP 1 ServicePaymentMode FROM #PaymentMode)  
		--SELECT ClientName,Direct,BTC,Id From  WRBHBCheckInHdr    
		--WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
   
		SELECT ClientName,@TariffPaymentMode as TariffPaymentMode,@ServicePaymentMode as ServicePaymentMode,  
		Id From  WRBHBCheckInHdr    
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
		--Day Count  
		CREATE TABLE #CountDays(NoofDays INT,CheckInHdrId INT)  
		INSERT INTO #CountDays (NoofDays,CheckInHdrId)  
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,  
		Id--,ArrivalDate  
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;  

		--TariffCalculate  
		--CREATE TABLE #NetTariff(NetTariff DECIMAL(27,2))  
		--SET @Tariff=(SELECT Tariff From WRBHBCheckInHdr WHERE Id=@CheckInHdrId)  
		--INSERT INTO  #NetTariff (NetTariff)  
		--SELECT ISNULL(CD.NoofDays,0) * ISNULL(@Tariff,0) FROM WRBHBCheckInHdr CH    
		--JOIN  #CountDays CD ON CH.Id=CD.CheckInHdrId   
		--WHERE CH.IsActive=1 AND IsDeleted=0 AND Id=@CheckInHdrId;  
		--DECLARE @NetTariff Decimal(27,2)  

		--Tax Calculate  
		-- To Check Tariff two perticular amount   


		--drop table #LuxuryTax  
		--drop table #LuxuryTax1  
		--drop table #LuxuryTax2  
		--drop table #Tariff  
		--drop table #FINALLuxury  
		--drop table #FINAL  
		--     CREATE TABLE #LEVEL(ChkInDate NVARCHAR(100),ChkOutDate NVARCHAR(100))  
		-- -- DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);  
		--  set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		--  set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		--  set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)  

		--If @BookingLevel = 'Room'   
		-- BEGIN  
		--  INSERT INTO #LEVEL(ChkInDate,ChkOutDate)  
		--  select CONVERT(nvarchar(100),ChkInDt,103),CONVERT(nvarchar(100),ChkOutDt,103)   
		--  from WRBHBBookingPropertyAssingedGuest  
		--  where GuestId = @GuestId and BookingId = @BookingId  
		-- END  
		--If @BookingLevel = 'Bed'  
		-- BEGIN  
		--  INSERT INTO #LEVEL(ChkInDate,ChkOutDate)  
		--  select CONVERT(nvarchar(100),ChkInDt,103),CONVERT(nvarchar(100),ChkOutDt,103)   
		--  from WRBHBBedBookingPropertyAssingedGuest  
		--  where GuestId = @GuestId and BookingId = @BookingId  
		-- END   
		--If @BookingLevel = 'Apartment'  
		-- BEGIN  
		--  INSERT INTO #LEVEL(ChkInDate,ChkOutDate)  
		--  select CONVERT(nvarchar(100),ChkInDt,103),CONVERT(nvarchar(100),ChkOutDt,103)   
		--  from WRBHBApartmentBookingPropertyAssingedGuest  
		--  where GuestId = @GuestId and BookingId = @BookingId  
		-- END   
		--   DECLARE @ChkInDate nvarchar(100),@ChkOutDate nvarchar(100);  
		--      set @ChkInDate =( SELECT ChkInDate FROM #LEVEL)   
		--   set @ChkOutDate =( SELECT ChkOutDate FROM #LEVEL)  

		--set @ChkInDate = (select CONVERT(nvarchar(100),ArrivalDate,103) FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId);  
		--set @ChkOutDate = (select CONVERT(nvarchar(100),ChkoutDate,103) FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId)  

		CREATE TABLE #LuxuryTax(LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),LT DECIMAL(27,2),ST DECIMAL(27,2))  

		CREATE TABLE #LuxuryTax1(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2))  

		CREATE TABLE #LuxuryTax2(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2),  
		DATE NVARCHAR(100))  

		CREATE TABLE #Tariff(Tariff DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),Date NVARCHAR(100))  
		CREATE TABLE #TariffADD(Tariff DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),Date NVARCHAR(100))  

		CREATE TABLE #FINALLuxury(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),LT DECIMAL(27,2),ST DECIMAL(27,2),  
		DATE NVARCHAR(100))  

  
    
		CREATE TABLE #FINAL(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),LT DECIMAL(27,2),ST DECIMAL(27,2))  

		---TO GET TAX VALUE FOR GIVAEN DATE  
		-- select @ChkInDate,@ChkOutDate,@StateId;  
		INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
		TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
		SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
		TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
		FROM WRBHBTaxMaster  
		WHERE CONVERT(nvarchar(100),Date,103) between CONVERT(nvarchar(100),@ChkInDate,103) and  
		CONVERT(nvarchar(100),@ChkOutDate,103)    
		AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

		INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
		TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
		SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
		TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
		FROM WRBHBTaxMaster  
		WHERE CONVERT(nvarchar(100),DateTo,103) between CONVERT(nvarchar(100),@ChkInDate,103) and  
		CONVERT(nvarchar(100),@ChkOutDate,103)    
		AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

		INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
		TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
		SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
		TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
		FROM WRBHBTaxMaster  
		WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),@ChkInDate,103)   
		AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

		INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
		TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
		SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),ISNULL(ServiceTaxOnTariff,0),CONVERT(varchar(100),Date,103),  
		CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
		TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
		FROM WRBHBTaxMaster  
		WHERE CONVERT(nvarchar(100),@ChkOutDate,103)<= CONVERT(nvarchar(100),DateTo,103)    
		AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  



		DECLARE @Tariff DECIMAL(27,2),@RackTariffSingle DECIMAL(27,2),@RackTariffDouble DECIMAL(27,2),@Dt1 DateTime ,@prtyId BIGINT,  
		@chktime NVARCHAR(100),@TimeType NVARCHAR(100),@chkouttime NVARCHAR(100);  
		DECLARE @DateDiff int,@i int,@HR NVARCHAR(100),@MIN INT,@OutPutSEC INT,@OutPutHour INT,  
		@NoOfDays INT;  
		--SELECT * from #LuxuryTax1  
		SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
		FROM #LuxuryTax1;    
		WHILE (@DateDiff>=0)  
		BEGIN         
			INSERT INTO #LuxuryTax2(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Date,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT TOP 1 LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,FromDT,103)),103),  
			TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3     
			FROM #LuxuryTax1  
			SET @i=@i+1  
			SET @DateDiff=@DateDiff-1     
			IF @DateDiff=0  
		BEGIN  
		DELETE FROM #LuxuryTax1  
		WHERE Id IN(SELECT TOP 1 Id FROM #LuxuryTax1)  
		SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
		FROM #LuxuryTax1;  
		END  
		END    
  --SELECT * from #LuxuryTax2  
		DECLARE @BookingPropertyId BIGINT;  
		SELECT @BookingPropertyId=PropertyId FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId  
		SET @HR=(select CheckIn from WRBHBProperty where Id =@BookingPropertyId)  

		--TARIFF SPLIT FOR CHECK IN TO CHECK OUT   
		SELECT @NoOfDays=0,@chktime=ArrivalTime,@TimeType=TimeType,@Tariff=Tariff,@RackTariffSingle=RackTariffSingle,  
		@RackTariffDouble=RackTariffDouble,@i=0,  
		-- @RackTariff=RackTariff,  
		@prtyId=PropertyId,@chkouttime= CONVERT(VARCHAR(8),GETDATE(),108) FROM WRBHBCheckInHdr where Id=@CheckInHdrId  
    
		-- SELECT @DateDiff,@ChkInDate,@ChkOutDate,@HR  
		IF @HR='12'    
		BEGIN  
		-- To Check Time  
		SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+  
		CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+  
		CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+'12:00:00',CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+  
		CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+  
		CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+'23:59:59') AS M  
		);  
		IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END  
		ELSE BEGIN SELECT @MIN AS M END   
		--this is 24 hour  for mat  
		Select @DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60)   
		-- this is 12 hour Format   
		--Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes   
 --   
		--ADD BEFORE CHECKIN TIME TARIFF  
		IF(UPPER(@TimeType)=UPPER('AM'))  
		BEGIN  
			IF(CAST(@chktime AS TIME)<CAST('11:00:00' AS TIME))  
			BEGIN  
				SELECT @NoOfDays=@NoOfDays+1  
				INSERT INTO #Tariff(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
				SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,  
				CONVERT(NVARCHAR,DATEADD(DAY,-1,CONVERT(DATE,@ChkInDate,103)),103)     
			END     
		END  
    
		   --GET AFTER 1 CL CHECKOUT TIME TARIFF ADD  AND ABOVE ONE HR TARIFF ADD     
		   IF(CAST(@chkouttime AS TIME)>CAST('13:00:00' AS TIME))  
		   BEGIN  
				IF(@OutPutHour > 1)  
				BEGIN    
					INSERT INTO #TariffADD(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,  
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)     
		        END   
	      END  
	      IF(CAST(@chkouttime AS TIME)>CAST('23:00:00' AS TIME))  
	      BEGIN  
          IF(@OutPutHour > 1)  
          BEGIN    
					SELECT @NoOfDays=@NoOfDays+1       
					INSERT INTO #Tariff(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
					SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,  
					CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)   
	      
		            DELETE FROM #TariffADD;    
           END   
          END      
   --DAYS TARIFF ADD      
          WHILE (@DateDiff>0)  
          BEGIN   
				   SELECT @NoOfDays=@NoOfDays+1       
				   INSERT INTO #Tariff(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
				   SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)  
				   --SELECT @Tariff,@RackTariff,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)  
				   SET @i=@i+1  
				   SET @DateDiff=@DateDiff-1      
			 --  Select @i,@DateDiff    
              END  
          END    
          ELSE   
          BEGIN  
   --Get Date Differance  
 --  select @ChkInDate,@ChkOutDate,@chktime,@chkouttime  
	   SET @MIN=(SELECT DATEDIFF(MINUTE,CAST(YEAR(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+  
	   CAST(MONTH(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+'-'+  
	   CAST(DAY(CONVERT(DATE,@ChkInDate,103)) AS VARCHAR)+' '+@chktime,CAST(YEAR(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+  
	   CAST(MONTH(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+'-'+  
	   CAST(DAY(CONVERT(DATE,@ChkOutDate,103)) AS VARCHAR)+' '+@chkouttime) AS M  
	   );  
	   IF @MIN>1440 BEGIN SELECT @MIN-120 AS M END  
	   ELSE BEGIN SELECT @MIN AS M END   
	   --this is 24 hour  for mat  
	   Select @i=0,@DateDiff=@MIN/1440,@OutPutHour=(@MIN % 1440)/60,@OutPutSEC=(@MIN % 60)   
   -- this is 12 hour Format   
   --Select @MIN/720 as NoDays,(@MIN % 720)/60 as NoHours,(@MIN % 60) as NoMinutes      
       
     --ABOVE 1 HR IT WILL WORK  
       
	  IF(@OutPutHour >12)  
	  BEGIN    
		SELECT @NoOfDays=@NoOfDays+1        
		INSERT INTO #Tariff(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
		SELECT @Tariff,@RackTariffSingle ,@RackTariffDouble,  
		CONVERT(NVARCHAR,DATEADD(DAY,@DateDiff,CONVERT(DATE,@ChkInDate,103)),103)     
      END  
      --DAYS TARIFF ADD  
        
	   WHILE (@DateDiff>0)  
	   BEGIN   
		SELECT @NoOfDays=@NoOfDays+1       
		INSERT INTO #Tariff(Tariff,RackTariffSingle ,RackTariffDouble,Date)  
		SELECT @Tariff,@RackTariffSingle,@RackTariffDouble,  
		CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103)   
		SET @i=@i+1  
		SET @DateDiff=@DateDiff-1                    
	   END     
	  ENd   
    
  --Select * from #Tariff   
  --select * from #LuxuryTax2  
  --RACKTARIFFFLAG 1  
  --SLAB 1 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax*(RackTariffSingle+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffSingle+@ExtraMatters) between h.TariffAmtFrom AND h.TariffAmtTo  
		AND RackTariffFlag=1  

		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax*(RackTariffDouble+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE (RackTariffDouble+@ExtraMatters) between h.TariffAmtFrom AND h.TariffAmtTo  
		AND RackTariffFlag=1  
		 
		--SLAB 2 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax1*(RackTariffSingle+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax1,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		left outer join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffSingle+@ExtraMatters) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
		AND RackTariffFlag=1  

		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax1*(RackTariffDouble+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax1,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		left outer join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffDouble+@ExtraMatters) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
		AND RackTariffFlag=1  
		 
		--SLAB 3 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax2*(RackTariffSingle+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax2,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffSingle+@ExtraMatters) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
		AND RackTariffFlag=1  

		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax2*(RackTariffDouble+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax2,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffDouble+@ExtraMatters) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
		AND RackTariffFlag=1  

		--SLAB 4 CHECK (RACK TARIFF SINGLE AND DOUBLE)  
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax3*(RackTariffSingle+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax3,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffSingle+@ExtraMatters) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
		AND RackTariffFlag=1  

		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax3*(RackTariffDouble+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax3,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (RackTariffDouble+@ExtraMatters) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
		AND RackTariffFlag=1  
		
		--RACKTARIFFFLAG 0  
		--SLAB 1 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff, ISNULL(h.LuxuryTax*(D.Tariff+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (Tariff+@ExtraMatters) between h.TariffAmtFrom AND h.TariffAmtTo  
		AND RackTariffFlag=0  
		 
		--SLAB 2 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax1*(D.Tariff+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax1,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (Tariff+@ExtraMatters) between h.TariffAmtFrom1 AND h.TariffAmtTo1  
		AND RackTariffFlag=0  
		 
		--SLAB 3 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax2*(D.Tariff+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax2,0),  
		ISNULL(h.ServiceTax,0),D.Date   
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (Tariff+@ExtraMatters) between h.TariffAmtFrom2 AND h.TariffAmtTo2  
		AND RackTariffFlag=0  

		--SLAB 4 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date)  
		SELECT D.Tariff,ISNULL(h.LuxuryTax3*(D.Tariff+@ExtraMatters)/100,0),0,ISNULL(h.LuxuryTax3,0),  
		ISNULL(h.ServiceTax,0),D.Date
		FROM #LuxuryTax2 h  
		join #Tariff d ON H.Date = D.Date  
		WHERE  (Tariff+@ExtraMatters) between h.TariffAmtFrom3 AND h.TariffAmtTo3  
		AND RackTariffFlag=0  

		INSERT INTO #FINAL(TARIFF,LuxuryTax,ServiceTax,LT,ST)  
		SELECT SUM(TARIFF),(SUM(TARIFF)+@ExtraMatters)*LT/100,(SUM(TARIFF)+@ExtraMatters)*ST/100,LT,ST FROM   
		#FINALLuxury  
		GROUP BY TARIFF,LuxuryTax,ServiceTax,LT,ST  
		  
		
		--Select * from #Tariff;  
		--  SELECT ChkInDate,ChkOutDate FROM #LEVEL;  
		SELECT @NoOfDays AS NoofDays --FROM #Tariff  
		SELECT TARIFF AS NetTariff,LuxuryTax,ServiceTax,LT,ST FROM #FINAL  
		 
		 
		 
		SELECT COUNT(Id) AS Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId 
		and IsActive = 1 and IsDeleted = 0 and ISNULL(Flag,0)= 0 
		 
		SELECT COUNT(d.CheckOutHdrId) AS Id2 FROM WRBHBChechkOutHdr h  
		JOIN WRBHBCheckOutServiceHdr d ON h.Id = d.CheckOutHdrId  
		and d.IsActive = 1 and d.IsDeleted = 0
		--join WRBHBCheckOutServiceDtls cs on d.Id= cs.CheckOutServceHdrId  
		WHERE h.ChkInHdrId= @CheckInHdrId  
		and h.IsActive = 1 and h.IsDeleted = 0 and ISNULL(Flag,0)= 0
		 
		
		 
		SELECT Id  
		FROM WRBHBChechkOutHdr WHERE ChkInHdrId = @CheckInHdrId  and ISNULL(Flag,0)= 0
		 
		SELECT COUNT(Tariff) AS Tariff FROM #TariffADD  
     
   -- Settlement Grid Load  
     
--DROP TABLE #TariffSet  
  
--select @CheckInHdrId aslll;  
		CREATE TABLE #TariffSet(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  

		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCash d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND 
		d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCard d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId AND 
		d.IsActive=1 AND d.IsDeleted=0 and 
		d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCheque d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId 
		AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentCompanyInvoice d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId 
		AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Tariff'  and ISNULL(Flag,0)= 0

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT h.CheckOutNo,d.Payment,(round(h.ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		FROM WRBHBChechkOutHdr h  
		left outer join WRBHBChechkOutPaymentNEFT d on h.Id = d.ChkOutHdrId and  
		h.IsActive = 1 and h.IsDeleted = 0  
		WHERE h.ChkInHdrId=@CheckInHdrId
		 AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Tariff'  and ISNULL(h.Flag,0)= 0 

		-- Service  
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId 
		AND d.IsActive=1 AND d.IsDeleted=0 and  
		 d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND 
		d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Service'  and ISNULL(ch.Flag,0)= 0 

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND 
		d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Service'  and ISNULL(ch.Flag,0)= 0  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId 
		AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Service'  and ISNULL(ch.Flag,0)= 0  
		 
		 
		 INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(h.ChkOutServiceNetAmount,0)) as ChkOutTariffNetAmount,  
		(round(d.AmountPaid,0)) as ChkOutTariffNetAmount,isnull(d.OutStanding,0) as OutStanding,h. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId 
		AND d.IsActive=1 AND d.IsDeleted=0 
		and d.Payment='Service' and ISNULL(ch.Flag,0)= 0 
		 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCash d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND 
		--d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated'  and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  
		 
		 
		 
		 
		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus  
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCard d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND 
		--d.IsActive=1 AND d.IsDeleted=0 and  
		d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   

		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCheque d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId AND 
		--d.IsActive=1 AND d.IsDeleted=0 and   
		d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  


		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentCompanyInvoice d on d.ChkOutHdrId = h.CheckOutHdrId  
		where ch.ChkInHdrId=@CheckInHdrId 
		--AND d.IsActive=1 AND d.IsDeleted=0  
		and d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus  



		INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CH.CheckOutNo,d.Payment,(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0)) ,  
		(round(sum(d.AmountPaid),0)),
		(round(ch.ChkOutTariffNetAmount,0)+ISNULL(h.ChkOutServiceNetAmount,0))-(round(sum(d.AmountPaid),0)) as OutStanding,
		ch. PaymentStatus 
		from WRBHBChechkOutHdr ch  
		join WRBHBCheckOutServiceHdr h on h.CheckOutHdrId = ch.Id  
		join WRBHBChechkOutPaymentNEFT d on d.ChkOutHdrId = ch.Id  
		where ch.ChkInHdrId=@CheckInHdrId
		-- AND d.IsActive=1 AND d.IsDeleted=0   
		and d.Payment='Consolidated' and ISNULL(ch.Flag,0)= 0 
		group by ch.CheckOutNo,d.Payment,h. PaymentStatus,ch.ChkOutTariffNetAmount,h.ChkOutServiceNetAmount,
		ch. PaymentStatus   
     
     
  
   --   DECLARE @TEMPConsolidate1 NVARCHAR(100)  
   --SELECT @TEMPConsolidate1=PaymentStatus FROM #TariffSet   
   --WHERE BillType='Consolidate'  
     
   --IF ISNULL(@TEMPConsolidate1,'')='Paid'  
   --BEGIN   
   -- DELETE FROM #TariffSet   
   -- WHERE BillType!='Consolidate'  
   --END   
  
  
	   SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
			  FROM  #TariffSet  
  
  
  
     
   --CREATE TABLE #TariffSet(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
   --NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
   --INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
   --SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
   --(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
   --FROM WRBHBChechkOutHdr  
   --WHERE ChkInHdrId=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
     
     
   --     -- CAST(ISNULL(KH.TotalAmount,0)as DECIMAL(27,2)) AS Amount  
           
   --   INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
   --SELECT  DISTINCT CH.CheckOutNo,'Service' AS BillType,round(ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount,  
   --round(ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount,  
   --0.00 as OutStanding, CS.PaymentStatus  
   --FROM WRBHBCheckOutServiceHdr CS  
   --JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0  
   --WHERE CH.ChkInHdrId=@CheckInHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  
    
        
      --INSERT INTO #TariffSet(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
      --SELECT DISTINCT CO.CheckOutNo,'Consolidated' AS BillType,round(CO.ChkOutTariffNetAmount+CS.ChkOutServiceNetAmount,0) AS Amount,  
      --round(CO.ChkOutTariffNetAmount+CS.ChkOutServiceNetAmount,0) AS NetAmount,  
      --0.00 as OutStanding,'Unpaid' as PaymentStatus   
      --FROM WRBHBChechkOutHdr CO  
      --JOIN WRBHBCheckOutServiceHdr CS ON CO.Id=CS.CheckOutHdrId AND CS.IsActive=1 AND CS.IsDeleted=0  
      --WHERE CO.ChkInHdrId=@CheckInHdrId AND CO.IsActive=1 AND CO.IsDeleted=0;  
        
		  --SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
				-- FROM  #TariffSet   
               
               
     
     
     
		--Name  
		  SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		  WHERE ChkInHdrId=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   and ISNULL(Flag,0)= 0 
	        
	        
		  -- TARIFF FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND D.IsDeleted = 0   AND
		   H.ChkInHdrId = @CheckInHdrId   and ISNULL(h.Flag,0)= 0 
		  -- SERVICE FOR ADD PAYMENTS  
		  SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		  FROM WRBHBCheckOutServiceHdr H  
		  JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive=1 AND H.IsDeleted=0 AND D.ChkInHdrId=@CheckInHdrId  and ISNULL(d.Flag,0)= 0
		  -- CONSOLIDATE FOR ADD PAYMENTS  
		  SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		  FROM WRBHBChechkOutHdr H  
		  JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId AND D.IsActive = 1 AND D.IsDeleted = 0  
		  WHERE H.IsActive = 1 AND H.IsDeleted = 0 AND  
		  H.ChkInHdrId = @CheckInHdrId  and ISNULL(h.Flag,0)= 0
	        
	        
		  SELECT COUNT(*) AS UnPaid FROM  #TariffSet  WHERE PaymentStatus = 'UnPaid'  
END
ELSE
BEGIN
	SELECT Property,Stay,ChkOutTariffAdays  AS Tariff,  
		CONVERT(NVARCHAR(100),CheckOutDate,103) AS ChkoutDate,CONVERT(NVARCHAR(100),CheckInDate,103) AS CheckInDate  
		FROM WRBHBChechkOutHdr WHERE  Id=@CID --and  IsActive=1 and IsDeleted=0 
		and Flag=0  

		--BillDate   
		SELECT CONVERT(VARCHAR(103),CheckOutDate ,103) AS BillDate   
		FROM WRBHBChechkOutHdr  WHERE   Id=@CID --and IsActive=1 and IsDeleted=0
		 and Flag=0  

		--Type  
		SELECT GuestName AS Name,RoomNo,EmpCode,ApartmentType,BedType,PropertyType FROM WRBHBCheckInHdr  
		WHERE  Id=@CheckInHdrId --AND IsActive=1 AND IsDeleted=0  

		CREATE TABLE #PaymentMode1(TariffPaymentMode NVARCHAR(100),ServicePaymentMode NVARCHAR(100))  
		-- DECLARE @BookingId BIGINT,@GuestId BIGINT,@BookingLevel nvarchar(100);  
		set @BookingId=(select BookingId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @GuestId=(select GuestId from WRBHBCheckInHdr where Id = @CheckInHdrId)  
		set @BookingLevel=(select Type from WRBHBCheckInHdr where Id = @CheckInHdrId)  
  
  
		If @BookingLevel = 'Room'   
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode  
			  from WRBHBBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END  
		If @BookingLevel = 'Bed'  
		 BEGIN  
			  INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			  select TariffPaymentMode,ServicePaymentMode   
			  from WRBHBBedBookingPropertyAssingedGuest  
			  where GuestId = @GuestId and BookingId = @BookingId  
		 END   
		If @BookingLevel = 'Apartment'  
		BEGIN  
			INSERT INTO #PaymentMode1(TariffPaymentMode,ServicePaymentMode)  
			select TariffPaymentMode,ServicePaymentMode   
			from WRBHBApartmentBookingPropertyAssingedGuest  
			where GuestId = @GuestId and BookingId = @BookingId  
		END  

		DECLARE @TariffPaymentModes nvarchar(100),@ServicePaymentModes nvarchar(100);  
		set @TariffPaymentModes =( SELECT top 1 TariffPaymentMode FROM #PaymentMode1)   
		set @ServicePaymentModes =( SELECT top 1 ServicePaymentMode FROM #PaymentMode1)  
		--SELECT ClientName,Direct,BTC,Id From  WRBHBCheckInHdr    
		--WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0  
    
		SELECT ClientName,@TariffPaymentModes as TariffPaymentMode,@ServicePaymentModes as ServicePaymentMode,  
		Id From  WRBHBCheckInHdr    
		WHERE Id=@CheckInHdrId-- AND IsActive=1 AND IsDeleted=0  
		--Day Count  
		CREATE TABLE #CountDays1(NoofDays INT,CheckInHdrId INT)  
		INSERT INTO #CountDays1(NoofDays,CheckInHdrId)  
		SELECT DATEDIFF(day, CAST(CAST(ArrivalDate AS NVARCHAR)+' '+ArrivalTime AS DATETIME), CAST(ChkoutDate AS NVARCHAR)) AS Days,  
		Id--,ArrivalDate  
		FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId;  



		Select 0 as M;  

		Select NoOfDays from WRBHBChechkOutHdr  where  Id=@CID --and IsActive=1 and IsDeleted=0 
		and Flag=0  

		select ChkOutTariffTotal NetTariff,ChkOutTariffLT LuxuryTax,  
		ChkOutTariffST1 ServiceTax,0 LT,0 ST  from WRBHBChechkOutHdr   
		where   Id=@CID --and IsActive=1 and IsDeleted=0 
		and Flag=0  

		SELECT COUNT(Id) as Id1 from WRBHBChechkOutHdr where ChkInHdrId = @CheckInHdrId   
     
		SELECT COUNT(d.CheckOutHdrId) as Id2 from WRBHBChechkOutHdr h  
		join WRBHBCheckOutServiceHdr d on h.Id = d.CheckOutHdrId   
		where h.ChkInHdrId= @CheckInHdrId and h.  
		IsActive=1 and h.IsDeleted=0  
		SELECT Id from WRBHBChechkOutHdr   
		where Id=@CID --and IsActive=1 and IsDeleted=0 
		and Flag=0  
		 
		select 1 as Tariff;--this is doubt value 
		 
		DECLARE @CheckOutId BIGINT;
		 
		 SELECT @CheckOutId=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 AND IsActive = 1 and IsDeleted = 0
		  
		CREATE TABLE #TariffSet1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
	
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSetFinal(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet1
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffs(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CID 
		--AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id
		-- AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CID 
		--AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
		
		DECLARE @TSCOUNT  INT;
		SELECT @TSCOUNT=COUNT(*) FROM  #Tariffs
        
        IF @TSCOUNT=2
        BEGIN
			INSERT INTO #Tariffs(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffs  
			group by BillNo
		END
		
		
		update #Tariffs set NetAmount=isnull(d.NetAmount,0),OutStanding=(t.Amount-isnull(d.NetAmount,0)) 
		from #Tariffs t
		left outer Join  #TariffSetFinal d on t.BillType=d.BillType
		
		
		DECLARE @TARIFAMT11 DECIMAL(27,2),@SERVICEAMT11 DECIMAL(27,2)  
		SET @TARIFAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1 where BillType='Tariff')  
		SET @SERVICEAMT11=(SELECT isnull(sum(NetAmount),0) from #TariffSet1  where BillType='Service')  
		-- select @TARIFAMT11,@SERVICEAMT11  
		--update #TariffSet1 set  NetAmount = @TARIFAMT11  where BillType='Tariff' ;  
		--update #TariffSet1 set  NetAmount = @SERVICEAMT11  where BillType='Service' ;  

		--CREATE TABLE #TafFin(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
        
		--INSERT INTO #TafFin(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,isnull(T1.Amount,0) Amount, (ISNULL(T2.NetAmount,0)) NetAmount,  
		--ISNULL(T1.Amount,0)-(ISNULL(T2.NetAmount,0)) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffs T1  
		--LEFT   JOIN #TariffSet1 T2 ON T1.BillType=T2.BillType  
		--group by T1.BillNo,T1.BillType,T1.Amount,T2.NetAmount,T1.PaymentStatus  
		
        update #Tariffs set PaymentStatus='Paid'  
        where Amount=NetAmount;  
        
       
        
		DECLARE @TARIFAMT DECIMAL(27,2),@SERVICEAMT DECIMAL(27,2),@CONSOLIAMT DECIMAL(27,2)  
		SET @TARIFAMT=(SELECT OutStanding from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT=(SELECT OutStanding from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT=(SELECT OutStanding from #Tariffs  where BillType='Consolidate')  

		DECLARE @TARIFAMT1 DECIMAL(27,2),@SERVICEAMT1 DECIMAL(27,2),@CONSOLIAMT1 DECIMAL(27,2)  
		SET @TARIFAMT1=(SELECT NetAmount from #Tariffs where BillType='Tariff')  
		SET @SERVICEAMT1=(SELECT NetAmount from #Tariffs  where BillType='Service')  
		SET @CONSOLIAMT1=(SELECT NetAmount from #Tariffs  where BillType='Consolidate')  
        
     
           
		DELETE  FROM   #Tariffs  WHERE BillType='Consolidate'  
		and round((@TARIFAMT1+@SERVICEAMT1),0)!=0  

		DECLARE @TEMPConsolidate NVARCHAR(100),@Netamount1 decimal(27,2)  
		SELECT @TEMPConsolidate=PaymentStatus FROM #Tariffs   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate,'')='Paid'  
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END 

		SELECT @Netamount1=NetAmount FROM #Tariffs   
		WHERE BillType='Consolidate' 

		IF cast(ISNULL(@Netamount1,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffs   
			WHERE BillType!='Consolidate'  
		END
		 
        SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id FROM #Tariffs; 
         
		 
		SELECT  Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CID --AND IsActive=1 AND IsDeleted=0   
		GROUP BY Name

		-- TARIFF FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@TARIFAMT,0),0) AS ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE 
		--H.IsActive = 1 AND D.IsDeleted = 0 AND 
		H.Id = @CID  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL(ROUND(@SERVICEAMT,0),0) AS ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE
		-- H.IsActive=1 AND H.IsDeleted=0 AND 
		 D.Id=@CID;  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT DISTINCT ISNULL( ROUND((@TARIFAMT+@SERVICEAMT),0),0) AS ConsolidateAmount 
		--FROM #Tariffs  
		--WHERE ROUND((@TARIFAMT+@SERVICEAMT),0)!=0  
	--	SELECT 1 AS UnPaid;   
	END
		
	
END  
  
	   
 IF @Action='Print'  
  BEGIN   
		 

		DECLARE @CheckOutId1 BIGINT;
		 
		 --SELECT @CheckOutId1=Id FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId
		 --AND IsActive = 1 and IsDeleted = 0
		
		  select @CheckOutId1=@CheckInHdrId
		  
		 
		  
		CREATE TABLE #TariffSet2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  
		
		CREATE TABLE #TariffSetFinal2(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT,PaymentType NVARCHAR(100))  

		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)
		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCash d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCard d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCheque d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentNEFT d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSet2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId)  

		SELECT '',d.Payment,0,(round((d.AmountPaid),0)) as ChkOutTariffNetAmount,0,'',d.ChkOutHdrId 
		FROM  WRBHBChechkOutPaymentCompanyInvoice d   
		WHERE D.ChkOutHdrId=@CheckOutId1 
		--AND d.IsActive=1 AND d.IsDeleted=0 
		
		INSERT INTO #TariffSetFinal2(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,CheckOutId) 
		select BillNo,BillType,Amount,sum(NetAmount),OutStanding,PaymentStatus,CheckOutId
		from #TariffSet2
		group by BillNo,BillType,Amount,OutStanding,PaymentStatus,CheckOutId
		
		
---upto this paid with flag 0 is taken  for else part of checkout   
		CREATE TABLE #Tariffsa(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100),
		CheckOutId BIGINT)  
		
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckOutId1 
		--AND IsActive=1 AND IsDeleted=0   
   
           
		INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT   CH.CheckOutNo,'Service' AS BillType,round(sum(ChkOutServiceNetAmount),0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id --AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckOutId1 --AND CS.IsActive=1 AND CS.IsDeleted=0    
		GROUP BY CH.CheckOutNo, CS.PaymentStatus 
  
    
        DECLARE @TSCOUNT1  INT;
		SELECT @TSCOUNT1=COUNT(*) FROM  #Tariffsa
        
        IF @TSCOUNT1=2
        BEGIN
			INSERT INTO #Tariffsa(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
			select BillNo ,'Consolidate',SUM(Amount),SUM(NetAmount),SUM(OutStanding),'UnPaid' 
			from #Tariffsa  
			group by BillNo
		END
		
		
		
		update #Tariffsa set NetAmount=d.NetAmount,OutStanding=(t.Amount-d.NetAmount) 
		from #Tariffsa t
		Join  #TariffSetFinal2 d on t.BillType=d.BillType 

		
		
		dECLARE @TARIFAMT111 DECIMAL(27,2),@SERVICEAMT111 DECIMAL(27,2)  
		SET @TARIFAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2 where BillType='Tariff')  
		SET @SERVICEAMT111=(SELECT isnull(sum(NetAmount),0) from #TariffSet2  where BillType='Service')  
		--select @TARIFAMT111,@SERVICEAMT111  
		update #TariffSet2 set  NetAmount = @TARIFAMT111  where BillType='Tariff' ;  
		update #TariffSet2 set  NetAmount = @SERVICEAMT111  where BillType='Service' ;  
   

		CREATE TABLE #TafFin1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--SELECT T1.BillNo,T1.BillType,T1.Amount,ISNULL(T2.NetAmount,0) NetAmount,  
		--ISNULL(T1.Amount,0)-ISNULL(T2.NetAmount,0) AS OutStanding ,  
		--T1.PaymentStatus PaymentStatus                
		--FROM   #Tariffsa T1  
		--left  outer  JOIN #TariffSet2 T2 ON T1.BillType=T2.BillType  
         
        
       
       
		--CREATE TABLE #TafFin22(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		--NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  

		--INSERT INTO #TafFin22(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		--select BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus   
		--from  #TafFin1 		
		--group by BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus ;  
		--  select * from #TafFin22  

		dECLARE @TARIFAMTs DECIMAL(27,2),@SERVICEAMTs DECIMAL(27,2)  
		SET @TARIFAMTs=(SELECT OutStanding from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMTs=(SELECT OutStanding from #Tariffsa  where BillType='Service')  
		

		dECLARE @TARIFAMT1s DECIMAL(27,2),@SERVICEAMT1s DECIMAL(27,2)  
		SET @TARIFAMT1s=(SELECT NetAmount from #Tariffsa where BillType='Tariff')  
		SET @SERVICEAMT1s=(SELECT NetAmount from #Tariffsa  where BillType='Service')  

		  
		   
		delete  from   #Tariffsa  where BillType='Consolidate'  
		and round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  

		DECLARE @TEMPConsolidate1 NVARCHAR(100),@Netamount decimal(27,2),@PamentMode Nvarchar(100)   
		SELECT @TEMPConsolidate1=PaymentStatus FROM #Tariffsa   
		WHERE BillType='Consolidate'  
		
		
		IF ISNULL(@TEMPConsolidate1,'') = 'Paid'  
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END   
		
		SELECT @Netamount=sum(NetAmount) FROM #Tariffsa   
		WHERE BillType='Consolidate' 


		IF cast(ISNULL(@Netamount,0)AS INT) != 0 
		BEGIN   
			DELETE FROM #Tariffsa   
			WHERE BillType!='Consolidate'  
		END  
		
		update #Tariffsa set PaymentStatus='Paid'  
		where Amount=@Netamount ;
		   --select * from #TafFin22
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #Tariffs  
		--Select  BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id from #TariffSet1  
		
		Select  BillNo,BillType,Amount,SUM(NetAmount) NetAmount,Amount-SUM(NetAmount) OutStanding,PaymentStatus,
		0 AS Id from #Tariffsa
		group by BillNo,BillType,Amount,PaymentStatus
		
      --Name  
        
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE ChkInHdrId=@PropertyId 
		--AND IsActive=1 AND IsDeleted=0   

		-- TARIFF FOR ADD PAYMENTS   
		--@PropertyId(CheckOut Id Temp... send)  
		SELECT isnull(round(@TARIFAMTs,0),0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive = 1 AND D.IsDeleted = 0  AND
		 H.Id = @PropertyId  

		-- SERVICE FOR ADD PAYMENTS  
		SELECT isnull(round(@SERVICEAMTs,0),0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE 
		--H.IsActive=1 AND H.IsDeleted=0 AND 
		D.Id=@PropertyId;  
		-- CONSOLIDATE FOR ADD PAYMENTS  

		SELECT distinct isnull(round((@TARIFAMT1s+@SERVICEAMT1s),0),0) AS ConsolidateAmount 
		--from #TafFin22  
		--WHERE round((@TARIFAMT1s+@SERVICEAMT1s),0)!=0  
		
		
		
     
  END  
 If @Action ='Services'  
	BEGIN  
         --ExactCheckOut  
	   SELECT CheckOut,CheckOutType FROM WRBHBProperty  
	   WHERE IsActive=1 AND IsDeleted=0 AND  Id=@CheckInHdrId;  
	   --GraceTime  
	   SELECT GraceTime FROM  WRBHBProperty  
	   WHERE IsActive=1 AND IsDeleted=0 AND  Id=@CheckInHdrId;  
     END  
--If @Action='Load'  
--begin  
--SELECT DISTINCT (FirstName+''+LastName) AS ResidentManger FROM WRBHBUser U  
-- JOIN WRBHBPropertyUsers P ON U.Id=P.UserId AND P.IsActive=1 AND P.IsDeleted=0  
-- WHERE P.UserType in ('Resident Managers','Assistant Resident Managers') AND   
-- U.IsActive=1 AND U.IsDeleted=0 and P.PropertyId = 1  
    
    
IF @Action='Prints'  
  BEGIN   
		CREATE TABLE #Tariff1(BillNo INT,BillType NVARCHAR(100),Amount DECIMAL(27,2),  
		NetAmount DECIMAL(27,2),OutStanding decimal(27,2),PaymentStatus nvarchar(100))  
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT CheckOutNo,'Tariff' AS BillType,(round(ChkOutTariffNetAmount,0)) as ChkOutTariffNetAmount,  
		0.00 as ChkOutTariffNetAmount,0.00 as OutStanding, PaymentStatus  
		FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId 
		--AND IsActive=1 AND IsDeleted=0  
     
     
        -- CAST(ISNULL(KH.TotalAmount,0)as DECIMAL(27,2)) AS Amount  
           
		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT  DISTINCT CH.CheckOutNo,'Service' AS BillType,round(ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount,  
		0.00 as ChkOutServiceNetAmount,  
		0.00 as OutStanding, CS.PaymentStatus  
		FROM WRBHBCheckOutServiceHdr CS  
		JOIN WRBHBChechkOutHdr  CH ON CS.CheckOutHdrId=CH.Id --AND CH.IsActive=1 AND CH.IsDeleted=0  
		WHERE CH.Id=@CheckInHdrId 
		--AND CS.IsActive=1 AND CS.IsDeleted=0  


		INSERT INTO #Tariff1(BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus)  
		SELECT DISTINCT CO.CheckOutNo,'Consolidate' AS BillType,round(CO.ChkOutTariffNetAmount+CS.ChkOutServiceNetAmount,0) AS Amount,  
		0.00 AS NetAmount,  
		0.00 as OutStanding,'Unpaid' as PaymentStatus   
		FROM WRBHBChechkOutHdr CO  
		JOIN WRBHBCheckOutServiceHdr CS ON CO.Id=CS.CheckOutHdrId --AND CS.IsActive=1 AND CS.IsDeleted=0  
		WHERE CO.Id=@CheckInHdrId 
		--AND CO.IsActive=1 AND CO.IsDeleted=0;  

		SELECT BillNo,BillType,Amount,NetAmount,OutStanding,PaymentStatus,0 AS Id               
			 FROM  #Tariff1   
         
        
      --Name  
		SELECT DISTINCT Name FROM WRBHBChechkOutHdr  
		WHERE Id=@CheckInHdrId AND IsActive=1 AND IsDeleted=0   


		-- TARIFF FOR ADD PAYMENTS  
		SELECT round(H.ChkOutTariffNetAmount,0) as ChkOutTariffNetAmount,D.ChkinAdvance as Advance,H.ChkInHdrId  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckInHdr D ON H.ChkInHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive = 1 AND D.IsDeleted = 0   AND 
		H.Id = @CheckInHdrId  
		-- SERVICE FOR ADD PAYMENTS  
		SELECT round(H.ChkOutServiceNetAmount,0) as ChkOutServiceNetAmount  
		FROM WRBHBCheckOutServiceHdr H  
		JOIN WRBHBChechkOutHdr D ON H.CheckOutHdrId = D.Id AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE --H.IsActive=1 AND H.IsDeleted=0 AND 
		D.Id=@CheckInHdrId  
		-- CONSOLIDATE FOR ADD PAYMENTS  
		SELECT round((H.ChkOutTariffNetAmount+D.ChkOutServiceNetAmount),0) AS ConsolidateAmount  
		FROM WRBHBChechkOutHdr H  
		JOIN WRBHBCheckOutServiceHdr D ON H.Id = D.CheckOutHdrId --AND D.IsActive = 1 AND D.IsDeleted = 0  
		WHERE-- H.IsActive = 1 AND H.IsDeleted = 0 AND  
		H.Id = @CheckInHdrId  
        
        
  END   
IF @Action='PaidUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid' , IsActive = 1 
	   WHERE ChkInHdrId = @CheckInHdrId  
	    
  END   
IF @Action='ServiceUpdate'  
  BEGIN  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  
  END   
IF @Action='ConUpdate'  
  BEGIN  
	   UPDATE WRBHBChechkOutHdr set PaymentStatus = 'UnPaid'  
	   WHERE ChkInHdrId = @CheckInHdrId  
     
	   UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'UnPaid'    
	   WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)  
  END 
  
-- Intermediate update
If @Action='TariffIntermediate'  
BEGIN
	
    DECLARE @CheckOutId2 BIGINT;
    DECLARE @IntemediateChkoutDt NVARCHAR(100),@PayeeName NVARCHAR(100),@Address NVARCHAR(4000),
	@Consolidated BIT,@CreatedBy BIGINT
    SET @CheckOutId2 =  (SELECT TOP 1 Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId order by Id desc)
    SET @IntemediateChkoutDt = (SELECT TOP 1 CONVERT(DATE,BillEndDate,103)  FROM WRBHBChechkOutHdr
     WHERE ChkInHdrId=@CheckInHdrId order by Id desc)
    SET @PayeeName =(select top 1 GuestName from WRBHBChechkOutHdr where ChkInHdrId=@CheckInHdrId order by Id desc)
  --  SET @Consolidated = 
    
   
	UPDATE WRBHBCheckInHdr SET NewCheckInDate = @IntemediateChkoutDt ,ArrivalTime = '12:00:00',TimeType = 'PM'
	WHERE Id = @CheckInHdrId  
	
	UPDATE WRBHBChechkOutHdr SET PaymentStatus = 'Paid' ,Flag = 1,Status='CheckOut' ,IsActive = 1 
	WHERE Id = @CheckOutId2 
	
	UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'  ,IsActive = 1  
	WHERE CheckOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCash SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCard SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCheque SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentCompanyInvoice SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	UPDATE WRBHBChechkOutPaymentNEFT SET IsActive = 1 
	WHERE ChkOutHdrId = @CheckOutId2
	
	-- Settlement table insert 
	CREATE TABLE #TEMPCHKHDR(ChkOutHdrId INT,PayeeName NVARCHAR(100),AddressS NVARCHAR(4000),
	Consolidated BIT,CreatedBy BIGINT,ModifiedBy BIGINT,Payment nvarchar(100),AmountPaid decimal(27,2),StatusId Bigint)

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)

	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCash
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCard
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCheque
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentCompanyInvoice
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2

	INSERT INTO #TEMPCHKHDR(ChkOutHdrId,PayeeName,AddressS,Consolidated,CreatedBy,ModifiedBy,Payment,AmountPaid,StatusId)
	SELECT ChkOutHdrId,PayeeName,Address,0 Consoli,CreatedBy,ModifiedBy,Payment,AmountPaid,Id
	FROM WRBHBChechkOutPaymentNEFT
	WHERE IsActive=1 AND IsDeleted=0 AND ISNULL(OutStanding,0)=0 AND ChkOutHdrId=@CheckOutId2
	--Insert into main table
	INSERT INTO WRBHBCheckOutSettleHdr(ChkOutHdrId,PayeeName,Address,Consolidated,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	Select Distinct ChkOutHdrId,PayeeName,AddressS,0,CreatedBy,GETDATE(),ModifiedBy,GETDATE(),1,0,NEWID()
	from #TEMPCHKHDR

	DEclare @CkstlHdrid Bigint;
	SET @CkstlHdrid=@@IDENTITY;

	--SELECT Id FROM WRBHBCheckOutSettleHdr WHERE Id=@CkstlHdrid;


	INSERT INTO WRBHBCheckOutSettleDtl(CheckOutSettleHdrId,PropertyId,GuestId,BillNo,BillType,
	BillAmount,NetAmount,OutStanding,PaymentStatus,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	Select @CkstlHdrid,0 as prptyId,0 as GuestId,0 as BillNO, Payment Billtype,
	AmountPaid,AmountPaid,0 as Outstand,'Paid' Status,
	CreatedBy,GETDATE(),CreatedBy,GETDATE(),1,0,NEWID()
	from #TEMPCHKHDR
	group by Payment,AmountPaid,CreatedBy

	
	
END

If @Action='ServiceIntermediate'  
BEGIN
	UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'Paid'  ,IsActive = 1  
	WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId) 
	
	UPDATE WRBHBChechkOutPaymentCash SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCard SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCheque SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCompanyInvoice SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentNEFT SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
END

If @Action='ConsolidateIntermediate'  
BEGIN
	UPDATE WRBHBChechkOutHdr set PaymentStatus = 'UnPaid',IsActive = 1   
	WHERE ChkInHdrId = @CheckInHdrId
	   
	UPDATE WRBHBCheckOutServiceHdr SET PaymentStatus = 'UnPaid'  ,IsActive = 1  
	WHERE CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId) 
	
	UPDATE WRBHBChechkOutPaymentCash SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCard SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCheque SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentCompanyInvoice SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
	UPDATE WRBHBChechkOutPaymentNEFT SET IsActive = 1 
	WHERE ChkOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE ChkInHdrId=@CheckInHdrId)
	
END
  
IF @Action='IMAGEUPLOAD'  
BEGIN 
		UPDATE WRBHBChechkOutPaymentCompanyInvoice SET FileLoad=@Str1 
		WHERE Id=@CheckInHdrId ---CompanyInvoice Id IS IN @CheckInHdrId
  END 
		
END

	
			
			
			




