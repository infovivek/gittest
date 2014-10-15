 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_VendorCost_Insert') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE Sp_VendorCost_Insert;
GO   
/* 
        Author Name : Anbu
		Created On 	: <Created Date (03/07/2014)  >
		Section  	:  VenderCost
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
CREATE PROCEDURE  Sp_VendorCost_Insert
(
@VendorId		INT,
@EffectiveFrom	NVARCHAR(100),
@ProductName    NVARCHAR(500),
@Cost			DECIMAL(27,2),
@ItemId			INT,
@Flag			INT,
@UserId			Int)
AS
BEGIN
INSERT INTO WRBHBVendorCost(VendorId,PropertyId,EffectiveFrom,ProductName,Cost,
			ItemId,Flag,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
			RowId)
VALUES	    (@VendorId,0,Convert(date,@EffectiveFrom,103),@ProductName,@Cost,@ItemId,@Flag,
		    1,0,@UserId,GETDATE(),@UserId,GETDATE(),NEWID())
			
			SELECT Id,RowId FROM WRBHBVendorCost WHERE Id=@@IDENTITY;		
END	


--Truncate Table WRBHBVendorCost