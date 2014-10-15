SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MapVendor_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_MapVendor_Update

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (28/06/2014)  >
Section  	: PETTYCASH STATUS HELP
Purpose  	: PETTYCASH STATUS HELP
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

CREATE PROCEDURE Sp_MapVendor_Update
(
@VendorId BigInt,
@Process  BIGINT,
@Property		 NVARCHAR(100),
@PropertyId BIGINT,
@Id         BIGINT,
@UserId		 BIGINT
)
AS

BEGIN

	 UPDATE WRBHBMapVendor SET IsActive=0,IsDeleted=1
	 WHERE Id=@Id 
	 
	 INSERT INTO WRBHBMapVendor (VendorId,Process,Property,PropertyId,IsActive,
	 IsDeleted,Createdby,Createddate,Modifiedby,Modifieddate,
	 RowId)
	 VALUES(@VendorId,@Process,@Property,@PropertyId,1,0,@UserId,
	 GETDATE(),@UserId,GETDATE(),NEWID())
	
	SELECT Id,RowId FROM WRBHBMapVendor WHERE Id=@@IDENTITY;
	
SELECT Id,RowId FROM WRBHBMapVendor WHERE Id=@Id;
END

--Truncate Table WRBHBMapVendor