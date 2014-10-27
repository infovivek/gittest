SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TrGenerateClient_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_TrGenerateClient_Insert]
GO   
/* 
Author Name : <Anbu>
Created On 	: <Created Date (25/10/2014)  >
Section  	: TrGenerateClient Insert 
Purpose  	: ClientGradeValue  Insert
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
CREATE PROCEDURE [dbo].[Sp_TrGenerateClient_Insert](
@ClientId		BIGINT,
@TrClient		NVARCHAR(100),
@CreatedBy		BIGINT
) 
AS
BEGIN

INSERT INTO WRBHBTrClient(ClientId,Trclient,CreatedBy,
 CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
 VALUES(@ClientId,@TrClient,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
 
 SELECT Id,RowId FROM WRBHBTrClient 
 WHERE Id=@@IDENTITY
 
END
GO