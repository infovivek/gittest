SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckInHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInHdr_Update]
GO
/*=============================================
Author Name  : Shameem
Created Date : 22/05/2014 
Section  	 : Guest Service
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
=============================================*/

CREATE PROCEDURE [dbo].[SP_CheckInHdr_Update](
@RoomId BIGINT,@PropertyId BIGINT=NULL,
@BookingId INT=NULL,@StateId INT,@GuestId INT=NULL,@ChkInGuest NVARCHAR(100),
@CheckInNo NVARCHAR(100)=NULL,@ArrivalDate NVARCHAR(100)=NULL,@ArrivalTime NVARCHAR(100)=NULL,
@ChkoutDate NVARCHAR(100),@RoomNo NVARCHAR(100)=NULL,@GuestName NVARCHAR(100)=NULL,
@ClientName NVARCHAR(100),@Property NVARCHAR(MAX)=NULL,@MobileNo NVARCHAR(100)=NULL,
@EmailId NVARCHAR(100)=NULL,@Designation NVARCHAR(100),@Nationality NVARCHAR(100)=NULL,
@IdProof NVARCHAR(100)=NULL,@ChkinAdvance DECIMAL(27,2),@Tariff DECIMAL(27,2),
@Direct BIT,@BTC BIT,@Image NVARCHAR(MAX)=NULL,@EmpCode NVARCHAR(100)=NULL,@BookingCode NVARCHAR(100)=NULL,
@CreatedBy INT,@Id INT,@TimeType NVARCHAR(100),@Occupancy NVARCHAR(100),@RackTariffSingle DECIMAL(27,2),
@RackTariffDouble DECIMAL(27,2),@ApartmentId INT=NULL,@BedId INT=NULL,@ApartmentType NVARCHAR(100),
@BedType NVARCHAR(100),@Type NVARCHAR(100),@RefGuestId nvarchar(100),@PropertyType nvarchar(100),
@CheckStatus NVARCHAR(100),@GuestImage NVARCHAR(100),@SingleMarkupAmount DECIMAL(27,2),
@DoubleMarkupAmount DECIMAL(27,2),@ClientId int,@CityId int,@ServiceCharge int)

AS
BEGIN
-- Checkin Update
UPDATE WRBHBCheckInHdr SET Image=@Image,
MobileNo=@MobileNo,GuestId=@GuestId,ChkInGuest=@ChkInGuest,
IdProof=@IdProof,ArrivalTime=@ArrivalTime,
ArrivalDate=CONVERT(Date,@ArrivalDate,103),
ChkoutDate=CONVERT(Date,@ChkoutDate,103),ClientName=@ClientName,
EmailId=@EmailId,EmpCode=@EmpCode,Direct=@Direct,BTC=@BTC,Property=@Property,
ChkinAdvance=@ChkinAdvance,Nationality=@Nationality,Designation = @Designation,
BookingId=@BookingId,ModifiedBy=@CreatedBy,
RoomNo=@RoomNo,StateId=@StateId,Tariff=@Tariff,BookingCode = @BookingCode,
ModifiedDate=GETDATE(),RoomId=@RoomId,PropertyId=CAST((@PropertyId) AS NVARCHAR(100)),TimeType=@TimeType,
Occupancy=@Occupancy ,RackTariffSingle=@RackTariffSingle,RackTariffDouble=@RackTariffDouble,
ApartmentId = @ApartmentId,BedId =@BedId,ApartmentType = @ApartmentType,
BedType = @BedType,Type=@Type,RefGuestId=@RefGuestId,PropertyType=@PropertyType,
CheckStatus=@CheckStatus,GuestImage=@GuestImage,SingleMarkupAmount=@SingleMarkupAmount,
DoubleMarkupAmount=@DoubleMarkupAmount,ClientId=@ClientId,CityId=@CityId,ServiceCharge=@ServiceCharge,
NewCheckInDate=CONVERT(Date,@ArrivalDate,103),NewCheckoutDate=CONVERT(Date,@ChkoutDate,103)
WHERE Id=@Id;

SELECT Id,RowId FROM WRBHBCheckInHdr WHERE Id=@Id;
END
GO