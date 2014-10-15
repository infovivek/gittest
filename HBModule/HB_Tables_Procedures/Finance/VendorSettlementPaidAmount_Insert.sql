SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorSettlementPaidAmount_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_VendorSettlementPaidAmount_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: Apartment  Insert 
Purpose  	: Apartment  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_VendorSettlementPaidAmount_Insert](
@HdrId				BIGINT,
@AdjustAdvance		DECIMAL(27,2),
@DateofPayment		NVARCHAR(100),
@AmountPaid			DECIMAL(27,2),
@BankName			NVARCHAR(100),
@ChequeNumber		NVARCHAR(100),
@IssueDate			NVARCHAR(100),
@PaymentMode		NVARCHAR(100),
@CreatedBy			NVARCHAR(100)
) 
AS
BEGIN
 --INSERT
 
	INSERT INTO WRBHBVendorSettlementPaidAmount(VendorSettlementHdId,AdjustAdvance,
	DateofPayment,AmountPaid,BankName,ChequeNumber,IssueDate,PaymentMode,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
	VALUES(@HdrId,@AdjustAdvance,CONVERT(DATE,@DateofPayment,103),@AmountPaid,
	@BankName,@ChequeNumber,CONVERT(DATE,@IssueDate,103),@PaymentMode,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
	SELECT Id,RowId FROM WRBHBVendorSettlementPaidAmount WHERE Id=@@IDENTITY
 
END
GO