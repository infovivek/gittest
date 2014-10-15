SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_KOTEntryUser_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_KOTEntryUser_Update]
GO
/*=============================================
Author Name  : shameem
Created Date : 12/05/14 
Section  	 : Guest Service
Purpose  	 : KOT Entry  (Details)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_KOTEntryUser_Update](@KOTEntryHdrId BIGINT,
@UserName NVARCHAR(100),@UserId INT
,@BreakfastVeg BIGINT=NULL,
@BreakfastNonVeg BIGINT=NULL,@LunchVeg BIGINT=NULL,
@LunchNonVeg BIGINT= NULL,@DinnerVeg BIGINT=NULL,
@DinnerNonVeg BIGINT=NULL,@CreatedBy BIGINT,
@Id BIGINT)

AS
BEGIN
UPDATE WRBHBKOTUser SET KOTEntryHdrId=@KOTEntryHdrId,UserName=@UserName,UserId=@UserId
,BreakfastVeg=@BreakfastVeg,
BreakfastNonVeg=@BreakfastNonVeg,LunchVeg=@LunchVeg,LunchNonVeg=@LunchNonVeg,
DinnerVeg=@DinnerVeg,DinnerNonVeg=@DinnerNonVeg,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBKOTUser WHERE Id=@Id;
END
GO