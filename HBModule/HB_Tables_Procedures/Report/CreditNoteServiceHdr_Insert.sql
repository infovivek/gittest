SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CreditNoteServiceHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CreditNoteServiceHdr_Insert]
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
CREATE PROCEDURE [dbo].[SP_CreditNoteServiceHdr_Insert](
@ChkInVoiceNo NVARCHAR(100),
@CrdInVoiceNo NVARCHAR(100),
@VAT DECIMAL(27,2),
@ServiceTaxFB DECIMAL(27,2),
@ServiceTaxOT DECIMAL(27,2),
@Cess DECIMAL(27,2),
@HECess DECIMAL(27,2),
@TotalAmount DECIMAL(27,2),
@Description NVARCHAR(2000),
@CreditNoteNo NVARCHAR(100),
@ChkOutId BIGINT,
@PropertyId BIGINT,
@Createdby INT
)
AS
BEGIN
 
	 DECLARE @TEMPINVOICENO NVARCHAR(100),@PROPERTY NVARCHAR(100);
	 DECLARE @INVOICENO1 NVARCHAR(100),@Length BIGINT,@ChkInVce NVARCHAR(100);
	 
	 SET @ChkInVce=(SELECT ChkOutInVoiceNo FROM WRBHBCreditNoteServiceHdr WHERE 
	 CheckOutId=@ChkOutId AND ChkOutInVoiceNo=@ChkInVoiceNo)
	 
IF ISNULL(@ChkInVce,'')=''
 BEGIN
	 
	 SET @PROPERTY = (SELECT TOP 1 Property FROM WRBHBChechkOutHdr 
	 WHERE PropertyType ='Internal Property' and  Id = @ChkOutId) 
	 
	 SET @TEMPINVOICENO = (SELECT TOP 1 CrdInVoiceNo FROM WRBHBCreditNoteServiceHdr 
	 WHERE PropertyId=@PropertyId  
	 ORDER BY Id DESC)

	 IF ISNULL(@TEMPINVOICENO , '' )= ''
	 BEGIN
		SET @CrdInVoiceNo = SUBSTRING(upper(@PROPERTY),0,4)+'/'+'01'
	 END
	 ELSE
	  BEGIN
	   SET @CrdInVoiceNo =SUBSTRING(@TEMPINVOICENO,0,5)+CAST(SUBSTRING(@TEMPINVOICENO,5,9)+1 AS VARCHAR); 
	 END
	 
	 
	 
	 INSERT INTO WRBHBCreditNoteServiceHdr(CheckOutId,ChkOutInVoiceNo,CrdInVoiceNo,VAT,ServicetaxFB,
	 ServiceTaxOthers,TotAlAmount,Cess,HECess,Description,IsActive,IsDeleted,Createdby,CreatedDate,
	 Modifiedby,ModifiedDate,RowId,CreditNoteNo,PropertyId)
	 
	 VALUES(@ChkOutId,@ChkInVoiceNo,@CrdInVoiceNo,@VAT,@ServiceTaxFB,
	 @ServiceTaxOT,@TotalAmount,@Cess,@HECess,@Description,1,0,@Createdby,GETDATE(),
	 @Createdby,GETDATE(),NEWID(),@CreditNoteNo,@PropertyId)
	 
	 SELECT Id,RowId,'Service' AS Type FROM WRBHBCreditNoteServiceHdr
	 WHERE Id=@@IDENTITY;
	END
	ELSE
	BEGIN
		 SELECT 0 AS Id,'Exists' AS Type FROM WRBHBCreditNoteTariffHdr
	END
END

