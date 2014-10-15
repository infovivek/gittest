 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_Vendor_Insert') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_Vendor_Insert;
GO   
/* 
        Author Name : Mini
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
CREATE PROCEDURE  Sp_Vendor_Insert
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
	@BankId  int
) 
AS
BEGIN
INSERT INTO WRBHBVendor(VendorName,VendorCategory,FirstName,LastName,Designation,NatureofService ,
	Mobile,Office,Email,States,StateId,City,CityId,Website,Addresss,PayChk,Payonline,Bankname,IFSCode ,
	Payeename,Accountnumber,AccountType,Paymentcircle,Pannum,Saleregnumb,Saleregdate,Servicergenum,Servicergedate,
	IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,CategoryId,BankId)
VALUES (@VendorName,@Category,@FirstName,@LastName,@Designation,@NatureofService,
@MobileNumber,@Office,@Email,@State,@StateId,@City,@CityId,@Website,@Address,@Cheque,@OnlineTransfer,@Bank,@IFSC,
@Payeename,@AccountNo,@AccountType,@Paymentcircle,@Pancard,@SaletaxNum,
Convert(NVarChar(100),@saletaxdate,103),@ServtaxNum,convert(NVarChar(100),@servicetaxdate,103),
1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),@CategoryId,@BankId )
		
 SELECT Id,RowId FROM WRBHBVendor WHERE Id=@@IDENTITY;		
END		