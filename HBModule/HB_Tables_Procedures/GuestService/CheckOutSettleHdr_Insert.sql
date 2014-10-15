SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutSettleHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutSettleHdr_Insert]
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
CREATE PROCEDURE [dbo].[SP_CheckOutSettleHdr_Insert](
@ChkOutHdrId INT,@PayeeName NVARCHAR(100),@Address NVARCHAR(4000),
@Consolidated BIT,@CreatedBy BIGINT)

AS
BEGIN

DECLARE @Id INT,@ChkInHdrId int,@GuestName nvarchar(100),@NoOfDays int,@GuestId nvarchar(100),@BookingId int,
@RoomId int,@BedId int,@ApartmentId int,@PropertyId int;
 -- INSERT,
INSERT INTO WRBHBCheckOutSettleHdr(ChkOutHdrId,PayeeName,Address,Consolidated,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES
(@ChkOutHdrId,@PayeeName,@Address,@Consolidated,
 @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
 SET @Id=@@IDENTITY;
 
 SELECT Id,RowId,ChkOutHdrId FROM WRBHBCheckOutSettleHdr WHERE Id=@Id;

UPDATE WRBHBChechkOutHdr SET-- GuestName=@GuestName,

ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
--ChkInHdrId=@ChkInHdrId,NoOfDays=@NoOfDays,
--GuestId=@GuestId,BookingId=@BookingId,RoomId=@RoomId,
--BedId=@BedId,ApartmentId=@ApartmentId,
--PropertyId=@PropertyId,
Status= 'CheckOut',Flag=1

WHERE  Id =@ChkOutHdrId --and GuestId=@GuestId and PropertyId =@PropertyId;





END
GO