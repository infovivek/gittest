SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractProductMaster_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_ContractProductMaster_Help

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACTPRODUCTMASTER HELP
Purpose  	: PRODUCT HELP
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

CREATE PROCEDURE Sp_ContractProductMaster_Help
(
@Action NVARCHAR(100),
@Str NVARCHAR(100),
@UserId INT,
@Id		INT
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
	 BEGIN  
		SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt; 
	 END
  IF @Action='Food'
	 BEGIN  
		Select ProductName,Id From WRBHBContarctProductMaster 
		WHERE TypeService='Food And Beverages' AND IsActive=1 AND IsDeleted=0
		
	 END
  IF @Action='Services'
	 BEGIN  
		Select ProductName,Id From WRBHBContarctProductMaster 
		WHERE TypeService='Services' AND IsActive=1 AND IsDeleted=0
		 
	 END
  IF @Action='Laundry'
	 BEGIN  
		Select ProductName,Id From WRBHBContarctProductMaster 
		WHERE SubTypeId=@Id AND IsActive=1 AND IsDeleted=0
	 END
  IF @Action='LaundrySubType'
	 BEGIN  
		Select SubType,Id AS SubTypeId From WRBHBContractProductSubMaster 
		WHERE  IsActive=1 AND IsDeleted=0
	 END		 
 END
 
 
 
