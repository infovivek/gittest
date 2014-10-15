
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ExterCheckOutTAC_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ExterCheckOutTAC_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 22/07/14 
Section  	 : Guest Service
Purpose  	 : Checkout External Tac
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_ExterCheckOutTAC_Insert](@ChkOutHdrId int,
@TACInvoiceNo NVARCHAR(100),@TACInvoiceFile nvarchar(max),@GuestName NVARCHAR(100),
@BillDate NVARCHAR(100),@ClientName NVARCHAR(100),
@Property NVARCHAR(100),@ChkOutTariffTotal DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT,
@ChkInHdrId INT,@NoOfDays INT,@RoomId INT,
@PropertyId int,@GuestId int,@BookingId int,@StateId int,@Direct nvarchar(100),
@PropertyType nvarchar(100),@Status nvarchar(100),@CheckOutDate nvarchar(100),
@CheckInDate nvarchar(100),@MarkUpAmount decimal(27,2),@BusinessSupportST decimal(27,2),
@Rate decimal(27,2),@TotalBusinessSupportST decimal(27,2),@TACAmount decimal(27,2)
)
AS
BEGIN
	DECLARE @InsId INT,@Cnt INT,@Cnt1 INT,@SCode INT;--,@TACInvoiceNo nvarchar(100);
	
IF @PropertyType = 'External Property'
BEGIN
		
	IF EXISTS (SELECT NULL FROM WRBHBExternalChechkOutTAC
	WHERE PropertyType ='External Property' and ISNULL(TACInvoiceNo,'') != '')
	BEGIN
	SELECT TOP 1 @TACInvoiceNo='EXT/'+
	CAST(CAST(SUBSTRING(TACInvoiceNo,5,LEN(TACInvoiceNo)) AS INT) + 1 AS VARCHAR)
	FROM WRBHBExternalChechkOutTAC 
	where PropertyType ='External Property'  and TACInvoiceNo!=''
	ORDER BY Id DESC;
	END
	ELSE
	BEGIN
	set @TACInvoiceNo='EXT/01';
	END
END
ELSE
BEGIN
	set @TACInvoiceNo=0;
END
	
	



 
  -- INSERT
INSERT INTO WRBHBExternalChechkOutTAC(ChkOutHdrId,TACInvoiceNo,TACInvoiceFile,GuestName,
BillDate,ClientName,Property,ChkOutTariffTotal,ChkOutTariffCess,
ChkOutTariffHECess,ChkOutTariffNetAmount,ChkInHdrId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,NoOfDays,
RoomId,PropertyId,GuestId,BookingId,StateId,Direct ,
PropertyType,Status ,CheckInDate,CheckOutDate ,MarkUpAmount,BusinessSupportST,Rate,
TotalBusinessSupportST,TACAmount,PaymentStatus,Flag)
values(@ChkOutHdrId,@TACInvoiceNo,@TACInvoiceFile,@GuestName,@BillDate,@ClientName,
@Property,@ChkOutTariffTotal,@ChkOutTariffCess,
@ChkOutTariffHECess,@ChkOutTariffNetAmount,@ChkInHdrId,@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID(),@NoOfDays,
@RoomId,@PropertyId,@GuestId,@BookingId,@StateId,@Direct ,
@PropertyType,@Status,@CheckInDate,@CheckOutDate,@MarkUpAmount,@BusinessSupportST,@Rate,
@TotalBusinessSupportST,@TACAmount,'Paid','1')

SET @InsId=@@IDENTITY;
SELECT  Id ,RowId ,DATENAME(WEEKDAY, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
    CONVERT(VARCHAR(12),CreatedDate,103) BookingDate,TACInvoiceNo FROM WRBHBExternalChechkOutTAC WHERE Id=@InsId;
    
 
 
    
 UPDATE WRBHBBookingPropertyAssingedGuest SET CurrentStatus = 'CheckOut' ,
 CheckOutHdrId = @InsId
 WHERE BookingId=@BookingId and 
 RoomCaptured=(SELECT TOP 1 RoomCaptured FROM WRBHBBookingPropertyAssingedGuest
 WHERE BookingId=@BookingId and GuestId=@GuestId
 ORDER BY Id ASC);

END






