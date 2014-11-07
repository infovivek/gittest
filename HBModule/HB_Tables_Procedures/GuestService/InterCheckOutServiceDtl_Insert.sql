SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_InterCheckOutServiceDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_InterCheckOutServiceDtl_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 19/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Detail)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_InterCheckOutServiceDtl_Insert](
@CheckOutServceHdrId INT,
@ChkOutSerAction BIT,@ChkOutSerInclude BIT,
@ChkOutSerDate NVARCHAR(100),@ChkOutSerItem NVARCHAR(100),
@ChkOutSerAmount DECIMAL(27,2),@ProductId INT,@TypeService NVARCHAR(100),
@ChkOutSerQuantity INT,@ChkOutSerNetAmount DECIMAL(27,2),
@CreatedBy BIGINT,@Id BIGINT,@Quantity DECIMAL(27,2))

AS
BEGIN
DECLARE @Id1 INT,@PropertyId BIGINT,@BookingId BIGINT,@GuestId BIGINT,@RoomId BIGINT,@NewKOTEntryHdrId BIGINT,
@GuestName nvarchar(100);

DECLARE @IntermediateFlag NVARCHAR(100)
SET @IntermediateFlag = (SELECT IntermediateFlag FROM WRBHBChechkOutHdr WHERE Id = @CheckOutServceHdrId)

IF @IntermediateFlag = '1'
BEGIN
 -- INSERT
INSERT INTO WRBHBCheckOutServiceDtls(CheckOutServceHdrId,ChkOutSerAction,
ChkOutSerInclude,ChkOutSerDate,ChkOutSerItem,ChkOutSerAmount,ChkOutSerQuantity
,ChkOutSerNetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
ProductId,TypeService)

VALUES
(@CheckOutServceHdrId,@ChkOutSerAction,@ChkOutSerInclude,@ChkOutSerDate,@ChkOutSerItem,
@ChkOutSerAmount,@ChkOutSerQuantity,@ChkOutSerNetAmount,@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID(),@ProductId,@TypeService)


SET @Id1=@@IDENTITY;
SELECT Id,RowId FROM WRBHBCheckOutServiceDtls WHERE Id=@Id1;

SELECT  @PropertyId=PropertyId,@BookingId=BookingId,@GuestId=GuestId,@RoomId=RoomId,@GuestName=GuestName 
FROM WRBHBChechkOutHdr WHERE Id=@CheckOutServceHdrId
IF @TypeService='Food And Beverages'
BEGIN
	IF @Id=0
	BEGIN
		INSERT INTO WRBHBNewKOTEntryHdr(PropertyId,PropertyName,Date,GuestName,GuestId,GetType,RoomNo,
		BookingCode,ClientName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,TotalAmount,
		BookingId,RoomId,CheckInId)

		VALUES(@PropertyId,'',CONVERT(Date,@ChkOutSerDate,103),@GuestName,@GuestId,'','',
		'','',@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),0,0,NEWID(),0,
		@BookingId,@RoomId,0)
		
		SELECT @NewKOTEntryHdrId=@@IDENTITY

		INSERT INTO WRBHBNewKOTEntryDtl(NewKOTEntryHdrId,ServiceItem,
		Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,IsDeleted,RowId)

		VALUES(@NewKOTEntryHdrId,@ChkOutSerItem,@Quantity,
		0,@ChkOutSerAmount,@ProductId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),0,0,NEWID())
	END
	ELSE
	BEGIN		

		UPDATE WRBHBNewKOTEntryDtl SET ServiceItem=@ChkOutSerItem,
		Quantity=@Quantity,Price=0,Amount=@ChkOutSerAmount,
		ItemId= @ProductId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id;
	
	END
END
END
ELSE
BEGIN
 -- INSERT
INSERT INTO WRBHBCheckOutServiceDtls(CheckOutServceHdrId,ChkOutSerAction,
ChkOutSerInclude,ChkOutSerDate,ChkOutSerItem,ChkOutSerAmount,ChkOutSerQuantity
,ChkOutSerNetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
ProductId,TypeService)

VALUES
(@CheckOutServceHdrId,@ChkOutSerAction,@ChkOutSerInclude,@ChkOutSerDate,@ChkOutSerItem,
@ChkOutSerAmount,@ChkOutSerQuantity,@ChkOutSerNetAmount,@CreatedBy,GETDATE(),@CreatedBy,
GETDATE(),1,0,NEWID(),@ProductId,@TypeService)


SET @Id1=@@IDENTITY;
SELECT Id,RowId FROM WRBHBCheckOutServiceDtls WHERE Id=@Id1;

SELECT  @PropertyId=PropertyId,@BookingId=BookingId,@GuestId=GuestId,@RoomId=RoomId,@GuestName=GuestName 
FROM WRBHBChechkOutHdr WHERE Id=@CheckOutServceHdrId
IF @TypeService='Food And Beverages'
BEGIN
	IF @Id=0
	BEGIN
		INSERT INTO WRBHBNewKOTEntryHdr(PropertyId,PropertyName,Date,GuestName,GuestId,GetType,RoomNo,
		BookingCode,ClientName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,TotalAmount,
		BookingId,RoomId,CheckInId)

		VALUES(@PropertyId,'',CONVERT(Date,@ChkOutSerDate,103),@GuestName,@GuestId,'','',
		'','',@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),0,
		@BookingId,@RoomId,0)
		
		SELECT @NewKOTEntryHdrId=@@IDENTITY

		INSERT INTO WRBHBNewKOTEntryDtl(NewKOTEntryHdrId,ServiceItem,
		Quantity,Price,Amount,ItemId,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,IsDeleted,RowId)

		VALUES(@NewKOTEntryHdrId,@ChkOutSerItem,@Quantity,
		0,@ChkOutSerAmount,@ProductId,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
	END
	ELSE
	BEGIN		

		UPDATE WRBHBNewKOTEntryDtl SET ServiceItem=@ChkOutSerItem,
		Quantity=@Quantity,Price=0,Amount=@ChkOutSerAmount,
		ItemId= @ProductId,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id;
	
	END
END
END


END
GO