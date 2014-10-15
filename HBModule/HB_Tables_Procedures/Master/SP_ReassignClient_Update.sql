 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ReassignClient_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ReassignClient_Update]
GO   
/* 
        Author Name : <Anbu.P>
		Created On 	: <Created Date (07/04/2014)  >
		Section  	: Reassign Executive
		Purpose  	: Executive Update
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
CREATE PROCEDURE [dbo].[Sp_ReassignClient_Update] (
@Id					BIGINT,
@Category           NVARCHAR(100),
@UserRole			NVARCHAR(100),
@UserId				BIGINT,
@ReassignId			BIGINT,
@CreatedBy			BIGINT
) 
AS
BEGIN

INSERT INTO WRBHBReference(Category,UserRole,UserId,ReassignId,
Createdby,Createddate,Modifiedby,Modifieddate,IsActive,IsDeleted,Rowid)

Values(@Category,@UserRole,@UserId,@ReassignId,
@CreatedBy,GETDATE(),@Createdby,GETDATE(),1,0,NEWID())
SET  @Id=@@IDENTITY

SELECT Id ,RowId FROM WRBHBReference WHERE Id=@Id
END

GO
