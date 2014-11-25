
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CheckoutIntermediate_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_CheckoutIntermediate_Insert]
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
CREATE PROCEDURE [dbo].[Sp_CheckoutIntermediate_Insert](
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
@Preformainvoice BIT)

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
 --UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
 --where BookingId=@BookingId and RoomId = @RoomId
 --RoomCaptured=(select RoomCaptured from WRBHBBookingPropertyAssingedGuest
 --where BookingId=@BookingId and GuestId=@GuestId);
 
 --DECLARE @tempproperty nvarchar(100),@tempinvoiceno nvarchar(100);
 --declare @invoice1 nvarchar(100),@Length BIGINT;
 ----declare @Property nvarchar(3),@InVoiceNo NVARCHAR(100);
 --set @Property=(select (PropertyName) from WRBHBProperty 
 --where Id = @PropertyId and IsActive = 1 and IsDeleted = 0);
 --set @tempinvoiceno = (select top 1 InVoiceNo from WRBHBChechkOutHdr 
 --where PropertyType ='Internal Property' and  PropertyId = @PropertyId 
 --order by Id desc)
 ----select @Property,@tempinvoiceno
 --if ISNULL(@tempinvoiceno , '' )= ''
 --begin
 -- set @InVoiceNo = SUBSTRING(upper(@Property),0,4)+'/'+'01'
 --end
 --else
 -- begin
 --  set @InVoiceNo = 
 --  SUBSTRING(@tempinvoiceno,0,5)+
 --  CAST(SUBSTRING(@tempinvoiceno,5,9)+1 AS VARCHAR); 
 -- -- CAST(CAST(SUBSTRING(@tempinvoiceno,6,LEN(@tempinvoiceno)) AS INT) + 1    AS VARCHAR); 
 --end
 
DECLARE @PIInvoice NVARCHAR(100);
DECLARE @tempproperty NVARCHAR(100),@tempinvoiceno nvarchar(100);
DECLARE @invoice1 NVARCHAR(100),@Length BIGINT;


 IF @Intermediate = 'Intermediate'
 BEGIN
  IF @Preformainvoice = 1
 BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType ='Internal Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
		YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,LEN(PIInvoice))+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType ='Internal Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
				YEAR(CreatedDate)=YEAR(GETDATE()) AND PIInvoice!=''and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
 END
 --IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
	--	WHERE PropertyType ='Internal Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
	--	YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(PIInvoice,'') != '')
	--		BEGIN
	--			SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
	--		  + CAST(SUBSTRING(PIInvoice,4,LEN(PIInvoice))+1 AS VARCHAR)
	--			FROM WRBHBChechkOutHdr
	--			WHERE PropertyType ='Internal Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
	--			YEAR(CreatedDate)=YEAR(GETDATE()) AND PIInvoice!=''and PIInvoice!='0'
	--			ORDER BY Id DESC;
	--		END
	--		ELSE
	--			BEGIN
	--			SELECT @PIInvoice='PI/1';
	--		END
		--	select @PIInvoice
			
			--DECLARE @tempproperty nvarchar(100),@tempinvoiceno nvarchar(100);
			
			--declare @invoice1 nvarchar(100),@Length BIGINT;
			--declare @Property nvarchar(3),@InVoiceNo NVARCHAR(100);
			SET @Property=(SELECT (PropertyName) FROM WRBHBProperty 
			WHERE Id = @PropertyId AND IsActive = 1 AND IsDeleted = 0);
			SET @tempinvoiceno = (SELECT TOP 1 InVoiceNo FROM WRBHBChechkOutHdr 
			WHERE PropertyType ='Internal Property' AND  PropertyId = @PropertyId 
			ORDER BY Id DESC)
			--select @Property,@tempinvoiceno
			IF ISNULL(@tempinvoiceno , '' )= ''
			BEGIN
			SET @InVoiceNo = SUBSTRING(upper(@Property),0,4)+'/'+'01'
			END
			ELSE
			BEGIN
			SET @InVoiceNo = 
			SUBSTRING(@tempinvoiceno,0,5)+
			CAST(SUBSTRING(@tempinvoiceno,5,9)+1 AS VARCHAR); 
			-- CAST(CAST(SUBSTRING(@tempinvoiceno,6,LEN(@tempinvoiceno)) AS INT) + 1    AS VARCHAR); 
			END
 END
 ELSE
 BEGIN
			
			--declare @Property nvarchar(3),@InVoiceNo NVARCHAR(100);
			SET @Property=(SELECT (PropertyName) FROM WRBHBProperty 
			WHERE Id = @PropertyId and IsActive = 1 AND IsDeleted = 0);
			SET @tempinvoiceno = (SELECT TOP 1 InVoiceNo FROM WRBHBChechkOutHdr 
			WHERE PropertyType ='Internal Property' AND  PropertyId = @PropertyId 
			ORDER BY Id DESC)
			--select @Property,@tempinvoiceno
			IF ISNULL(@tempinvoiceno , '' )= ''
			BEGIN
			SET @InVoiceNo = SUBSTRING(upper(@Property),0,4)+'/'+'01'
			END
			ELSE
			BEGIN
			SET @InVoiceNo = 
			SUBSTRING(@tempinvoiceno,0,5)+
			CAST(SUBSTRING(@tempinvoiceno,5,9)+1 AS VARCHAR); 
			-- CAST(CAST(SUBSTRING(@tempinvoiceno,6,LEN(@tempinvoiceno)) AS INT) + 1    AS VARCHAR); 
			END
 END

	
 

 

 IF @Intermediate = 'Intermediate'
 BEGIN
 IF @Preformainvoice = 1
 BEGIN
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
		ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,Preformainvoice)

		VALUES
		(@CheckOutNo,@GuestName,@Stay,@Type,@BookingLevel,@BillDate,
		@ClientName,@Property,@ChkOutTariffTotal,@ChkOutTariffAdays,
		@ChkOutTariffDiscount,@ChkOutTariffLT,@ChkOutTariffST1,
		@ChkOutTariffST2,@ChkOutTariffSC,@ChkOutTariffST3,
		@ChkOutTariffCess,@ChkOutTariffHECess ,@ChkOutTariffNetAmount,
		@ChkOutTariffReferance,@ChkOutTariffExtraType,
		@CheckOutTariffExtraDays,@ChkOutTariffExtraAmount,@ChkInHdrId,
		@CreatedBy,GETDATE(),@CreatedBy,
		GETDATE(),0,0,NEWID(),@Name,@NoOfDays,
		@RoomId,@CheckInType,@ApartmentNo,@BedNo,@BedId,@ApartmentId,
		@PropertyId,@GuestId,@BookingId,@StateId,@Direct ,
		@BTC,@PropertyType ,@Status,@STAgreedAmount,@LTAgreedAmount,@STRackAmount,@LTRackAmount,
		@CheckInDate,@CheckOutDate,@InVoiceNo,0,0,'UnPaid',@STTaxPer,@LTTaxPer,0,
		@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,
		@ServiceChargeChk,@BillFromDate,@BillEndDate,@Intermediate,0,@PIInvoice,@Preformainvoice)

		SET @InsId=@@IDENTITY;
		SELECT  Id,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;
		
		
 END
 ELSE
 BEGIN
 
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
		ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,Preformainvoice)

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
		@ServiceChargeChk,@BillFromDate,@BillEndDate,@Intermediate,1,0,0)

		SET @InsId=@@IDENTITY;
		SELECT  Id,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;
		
		UPDATE WRBHBChechkOutHdr SET IntermediateFlag = 1 WHERE Id = @InsId;
		
		
		UPDATE WRBHBCheckInHdr SET NewCheckInDate = CONVERT(DATE,@BillEndDate,103) ,ArrivalTime = '12:00:00',TimeType = 'PM'
		WHERE GuestId = @GuestId AND BookingId =@BookingId 
 END
		--INSERT INTO WRBHBChechkOutHdr(CheckOutNo,GuestName,Stay,Type,BookingLevel,
		--BillDate,ClientName,Property,ChkOutTariffTotal,ChkOutTariffAdays,
		--ChkOutTariffDiscount,ChkOutTariffLT,ChkOutTariffST1,ChkOutTariffST2,
		--ChkOutTariffSC,ChkOutTariffST3,ChkOutTariffCess,ChkOutTariffHECess,
		--ChkOutTariffNetAmount,ChkOutTariffReferance,ChkOutTariffExtraType,
		--ChkOutTariffExtraDays,ChkOutTariffExtraAmount,ChkInHdrId,
		--CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Name,NoOfDays,
		--RoomId,CheckInType,ApartmentNo,BedNo,BedId,ApartmentId,PropertyId,GuestId,
		--BookingId,StateId,Direct ,
		--BTC,PropertyType,Status,STAgreedAmount,LTAgreedAmount,STRackAmount,LTRackAmount,CheckInDate,CheckOutDate,
		--InVoiceNo,Flag,PrintInvoice ,PaymentStatus,ServiceTaxPer,LuxuryTaxPer,ServiceEntryFlag,VATPer,
		--RestaurantSTPer,BusinessSupportST,ClientId,CityId,
		--ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,Preformainvoice)

		--VALUES
		--(@CheckOutNo,@GuestName,@Stay,@Type,@BookingLevel,@BillDate,
		--@ClientName,@Property,@ChkOutTariffTotal,@ChkOutTariffAdays,
		--@ChkOutTariffDiscount,@ChkOutTariffLT,@ChkOutTariffST1,
		--@ChkOutTariffST2,@ChkOutTariffSC,@ChkOutTariffST3,
		--@ChkOutTariffCess,@ChkOutTariffHECess ,@ChkOutTariffNetAmount,
		--@ChkOutTariffReferance,@ChkOutTariffExtraType,
		--@CheckOutTariffExtraDays,@ChkOutTariffExtraAmount,@ChkInHdrId,
		--@CreatedBy,GETDATE(),@CreatedBy,
		--GETDATE(),0,0,NEWID(),@Name,@NoOfDays,
		--@RoomId,@CheckInType,@ApartmentNo,@BedNo,@BedId,@ApartmentId,
		--@PropertyId,@GuestId,@BookingId,@StateId,@Direct ,
		--@BTC,@PropertyType ,@Status,@STAgreedAmount,@LTAgreedAmount,@STRackAmount,@LTRackAmount,
		--@CheckInDate,@CheckOutDate,@InVoiceNo,0,0,'UnPaid',@STTaxPer,@LTTaxPer,0,
		--@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,
		--@ServiceChargeChk,@BillFromDate,@BillEndDate,@Intermediate,1,0,0)

		--SET @InsId=@@IDENTITY;
		--SELECT  Id,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;

		----UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
		----CheckOutHdrId = @InsId
		----WHERE BookingId=@BookingId and 
		----RoomCaptured=(SELECT TOP 1 RoomCaptured FROM WRBHBBookingPropertyAssingedGuest
		----WHERE BookingId=@BookingId and GuestId=@GuestId
		----ORDER BY Id ASC);

		----UPDATE WRBHBBedBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
		----WHERE BookingId=@BookingId and  BedId =@BedId AND -- GuestId=@GuestId and
		----IsActive= 1 and IsDeleted = 0;

		----UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' 
		----WHERE BookingId=@BookingId and  ApartmentId =@ApartmentId AND --GuestId=@GuestId and
		----IsActive= 1 and IsDeleted = 0;
		--UPDATE WRBHBChechkOutHdr SET IntermediateFlag = 1 WHERE Id = @InsId;
	--	UPDATE WRBHBCheckInHdr SET NewCheckInDate = @BillEndDate,ArrivalTime='12:00:00'  WHERE GuestId = @GuestId;
END
ELSE
BEGIN


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
		ServiceChargeChk,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,PIInvoice,Preformainvoice)

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
		@ServiceChargeChk,@BillFromDate,@BillEndDate,@Intermediate,0,0,0)

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
 

 
END

GO


 
 
 