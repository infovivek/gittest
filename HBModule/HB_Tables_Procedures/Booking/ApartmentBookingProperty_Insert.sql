SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ApartmentBookingProperty_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ApartmentBookingProperty_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: <Created Date (29/05/2014)  >
Section  	: Apartment Booking Property  Insert 
Purpose  	: Apartment Booking Property Details  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_ApartmentBookingProperty_Insert](
@BookingId BIGINT,
@PropertyName NVARCHAR(100),
@PropertyId BIGINT,
@GetType NVARCHAR(100),
@PropertyType NVARCHAR(100),
@Tariff DECIMAL(27,2),
@Discount DECIMAL(27,2),
@DiscountedTariff DECIMAL(27,2),
@Phone NVARCHAR(100),
@Email NVARCHAR(100),
@Locality NVARCHAR(100),
@LocalityId BIGINT,
@Rs BIT,
@Per BIT,
@DiscountAllowed DECIMAL(27,2),
@UsrId BIGINT) 
AS
BEGIN
 INSERT INTO WRBHBApartmentBookingProperty(BookingId,PropertyName,PropertyId,
 GetType,PropertyType,Tariff,Discount,DiscountedTariff,Phone,Email,Locality,
 LocalityId,Rs,Per,DiscountAllowed,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId)
 VALUES(@BookingId,@PropertyName,@PropertyId,@GetType,@PropertyType,@Tariff,
 @Discount,@DiscountedTariff,@Phone,@Email,@Locality,@LocalityId,@Rs,@Per,
 @DiscountAllowed,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID());
 SELECT Id,RowId FROM WRBHBApartmentBookingProperty WHERE Id=@@IDENTITY;
END
GO
