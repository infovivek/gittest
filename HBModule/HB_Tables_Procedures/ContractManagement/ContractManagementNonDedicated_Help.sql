SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'SP_ContractNonDedicated_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  SP_ContractNonDedicated_Help
GO 
/* 
Author Name : Anbu
Created On 	: <Created Date (18/03/2014)  >
Section  	: Contract MANAGEMENT NonDedicated Help
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
CREATE PROCEDURE SP_ContractNonDedicated_Help
(@PAction NVARCHAR(100),@HelpId bigint,
--@Pram1 bigint,
@UserId bigint,@Pram2 nvarchar(100))
AS
BEGIN
  IF @PAction='PageLoad'
  BEGIN
	 --Table DateFunction
		SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt;  
	 --Table1 DateFunction
	CREATE TABLE #TEMPCleint (Id BIGINT NOT NULL, ClientName NVARCHAR(100) NOT NULL)
       --INSERT INTO #TEMPCleint (Id,ClientName) VALUES(1,'Humming Bird');
       INSERT INTO #TEMPCleint (Id,ClientName)
		select Id,ClientName from WRBHBClientManagement where IsActive=1 order by ClientName asc;
		Select Id,ClientName as ClientName from #TEMPCleint;
  --Table2 DateFunction
	Select Id as PropertyId,PropertyName as Property from WRBHBProperty 
    where IsActive=1 and IsDeleted=0 and Category in('External Property' ,'Internal Property')
    order by PropertyName asc;
	 
  END
  if @PAction='ServiceLoad'
	  Begin
	  --Create  TABLE #TEMPData (EffectiveFrom  NVARCHAR(500),Enable bit ,Complimentary bit,AmountChange bit,
	  -- ServiceName NVARCHAR(500),ProductId bigint,Id bigint,TypeService NVARCHAR(500),Price decimal(27,2));
	  --    Select convert(varchar,EffectiveFrom,103) as EffectiveFrom,
	  -- Enable,Complimentary,AmountChange,
	  -- ServiceName,ProductId,0 as Id,TypeService,
	  -- Price from WRBHBContractNonDedicatedServices
	  -- where IsActive=1 and IsDeleted=0 and AmountChange=1;
	   
	   Select convert(varchar,EffectiveFrom,103) as EffectiveFrom,
	   Enable,ISComplimentary as Complimentary,AmountChange,
	   ProductName as ServiceName,Id as ProductId,0 as Id,TypeService,
	   PerQuantityprice as Price  from  WRBHBContarctProductMaster 
	   where IsActive=1 and isdeleted=0;  
	  End
  
  if @PAction='PropertyNONDedicated'
	  Begin
		Select Id as PropertyId,PropertyName as Property,Category as PrtyCategoryId from WRBHBProperty 
		where IsActive=1 and IsDeleted=0 and Category in('External Property' ,'Internal Property') 
		 order by PropertyName asc;
	  End
  -- if @PAction='ApartTypesLoadsssss'--//FOR dedicated Property
	 -- begin 
		--	 if(@HelpId!=0)
		--	 Begin
		--	 CREATE TABLE #TEMPData (ApartId BIGINT NOT NULL,RoomId BIGINT NOT NULL,
  --                      BlockId Bigint not null, Place NVARCHAR(500)  NULL);
  --   Insert into #TEMPData(ApartId,RoomId,BlockId,Place)
		--Select isnull(PA.Id,0) as ApartId,isnull(PR.Id,0) as RoomId ,isnull(PB.Id,0) as BlockId,
  --     PA.ApartmentType+' - '+PA.ApartmentNo+--' - '+PA.SellableApartmentType+
  --     ' - '+PR.RoomNo+' - '+PR.RoomCategory AS Place
  --     from WRBHBProperty prty
  --    left join WRBHBPropertyBlocks PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0
  --     left join WRBHBPropertyApartment PA on PA.PropertyId=prty.Id and PB.Id=PA.BlockId 
  --     and PA.IsActive=1 and PA.IsDeleted=0
  --     left join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PB.Id=PR.BlockId AND PA.Id=PR.ApartmentId 
  --     and PR.IsActive=1 and PR.IsDeleted=0  
  --     where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@HelpId
  --     group by PA.Id,prty.Id,PR.Id,PB.Id,PB.BlockName ,PA.ApartmentNo,
  --     PR.RoomNo,PR.RoomCategory,PA.ApartmentType; 
  --     Select  ApartId as ApartmentId ,RoomId,BlockId,Place as Type from  #TEMPData
  --     where RoomId!=0  and BlockId!=0 
  --     group by  Place,ApartId,RoomId,BlockId 
		--	End 
	 -- End
  if @PAction='Transaction'
	  begin 
		  select  BTC from WRBHBClientManagement where
        IsActive=1 and IsDeleted=0   and Id=@HelpId;
        
        Select Name as label,Id from  WRBHBTransSubsPriceModel 
        where IsActive=1 and IsDeleted=0 and Types='Transcription';
	  End  
	  if @PAction='SubScription'
	  begin 
		  select  BTC from WRBHBClientManagement where
        IsActive=1 and IsDeleted=0   and Id=@HelpId;
        
        Select Name as label,Id from  WRBHBTransSubsPriceModel 
        where IsActive=1 and IsDeleted=0  and Types='Subscription';
	  End  
	    if @PAction='ApartTypesLoad'--//FOR non dedicated Property
	  begin 
		 if(@HelpId!=0)
			 IF(@Pram2='External Property')
				 Begin
						 --Drop table #TEMPData
						 CREATE TABLE #TEMPDatanon (ApartId BIGINT NOT NULL,RoomId BIGINT NOT NULL,
										  BlockId Bigint not null, ApartmentType NVARCHAR(500)  NULL,
										  RackDouble Decimal(27,2),RackSingle Decimal(27,2));
					   Insert into #TEMPDatanon(ApartId,RoomId,BlockId,ApartmentType,RackDouble,RackSingle)
						Select isnull(0,0) as ApartId,isnull(PR.Id,0) as RoomId ,0 as BlockId,
					   isnull(PR.RoomType,'')  AS ApartmentType,
					   isnull(Pr.RackDouble,0),isnull(Pr.RackSingle,0)
					   from WRBHBProperty prty 
					   left join WRBHBPropertyOwners PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0
					   left join WRBHBPropertyAgreements Agree on Agree.PropertyId=prty.Id and Agree.IsActive=1 and agree.IsDeleted=0
					   left join WRBHBPropertyAgreementsRoomCharges  PR on Agree.Id=pr.AgreementId and pr.IsActive=1 and pr.IsDeleted=0
					   where prty.IsActive=1 and prty.IsDeleted=0 and  prty.Id = @HelpId
					   and Category='External Property'
					   group by PR.RoomType,prty.Id,PR.Id,Pr.RackDouble,Pr.RackSingle
					   Select  ApartmentType as Type,RackDouble as DoubleOccupancyTariff,RackSingle as RoomTariff,
					   ApartId as ApartmentId,RoomId,BlockId as BedId 
					   from  #TEMPDatanon
					   where RoomId!=0 group by  ApartmentType,ApartId,RoomId,BlockId,RackDouble,RackSingle 
				End 
			--	else--ELSE PART FOR BOTH THE TEMP TABLES
			--	Begin
			--			CREATE TABLE #TEMPData (ApartId BIGINT NOT NULL,RoomId BIGINT NOT NULL,
			--							BlockId Bigint not null, Place NVARCHAR(500)  NULL);
			--		    Insert into #TEMPData(ApartId,RoomId,BlockId,Place)
			--			Select isnull(PA.Id,0) as ApartId,isnull(PR.Id,0) as RoomId ,isnull(PB.Id,0) as BlockId,
			--		   PA.ApartmentType+' - '+PA.ApartmentNo+--' - '+PA.SellableApartmentType+
			--		   ' - '+PR.RoomNo+' - '+PR.RoomCategory AS Place
			--		   from WRBHBProperty prty
			--		  left join WRBHBPropertyBlocks PB on PB.PropertyId=prty.Id and PB.IsActive=1 and PB.IsDeleted=0
			--		   left join WRBHBPropertyApartment PA on PA.PropertyId=prty.Id and PB.Id=PA.BlockId 
			--		   and PA.IsActive=1 and PA.IsDeleted=0
			--		   left join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PB.Id=PR.BlockId AND PA.Id=PR.ApartmentId 
			--		   and PR.IsActive=1 and PR.IsDeleted=0  
			--		   where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@HelpId
			--		   group by PA.Id,prty.Id,PR.Id,PB.Id,PB.BlockName ,PA.ApartmentNo,
			--		   PR.RoomNo,PR.RoomCategory,PA.ApartmentType; 
			--		   Select  ApartId as ApartmentId ,RoomId,BlockId,Place as Type from  #TEMPData
			--		   where RoomId!=0  and BlockId!=0 
			--		   group by  Place,ApartId,RoomId,BlockId 
			--End 
	  End
 end 
 
