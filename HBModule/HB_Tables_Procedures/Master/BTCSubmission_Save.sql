SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCSubmission_Save]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_BTCSubmission_Save]
GO 
/* 
    Author Name : <ARUNPRASATH.k>
	Created On 	: <Created Date (19/08/2014)>
	Section  	: BTC Submission Save
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
CREATE PROCEDURE [dbo].[SP_BTCSubmission_Save](
@ClientId			BIGINT,
@Acknowledged		NVARCHAR(100)=NULL,
@Comments           NVARCHAR(100)=NULL, 
@Filename			NVARCHAR(100)=NULL, 
@Physical			NVARCHAR(100)=NULL,
@Expected			NVARCHAR(100)=NULL,	
@SubmittedOn		NVARCHAR(100)=NULL,
@CollectionStatus	NVARCHAR(100)=NULL,
@DepositDetilsId	BIGINT,
@ChkOutHdrId        BIGINT, 
@InvoiceNo			NVARCHAR(100)=NULL, 
@InvoiceType		NVARCHAR(100)=NULL,
@InvoiceDate		NVARCHAR(100)=NULL,	
@CreatedBy			BIGINT
)
AS
BEGIN  
	INSERT INTO WRBHBBTCSubmission(ClientId,SubmittedOnDate,ExpectedDate,PhysicalInvoice,Acknowledged,
	Comments,CollectionStatus,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
	IsActive,IsDeleted,RowId,FileNames,ChkOutHdrId,InvoiceNo,
	InvoiceType,InvoiceDate,DepositDetilsId) 
	VALUES
	(@ClientId,CONVERT(DATE,@SubmittedOn,103),CONVERT(DATE,@Expected,103),@Physical,@Acknowledged,@Comments,@CollectionStatus,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@FileName,@ChkOutHdrId,@InvoiceNo,
	@InvoiceType,CONVERT(DATE,@InvoiceDate,103),@DepositDetilsId)
	
	SELECT Id,RowId FROM WRBHBBTCSubmission 
	WHERE Id=@@IDENTITY
END

