SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagement_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagement_Delete]
GO 
 /* 
       Author Name  :  mini
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT Delete
		Purpose  	: PROPERTY Delete
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
CREATE PROCEDURE Sp_ContractManagement_Delete
(@Id   		BigInt, 
@Pram1		NVARCHAR(100)=NULL, 
@DeleteId   BigInt, --ContractId
@UserId     BigInt
)
AS
BEGIN   
			UPDATE WRBHBContractManagement SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE Id =@Id; 
			UPDATE WRBHBContractManagementTariffAppartment SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE ContractId =@Id;
			UPDATE WRBHBContractManagementAppartment SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE ContractId =@Id;
			UPDATE WRBHBContractManagementServices SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE ContractId =@Id;
			
END



--WRBHBContractManagement 
--WRBHBContractManagementTariffAppartment
--WRBHBContractManagementServices
--WRBHBContarctProductMaster