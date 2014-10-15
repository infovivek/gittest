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
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOut_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOut_Select]
GO
/*=============================================
Author Name  : shameem
Created Date : 08/05/14
Section  	 : Guest service
Purpose  	 : Checkout
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOut_Select](@Id INT=NULL)
AS
BEGIN
	IF @Id=0 
		BEGIN
			  SELECT CheckOutNo AS BillNo,GuestName,Id,
			  CONVERT(VARCHAR(100),BillDate,103) AS BillDate FROM WRBHBChechkOutHdr 
			  WHERE IsDeleted=0 AND IsActive=1  ORDER BY Id DESC;
		 END
ELSE
	 BEGIN
	  -- Header
		  SELECT CheckOutNo,GuestName,Stay,Type,BookingLevel,Name,
		  CONVERT(VARCHAR(100),BillDate,103) as BillDate,ClientName,
		  Property,ChkOutTariffTotal,ChkOutTariffAdays,
		  ChkOutTariffDiscount,ChkOutTariffLT,ChkOutTariffST1,ChkOutTariffST2,
		  ChkOutTariffSC,ChkOutTariffST3,ChkOutTariffCess,ChkOutTariffHECess,
		  ChkOutTariffNetAmount,ChkOutTariffReferance,Id
		  FROM WRBHBChechkOutHdr WHERE Id=@Id;
		  
		  SELECT CheckOutHdrId,ChkOutServiceAmtl,ChkOutServiceVat,ChkOutServiceLT,
		  ChkOutServiceST,ChkOutServiceNetAmount,Id
		  FROM WRBHBCheckOutServiceHdr WHERE CheckOutHdrId=@Id;
		  
		  SELECT CheckOutServceHdrId,ChkOutSerAction,ChkOutSerInclude,ChkOutSerDate,ChkOutSerItem,
		  ChkOutSerAmount,ChkOutSerQuantity,ChkOutSerNetAmount,CS.Id
		  FROM WRBHBCheckOutServiceDtls CS
		  JOIN WRBHBCheckOutServiceHdr SH ON CS.CheckOutServceHdrId=SH.Id AND CS.IsActive=1 AND CS.IsDeleted=0 
		  WHERE SH.CheckOutHdrId=@Id;
	  
	  END
END
GO