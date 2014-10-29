SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PCExpenseApproval_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[Sp_PCExpenseApproval_Update]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (03/06/2014)  >
Section  	: PETTYCASH REQUESTED HELP
Purpose  	: PETTYCASH REQUESTED HELP
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
CREATE PROCEDURE [dbo].[Sp_PCExpenseApproval_Update]
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
@Process   BIT,@PropertyId   INT,
@UserId   INT,@Id INT,
@CreatedBy INT
)
AS
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX),@Id1 int,@Str NVARCHAR(100);
IF(@ProcessedStatus ='Approved by reporting authority')
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBPCExpenseApproval WITH (NOLOCK) 
 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
	  SELECT @ErrMsg;
 END
 SET @Id1=(SELECT UserId FROM WRBHBPCExpenseApproval WITH (NOLOCK) 
 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
 IF(@Id1 !=0)
 BEGIN
      SET @ErrMsg = 'Need Operations Head Approval';
	  SELECT @ErrMsg;
 END
 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Ops Head')
	
	 IF(ISNULL(@Str,'') !='Ops Head')
	 BEGIN
			SET @ErrMsg = 'Need Operations Head Approval';
			SELECT @ErrMsg;
	 END
 ELSE
 BEGIN
		UPDATE WRBHBPettyCashStatus SET Flag=0
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId 
 
		INSERT INTO	WRBHBNewPCExpenseApproval (RequestedOn,Requestedby,
		PCAccount,ApprovedAmount,ExpenseAmount,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,UserId,PropertyId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,HeaderId)
		VALUES (@RequestedOn,@Requestedby,@PCAccount,@ApprovedAmount,@ExpenseAmount,
		'Report Approved by Ops Head',
		@LastProcessedon,@Comments,@RequestedUserId,@UserId,@PropertyId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@Id)
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBPCExpenseApproval SET RequestedOn=@RequestedOn,Requestedby=@Requestedby,PCAccount=@PCAccount,
		ApprovedAmount=@ApprovedAmount,ExpenseAmount=@ExpenseAmount,
		ProcessedStatus='Report Approved by Ops Head',LastProcessedon=@LastProcessedon,
		Comments=@Comments,RequestedUserId=@RequestedUserId,PropertyId=@PropertyId,UserId=@UserId,Process=@Process,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		SELECT Id,RowId FROM WRBHBPCExpenseApproval
		WHERE Id=@Id
 END
END
IF(@ProcessedStatus ='Report Approved by Ops Head')
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBPCExpenseApproval WITH (NOLOCK) 
 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
	  SELECT @ErrMsg;
 END
 SET @Id1=(SELECT UserId FROM WRBHBPCExpenseApproval WITH (NOLOCK) 
 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
 IF(@Id1 !=0)
 BEGIN
      SET @ErrMsg = 'Need Finance Manager Approval';
	  SELECT @ErrMsg;
 END
 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Finance')
	 IF(ISNULL(@Str,'') !='Finance')
	 BEGIN
			SET @ErrMsg = 'Need Finance Manager Approval';
			SELECT @ErrMsg;
	 END
 ELSE
 BEGIN
		UPDATE WRBHBPettyCashStatusHdr SET Flag=0,IsActive=0,IsDeleted=1
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId 
			 			
		INSERT INTO	WRBHBNewPCExpenseApproval (RequestedOn,Requestedby,
		PCAccount,ApprovedAmount,ExpenseAmount,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,PropertyId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@RequestedOn,@Requestedby,@PCAccount,@ApprovedAmount,@ExpenseAmount,
		'Accounted and Closed by Finance Manager ',
		@LastProcessedon,@Comments,@RequestedUserId,@PropertyId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID())
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBPCExpenseApproval SET RequestedOn=@RequestedOn,Requestedby=@Requestedby,PCAccount=@PCAccount,
		ApprovedAmount=@ApprovedAmount,ExpenseAmount=@ExpenseAmount,
		ProcessedStatus='Accounted and Closed by Finance Manager',LastProcessedon=@LastProcessedon,
		Comments=@Comments,RequestedUserId=@RequestedUserId,PropertyId=@PropertyId,UserId=@UserId,Process=0,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		SELECT Id,RowId FROM WRBHBPCExpenseApproval
		WHERE Id=@Id
END
END


 
  

