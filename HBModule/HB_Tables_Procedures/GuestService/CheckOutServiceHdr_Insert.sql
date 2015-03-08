
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutServiceHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutServiceHdr_Insert]
GO
/*=============================================
Author Name  : Anbu
Modified Date : 21/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutServiceHdr_Insert](
@CheckOutHdrId INT,
@ChkOutServiceAmtl DECIMAL(27,2),@ChkOutServiceVat DECIMAL(27,2),
@ChkOutServiceLT DECIMAL(27,2),@ChkOutServiceST DECIMAL(27,2),
@Cess DECIMAL(27,2),@HECess DECIMAL(27,2),
@CheckOutNetAmount DECIMAL(27,2),@MiscellaneousRemarks NVARCHAR(100),
@MiscellaneousAmount DECIMAL(27,2),
@CreatedBy BIGINT,@OtherService DECIMAL(27,2))

AS
BEGIN
DECLARE @Id1 INT,@GuestName NVARCHAR(100),@PropertyType NVARCHAR(100),@Direct NVARCHAR(100),@InVoiceNo NVARCHAR(100),
@BTC NVARCHAR(100);
SET @GuestName = (SELECT GuestName FROM WRBHBChechkOutHdr WHERE Id = @CheckOutHdrId)
SET @PropertyType = (SELECT PropertyType FROM WRBHBChechkOutHdr WHERE Id = @CheckOutHdrId)
SET @Direct = (SELECT Direct FROM WRBHBChechkOutHdr WHERE Id = @CheckOutHdrId)
SET @BTC = (SELECT BTC FROM WRBHBChechkOutHdr WHERE Id = @CheckOutHdrId)





IF @PropertyType IN ('Managed G H')
BEGIN
IF @Direct = 'Direct'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('Managed G H')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='MGH/1';
		END
	END
		
	END	
	IF @BTC = 'Bill to Company (BTC)'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('Managed G H')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='MGH/1';
		END
	END
		
	END	
	IF @BTC = 'Bill to Client'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('Managed G H')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('Managed G H')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='MGH/1';
		END
	END
		
	END	
END

IF @PropertyType IN ('DdP')
BEGIN
IF @Direct = 'Direct'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('DdP')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('DdP')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='DdP/1';
		END
	END
		
	END	
	IF @BTC = 'Bill to Company (BTC)'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('DdP')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('DdP')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='DdP/1';
		END
	
	END
		
	END	
	IF @BTC = 'Bill to Client'  
	BEGIN
	IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBChechkOutHdr
		WHERE PropertyType IN ('DdP')  AND ISNULL(InVoiceNo,'') != '')
		BEGIN
			SELECT TOP 1 @InVoiceNo=SUBSTRING(InVoiceNo,0,5)+
			CAST(CAST(SUBSTRING(InVoiceNo,5,LEN(InVoiceNo)) AS INT) + 1 AS VARCHAR)
			FROM WRBHBChechkOutHdr
			WHERE PropertyType IN ('DdP')  AND InvoiceNo!=''  and InvoiceNo!='0'
			ORDER BY Id DESC;
		END
		ELSE
			BEGIN
			SELECT @InVoiceNo='DdP/1';
		END
	END
		
	END	
END






 -- INSERT
INSERT INTO WRBHBCheckOutServiceHdr(CheckOutHdrId,ChkOutServiceAmtl,
ChkOutServiceVat,ChkOutServiceLT,ChkOutServiceST,Cess,HECess,
ChkOutServiceNetAmount,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,PaymentStatus,
MiscellaneousRemarks,MiscellaneousAmount,OtherService)

VALUES
(@CheckOutHdrId,@ChkOutServiceAmtl,@ChkOutServiceVat,@ChkOutServiceLT,@ChkOutServiceST,@Cess,@HECess,
@CheckOutNetAmount,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),'UnPaid',@MiscellaneousRemarks,
@MiscellaneousAmount,@OtherService)

SET @Id1=@@IDENTITY;
SELECT CheckOutHdrId as Id,Id RowId FROM WRBHBCheckOutServiceHdr WHERE Id=@Id1;

-- this table use to bill no wise		

INSERT INTO WRBHBCheckOutDtls(CheckOutId,GuestName,BillType,BillAmount,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@CheckOutHdrId,@GuestName,'Service',@CheckOutNetAmount,@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID())

IF ISNULL(@ChkOutServiceAmtl,0) !=0
	BEGIN
	
		UPDATE WRBHBChechkOutHdr SET InVoiceNo=@InVoiceNo WHERE Id = @CheckOutHdrId AND
		PropertyType IN ('Managed G H','DdP') AND Direct='Direct'

		UPDATE WRBHBChechkOutHdr SET InVoiceNo=@InVoiceNo WHERE Id = @CheckOutHdrId AND
		PropertyType IN ('Managed G H','DdP') AND BTC='Bill to Company (BTC)'

		UPDATE WRBHBChechkOutHdr SET InVoiceNo=@InVoiceNo WHERE Id = @CheckOutHdrId AND
		PropertyType IN ('Managed G H','DdP') AND BTC='Bill to Client'
	END

END
GO
 
