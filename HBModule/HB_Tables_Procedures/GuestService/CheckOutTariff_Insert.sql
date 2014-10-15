SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutTariff_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutTariff_Insert]
GO
/*=============================================
Author Name  : Anbu
Modified Date : 21/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutTariff (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutTariff_Insert](
@CheckOutHdrId INT,@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT)
AS
BEGIN
DECLARE @Id INT;
 -- INSERT
INSERT INTO WRBHBCheckOutTariff (ChkOutTariffTotal,ChkOutTariffAdays,
ChkOutTariffDiscount,ChkOutTariffLT,ChkOutTariffST1,ChkOutTariffST2,
ChkOutTariffSC,ChkOutTariffST3,ChkOutTariffCess,ChkOutTariffHECess,
ChkOutTariffNetAmount,ChkOutTariffReferance,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)
VALUES
(@ChkOutTariffTotal,@ChkOutTariffAdays,
@ChkOutTariffDiscount,@ChkOutTariffLT,@ChkOutTariffST1,
@ChkOutTariffST2,@ChkOutTariffSC,@ChkOutTariffST3,
@ChkOutTariffCess,@ChkOutTariffHECess ,@ChkOutTariffNetAmount,
@ChkOutTariffReferance,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

SET @Id=@@IDENTITY;
SELECT Id,RowId FROM WRBHBCheckOutTariff WHERE Id=@Id;
END
GO