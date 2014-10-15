 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmissionModeDetail_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmissionModeDetail_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/08/2014)  >
		Section  	: BTC SUBMISSION CASH INSERT
		Purpose  	: CASH INSERT
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
CREATE PROCEDURE [dbo].[Sp_BTCSubmissionModeDetail_Insert]
(
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
@Mode				NVARCHAR(100),
@CreatedBy			BIGINT,
@Id					BIGINT,
@ModeId				BIGINT
) 
AS
BEGIN
 IF (@Id=0)--NOT EXISTS(SELECT NULL FROM WRBHBBTCSubmission WHERE Id = @@IDENTITY  )		
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
 ELSE
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
	FileNames=@FileName,
	Mode=@Mode,
	ModeId=@ModeId
	WHERE Id=@Id
	
	SELECT Id,RowId FROM WRBHBBTCSubmission 
	WHERE Id=@Id
 END
END		