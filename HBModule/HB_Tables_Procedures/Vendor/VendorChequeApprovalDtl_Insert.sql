SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_VendorChequeApprovalDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_VendorChequeApprovalDtl_Insert]

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
CREATE PROCEDURE [dbo].[SP_VendorChequeApprovalDtl_Insert]
(
@VendorChequeApprovalHdrId INT,
@RequestedOn NVARCHAR(100),
@Requestedby NVARCHAR(100),
@RequestedAmount DECIMAL(27,2),
@Status NVARCHAR(100),
@Processedon NVARCHAR(100),
@Processedby NVARCHAR(100),
@Process   BIT,
@UserId   INT,
@RequestedUserId   INT,
@PropertyId   INT,
@CreatedBy INT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX),@Str NVARCHAR(100);
IF(@Status ='Waiting For Operation Manager Approval')
BEGIN
	IF EXISTS (SELECT NULL FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
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
	     UPDATE WRBHBVendorRequest SET Flag=0 
		 WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId
		
		INSERT INTO	WRBHBVendorChequeApprovalNewDtl (VendorChequeApprovalHdrId,RequestedOn,Requestedby,
		RequestedAmount,Status,Processedon,Processedby,
		RequestedUserId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,PropertyId)
		VALUES (@VendorChequeApprovalHdrId,@RequestedOn,@Requestedby,@RequestedAmount,
		'Approved by reporting authority',CONVERT(NVARCHAR(100),GETDATE(),103),@Processedby,@RequestedUserId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@PropertyId)	

		INSERT INTO	WRBHBVendorChequeApprovalDtl (VendorChequeApprovalHdrId,RequestedOn,Requestedby,
		RequestedAmount,Status,Processedon,Processedby,
		RequestedUserId,UserId,Process,IsActive,IsDeleted,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,RowId,PropertyId)
		VALUES (@VendorChequeApprovalHdrId,@RequestedOn,@Requestedby,@RequestedAmount,
		'Approved by reporting authority',CONVERT(NVARCHAR(100),GETDATE(),103),@Processedby,@RequestedUserId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@PropertyId)	
	
		SELECT Id,RowId FROM WRBHBVendorChequeApprovalDtl WHERE Id=@@IDENTITY;
	END
END
END
	



