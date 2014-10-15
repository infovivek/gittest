-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_LaundryServiceDtl_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_LaundryServiceDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 22/09/2014 
Section  	 : Guest Service
Purpose  	 : LaundryServiceHdr_Insert
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LaundryServiceDtl_Insert](@LaundryHdrId BIGINT,
@ServiceItem NVARCHAR(100)=NULL,@ServiceType NVARCHAR(100)=NULL,@Quantity INT=NULL,@Price DECIMAL(27,2)=NULL,@Amount DECIMAL(27,2)=NULL,
@ItemId INT=NULL,@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;
-- CHECKIN PROPERTY GUEST DETAILS INSERT
INSERT INTO WRBHBLaundrServiceDtl(LaundryHdrId,ServiceItem,ServiceType,
Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@LaundryHdrId,@ServiceItem,@ServiceType,@Quantity,
@Price,@Amount,@ItemId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

SELECT Id,RowId FROM WRBHBLaundrServiceDtl WHERE Id=@@IDENTITY;

END
GO