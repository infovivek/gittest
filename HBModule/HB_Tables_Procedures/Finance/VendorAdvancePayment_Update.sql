SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorAdvancePayment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_VendorAdvancePayment_Update]
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
CREATE PROCEDURE [dbo].[Sp_VendorAdvancePayment_Update](
@PropertyId			BIGINT,
@PropertyName		NVARCHAR(100),
@AdvanceAmount		DECIMAL(27,2),
@DateofPayment		NVARCHAR(100),
@Comments			NVARCHAR(100),
@BankName			NVARCHAR(100),
@ChequeNumber		NVARCHAR(100),
@IssueDate			NVARCHAR(100),
@PaymentMode		NVARCHAR(100),
@CreatedBy			NVARCHAR(100),
@Id					BIGINT
) 
AS
BEGIN
 --UPDATE
 
 UPDATE WRBHBVendorAdvancePayment SET 
	PropertyId=@PropertyId,
	PropertyName=@PropertyName,
	AdvanceAmount=@AdvanceAmount,
	DateofPayment=CONVERT(DATE,@DateofPayment,103),
	Comments=@Comments,
	BankName=@BankName,
	ChequeNumber=@ChequeNumber,
	IssueDate=CONVERT(DATE,@IssueDate,103),
	PaymentMode=@PaymentMode,
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id 
 
	SELECT Id,RowId FROM WRBHBVendorAdvancePayment WHERE Id=@Id
 
END
GO