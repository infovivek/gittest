SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTEntryHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_NewKOTEntryHdr_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 24/05/2014 
Section  	 : Guest Service
Purpose  	 : New KOT Entry Header
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_NewKOTEntryHdr_Insert](@PropertyId BIGINT,
@PropertyName NVARCHAR(100),@Date NVARCHAR(100),
@GuestName NVARCHAR(100),@GuestId BIGINT,@GetType NVARCHAR(100),@RoomNo NVARCHAR(100),
@BookingCode nvarchar(100),@ClientName nvarchar(100),@CreatedBy BIGINT,@TotalAmount DECIMAL(27,2),
@BookingId BIGINT,@RoomId BIGINT,@CheckInId BIGINT)

AS
BEGIN
DECLARE @Id INT;

-- CHECKIN PROPERTY INSERT
INSERT INTO WRBHBNewKOTEntryHdr(PropertyId,PropertyName,Date,GuestName,GuestId,GetType,RoomNo,
BookingCode,ClientName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,TotalAmount,
BookingId,RoomId,CheckInId)

VALUES(@PropertyId,@PropertyName,CONVERT(Date,@Date,103),@GuestName,@GuestId,@GetType,@RoomNo,
@BookingCode,@ClientName,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@TotalAmount,
@BookingId,@RoomId,@CheckInId)


SET @Id=@@IDENTITY;
SELECT Id,RowId FROM WRBHBNewKOTEntryHdr WHERE Id=@Id;
END
GO

