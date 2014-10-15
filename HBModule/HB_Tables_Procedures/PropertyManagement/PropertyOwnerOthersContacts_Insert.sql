 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwnerOthersContacts_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwnerOthersContacts_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (04/04/2014)  >
		Section  	: Property Owner OthersContacts
		Purpose  	: Property Owner OthersContacts Insert
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
CREATE PROCEDURE [dbo].[sp_PropertyOwnerOthersContacts_Insert] ( 
 @OwnerId		BIGINT,
 @Name			NVARCHAR(100),
 @EmailId		NVARCHAR(100),
 @ContactType	NVARCHAR(100),
 @PhoneNumber	NVARCHAR(100),
 @designation	NVARCHAR(100),
 @CreatedBy		BIGINT  
)   
AS  
BEGIN  
  --INSERT 
   INSERT INTO dbo.WRBHBPropertyOwnerOtherContacts
  (OwnerId,Name,EmailId,ContactType,PhoneNumber,designation,
  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,  
  IsDeleted,RowId)
  VALUES 
  (@OwnerId,@Name,@EmailId,@ContactType,@PhoneNumber,@designation,
  @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
END  