SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGeneration_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SSPCodeGeneration_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (25/03/2014)  >
		Section  	: SSPCodeGeneration Help
		Purpose  	: SSPCodeGeneration Help
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGeneration_Help](

@Action   		 NVARCHAR(100), 
@Pram1			 NVARCHAR(100)=NULL, 
@Pram2		     BigInt,
@Pram3		     BigInt, 
@UserId          BigInt
)
AS
BEGIN   
IF @Action='Client'
BEGIN
	 
	SELECT ClientName ,Id,CCity FROM WRBHBClientManagement
	WHERE IsDeleted=0 AND IsActive=1
	
	SELECT PropertyName ,Id,Category PropertyTypeId FROM WRBHBProperty
	WHERE IsDeleted=0 AND IsActive=1 AND  Category IN('Internal Property','External Property');	
	
	SELECT convert(varchar,EffectiveFrom,103) as EffectiveFrom,
    Enable,ISComplimentary as Complimentary,AmountChange,
    ProductName as ServiceName,Id as ProductId,0 as Id, TypeService as TypeService,
    PerQuantityprice as Price  FROM  WRBHBContarctProductMaster
    WHERE IsActive=1 and IsDeleted=0;
	
END	
IF @Action='ApartmentRooms'
Begin
   SELECT  B.BlockName+' - '+ ApartmentNo ApartmentNo,SellableApartmentType Type,A.Id ApartmentId,0 Id,0 SingleTariff,0 DoubleTariff
   FROM  dbo.WRBHBPropertyApartment A
   JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.Id=A.BlockId
   WHERE A.IsActive=1 and A.IsDeleted=0 AND A.PropertyId=@Pram2;
   
   SELECT  B.BlockName+' - '+ ApartmentNo+' - '+RoomNo RoomNo,A.Id RoomId,0 Id,0 SingleTariff,0 DoubleTariff
   FROM  dbo.WRBHBPropertyRooms A
   JOIN WRBHBPropertyBlocks B WITH(NOLOCK) ON B.Id=A.BlockId
   JOIN dbo.WRBHBPropertyApartment C WITH(NOLOCK) ON C.Id=A.ApartmentId
   WHERE A.IsActive=1 and A.IsDeleted=0 AND A.PropertyId=@Pram2;
   
END	 
END