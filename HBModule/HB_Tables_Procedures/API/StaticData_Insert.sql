--DROP PROCEDURE Sp_StaticData_Insert;
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_StaticData_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_StaticData_Insert]
GO 
/*     
Author Name : <ARUNPRASATH.k>    
Created On  : <Created Date (26/07/2014)  >    
Section   : StaticData  Insert     
Purpose   : StaticData  Insert    
Remarks   : <Remarks if any>                            
Reviewed By : <Reviewed By (Leave it blank)>    
*/                
/*******************************************************************************************************    
*    AMENDMENT BLOCK    
********************************************************************************************************    
'Name   Date   Signature   Description of Changes    
********************************************************************************************************     
*******************************************************************************************************    
*/    
CREATE PROCEDURE [dbo].[Sp_StaticData_Insert](    
@HotalId    NVARCHAR(100),    
@City     NVARCHAR(100),    
@CityCode    NVARCHAR(100),    
@Country    NVARCHAR(100),    
@CountryCode   NVARCHAR(100),    
@Line1     NVARCHAR(100),    
@Area     NVARCHAR(MAX),    
@Line2     NVARCHAR(100),    
@Pincode    NVARCHAR(100),    
--@AlternateName   NVARCHAR(100),    
@DateUpdated   NVARCHAR(100),    
@State     NVARCHAR(100),    
@Latitude    NVARCHAR(100),    
@Longitude    NVARCHAR(100),    
@Email     NVARCHAR(100),    
--@Fax     NVARCHAR(100),    
--@Mobile     NVARCHAR(100),    
@ContactPerson   NVARCHAR(100),    
@Phone     NVARCHAR(100),    
--@Facility    NVARCHAR(MAX),    
@CheckOutTime   NVARCHAR(100),    
@CheckInTime   NVARCHAR(100),    
--@Contact    NVARCHAR(100),    
--@Currency    NVARCHAR(100),    
@Description   NVARCHAR(250),    
@HotalName    NVARCHAR(100),    
--@Overallrating   NVARCHAR(100),    
--@Recommended   NVARCHAR(100),    
@StarRating    NVARCHAR(100),    
--@TotalRating   NVARCHAR(100),    
--@TotalReviews   NVARCHAR(100),    
@WebAddress    NVARCHAR(100),    
@TwentyFourHourCheckinAllowed NVARCHAR(100),    
@Image     NVARCHAR(MAX),    
--@Amenity    NVARCHAR(100)=NULL ,
@HotelCount   INT
)     
AS    
BEGIN    
 --INSERT
 IF EXISTS (SELECT NULL FROM WRBHBStaticHotels WHERE IsActive = 1 AND 
 IsDeleted = 0 AND CityCode = @CityCode AND HotalId = @HotalId)
  BEGIN
   UPDATE WRBHBStaticHotels SET Area = @Area,City = @City,Country = @Country,
   CountryCode = @CountryCode, Line1 = @Line1,Line2 = @Line2,Pincode = @Pincode,
   DateUpdated = @DateUpdated,State = @State,Email = @Email,
   ContactPerson = @ContactPerson,Phone = @Phone,CheckOutTime = @CheckOutTime,
   CheckInTime = @CheckInTime,Description = @Description,
   HotalName = @HotalName,StarRating = @StarRating,
   TwentyFourHourCheckinAllowed = @TwentyFourHourCheckinAllowed,
   WebAddress = @WebAddress,Image = @Image,ModifiedDate = GETDATE(),
   Latitude = @Latitude,Longitude = @Longitude
   WHERE IsActive = 1 AND IsDeleted = 0 AND CityCode = @CityCode AND 
   HotalId = @HotalId;
   SELECT Id,RowId FROM WRBHBStaticHotels
   WHERE IsActive = 1 AND IsDeleted = 0 AND CityCode = @CityCode AND 
   HotalId = @HotalId;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBStaticHotels(HotalId,Area,City,CityCode,Country,CountryCode,
   Line1,Line2,Pincode,DateUpdated,State,Email,ContactPerson,Phone,CheckOutTime,
   CheckInTime,Description,HotalName,StarRating,TwentyFourHourCheckinAllowed,
   WebAddress,Image,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
   IsActive,IsDeleted,RowId,HotelCount,Latitude,Longitude)
   VALUES(@HotalId,@Area,@City,@CityCode,@Country,@CountryCode,@Line1,
   @Line2,@Pincode,@DateUpdated,@State,@Email,@ContactPerson,@Phone,
   @CheckOutTime,@CheckInTime,@Description,@HotalName,@StarRating,
   @TwentyFourHourCheckinAllowed,@WebAddress,@Image,0,GETDATE(),0,GETDATE(),
   1,0,NEWID(),@HotelCount,@Latitude,@Longitude);
   SELECT Id,RowId FROM WRBHBStaticHotels WHERE Id = @@IDENTITY;
  END
END
    