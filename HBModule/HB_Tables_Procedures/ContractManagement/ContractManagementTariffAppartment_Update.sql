SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagementTariffAppartment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagementTariffAppartment_Update]
GO  
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (13/03/2014)  >
Section  	: CONTRACTMANAGEMENTTARRIFAPPARTMENT INSERT
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
CREATE PROCEDURE Sp_ContractManagementTariffAppartment_Update
(
@ContractId		BIGINT,
@Place		NVARCHAR(100),
@Property		NVARCHAR(100),
@AttachedBy nvarchar(100),
@Attachedon NVARCHAR(100),
@Detachedon NVARCHAR(100), 
@Detach     BIT,
@CreatedBy  BIGINT,@RoomId Bigint,
@ApartmentId bigint,
@PropertyId BIGINT,
@Tariff     DECIMAL,
@BlockId    bigint,
@Id         Bigint
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
DECLARE @BookingLevel NVARCHAR(100);
SELECT @BookingLevel=BookingLevel FROM WRBHBContractManagement WHERE Id=@ContractId		
IF @BookingLevel='Apartment'
BEGIN
	IF EXISTS (SELECT NULL FROM  WRBHBContractManagementAppartment 
	 WHERE Tariff=@Tariff AND Id=@Id)
	 BEGIN 
	update WRBHBContractManagementAppartment set 
	Place=@Place,Property=@Property,--Attachedon,AttachedBy,Detachedon,Detach,PropertyId,
	Tariff=@Tariff,RoomId=@RoomId,ApartmentId=@ApartmentId, BlockId=@BlockId,
	 ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	 where Id=@Id and ContractId=@ContractId;
	 
	SELECT Id,RowId FROM WRBHBContractManagementTariffAppartment WHERE Id=@Id;

	end
	else
	begin

		UPDATE   WRBHBContractManagementAppartment SET  
			IsActive=0,
			ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND IsDeleted=0 ;

	INSERT INTO WRBHBContractManagementAppartment (
	ContractId,Place,Property,Attachedon,AttachedBy,Detachedon,Detach,PropertyId,Tariff,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, IsActive,IsDeleted,RowId,RoomId,ApartmentId,BlockId)

	VALUES(@ContractId,@Place,@Property,Convert(date,GETDATE(),103),@AttachedBy,Convert(date,GETDATE(),103),@Detach,
	@PropertyId,@Tariff,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@RoomId,@ApartmentId,@BlockId)
	 
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBContractManagementAppartment WHERE Id=@Identity;
	end

END
ELSE
BEGIN	
	IF EXISTS (SELECT NULL FROM  WRBHBContractManagementTariffAppartment 
	 WHERE Tariff=@Tariff AND Id=@Id)
	 BEGIN 
	update WRBHBContractManagementTariffAppartment set 
	Place=@Place,Property=@Property,--Attachedon,AttachedBy,Detachedon,Detach,PropertyId,
	Tariff=@Tariff,RoomId=@RoomId,ApartmentId=@ApartmentId, BlockId=@BlockId,
	 ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	 where Id=@Id and ContractId=@ContractId;
	 
	SELECT Id,RowId FROM WRBHBContractManagementTariffAppartment WHERE Id=@Id;

	end
	else
	begin

		UPDATE   WRBHBContractManagementTariffAppartment SET  
			IsActive=0,
			ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
			WHERE Id=@Id AND IsDeleted=0 ;

	INSERT INTO WRBHBContractManagementTariffAppartment (
	ContractId,Place,Property,Attachedon,AttachedBy,Detachedon,Detach,PropertyId,Tariff,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, IsActive,IsDeleted,RowId,RoomId,ApartmentId,BlockId)

	VALUES(@ContractId,@Place,@Property,Convert(date,GETDATE(),103),@AttachedBy,Convert(date,GETDATE(),103),@Detach,
	@PropertyId,@Tariff,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@RoomId,@ApartmentId,@BlockId)
	 
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBContractManagementTariffAppartment WHERE Id=@Identity;
	end
END	
END
 
 
  