-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutHdr_Update]
GO
/*=============================================
Author Name  : shameem
Modifiedby   : Anbu
Modified Date : 21/05/14 
Section  	 : Transaction
Purpose  	 : Checkout (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutHdr_Update](@CheckOutNo NVARCHAR(100),
@GuestName NVARCHAR(100),@Stay NVARCHAR(100),
@Type NVARCHAR(100),@BookingLevel NVARCHAR(100),@BillDate NVARCHAR(100),@ClientName NVARCHAR(100),
@Property NVARCHAR(100),@ChkOutTariffTotal DECIMAL(27,2),@ChkOutTariffAdays DECIMAL(27,2),
@ChkOutTariffDiscount DECIMAL(27,2),@ChkOutTariffLT DECIMAL(27,2),@ChkOutTariffST1 DECIMAL(27,2),
@ChkOutTariffST2 DECIMAL(27,2),@ChkOutTariffSC DECIMAL(27,2),@ChkOutTariffST3 DECIMAL(27,2),
@ChkOutTariffCess DECIMAL(27,2),@ChkOutTariffHECess DECIMAL(27,2),@ChkOutTariffNetAmount DECIMAL(27,2),
@ChkOutTariffReferance NVARCHAR(100),@CreatedBy BIGINT,@Id BIGINT,@Name NVARCHAR(100),
@ChkOutTariffExtraType NVARCHAR(100),@CheckOutTariffExtraDays INT,@ChkOutTariffExtraAmount DECIMAL(27,2),
@ChkInHdrId INT,@NoOfDays INT,@RoomId INT,
@CheckInType NVARCHAR(100),@ApartmentNo NVARCHAR(100),@BedNo NVARCHAR(100),@BedId INT,@ApartmentId INT,
@PropertyId int,@GuestId int,@BookingId int,@StateId int,@Direct nvarchar(100),
@BTC nvarchar(100),@PropertyType nvarchar(100))

AS
BEGIN
UPDATE WRBHBChechkOutHdr SET CheckOutNo = @CheckOutNo,GuestName =@GuestName,
Stay=@Stay,Type=@Type,BookingLevel=@BookingLevel,BillDate=@BillDate,
ClientName=@ClientName,Property=@Property,ChkOutTariffTotal=@ChkOutTariffTotal,
ChkOutTariffAdays=@ChkOutTariffAdays,ChkOutTariffDiscount=@ChkOutTariffDiscount,
ChkOutTariffLT=@ChkOutTariffLT,ChkOutTariffST1=@ChkOutTariffST1,ChkOutTariffST2=@ChkOutTariffST2,
ChkOutTariffSC=@ChkOutTariffSC,ChkOutTariffST3=@ChkOutTariffST3,
ChkOutTariffCess=@ChkOutTariffCess,ChkOutTariffHECess=@ChkOutTariffHECess,
ChkOutTariffNetAmount=@ChkOutTariffNetAmount,ChkOutTariffReferance=@ChkOutTariffReferance,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Name=@Name,ChkOutTariffExtraType=@ChkOutTariffExtraType,
ChkOutTariffExtraDays=@CheckOutTariffExtraDays,ChkOutTariffExtraAmount=@ChkOutTariffExtraAmount,
ChkInHdrId=@ChkInHdrId,NoOfDays=@NoOfDays,RoomId=@RoomId,CheckInType=@CheckInType,
ApartmentNo=@ApartmentNo,BedNo=@BedNo,BedId=@BedId,ApartmentId=@ApartmentId,
PropertyId=@PropertyId,GuestId=@GuestId,BookingId=@BookingId,
Direct=@Direct,BTC=@BTC,PropertyType=@PropertyType
WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBChechkOutHdr WHERE Id=@Id;
END
GO