SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CreditNoteServiceDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteServiceDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 05/02/15 
Section  	 : Search Invoice
Purpose  	 : CreditNote Against CheckOut Service
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CreditNoteServiceDtl_Insert](

@CrdServiceHdrId Int,
@Type NVARCHAR(100),
@ServiceAmount DECIMAL(27,2),
@Quantity DECIMAL(27,2),
@Total DECIMAL(27,2),
@Createdby INT
)
AS
BEGIN
  
   
   
	 INSERT INTO WRBHBCreditNoteServiceDtls(CrdServiceHdrId,Type,ServiceAmount,Quantity,Total,
	 IsActive,IsDeleted,Createdby,CreatedDate,ModifedBy,ModifiedDate,RowId)
	 
	 VALUES(@CrdServiceHdrId,@Type,@ServiceAmount,@Quantity,@Total,1,0,@Createdby,GETDATE(),
	 @Createdby,GETDATE(),NEWID())
	 
	 SELECT Id,RowId FROM WRBHBCreditNoteServiceDtls WHERE Id=@@IDENTITY;
END