
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutServiceHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutServiceHdr_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 19/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutServiceHdr_Update](
@CheckOutHdrId INT,
@ChkOutServiceAmtl DECIMAL(27,2),@ChkOutServiceVat DECIMAL(27,2),
@ChkOutServiceLT DECIMAL(27,2),@ChkOutServiceST DECIMAL(27,2),
@Cess DECIMAL(27,2),@HECess DECIMAL(27,2),@CheckOutNetAmount DECIMAL(27,2),
@CreatedBy BIGINT,@Id INT)
AS
BEGIN

UPDATE WRBHBCheckOutServiceHdr SET CheckOutHdrId = @CheckOutHdrId,ChkOutServiceAmtl =@ChkOutServiceAmtl,
ChkOutserviceVat=@ChkOutserviceVat ,ChkOutServiceLT=@ChkOutServiceLT,ChkOutserviceST=@ChkOutServiceST,
Cess=@Cess,HECess=@HECess,
ChkOutServiceNetAmount=@CheckOutNetAmount,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBCheckOutServiceHdr WHERE Id=@Id;
END
GO