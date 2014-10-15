SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPayment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPayment_Update]
GO
/*=============================================
Author Name  : shameem
Created Date : 28/06/14 
Section  	 : Guest Service
Purpose  	 : Checkout Payment 
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutPayment_Update](
@ChkOutHdrId BIGINT,@PayeeName NVARCHAR(100),
@Address NVARCHAR(100),@SettlementStatus NVARCHAR(100),
@AmountPaid DECIMAL(27,2),@PaymentMode BIT,@CreatedBy BIGINT,@Id BIGINT)

AS
BEGIN
UPDATE WRBHBChechkOutPayment SET ChkOutHdrId=@ChkOutHdrId,PayeeName=@PayeeName,Address=@Address,
SettlementStatus=@SettlementStatus,AmountPaid=@AmountPaid,PaymentMode=@PaymentMode,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPayment WHERE Id=@Id;
END
GO