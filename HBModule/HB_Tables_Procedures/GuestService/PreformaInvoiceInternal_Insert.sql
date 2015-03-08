
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PreformaInvoiceInternal_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PreformaInvoiceInternal_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 02/03/15 
Section  	 : Guest Service
Purpose  	 : Checkout (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_PreformaInvoiceInternal_Insert](
@CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(100),@Stay NVARCHAR(100),
@Type NVARCHAR(100),@BookingLevel NVARCHAR(100),@BillDate NVARCHAR(100),@ClientName NVARCHAR(100),
@Property NVARCHAR(100),@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT,@Name NVARCHAR(100),@ChkOutTariffExtraType NVARCHAR(100),
@CheckOutTariffExtraDays INT,@ChkOutTariffExtraAmount DECIMAL(27,2),@ChkInHdrId INT,@NoOfDays INT,@RoomId INT,
@CheckInType NVARCHAR(100),@ApartmentNo NVARCHAR(100),@BedNo NVARCHAR(100),@BedId INT,@ApartmentId INT,
@PropertyId INT,@GuestId INT,@BookingId INT,@StateId INT,@Direct NVARCHAR(100),
@BTC NVARCHAR(100),@PropertyType NVARCHAR(100),@Status NVARCHAR(100),@STAgreedAmount DECIMAL(27,2),
@LTAgreedAmount DECIMAL(27,2),@STRackAmount DECIMAL(27,2),@LTRackAmount DECIMAL(27,2),@CheckOutDate NVARCHAR(100),
@CheckInDate NVARCHAR(100),@InVoiceNo NVARCHAR(100),@LTTaxPer DECIMAL(27,2),@STTaxPer DECIMAL(27,2),
@VATPer DECIMAL(27,2),@RestaurantSTPer DECIMAL(27,2),@BusinessSupportST DECIMAL(27,2),@ClientId INT,@CityId INT,
@ServiceChargeChk INT,@BillFromDate NVARCHAR(100),@BillEndDate NVARCHAR(100),@Intermediate NVARCHAR(100),
@Preformainvoice BIT,@Email NVARCHAR(100),@TariffPaymentMode NVARCHAR(100),@BookingType NVARCHAR(100))

AS
BEGIN
DECLARE @InsId INT,@Cnt INT,@Cnt1 INT,@SCode INT;

--SET @Cnt=(SELECT COUNT(*) FROM WRBHBPreformaCheckOut);
--IF @Cnt=0 
-- BEGIN 
--  SET @CheckOutNo=1;
-- END
--ELSE 
-- BEGIN
--  SET @CheckOutNo=(SELECT TOP 1 CAST(CheckoutNo AS INT)+1 
--  FROM WRBHBPreformaCheckOut ORDER BY Id DESC);
-- END
 
 
DECLARE @PIInvoice NVARCHAR(100);
DECLARE @tempproperty NVARCHAR(100),@tempinvoiceno nvarchar(100);
DECLARE @invoice1 NVARCHAR(100),@Length BIGINT;



IF EXISTS (SELECT NULL FROM WRBHBPreformaCheckOut
WHERE PropertyType IN ('Internal Property','External Property','MMT','CPP') AND ISNULL(PIInvoice,'') != '')
	BEGIN
		SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
	  + CAST(SUBSTRING(PIInvoice,4,LEN(PIInvoice))+1 AS VARCHAR)
		FROM WRBHBPreformaCheckOut
		WHERE PropertyType IN ('Internal Property','External Property','MMT','CPP')
		  AND PIInvoice!=''and PIInvoice!='0'
		ORDER BY Id DESC;
	END
	ELSE
		BEGIN
		SELECT @PIInvoice='PI/1';
	END





	INSERT INTO WRBHBPreformaCheckOut(CheckOutNo,GuestName,Stay,Type,BookingLevel,
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
		ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,Preformainvoice,Email,
		TariffPaymentMode,BookingType)

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
		@CheckInDate,@CheckOutDate,@InVoiceNo,1,0,'UnPaid',@STTaxPer,@LTTaxPer,0,
		@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,
		@ServiceChargeChk,@BillFromDate,@BillEndDate,'',0,@PIInvoice,1,@Email,
		@TariffPaymentMode,@BookingType)

		SET @InsId=@@IDENTITY;
		SELECT  Id,RowId FROM WRBHBPreformaCheckOut WHERE Id=@InsId;

END

GO


 
 
 