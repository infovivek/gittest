SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PCExpenseApproval_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PCExpenseApproval_Insert]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (22/08/2014)  >
Section  	: PCExpenseApproval_Insert
Purpose  	: PCExpenseApproval_Insert
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
CREATE PROCEDURE [dbo].[SP_PCExpenseApproval_Insert]
(
@RequestedOn NVARCHAR(100),
@Requestedby NVARCHAR(100),
@PCAccount NVARCHAR(100),
@ApprovedAmount DECIMAL(27,2),
@ExpenseAmount DECIMAL(27,2),
@ProcessedStatus NVARCHAR(100),
@LastProcessedon NVARCHAR(100),
@Comments NVARCHAR(100),
@RequestedUserId INT,
@Process   BIT,
@UserId   INT,@PropertyId   INT,
@CreatedBy INT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX),@Str NVARCHAR(100);
 IF(@ProcessedStatus ='Waiting For Operation Manager Approval')
 BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBPCExpenseApproval WITH (NOLOCK) 
 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
		SET @ErrMsg = 'Requestor and Approver cannot be same';
        SELECT @ErrMsg;
 END
 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Operations Managers')
	
	 IF (ISNULL(@Str,'') !='Operations Managers')
	 BEGIN
			SET @ErrMsg = 'Need Operations Manager Approval';
			SELECT @ErrMsg;
	 END
 ELSE
 BEGIN
		UPDATE WRBHBPettyCashStatusHdr SET NewEntry=1
		WHERE UserId=@RequestedUserId AND PropertyId=@PropertyId AND 
		CONVERT(NVARCHAR,CAST(ModifiedDate AS Date),103)=CONVERT(NVARCHAR,@RequestedOn,103)
			
		INSERT INTO	WRBHBPCExpenseApproval (RequestedOn,Requestedby,
		PCAccount,ApprovedAmount,ExpenseAmount,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,UserId,PropertyId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@RequestedOn,@Requestedby,@PCAccount,@ApprovedAmount,@ExpenseAmount,
		'Approved by reporting authority',
		@LastProcessedon,@Comments,@RequestedUserId,@UserId,@PropertyId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID())	
		
		SELECT Id,Rowid FROM WRBHBPCExpenseApproval WHERE Id=@@IDENTITY;
	
		DECLARE @Id1 int
		SET @Id1=(SELECT Id FROM WRBHBPCExpenseApproval WHERE Id=@@IDENTITY)
	
		INSERT INTO	WRBHBNewPCExpenseApproval (RequestedOn,Requestedby,
		PCAccount,ApprovedAmount,ExpenseAmount,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,UserId,PropertyId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,HeaderId)
		VALUES (@RequestedOn,@Requestedby,@PCAccount,@ApprovedAmount,@ExpenseAmount,
		'Approved by reporting authority',
		@LastProcessedon,@Comments,@RequestedUserId,@UserId,@PropertyId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@Id1)
 END
 END
  
END
  
  
