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
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PaxInOut_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_PaxInOut_Update]
GO
/*=============================================
Author Name  : Anbu
Created Date : 30/06/2014 
Section  	 : GuestService
Purpose  	 : PaxIn/OutUpdate
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_PaxInOut_Update]
(@ChkInHdrId INT,@RoomId INT,
@InOut BIT,@Date NVARCHAR(100),@Time NVARCHAR(100),@Male INT,@Female INT,
@Child INT,@Tariff DECIMAL(27,2),@UsrId INT,@Id INT,@Cess DECIMAL(27,2),
@HECess DECIMAL(27,2),@VAT DECIMAL(27,2),@ServiceTax DECIMAL(27,2),
@Luxury DECIMAL(27,2),@ExtraBed DECIMAL(27,2),@PropertyId INT,@TaxId INT,
@Tax DECIMAL(27,2),@OldMale INT,@OldFemale INT,@OldTariff DECIMAL(27,2),
@OldTax DECIMAL(27,2),@RoomNo NVARCHAR(100),@RoomType NVARCHAR(100),
@Property NVARCHAR(100))
AS
BEGIN
	UPDATE WRBHBPaxInOut SET Date=CONVERT(DATE,@Date,103),Time=@Time,
	Male=@Male,Female=@Female,Child=@Child,Tariff=@Tariff,
	ModifiedBy=@UsrId,ModifiedDate=GETDATE(),Cess=@Cess,HECess=@HECess,
	VAT=@VAT,ServiceTax=@ServiceTax,Luxury=Luxury,ExtraBed=@ExtraBed,
	PropertyId=@PropertyId,Property=@Property,TaxId=@TaxId,Tax=@Tax WHERE Id=@Id;


	SELECT Id,RowId FROM WRBHBPaxInOut WHERE Id=@Id;
END
GO