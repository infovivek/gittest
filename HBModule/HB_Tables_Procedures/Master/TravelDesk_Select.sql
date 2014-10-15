 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_TravelDesk_Select') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE Sp_TravelDesk_Select
GO 
/* 
Author Name :  Mini
Created On 	: <Created Date (04/07/2014)  >
Section  	:  
Purpose  	:  
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
CREATE PROCEDURE Sp_TravelDesk_Select (@Id BIGINT,
@Param1 NVarChar(100),@Param2 NVARCHAR(100),@UserId BIGINT)
AS
BEGIN
IF(@Param1='TRAVELAGENCY')
BEGIN
 IF( @Param2 <> ''  )
  BEGIN
  --table 1 for header's
   SELECT distinct Email, FirstName,LastName,Designation,Mobile,
        Office,Addresss as address,States State,StateId,City,CityId,Website ,0 as Id
   FROM WRBHBTravelDesk V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 AND Email=@Param2 and Mode=@Param1 ;
   --created table for loadind datas
   create table #TempClient(ClientName nvarchar(500),ClientId bigint,Tick bit)
   insert into #TempClient(ClientName,ClientId,Tick)
   SELECT  ClientName,ClientId,1 as Tick
   FROM WRBHBTravelDesk V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 AND Email=@Param2 and Mode=@Param1 ;
   insert into #TempClient(ClientName,ClientId,Tick)
   SELECT ClientName  AS ClientName,Id as ClientId ,0 as Tick
   FROM WRBHBClientManagement WHERE IsActive=1 and IsDeleted=0 and Id not in(Select ClientId from #TempClient); 
   
     SELECT  ClientName,ClientId ,Tick from #TempClient
     
  END	
 IF( @Param2 = '')
  BEGIN
   SELECT distinct Email,FirstName,LastName--,Mode
   FROM WRBHBTravelDesk V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 and Mode='TRAVELAGENCY'
   --order by Id Desc; 
  END

END
ELSE
BEGIN
 IF @Id <> 0  
  BEGIN
   SELECT  ClientName,ClientId,FirstName,LastName,Designation,Mobile,
        Office,Addresss as address,Email,States State,StateId,City,CityId,Website ,Id as Id
   FROM WRBHBTravelDesk V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 AND Id=@Id;
  END	
 IF @Id = 0
  BEGIN
   SELECT ClientName,FirstName,LastName,Id
   FROM WRBHBTravelDesk V 
   WHERE V.IsDeleted=0 AND V.IsActive=1 and Mode='TRAVELDESK'
   order by Id desc;
  END

END

END
GO
