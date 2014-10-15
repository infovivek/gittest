
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCheque_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCheque_Insert]
GO
/*=============================================
Author Name  : shameem
Modified Date : 23/06/14 
Section  	 : Guest checkout 
Purpose  	 : Payment CHEQUE
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCheque_Insert](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@ChequeNumber NVARCHAR(100),@BankName NVARCHAR(100),
@DateIssued NVARCHAR(100),@DateIssueMonth int,@DateIssueYear int ,@CreatedBy BIGINT,
@OutStanding DECIMAL(27,2))


AS
BEGIN
DECLARE @Id INT;
 -- INSERT
INSERT INTO WRBHBChechkOutPaymentCheque(ChkOutHdrId,Payment,PayeeName,Address,
AmountPaid,ChequeNumber,BankName,DateIssued,DateIssueMonth,DateIssueYear,PaymentMode,
OutStanding,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@ChequeNumber,@BankName,
@DateIssued,@DateIssueMonth,@DateIssueYear,@PaymentMode,@OutStanding,@CreatedBy,
GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())


SET @Id=@@IDENTITY;
SELECT  Id,RowId FROM WRBHBChechkOutPaymentCheque WHERE Id=@Id;
END
GO

