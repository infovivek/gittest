SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCSubmission_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_BTCSubmission_Update]
GO 
/* 
    Author Name : <ARUNPRASATH.k>
	Created On 	: <Created Date (19/08/2014)>
	Section  	: BTC Submission Update
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
CREATE PROCEDURE [dbo].[SP_BTCSubmission_Update](
@ClientId			BIGINT,
@Acknowledged		NVARCHAR(100)=NULL,
@Comments           NVARCHAR(100)=NULL, 
@Filename			NVARCHAR(100)=NULL, 
@Physical			NVARCHAR(100)=NULL,
@Expected			NVARCHAR(100)=NULL,	
@SubmittedOn		NVARCHAR(100)=NULL,
@CollectionStatus	NVARCHAR(100)=NULL,
@CreatedBy			BIGINT,
@DepositDetilsId	BIGINT,
@ChkOutHdrId        BIGINT, 
@InvoiceNo			NVARCHAR(100)=NULL, 
@InvoiceType		NVARCHAR(100)=NULL,
@InvoiceDate		NVARCHAR(100)=NULL,	
@Id					BIGINT
)
AS
BEGIN  
	UPDATE WRBHBBTCSubmission SET 
	ClientId=@ClientId,
	SubmittedOnDate=CONVERT(DATE,@SubmittedOn,103),
	ExpectedDate=CONVERT(DATE,@Expected,103),
	PhysicalInvoice=@Physical,
	Acknowledged=@Acknowledged,
	Comments=@Comments,
	CollectionStatus=@CollectionStatus,		
	ChkOutHdrId=@ChkOutHdrId,
	InvoiceNo=@InvoiceNo,
	InvoiceType=@InvoiceType,
	InvoiceDate=CONVERT(DATE,InvoiceDate,103),
	DepositDetilsId=@DepositDetilsId,
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE(),	
	FileNames=@FileName
	WHERE Id=@Id
	
	SELECT Id,RowId FROM WRBHBBTCSubmission 
	WHERE Id=@Id
END