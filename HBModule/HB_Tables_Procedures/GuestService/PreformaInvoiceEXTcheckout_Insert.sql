
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PreformaInvoiceEXTcheckout_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_PreformaInvoiceEXTcheckout_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 04/03/15 
Section  	 : Guest Service
Purpose  	 : Checkout (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[Sp_PreformaInvoiceEXTcheckout_Insert](
@CheckOutNo NVARCHAR(100),@GuestName NVARCHAR(100),@Stay NVARCHAR(100),
@Type NVARCHAR(100),@BookingLevel NVARCHAR(100),@BillDate NVARCHAR(100),@ClientName NVARCHAR(100),
@Property NVARCHAR(100),@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT,@Name NVARCHAR(100),@ChkOutTariffExtraType NVARCHAR(100),
@CheckOutTariffExtraDays INT,@ChkOutTariffExtraAmount DECIMAL(27,2),@ChkInHdrId INT,@NoOfDays INT,@RoomId INT,
@CheckInType NVARCHAR(100),@ApartmentNo NVARCHAR(100),@BedNo NVARCHAR(100),@BedId INT,@ApartmentId INT,
@PropertyId BIGINT,@GuestId int,@BookingId int,@StateId int,@Direct nvarchar(100),
@BTC nvarchar(100),@PropertyType nvarchar(100),@STAgreedAmount decimal(27,2),@LTAgreedAmount decimal(27,2),
@STRackAmount decimal(27,2),@LTRackAmount decimal(27,2),@Status nvarchar(100),@CheckOutDate nvarchar(100),
@CheckInDate nvarchar(100),@PrintInvoice bit,@InVoiceNo nvarchar(100),@LTTaxPer DECIMAL(27,2),@STTaxPer DECIMAL(27,2),
@VATPer decimal(27,2),@RestaurantSTPer decimal(27,2),@BusinessSupportST decimal(27,2),@ClientId int,@CityId int,
@BillFromDate NVARCHAR(100),@BillEndDate NVARCHAR(100),@Intermediate NVARCHAR(100),@Email NVARCHAR(100))
AS
BEGIN
DECLARE @InsId INT,@Cnt INT,@Cnt1 INT,@SCode INT;



DECLARE @PIInvoice NVARCHAR(100);
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



 


		-- INSERT
		INSERT INTO WRBHBPreformaCheckOut(CheckOutNo,GuestName,Stay,Type,BookingLevel,
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
		RestaurantSTPer,BusinessSupportST,ClientId,CityId,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,
		ServiceChargeChk,Preformainvoice,Email)

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
		CAST((@PropertyId) AS NVARCHAR(100)),@GuestId,@BookingId,@StateId,@Direct ,
		@BTC,@PropertyType,@STAgreedAmount,@LTAgreedAmount,@STRackAmount,@LTRackAmount,@Status,
		@CheckInDate,@CheckOutDate,@InVoiceNo,0,@PrintInvoice,'UnPaid',@STTaxPer,@LTTaxPer,0,
		@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,@BillFromDate,@BillEndDate,'',
		0,@PIInvoice,0,0,@Email)

		SET @InsId=@@IDENTITY;
		SELECT  Id ,PropertyType,RowId FROM WRBHBPreformaCheckOut WHERE Id=@InsId;
		
  
 


END

