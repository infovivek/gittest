 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Apartment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Apartment_Update]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: Apartment  Insert 
		Purpose  	: Apartment  Insert
		Remarks  	: <Remarks if any>                        
		Reviewed By	: <Reviewed By (Leave it blank)>
	*/            
	/*******************************************************************************************************
	*				AMENDMENT BLOCK
	********************************************************************************************************
	'Name			Date			Signature			Description of Changes
	********************************************************************************************************
	arun			20/6/14			Histroy				History management for Apartment added	
	*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Apartment_Update] (
@PropertyId			bigint,
@BlockId					int,
@BlockName				NVARCHAR(100),
@ApartmentName           NVARCHAR(100),
@ApartmentType		    NVARCHAR(100),
@ApartmentNo		  	NVARCHAR(100),
@SellableApartmentType	NVARCHAR(100), 
@OwnershipType			NVARCHAR(100),
@RackTariff				Decimal(27,2), 
@DiscountModePer		Bit,
@DiscountModeRS			Bit,
@DiscountAllowed		Decimal(27,2), 
@Status		            nvarchar(100), 
@CreatedBy				BigInt,
@Id               Bigint 
) 
AS
BEGIN
DECLARE @Identity int,@IsActive	BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER; 
SELECT @RowId =NEWID(),@IsActive=1,@IsDeleted=0;
--History management for Apartment
INSERT INTO WRBHBPropertyApartmentHistory(PropertyApartmentId,PropertyId,BlockId,BlockName,ApartmentType,
 ApartmentNo,SellableApartmentType,OwnershipType,RackTariff,DiscountModePer,
 DiscountModeRS,Status,ApartmentName,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,DiscountAllowed)
 SELECT Id,PropertyId,BlockId,BlockName,ApartmentType,
 ApartmentNo,SellableApartmentType,OwnershipType,RackTariff,DiscountModePer,
 DiscountModeRS,Status,ApartmentName,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,DiscountAllowed
 FROM WRBHBPropertyApartment WHERE Id=@Id
 
 
UPDATE WRBHBPropertyApartment Set PropertyId=@PropertyId,
BlockId=@BlockId,BlockName=@BlockName,ApartmentType=@ApartmentType,
ApartmentNo=@ApartmentNo,SellableApartmentType=@SellableApartmentType,
OwnershipType=@OwnershipType,RackTariff=@RackTariff,
DiscountModePer=@DiscountModePer,DiscountModeRS=@DiscountModeRS,
@DiscountAllowed=@DiscountAllowed,
Status=@Status,ApartmentName=@ApartmentName,
 ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() 
 WHERE Id=@Id 

SELECT Id , RowId FROM WRBHBPropertyApartment WHERE Id=@Id
END

GO
