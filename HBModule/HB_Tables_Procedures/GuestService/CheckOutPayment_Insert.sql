SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPayment_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPayment_Insert]
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
CREATE PROCEDURE [dbo].[SP_CheckOutPayment_Insert](
@ChkOutHdrId BIGINT,@PayeeName NVARCHAR(100),
@Address NVARCHAR(100),@SettlementStatus NVARCHAR(100),
@AmountPaid DECIMAL(27,2),@PaymentMode NVARCHAR(100),@Payment NVARCHAR(100),
@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;
-- INSERT
INSERT INTO WRBHBChechkOutPayment(ChkOutHdrId,PayeeName,Address,
SettlementStatus,AmountPaid,PaymentMode,Payment,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)
VALUES(@ChkOutHdrId,@PayeeName,@Address,@SettlementStatus,@AmountPaid,
@PaymentMode,@Payment,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())


SET @Id=@@IDENTITY;
SELECT ChkOutHdrId as Id,RowId FROM WRBHBChechkOutPayment WHERE Id =@Id
END
GO