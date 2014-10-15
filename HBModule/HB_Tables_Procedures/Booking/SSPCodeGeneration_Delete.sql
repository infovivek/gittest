SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGeneration_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SSPCodeGeneration_Delete]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (25/03/2014)  >
		Section  	: SSPCodeGeneration Delete
		Purpose  	: SSPCodeGeneration Delete
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGeneration_Delete](
@Id   			 BigInt, 
@Pram1			 NVARCHAR(100)=NULL, 
@Pram2		     BigInt, 
@UserId          BigInt
)
AS
BEGIN   
			UPDATE WRBHBSSPCodeGeneration SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  Id =@Id; 
			
			UPDATE dbo.WRBHBSSPCodeGenerationApartment SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  SSPCodeGenerationId=@Id; 
			
			UPDATE dbo.WRBHBSSPCodeGenerationRooms SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  SSPCodeGenerationId =@Id; 		
			
			UPDATE dbo.WRBHBSSPCodeGenerationServices SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  SSPCodeGenerationId =@Id;	
			 
END