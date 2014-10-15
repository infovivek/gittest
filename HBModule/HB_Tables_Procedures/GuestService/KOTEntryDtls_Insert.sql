-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_KOTEntryDtls_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_KOTEntryDtls_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 12/05/2014 
Section  	 : Guest Servic
Purpose  	 : KOT ENTRY DETAILS
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_KOTEntryDtls_Insert](@KOTEntryHdrId BIGINT,
@PropertyId BIGINT,@BookingId BIGINT,
@BookingCode NVARCHAR(100),@GuestName NVARCHAR(100),
@RoomNo NVARCHAR(100),@BreakfastVeg BIGINT=NULL,
@BreakfastNonVeg BIGINT=NULL,@LunchVeg BIGINT=NULL,
@LunchNonVeg BIGINT= NULL,@DinnerVeg BIGINT=NULL,
@DinnerNonVeg BIGINT=NULL,@CheckInId INT,@UserId BIGINT)

AS
BEGIN
DECLARE @InsId INT;
-- CHECKIN PROPERTY GUEST DETAILS INSERT
INSERT INTO WRBHBKOTDtls(KOTEntryHdrId,PropertyId,BookingId,
BookingCode,GuestName,RoomNo,BreakfastVeg,BreakfastNonVeg,LunchVeg,
LunchNonVeg,DinnerVeg,DinnerNonVeg,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId,CheckInId)

VALUES(@KOTEntryHdrId,@PropertyId,@BookingId,@BookingCode,@GuestName,
@RoomNo,@BreakfastVeg,@BreakfastNonVeg,@LunchVeg,@LunchNonVeg,@DinnerVeg,
@DinnerNonVeg,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID(),@CheckInId)

SET @InsId=@@IDENTITY;
SELECT Id,RowId FROM WRBHBKOTDtls WHERE Id=@InsId;
END
GO

