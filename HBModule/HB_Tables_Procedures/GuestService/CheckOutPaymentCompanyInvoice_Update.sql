
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCompanyInvoice_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCompanyInvoice_Update]
GO
/*=============================================
Author Name  : shameem
Modified Date : 23/06/14 
Section  	 : Guest checkout 
Purpose  	 : Payment COMPANY INVOICE
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCompanyInvoice_Update](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@Approver NVARCHAR(100),@Requester NVARCHAR(100),
@EmailId NVARCHAR(100),@PhoneNo INT,@FileLoad nvarchar(100),@CreatedBy BIGINT,@Id int)

AS
BEGIN
UPDATE WRBHBChechkOutPaymentCompanyInvoice SET
ChkOutHdrId=@ChkOutHdrId,PayeeName=@PayeeName,Payment=@Payment,
Address=@Address,AmountPaid=@AmountPaid,Approver=@Approver,Requester=@Requester,
EmailId=@EmailId,PhoneNo=@PhoneNo,FileLoad=@FileLoad
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutPaymentCompanyInvoice WHERE Id=@Id;
END
GO
