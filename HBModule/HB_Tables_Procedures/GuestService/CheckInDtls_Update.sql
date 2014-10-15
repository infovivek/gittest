-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CheckInDtls_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_CheckInDtls_Update]
GO
/*=============================================
Author Name  : Naharjun
Created Date : 29/04/2014 
Section  	 : Transaction
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CheckInDtls_Update](@ChkInHdrId BIGINT=NULL,@PropertyId BIGINT=NULL,@RoomNo BIGINT=NULL,
@RoomType NVARCHAR(100)=NULL,@Pax BIGINT=NULL,@Tariff DECIMAL(27,2)=NULL,
@TariffId BIGINT=NULL,@RoomId BIGINT=NULL, @BookingId BIGINT=NULL,@CreatedBy BIGINT,@Id BIGINT)

AS
BEGIN
DECLARE @InsId INT;
UPDATE WRBHBCheckInDtls SET ChkInHdrId=@ChkInHdrId,PropertyId=@PropertyId,RoomNo=@RoomNo,RoomType=@RoomType,
Pax=@Pax,Tariff=@Tariff,TariffId=@TariffId,RoomId=@RoomId,BookingId=@BookingId, ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
WHERE Id=@Id


SELECT Id,RowId FROM WRBHBCheckInDtls WHERE Id=@Id;
END
GO