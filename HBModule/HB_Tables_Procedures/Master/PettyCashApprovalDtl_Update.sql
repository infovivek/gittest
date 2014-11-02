SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PettyCashApprovalDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_PettyCashApprovalDtl_Update]

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
CREATE PROCEDURE [dbo].[SP_PettyCashApprovalDtl_Update]
(
@PettyCashApprovalHdrId INT,
@RequestedOn NVARCHAR(100),
@Requestedby NVARCHAR(100),
@PCAccount NVARCHAR(100),
@RequestedAmount DECIMAL(27,2),
@RequestedStatus NVARCHAR(100),
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
 IF EXISTS (SELECT NULL FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
	  SELECT @ErrMsg;
 END
 SET @Id1=(SELECT UserId FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
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
		UPDATE WRBHBPettyCashHdr SET Flag=1 
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId
	 
		INSERT INTO	WRBHBNewPettyCashApprovalDtl (PettyCashApprovalHdrId,RequestedOn,Requestedby,
		PCAccount,RequestedAmount,RequestedStatus,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,PropertyId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,HeaderId)
		VALUES (@PettyCashApprovalHdrId,@RequestedOn,@Requestedby,@PCAccount,@RequestedAmount,
		@RequestedStatus,'Approved and waiting for transfer',
		CONVERT(NVARCHAR(100),GETDATE(),103),@Comments,@RequestedUserId,@PropertyId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@Id)
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBPettyCashApprovalDtl SET PettyCashApprovalHdrId=@PettyCashApprovalHdrId,
		RequestedOn=@RequestedOn,Requestedby=@Requestedby,PCAccount=@PCAccount,RequestedAmount=@RequestedAmount
		,RequestedStatus=@RequestedStatus,ProcessedStatus='Approved and waiting for transfer',
		LastProcessedon=CONVERT(NVARCHAR(100),GETDATE(),103),
		Comments=@Comments,RequestedUserId=@RequestedUserId,PropertyId=@PropertyId,UserId=@UserId,Process=@Process,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		SELECT Id,RowId FROM WRBHBPettyCashApprovalDtl
		WHERE Id=@Id
 END
END
IF(@ProcessedStatus ='Approved and waiting for transfer')
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
	  SELECT @ErrMsg;
 END
 SET @Id1=(SELECT UserId FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
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
		UPDATE WRBHBPettyCashHdr SET Flag=1 
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId
		
		INSERT INTO	WRBHBNewPettyCashApprovalDtl (PettyCashApprovalHdrId,RequestedOn,Requestedby,
		PCAccount,RequestedAmount,RequestedStatus,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,PropertyId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@PettyCashApprovalHdrId,@RequestedOn,@Requestedby,@PCAccount,@RequestedAmount,
		@RequestedStatus,'Transferred ',
		CONVERT(NVARCHAR(100),GETDATE(),103),@Comments,@RequestedUserId,@PropertyId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID())
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBPettyCashApprovalDtl SET PettyCashApprovalHdrId=@PettyCashApprovalHdrId,
		RequestedOn=@RequestedOn,Requestedby=@Requestedby,PCAccount=@PCAccount,RequestedAmount=@RequestedAmount
		,RequestedStatus=@RequestedStatus,ProcessedStatus='Transferred',LastProcessedon=CONVERT(NVARCHAR(100),GETDATE(),103),
		Comments=@Comments,RequestedUserId=@RequestedUserId,PropertyId=@PropertyId,UserId=@UserId,Process=@Process,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		SELECT Id,RowId FROM WRBHBPettyCashApprovalDtl
		WHERE Id=@Id
END
END
IF(@ProcessedStatus ='Transferred')
BEGIN
 SET @Id1=(SELECT UserId FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
 WHERE UPPER(RequestedUserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
 IF (ISNULL(@Id1,0) =0)
 BEGIN
      SET @ErrMsg = 'Need Resident Manager Approval';
	  SELECT @ErrMsg;
 END
     SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType IN ('Resident Managers','Assistant Resident Managers'))
	 IF(ISNULL(@Str,'') ='')
	 BEGIN
			SET @ErrMsg = 'Need Resident Managers Approval';
			SELECT @ErrMsg;
	 END
 ELSE
 BEGIN
 
		UPDATE WRBHBPettyCashHdr SET Flag=1 
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId
		
		INSERT INTO	WRBHBNewPettyCashApprovalDtl (PettyCashApprovalHdrId,RequestedOn,Requestedby,
		PCAccount,RequestedAmount,RequestedStatus,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,PropertyId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@PettyCashApprovalHdrId,@RequestedOn,@Requestedby,@PCAccount,@RequestedAmount,
		@RequestedStatus,'Acknowledged ',
		CONVERT(NVARCHAR(100),GETDATE(),103),@Comments,@RequestedUserId,@PropertyId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID())
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBPettyCashApprovalDtl SET PettyCashApprovalHdrId=@PettyCashApprovalHdrId,
		RequestedOn=@RequestedOn,Requestedby=@Requestedby,PCAccount=@PCAccount,RequestedAmount=@RequestedAmount
		,RequestedStatus=@RequestedStatus,ProcessedStatus='Acknowledged ',LastProcessedon=CONVERT(NVARCHAR(100),GETDATE(),103),
		Comments=@Comments,RequestedUserId=@RequestedUserId,PropertyId=@PropertyId,UserId=@UserId,Process=@Process,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		SELECT Id,RowId FROM WRBHBPettyCashApprovalDtl
		WHERE Id=@Id
	END

END
IF(@ProcessedStatus ='Acknowledged')
BEGIN
       SET @ErrMsg = 'Waiting For Resident Managers Expense Report';
	   SELECT @ErrMsg;
END
 
  

