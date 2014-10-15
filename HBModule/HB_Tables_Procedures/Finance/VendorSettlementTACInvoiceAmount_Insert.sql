
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_VendorSettlementTACInvoiceAmount_Insert') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE   Sp_VendorSettlementTACInvoiceAmount_Insert
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
CREATE PROCEDURE [dbo].[Sp_VendorSettlementTACInvoiceAmount_Insert](  
@HdrId     BIGINT,  
@TACId     BIGINT,  
@TACInvoiceNo   NVARCHAR(100),  
@BillDate    NVARCHAR(100),  
@TACAmount    DECIMAL(27,2),  
@TotalBusinessSupportST DECIMAL(27,2),  
@Total     DECIMAL(27,2),  
@AdjusementAmount  DECIMAL(27,2),  
@Adjusment    DECIMAL(27,2),  
@CreatedBy    BIGINT  
)   
AS  
BEGIN  
  
 
INSERT INTO WRBHBVendorSettlementTACInvoiceAmount(VendorSettlementHdId,TACId,TACInvoiceNo,BillDate,  
TACAmount,TotalBusinessSupportST,Total,AdjusementAmount,Adjusment,CreatedBy,CreatedDate,  
ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)  
VALUES(@HdrId,@TACId,@TACInvoiceNo,CONVERT(DATE,@BillDate,103),  
@TACAmount,@TotalBusinessSupportST,@Total,@AdjusementAmount,@Adjusment,  
@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())  

CREATE TABLE #TACInvoiceDataAdjusment(InvoiceAmount DECIMAL(27,2),TACId BIGINT,
Adjusment DECIMAL(27,2))
	
INSERT INTO #TACInvoiceDataAdjusment(InvoiceAmount,TACId,Adjusment)
SELECT SUM(Total),TACId,SUM(Adjusment) FROM WRBHBVendorSettlementTACInvoiceAmount
WHERE TACId=@TACId
GROUP BY TACId
	
UPDATE WRBHBExternalChechkOutTAC SET SettlementFlag=1 
FROM #TACInvoiceDataAdjusment S 
JOIN WRBHBExternalChechkOutTAC H ON S.TACId=H.Id
AND S.Adjusment=H.TACAmount	
	  
SELECT @HdrId   
  
END