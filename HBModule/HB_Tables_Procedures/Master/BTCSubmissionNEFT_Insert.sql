 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmissionNEFT_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmissionNEFT_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/08/2014)  >
		Section  	: BTC SUBMISSION NEFT INSERT
		Purpose  	: NEFT INSERT
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
CREATE PROCEDURE [dbo].[Sp_BTCSubmissionNEFT_Insert]
(
@ClientId			INT,
@Amount				DECIMAL(27,2),
@ReferenceNo		NVARCHAR(100),
@Bank				NVARCHAR(100),
@NEFTDate			DATETIME,
@Comments			NVARCHAR(100),
@CreatedBy			INT,
@Mode				NVARCHAR(100)
) 
AS
BEGIN
INSERT INTO WRBHBBTCSubmissionNEFT(Amount,ReferenceNo,BankName,DateOfNEFT,Comments,IsActive,IsDeleted,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate,RowId,Mode,ClientId)
VALUES (@Amount,@ReferenceNo,@Bank,@NEFTDate,@Comments,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode,@ClientId)
		
 SELECT Id,RowId FROM WRBHBBTCSubmissionNEFT WHERE Id=@@IDENTITY;	
 
 UPDATE WRBHBBTCSubmission SET CollectionStatus='NEFT Payment',Mode=@Mode,ModeId=@@IDENTITY
 WHERE ClientId=@ClientId AND CollectionStatus='Submitted'		
END		