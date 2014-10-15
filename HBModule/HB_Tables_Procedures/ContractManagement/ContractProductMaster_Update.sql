SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractProductMaster_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractProductMaster_Update]
GO   

/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACTPRODUCTMASTER UPDATE
Purpose  	: PRODUCT UPDATE
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
CREATE PROCEDURE [dbo].[Sp_ContractProductMaster_Update]
(
@EffectiveFrom		NVARCHAR(100),
@ContractRate		BIT,
@IsComplimentary	BIT,
@TypeService		NVARCHAR(100),
@ProductName		NVARCHAR(100),
@BasePrice			DECIMAL(27,2),
@PerQuantityprice	DECIMAL(27,2),
@CreatedBy			BIGINT,
@Id					INT,
@Enable				BIT,
@SubType        NVARCHAR(100),
@SubTypeId        INT,
@AmountChange		BIT
)
AS
BEGIN

IF EXISTS (SELECT NULL FROM WRBHBContarctProductMaster 
WHERE PerQuantityprice=@PerQuantityprice AND Id=@Id)
--IF(PerQuantityprice=@PerQuantityprice FROM WRBHBContarctProductMaster WHERE Id=@Id)

BEGIN
UPDATE WRBHBContarctProductMaster SET EffectiveFrom=Convert(date,@EffectiveFrom,103),ContractRate=@ContractRate,
IsComplimentary=@IsComplimentary,TypeService=@TypeService,ProductName=@ProductName,BasePrice=@BasePrice,
PerQuantityprice=@PerQuantityprice,ModifiedBy=@CreatedBy,Enable=@Enable,AmountChange=@AmountChange,
SubTypeId=@SubTypeId
WHERE Id=@Id and IsActive=1 and IsDeleted=0;

UPDATE WRBHBContractProductSubMaster SET SubType=@SubType
WHERE Id=@SubTypeId

select Id,RowId From WRBHBContarctProductMaster 
where Id=@Id;

END

ELSE

BEGIN
	UPDATE WRBHBContarctProductMaster SET EffectiveFrom=Convert(date,@EffectiveFrom,103),ContractRate=@ContractRate,
	IsComplimentary=@IsComplimentary,TypeService=@TypeService,ProductName=@ProductName,BasePrice=@BasePrice,
	PerQuantityprice=@PerQuantityprice,ModifiedBy=@CreatedBy,Enable=@Enable,AmountChange=@AmountChange,
	SubTypeId=@SubTypeId
	WHERE Id=@Id  and IsActive=1 and IsDeleted=0
	
	UPDATE WRBHBContractProductSubMaster SET SubType=@SubType
	Where Id=@SubTypeId
	--select Id,RowId From WRBHBContarctProductMaster 	where Id=@Id;
	
		--IF EXISTS (SELECT NULL FROM WRBHBContractManagementServices WHERE ProductId=@Id)
		--BEGIN
			UPDATE WRBHBContractManagementServices SET Price=@PerQuantityprice 
			WHERE AmountChange =0 AND ProductId= @Id and IsActive=1;
			
            update WRBHBContractNonDedicatedServices SET Price=@PerQuantityprice 
			WHERE AmountChange =0 AND ProductId= @Id and IsActive=1;
			
            --update WRBHBSSPCodeGenerationServices  SET Price=@PerQuantityprice 
			--WHERE  ProductId= @Id and IsActive=1;
			
			select Id,RowId From WRBHBContarctProductMaster 
			where Id=@Id;
	--	END
END
END


