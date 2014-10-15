 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwnerOthersContacts_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwnerOthersContacts_Update]
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
CREATE PROCEDURE [dbo].[sp_PropertyOwnerOthersContacts_Update] ( 
 @OwnerId		BIGINT,
 @Name			NVARCHAR(100),
 @EmailId		NVARCHAR(100),
 @ContactType	NVARCHAR(100),
 @PhoneNumber	NVARCHAR(100),
 @designation	NVARCHAR(100),
 @CreatedBy		BIGINT ,
 @Id			BIGINT
)   
AS  
BEGIN  
  --INSERT 
   UPDATE dbo.WRBHBPropertyOwnerOtherContacts SET
  OwnerId=@OwnerId,
  Name=@Name,
  EmailId=@EmailId,
  ContactType=@ContactType,
  PhoneNumber=@PhoneNumber,
  designation=@designation,
  ModifiedBy=@CreatedBy,
  ModifiedDate=GETDATE()
  WHERE Id=@Id

END  