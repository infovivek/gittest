 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmissionCash_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmissionCash_Insert]
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
CREATE PROCEDURE [dbo].[Sp_BTCSubmissionCash_Insert]
(
@Amount				DECIMAL(27,2),
@ReceivedOn			NVARCHAR(100),
@ReceivedBy			NVARCHAR(100),
@Comments			NVARCHAR(100),
@CreatedBy			BIGINT,
@Mode				NVARCHAR(100)
) 
AS
BEGIN
INSERT INTO WRBHBBTCSubmissionCash(Amount,ReceivedOn,ReceivedBy,Comments,IsActive,IsDeleted,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate,RowId,Mode)
VALUES (@Amount,CONVERT(date,@ReceivedOn,103),@ReceivedBy,@Comments,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),
		NEWID(),@Mode)
		
 SELECT Id,RowId FROM WRBHBBTCSubmissionCash WHERE Id=@@IDENTITY;
 
END		