SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutTariff_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutTariff_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 21/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutTariff (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutTariff_Update](
@CheckOutHdrId INT,@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy INT,@Id INT)
AS
BEGIN

UPDATE WRBHBCheckOutTariff SET ChkOutTariffTotal=@ChkOutTariffTotal,ChkOutTariffAdays=@ChkOutTariffAdays,
ChkOutTariffDiscount=@ChkOutTariffDiscount,ChkOutTariffLT=@ChkOutTariffLT,ChkOutTariffST1=@ChkOutTariffST1,
ChkOutTariffST2=@ChkOutTariffST2,ChkOutTariffSC=@ChkOutTariffSC,ChkOutTariffST3=@ChkOutTariffST3,
ChkOutTariffCess=@ChkOutTariffCess,ChkOutTariffHECess=@ChkOutTariffHECess,
ChkOutTariffNetAmount=@ChkOutTariffNetAmount,ChkOutTariffReferance=@ChkOutTariffReferance,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBCheckOutTariff WHERE Id=@Id;
END
GO