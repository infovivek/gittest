SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagement_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[Sp_ContractManagement_Select]

Go

CREATE PROCEDURE Sp_ContractManagement_Select(
@SelectId Bigint,
@Pram1 bigint,
@Pram2 nvarchar(100),
@UserId bigint)

AS 
BEGIN
if @SelectId<>0
	Begin
		Select ContractType,ContractName,C.ClientName as ClientName,H.Property,PrintingModel,Types as Types,
		convert(varchar,StartDate,103) as StartDate,convert(varchar,EndDate,103) as EndDate,
		convert(varchar,AgreementDate,103) as AgreementDate,
		RateInterval,ContractPriceMode,TransubName,TransubId,H.Id,BookingLevel
		from WRBHBContractManagement H		
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON H.ClientId=C.Id AND C.IsActive=1 and C.IsDeleted=0 
		where H.IsActive=1 and H.IsDeleted=0 and H.Id=@SelectId; 
		
		DECLARE @BookingLevel NVARCHAR(100);
		SELECT @BookingLevel=BookingLevel FROM WRBHBContractManagement WHERE Id=@SelectId		
		IF @BookingLevel='Apartment'
		BEGIN
		--TARIFF (History)
			Select convert(varchar,StartDate,103) as StartDate,convert(varchar,EndDate,103) as EndDate,
			Apart.Tariff as Tarif,Apart.PropertyId as PropertyId,Apart.Id as Id,--Apart.ContractId,
			P.PropertyName as Property, Apart.Place as Place
			from WRBHBContractManagement cont
			join WRBHBContractManagementAppartment Apart on cont.Id=Apart.ContractId
			and Apart.IsActive=0 and Apart.IsDeleted=0 
			JOIN WRBHBProperty P WITH(NOLOCK) ON Apart.PropertyId=P.Id AND P.IsActive=1 and P.IsDeleted=0
			where cont.IsActive=1 and cont.IsDeleted=0 and cont.Id=@SelectId
			order by cont.Id desc 
					
			SELECT P.PropertyName Property,PropertyId,Place,Tariff,RoomId,ApartmentId,BlockId,ContractId,Place as Places,H.Id
			from WRBHBContractManagementAppartment H
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 and P.IsDeleted=0
			WHERE H.IsActive=1 and H.IsDeleted=0 and ContractId=@SelectId
		END
		ELSE
		BEGIN
		--TARIFF (History)
			Select convert(varchar,StartDate,103) as StartDate,convert(varchar,EndDate,103) as EndDate,
			Apart.Tariff as Tarif,Apart.PropertyId as PropertyId,Apart.Id as Id,--Apart.ContractId,
			P.PropertyName as Property, Apart.Place as Place
			from WRBHBContractManagement cont
			join WRBHBContractManagementTariffAppartment Apart on cont.Id=Apart.ContractId
			and Apart.IsActive=0 and Apart.IsDeleted=0 
			JOIN WRBHBProperty P WITH(NOLOCK) ON Apart.PropertyId=P.Id AND P.IsActive=1 and P.IsDeleted=0
			where cont.IsActive=1 and cont.IsDeleted=0 and cont.Id=@SelectId
			order by Id desc 
			
			SELECT P.PropertyName Property,PropertyId,Place,Tariff,RoomId,ApartmentId,BlockId,ContractId,Place as Places,H.Id
			from WRBHBContractManagementTariffAppartment H
			JOIN WRBHBProperty P WITH(NOLOCK) ON H.PropertyId=P.Id AND P.IsActive=1 and P.IsDeleted=0
			WHERE H.IsActive=1 and H.IsDeleted=0 and ContractId=@SelectId
		END
		--TABLE-3 FOR TEMPORY
		--drop table #TEMP_WRBHBContractServices
		CREATE TABLE #TEMP_WRBHBContractServices(Complimentary BIT,
		ServiceName NVARCHAR(100),Id Bigint,Price DECIMAL(27,2),Enable BIT,
		ProductId BIGINT,AmountChange Bit,EffectiveFrom nvarchar(100),TypeService Nvarchar(100))
		
		INSERT INTO #TEMP_WRBHBContractServices(Complimentary,ServiceName,Id,
		Price,Enable,ProductId,EffectiveFrom,AmountChange,TypeService) 
		select cms.Complimentary as Complimentary,ServiceName,CMS.Id,
		Price,CMS.Enable as Enable,Cms.ProductId as ProductId,
		convert(nvarchar,Cms.EffectiveFrom,103) as EffectiveFrom,
		cms.AmountChange as AmountChange,cms.TypeService as TypeService
		from WRBHBContractManagementServices CMS 
		where cms.IsActive=1 and cms.IsDeleted=0 and  cms.ContractId=@SelectId

		
		INSERT INTO #TEMP_WRBHBContractServices(Complimentary,ServiceName,Id,
		Price,Enable,ProductId,EffectiveFrom,AmountChange,TypeService)		
		SELECT ISComplimentary,ProductName,0,PerQuantityprice,
		Enable,Id,	convert(varchar,EffectiveFrom,103) as EffectiveFrom,
		AmountChange,TypeService
	    FROM  WRBHBContarctProductMaster
	    WHERE IsActive=1 and IsDeleted=0 AND Id NOT IN(SELECT ISNULL(ProductId,0)	
	    FROM dbo.WRBHBContractManagementServices
		WHERE ContractId=@SelectId)
		
		SELECT Complimentary,P.ProductName ServiceName,Price,H.Enable,ProductId,H.AmountChange,H.TypeService,H.EffectiveFrom,H.Id  
		FROM #TEMP_WRBHBContractServices H
		JOIN WRBHBContarctProductMaster P WITH(NOLOCK) ON H.ProductId=P.Id AND P.IsActive=1 and P.IsDeleted=0
		
	End 
Else 
	BEGIN
	    Select ContractName,C.ClientName as ClientName,H.Id 
		from WRBHBContractManagement H
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON H.ClientId=C.Id AND C.IsActive=1 and C.IsDeleted=0
		where H.IsActive=1 and H.IsDeleted=0 order by H.Id desc
	End
End
 
 
 