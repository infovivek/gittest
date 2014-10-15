SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorAdvancePayment_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_VendorAdvancePayment_Insert]
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
CREATE PROCEDURE [dbo].[Sp_VendorAdvancePayment_Insert](
@PropertyId			BIGINT,
@PropertyName		NVARCHAR(100),
@AdvanceAmount		DECIMAL(27,2),
@DateofPayment		NVARCHAR(100),
@Comments			NVARCHAR(100),
@BankName			NVARCHAR(100),
@ChequeNumber		NVARCHAR(100),
@IssueDate			NVARCHAR(100),
@PaymentMode		NVARCHAR(100),
@CreatedBy			NVARCHAR(100)
) 
AS
BEGIN
 --INSERT
 
	INSERT INTO WRBHBVendorAdvancePayment(PropertyId,PropertyName,AdvanceAmount,
	DateofPayment,Comments,BankName,ChequeNumber,IssueDate,PaymentMode,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
	VALUES(@PropertyId,@PropertyName,@AdvanceAmount,
	CONVERT(DATE,@DateofPayment,103),@Comments,@BankName,@ChequeNumber,
	CONVERT(DATE,@IssueDate,103),@PaymentMode,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
	SELECT Id,RowId FROM WRBHBVendorAdvancePayment WHERE Id=@@IDENTITY
 
END
GO