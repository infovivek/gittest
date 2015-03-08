SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckInRollback_insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInRollback_insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 22/05/2014 
Section  	 : Guest Service
Purpose  	 : Checkin rollback
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_CheckInRollback_insert](@RoomId BIGINT,@PropertyId BIGINT=NULL,
@BookingId INT=NULL,@GuestId INT=NULL,
@Chkindate NVARCHAR(100)=NULL,@ChkoutDate NVARCHAR(100),
@GuestName NVARCHAR(100)=NULL,@Property NVARCHAR(MAX)=NULL,@BookingCode NVARCHAR(100)=NULL,
@CreatedBy INT,@ApartmentId INT=NULL,@BedId INT=NULL,@Type NVARCHAR(100),
@BookingLevel NVARCHAR(100),@ChangedStatus NVARCHAR(100),@CheckInHdrId INT=NULL,
@Remarks NVARCHAR(MAX)=NULL)

AS
BEGIN
DECLARE @InsId INT;
INSERT INTO WRBHBCheckInRollback(RoomId,PropertyId,BookingId,
GuestId,Chkindate,ChkoutDate,GuestName,Property,BookingCode,
ApartmentId,BedId,CheckInHdrId,Type,BookingLevel,ChangedStatus,Remarks,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@RoomId,@PropertyId,@BookingId,@GuestId,@Chkindate,@ChkoutDate,
@GuestName,@Property,@BookingCode,@ApartmentId,@BedId,@CheckInHdrId,@Type,
@BookingLevel,@ChangedStatus,@Remarks,@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID())

SET @InsId=@@IDENTITY;
SELECT Id,RowId FROM WRBHBCheckInRollback WHERE Id=@InsId;

-- Booking table update
 UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'Booked' ,
 CheckInHdrId = (SELECT Id  FROM WRBHBCheckInHdr WHERE Id=@CheckInHdrId)
 WHERE BookingId=@BookingId and IsActive = 1 AND IsDeleted = 0 AND
 RoomCaptured=(SELECT TOP 1 RoomCaptured from WRBHBBookingPropertyAssingedGuest
 WHERE BookingId=@BookingId and GuestId=@GuestId AND IsActive= 1 and IsDeleted = 0 );
 
 
 UPDATE WRBHBBedBookingPropertyAssingedGuest SET CurrentStatus = 'Booked' 
 WHERE BookingId=@BookingId and  BedId =@BedId AND --GuestId = @GuestId
 IsActive= 1 and IsDeleted = 0;
 
 UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET CurrentStatus = 'Booked' 
 WHERE BookingId=@BookingId and  ApartmentId =@ApartmentId AND --GuestId=@GuestId and
 IsActive= 1 and IsDeleted = 0;
 
 ---- Check in table update
 UPDATE WRBHBCheckInHdr SET IsActive = 0 WHERE Id = @CheckInHdrId
 
 -- KOT AND LAUNDRY
-- UPDATE WRBHBKOTDtls SET IsActive WHERE HdrDate = CONVERT(Date,@ChkOutSerDate,103) AND  
--CheckInId=@ChkInHdrId AND PropertyId = @PropertyId AND  IsActive =1 and IsDeleted =0



UPDATE WRBHBNewKOTEntryHdr SET IsActive = 0 WHERE  GuestId =@GuestId AND
BookingId=@BookingId AND PropertyId=@PropertyId AND CheckInId=@CheckInHdrId AND IsActive =1 and IsDeleted =0
UPDATE WRBHBLaundrServiceHdr SET IsActive = 0  WHERE  GuestId =@GuestId AND
BookingId=@BookingId AND PropertyId=@PropertyId AND CheckInId=@CheckInHdrId AND IsActive =1 and IsDeleted =0
 

END

GO