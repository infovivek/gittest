SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CreditNoteTariff_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteTariff_Insert]
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
CREATE PROCEDURE [dbo].[SP_CreditNoteTariff_Insert](
@CheckOutId INT,
@ChkInVoiceNo NVARCHAR(100),
@CrdInVoiceNo NVARCHAR(100),
@LuxuryTax DECIMAL(27,2),
@ServiceTax1 DECIMAL(27,2),
@ServiceTax2 DECIMAL(27,2),
@TotalAmount DECIMAL(27,2),
@Description NVARCHAR(100),
@CreditNoteNo NVARCHAR(100),
@Createdby INT
)
AS
BEGIN
 
	 DECLARE @TEMPINVOICENO NVARCHAR(100),@PROPERTY NVARCHAR(100);
	 DECLARE @INVOICENO1 NVARCHAR(100),@Length BIGINT;
	 
	 SET @PROPERTY = (SELECT TOP 1 Property FROM WRBHBChechkOutHdr 
	 WHERE PropertyType ='Internal Property' and  Id = @CheckOutId) 
	 
	 SET @TEMPINVOICENO = (SELECT TOP 1 InVoiceNo FROM WRBHBChechkOutHdr 
	 WHERE PropertyType ='Internal Property' and  Id = @CheckOutId 
	 ORDER BY Id DESC)

	 IF ISNULL(@TEMPINVOICENO , '' )= ''
	 BEGIN
		SET @CrdInVoiceNo = SUBSTRING(upper(@PROPERTY),0,4)+'/'+'01'
	 END
	 ELSE
	  BEGIN
	   SET @CrdInVoiceNo =SUBSTRING(@TEMPINVOICENO,0,5)+CAST(SUBSTRING(@TEMPINVOICENO,5,9)+1 AS VARCHAR); 
	 
	 END
	 
	 INSERT INTO WRBHBCreditNoteTariffHdr(CheckOutId,ChkInVoiceNo,CrdInVoiceNo,LuxuryTax,Servicetax1,
	 ServiceTax2,TotAlAmount,Description,IsActive,IsDeleted,Createdby,CreatedDate,
	 Modifiedby,ModifiedDate,RowId,CreditNoteNo)
	 
	 VALUES(@CheckOutId,@ChkInVoiceNo,@CrdInVoiceNo,@LuxuryTax,@ServiceTax1,
	 @ServiceTax2,@TotalAmount,@Description,1,0,@Createdby,GETDATE(),@Createdby,GETDATE(),NEWID(),@CreditNoteNo)
	 
END