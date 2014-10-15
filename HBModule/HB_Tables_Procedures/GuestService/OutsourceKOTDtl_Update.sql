SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_OutsourceKOTDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_OutsourceKOTDtl_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 24/05/14 
Section  	 : Guest Service
Purpose  	 : New KOT Entry  (Details)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_OutsourceKOTDtl_Update](@OutsourceKOTHdrId BIGINT,
@ServiceItem NVARCHAR(100),@Quantity INT,@Price DECIMAL(27,2),@Amount DECIMAL(27,2),@ItemId INT,
@CreatedBy BIGINT,@Id BIGINT)

AS
BEGIN
	UPDATE WRBHBOutsourceKOTDtl SET OutsourceKOTHdrId=@OutsourceKOTHdrId,ServiceItem=@ServiceItem,
	Quantity=@Quantity,Price=@Price,Amount=@Amount,
	ItemId= @ItemId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id;

	SELECT Id,RowId FROM WRBHBOutsourceKOTDtl WHERE Id=@Id;
END
GO