SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_ContractNonDedicated_Select') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_ContractNonDedicated_Select

Go

CREATE PROCEDURE Sp_ContractNonDedicated_Select
(
@SelectId Bigint,
@Pram1 bigint,
@Pram2 nvarchar(100),
@UserId bigint)

AS 
BEGIN
if @SelectId<>0
	Begin
		Select ContractType,ContractName,C.ClientName as ClientName,
		convert(varchar,StartDate,103) as StartDate,ClientId,H.Id,Types,PricingModel,TransName,
		convert(varchar,EndDate,103) as EndDate from WRBHBContractNonDedicated H
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON H.ClientId=C.Id AND C.IsActive=1 and C.IsDeleted=0
		where H.IsActive=1 and H.IsDeleted=0 and H.Id=@SelectId; 
		 
		Select ApartmentType as Type,C.PropertyName as PropertyName,PropertyId,ApartTarif,
		RoomTarif as RoomTariff,DoubleTarif as DoubleOccupancyTariff,TripleTarif as TripleTarif,Description,BedTarif as BedTariff,0 AS GridId ,
		ApartmentId as ApartmentId,RoomId,BedId,H.Id,PropertyCategory as PrtyCategoryId
		from WRBHBContractNonDedicatedApartment	H
		JOIN WRBHBProperty C WITH(NOLOCK) ON H.PropertyId=C.Id AND C.IsActive=1 and C.IsDeleted=0
		where H.IsActive=1 and H.IsDeleted=0 and NondedContractId=@SelectId; 
		
		--TABLE-2 FOR TEMPORY
		CREATE TABLE #TEMP_WRBHBNonDedicatedServices(Complimentary BIT,
		ServiceName NVARCHAR(100),Id Bigint,Price DECIMAL(27,2),Enable BIT,
		ProductId BIGINT,AmountChange Bit,EffectiveFrom NVARCHAR(100),TypeService Nvarchar(100))
		
		INSERT INTO #TEMP_WRBHBNonDedicatedServices(Complimentary,ServiceName,Id,
		Price,Enable,ProductId,AmountChange,EffectiveFrom,TypeService)	
		select cms.Complimentary as Complimentary,ServiceName ,CMS.Id,
		Price,CMS.Enable as Enable,Cms.ProductId as ProductId,cms.AmountChange as AmountChange,
		convert(varchar,Cms.EffectiveFrom,103) as EffectiveFrom,TypeService
		from WRBHBContractNonDedicatedServices CMS 
		where IsActive=1 and IsDeleted=0 and NondedContractId=@SelectId;
		
		INSERT INTO #TEMP_WRBHBNonDedicatedServices(Complimentary,ServiceName,Id,
		Price,Enable,ProductId,AmountChange,EffectiveFrom,TypeService)		
		SELECT ISComplimentary as Complimentary,ProductName,0,
		PerQuantityprice,Enable,Id,AmountChange,
		convert(varchar,EffectiveFrom,103) as EffectiveFrom,TypeService
	    FROM  WRBHBContarctProductMaster
	    WHERE IsActive=1 and IsDeleted=0 AND Id NOT IN(SELECT ISNULL(ProductId,0)	
	    FROM dbo.WRBHBContractNonDedicatedServices
		WHERE NondedContractId=@SelectId)
		
		SELECT Complimentary,ServiceName,Price,Enable,ProductId,AmountChange,TypeService,EffectiveFrom,Id  
		FROM #TEMP_WRBHBNonDedicatedServices
		
		--TABLE-3(History)
		select convert(nvarchar,s.StartDate,103) StartDate,convert(nvarchar,s.EndDate,103)EndDate, d.Property,ApartMentType as Place,ApartTarif as ApartTarif,RoomTarif,
		DoubleTarif as Tarif,TripleTarif as TripleTarif,Description,BedTarif,d.Id
		from WRBHBContractNonDedicatedApartment d
		join  WRBHBContractNonDedicated s on s.Id=d.NondedContractId
		where d.IsActive=0 and d.IsDeleted=0 and NondedContractId=@SelectId;
		 
		
	End 
Else 
	BEGIN
	   Select ContractName,C.ClientName as ClientName,H.Id 
		from WRBHBContractNonDedicated H
		JOIN WRBHBClientManagement C WITH(NOLOCK) ON H.ClientId=C.Id AND C.IsActive=1 and C.IsDeleted=0
		where H.IsActive=1 and H.IsDeleted=0 order by H.Id desc
	End
End


 
 