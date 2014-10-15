SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorSettlementAdjusmentAdvanceAmount_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_VendorSettlementAdjusmentAdvanceAmount_Insert]
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
CREATE PROCEDURE [dbo].[Sp_VendorSettlementAdjusmentAdvanceAmount_Insert](
@HdrId						BIGINT,
@VendorAdvancePaymentId		BIGINT,
@AdvanceAmount				DECIMAL(27,2),
@AdjusementAmount			DECIMAL(27,2),
@CreatedBy					NVARCHAR(100)
) 
AS
BEGIN
 --INSERT
 
	INSERT INTO WRBHBVendorSettlementAdjusmentAdvanceAmount(VendorSettlementHdId,
	VendorAdvancePaymentId,AdvanceAmount,AdjusementAmount,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
	VALUES(@HdrId,@VendorAdvancePaymentId,@AdvanceAmount,@AdjusementAmount,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
 
 
	SELECT @HdrId,RowId FROM WRBHBVendorSettlementAdjusmentAdvanceAmount WHERE Id=@@IDENTITY
	
	
	CREATE TABLE #AdvanceAmount(AdvanceAmount DECIMAL(27,2),Id BIGINT,AdjusmentAmount DECIMAL(27,2))
	
	INSERT INTO #AdvanceAmount(Id,AdjusmentAmount)
	SELECT VendorAdvancePaymentId,SUM(AdjusementAmount) FROM WRBHBVendorSettlementAdjusmentAdvanceAmount A
	WHERE VendorAdvancePaymentId=@VendorAdvancePaymentId
	GROUP BY VendorAdvancePaymentId
		
	UPDATE WRBHBVendorAdvancePayment SET SettlementFlag=1 
	FROM #AdvanceAmount S 
	JOIN WRBHBVendorAdvancePayment H ON S.Id=H.Id AND S.AdjusmentAmount =H.AdvanceAmount	
 
END
GO