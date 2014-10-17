 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmissionCard_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmissionCard_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/08/2014)  >
		Section  	: BTC SUBMISSION Card INSERT
		Purpose  	: Card INSERT
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
CREATE PROCEDURE [dbo].[Sp_BTCSubmissionCard_Insert]
(
@ClientId			INT,
@Amount				DECIMAL(27,2),
@CCBrand			NVARCHAR(100),
@Name				NVARCHAR(100),
@CardNumber			NVARCHAR(100),
@ExpiryMonth		NVARCHAR(100),
@ExpiryYear			NVARCHAR(100),
@ROC				NVARCHAR(100),
@SOC				NVARCHAR(100),
@Swipedfor			NVARCHAR(100),
@Remarks			NVARCHAR(100),
@Comments			NVARCHAR(100),
@CreatedBy			INT,
@Mode				NVARCHAR(100)
) 
AS
BEGIN


INSERT INTO WRBHBBTCSubmissionCard(Amount,CCBrand,NameOnTheCard,CardNumber,ExpiryMonth,ExpiryYear,ROC,
			SOCBatchCloseNo,SwipedFor,Remarks,Comments,IsActive,IsDeleted,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate,RowId,Mode,ClientId)
VALUES (@Amount,@CCBrand,@Name,@CardNumber,@ExpiryMonth,@ExpiryYear,@ROC,@SOC,@Swipedfor,@Remarks,@Comments,
		1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode,@ClientId)
		
 SELECT Id,RowId FROM WRBHBBTCSubmissionCard WHERE Id=@@IDENTITY;	
 
 UPDATE WRBHBBTCSubmission SET CollectionStatus='Card Payment',Mode=@Mode,ModeId=@@IDENTITY
 WHERE ClientId=@ClientId AND CollectionStatus='Submitted'	
END		