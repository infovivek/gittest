SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MapVendor_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_MapVendor_Insert

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (01/07/2014)  >
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

CREATE PROCEDURE Sp_MapVendor_Insert
(
@VendorId BigInt,
@Process		BIT,
@Property		 NVARCHAR(100),
@PropertyId BIGINT,
@UserId		 BIGINT
)
	AS
	DECLARE @Identity int
	IF EXISTS (SELECT PropertyId FROM WRBHBMapVendor WITH (NOLOCK) 
	WHERE UPPER(PropertyId) = UPPER(@PropertyId)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
     UPDATE WRBHBMapVendor SET IsActive=0 ,IsDeleted=1
     WHERE PropertyId=@PropertyId;         
	
	 INSERT INTO WRBHBMapVendor (VendorId,Process,Property,PropertyId,IsActive,
	 IsDeleted,Createdby,Createddate,Modifiedby,Modifieddate,
	 RowId)
	 VALUES(@VendorId,@Process,@Property,@PropertyId,1,0,@UserId,
	 GETDATE(),@UserId,GETDATE(),NEWID())
	
	 SET  @Identity=@@IDENTITY
	 SELECT Id,RowId FROM WRBHBMapVendor WHERE Id=@Identity;
END
ELSE
BEGIN
		INSERT INTO WRBHBMapVendor (VendorId,Process,Property,PropertyId,IsActive,
		IsDeleted,Createdby,Createddate,Modifiedby,Modifieddate,
		RowId)
		VALUES(@VendorId,@Process,@Property,@PropertyId,1,0,@UserId,
		GETDATE(),@UserId,GETDATE(),NEWID())

	
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBMapVendor WHERE Id=@Identity;
END


--TRUNCATE TABLE WRBHBMapVendor