/****** Object:  StoredProcedure [dbo].[SP_NewKOTEntryDtl_Update]    Script Date: 07/30/2014 17:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTUserEntryDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewKOTUserEntryDtl_Update]

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
CREATE PROCEDURE [dbo].[SP_NewKOTUserEntryDtl_Update]
(@NewKOTEntryHdrId BIGINT,
@ServiceItem NVARCHAR(100),
@Quantity INT,
@Price DECIMAL(27,2),
@Amount DECIMAL(27,2),
@ItemId INT,
@CreatedBy BIGINT,
@Id BIGINT)

AS
BEGIN
UPDATE WRBHBNewKOTUserEntryDtl SET NewKOTEntryHdrId=@NewKOTEntryHdrId,ServiceItem=@ServiceItem,
Quantity=@Quantity,Price=@Price,Amount=@Amount,
ItemId= @ItemId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBNewKOTUserEntryDtl WHERE Id=@Id;
END
GO