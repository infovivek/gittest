
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingPropertyAssingedGuest_Validation]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Validation]
GO   
/* 
Author Name : Arun
Created On 	: (28/05/2014)  >
Section  	: Custom Fields Details  Insert 
Purpose  	: Custom Fields Details  Insert
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
CREATE PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Validation](
@BookingId BIGINT,
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@GuestId	BIGINT,
@CheckInDT NVARCHAR(100),
@CheckOutDT NVARCHAR(100),
@TariffPaymentMode NVARCHAR(100),
@ServicePaymentMode NVARCHAR(100),
@Id BIGINT,
@Remarks NVARCHAR(100),
@UserId  BIGINT,
@DateChangeFlag NVARCHAR(100)
)
AS
BEGIN
 ---
 DECLARE @BookingLevel NVARCHAR(100),@PROPERTYID BIGINT,@RoomId BIGINT,@Count BIGINT;
 
 SELECT @BookingLevel=BookingLevel FROM WRBHBBooking WHERE Id=@BookingId
 
 --drop table #BookingData
 --drop table #BookingPrevious
 --drop table #BookingSplit
 
 IF @DateChangeFlag='1'
 BEGIN
	 CREATE TABLE #BookingData(BookingId BIGINT,CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),RoomId BIGINT,
	 ApartmentId BIGINT,BedId BIGINT)
	 
	 CREATE TABLE #BookingPrevious(BookingId BIGINT,CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),RoomId BIGINT,
	 ApartmentId BIGINT,BedId BIGINT)
	 
	 CREATE TABLE #BookingSplit(BookingId BIGINT,CheckInDate NVARCHAR(100),CheckOutDate NVARCHAR(100),RoomId BIGINT,
	 ApartmentId BIGINT,BedId BIGINT,CurrentDate NVARCHAR(100))
	 
	 DECLARE @Tariff DECIMAL(27,2),@ChkInDate NVARCHAR(100),@ChkOutDate NVARCHAR(100);
	 DECLARE @DateDiff int,@i BIGINT,@HR NVARCHAR(100),@NoOfDays INT,
	 @RoomType NVARCHAR(100),@BedId BIGINT,@ApartmentId BIGINT,@BookingId1 BIGINT,@RoomId1 BIGINT,
	 @ExpectedChkInTime NVARCHAR(100),@CHeckOutTime NVARCHAR(100);
	 --select @BookingLevel
	 IF @BookingLevel='Room'
	 BEGIN  
		SELECT @RoomId=RoomId FROM WRBHBBookingPropertyAssingedGuest
		WHERE  Id=@Id 
		IF @RoomId!=0
		BEGIN			
			SELECT @ExpectedChkInTime=ExpectChkInTime+' '+AMPM,@CHeckOutTime=' 11:59:00 AM',
			@ChkOutDate=CONVERT(DATE,@CheckOutDT,103),@ChkInDate=CONVERT(DATE,@CheckInDT,103) 
			FROM WRBHBBookingPropertyAssingedGuest WHERE Id=@Id
			
			--ROOM LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)            
            AND R.IsActive=1 AND R.IsDeleted=0
          
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
			
			
			--BED LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId 
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId 
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId  AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId 
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND  
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)  
			AND R.IsActive=1 AND R.IsDeleted=0
		    
		    --APARTMENT LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId AND PR.Id=@RoomId 
			WHERE  
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId AND PR.Id=@RoomId 
			WHERE
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId AND PR.Id=@RoomId 
			WHERE  
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
		    
			INSERT INTO #BookingPrevious(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CheckInDate,CheckOutDate,R.RoomId,0,0 FROM #BookingData R
			WHERE  R.BookingId NOT IN (SELECT b.Id FROM WRBHBBooking B
			JOIN WRBHBCheckInHdr CH ON CH.BookingId=B.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
			JOIN WRBHBChechkOutHdr CO ON CO.ChkInHdrId=CH.Id AND CO.IsActive=1 AND CO.IsDeleted=0
			WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.CancelStatus!='Canceled')
			
			DELETE FROM #BookingPrevious where BookingId=@BookingId
			
			SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
			@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
			FROM #BookingPrevious
			 WHILE (@NoOfDays>0)
				BEGIN										
					INSERT INTO #BookingSplit(BookingId,CheckInDate,CheckOutDate,CurrentDate,RoomId,ApartmentId,BedId)
					SELECT @BookingId1,@ChkInDate,@ChkOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),
					@RoomId1,@ApartmentId,@BedId
					SET @NoOfDays=@NoOfDays-1 
					SET @i=@i+1
					IF @NoOfDays=0
					BEGIN	
						DELETE FROM #BookingPrevious WHERE BookingId=@BookingId1 
							
						SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
						@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
						@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
						FROM #BookingPrevious			
					END		
			   END
			   SELECT @Count=COUNT(*) FROM #BookingSplit
			   WHERE CONVERT(DATE,CurrentDate,103) BETWEEN CONVERT(DATE,@CheckInDT,103)
			   AND CONVERT(DATE,@CheckOutDT,103)
		END
		ELSE
		BEGIN
			SELECT @Count=0
		END			
	 END
	 IF @BookingLevel='Bed'
	 BEGIN  
		SELECT @RoomId=RoomId,@BedId=BedId FROM WRBHBBedBookingPropertyAssingedGuest
		WHERE  Id=@Id
		SELECT @ExpectedChkInTime=ExpectChkInTime+' '+AMPM,@CHeckOutTime=' 11:59:00 AM',
			@ChkOutDate=CONVERT(DATE,@CheckOutDT,103),@ChkInDate=CONVERT(DATE,@CheckInDT,103) 
			FROM WRBHBBookingPropertyAssingedGuest WHERE Id=@Id
		IF @BedId!=0
		BEGIN		
			--ROOM LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,PB.Id 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'			
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=R.RoomId AND PB.Id=@BedId
			WHERE R.RoomId=@RoomId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)            
            AND R.IsActive=1 AND R.IsDeleted=0
          
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,PB.Id 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=R.RoomId
			WHERE R.RoomId=@RoomId AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,PB.Id 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=R.RoomId
			WHERE R.RoomId=@RoomId AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
			
			
			--BED LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId 
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND BedId=@BedId AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND BedId=@BedId AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,0,R.BedId 
			FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			WHERE RoomId=@RoomId AND BedId=@BedId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)  
			AND R.IsActive=1 AND R.IsDeleted=0
		    
		    --APARTMENT LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,PB.Id 
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=PR.Id AND PB.Id=@BedId
			WHERE 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,PB.Id 
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=PR.Id AND PB.Id=@BedId
			WHERE 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,PB.Id
			FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId
			JOIN dbo.WRBHBPropertyRoomBeds PB WITH(NOLOCK) ON PB.RoomId=PR.Id AND PB.Id=@BedId
			WHERE  
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
			
			
		    
			INSERT INTO #BookingPrevious(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CheckInDate,CheckOutDate,R.RoomId,0,0 FROM #BookingData R
			WHERE  R.BookingId NOT IN (SELECT b.Id FROM WRBHBBooking B
			JOIN WRBHBCheckInHdr CH ON CH.BookingId=B.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
			JOIN WRBHBChechkOutHdr CO ON CO.ChkInHdrId=CH.Id AND CO.IsActive=1 AND CO.IsDeleted=0
			WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.CancelStatus!='Canceled')
			
			
			DELETE FROM #BookingPrevious where BookingId=@BookingId
			
			
			SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
			@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
			FROM #BookingPrevious
			 WHILE (@NoOfDays>0)
				BEGIN										
					INSERT INTO #BookingSplit(BookingId,CheckInDate,CheckOutDate,CurrentDate,RoomId,ApartmentId,BedId)
					SELECT @BookingId1,@ChkInDate,@ChkOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),
					@RoomId1,@ApartmentId,@BedId
					SET @NoOfDays=@NoOfDays-1 
					SET @i=@i+1
					IF @NoOfDays=0
					BEGIN	
						DELETE FROM #BookingPrevious WHERE BookingId=@BookingId1 
							
						SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
						@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
						@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
						FROM #BookingPrevious			
					END		
			   END
			   SELECT @Count=COUNT(*) FROM #BookingSplit
			   WHERE CONVERT(DATE,CurrentDate,103) BETWEEN CONVERT(DATE,@CheckInDT,103)
			   AND CONVERT(DATE,@CheckOutDT,103)
		END
		ELSE
		BEGIN
			SELECT @Count=0
		END		
	 END
	 IF @BookingLevel='Apartment'
	 BEGIN 		 
		SELECT @ApartmentId=G.ApartmentId FROM WRBHBApartmentBookingPropertyAssingedGuest G
		JOIN dbo.WRBHBPropertyRooms R WITH(NOLOCK) ON R.ApartmentId=G.ApartmentId  
		WHERE  G.Id=@Id 
		
		SELECT @ExpectedChkInTime=ExpectChkInTime+' '+AMPM,@CHeckOutTime=' 11:59:00 AM',
			@ChkOutDate=CONVERT(DATE,@CheckOutDT,103),@ChkInDate=CONVERT(DATE,@CheckInDT,103) 
			FROM WRBHBBookingPropertyAssingedGuest WHERE Id=@Id
		IF @ApartmentId!=0
		BEGIN
		
			--ROOM LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)            
            AND R.IsActive=1 AND R.IsDeleted=0
          
         
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId AND
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,0 
			FROM WRBHBBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId  AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
			
			
			--BED LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,R.BedId FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId AND
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,R.BedId FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId  AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			R.RoomId,A.Id,R.BedId FROM WRBHBBedBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN dbo.WRBHBPropertyApartment A WITH(NOLOCK) ON  R.BookingPropertyId=A.PropertyId 
			AND R.ApartmentId=A.Id AND A.IsActive=1 AND B.IsDeleted=0
		    JOIN WRBHBPropertyRooms AR ON A.Id=AR.ApartmentId AND AR.IsActive=1 AND AR.IsDeleted=0 
			WHERE R.RoomId=AR.Id AND R.ApartmentId=@ApartmentId AND  
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME)  
			AND R.IsActive=1 AND R.IsDeleted=0
		    
		    --APARTMENT LEVEL
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId 
			WHERE R.ApartmentId=@ApartmentId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId 
			WHERE R.ApartmentId=@ApartmentId AND 
			CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) BETWEEN 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) AND R.IsActive=1 AND R.IsDeleted=0
			AND R.BookingId NOT IN (SELECT BookingId FROM #BookingData)
			
			INSERT INTO #BookingData(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CONVERT(NVARCHAR,ChkInDt,103),CONVERT(NVARCHAR,ChkOutDt,103),
			PR.Id,R.ApartmentId,0 FROM WRBHBApartmentBookingPropertyAssingedGuest R
			JOIN WRBHBBooking B ON R.BookingId=B.Id AND ISNULL(B.CancelStatus,'')!='Canceled'
			JOIN WRBHBPropertyRooms PR WITH(NOLOCK) ON PR.ApartmentId=R.ApartmentId 
			WHERE R.ApartmentId=@ApartmentId AND 
			CAST(CAST(R.ChkInDt AS NVARCHAR)+' '+R.ExpectChkInTime+' '+R.AMPM as DATETIME) < 
            CAST(CAST(@ChkInDate AS NVARCHAR)+' '+@ExpectedChkInTime as DATETIME) AND
            CAST(CAST(R.ChkOutDt AS NVARCHAR)+' '+@CHeckOutTime as DATETIME) >
            CAST(@ChkOutDate+@CHeckOutTime AS DATETIME) 
			AND R.IsActive=1 AND R.IsDeleted=0
		    
			INSERT INTO #BookingPrevious(BookingId,CheckInDate,CheckOutDate,RoomId,ApartmentId,BedId)
			SELECT R.BookingId,CheckInDate,CheckOutDate,R.RoomId,0,0 FROM #BookingData R
			WHERE  R.BookingId NOT IN (SELECT b.Id FROM WRBHBBooking B
			JOIN WRBHBCheckInHdr CH ON CH.BookingId=B.Id AND CH.IsActive=1 AND CH.IsDeleted=0 
			JOIN WRBHBChechkOutHdr CO ON CO.ChkInHdrId=CH.Id AND CO.IsActive=1 AND CO.IsDeleted=0
			WHERE B.IsActive=1 AND B.IsDeleted=0 AND B.CancelStatus!='Canceled')
			
			DELETE FROM #BookingPrevious where BookingId=@BookingId
			
			SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
			@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
			@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
			FROM #BookingPrevious
			 WHILE (@NoOfDays>0)
				BEGIN										
					INSERT INTO #BookingSplit(BookingId,CheckInDate,CheckOutDate,CurrentDate,RoomId,ApartmentId,BedId)
					SELECT @BookingId1,@ChkInDate,@ChkOutDate,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,@ChkInDate,103)),103),
					@RoomId1,@ApartmentId,@BedId
					SET @NoOfDays=@NoOfDays-1 
					SET @i=@i+1
					IF @NoOfDays=0
					BEGIN	
						DELETE FROM #BookingPrevious WHERE BookingId=@BookingId1 
							
						SELECT TOP 1 @ChkInDate=CheckInDate,@ChkOutDate=CheckOutDate,
						@NoOfDays=DATEDIFF(day, CONVERT(DATE,CheckInDate,103), CONVERT(DATE,CheckOutDate,103))+1,
						@BookingId1=BookingId,@BedId=BedId,@ApartmentId=ApartmentId,@RoomId1=RoomId,@i=0
						FROM #BookingPrevious			
					END		
			   END
			   SELECT @Count=COUNT(*) FROM #BookingSplit
			   WHERE CONVERT(DATE,CurrentDate,103) BETWEEN CONVERT(DATE,@CheckInDT,103)
			   AND CONVERT(DATE,@CheckOutDT,103) 
		END
		ELSE
		BEGIN
			SELECT @Count=0
		END	
	 END 
 END
 ELSE
 BEGIN
 SET @Count=0 
 END
 IF @Count!=0
 BEGIN 
	SELECT 'Date Not Available',@Id,@FirstName
 END
 ELSE
 BEGIN
	SELECT 'Date Available',@Id,@FirstName
 END	
END