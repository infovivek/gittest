SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TaxMapping_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TaxMapping_Update]
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
CREATE PROCEDURE [dbo].[Sp_TaxMapping_Update]
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
@Service		NVARCHAR(100),
@Id				INT,
@CreatedBy		INT
)
AS
BEGIN

			UPDATE WRBHBTaxMapping SET PropertyId=@PropertyId,Property=@Property,ServiceItem=@ServiceItem,
		    ItemId=@ItemId,VAT=@VAT,LuxuryTax=@Luxurytax,ST1=@ST1,ST2=@ST2,ST3=@ST3,Service=@Service,
			Modifiedby=@CreatedBy,ModifiedDate=CONVERT(date,GETDATE(),103)
			WHERE Id=@Id
	
			SELECT Id,Rowid FROM WRBHBTaxMapping WHERE Id=@Id
	
		
END

