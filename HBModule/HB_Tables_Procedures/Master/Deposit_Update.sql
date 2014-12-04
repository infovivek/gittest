 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Deposit_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Deposit_Update]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/06/2014)  >
		Section  	: Deposit Update
		Purpose  	: Deposit Update
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
CREATE PROCEDURE [dbo].[Sp_Deposit_Update]
(
@Date				NVARCHAR(100),
@Amount				NVARCHAR(100),
@DepositeToId		NVARCHAR(100),
@Comments			NVARCHAR(100),
@CreatedBy			INT,
@ChalanImage		NVARCHAR(Max),
@Mode				BIT,
@Id					BIGINT
) 
AS
BEGIN
DECLARE @Identity int
Update WRBHBDeposits SET DepositedDate=@Date,Amount=@Amount,DepositeToId=@DepositeToId,DepositedBy=@CreatedBy,
		Comments=@Comments,ChallanImage=@ChalanImage,Mode=@Mode,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			
SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBDeposits WHERE Id=@Identity;	
END		