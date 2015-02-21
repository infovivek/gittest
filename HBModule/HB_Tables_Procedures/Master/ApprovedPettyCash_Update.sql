SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ApprovedPettyCash_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ApprovedPettyCash_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (31/03/2014)  >
Section  	: PETTYCASH Update
Purpose  	: PETTYCASH Update
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
CREATE PROCEDURE [dbo].[Sp_ApprovedPettyCash_Update]
(
@Date			NVARCHAR(100),
@Description	NVARCHAR(MAX),
@ExpenseHead	NVARCHAR(100),
@Amount			DECIMAL(27,1),
@ApprovedAmount	DECIMAL(27,1),
@CreatedBy		INT,
@Status			NVARCHAR(100),
@Comments		NVARCHAR(1000),
@PropertyId		BIGINT,
@UserId			BIGINT,
@Id				BIGINT,
@Total			BIGINT,
@ExpenseGroupId	BIGINT
)
AS
BEGIN
	 DECLARE @ErrMsg NVARCHAR(MAX),@Str NVARCHAR(100);
	 IF EXISTS (SELECT NULL FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
	 WHERE UPPER(@UserId) = UPPER(@CreatedBy))
	 BEGIN
	  		SET @ErrMsg = 'Requestor and Approver cannot be same';
			SELECT @ErrMsg;
	 END
	 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@CreatedBy) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Operations Managers')
	
	 IF ISNULL(@Str,'') !='Operations Managers'
	 BEGIN
			SET @ErrMsg = 'Need Operations Manager Approval';
			SELECT @ErrMsg;
	 END
 
 ELSE
 BEGIN
	UPDATE WRBHBPettyCash SET ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
	Comments=@Comments,ApprovedAmount=@ApprovedAmount FROM WRBHBPettyCash P
	JOIN WRBHBPettyCashHdr PH ON P.PettyCashHdrId=PH.Id AND PH.IsActive=1 AND PH.IsDeleted=0
	WHERE P.Id=@Id AND PH.UserId=@UserId AND PH.PropertyId=@PropertyId AND PH.ExpenseGroupId=@ExpenseGroupId
				
	SELECT Id,Rowid FROM WRBHBPettyCash WHERE Id=@Id;
END
END		



	