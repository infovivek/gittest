SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PropertyRooms_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PropertyRooms_Delete]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY ROOM Delete
		Purpose  	: PROPERTYROOM Delete
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
CREATE PROCEDURE [dbo].[Sp_PropertyRooms_Delete](
@Id   	     	BigInt, 
@Pram1			 NVARCHAR(100)=NULL, 
@PropertyId      BigInt, 
@UserId          BigInt
)
AS
BEGIN   
			UPDATE WRBHBPropertyRooms SET ModifiedBy=@UserId,
			ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 WHERE Id =@Id;
END