
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ExterCheckOutHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ExterCheckOutHdr_Insert]
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
CREATE PROCEDURE [dbo].[SP_ExterCheckOutHdr_Insert](
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
@BTC nvarchar(100),@PropertyType nvarchar(100),@STAgreedAmount decimal(27,2),@LTAgreedAmount decimal(27,2),
@STRackAmount decimal(27,2),@LTRackAmount decimal(27,2),@Status nvarchar(100),@CheckOutDate nvarchar(100),
@CheckInDate nvarchar(100),@PrintInvoice bit,@InVoiceNo nvarchar(100),@LTTaxPer DECIMAL(27,2),@STTaxPer DECIMAL(27,2),
@VATPer decimal(27,2),@RestaurantSTPer decimal(27,2),@BusinessSupportST decimal(27,2),@ClientId int,@CityId int,
@BillFromDate NVARCHAR(100),@BillEndDate NVARCHAR(100))
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



IF @PropertyType ='External Property'
BEGIN
IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType ='External Property' and PrintInvoice = 1 and MONTH(CreatedDate)=MONTH(GETDATE()) AND
		YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
				YEAR(CreatedDate)=YEAR(GETDATE()) AND InvoiceNo!='' and PrintInvoice = 1 and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='HBE/1';
			END
	END
	--ELSE
	----BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT  NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
		YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				set  @InVoiceNo=(Select Top 1 SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
				YEAR(CreatedDate)=YEAR(GETDATE()) AND InvoiceNo!=''and InvoiceNo!='0'
				ORDER BY Id DESC);
			END
			ELSE
				BEGIN
				select 'r'
				SELECT @InVoiceNo='HBE/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
		YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
				YEAR(CreatedDate)=YEAR(GETDATE()) AND InvoiceNo!=''and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='HBE/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
END

 

--declare @InVoiceNo nvarchar(100)


select @InVoiceNo
 
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
BTC,PropertyType,STAgreedAmount,LTAgreedAmount,STRackAmount,LTRackAmount,Status ,
CheckInDate,CheckOutDate ,InVoiceNo,Flag,PrintInvoice ,PaymentStatus,ServiceTaxPer,LuxuryTaxPer,ServiceEntryFlag,VATPer,
RestaurantSTPer,BusinessSupportST,ClientId,CityId,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice)

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
@BTC,@PropertyType,@STAgreedAmount,@LTAgreedAmount,@STRackAmount,@LTRackAmount,@Status,
@CheckInDate,@CheckOutDate,@InVoiceNo,0,@PrintInvoice,'UnPaid',@STTaxPer,@LTTaxPer,0,
@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,@BillFromDate,@BillEndDate,'',0,0)

SET @InsId=@@IDENTITY;
SELECT  Id ,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;

 UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
 CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE Id=@InsId)
 where BookingId=@BookingId and 
 RoomCaptured=(select RoomCaptured from WRBHBBookingPropertyAssingedGuest
 where BookingId=@BookingId and GuestId=@GuestId);
 
 IF @Direct = 'Direct'
 BEGIN
	UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,Flag = 1
	WHERE Id = @InsId and PropertyType =  'External Property' 
	
	UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,Flag = 1
	WHERE Id = @InsId and PropertyType =  'Managed G H' 
 END

END

GO
 

