SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Apartment_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_Apartment_Insert]
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
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Apartment_Insert](@PropertyId BIGINT,@BlockId INT,
@BlockName NVARCHAR(100),@ApartmentName NVARCHAR(100),
@ApartmentType NVARCHAR(100),@ApartmentNo NVARCHAR(100),
@SellableApartmentType NVARCHAR(100),@OwnershipType NVARCHAR(100),
@RackTariff DECIMAL(27,2),@DiscountModePer BIT,@DiscountModeRS BIT,
@DiscountAllowed DECIMAL(27,2),@Status NVARCHAR(100),@CreatedBy BIGINT) 
AS
BEGIN
 --INSERT
 IF EXISTS (SELECT NULL FROM WRBHBPropertyApartment WHERE 
 UPPER(ApartmentNo)=UPPER(@ApartmentNo) AND PropertyId=@PropertyId AND BlockId=@BlockId) 
 BEGIN
 SELECT 'ALREADY EXISTS'
 END
 ELSE
 BEGIN
 INSERT INTO WRBHBPropertyApartment(PropertyId,BlockId,BlockName,ApartmentType,
 ApartmentNo,SellableApartmentType,OwnershipType,RackTariff,DiscountModePer,
 DiscountModeRS,Status,ApartmentName,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,DiscountAllowed)
 VALUES(@PropertyId,@BlockId,@BlockName,@ApartmentType,@ApartmentNo,
 @SellableApartmentType,@OwnershipType,@RackTariff,@DiscountModePer,
 @DiscountModeRS,@Status,@ApartmentName,@CreatedBy,GETDATE(),@CreatedBy,
 GETDATE(),1,0,NEWID(),@DiscountAllowed)
 SELECT Id,RowId FROM WRBHBPropertyApartment WHERE Id=@@IDENTITY
 END
END
GO
