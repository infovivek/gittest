-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CheckInDtls_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInDtls_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 28/04/2014 
Section  	 : Transaction
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CheckInDtls_Insert](@ChkInHdrId BIGINT=NULL,@PropertyId BIGINT=NULL,@RoomNo BIGINT=NULL,
@RoomType NVARCHAR(100)=NULL,@Pax BIGINT=NULL,
@Tariff DECIMAL(27,2)=NULL,
@TariffId BIGINT=NULL,@RoomId BIGINT=NULL, @BookingId BIGINT=NULL,@CreatedBy BIGINT)

AS
BEGIN
DECLARE @InsId INT;
INSERT INTO WRBHBCheckInDtls(ChkInHdrId,PropertyId,RoomNo,RoomType,Pax,
Tariff,TariffId,RoomId,BookingId,CreatedBy,ModifiedBy,CreatedDate,
ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@ChkInHdrId,@PropertyId,@RoomNo,@RoomType,@Pax,@Tariff,@TariffId,@RoomId,@BookingId,
@CreatedBy,@CreatedBy,GETDATE(),GETDATE(),0,0,NEWID());
SET @InsId=@@IDENTITY;
SELECT Id,RowId FROM WRBHBCheckInDtls WHERE Id=@InsId;
END
GO