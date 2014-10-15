SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_VendorChequeApprovalDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_VendorChequeApprovalDtl_Update]

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
CREATE PROCEDURE [dbo].[SP_VendorChequeApprovalDtl_Update]
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
@CreatedBy INT,
@Id INT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX),@Id1 int,@Str NVARCHAR(100);
IF(@Status ='Approved by reporting authority')
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
	WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
 BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
      SELECT @ErrMsg;
 END
	  SET @Id1=(SELECT UserId FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
	  WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
 IF(@Id1 !=0)
 BEGIN
      SET @ErrMsg = 'Need Operations Head Approval';
	  SELECT @ErrMsg;
 END
 SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Ops Head')
	
	 IF(ISNULL(@Str,'')!='Ops Head')
	 BEGIN
			SET @ErrMsg = 'Need Operations Head Approval';
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
		'Approved and waiting for Payment Release',CONVERT(NVARCHAR(100),GETDATE(),103),@Processedby,@RequestedUserId,@UserId,
		@Process,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@PropertyId)	
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBVendorChequeApprovalDtl SET VendorChequeApprovalHdrId=@VendorChequeApprovalHdrId,
		RequestedOn=@RequestedOn,Requestedby=@Requestedby,RequestedAmount=@RequestedAmount
		,Status='Approved and waiting for Payment Release',Processedon=CONVERT(NVARCHAR(100),GETDATE(),103),
		Processedby=@Processedby,RequestedUserId=@RequestedUserId,UserId=@UserId,Process=@Process,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		
		SELECT Id,RowId FROM WRBHBVendorChequeApprovalDtl
		WHERE Id=@Id
 END
END
IF(@Status ='Approved and waiting for Payment Release')
BEGIN
IF EXISTS (SELECT NULL FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
	WHERE UPPER(@UserId) = UPPER(@RequestedUserId))
BEGIN
      SET @ErrMsg = 'Requestor and Approver cannot be same';
      SELECT @ErrMsg;
END
      SET @Id1=(SELECT UserId FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
      WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
IF(@Id1 !=0)
BEGIN
      SET @ErrMsg = 'Need Finance Manager Approval';
	  SELECT @ErrMsg;
	  
END
SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Finance')
	
	 IF(ISNULL(@Str,'')!='Finance')
	 BEGIN
			SET @ErrMsg = 'Need Finance Manager Approval';
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
		'Payment Released ',CONVERT(NVARCHAR(100),GETDATE(),103),@Processedby,@RequestedUserId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
		,@CreatedBy,GETDATE(),NEWID(),@PropertyId)	
		
		SET  @Identity=@@IDENTITY
		
		UPDATE WRBHBVendorChequeApprovalDtl SET VendorChequeApprovalHdrId=@VendorChequeApprovalHdrId,
		RequestedOn=@RequestedOn,Requestedby=@Requestedby,RequestedAmount=@RequestedAmount
		,Status='Payment Released',Processedon=CONVERT(NVARCHAR(100),GETDATE(),103),
		Processedby=@Processedby,RequestedUserId=@RequestedUserId,UserId=@UserId,Process=@Process,ModifiedBy=@CreatedBy,
		ModifiedDate=GETDATE()
		WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		
		SELECT Id,RowId FROM WRBHBVendorChequeApprovalDtl
		WHERE Id=@Id
END
END
IF(@Status ='Payment Released')
BEGIN
	SET @Id1=(SELECT UserId FROM WRBHBVendorChequeApprovalDtl WITH (NOLOCK) 
	WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND Id=@Id)
	IF(@Id1 !=0)
	BEGIN
      SET @ErrMsg = 'Need Resident Manager Approval';
	  SELECT @ErrMsg;
 END
  SET @Str=(SELECT UserType FROM WRBHBPropertyUsers WITH (NOLOCK) 
	 WHERE UPPER(UserId) = UPPER(@UserId) AND IsActive=1 AND IsDeleted=0 AND PropertyId=@PropertyId
	 AND UserType='Resident Managers')
	 IF(ISNULL(@Str,'') !='Resident Managers')
	 BEGIN
			SET @ErrMsg = 'Need Resident Manager Approval';
			SELECT @ErrMsg;
	 END
 ELSE
 BEGIN
 
	UPDATE WRBHBVendorRequest SET Flag=0 
	WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId
	
	UPDATE WRBHBVendorChequeApprovalDtl SET Process=0 
	WHERE IsActive=1 AND IsDeleted=0 AND UserId=@RequestedUserId

	INSERT INTO	WRBHBVendorChequeApprovalNewDtl (VendorChequeApprovalHdrId,RequestedOn,Requestedby,
	RequestedAmount,Status,Processedon,Processedby,
	RequestedUserId,UserId,Process,IsActive,IsDeleted,CreatedBy,
	CreatedDate,ModifiedBy,ModifiedDate,RowId,PropertyId)
	VALUES (@VendorChequeApprovalHdrId,@RequestedOn,@Requestedby,@RequestedAmount,
	'Acknowledged',CONVERT(NVARCHAR(100),GETDATE(),103),@Processedby,@RequestedUserId,@UserId,@Process,1,0,@CreatedBy,GETDATE()
	,@CreatedBy,GETDATE(),NEWID(),@PropertyId)	
	
	SET  @Identity=@@IDENTITY
	
	UPDATE WRBHBVendorChequeApprovalDtl SET VendorChequeApprovalHdrId=@VendorChequeApprovalHdrId,
	RequestedOn=@RequestedOn,Requestedby=@Requestedby,RequestedAmount=@RequestedAmount
	,Status='Acknowledged',Processedon=CONVERT(NVARCHAR(100),GETDATE(),103),
	Processedby=@Processedby,RequestedUserId=@RequestedUserId,UserId=@UserId,Process=@Process,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
	
	SELECT Id,RowId FROM WRBHBVendorChequeApprovalDtl
	WHERE Id=@Id
END
END
IF(@Status ='Acknowledged')
BEGIN
       SET @ErrMsg = 'Waiting For Resident Managers Expense Report';
	  SELECT @ErrMsg;
END
END
