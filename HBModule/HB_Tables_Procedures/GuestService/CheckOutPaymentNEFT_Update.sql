
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentNEFT_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentNEFT_Update]
GO
/*=============================================
Author Name  : shameem
Modified Date : 23/06/14 
Section  	 : Guest checkout 
Purpose  	 : Payment NEFT
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentNEFT_Update](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@ReferenceNumber NVARCHAR(100),
@BankName NVARCHAR(100),@DateNEFTMonth int,
@DateNEFTYear int,@CreatedBy BIGINT,@OutStanding decimal(27,2),@Id int)

AS
BEGIN


UPDATE WRBHBChechkOutPaymentNEFT SET

ChkOutHdrId=@ChkOutHdrId,Payment=@Payment,
PayeeName=@PayeeName,Address=@Address,AmountPaid=@AmountPaid,
PaymentMode=@PaymentMode,ReferenceNumber=@ReferenceNumber,
BankName=@BankName,DateNEFTMonth=@DateNEFTMonth,DateNEFTYear=@DateNEFTYear,
OutStanding=@OutStanding


WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPaymentNEFT WHERE Id=@Id;
END
GO