SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_LaundryServiceDtl_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_LaundryServiceDtl_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 22/09/14 
Section  	 : Guest Service
Purpose  	 : LaundryService_Update (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_LaundryServiceDtl_Update]
(
@PropertyName NVARCHAR(100),@Date NVARCHAR(100),
@PropertyId BIGINT,@GuestName NVARCHAR(100),@GuestId BIGINT,@GetType NVARCHAR(100),@RoomNo NVARCHAR(100),
@BookingCode nvarchar(100),@ClientName nvarchar(100),@CreatedBy BIGINT,@Id BIGINT,@TotalAmount DECIMAL(27,2),
@BookingId BIGINT,@RoomId BIGINT,@CheckInId BIGINT)

AS
BEGIN
UPDATE WRBHBLaundrServiceHdr SET PropertyName=@PropertyName,Date=@Date,
PropertyId=@PropertyId,GuestName=@GuestName,GuestId=@GuestId,GetType=@GetType,
RoomNo=@RoomNo,BookingCode=@BookingCode,ClientName=@ClientName,TotalAmount=@TotalAmount,
BookingId=@BookingId,RoomId=@RoomId,CheckInId=@CheckInId,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBLaundrServiceHdr WHERE Id=@Id;
END
GO