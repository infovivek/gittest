 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagementServices_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagementServices_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (11/03/2014)  >
		Section  	: CONTRACT MANAGEMENT 
		Purpose  	: CONTRACT Services
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
CREATE PROCEDURE [dbo].[Sp_ContractManagementServices_Insert] 
	(@EffectiveFrom  nvarchar(100),@Complimentary  bit,
	 @ServiceName  nvarchar(100),  @Price decimal(27,2),
	 @ContractId BIGINT,@ProductId BIGINT,@CreatedBy Bigint,@Enable bit,
	  @AmountChange BIT, @TypeService NVARCHAR(100)) 
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
Declare @ChkedPrice int;
		
 Set @ChkedPrice = (Select PerQuantityprice from WRBHBContarctProductMaster
                      where Id=@ProductId and IsActive=1 and IsDeleted=0) 
 IF EXISTS (SELECT NULL FROM  WRBHBContractManagementServices 
 WHERE UPPER(Price)=UPPER(@ChkedPrice) AND ProductId=@ProductId  and IsActive=1 and IsDeleted=0)
	 BEGIN
	  INSERT INTO WRBHBContractManagementServices(EffectiveFrom,Complimentary,ServiceName,Price,ContractId,ProductId,
									  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
			   VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@ContractId,@ProductId,          
			   @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,@AmountChange,@TypeService);
	  SET  @Identity=@@IDENTITY;
	 SELECT Id,RowId FROM WRBHBContractManagementServices WHERE Id=@Identity;
	 END
 ELSE
	 BEGIN
	 INSERT INTO WRBHBContractManagementServices(EffectiveFrom,Complimentary,ServiceName,Price,ContractId,ProductId,
									  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
			   VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@ContractId,@ProductId,          
			   @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,0,@TypeService);
	SET  @Identity=@@IDENTITY;
	 SELECT Id,RowId FROM WRBHBContractManagementServices WHERE Id=@Identity;
	 END
END
GO 