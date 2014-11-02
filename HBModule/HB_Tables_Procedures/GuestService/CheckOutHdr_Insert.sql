
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutHdr_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 08/05/14 
Section  	 : Guest Service
Purpose  	 : Checkout (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutHdr_Insert](
@CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(100),@Stay NVARCHAR(100),
@Type NVARCHAR(100),@BookingLevel NVARCHAR(100),@BillDate NVARCHAR(100),@ClientName NVARCHAR(100),
@Property NVARCHAR(100),@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT,@Name NVARCHAR(100),@ChkOutTariffExtraType NVARCHAR(100),
@CheckOutTariffExtraDays INT,@ChkOutTariffExtraAmount DECIMAL(27,2),@ChkInHdrId INT,@NoOfDays INT,@RoomId INT,
@CheckInType NVARCHAR(100),@ApartmentNo NVARCHAR(100),@BedNo NVARCHAR(100),@BedId INT,@ApartmentId INT,
@PropertyId int,@GuestId int,@BookingId int,@StateId int,@Direct nvarchar(100),
@BTC nvarchar(100),@PropertyType nvarchar(100),@Status nvarchar(100),@STAgreedAmount decimal(27,2),
@LTAgreedAmount decimal(27,2),@STRackAmount decimal(27,2),@LTRackAmount decimal(27,2),@CheckOutDate nvarchar(100),
@CheckInDate nvarchar(100),@InVoiceNo nvarchar(100),@LTTaxPer DECIMAL(27,2),@STTaxPer DECIMAL(27,2),
@VATPer decimal(27,2),@RestaurantSTPer decimal(27,2),@BusinessSupportST decimal(27,2),@ClientId int,@CityId int,
@ServiceChargeChk int,@BillFromDate NVARCHAR(100),@BillEndDate NVARCHAR(100))

AS
BEGIN
DECLARE @InsId INT,@Cnt INT,@Cnt1 INT,@SCode INT;

SET @Cnt=(SELECT COUNT(*) FROM WRBHBChechkOutHdr);
IF @Cnt=0 
 BEGIN 
  SET @CheckOutNo=1;
 END
ELSE 
 BEGIN
  SET @CheckOutNo=(SELECT TOP 1 CAST(CheckoutNo AS INT)+1 
  FROM WRBHBChechkOutHdr ORDER BY Id DESC);
 END
 UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
 where BookingId=@BookingId and RoomId = @RoomId
 --RoomCaptured=(select RoomCaptured from WRBHBBookingPropertyAssingedGuest
 --where BookingId=@BookingId and GuestId=@GuestId);
 
 declare @tempproperty nvarchar(100),@tempinvoiceno nvarchar(100);
 declare @invoice1 nvarchar(100),@Length BIGINT;
 --declare @Property nvarchar(3),@InVoiceNo NVARCHAR(100);
 set @Property=(select (PropertyName) from WRBHBProperty 
 where Id = @PropertyId and IsActive = 1 and IsDeleted = 0);
 set @tempinvoiceno = (select top 1 InVoiceNo from WRBHBChechkOutHdr 
 where PropertyType ='Internal Property' and  PropertyId = @PropertyId 
 order by Id desc)
 --select @Property,@tempinvoiceno
 if ISNULL(@tempinvoiceno , '' )= ''
 begin
  set @InVoiceNo = SUBSTRING(upper(@Property),0,4)+'/'+'01'
 end
 else
  begin
   set @InVoiceNo = 
   SUBSTRING(@tempinvoiceno,0,5)+
   CAST(SUBSTRING(@tempinvoiceno,5,9)+1 AS VARCHAR); 
  -- CAST(CAST(SUBSTRING(@tempinvoiceno,6,LEN(@tempinvoiceno)) AS INT) + 1    AS VARCHAR); 
 end

 
 
 -- INSERT
INSERT INTO WRBHBChechkOutHdr(CheckOutNo,GuestName,Stay,Type,BookingLevel,
BillDate,ClientName,Property,ChkOutTariffTotal,ChkOutTariffAdays,
ChkOutTariffDiscount,ChkOutTariffLT,ChkOutTariffST1,ChkOutTariffST2,
ChkOutTariffSC,ChkOutTariffST3,ChkOutTariffCess,ChkOutTariffHECess,
ChkOutTariffNetAmount,ChkOutTariffReferance,ChkOutTariffExtraType,
ChkOutTariffExtraDays,ChkOutTariffExtraAmount,ChkInHdrId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Name,NoOfDays,
RoomId,CheckInType,ApartmentNo,BedNo,BedId,ApartmentId,PropertyId,GuestId,
BookingId,StateId,Direct ,
BTC,PropertyType,Status,STAgreedAmount,LTAgreedAmount,STRackAmount,LTRackAmount,CheckInDate,CheckOutDate,
InVoiceNo,Flag,PrintInvoice ,PaymentStatus,ServiceTaxPer,LuxuryTaxPer,ServiceEntryFlag,VATPer,
RestaurantSTPer,BusinessSupportST,ClientId,CityId,
ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice)

VALUES
(@CheckOutNo,@GuestName,@Stay,@Type,@BookingLevel,@BillDate,
@ClientName,@Property,@ChkOutTariffTotal,@ChkOutTariffAdays,
@ChkOutTariffDiscount,@ChkOutTariffLT,@ChkOutTariffST1,
@ChkOutTariffST2,@ChkOutTariffSC,@ChkOutTariffST3,
@ChkOutTariffCess,@ChkOutTariffHECess ,@ChkOutTariffNetAmount,
@ChkOutTariffReferance,@ChkOutTariffExtraType,
@CheckOutTariffExtraDays,@ChkOutTariffExtraAmount,@ChkInHdrId,
@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID(),@Name,@NoOfDays,
@RoomId,@CheckInType,@ApartmentNo,@BedNo,@BedId,@ApartmentId,
@PropertyId,@GuestId,@BookingId,@StateId,@Direct ,
@BTC,@PropertyType ,@Status,@STAgreedAmount,@LTAgreedAmount,@STRackAmount,@LTRackAmount,
@CheckInDate,@CheckOutDate,@InVoiceNo,0,0,'UnPaid',@STTaxPer,@LTTaxPer,0,
@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,
@ServiceChargeChk,@BillFromDate,@BillEndDate,'',0,0)

SET @InsId=@@IDENTITY;
SELECT  Id,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;

 UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
 CheckOutHdrId = @InsId
 WHERE BookingId=@BookingId and 
 RoomCaptured=(SELECT TOP 1 RoomCaptured FROM WRBHBBookingPropertyAssingedGuest
 WHERE BookingId=@BookingId and GuestId=@GuestId
 ORDER BY Id ASC);
 
 UPDATE WRBHBBedBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
 WHERE BookingId=@BookingId and  BedId =@BedId AND -- GuestId=@GuestId and
 IsActive= 1 and IsDeleted = 0;
 
 UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
 WHERE BookingId=@BookingId and  ApartmentId =@ApartmentId AND --GuestId=@GuestId and
 IsActive= 1 and IsDeleted = 0;
 
END

GO


 
 
 