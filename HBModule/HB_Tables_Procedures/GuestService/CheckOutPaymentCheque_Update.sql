SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCheque_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCheque_Update]
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
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCheque_Update](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@ChequeNumber NVARCHAR(100),@BankName NVARCHAR(100),
@DateIssued NVARCHAR(100),@DateIssueMonth int,@DateIssueYear int ,@CreatedBy BIGINT,
@OutStanding DECIMAL(27,2),@Id int)


AS
BEGIN

UPDATE WRBHBChechkOutPaymentCheque SET
ChkOutHdrId=@ChkOutHdrId,Payment=@Payment,Address=@Address,
AmountPaid=@AmountPaid,PaymentMode=@PaymentMode,ChequeNumber=@ChequeNumber,
BankName=@BankName,DateIssued=@DateIssued,DateIssueMonth=@DateIssueMonth,
DateIssueYear=@DateIssueYear,OutStanding=@OutStanding

WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPaymentCheque WHERE Id=@Id;
END
GO


