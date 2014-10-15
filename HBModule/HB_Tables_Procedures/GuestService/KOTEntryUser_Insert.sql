-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_KOTEntryUser_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_KOTEntryUser_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 25/06/2014 
Section  	 : Guest Servic
Purpose  	 : KOT ENTRY USERDETAILS
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_KOTEntryUser_Insert](@KOTEntryHdrId BIGINT,
@UserName NVARCHAR(100),@UserId INT,
@BreakfastVeg BIGINT=NULL,
@BreakfastNonVeg BIGINT=NULL,@LunchVeg BIGINT=NULL,
@LunchNonVeg BIGINT= NULL,@DinnerVeg BIGINT=NULL,
@DinnerNonVeg BIGINT=NULL,@CreatedBy BIGINT)

AS
BEGIN
DECLARE @InsId INT;
-- CHECKIN PROPERTY GUEST DETAILS INSERT
INSERT INTO WRBHBKOTUser(KOTEntryHdrId,UserName,UserId
,BreakfastVeg,BreakfastNonVeg,LunchVeg,
LunchNonVeg,DinnerVeg,DinnerNonVeg,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@KOTEntryHdrId,@UserName,@UserId,
@BreakfastVeg,@BreakfastNonVeg,@LunchVeg,@LunchNonVeg,@DinnerVeg,
@DinnerNonVeg,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

SET @InsId=@@IDENTITY;
SELECT Id,RowId FROM WRBHBKOTUser WHERE Id=@InsId;
END
GO

