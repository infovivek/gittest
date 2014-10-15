SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_TaxMaster_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_TaxMaster_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 02/04/2014 
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
CREATE PROCEDURE [dbo].[SP_TaxMaster_Insert]
(@Cess			DECIMAL(27,2)=NULL,
@HECess			DECIMAL(27,2)=NULL,
@VAT			DECIMAL(27,2)=NULL,
@ServiceAmount  decimal(27,2),
@TariffAmtFrom  DECIMAL(27,2)=NULL,
@TariffAmtTo    DECIMAL(27,2)=NULL,
@Taxper			DECIMAL(27,2)=NULL,
@TariffAmtFrom1  DECIMAL(27,2)=NULL,
@TariffAmtTo1    DECIMAL(27,2)=NULL,
@Taxper1			DECIMAL(27,2)=NULL,
@TariffAmtFrom2  DECIMAL(27,2)=NULL,
@TariffAmtTo2    DECIMAL(27,2)=NULL,
@Taxper2			DECIMAL(27,2)=NULL,
@TariffAmtFrom3  DECIMAL(27,2)=NULL,
@TariffAmtTo3    DECIMAL(27,2)=NULL,
@Taxper3			DECIMAL(27,2)=NULL,
@State          NVARCHAR(100),
@StateId        BIGINT,
@Date           NVARCHAR(100),
@VATNo			NVARCHAR(100),
@LuxuryNo		NVARCHAR(100),
@ServiceNo		NVARCHAR(100),
@RestaurantST   DECIMAL(27,2)=NULL,
@BusinessSupportST DECIMAL(27,2)=NULL,
@RackTariff		BIT,
@CreatedBy      BIGINT,
@TINNumber      NVARCHAR(250) ,
@CINNumber      NVARCHAR(250))
AS
BEGIN
DECLARE @Id INT;
INSERT INTO WRBHBTaxMaster(Cess,HECess,VAT,ServiceTaxOnTariff,TariffAmtFrom,TariffAmtTo,LTaxper,
TariffAmtFrom1,TariffAmtTo1,LTaxper1,TariffAmtFrom2,TariffAmtTo2,LTaxper2,TariffAmtFrom3,TariffAmtTo3,LTaxper3,
CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,IsActive,IsDeleted,RowId,State,StateId,Date,VATNo,LuxuryNo,ServiceNO,
RestaurantST,BusinessSupportST,RackTariff,TINNumber,CINNumber)

VALUES(@Cess,@HECess,@VAT,@ServiceAmount,@TariffAmtFrom,@TariffAmtTo,
@Taxper,@TariffAmtFrom1,@TariffAmtTo1,@Taxper1,@TariffAmtFrom2,@TariffAmtTo2,@Taxper2,@TariffAmtFrom3,1000000,
@Taxper3,@CreatedBy,@CreatedBy,
GETDATE(),GETDATE(),1,0,NEWID(),@State,@StateId,Convert(date,@Date,103),@VATNo,@LuxuryNo,@ServiceNo,
@RestaurantST,@BusinessSupportST,@RackTariff,@TINNumber,@CINNumber);
SET @Id=@@IDENTITY;

SELECT Id,RowId FROM WRBHBTaxMaster WHERE Id=@Id;
END



--Alter table WRBHBTaxMaster add TINNumber nvarchar(250) default 0;
--Alter table WRBHBTaxMaster add CINNumber nvarchar(250) default 0;
--update   WRBHBTaxMaster set TINNumber=0,CINNumber=0
