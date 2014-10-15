-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_OutsourceKOTDtl_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_OutsourceKOTDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 02/08/2014 
Section  	 : Guest Servic
Purpose  	 : OUTSourceKOT ENTRY DETAILS
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_OutsourceKOTDtl_Insert](@OutsourceKOTHdrId BIGINT,
@ServiceItem NVARCHAR(100)=NULL,@Quantity INT=NULL,@Price DECIMAL(27,2)=NULL,@Amount DECIMAL(27,2)=NULL,
@ItemId INT=NULL,@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;

	INSERT INTO WRBHBOutsourceKOTDtl(OutsourceKOTHdrId,ServiceItem,
	Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,IsDeleted,RowId)

	VALUES(@OutsourceKOTHdrId,@ServiceItem,@Quantity,
	@Price,@Amount,@ItemId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

	SELECT Id,RowId FROM WRBHBOutsourceKOTDtl WHERE Id=@@IDENTITY;

END
GO