SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreement_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreement_Delete]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY Agreement Delete
		Purpose  	: PROPERTYAgreement Delete
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
CREATE PROCEDURE [dbo].[sp_PropertyAgreement_Delete](
@Id   		BigInt, 
@Pram1			 NVARCHAR(100)=NULL, 
@PropertyId      BigInt, 
@UserId          BigInt
)
AS
BEGIN   
			UPDATE WRBHBPropertyAgreements SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 WHERE Id =@Id; 
			
END