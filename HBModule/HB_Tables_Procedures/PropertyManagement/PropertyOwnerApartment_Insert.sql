 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwnerApartment_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwnerApartment_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY OWNER APARTMENT
		Purpose  	: PROPERTY OWNER APARTMENT Insert
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
CREATE PROCEDURE [dbo].[sp_PropertyOwnerApartment_Insert] ( 
 @OwnerId BIGINT,
 @ApartmentId BIGINT,
 @ApartmentName NVARCHAR(100),
 @CreatedBy    BIGINT  
)   
AS  
BEGIN  
  --INSERT 
  DECLARE @Category NVARCHAR(100),@PropertyId BIGINT;
  SELECT @PropertyId=PropertyId FROM WRBHBPropertyOwners WHERE Id=@OwnerId ;
  SELECT @Category=Category FROM WRBHBProperty WHERE Id=@PropertyId ;
 
  IF @Category!='Internal Property'
  BEGIN 
		INSERT INTO  dbo.WRBHBPropertyOwnerProperty( 
		OwnerId,PropertyId,PropertyName,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,  
		IsDeleted,RowId)   
		VALUES(@OwnerId,@ApartmentId,@ApartmentName,
		@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID());
		SELECT Id,RowId FROM WRBHBPropertyOwnerProperty WHERE Id=@@IDENTITY;   
  END
  ELSE
  BEGIN  
		INSERT INTO  WRBHBPropertyOwnerApartment( 
		OwnerId,ApartmentId,ApartmentName,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,  
		IsDeleted,RowId)   
		VALUES(@OwnerId,@ApartmentId,@ApartmentName,
		@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID());
		SELECT Id,RowId FROM WRBHBPropertyOwnerApartment WHERE Id=@@IDENTITY;  
  END
 
END  