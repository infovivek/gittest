SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_KOTEntryHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_KOTEntryHdr_Update]
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

CREATE PROCEDURE [dbo].[SP_KOTEntryHdr_Update](
@PropertyName NVARCHAR(100),@Date NVARCHAR(100),
@PropertyId BIGINT,@BookingId BIGINT,@CheckInId INT,
@UserId BIGINT,@Id BIGINT)

AS
BEGIN
UPDATE WRBHBKOTHdr SET PropertyName=@PropertyName,Date=CONVERT(Date,@Date,103),
PropertyId=@PropertyId,CheckInId=@CheckInId,BookingId=@BookingId,ModifiedBy=@UserId,ModifiedDate=GETDATE()
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBKOTHdr WHERE Id=@Id;
END
GO