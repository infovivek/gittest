SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckInHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInHdr_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 22/05/2014 
Section  	 : Guest Service
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_CheckInHdr_Insert](@RoomId BIGINT,@PropertyId BIGINT=NULL,
@BookingId INT=NULL,@StateId INT,@GuestId INT=NULL,@ChkInGuest NVARCHAR(100),
@CheckInNo NVARCHAR(100)=NULL,@ArrivalDate NVARCHAR(100)=NULL,@ArrivalTime NVARCHAR(100)=NULL,
@ChkoutDate NVARCHAR(100),@RoomNo NVARCHAR(100)=NULL,@GuestName NVARCHAR(100)=NULL,
@ClientName NVARCHAR(100),@Property NVARCHAR(MAX)=NULL,@MobileNo NVARCHAR(100)=NULL,
@EmailId NVARCHAR(100)=NULL,@Designation NVARCHAR(100),@Nationality NVARCHAR(100)=NULL,
@IdProof NVARCHAR(100)=NULL,@ChkinAdvance DECIMAL(27,2),@Tariff DECIMAL(27,2),
@Direct BIT,@BTC BIT,@Image NVARCHAR(MAX)=NULL,@EmpCode NVARCHAR(100)=NULL,@BookingCode NVARCHAR(100)=NULL,
@CreatedBy INT,@TimeType NVARCHAR(100)=NULL,@Occupancy NVARCHAR(100)=NULL,@RackTariffSingle DECIMAL(27,2),
@RackTariffDouble DECIMAL(27,2)=NULL,@ApartmentId INT=NULL,@BedId INT=NULL,@ApartmentType NVARCHAR(100),
@BedType NVARCHAR(100),@Type NVARCHAR(100),@RefGuestId nvarchar(100),@PropertyType NVARCHAR(100),
@CheckStatus NVARCHAR(100),@GuestImage NVARCHAR(100),@SingleMarkupAmount DECIMAL(27,2),
@DoubleMarkupAmount DECIMAL(27,2),@ClientId int,@CityId int,@ServiceCharge int,@TariffPaymentMode NVARCHAR(100))

AS
BEGIN
DECLARE @InsId INT,@Cnt INT,@Cnt1 INT,@SBillNo INT;

--SCODE
SET @Cnt1=(SELECT COUNT(*) FROM WRBHBCheckInHdr); 
IF @Cnt1=0 BEGIN SET @CheckInNo=1;END
ELSE BEGIN
SET @CheckInNo=(SELECT TOP 1 CAST(CheckInNo AS INT)+1 AS CheckInNo 
FROM WRBHBCheckInHdr   ORDER BY Id DESC);END

--IF @Cnt=0 BEGIN SET @SCode=1;END
--ELSE BEGIN
--SET @SCode=(SELECT TOP 1 ISNULL(SCode,0)+1 AS CheckInNo FROM WrbHMSCheckInHdr 
--ORDER BY Id DESC);END
-- Room CheckIn
UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus= 'CheckIn' 
WHERE GuestId=@GuestId and BookingId=@BookingId;
---CHECKIN INSERT 
INSERT INTO WRBHBCheckInHdr(RoomId,PropertyId,BookingId,
StateId,GuestId,RefGuestId,ChkInGuest,CheckInNo,ArrivalDate,ArrivalTime,
ChkoutDate,RoomNo,GuestName,ClientName,Property,MobileNo,
EmailId,Designation,Nationality,IdProof,ChkinAdvance,Tariff,
Direct,BTC,EmpCode,BookingCode,Image,CreatedBy,TimeType,Occupancy,RackTariffSingle,
RackTariffDouble,ApartmentId,BedId,ApartmentType,BedType,Type,PropertyType,CheckStatus,
GuestImage,SingleMarkupAmount,DoubleMarkupAmount,ClientId,CityId,ServiceCharge,
NewCheckInDate,NewCheckoutDate,TariffPaymentMode,
ModifiedBy,CreatedDate,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@RoomId,CAST((@PropertyId) AS NVARCHAR(100)),@BookingId,@StateId,@GuestId,@RefGuestId,@ChkInGuest,
@CheckInNo,convert(date,@ArrivalDate,103),@ArrivalTime,
CONVERT(date,@ChkoutDate,103),@RoomNo,@GuestName,@ClientName,@Property,
@MobileNo,@EmailId,@Designation,@Nationality,@IdProof,@ChkinAdvance,@Tariff,
@Direct,@BTC,@EmpCode,@BookingCode,@Image,@CreatedBy,@TimeType,@Occupancy,@RackTariffSingle,
@RackTariffDouble,@ApartmentId,@BedId,@ApartmentType,@BedType,@Type,@PropertyType ,@CheckStatus,
@GuestImage,@SingleMarkupAmount,@DoubleMarkupAmount,@ClientId,@CityId,@ServiceCharge,
CONVERT(date,@ArrivalDate,103),CONVERT(date,@ChkoutDate,103),@TariffPaymentMode,
@CreatedBy,GETDATE(),GETDATE(),1,0,NEWID());

SET @InsId=@@IDENTITY;
---- Booking UPDATE
--UPDATE WRBHBBooking SET CheckInId=@InsId,RoomId=@RoomId,IsActive=1
--WHERE Id=@ReservationId;


SELECT Id,RowId FROM WRBHBCheckInHdr WHERE Id=@InsId;

UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckIn' ,
 CheckInHdrId = (SELECT Id  FROM WRBHBCheckInHdr WHERE Id=@InsId)
 WHERE BookingId=@BookingId and IsActive = 1 AND IsDeleted = 0 AND
 RoomCaptured=(SELECT TOP 1 RoomCaptured from WRBHBBookingPropertyAssingedGuest
 WHERE BookingId=@BookingId and GuestId=@GuestId AND IsActive= 1 and IsDeleted = 0 );
 
 
 UPDATE WRBHBBedBookingPropertyAssingedGuest SET CurrentStatus = 'CheckIn' ,
 CheckInHdrId = (SELECT Id  FROM WRBHBCheckInHdr WHERE Id=@InsId)
 WHERE BookingId=@BookingId and  BedId =@BedId AND --GuestId = @GuestId
 IsActive= 1 and IsDeleted = 0;
 
 UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET CurrentStatus = 'CheckIn' ,
 CheckInHdrId = (SELECT Id  FROM WRBHBCheckInHdr WHERE Id=@InsId)
 WHERE BookingId=@BookingId and  ApartmentId =@ApartmentId AND --GuestId=@GuestId and
 IsActive= 1 and IsDeleted = 0;

 
END




GO


