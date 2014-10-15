 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagementServices_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagementServices_Update]
GO   
/* 
        Author Name : mini
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
CREATE PROCEDURE [dbo].[Sp_ContractManagementServices_Update] 
	(@EffectiveFrom  nvarchar(100),@Complimentary  bit,
	 @ServiceName  nvarchar(100),  @Price decimal(27,2),
	 @ContractId BIGINT,@ProductId BIGINT,@CreatedBy Bigint,
	 @Enable bit,@Id bigint,@AmountChange bit,@TypeService NVARCHAR(100)) 
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX); 
 
IF EXISTS (SELECT NULL FROM  WRBHBContractManagementServices 
 WHERE UPPER(Price)=UPPER(@Price) AND Id=@Id and ProductId=@ProductId  and IsActive=1 and IsDeleted=0)
 BEGIN
 
 update WRBHBContractManagementServices set  Complimentary=@Complimentary,
ServiceName=@ServiceName,Price=@Price,ProductId=@ProductId,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Enable=@Enable,AmountChange=@AmountChange,TypeService=@TypeService
WHERE Id=@Id and ContractId=@ContractId;
 
  SELECT Id,RowId FROM WRBHBContractManagementServices WHERE Id=@Id;
 END
 ELSE
 BEGIN 
                                 

    UPDATE   WRBHBContractManagementServices SET  
		IsActive=0,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND IsDeleted=0 ;
		
  INSERT INTO WRBHBContractManagementServices(EffectiveFrom,Complimentary,ServiceName,Price,ContractId,ProductId,
                                  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Enable,AmountChange,TypeService)
           VALUES(CONVERT(DATE,@EffectiveFrom,103),@Complimentary,@ServiceName,@Price,@ContractId,@ProductId,          
           @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Enable,1,@TypeService);
 SET  @Identity=@@IDENTITY;
 SELECT Id,RowId FROM WRBHBContractManagementServices WHERE Id=@Identity;
  end
 end