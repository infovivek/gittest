
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutPaymentNEFT_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutPaymentNEFT_Insert]
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
CREATE PROCEDURE [dbo].[SP_CheckOutPaymentNEFT_Insert](
@ChkOutHdrId INT,@Payment NVARCHAR(100),
@PayeeName NVARCHAR(100),@Address NVARCHAR(100),@AmountPaid DECIMAL(27,2),
@PaymentMode NVARCHAR(100),@ReferenceNumber NVARCHAR(100),
@BankName NVARCHAR(100),@DateofNEFT NVARCHAR(100),@DateNEFTMonth int,
@DateNEFTYear int,@CreatedBy BIGINT,@OutStanding decimal(27,2))

AS
BEGIN
DECLARE @Id INT;
DECLARE @IntermediateFlag NVARCHAR(100)
SET @IntermediateFlag = (SELECT IntermediateFlag FROM WRBHBChechkOutHdr WHERE Id = @ChkOutHdrId)

IF @IntermediateFlag = '1'
BEGIN
	-- INSERT
	INSERT INTO WRBHBChechkOutPaymentNEFT(ChkOutHdrId,Payment,PayeeName,Address,
	AmountPaid,PaymentMode,ReferenceNumber,BankName,DateofNEFT,DateNEFTMonth,DateNEFTYear,OutStanding,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@PaymentMode,@ReferenceNumber,
	@BankName,@DateofNEFT,@DateNEFTMonth,@DateNEFTYear,@OutStanding,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),0,0,NEWID())

	SET @Id=@@IDENTITY;
	SELECT  Id,RowId FROM WRBHBChechkOutPaymentNEFT WHERE Id=@Id;
END
ELSE
BEGIN
	-- INSERT
	INSERT INTO WRBHBChechkOutPaymentNEFT(ChkOutHdrId,Payment,PayeeName,Address,
	AmountPaid,PaymentMode,ReferenceNumber,BankName,DateofNEFT,DateNEFTMonth,DateNEFTYear,OutStanding,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

	VALUES(@ChkOutHdrId,@Payment,@PayeeName,@Address,@AmountPaid,@PaymentMode,@ReferenceNumber,
	@BankName,@DateofNEFT,@DateNEFTMonth,@DateNEFTYear,@OutStanding,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

	SET @Id=@@IDENTITY;
	SELECT  Id,RowId FROM WRBHBChechkOutPaymentNEFT WHERE Id=@Id;
END
 
END
GO
