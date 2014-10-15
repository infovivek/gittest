SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOutServiceHdr_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOutServiceHdr_Select]
GO
/*=============================================
Author Name  : Anbu
Created Date : 19/05/14 
Section  	 : Guest Service
Purpose  	 : CheckoutService (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_CheckOutServiceHdr_Select]
(@Id INT=NULL)
AS
BEGIN
	IF @Id=0 
		BEGIN
			  SELECT CheckOutHdrId,NetAmount,Id
			  FROM WRBHBCheckOutServiceHdr 
			  WHERE IsDeleted=0 AND IsActive=0  ORDER BY Id DESC;
		 END
ELSE
	 BEGIN
	  -- Header
		  SELECT CheckOutHdrId,ChkOutServiceAmtl,ChkOutserviceVat,ChkOutServiceLT,
		  ChhkOutserviceST,NetAmount,Id
		  FROM WRBHBCheckOutServiceHdr WHERE Id=@Id;
	  
	  END
END
GO