
GO
/****** Object:  StoredProcedure [dbo].[SP_ExterInterCheckOutHdr_Insert]    Script Date: 11/14/2014 15:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
ALTER PROCEDURE [dbo].[SP_ExterInterCheckOutHdr_Insert](
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

DECLARE @PIInvoice NVARCHAR(100);
DECLARE @invoice1 NVARCHAR(100),@Length BIGINT;

IF @Intermediate = 'Intermediate'
BEGIN
IF @PropertyType ='External Property'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE  PIInvoice!=''  and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
	--IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
	--	WHERE PropertyType ='External Property' and PrintInvoice = 1 and MONTH(CreatedDate)=MONTH(GETDATE()) AND
	--	YEAR(CreatedDate)=YEAR(GETDATE()) AND ISNULL(InVoiceNo,'') != '')
	--		BEGIN
	--			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
	--			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
	--			FROM WRBHBChechkOutHdr
	--			WHERE PropertyType ='External Property' and MONTH(CreatedDate)=MONTH(GETDATE()) AND
	--			YEAR(CreatedDate)=YEAR(GETDATE()) AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
	--			ORDER BY Id DESC;
	--		END
	--		ELSE
	--			BEGIN
	--			SELECT @InVoiceNo='EXT/1';
	--		END
	--END
	
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') and PrintInvoice = 1  AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP')
				 AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE  PIInvoice!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!=''  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE  
			--	MONTH(CreatedDate)=MONTH(GETDATE()) AND YEAR(CreatedDate)=YEAR(GETDATE()) AND 
				PIInvoice!='' and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP')  AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP')
			--	 and MONTH(CreatedDate)=MONTH(GETDATE()) AND YEAR(CreatedDate)=YEAR(GETDATE()) 
				AND InvoiceNo!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
END
IF @PropertyType ='Managed G H'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!=''  and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') and PrintInvoice = 1  AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP')  AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	
	IF @Direct = 'Direct'  
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') and PrintInvoice = 1  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('Managed G H','DdP')  AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='MGH/1';
		END
	END
	
	
	
	
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP')  AND InvoiceNo!=''  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!='' and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP')  AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP')  AND InvoiceNo!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	
END
IF @PropertyType ='MMT'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE  ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!=''  and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') and PrintInvoice = 1  AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP')  AND InvoiceNo!=''  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE  ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!='' and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	
END

END

ELSE
BEGIN
IF @PropertyType ='External Property'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') and PrintInvoice = 1 AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and PrintInvoice = 1 and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and  InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and  InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
 END
IF @PropertyType ='CPP'
BEGIN
	IF @BTC = 'Bill to Company (BTC)'  
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
			
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP')  AND InvoiceNo!='' and  InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
END

IF @PropertyType ='Managed G H'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE  PIInvoice!=''  and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') and PrintInvoice = 1 AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP') AND InvoiceNo!='' and PrintInvoice = 1  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE  ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE   PIInvoice!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP') AND InvoiceNo!=''  and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE   ISNULL(PIInvoice,'') != '')
			BEGIN
				SELECT TOP 1 @PIInvoice=   SUBSTRING(PIInvoice,0,4)
			  + CAST(SUBSTRING(PIInvoice,4,9)+1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE    PIInvoice!='' and PIInvoice!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @PIInvoice='PI/1';
			END
			
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H','DdP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType IN ('Managed G H','DdP')  AND InvoiceNo!='' and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='MGH/1';
			END
	END
	
END
IF @PropertyType ='MMT'
BEGIN

IF ISNULL(@PrintInvoice,0) = '1' 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') and PrintInvoice = 1 AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and PrintInvoice = 1 and InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Company (BTC)'  OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and  InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
	IF @BTC = 'Bill to Client' OR @PrintInvoice = 1 
	BEGIN
		IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType in('External Property','MMT','CPP') AND ISNULL(InVoiceNo,'') != '')
			BEGIN
				SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
				CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
				FROM WRBHBChechkOutHdr
				WHERE PropertyType in('External Property','MMT','CPP') AND InvoiceNo!='' and  InvoiceNo!='0'
				ORDER BY Id DESC;
			END
			ELSE
				BEGIN
				SELECT @InVoiceNo='EXT/1';
			END
	END
	--ELSE
	--BEGIN
	--	set @InVoiceNo='0';
	--END
END
END



 

 IF @Intermediate = 'Intermediate'
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
		@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,@BillFromDate,@BillEndDate,@Intermediate,
		1,0,0,0,@Email)

		SET @InsId=@@IDENTITY;
		SELECT  Id ,PropertyType,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;
		
		UPDATE WRBHBChechkOutHdr SET IntermediateFlag = 1 WHERE Id = @InsId;

		--UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
		--CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE Id=@InsId)
		--where BookingId=@BookingId and 
		--RoomCaptured=(select RoomCaptured from WRBHBBookingPropertyAssingedGuest
		--where BookingId=@BookingId and GuestId=@GuestId);
		
		UPDATE WRBHBCheckInHdr SET NewCheckInDate = CONVERT(DATE,@BillEndDate,103) ,ArrivalTime = '12:00:00',TimeType = 'PM'
		WHERE GuestId = @GuestId AND BookingId =@BookingId 

		IF @Direct = 'Direct'
		BEGIN
			UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,IntermediateFlag = 1,IsActive=1
			WHERE Id = @InsId and PropertyType =  'External Property' 

			UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,IntermediateFlag = 1,IsActive=1
			WHERE Id = @InsId and PropertyType IN ('Managed G H','DdP') 
		END
		IF @PrintInvoice = 1
		BEGIN
			UPDATE WRBHBChechkOutHdr set CollectVendor = 'CollectVendor'  
			WHERE Id = @InsId and PropertyType =  'External Property'
		END
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
		BTC,PropertyType,STAgreedAmount,LTAgreedAmount,STRackAmount,LTRackAmount,Status ,
		CheckInDate,CheckOutDate ,InVoiceNo,Flag,PrintInvoice ,PaymentStatus,ServiceTaxPer,LuxuryTaxPer,ServiceEntryFlag,VATPer,
		RestaurantSTPer,BusinessSupportST,ClientId,CityId,BillFromDate,BillEndDate,Intermediate,IntermediateFlag,
		PIInvoice,ServiceChargeChk,Preformainvoice,Email)

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
		@VATPer,@RestaurantSTPer,@BusinessSupportST,@ClientId,@CityId,@BillFromDate,@BillEndDate,@Intermediate,0,0,0,0,@Email)

		SET @InsId=@@IDENTITY;
		SELECT  Id ,PropertyType,RowId FROM WRBHBChechkOutHdr WHERE Id=@InsId;
		
		--UPDATE WRBHBChechkOutHdr SET IntermediateFlag = 1 WHERE Id = @InsId;

		UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
		CheckOutHdrId = (SELECT Id  FROM WRBHBChechkOutHdr WHERE Id=@InsId)
		where BookingId=@BookingId and 
		RoomCaptured=(select top 1 RoomCaptured from WRBHBBookingPropertyAssingedGuest
		where BookingId=@BookingId and GuestId=@GuestId);
		
		 
		
 
		IF @Direct = 'Direct'
		BEGIN
			UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  ,Flag = 1
			WHERE Id = @InsId and PropertyType =  'External Property' 

			UPDATE WRBHBChechkOutHdr set PaymentStatus = 'Paid'  --,Flag = 1
			WHERE Id = @InsId and PropertyType IN ('Managed G H','DdP') 
		END
		IF @PrintInvoice = 1
		BEGIN
			UPDATE WRBHBChechkOutHdr set CollectVendor = 'CollectVendor'  
			WHERE Id = @InsId and PropertyType =  'External Property'
		END
 END
 


END

