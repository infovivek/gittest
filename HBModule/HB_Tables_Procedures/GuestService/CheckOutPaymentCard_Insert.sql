SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCard_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCard_Insert]
GO
/*=============================================
Author Name  : shameem
Modified Date : 23/06/14 
Section  	 : Guest checkout 
Purpose  	 : Payment Card
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCard_Insert](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@CardDetails NVARCHAR(100),@CCBrand NVARCHAR(100),
@NameoftheCard NVARCHAR(100),@CreditCardNo NVARCHAR(100),@ExpiryOn NVARCHAR(100),
@ROC NVARCHAR(100),@SOCBatchCloseNo NVARCHAR(100),@AmountSwipedFor NVARCHAR(100),
@CreatedBy BIGINT,@ExpiryMonth int,@ExpiryYear int,@OutStanding decimal(27,2))


AS
BEGIN
DECLARE @Id INT;
DECLARE @IntermediateFlag NVARCHAR(100)
SET @IntermediateFlag = (SELECT IntermediateFlag FROM WRBHBChechkOutHdr WHERE Id = @ChkOutHdrId)

IF @IntermediateFlag = '1'
BEGIN
	-- INSERT
	INSERT INTO WRBHBChechkOutPaymentCard(ChkOutHdrId,Payment,PayeeName,Address,
	AmountPaid,PaymentMode,CardDetails,CCBrand,NameoftheCard,CreditCardNo,ExpiryOn,
	ROC,SOCBatchCloseNo,AmountSwipedFor,ExpiryMonth,ExpiryYear,OutStanding,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,IsDeleted,RowId)


	VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@PaymentMode,
	@CardDetails,@CCBrand,@NameoftheCard,@CreditCardNo,@ExpiryOn,@ROC,
	@SOCBatchCloseNo,@AmountSwipedFor,@ExpiryMonth,@ExpiryYear,@OutStanding,@CreatedBy,
	GETDATE(),@CreatedBy,GETDATE(),0,0,NEWID())

	SET @Id=@@IDENTITY;
	SELECT  Id,RowId FROM WRBHBChechkOutPaymentCard WHERE Id=@Id;
END
ELSE
BEGIN
-- INSERT
	INSERT INTO WRBHBChechkOutPaymentCard(ChkOutHdrId,Payment,PayeeName,Address,
	AmountPaid,PaymentMode,CardDetails,CCBrand,NameoftheCard,CreditCardNo,ExpiryOn,
	ROC,SOCBatchCloseNo,AmountSwipedFor,ExpiryMonth,ExpiryYear,OutStanding,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,IsDeleted,RowId)


	VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@PaymentMode,
	@CardDetails,@CCBrand,@NameoftheCard,@CreditCardNo,@ExpiryOn,@ROC,
	@SOCBatchCloseNo,@AmountSwipedFor,@ExpiryMonth,@ExpiryYear,@OutStanding,@CreatedBy,
	GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

	SET @Id=@@IDENTITY;
	SELECT  Id,RowId FROM WRBHBChechkOutPaymentCard WHERE Id=@Id;
END

END
GO