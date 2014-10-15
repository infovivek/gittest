
/****** Object:  StoredProcedure [dbo].[SP_NewKOTEntryDtl_Insert]    Script Date: 07/30/2014 17:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTUserEntryDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewKOTUserEntryDtl_Insert]

Go
/*=============================================
Author Name  : Anbu
Created Date : 30/07/14
Section  	 : Guest service
Purpose  	 : KOT Entry
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_NewKOTUserEntryDtl_Insert](@NewKOTEntryHdrId BIGINT,
@ServiceItem NVARCHAR(100)=NULL,@Quantity INT=NULL,
@Price DECIMAL(27,2)=NULL,@Amount DECIMAL(27,2)=NULL,@ItemId INT=NULL,
@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;
-- CHECKIN PROPERTY GUEST DETAILS INSERT
INSERT INTO WRBHBNewKOTUserEntryDtl(NewKOTEntryHdrId,ServiceItem,
Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@NewKOTEntryHdrId,@ServiceItem,@Quantity,
@Price,@Amount,@ItemId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
--SET @Id=@@IDENTITY;
--SELECT Id,RowId FROM WRBHBNewKOTEntryDtl WHERE Id=@NewKOTEntryHdrId;
SELECT Id,RowId FROM WRBHBNewKOTUserEntryDtl WHERE Id=@@IDENTITY;

END
GO