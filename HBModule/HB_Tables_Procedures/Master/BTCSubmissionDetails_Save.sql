SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCSubmissionDetails_Save]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_BTCSubmissionDetails_Save]
GO 
/* 
    Author Name : <ARUNPRASATH.k>
	Created On 	: <Created Date (19/08/2014)>
	Section  	: BTC Submission Details Save
	Purpose  	: Save
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
CREATE PROCEDURE [dbo].[SP_BTCSubmissionDetails_Save](
@BTCSubmissionId	BIGINT,
@ClientId			BIGINT,
@DepositDetilsId	BIGINT,
@ChkOutHdrId        BIGINT, 
@InvoiceNo			NVARCHAR(100)=NULL, 
@InvoiceType		NVARCHAR(100)=NULL,
@InvoiceDate		NVARCHAR(100)=NULL,	
@CollectionStatus	NVARCHAR(100)=NULL,
@CreatedBy			BIGINT
)
AS
BEGIN  
	INSERT INTO WRBHBBTCSubmissionDetails(BTCSubmissionId,ClientId,ChkOutHdrId,InvoiceNo,
	InvoiceType,InvoiceDate,CollectionStatus,DepositDetilsId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
	IsActive,IsDeleted,RowId) 
	VALUES
	(@BTCSubmissionId,@ClientId,@ChkOutHdrId,@InvoiceNo,@InvoiceType,CONVERT(DATE,@InvoiceDate,103),@CollectionStatus,
	@DepositDetilsId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
	
	SELECT Id,RowId FROM WRBHBBTCSubmissionDetails 
	WHERE Id=@@IDENTITY
END





