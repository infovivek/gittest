--SELECT * FROM WRBHBTravelDesk
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_TravelDesk_Update') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_TravelDesk_Update;
GO   
/* 
        Author Name :  Mini
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
CREATE PROCEDURE  Sp_TravelDesk_Update
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
	@ClientId int ,  
	--@Password varbinary,
	@Id bigint,
	@Mode nvarchar(100) 
) 
AS
BEGIN
 If(@Mode='TRAVELDESK')
  BEGIN
		Update WRBHBTravelDesk set --ClientId=@ClientId,ClientName=@ClientName,
		FirstName=@FirstName,LastName=@LastName,Designation=@Designation, 
		Mobile=@MobileNumber,--Office=@Office,Email=@Email,
		States=@State,StateId=@StateId,City=@City,CityId=@CityId,
		Website=@Website,--Addresss=@Address, 
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() 
		WHERE Id=@Id and IsActive=1 and IsDeleted=0; 
		
       SELECT Id,RowId FROM WRBHBTravelDesk WHERE Id=@Id;	 
  End
   If(@Mode='ENDUSER')
	 BEGIN
	 -- DECLARE @Identity INT,@Identity1 NVARCHAR(100)  
 -- DECLARE @InsId INT,@ErrMsg NVARCHAR(MAX); 
	--		IF  EXISTS(SELECT NULL FROM WRBHBTravelDesk WITH (NOLOCK) 
	--		WHERE  Email=@Email AND IsDeleted=0 AND IsActive=1 and Id=@Id)   
	   BEGIN  
	   DECLARE @UserPassword VARCHAR(100)   
		EXEC sp_PasswordGeneration @len=8, @output=@UserPassword out   
		SET @UserPassword=@UserPassword;  
		open symmetric key sk_key decryption by password = 'WARBHB@Pass';  
 update WRBHBTravelDesk set Password= null, IsActive=0,IsDeleted=1,ModifiedDate=GETDATE() where Email=@Email and Mode='ENDUSER'
 
 Update WRBHBClientManagementAddClientGuest 
 SET Password= encryptbykey(key_guid('sk_key'),@UserPassword,1,'HB@1wr'), EmailId=@Email,
 FirstName=@FirstName,LastName=@LastName,GMobileNo=@MobileNumber
     WHERE Id=@Id and IsActive=1 and IsDeleted=0 --and EmailId=@Email
     
       INSERT INTO WRBHBTravelDesk(ClientName,ClientId,FirstName,LastName,Designation,
				Mobile,Office,Email,Password,States,StateId,City,CityId,Website,Addresss, 
				IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Mode)
				VALUES (@ClientName,@ClientId,@FirstName,@LastName,@Designation,
				@MobileNumber,@Office,@Email,(encryptbykey(key_guid('sk_key'), @UserPassword, 1, 'HB@1wr'))
				,@State,@StateId,@City,@CityId,@Website,@Address,  
				1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@Mode )

				SELECT Id,RowId,@UserPassword,DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
    CONVERT(VARCHAR(12),CreatedDate,103) BookingDate
     FROM WRBHBTravelDesk WHERE Id=@@IDENTITY;
				
		SELECT Logo FROM dbo.WRBHBCompanyMaster;
       
	   END   
	 END
END		



 