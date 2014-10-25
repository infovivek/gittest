SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCard_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCard_Update]
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
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCard_Update](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@CardDetails NVARCHAR(100),@CCBrand NVARCHAR(100),
@NameoftheCard NVARCHAR(100),@CreditCardNo NVARCHAR(100),@ExpiryOn NVARCHAR(100),
@ROC NVARCHAR(100),@SOCBatchCloseNo NVARCHAR(100),@AmountSwipedFor NVARCHAR(100),
@CreatedBy BIGINT,@ExpiryMonth int,@ExpiryYear int,@OutStanding decimal(27,2),@Id int)


AS
BEGIN

UPDATE WRBHBChechkOutPaymentCard SET
ChkOutHdrId=@ChkOutHdrId,Payment=@Payment,PayeeName=@PayeeName,
Address=@Address,AmountPaid=@AmountPaid,
PaymentMode=@PaymentMode,CardDetails=@CardDetails,CCBrand=@CCBrand,
NameoftheCard=@NameoftheCard,CreditCardNo=@CreditCardNo,ExpiryOn=@ExpiryOn,
ROC=@ROC,SOCBatchCloseNo=@SOCBatchCloseNo,AmountSwipedFor=@AmountSwipedFor,
OutStanding=@OutStanding

WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPaymentCard WHERE Id=@Id;
END
GO






