SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutSettleDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutSettleDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 28/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutSettleDtl_Insert](@CheckOutSettleHdrId INT,
@PropertyId INT,@GuestId INT,@BillType NVARCHAR(100),@BillNo INT,
@BillAmount DECIMAL(27,2),@NetAmount DECIMAL(27,2),@OutStanding DECIMAL(27,2),
@PaymentStatus NVARCHAR(100),@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT,@ChkInHdrId int,@GuestName nvarchar(100),@NoOfDays int,@BookingId int,
@RoomId int,@BedId int,@ApartmentId int;
 -- INSERT

INSERT INTO WRBHBCheckOutSettleDtl(CheckOutSettleHdrId,PropertyId,GuestId,BillNo,BillType,
BillAmount,NetAmount,OutStanding,PaymentStatus,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES
(@CheckOutSettleHdrId,@PropertyId,@GuestId,@BillNo,@BillType,@BillAmount,@NetAmount,@OutStanding,@PaymentStatus,
 @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

--UPDATE WRBHBChechkOutHdr SET GuestName =@GuestName,

--ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
--ChkInHdrId=@ChkInHdrId,NoOfDays=@NoOfDays,
--GuestId=@GuestId,BookingId=@BookingId,RoomId=@RoomId,
--BedId=@BedId,ApartmentId=@ApartmentId,
--PropertyId=@PropertyId,
--Status= 'CheckOut',Flag=1

--WHERE Id=@Id and ChkInHdrId =@ChkInHdrId and GuestId=@GuestId and PropertyId =@PropertyId;
SELECT Id,RowId FROM WRBHBCheckOutSettleDtl WHERE Id=@Id;
END
GO


