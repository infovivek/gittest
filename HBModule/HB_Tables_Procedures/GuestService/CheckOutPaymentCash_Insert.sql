
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCash_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCash_Insert]
GO
/*=============================================
Author Name  : shameem
Modified Date : 23/06/14 
Section  	 : Guest checkout 
Purpose  	 : Payment Cash
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCash_Insert](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@CashReceivedOn NVARCHAR(100),@CashReceivedBy NVARCHAR(100),
@CreatedBy BIGINT,@OutStanding decimal(27,2))

AS
BEGIN
DECLARE @Id INT;
 -- INSERT
INSERT INTO WRBHBChechkOutPaymentCash(ChkOutHdrId,Payment,PayeeName,Address,PaymentMode,
AmountPaid,CashReceivedOn,CashReceivedBy,OutStanding,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@PaymentMode,@AmountPaid,@CashReceivedOn,
@CashReceivedBy,@OutStanding,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

--UPDATE WRBHBChechkOutHdr SET AmountPaid=OutStanding

SET @Id=@@IDENTITY;
SELECT  Id,RowId FROM WRBHBChechkOutPaymentCash WHERE Id=@Id;
END
GO