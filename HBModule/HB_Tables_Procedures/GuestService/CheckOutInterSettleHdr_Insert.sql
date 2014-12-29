SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutInterSettleHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutInterSettleHdr_Insert]
GO
/*=============================================
Author Name  : shameem
Created Date : 28/05/14 
Section  	 : 
Purpose  	 : CheckoutSettlemet (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutInterSettleHdr_Insert](
@ChkOutHdrId INT,@PayeeName NVARCHAR(100),@Address NVARCHAR(4000),
@Consolidated BIT,@EmailId NVARCHAR(100),@CreatedBy BIGINT)

AS
BEGIN

DECLARE @Id INT,@ChkInHdrId int,@GuestName nvarchar(100),@NoOfDays int,@GuestId nvarchar(100),@BookingId int,
@RoomId int,@BedId int,@ApartmentId int,@PropertyId int,@Logo NVARCHAR(MAX);

SET @LOGO=(SELECT Logo FROM WRBHBCompanyMaster)
 -- INSERT,
INSERT INTO WRBHBCheckOutSettleHdr(ChkOutHdrId,PayeeName,Address,Consolidated,EmailId,
CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES
(@ChkOutHdrId,@PayeeName,@Address,@Consolidated,@EmailId,
 @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
 SET @Id=@@IDENTITY;
 
 SELECT Id,RowId,ChkOutHdrId FROM WRBHBCheckOutSettleHdr WHERE Id=@Id;
 SELECT Property ,stay,@LOGO AS logo ,Email FROM WRBHBChechkOutHdr WHERE Id = @ChkOutHdrId ;
 
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