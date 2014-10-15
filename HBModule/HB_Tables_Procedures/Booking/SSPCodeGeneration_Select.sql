SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGeneration_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGeneration_Select]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: SSPCodeGeneration
Purpose  	: SELECT
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGeneration_Select](
@SelectId BIGINT,  
@Pram1 BIGINT,
@Pram2 NVARCHAR(100),
@UserId BIGINT)  
AS  
BEGIN  
 IF @SelectId <> 0  
  BEGIN 
		DECLARE @PROPERTYID BIGINT;
		CREATE TABLE #TEMP_WRBHBSSPCodeGenerationApartment(SSPCodeGenerationId BIGINT,ApartmentNo NVARCHAR(100),
		Type NVARCHAR(100),SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),Id BIGINT,ApartmentId BIGINT)
		CREATE TABLE #TEMP_WRBHBSSPCodeGenerationRooms(SSPCodeGenerationId BIGINT,RoomNo NVARCHAR(100),
		SingleTariff DECIMAL(27,2),DoubleTariff DECIMAL(27,2),Id BIGINT,RoomId BIGINT)
		CREATE TABLE #TEMP_WRBHBSSPCodeGenerationServices(SSPCodeGenerationId BIGINT,Complimentary BIT,
		ServiceName NVARCHAR(100),Price DECIMAL(27,2),Id BIGINT,Enable BIT,ProductId BIGINT,TypeService NVARCHAR(100))
		 
		SELECT @PROPERTYID=PropertyId FROM WRBHBSSPCodeGeneration A WHERE A.Id=@SelectId;  
		 
		SELECT ClientId,CM.ClientName,PropertyId,B.PropertyName,SSPName,SSPCode,BookingLevel,SingleTariff,
		DoubleTariff,TripleTariff,A.Id,B.Category 
		FROM WRBHBSSPCodeGeneration A
		LEFT OUTER JOIN dbo.WRBHBProperty  B WITH(NOLOCK)  ON  A.PropertyId=B.Id		
		LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK) ON  CM.Id=A.ClientId		
		WHERE A.Id=@SelectId;  
		--APARTMENT ALREADY SAVED
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationApartment(SSPCodeGenerationId ,ApartmentNo,
		Type,SingleTariff,DoubleTariff,Id,ApartmentId)
		SELECT SSPCodeGenerationId,ApartmentNo,ApartmentType Type,SingleTariff,DoubleTariff,Id,ApartmentId
		FROM dbo.WRBHBSSPCodeGenerationApartment
		WHERE SSPCodeGenerationId=@SelectId;
		
		--NEW ADDED APARTMENT 
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationApartment(SSPCodeGenerationId ,ApartmentNo,
		Type,SingleTariff,DoubleTariff,Id,ApartmentId)
		SELECT 0,B.BlockName+' - '+ ApartmentNo ApartmentNo,SellableApartmentType Type,0 SingleTariff,0 DoubleTariff,0,A.Id 
	    FROM  dbo.WRBHBPropertyApartment A
	    JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.Id=A.BlockId
	    WHERE A.IsActive=1 and A.IsDeleted=0 AND A.PropertyId=@PROPERTYID
	    AND A.Id NOT IN(SELECT ISNULL(ApartmentId,0) FROM dbo.WRBHBSSPCodeGenerationApartment
	    WHERE SSPCodeGenerationId=@SelectId);
		
		SELECT SSPCodeGenerationId ,ApartmentNo,Type,SingleTariff,DoubleTariff,Id,ApartmentId 
		FROM #TEMP_WRBHBSSPCodeGenerationApartment
		
		--ROOM ALREADY SAVED
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationRooms(SSPCodeGenerationId ,RoomNo,
		SingleTariff,DoubleTariff,Id,RoomId)
		SELECT SSPCodeGenerationId,RoomNo,SingleTariff,DoubleTariff,Id,RoomId 
		FROM dbo.WRBHBSSPCodeGenerationRooms
		WHERE SSPCodeGenerationId=@SelectId;
		
		--NEW ADDED ROOM 
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationRooms(SSPCodeGenerationId ,RoomNo,
		SingleTariff,DoubleTariff,Id,RoomId)
		SELECT  0,B.BlockName+' - '+ ApartmentNo+' - '+RoomNo RoomNo,0 SingleTariff,0 DoubleTariff,0 Id,A.Id RoomId
	    FROM  dbo.WRBHBPropertyRooms A
	    JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.Id=A.BlockId
	    JOIN dbo.WRBHBPropertyApartment C WITH(NOLOCK) ON C.Id=A.ApartmentId
	    WHERE A.IsActive=1 and A.IsDeleted=0 AND A.PropertyId=@PROPERTYID
	    AND A.Id NOT IN (SELECT ISNULL(RoomId,0)FROM dbo.WRBHBSSPCodeGenerationRooms
		WHERE SSPCodeGenerationId=@SelectId);
	    
	    SELECT SSPCodeGenerationId ,RoomNo,SingleTariff,DoubleTariff,Id,RoomId 
	    FROM #TEMP_WRBHBSSPCodeGenerationRooms
		
		--SERVICE ALREADY SAVED
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationServices(SSPCodeGenerationId,Complimentary,ServiceName,
		Price,Enable,ProductId,TypeService,Id)		
		SELECT SSPCodeGenerationId,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Id 
		FROM dbo.WRBHBSSPCodeGenerationServices
		WHERE SSPCodeGenerationId=@SelectId;
		
		
		--NEW ADDED SERVICE 
		INSERT INTO #TEMP_WRBHBSSPCodeGenerationServices(SSPCodeGenerationId,Complimentary,ServiceName,
		Price,Enable,ProductId,TypeService,Id)		
		SELECT 0,ISComplimentary as Complimentary,ProductName,PerQuantityprice,
		Enable,Id,TypeService,0
	    FROM  WRBHBContarctProductMaster
	    WHERE IsActive=1 and IsDeleted=0 AND Id NOT IN(SELECT ISNULL(ProductId,0)	FROM dbo.WRBHBSSPCodeGenerationServices
		WHERE SSPCodeGenerationId=@SelectId)
		
		SELECT SSPCodeGenerationId,Complimentary,ServiceName,Price,Enable,ProductId,TypeService,Id 
		FROM #TEMP_WRBHBSSPCodeGenerationServices;
		
		
		CREATE TABLE #TEMPCLIENT(label NVARCHAR(100),Id BIGINT)
		INSERT INTO #TEMPCLIENT(label,Id) 
		SELECT 'Select Client',0
		INSERT INTO #TEMPCLIENT(label,Id) 
		SELECT ClientName label,Id FROM WRBHBClientManagement
		WHERE IsDeleted=0 AND IsActive=1
		SELECT label,Id FROM #TEMPCLIENT
		
		CREATE TABLE #TEMPPROPERTY(label NVARCHAR(100),Id BIGINT,PropertyType NVARCHAR(100))
		INSERT INTO #TEMPPROPERTY(label,Id,PropertyType) 
		SELECT 'Select Property',0,''
		INSERT INTO #TEMPPROPERTY(label,Id,PropertyType)
		SELECT PropertyName label,Id,Category PropertyType FROM WRBHBProperty
		WHERE IsDeleted=0 AND IsActive=1 AND  Category IN('Internal Property','External Property');	
		SELECT label,Id,PropertyType FROM #TEMPPROPERTY
		
		
		
		
		
 END  
 IF @SelectId = 0  
  BEGIN  
		SELECT CM.ClientName,B.PropertyName,SSPName,A.Id 
		FROM WRBHBSSPCodeGeneration A
		LEFT OUTER JOIN dbo.WRBHBProperty  B WITH(NOLOCK)  ON  A.PropertyId=B.Id		
		LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK) ON  CM.Id=A.ClientId		
		WHERE A.IsDeleted=0 AND A.IsActive=1 ORDER BY Id DESC;   
  END   
END  