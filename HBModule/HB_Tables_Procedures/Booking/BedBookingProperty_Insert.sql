SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BedBookingProperty_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BedBookingProperty_Insert]
GO   
/* 
Author Name : Sakthi
Created On 	: <Created Date (29/05/2014)  >
Section  	: bed Booking Property  Insert 
Purpose  	: bed Booking Property Details  Insert
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
CREATE PROCEDURE [dbo].[SP_BedBookingProperty_Insert](
@BookingId BIGINT,
@PropertyName NVARCHAR(100),
@PropertyId BIGINT,
@GetType NVARCHAR(100),
@PropertyType NVARCHAR(100),
@Tariff DECIMAL(27,2),
@Phone NVARCHAR(100),
@Email NVARCHAR(100),
@Locality NVARCHAR(100),
@LocalityId BIGINT,
@UsrId BIGINT,
--
@Rs BIT,
@Per BIT,
@DiscountAllowed DECIMAL(27,2),
@Discount DECIMAL(27,2),
@DiscountTariff DECIMAL(27,2)) 
AS
BEGIN
 INSERT INTO WRBHBBedBookingProperty(BookingId,PropertyName,PropertyId,
 GetType,PropertyType,Tariff,Phone,Email,Locality,LocalityId,CreatedBy,
 CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
 Rs,Per,DiscountAllowed,Discount,DiscountTariff)
 VALUES(@BookingId,@PropertyName,@PropertyId,@GetType,@PropertyType,
 @Tariff,@Phone,@Email,@Locality,@LocalityId,@UsrId,GETDATE(),@UsrId,
 GETDATE(),1,0,NEWID(),@Rs,@Per,@DiscountAllowed,@Discount,@DiscountTariff);
 SELECT Id,RowId FROM WRBHBBedBookingProperty WHERE Id=@@IDENTITY; 
/* -- NON DEDICATED PROPERTY 
 CREATE TABLE #BED21(PropertyId BIGINT,Tariff DECIMAL(27,2));
 INSERT INTO #BED21(PropertyId,Tariff)
 SELECT D.PropertyId,D.BedTarif FROM WRBHBContractNonDedicated H
 LEFT OUTER JOIN WRBHBContractNonDedicatedApartment D WITH(NOLOCK)ON
 D.NondedContractId=H.Id
 LEFT OUTER JOIN WRBHBProperty P WITH(NOLOCK)ON P.Id=D.PropertyId
 WHERE H.IsDeleted=0 AND H.IsActive=1 AND D.IsActive=1 AND 
 D.IsDeleted=0 AND P.Category='Internal Property' AND
 H.ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId) AND 
 P.CityId=(SELECT CityId FROM WRBHBBooking WHERE Id=@BookingId) AND
 P.Id=@PropertyId AND D.BedTarif=@Tariff;
 --
 SELECT PropertyName AS label,Id FROM WRBHBProperty WHERE Id=@PropertyId;
 --
 SELECT PB.BlockName+' - '+A.ApartmentNo+' - '+R.RoomNo+' - '+
 CAST(B.Id AS VARCHAR) AS label,R.Id AS RoomId,B.Id AS BedId,
 ND.Tariff FROM WRBHBProperty P
 LEFT OUTER JOIN WRBHBPropertyBlocks PB WITH(NOLOCK)ON PB.PropertyId=P.Id
 LEFT OUTER JOIN WRBHBPropertyApartment A WITH(NOLOCK)ON
 A.PropertyId=P.Id AND A.BlockId=PB.Id
 LEFT OUTER JOIN WRBHBPropertyRooms R WITH(NOLOCK)ON 
 R.PropertyId=P.Id AND R.ApartmentId=A.Id
 LEFT OUTER JOIN WRBHBPropertyRoomBeds B WITH(NOLOCK)ON 
 B.RoomId=R.Id
 LEFT OUTER JOIN #BED21 ND WITH(NOLOCK)ON ND.PropertyId=P.Id
 WHERE P.IsActive=1 AND P.IsDeleted=0 AND PB.IsActive=1 AND
 PB.IsDeleted=0 AND A.IsActive=1 AND A.IsDeleted=0 AND R.IsActive=1 AND 
 R.IsDeleted=0 AND B.IsActive=1 AND B.IsDeleted=0 AND
 P.Category='Internal Property' AND P.Id = ND.PropertyId AND
 A.SellableApartmentType != 'HUB' AND 
 P.CityId=(SELECT CityId FROM WRBHBBooking WHERE Id=@BookingId) AND 
 P.Id=@PropertyId;
 --*/
END
GO
