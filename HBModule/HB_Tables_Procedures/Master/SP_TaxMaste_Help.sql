SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_TaxMaster_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_TaxMaster_Help]
GO
/*=============================================
Author Name  : Anbu
Created Date : 03/04/2014 
Section  	 : Master
Purpose  	 : Tax
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
-- =============================================*/
CREATE PROCEDURE [dbo].[SP_TaxMaster_Help]
(
@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Id INT=NULL,
@StateId INT=NULL
)
AS
BEGIN
IF @Action ='STATELOAD'
   BEGIN
	  SELECT  StateName label,Id AS Data FROM WRBHBState 
	  WHERE IsActive=1;
   END
IF @Action='StateTax'
   	BEGIN
		SELECT TOP 1 Cess,HECess,VAT,Id,ServiceTaxOnTariff,TariffAmtFrom,TariffAmtTo,LTaxper,
		TariffAmtFrom1,TariffAmtTo1,LTaxper1,TariffAmtFrom2,TariffAmtTo2,LTaxper2,
		TariffAmtFrom3,TariffAmtTo3,LTaxper3,
		Convert(NVARCHAR,Date,103) AS Date,State,StateId,VATNo,LuxuryNo,ServiceNo,
		RestaurantST,BusinessSupportST,RackTariff,TINNumber,CINNumber
		FROM WRBHBTaxMaster 
		WHERE StateId=@StateId  AND IsActive=1 AND IsDeleted=0 order by Id desc;
		
		SELECT Cess,HECess,VAT,Id,ServiceTaxOnTariff,TariffAmtFrom,TariffAmtTo,LTaxper,
		RestaurantST,BusinessSupportST,Convert(NVARCHAR,Date,103) AS EffectiveFrom,
		Convert(NVARCHAR,DateTo ,103)AS EffectiveTo,State,StateId
		FROM WRBHBTaxMaster 
		WHERE StateId=@StateId AND IsActive=1 AND IsDeleted=0 order by Id ASC;
		
	END
END