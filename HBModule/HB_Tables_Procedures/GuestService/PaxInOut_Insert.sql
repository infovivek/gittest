
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
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PaxInOut_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_PaxInOut_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 30/06/2014 
Section  	 : GuestService
Purpose  	 : Pax In/Out
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_PaxInOut_Insert]
(@ChkInHdrId INT,@RoomId INT,@PropertyId INT,
@Property NVARCHAR(100),@InOut BIT,@Date NVARCHAR(100),@Time NVARCHAR(100),@Male INT,@Female INT,
@Child INT,@Tariff DECIMAL(27,2),@UsrId INT,@Cess DECIMAL(27,2),
@HECess DECIMAL(27,2),@VAT DECIMAL(27,2),@ServiceTax DECIMAL(27,2),
@Luxury DECIMAL(27,2),@ExtraBed DECIMAL(27,2),@TaxId INT,
@Tax DECIMAL(27,2),@OldMale INT,@OldFemale INT,@OldTariff DECIMAL(27,2),
@OldTax DECIMAL(27,2),@RoomNo NVARCHAR(100),@RoomType NVARCHAR(100))
AS
BEGIN
DECLARE @Cnt INT;
--ALREADY EXIST ENTRY CHECK
	 SET @Cnt=(SELECT COUNT(*) FROM WRBHBPaxInOut 
	 WHERE Date=CONVERT(DATE,@Date,103) AND IsActive=0 AND IsDeleted=0
	 AND ChkInHdrId=@ChkInHdrId AND RoomId=@RoomId); 
IF @Cnt=0
 BEGIN
	  INSERT INTO WRBHBPaxInOut(ChkInHdrId,RoomId,InOut,Date,Time,Male,Female,
	  Child,Tariff,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDeleted,
	  IsActive,RowId,Cess,HECess,VAT,ServiceTax,Luxury,ExtraBed,PropertyId,TaxId,
	  Tax,OldMale,OldFemale,OldTariff,OldTax,RoomNo,RoomType,Property)
	  VALUES(@ChkInHdrId,@RoomId,@InOut,CONVERT(Date,@Date,103),@Time,@Male,
	  @Female,@Child,@Tariff,@UsrId,GETDATE(),@UsrId,GETDATE(),0,0,NEWID(),
	  @Cess,@HECess,@VAT,@ServiceTax,@Luxury,@ExtraBed,@PropertyId,@TaxId,@Tax,
	  @OldMale,@OldFemale,@OldTariff,@OldTax,@RoomNo,@RoomType,@Property);
    
	  SELECT Id,RowId FROM WRBHBPaxInOut WHERE Id=@@IDENTITY;
END
ELSE
BEGIN
  UPDATE WRBHBPaxInOut SET IsActive=1,ModifiedBy=@UsrId,
  ModifiedDate=GETDATE() WHERE Date=CONVERT(DATE,@Date,103) AND 
  IsActive=0 AND IsDeleted=0 AND ChkInHdrId=@ChkInHdrId AND RoomId=@RoomId;
  --
  INSERT INTO WRBHBPaxInOut(ChkInHdrId,RoomId,InOut,Date,Time,Male,Female,
  Child,Tariff,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDeleted,
  IsActive,RowId,Cess,HECess,VAT,ServiceTax,Luxury,ExtraBed,PropertyId,TaxId,
  Tax,OldMale,OldFemale,OldTariff,OldTax,RoomNo,RoomType,Property)
  VALUES(@ChkInHdrId,@RoomId,@InOut,CONVERT(Date,@Date,103),@Time,@Male,
  @Female,@Child,@Tariff,@UsrId,GETDATE(),@UsrId,GETDATE(),0,0,NEWID(),
  @Cess,@HECess,@VAT,@ServiceTax,@Luxury,@ExtraBed,@PropertyId,@TaxId,@Tax,
  @OldMale,@OldFemale,@OldTariff,@OldTax,@RoomNo,@RoomType,@Property);
  

  SELECT Id,RowId FROM WRBHBPaxInOut WHERE Id=@@IDENTITY;  
 END

END
GO