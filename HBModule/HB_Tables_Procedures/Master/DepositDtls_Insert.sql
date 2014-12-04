 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_DepositDtls_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_DepositDtls_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (08/08/2014)  >
		Section  	: Deposit Detail INSERT
		Purpose  	: Deposit Detail INSERT
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
CREATE PROCEDURE [dbo].[Sp_DepositDtls_Insert]
(
@DepHdrId		BIGINT,
@InvoiceNo		NVARCHAR(100),
@Amount			DECIMAL(27,2),
@BillType		NVARCHAR(100),
@Tick			BIT,
@ClientId		BIGINT,
@ChkOutHdrId	BIGINT
)
AS
BEGIN
	INSERT INTO WRBHBDepositsDlts(DepHdrId,InvoiceNo,Amount,BillType,IsActive,IsDeleted,Tick,RowId,ClientId,ChkOutHdrId)
	VALUES(@DepHdrId,@InvoiceNo,@Amount,@BillType,1,0,@Tick,NEWID(),@ClientId,@ChkOutHdrId)
	
	-- SELECT Id,RowId FROM WRBHBDepositsDlts WHERE Id=@@IDENTITY;
END