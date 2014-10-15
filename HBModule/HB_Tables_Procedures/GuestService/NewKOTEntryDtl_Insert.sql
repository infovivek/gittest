-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_NewKOTEntryDtl_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_NewKOTEntryDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 24/05/2014 
Section  	 : Guest Servic
Purpose  	 : NEW KOT ENTRY DETAILS
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_NewKOTEntryDtl_Insert](@NewKOTEntryHdrId BIGINT,
@ServiceItem NVARCHAR(100)=NULL,@Quantity INT=NULL,@Price DECIMAL(27,2)=NULL,@Amount DECIMAL(27,2)=NULL,
@ItemId INT=NULL,@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;
-- CHECKIN PROPERTY GUEST DETAILS INSERT
INSERT INTO WRBHBNewKOTEntryDtl(NewKOTEntryHdrId,ServiceItem,
Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@NewKOTEntryHdrId,@ServiceItem,@Quantity,
@Price,@Amount,@ItemId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
--SET @Id=@@IDENTITY;
--SELECT Id,RowId FROM WRBHBNewKOTEntryDtl WHERE Id=@NewKOTEntryHdrId;
SELECT Id,RowId FROM WRBHBNewKOTEntryDtl WHERE Id=@@IDENTITY;

END
GO