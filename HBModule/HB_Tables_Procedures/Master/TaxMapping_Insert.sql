SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TaxMapping_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TaxMapping_Insert]
GO   
/* 
Author Name : Anbu
Created On 	: <Created Date (31/03/2014)  >
Section  	: TaxMapping_Insert
Purpose  	: TaxMapping_Insert
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
CREATE PROCEDURE [dbo].[Sp_TaxMapping_Insert]
(
@PropertyId		INT,
@Property		NVARCHAR(100),
@ServiceItem	NVARCHAR(100),
@ItemId			INT,
@VAT			BIT,
@Luxurytax		BIT,
@ST1			BIT,
@ST2			BIT,
@ST3			BIT,
@Service	NVARCHAR(100),
@CreatedBy		INT
)
AS
BEGIN
DECLARE @Identity int
BEGIN 
	INSERT INTO	WRBHBTaxMapping(PropertyId,Property,ServiceItem,ItemId,VAT,LuxuryTax,ST1,ST2,ST3,Service,
			IsActive,IsDeleted,Createdby,CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@PropertyId,@Property,@ServiceItem,@ItemId,@VAT,@Luxurytax,@ST1,@ST2,@ST3,@Service,1,0,@CreatedBy,
			CONVERT(date,GETDATE(),103),@CreatedBy,CONVERT(date,GETDATE(),103),NEWID())
	
	SET  @Identity=@@IDENTITY
	SELECT Id,Rowid FROM WRBHBTaxMapping WHERE Id=@Identity;
END
END			


