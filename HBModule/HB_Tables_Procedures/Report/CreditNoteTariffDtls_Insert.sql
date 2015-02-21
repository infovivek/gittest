SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CreditNoteTariffDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteTariffDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 08/05/14 
Section  	 : Search Invoice
Purpose  	 : CreditNote Against CheckOut Tariff
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CreditNoteTariffDtl_Insert](

@CrdTariffHdrId Int,
@Type NVARCHAR(100),
@Amount DECIMAL(27,2),
@NoOfDays INT,
@Total DECIMAL(27,2),
@Createdby INT
)
AS
BEGIN
  
	 INSERT INTO WRBHBCreditNoteTariffDtls(CrdTariffHdrId,Type,Amount,NoOfDays,Total,
	 IsActive,IsDeleted,Createdby,CreatedDate,Modifiedby,ModifiedDate,RowId)
	 
	 VALUES(@CrdTariffHdrId,@Type,@Amount,@NoOfDays,@Total,1,0,@Createdby,GETDATE(),
	 @Createdby,GETDATE(),NEWID())
	 
	 SELECT Id,RowId FROM WRBHBCreditNoteTariffDtls WHERE Id=@@IDENTITY;
END