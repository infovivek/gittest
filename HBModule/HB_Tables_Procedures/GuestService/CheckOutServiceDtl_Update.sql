SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutServiceDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutServiceDtl_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 19/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Detail)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutServiceDtl_Update](
@CheckOutServceHdrId INT,
@ChkOutSerAction BIT,@ChkOutSerInclude BIT,
@ChkOutSerDate NVARCHAR(100),@ChkOutSerItem NVARCHAR(100),@ChkOutSerAmount DECIMAL(27,2),
@ChkOutSerQuantity INT,@ChkOutSerNetAmount DECIMAL(27,2),
@CreatedBy BIGINT,@Id INT)
AS
BEGIN
UPDATE WRBHBCheckOutServiceDtls SET CheckOutServceHdrId=@CheckOutServceHdrId,ChkOutSerAction=@ChkOutSerAction,
ChkOutSerInclude=@ChkOutSerInclude,ChkOutSerDate=@ChkOutSerDate,ChkOutSerItem=@ChkOutSerItem,ChkOutSerAmount=
@ChkOutSerAmount,ChkOutserQuantity=@ChkOutSerQuantity,ChkOutSerNetAmount=@ChkOutSerNetAmount,ModifiedBy=@CreatedBy,
ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBCheckOutServiceDtls WHERE Id=@Id;
END
GO