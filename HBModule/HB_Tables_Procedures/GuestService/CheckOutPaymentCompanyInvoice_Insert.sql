
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentCompanyInvoice_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentCompanyInvoice_Insert]
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
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentCompanyInvoice_Insert](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@Approver NVARCHAR(100),@Requester NVARCHAR(100),
@EmailId NVARCHAR(100),@PhoneNo Nvarchar(100),@FileLoad nvarchar(100),@CreatedBy BIGINT,
@OutStanding decimal(27,2))

AS
BEGIN
DECLARE @Id INT;
 -- INSERT
INSERT INTO WRBHBChechkOutPaymentCompanyInvoice(ChkOutHdrId,Payment,PayeeName,Address,
AmountPaid,PaymentMode,Approver,Requester,EmailId,PhoneNo,FileLoad,OutStanding,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@PaymentMode,
@Approver,@Requester,@EmailId,@PhoneNo,@FileLoad,@OutStanding,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

SET @Id=@@IDENTITY;
SELECT  Id,RowId FROM WRBHBChechkOutPaymentCompanyInvoice WHERE Id=@Id;
END
GO
