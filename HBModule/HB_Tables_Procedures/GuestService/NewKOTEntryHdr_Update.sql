SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTEntryHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_NewKOTEntryHdr_Update]
GO
/*=============================================
Author Name  : shameem
Created Date : 12/05/14 
Section  	 : Guest Service
Purpose  	 : KOT Entry  (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_NewKOTEntryHdr_Update](
@PropertyName NVARCHAR(100),@Date NVARCHAR(100),
@PropertyId BIGINT,@GuestName NVARCHAR(100),@GuestId BIGINT,@GetType NVARCHAR(100),@RoomNo NVARCHAR(100),
@BookingCode nvarchar(100),@ClientName nvarchar(100),@CreatedBy BIGINT,@Id BIGINT,@TotalAmount DECIMAL(27,2),
@BookingId BIGINT,@RoomId BIGINT,@CheckInId BIGINT)

AS
BEGIN
UPDATE WRBHBNewKOTEntryHdr SET PropertyName=@PropertyName,Date=@Date,
PropertyId=@PropertyId,GuestName=@GuestName,GuestId=@GuestId,GetType=@GetType,
RoomNo=@RoomNo,BookingCode=@BookingCode,ClientName=@ClientName,TotalAmount=@TotalAmount,
BookingId=@BookingId,RoomId=@RoomId,CheckInId=@CheckInId,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBNewKOTEntryHdr WHERE Id=@Id;
END
GO