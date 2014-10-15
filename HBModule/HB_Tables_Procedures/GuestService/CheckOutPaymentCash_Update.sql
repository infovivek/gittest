SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCash_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_CheckOutPaymentCash_Update]
GO
/*=============================================
Author Name  : Shameem
Created Date : 22/05/2014 
Section  	 : Guest Service
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
=============================================*/

CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCash_Update](@Id int,
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@CashReceivedOn NVARCHAR(100),@CashReceivedBy NVARCHAR(100),
@CreatedBy BIGINT,@OutStanding decimal(27,2))

AS
BEGIN
-- 
UPDATE WRBHBChechkOutPaymentCash SET
ChkOutHdrId=@ChkOutHdrId,Payment=@Payment,Address=@Address,
AmountPaid=@AmountPaid,PaymentMode=@PaymentMode,CashReceivedOn=@CashReceivedOn,
OutStanding=@OutStanding,
CashReceivedBy=@CashReceivedBy
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPaymentCash WHERE Id=@Id;
END
GO


