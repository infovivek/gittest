SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_KOTEntryHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_KOTEntryHdr_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 12/05/2014 
Section  	 : Guest Service
Purpose  	 : KOT Entry Header
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_KOTEntryHdr_Insert](
@PropertyName NVARCHAR(100),@Date NVARCHAR(100),
@PropertyId BIGINT,@BookingId BIGINT,@CheckInId BIGINT,
@UserId BIGINT)

AS
BEGIN
DECLARE @InsId INT;

-- CHECKIN PROPERTY INSERT
INSERT INTO WRBHBKOTHdr(PropertyId,CheckInId,BookingId,PropertyName,Date,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@PropertyId,@CheckInId,@BookingId,@PropertyName,CONVERT(Date,@Date,103),
@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID())


SET @InsId=@@IDENTITY;
SELECT Id,RowId FROM WRBHBKOTHdr WHERE Id=@InsId;
END
GO

