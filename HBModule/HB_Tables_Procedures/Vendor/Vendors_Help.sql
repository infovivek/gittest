 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_Vendor_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  [Sp_Vendor_Help]
GO 
/* 
Author Name : mini
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
CREATE PROCEDURE [Sp_Vendor_Help](@PAction NVARCHAR(100),@Param1 bigint,
@Param2 NVARCHAR(100),@Id1 bigint,@Id2 bigint,@UserId bigint)
AS
BEGIN
  IF @PAction='PageLoad'
  BEGIN
	--Table DateFunction
		 SELECT CategoryName  AS label,Id as CategoryId   FROM WRBHBVendorCategory WHERE IsActive=1; 
		 
	--Table1 DateFunction
		-- SELECT BankName  AS label,Id as BankId   FROM WRBHBBank where IsActive=1; 
  END
	 IF @PAction='STATELOAD'
  BEGIN
  --Table DateFunction
		 SELECT StateName AS label,Id as StateId FROM WRBHBState WHERE IsActive=1; 
  END
   IF @PAction='CITYLOAD'
  BEGIN
	--Table DateFunction
		 SELECT CityName AS label,Id as CityId FROM WRBHBCity WHERE IsActive=1 and StateId=@Id1 ; 
  END  
  
  End 
   
 