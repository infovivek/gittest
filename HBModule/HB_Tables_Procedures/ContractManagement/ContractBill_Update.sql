 
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractBill_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractBill_Update]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (1/04/2014)  >
Section  	: CONTRACT BILL Update
Purpose  	: 
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/

CREATE PROCEDURE [dbo].[Sp_ContractBill_Update]
(
@TotalAmount DECIMAL(27,2),
@AdjustmentAmount DECIMAL(27,2),
@Attention NVARCHAR(100),
@ReferenceNo NVARCHAR(100),
@Remarks NVARCHAR(500),
@DueDate NVARCHAR(100),
@ContractId BIGINT,
@CreatedBy BIGINT,
@Id BIGINT,
@LTTax DECIMAL(27,2),
@STTax DECIMAL(27,2),
@Cess DECIMAL(27,2),
@HCess DECIMAL(27,2),
@LTPer DECIMAL(27,2),
@STper DECIMAL(27,2),
@StartDate NVARCHAR(100),
@EndDate NVARCHAR(100)
)
AS
BEGIN
	DECLARE @Tempinvoiceno NVARCHAR(100),@ContractType NVARCHAR(100),@InVoiceNo NVARCHAR(100),
	@Mode NVARCHAR(100);
	SET @ContractType=(SELECT ContractType FROM WRBHBContractManagement WHERE Id=@ContractId)

	SET @Tempinvoiceno = (SELECT TOP 1 InVoiceNo FROM WRBHBInvoiceManagedGHAmount 
		WHERE  IsActive=1 AND IsDeleted=0 AND Type=@ContractType AND ISNULL(InvoiceNo,'')!='' order by Id desc)
		
	
	IF LTRIM(@ContractType)=LTRIM(' Managed Contracts ')
	BEGIN
		SELECT @ContractType='MAN'
		
	END
	ELSE
	BEGIN	
		SELECT @ContractType='DED'
	END
		
	
	IF ISNULL(@Tempinvoiceno , '' )= ''
	BEGIN
		SET @InVoiceNo = SUBSTRING(upper(@ContractType),0,4)+'/'+'1'
	END
	ELSE
	BEGIN
		SET @InVoiceNo = 
		SUBSTRING(@Tempinvoiceno,0,5)+
		CAST(CAST(SUBSTRING(@Tempinvoiceno,5,LEN(@Tempinvoiceno)) AS VARCHAR) + 1 AS VARCHAR); 
	END
	
	
	
	UPDATE WRBHBInvoiceManagedGHAmount set Tax=@LTTax,TotalAmount=@TotalAmount,InvoiceNo=@InVoiceNo,
	AdjustmentAmount=@AdjustmentAmount,Attention=@Attention,ReferenceNo=@ReferenceNo,
	Remarks=@Remarks,DueDate=Convert(date,@DueDate,103),ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
	LTTax=@LTTax,STTax=@STTax,Cess=@Cess,HCess=@HCess,LTPer=@LTPer,STper=@STper,
	EndDate=Convert(date,@EndDate,103),StartDate=Convert(date,@StartDate,103)
	WHERE Id=@Id

	SELECT Id,RowId,SubString(Type,0,3) as Type,ContractId 
	FROM WRBHBInvoiceManagedGHAmount WHERE Id=@Id
END
