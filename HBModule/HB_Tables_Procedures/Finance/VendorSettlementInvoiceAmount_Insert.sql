SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_VendorSettlementInvoiceAmount_Insert') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_VendorSettlementInvoiceAmount_Insert
GO 
/*   
Author Name : <ARUNPRASATH.k>  
Created On  : <Created Date (27/09/2014)  >  
Section   : VendorSettlementInvoiceAmount  insert  
Purpose   : VendorSettlementInvoiceAmount  Insert  
Remarks   : <Remarks if any>                          
Reviewed By : <Reviewed By (Leave it blank)>  
*/              
/*******************************************************************************************************  
*    AMENDMENT BLOCK  
********************************************************************************************************  
'Name   Date   Signature   Description of Changes  
********************************************************************************************************   
*******************************************************************************************************  
*/  
CREATE PROCEDURE [dbo].[Sp_VendorSettlementInvoiceAmount_Insert](  
@HdrId			BIGINT,  
@PropertyId		BIGINT,  
@InvoiceId		BIGINT,  
@InvoiceNo		NVARCHAR(100),  
@InvoiceDate	DATE,  
@InvoiceAmount	DECIMAL(27,2),  
@Status			NVARCHAR(100),  
@POCount		NVARCHAR(100),  
@Adjusment		DECIMAL(27,2),  
@CreatedBy      BIGINT ,
@Flag			NVARCHAR(100) 
)   
AS  
BEGIN  
  
IF @HdrId=0  
BEGIN  
 INSERT INTO WRBHBVendorSettlementHdr(PropertyId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,  
 IsActive,IsDeleted,RowId)  
 VALUES(@PropertyId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())  
   
 SELECT @HdrId=@@IDENTITY  
END  
  
INSERT INTO WRBHBVendorSettlementInvoiceAmount(VendorSettlementHdId,InvoiceId,InvoiceNo,InvoiceDate,InvoiceAmount,  
Status,POCount,Adjusment,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, IsActive,IsDeleted,RowId,Flag)  
VALUES(@HdrId,@InvoiceId,@InvoiceNo,@InvoiceDate,@InvoiceAmount,  
@Status,@POCount,@Adjusment,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Flag)  
  
SELECT @HdrId   
  
END