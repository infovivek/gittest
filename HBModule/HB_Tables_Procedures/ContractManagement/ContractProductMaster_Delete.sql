SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractProductMaster_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[Sp_ContractProductMaster_Delete]
Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACTPRODUCTMASTER DELETE
Purpose  	: PRODUCT SELECT
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
CREATE PROCEDURE Sp_ContractProductMaster_Delete
(
@Id int,
@UserId int
)
AS
BEGIN
update WRBHBContarctProductMaster set IsActive=0,IsDeleted=1,ModifiedBy=@UserId
Where Id=@Id

--Update WRBHBRolesGroup Set IsActive=1,IsDeleted=1,ModifiedBy=@Id
--Where Id=@Id

End
GO