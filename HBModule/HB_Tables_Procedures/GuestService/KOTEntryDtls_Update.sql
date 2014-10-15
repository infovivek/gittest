SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_KOTEntryDtls_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_KOTEntryDtls_Update]
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
CREATE PROCEDURE [dbo].[SP_KOTEntryDtls_Update](@KOTEntryHdrId BIGINT,
@PropertyId BIGINT,@BookingId BIGINT,
@BookingCode NVARCHAR(100),@GuestName NVARCHAR(100),
@RoomNo NVARCHAR(100),@BreakfastVeg BIGINT=NULL,
@BreakfastNonVeg BIGINT=NULL,@LunchVeg BIGINT=NULL,
@LunchNonVeg BIGINT= NULL,@DinnerVeg BIGINT=NULL,
@DinnerNonVeg BIGINT=NULL,@CheckInId INT,@UserId BIGINT,@Id BIGINT)

AS
BEGIN
UPDATE WRBHBKOTDtls SET KOTEntryHdrId=@KOTEntryHdrId,PropertyId=@PropertyId,
BookingId=@BookingId,BookingCode=@BookingCode,
GuestName=@GuestName,RoomNo=@RoomNo,BreakfastVeg=@BreakfastVeg,
BreakfastNonVeg=@BreakfastNonVeg,LunchVeg=@LunchVeg,LunchNonVeg=@LunchNonVeg,
DinnerVeg=@DinnerVeg,DinnerNonVeg=@DinnerNonVeg,CheckInId=@CheckInId,ModifiedBy=@UserId,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBKOTDtls WHERE Id=@Id;
END
GO