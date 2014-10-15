 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_TravelAgency_Insert') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_TravelAgency_Insert;
GO   
/* 
        Author Name : Mini
		Created On 	: <Created Date (04/07/2014)  >
		Section  	:  
		Purpose  	:  
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
CREATE PROCEDURE  Sp_TravelAgency_Insert
( 
	@ClientName nvarchar(100),
	@FirstName nvarchar(500) ,
	@LastName  nvarchar(500) ,
	@Designation nvarchar(100) , 
	@MobileNumber nvarchar(50)  ,
	@Office nvarchar(50)  ,
	@Email nvarchar(100) ,
	@State nvarchar(100),
	@StateId int ,
    @City nvarchar(100),
	@CityId int  , 
	@Website nvarchar(100) ,
	@Address nvarchar(100) , 
	@CreatedBy int ,
	@ClientId int,
	@Mode nvarchar(100) 
	--,@Password varbinary
) 
AS
BEGIN
DECLARE @Identity INT,@Identity1 NVARCHAR(100),@Id int;  
DECLARE @InsId INT,@ErrMsg NVARCHAR(MAX);  
	DECLARE @UserPassword VARCHAR(100)   
	--Update WRBHBTravelDesk set IsActive=0 ,IsDeleted=1 
	--where Email=@Email and IsActive=1 and IsDeleted=0 and  @Mode='TRAVELAGENCY'
  If(@Mode='TRAVELAGENCY')
  BEGIN
IF EXISTS(SELECT NULL FROM WRBHBTravelDesk WITH (NOLOCK) 
        WHERE  Email=@Email AND IsDeleted=0 AND IsActive=1 and ClientId=@ClientId  and Mode='TRAVELAGENCY')   
   BEGIN  
   Update WRBHBTravelDesk set IsActive=0 ,IsDeleted=1 
	where Email=@Email and IsActive=1 and IsDeleted=0 and  @Mode='TRAVELAGENCY' 
		
		EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out   
		SET @UserPassword=@UserPassword;  
		open symmetric key sk_key decryption by password = 'WARBHB@Pass';  

				INSERT INTO WRBHBTravelDesk(ClientName,ClientId,FirstName,LastName,Designation,
				Mobile,Office,Email,Password,States,StateId,City,CityId,Website,Addresss, 
				IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Mode)
				VALUES (@ClientName,@ClientId,@FirstName,@LastName,@Designation,
				@MobileNumber,@Office,@Email,(encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'))
				,@State,@StateId,@City,@CityId,@Website,@Address,  
				1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode )

Update WRBHBTravelDesk Set Password=(encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'))
where   Mode='TRAVELAGENCY' and Email=@Email ;

				SELECT Id,RowId,@UserPassword,DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
    CONVERT(VARCHAR(12),CreatedDate,103) BookingDate
     FROM WRBHBTravelDesk WHERE Id=@@IDENTITY;	
				
				SELECT Logo FROM dbo.WRBHBCompanyMaster;   
   END   
ELSE  
	BEGIN  
	

		--DECLARE @UserPassword VARCHAR(100)   
		EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out   
		SET @UserPassword=@UserPassword;  
		open symmetric key sk_key decryption by password = 'WARBHB@Pass';  

				INSERT INTO WRBHBTravelDesk(ClientName,ClientId,FirstName,LastName,Designation,
				Mobile,Office,Email,Password,States,StateId,City,CityId,Website,Addresss, 
				IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Mode)
				VALUES (@ClientName,@ClientId,@FirstName,@LastName,@Designation,
				@MobileNumber,@Office,@Email,(encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'))
				,@State,@StateId,@City,@CityId,@Website,@Address,  
				1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode )

Update WRBHBTravelDesk Set Password=(encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'))
where   Mode='TRAVELAGENCY' and Email=@Email ;

				SELECT Id,RowId,@UserPassword,DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
    CONVERT(VARCHAR(12),CreatedDate,103) BookingDate
     FROM WRBHBTravelDesk WHERE Id=@@IDENTITY;	
				
				SELECT Logo FROM dbo.WRBHBCompanyMaster;
	
		  
	 END  
	 end
	
END  
 