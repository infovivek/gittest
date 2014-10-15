SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientGradeValueDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientGradeValueDetails_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: ClientGradeValueDetails  Insert 
Purpose  	: ClientGradeValueDetails  Insert
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
CREATE PROCEDURE [dbo].[Sp_ClientGradeValueDetails_Insert](
@ClientGradeValueId	BIGINT,
@CityId				BIGINT,
@CityName			NVARCHAR(100),
@CreatedBy			BIGINT) 
AS
BEGIN

INSERT INTO dbo.WRBHBClientGradeValueDetails(
ClientGradeValueId,CityId,CityName,CreatedBy,
CreatedDate,ModifiedBy,ModifiedDate,IsActive,
IsDeleted,RowId)
 VALUES(@ClientGradeValueId,@CityId,@CityName,@CreatedBy,GETDATE(),@CreatedBy,
 GETDATE(),1,0,NEWID())
 SELECT Id,RowId FROM WRBHBClientGradeValueDetails WHERE Id=@@IDENTITY
 
END
GO
