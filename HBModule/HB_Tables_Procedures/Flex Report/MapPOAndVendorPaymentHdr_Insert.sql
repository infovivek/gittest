SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MapPOAndVendorPaymentHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_MapPOAndVendorPaymentHdr_Insert]
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
CREATE PROCEDURE [dbo].[Sp_MapPOAndVendorPaymentHdr_Insert](
@InvoiceAmount	DECIMAL(27,2),
@InvoiceDate	NVARCHAR(100),
@InvoiceNo		NVARCHAR(100),
@Property		NVARCHAR(100),
@PropertyId		BIGINT,
@TotalPOAmount	DECIMAL(27,2),
@CreatedBy		NVARCHAR(100)
) 
AS
BEGIN
 --INSERT
 
 INSERT INTO WRBHBMapPOAndVendorPaymentHdr(InvoiceAmount,InvoiceDate,InvoiceNo,
 Property,PropertyId,TotalPOAmount,FilePath,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId)
 VALUES(@InvoiceAmount,CONVERT(DATE,@InvoiceDate,103),@InvoiceNo,
 @Property,@PropertyId,@TotalPOAmount,'',@CreatedBy,GETDATE(),@CreatedBy,
 GETDATE(),1,0,NEWID())
 
 SELECT Id,RowId FROM WRBHBMapPOAndVendorPaymentHdr WHERE Id=@@IDENTITY
 
END
GO
