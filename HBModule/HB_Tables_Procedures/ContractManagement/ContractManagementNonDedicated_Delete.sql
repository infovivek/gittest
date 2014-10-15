SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_ContractNonDedicated_Delete') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_ContractNonDedicated_Delete
GO 
 
CREATE PROCEDURE Sp_ContractNonDedicated_Delete
(@Id   		BigInt, 
@Pram1		NVARCHAR(100)=NULL, 
@DeleteId   BigInt, --ContractId
@UserId     BigInt
)
AS
BEGIN   
			UPDATE WRBHBContractNonDedicated SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE Id =@Id; 
			UPDATE WRBHBContractNonDedicatedApartment SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE NondedContractId =@Id;
			UPDATE WRBHBContractNonDedicatedServices SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE NondedContractId =@Id;
END


