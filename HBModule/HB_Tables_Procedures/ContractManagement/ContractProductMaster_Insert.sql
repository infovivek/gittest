SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractProductMaster_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractProductMaster_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACTPRODUCTMASTER INSERT
Purpose  	: PRODUCT INSERT
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
CREATE PROCEDURE [dbo].[Sp_ContractProductMaster_Insert]
(
@EffectiveFrom		NVARCHAR(100),
@ContractRate		BIT,
@IsComplimentary	BIT,
@TypeService		NVARCHAR(100),
@ProductName		NVARCHAR(100),
@BasePrice			DECIMAL(27,2),
@PerQuantityprice	DECIMAL(27,2),
@CreatedBy			BIGINT,
@Enable				BIT,
@SubType		NVARCHAR(100),
@SubTypeId			INT,
@AmountChange		BIT
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
IF Exists(SELECT Id FROM WRBHBContractProductSubMaster 
		  WHERE Id =@SubTypeId)
BEGIN
    UPDATE WRBHBContractProductSubMaster SET SubType=@SubType
	Where Id=@SubTypeId             
END 
ELSE
BEGIN
	INSERT INTO WRBHBContractProductSubMaster (SubType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
				IsActive,IsDeleted,RowId)
	VALUES(@SubType,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())			
END

BEGIN 
 INSERT INTO WRBHBContarctProductMaster (EffectiveFrom,ContractRate,IsComplimentary,
 TypeService,ProductName,BasePrice,PerQuantityprice,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
 IsActive,IsDeleted,RowId,Enable,AmountChange,SubTypeId)
 VALUES(Convert(date,@EffectiveFrom,103),@ContractRate,@IsComplimentary,@TypeService,@ProductName,@BasePrice,
 @PerQuantityprice,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,0,@SubTypeId)
 
 SET  @Identity=@@IDENTITY
SELECT Id,RowId FROM WRBHBContarctProductMaster WHERE Id=@Identity;
 END
 END