
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutServiceHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutServiceHdr_Insert]
GO
/*=============================================
Author Name  : Anbu
Modified Date : 21/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutServiceHdr_Insert](
@CheckOutHdrId INT,
@ChkOutServiceAmtl DECIMAL(27,2),@ChkOutServiceVat DECIMAL(27,2),
@ChkOutServiceLT DECIMAL(27,2),@ChkOutServiceST DECIMAL(27,2),
@Cess DECIMAL(27,2),@HECess DECIMAL(27,2),
@CheckOutNetAmount DECIMAL(27,2),@MiscellaneousRemarks NVARCHAR(100),
@MiscellaneousAmount DECIMAL(27,2),
@CreatedBy BIGINT,@OtherService DECIMAL(27,2))

AS
BEGIN
DECLARE @Id1 INT,@GuestName NVARCHAR(100);
SET @GuestName = (SELECT GuestName FROM WRBHBChechkOutHdr WHERE Id = @CheckOutHdrId)
 -- INSERT
INSERT INTO WRBHBCheckOutServiceHdr(CheckOutHdrId,ChkOutServiceAmtl,
ChkOutServiceVat,ChkOutServiceLT,ChkOutServiceST,Cess,HECess,
ChkOutServiceNetAmount,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,PaymentStatus,
MiscellaneousRemarks,MiscellaneousAmount,OtherService)

VALUES
(@CheckOutHdrId,@ChkOutServiceAmtl,@ChkOutServiceVat,@ChkOutServiceLT,@ChkOutServiceST,@Cess,@HECess,
@CheckOutNetAmount,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),'UnPaid',@MiscellaneousRemarks,
@MiscellaneousAmount,@OtherService)

SET @Id1=@@IDENTITY;
SELECT CheckOutHdrId as Id,Id RowId FROM WRBHBCheckOutServiceHdr WHERE Id=@Id1;

-- this table use to bill no wise		

		INSERT INTO WRBHBCheckOutDtls(CheckOutId,GuestName,BillType,BillAmount,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
		
		VALUES(@CheckOutHdrId,@GuestName,'Service',@CheckOutNetAmount,@CreatedBy,GETDATE(),@CreatedBy,
		GETDATE(),1,0,NEWID())
END
GO
 
