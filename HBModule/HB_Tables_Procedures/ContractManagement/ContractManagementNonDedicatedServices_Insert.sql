SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ContractNonDedicatedServices_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[SP_ContractNonDedicatedServices_Insert]

Go
CREATE PROCEDURE [dbo].[SP_ContractNonDedicatedServices_Insert] 
	(@EffectiveFrom  nvarchar(100),
	 @Complimentary  bit,
	 @ServiceName  nvarchar(100),  
	 @Price decimal(27,2),
	 @NondedContractId BIGINT,
	 @ProductId BIGINT,
	 @CreatedBy Bigint,
	 @Enable bit,
	 @AmountChange bit,
	 @TypeService NVARCHAR(100)) 
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
Declare @ChkedPrice int;
		
 Set @ChkedPrice = (Select PerQuantityprice from WRBHBContarctProductMaster
                      where Id=@ProductId and IsActive=1 and IsDeleted=0) 
 IF EXISTS (SELECT NULL FROM  WRBHBContractManagementServices 
 WHERE UPPER(Price)=UPPER(@ChkedPrice) AND ProductId=@ProductId  and IsActive=1 and IsDeleted=0)
	 BEGIN
	  INSERT INTO WRBHBContractNonDedicatedServices(EffectiveFrom,Complimentary,ServiceName,Price,NondedContractId,ProductId,
						CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
			   VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@NondedContractId,@ProductId,          
			   @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,@AmountChange,@TypeService);
	  SET  @Identity=@@IDENTITY;
	 SELECT Id,RowId FROM WRBHBContractNonDedicatedServices WHERE Id=@Identity;
	 END
 ELSE
	 BEGIN
	 INSERT INTO WRBHBContractNonDedicatedServices(EffectiveFrom,Complimentary,ServiceName,Price,NondedContractId,ProductId,
						CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
			   VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@NondedContractId,@ProductId,          
			   @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,0,@TypeService);
	SET  @Identity=@@IDENTITY;
	 SELECT Id,RowId FROM WRBHBContractNonDedicatedServices WHERE Id=@Identity;
	 END
END
GO 