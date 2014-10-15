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
--@Latitude    NVARCHAR(100),    
--@Longitude    NVARCHAR(100),    
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
@Description   NVARCHAR(MAX),    
@HotalName    NVARCHAR(100),    
--@Overallrating   NVARCHAR(100),    
--@Recommended   NVARCHAR(100),    
@StarRating    NVARCHAR(100),    
--@TotalRating   NVARCHAR(100),    
--@TotalReviews   NVARCHAR(100),    
@WebAddress    NVARCHAR(100),    
@TwentyFourHourCheckinAllowed NVARCHAR(100),    
@Image     NVARCHAR(MAX),    
@Amenity    NVARCHAR(100)=NULL ,
@HotelCount   INT
)     
AS    
BEGIN    
 --INSERT   
 INSERT INTO WRBHBStaticHotels(HotalId,Area,City,CityCode,Country,CountryCode,
 Line1,Line2,Pincode,DateUpdated,State,Email,ContactPerson,Phone,CheckOutTime,
 CheckInTime,Description,HotalName,StarRating,TwentyFourHourCheckinAllowed,    
 WebAddress,Image,Amenity,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,    
 IsActive,IsDeleted,RowId,HotelCount)
 VALUES(@HotalId,@Area,@City,@CityCode,@Country,@CountryCode,@Line1,    
 @Line2,@Pincode,@DateUpdated,@State,@Email,@ContactPerson,@Phone,@CheckOutTime,
 @CheckInTime,@Description,@HotalName,@StarRating,@TwentyFourHourCheckinAllowed,    
 @WebAddress,@Image,@Amenity,0,GETDATE(),0,GETDATE(),1,0,NEWID(),@HotelCount);     
 SELECT Id,RowId FROM WRBHBStaticHotels WHERE Id=@@IDENTITY;    
END
    