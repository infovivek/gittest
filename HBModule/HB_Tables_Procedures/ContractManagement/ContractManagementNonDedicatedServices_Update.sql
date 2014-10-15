SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'SP_ContractNonDedicatedServices_Update') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE SP_ContractNonDedicatedServices_Update

Go
CREATE PROCEDURE SP_ContractNonDedicatedServices_Update 
	(@EffectiveFrom  nvarchar(100),
	 @Complimentary  bit,
	 @ServiceName  nvarchar(100),  
	 @Price decimal(27,2),
	 @NondedContractId BIGINT,
	 @ProductId BIGINT,
	 @CreatedBy Bigint,
	 @Enable bit,@Id bigint,
	 @AmountChange bit,
	 @TypeService NVARCHAR(100)) 
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX); 
 
IF EXISTS (SELECT NULL FROM  WRBHBContractNonDedicatedServices 
 WHERE UPPER(Price)=UPPER(@Price) AND Id=@Id and ProductId=@ProductId  and IsActive=1 and IsDeleted=0)
 BEGIN
 
 update WRBHBContractNonDedicatedServices set  Complimentary=@Complimentary,
ServiceName=@ServiceName,Price=@Price,ProductId=@ProductId,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Enable=@Enable,AmountChange=@AmountChange
WHERE Id=@Id and NondedContractId=@NondedContractId;
 
  SELECT Id,RowId FROM WRBHBContractNonDedicatedServices WHERE Id=@Id;
 END
 ELSE
 BEGIN 
                                 

    UPDATE   WRBHBContractNonDedicatedServices SET  
		IsActive=0,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND IsDeleted=0 ;
		
  INSERT INTO WRBHBContractNonDedicatedServices(EffectiveFrom,Complimentary,ServiceName,Price,NondedContractId,ProductId,
                                  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
           VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@NondedContractId,@ProductId,          
           @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,1,@TypeService);
 SET  @Identity=@@IDENTITY;
 SELECT Id,RowId FROM WRBHBContractNonDedicatedServices WHERE Id=@Identity;
  end
 end