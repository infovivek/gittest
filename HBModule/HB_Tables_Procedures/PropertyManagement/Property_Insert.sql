 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Property_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Property_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY MANAGEMENT 
		Purpose  	: PROPERTY Insert
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
CREATE PROCEDURE [dbo].[Sp_Property_Insert] (  
@PropertyName   NVARCHAR(100),  
@Code     NVARCHAR(100),  
@Category    NVARCHAR(100),  
@PropertDescription  NVARCHAR(MAX),  
@Prefix     NVARCHAR(100),  
@Propertaddress   NVARCHAR(100),  
@City     NVARCHAR(100),  
@Localityarea   NVARCHAR(100),  
@State     NVARCHAR(100),  
@Postal     NVARCHAR(100),  
@Phone     NVARCHAR(100),  
@Directions    NVARCHAR(MAX),  
@Keyword    NVARCHAR(100),  
@ServicesSwimPool  BIT,  
@ServicesPub   BIT,  
@ServicesGym   BIT,  
@ServicesRestaurant  BIT,  
@ServicesConfHall  BIT,  
@ServicesCyberCafe  BIT,  
@ServicesLaundry  BIT,  
@ShowOnWebsite   BIT,  
@LatitudeLongitude  NVARCHAR(100),  
@CreatedBy    BigInt,  
@Date                   NVARCHAR(100),  
@StateId    INT,  
@CityId     INT,  
@LocalityId    INT,
@TotalNoRooms  NVARCHAR(100),
@PropertyRackTarrif DECIMAL(27,2),
@PropertyType NVARCHAR(100) ,
@RackTarrifDouble DECIMAL(27,2),
@BookingPolicy NVARCHAR(1000),
@CancelPolicy NVARCHAR(1000),
@Email		NVARCHAR(100),
@CheckIn    INT,
@CheckInType NVARCHAR(100),
@CheckOut    INT,
@CheckOutType NVARCHAR(100),
@GraceTime    INT
)   
AS  
BEGIN  
 --IF NOT EXISTS(SELECT NULL FROM WRBHBLocality WHERE   
 --  UPPER(Locality)=UPPER(@Localityarea) AND CityId=@CityId)  
 -- BEGIN    
	
 --    INSERT INTO WRBHBLocality(Locality,CityId,CreatedBy,CreatedDate,  
 --    ModifiedBy,ModifiedDate,IsActive,RowId)  
 --    VALUES(@Localityarea,@CityId,@CreatedBy,GETDATE(),@CreatedBy,  
 --    GETDATE(),1,NEWID());  
 --    SET @LocalityId=@@IDENTITY; 
       
 -- END  
 --ELSE  
 -- BEGIN  
	
 --  SELECT @LocalityId=Id FROM WRBHBLocality WHERE    
 --  UPPER(Locality)=UPPER(@Localityarea) AND CityId=@CityId
  
 -- END  

--INSERT  
IF ISNULL(@BookingPolicy,'')=''
BEGIN
SET @BookingPolicy='<ul><li>A picture of the guest will be taken through webcam for records.</li><li> 
The guests mobile number and official e-mail address needs to be provided.</li><li> 
Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. 
</li><li> A company business card or company ID card needs to be produced.</li></ul>'
END
IF ISNULL(@CancelPolicy,'')=''
BEGIN
SET @CancelPolicy='<ul><li> Email to stay@staysimplyfied.com and mention the booking ID no.</li><li> 
Cancellation less than 48 hrs &ndash; NIL. Before 48 hrs &ndash; 100% refund.</li><li> 
1 day tariff will be charged for no-show without intimation.</li></ul>'
END

 INSERT INTO dbo.WRBHBProperty(PropertyName,Code,Category,PropertDescription,  
 Prefix,Propertaddress,City,Localityarea,State,Postal,Phone,Directions,  
 Keyword,ServicesSwimPool,ServicesPub,ServicesGym,ServicesRestaurant,  
 ServicesConfHall,ServicesCyberCafe,ServicesLaundry,ShowOnWebsite,  
 LatitudeLongitude,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,  
 IsDeleted,RowId,Date,StateId,CityId,LocalityId,TotalNoRooms,RackTarrifSingle,PropertyType,
  RackTarrifDouble,BookingPolicy,CancelPolicy,Email,CheckIn,CheckInType,CheckOut,CheckOutType,GraceTime)  
 VALUES(@PropertyName,@Code,@Category,@PropertDescription,@Prefix,  
 @Propertaddress,@City,@Localityarea,@State,@Postal,@Phone,@Directions,  
 @Keyword,@ServicesSwimPool,@ServicesPub,@ServicesGym,@ServicesRestaurant,  
 @ServicesConfHall,@ServicesCyberCafe,@ServicesLaundry,@ShowOnWebsite,  
 @LatitudeLongitude,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),  
 CONVERT(DATE,@Date,103),@StateId,@CityId,@LocalityId,@TotalNoRooms,@PropertyRackTarrif,@PropertyType,
 @RackTarrifDouble,@BookingPolicy,@CancelPolicy,@Email,@CheckIn,@CheckInType,@CheckOut,@CheckOutType,@GraceTime);  
 SELECT Id,RowId FROM WRBHBProperty WHERE Id=@@IDENTITY;  
END  


