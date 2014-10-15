SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[Sp_ContractManagement_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  [Sp_ContractManagement_Help]
GO 
/* 
Author Name : mini
Created On 	: <Created Date (11/02/2014)  >
Section  	: Contract MANAGEMENT Help
Purpose  	: Contract Help
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE [Sp_ContractManagement_Help](@PAction NVARCHAR(100),@HelpId bigint,
@Pram2 NVARCHAR(100),
@UserId bigint)
AS
BEGIN
  IF @PAction='PageLoad'
  BEGIN
	 --Table DateFunction
		SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt; 
	 --Table1 DateFunction
		select PropertyName,Id from WRBHBProperty WHERE IsActive=1; 
	 --Table2 DateFunction
	CREATE TABLE #TEMPCleint (Id BIGINT NOT NULL, ClientName NVARCHAR(100) NOT NULL)
       --INSERT INTO #TEMPCleint (Id,ClientName) VALUES(1,'Humming Bird');
       INSERT INTO #TEMPCleint (Id,ClientName)
		select Id,ClientName from WRBHBClientManagement where IsActive=1 order by ClientName asc;
		Select ClientName,Id  from #TEMPCleint;
	 --Table3 DateFunction
		SELECT UserName AS label,Id as data FROM WRBHBUser 
		 WHERE UserGroup='Sales Executive' AND IsActive=1 AND IsDeleted=0;
  END
  IF @PAction='ContractTariffsApartDelete'
  BEGIN
		UPDATE WRBHBContractManagementAppartment SET IsActive=0 , IsDeleted=1,ModifiedBy=@UserId,
		ModifiedDate=GETDATE() WHERE Id=@HelpId
  END
  IF @PAction='ContractTariffsRoomDelete'
  BEGIN
		UPDATE WRBHBContractManagementTariffAppartment SET IsActive=0 , IsDeleted=1,ModifiedBy=@UserId,
		ModifiedDate=GETDATE() WHERE Id=@HelpId
  END
  if @PAction='ServiceLoad'
  Begin
   --Create  TABLE #TEMPData (EffectiveFrom  NVARCHAR(500),Enable bit ,Complimentary bit,AmountChange bit,
	  -- ServiceName NVARCHAR(500),ProductId bigint,Id bigint,TypeService NVARCHAR(500),Price decimal(27,2));
	  --    Select convert(varchar,EffectiveFrom,103) as EffectiveFrom,
	  -- Enable,Complimentary,AmountChange,
	  -- ServiceName,ProductId,0 as Id,TypeService,
	  -- Price from WRBHBContractManagementServices
	  -- where IsActive=1 and IsDeleted=0 and AmountChange=1;
   Select convert(varchar,EffectiveFrom,103) as EffectiveFrom,
   Enable,ISComplimentary as Complimentary,AmountChange,
   ProductName as ServiceName,Id as ProductId,0 as Id, TypeService as TypeService,
   PerQuantityprice as Price  from  WRBHBContarctProductMaster
   where IsActive=1 and isdeleted=0; 
  End
  if @PAction='TarifHistory'
 begin 
  
  --Select top 5 convert(varchar,StartDate,103) as StartDate,convert(varchar,EndDate,103) as EndDate,
		--Apart.Tariff as Tarif,Apart.PropertyId as PropertyId,Apart.Id as Id--Apart.ContractId,
		-- from WRBHBContractManagement cont
		-- left join WRBHBContractManagementTariffAppartment Apart on cont.Id=Apart.ContractId
		--  and Apart.IsActive=1 and Apart.IsDeleted=0 --and Apart.ContractId=@SelectId
		--where cont.IsActive=1 and cont.IsDeleted=0 
		--order by Id desc
		--and cont.Id=@SelectId; 
		
          Select  top 1 convert(varchar,StartDate,103) as StartDate,
           convert(varchar,EndDate,103) as EndDate ,0+0.00 as Tarif,PropertyId,Id  from  
          WRBHBContractManagement where IsActive=1 and IsDeleted=0 
          order by Id desc ;
  End 
  ---Abov this comes in Pageload
  if @PAction='GridPropertyDedicated'
  Begin
   
    Select P.Id as PropertyId,PropertyName as Property from WRBHBProperty	P 
    WHERE P.IsActive=1 and P.IsDeleted=0 and Category='Internal Property'    
    order by PropertyName asc;
  End
  if @PAction='GridPropertyManaged'
  begin 
    Select Id as PropertyId,PropertyName as Property from WRBHBProperty 
    where IsActive=1 and IsDeleted=0 and Category='Managed G H' order by PropertyName asc;
  end
  if @PAction='TarifGridLoad'--//FOR dedicated Property
  begin 
         if(@HelpId!=0)
         Begin
			CREATE TABLE #TEMPData (ApartId BIGINT NOT NULL,RoomId BIGINT NOT NULL,
			BlockId Bigint not null, Place NVARCHAR(500)  NULL);	
           IF(@Pram2='APARTMENT')
           BEGIN           
				Insert into #TEMPData(ApartId,RoomId,BlockId,Place)
				Select isnull(PA.Id,0) as ApartId,0 as RoomId ,isnull(PB.Id,0) as BlockId,
				PB.BlockName+' - '+PA.ApartmentNo AS Place
				from WRBHBProperty prty
				left join WRBHBPropertyBlocks PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0
				join WRBHBPropertyApartment PA on PA.PropertyId=prty.Id and PB.Id=PA.BlockId 
				and PA.IsActive=1 and PA.IsDeleted=0
				join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PB.Id=PR.BlockId AND PA.Id=PR.ApartmentId 
				and PR.IsActive=1 and PR.IsDeleted=0  				
				where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@HelpId
				AND PA.Id NOT IN(SELECT ApartmentId FROM dbo.WRBHBContractManagementAppartment CA WHERE CA.IsActive=1 and CA.IsDeleted=0)
				AND PR.Id NOT IN(SELECT RoomId FROM dbo.WRBHBContractManagementTariffAppartment CS WHERE CS.IsActive=1 and CS.IsDeleted=0)
				group by PA.Id,prty.Id,PB.Id,PB.BlockName ,PA.ApartmentNo;
				-- group by  ApartmentId,PR.Id,PB.Id,PB.BlockName ,PA.ApartmentNo,PR.RoomNo,PR.RoomCategory,PA.SellableApartmentType;
				
				Select  ApartId as ApartmentId ,RoomId,BlockId,Place from  #TEMPData
				group by  Place,ApartId,RoomId,BlockId 
           END
           ELSE
           BEGIN         
				Insert into #TEMPData(ApartId,RoomId,BlockId,Place)
				Select isnull(PA.Id,0) as ApartId,isnull(PR.Id,0) as RoomId ,isnull(PB.Id,0) as BlockId,
				PB.BlockName+' - '+PA.ApartmentNo+--' - '+PA.SellableApartmentType+
				' - '+PR.RoomNo+' - '+PR.RoomType AS Place
				from WRBHBProperty prty
				left join WRBHBPropertyBlocks PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0
				join WRBHBPropertyApartment PA on PA.PropertyId=prty.Id and PB.Id=PA.BlockId 
				and PA.IsActive=1 and PA.IsDeleted=0
				join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PB.Id=PR.BlockId AND PA.Id=PR.ApartmentId 
				and PR.IsActive=1 and PR.IsDeleted=0  
				where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@HelpId
				AND PR.Id NOT IN(SELECT RoomId FROM dbo.WRBHBContractManagementTariffAppartment CA WHERE CA.IsActive=1 and CA.IsDeleted=0)
				AND PA.Id NOT IN(SELECT ApartmentId FROM dbo.WRBHBContractManagementAppartment CS WHERE CS.IsActive=1 and CS.IsDeleted=0)
				group by PA.Id,prty.Id,PR.Id,PB.Id,PB.BlockName ,PA.ApartmentNo,
				PR.RoomNo,PR.RoomType;
				-- group by  ApartmentId,PR.Id,PB.Id,PB.BlockName ,PA.ApartmentNo,PR.RoomNo,PR.RoomCategory,PA.SellableApartmentType;
				
				Select  ApartId as ApartmentId ,RoomId,BlockId,Place from  #TEMPData
				group by  Place,ApartId,RoomId,BlockId 
			END
          End 
  End
  if @PAction='TarifGridManaged'--ForManaged property
  begin
   CREATE TABLE #TEMPDataMan (RoomId BIGINT NOT NULL,
                        BlockId Bigint not null, Place NVARCHAR(500)  NULL);
 Insert into #TEMPDataMan(RoomId,BlockId,Place)
  Select isnull(PR.Id,0) as RoomId ,isnull(PB.Id,0) as BlockId,
       PB.BlockName+' - '+--PA.ApartmentNo+' - '+PA.SellableApartmentType+' - '+
       PR.RoomNo+' - '+PR.RoomCategory AS Place
       from WRBHBProperty prty
       join WRBHBPropertyBlocks PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0 
       join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PB.Id=PR.BlockId  and PR.IsActive=1 and PR.IsDeleted=0 
       where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@HelpId 
       AND PR.Id NOT IN(SELECT RoomId FROM dbo.WRBHBContractManagementTariffAppartment CA WHERE CA.IsActive=1 and CA.IsDeleted=0) 
       group by prty.Id,PR.Id,PB.Id,PB.BlockName,PR.RoomNo,PR.RoomCategory;
       
       Select 0 as ApartmentId ,RoomId,BlockId,Place from  #TEMPDataMan
         where RoomId!=0 and BlockId!=0
       group by  Place,RoomId,BlockId
  end
  
  if @PAction='TarifGridLoads'
  begin  
  
   CREATE TABLE #TEMPBooks (Id BIGINT NOT NULL, BookType NVARCHAR(100) NOT NULL)
   INSERT INTO #TEMPBooks (Id,BookType) VALUES(1,'Active')
   INSERT INTO #TEMPBooks (Id,BookType) VALUES(2,'InActive') 
   
    SELECT BookType as Status from #TEMPBooks WHERE BookType<>'' GROUP BY BookType,Id;
  End
  if @PAction='PriceModel'
  BEGIN
   select  BTC from WRBHBClientManagement where
    IsActive=1 and IsDeleted=0   and Id=@HelpId;
  END
  if @PAction='Transactional'
	  BEGIN
		select  BTC from WRBHBClientManagement where
        IsActive=1 and IsDeleted=0   and Id=@HelpId;
        
        Select Name as label,Id from  WRBHBTransSubsPriceModel 
        where IsActive=1 and IsDeleted=0 And Types='Transcription';
	  END
	   if @PAction='Subscription'
	  BEGIN
		select  BTC from WRBHBClientManagement where
        IsActive=1 and IsDeleted=0   and Id=@HelpId;
        
        Select Name as label,Id from  WRBHBTransSubsPriceModel 
        where IsActive=1 and IsDeleted=0 And Types='Subscription';
	  END
  End 
   
 