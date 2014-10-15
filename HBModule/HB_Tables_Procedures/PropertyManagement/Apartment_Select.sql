SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Apartment_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_Apartment_Select]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: Booking  Insert 
Purpose  	: Booking  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>	.wadf. .sadasdasd:
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Apartment_Select](@SelectId BIGINT,  
@Pram1 BIGINT,@Pram2 NVARCHAR(100),@UserId BIGINT)  
AS  
BEGIN  
 IF @Pram1 <> 0  
  BEGIN  
   SELECT BlockId,B.BlockName,ApartmentName,ApartmentType,ApartmentNo,  
   SellableApartmentType,OwnershipType,RackTariff,DiscountModePer,  
   DiscountModeRS,DiscountAllowed,Status,A.Id 
   FROM WRBHBPropertyApartment A
   LEFT OUTER JOIN WRBHBPropertyBlocks  B WITH(NOLOCK)  ON  BlockId=B.Id
   WHERE A.PropertyId=@SelectId AND A.Id=@Pram1;   
  
  END  
 IF @Pram1 = 0  
  BEGIN  
   SELECT B.BlockName,ApartmentType,ApartmentNo,  
   SellableApartmentType,OwnershipType,RackTariff,Status,A.Id  
   FROM WRBHBPropertyApartment A
   LEFT OUTER JOIN WRBHBPropertyBlocks  B WITH(NOLOCK)  ON  BlockId=B.Id
   WHERE A.IsDeleted=0 AND A.PropertyId=@SelectId;  
  END   
END  