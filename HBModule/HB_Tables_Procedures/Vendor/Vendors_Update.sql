 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_Vendor_Update') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_Vendor_Update;
GO   
/* 
        Author Name :  Mini
		Created On 	: <Created Date (28/06/2014)  >
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
CREATE PROCEDURE  Sp_Vendor_Update
(
    @VendorName nvarchar(100) ,
	@Category nvarchar(100),
	@FirstName nvarchar(500) ,
	@LastName  nvarchar(500) ,
	@Designation nvarchar(100) ,
	@NatureofService nvarchar(150) ,
	@MobileNumber nvarchar(50)  ,
	@Office nvarchar(50)  ,
	@Email nvarchar(100) ,
	@State nvarchar(100),
	@StateId int ,
    @City nvarchar(100),
	@CityId int  , 
	@Website nvarchar(100) ,
	@Address nvarchar(100) ,
	@Cheque bit ,
	@OnlineTransfer bit,
	@Bank nvarchar(150) ,
	@IFSC nvarchar(50) ,
	@Payeename nvarchar(100) ,
	@AccountNo nvarchar(50) ,
	@AccountType nvarchar(100) ,
	@Paymentcircle nvarchar(100) ,
	@Pancard nvarchar(100) ,
	@SaletaxNum nvarchar(100) ,
	@saletaxdate  NVarChar(100) ,
	@ServtaxNum nvarchar(100) ,
	@servicetaxdate  NVarChar(100) ,
	@CreatedBy int ,
	@CategoryId int ,
	@BankId  int,
	@Id bigint
) 
AS
BEGIN
		Update WRBHBVendor set  VendorName=@VendorName,
		VendorCategory=@Category,FirstName=@FirstName,LastName=@LastName,
		Designation=@Designation,NatureofService=@NatureofService ,
		Mobile=@MobileNumber,Office=@Office,Email=@Email,
		States=@State,StateId=@StateId,City=@City,CityId=@CityId,
		Website=@Website,Addresss=@Address, Bankname=@Bank,IFSCode=@IFSC,
		Payeename=@Payeename,Accountnumber=@AccountNo,AccountType=@AccountType,
		Paymentcircle=@Paymentcircle,Pannum=@Pancard,Saleregnumb=@SaletaxNum,
		PayChk=@Cheque,Payonline=@OnlineTransfer,
		--Saleregdate=Convert(NVarChar(100),@saletaxdate,103),
		Servicergenum=@ServtaxNum,
		--Servicergedate=convert(NVarChar(100),@servicetaxdate,103),
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),CategoryId=@CategoryId
		WHERE Id=@Id and IsActive=1 and IsDeleted=0; 
		
       SELECT Id,RowId FROM WRBHBVendor WHERE Id=@Id;		
END		