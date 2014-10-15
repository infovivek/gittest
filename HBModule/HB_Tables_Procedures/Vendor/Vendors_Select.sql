 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_Vendor_Select') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE Sp_Vendor_Select
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
CREATE PROCEDURE Sp_Vendor_Select (@Id BIGINT,
@Param1 BIGINT,@UserId BIGINT)
AS
BEGIN
 IF @Id <> 0  
  BEGIN
   SELECT VendorCategory as Category, CategoryId, VendorName,FirstName,LastName,Designation,NatureOfService,Mobile,
        Office,Addresss as address,Email,States State,StateId,City,CityId,Website,Pannum as Pancard,
        Saleregnumb saletaxnum,CONVERT(NVARCHAR,Saleregdate,103)  saletaxdate,Servicergenum ServtaxNum,
       CONVERT(NVARCHAR,Servicergedate,103)  servicetaxdate,PayChk Cheque,Payonline OnlineTransfer,Bankname Bank,
       PayeeName,IFSCode IFSC,Accountnumber AccountNo,AccountType,PaymentCircle,BankId ,Id as Id
   FROM WRBHBVendor V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 AND Id=@Id;
  END	
 IF @Id = 0
  BEGIN
   SELECT VendorName,VendorCategory,FirstName,States,Id
   FROM WRBHBVendor V 
   WHERE V.IsDeleted=0 AND V.IsActive=1
   order by Id desc;
  END
END
GO
