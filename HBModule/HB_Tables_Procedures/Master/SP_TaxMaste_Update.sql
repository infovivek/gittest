SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_TaxMaster_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_TaxMaster_Update]
GO 
-- ===============================================================================
-- Author:		Anbu
-- Create date: 03/04/2014
-- ModifiedBy :               , ModifiedDate  : 
-- Description:	Tax Update
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_TaxMaster_Update]
(@Cess DECIMAL(27,2)=NULL,
@HECess DECIMAL(27,2)=NULL,
@VAT DECIMAL(27,2)=NULL,
@Id INT=NULL,
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
@Date               NVARCHAR(100),
@State              NVARCHAR(100),
@StateId			Bigint,
@VATNo			NVARCHAR(100),
@LuxuryNo		NVARCHAR(100),
@ServiceNo		NVARCHAR(100),
@RestaurantST   DECIMAL(27,2)=NULL,
@BusinessSupportST DECIMAL(27,2)=NULL,
@RackTariff			BIT,
@CreatedBy			Bigint,
@TINNumber      NVARCHAR(250) ,
@CINNumber      NVARCHAR(250))
AS
BEGIN
DECLARE @ExsitingId  int
SELECT @ExsitingId= Id FROM WRBHBTaxMaster where Date=Convert(datetime,@Date,103) and IsActive=1 And IsDeleted=0 AND StateId=@StateId

IF(ISNULL(@ExsitingId,0) !=0)
BEGIN
		UPDATE  WRBHBTaxMaster SET  
		Cess=@Cess,HECess=@HECess,VAT=@VAT,ServiceTaxOnTariff=@ServiceAmount,
		TariffAmtFrom=@TariffAmtFrom,VATNo=@VATNo,LuxuryNo=@LuxuryNo,ServiceNo=@ServiceNo,
		RestaurantST=@RestaurantST,BusinessSupportST=@BusinessSupportST,RackTariff=@RackTariff,
		TariffAmtTo=@TariffAmtTo,LTaxper=@Taxper,TariffAmtFrom1=@TariffAmtFrom1,TariffAmtTo1=@TariffAmtTo1,
		LTaxper1=@Taxper1,TariffAmtFrom2=@TariffAmtFrom2,TariffAmtTo2=@TariffAmtTo2,LTaxper2=@Taxper2,
		TariffAmtFrom3=@TariffAmtFrom3,TariffAmtTo3=@TariffAmtTo3,LTaxper3=@Taxper3,ModifiedBy=@CreatedBy,
		ModifiedDate=GETDATE(),Date=CONVERT(DATE,@Date,103),TINNumber=@TINNumber,CINNumber=@CINNumber
		WHERE Id=@ExsitingId AND IsActive=1 AND  IsDeleted=0 ;

END
ELSE
BEGIN
UPDATE WRBHBTaxMaster SET DateTo=(SELECT DATEADD(day,-1,Convert(datetime,@Date,103)))
WHERE Id=@Id AND IsActive=1 AND IsDeleted=0;

INSERT INTO WRBHBTaxMaster(Cess,HECess,VAT,ServiceTaxOnTariff,TariffAmtFrom,TariffAmtTo,LTaxper,
TariffAmtFrom1,TariffAmtTo1,LTaxper1,TariffAmtFrom2,TariffAmtTo2,LTaxper2,TariffAmtFrom3,TariffAmtTo3,LTaxper3,
CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,IsActive,IsDeleted,RowId,State,StateId,Date,VATNo,LuxuryNo,ServiceNo,
RestaurantST,BusinessSupportST,RackTariff,TINNumber,CINNumber)

VALUES(@Cess,@HECess,@VAT,@ServiceAmount,@TariffAmtFrom,@TariffAmtTo,@Taxper,
@TariffAmtFrom1,@TariffAmtTo1,@Taxper1,@TariffAmtFrom2,@TariffAmtTo2,@Taxper2,@TariffAmtFrom3,1000000,
@Taxper3,@CreatedBy,@CreatedBy,
GETDATE(),GETDATE(),1,0,NEWID(),@State,@StateId,Convert(datetime,@Date,103),@VATNo,@LuxuryNo,@ServiceNo,
@RestaurantST,@BusinessSupportST,@RackTariff,@TINNumber,@CINNumber);
SET @Id=@@IDENTITY;

SELECT Id,RowId FROM WRBHBTaxMaster WHERE Id=@Id;
END
END
GO

