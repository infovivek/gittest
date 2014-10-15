SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCSubmissionDetails_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_BTCSubmissionDetails_Update]
GO 
/* 
    Author Name : <ARUNPRASATH.k>
	Created On 	: <Created Date (19/08/2014)>
	Section  	: BTC Submission Details 
	Purpose  	: Update
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
CREATE PROCEDURE [dbo].[SP_BTCSubmissionDetails_Update](
@BTCSubmissionId	BIGINT,
@ClientId			BIGINT,
@DepositDetilsId	BIGINT,
@ChkOutHdrId        BIGINT, 
@InvoiceNo			NVARCHAR(100)=NULL, 
@InvoiceType		NVARCHAR(100)=NULL,
@InvoiceDate		NVARCHAR(100)=NULL,	
@CollectionStatus	NVARCHAR(100)=NULL,
@CreatedBy			BIGINT,
@Id					BIGINT	
)
AS
BEGIN  
	UPDATE WRBHBBTCSubmissionDetails SET
	BTCSubmissionId=@BTCSubmissionId,
	ClientId=@ClientId,
	ChkOutHdrId=@ChkOutHdrId,
	InvoiceNo=@InvoiceNo,
	InvoiceType=@InvoiceType,
	InvoiceDate=@InvoiceDate,
	CollectionStatus=@CollectionStatus,
	DepositDetilsId=@DepositDetilsId,
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id
	
	SELECT Id,RowId FROM WRBHBBTCSubmissionDetails 
	WHERE Id=@Id
END