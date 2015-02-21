SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashApprovalDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[Sp_PettyCashApprovalDtl_Insert]

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
CREATE PROCEDURE [dbo].[Sp_PettyCashApprovalDtl_Insert]
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
@Process   BIT,
@UserId   INT,@PropertyId   INT,
@CreatedBy INT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX),@Str NVARCHAR(100);
 
 IF(@ProcessedStatus ='Waiting For Operation Manager Approval')
 BEGIN
	 IF EXISTS (SELECT NULL FROM WRBHBPettyCashApprovalDtl WITH (NOLOCK) 
	 WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
	 BEGIN
	  
			SET @ErrMsg = 'Requestor and Approver cannot be same';
			SELECT @ErrMsg;
	 END
	 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Operations Managers')
	
	 IF ISNULL(@Str,'') !='Operations Managers'
	 BEGIN
			SET @ErrMsg = 'Need Operations Manager Approval';
			SELECT @ErrMsg;
	 END
 
 ELSE
 BEGIN

		UPDATE WRBHBPettyCashHdr SET Flag=1 
		WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId AND Date=CONVERT(Date,@RequestedOn,103)
		
		INSERT INTO	WRBHBPettyCashApprovalDtl (PettyCashApprovalHdrId,RequestedOn,Requestedby,
		PCAccount,RequestedAmount,RequestedStatus,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,UserId,PropertyId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@PettyCashApprovalHdrId,@RequestedOn,@Requestedby,@PCAccount,@RequestedAmount,
		@RequestedStatus,'Approved by reporting authority',
		CONVERT(NVARCHAR(100),GETDATE(),103),@Comments,@RequestedUserId,@UserId,@PropertyId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID())	
		
		SELECT Id,RowId FROM WRBHBPettyCashApprovalDtl WHERE Id=@@IDENTITY;
	
		DECLARE @Id1 int
		SET @Id1=(SELECT Id FROM WRBHBPettyCashApprovalDtl WHERE Id=@@IDENTITY)
	
		INSERT INTO	WRBHBNewPettyCashApprovalDtl (PettyCashApprovalHdrId,RequestedOn,Requestedby,
		PCAccount,RequestedAmount,RequestedStatus,ProcessedStatus,LastProcessedon,Comments,
		RequestedUserId,UserId,PropertyId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,HeaderId)
		VALUES (@PettyCashApprovalHdrId,@RequestedOn,@Requestedby,@PCAccount,@RequestedAmount,
		@RequestedStatus,'Approved by reporting authority',
		CONVERT(NVARCHAR(100),GETDATE(),103),@Comments,@RequestedUserId,@UserId,@PropertyId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@Id1)
 END
 END
 END