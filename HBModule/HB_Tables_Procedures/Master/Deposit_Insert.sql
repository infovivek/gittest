 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Deposit_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Deposit_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/06/2014)  >
		Section  	: Deposit INSERT
		Purpose  	: Deposit INSERT
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
CREATE PROCEDURE [dbo].[Sp_Deposit_Insert]
(
@Date				NVARCHAR(100),
@Amount				NVARCHAR(100),
@DepositeToId		NVARCHAR(100),
@Comments			NVARCHAR(MAX),
@CreatedBy			INT,
@ChalanImage		NVARCHAR(100),
@Mode				NVARCHAR(100),
@ImageName			NVARCHAR(100),
@PId				BIGINT,
@InvoiceNo			NVARCHAR(100),
@TotalAmount		DECIMAL(27,2),
@BTCTo				NVARCHAR(100),
@BTCMode			NVARCHAR(100),
@DoneBy				NVARCHAR(100),
@ChequeNo			NVARCHAR(100),
@ChkOutHdrId		BIGINT,
@ClientId			BIGINT
) 
AS
BEGIN
INSERT INTO WRBHBDeposits(DepositedDate,Amount,DepositeToId,DepositedBy,Comments,ChallanImage,Mode,
			IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,ImageName,PropertyId,
			InvoiceNo,TotalAmount,BTCTo,BTCMode,DoneBy,ChequeNo,ChkOutHdrId,ClientId)
VALUES (CONVERT(datetime,@Date,103),@Amount,@DepositeToId,@CreatedBy,@Comments,@ChalanImage,@Mode,1,0,@CreatedBy,
		GETDATE(),@CreatedBy,GETDATE(),NEWID(),@ImageName,@PId,'',@TotalAmount,@BTCTo,@BTCMode,@DoneBy,
		@ChequeNo,@ChkOutHdrId,@ClientId)
		
 SELECT Id,RowId FROM WRBHBDeposits
 WHERE Id=@@IDENTITY;		
END		
