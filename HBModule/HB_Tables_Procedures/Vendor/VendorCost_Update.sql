SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorCost_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_VendorCost_Update

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (03/07/2014)  >
Section  	: VendorCost
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

CREATE PROCEDURE Sp_VendorCost_Update
(
@VendorId		BigInt,
@EffectiveFrom	NVARCHAR(100),
@ProductName	NVARCHAR(100),
@Cost			DECIMAL(27,2),
@ItemId			INT,
@Id             BIGINT,
@Flag             BIGINT,
@UserId		    BIGINT
)
AS

BEGIN
    DECLARE @ExsitingId  int
    SELECT @ExsitingId= Id FROM WRBHBVendorCost where EffectiveFrom=Convert(date,@EffectiveFrom,103)
    AND IsActive=1 AND IsDeleted=0 AND PropertyId=@Id
	IF(ISNULL(@ExsitingId,0) !=0)
    BEGIN
	UPDATE WRBHBVendorCost SET VendorId=@VendorId,PropertyId=0,EffectiveFrom=Convert(date,@EffectiveFrom,103),
	       ProductName=@ProductName,Cost=@Cost,ItemId=@ItemId,Flag=@Flag,Modifiedby=@UserId, ModifiedDate=GETDATE()
	       WHERE Id=@Id 
	
	SELECT Id,RowId FROM WRBHBVendorCost WHERE Id=@Id;
	END
	ELSE
	BEGIN
	     UPDATE WRBHBVendorCost SET EffectiveTo=(SELECT DATEADD(day,-1,Convert(date,@EffectiveFrom,103))),
	                                IsActive=0,IsDeleted=1  WHERE Id=@Id;
	     
	     INSERT INTO WRBHBVendorCost(VendorId,PropertyId,EffectiveFrom,ProductName,Cost,
			ItemId,Flag,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
			RowId)
		 VALUES
			(@VendorId,0,Convert(date,@EffectiveFrom,103),@ProductName,@Cost,@ItemId,@Flag,
		    1,0,@UserId,GETDATE(),@UserId,GETDATE(),NEWID())
			
			SELECT Id,RowId FROM WRBHBVendorCost WHERE Id=@@IDENTITY;
			
	END
	
END