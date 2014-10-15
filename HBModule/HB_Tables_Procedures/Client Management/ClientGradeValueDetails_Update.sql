SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientGradeValueDetails_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientGradeValueDetails_Update]
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
CREATE PROCEDURE [dbo].[Sp_ClientGradeValueDetails_Update](
@ClientGradeValueId	BIGINT,
@CityId				BIGINT,
@CityName			NVARCHAR(100),
@CreatedBy			BIGINT,
@Id					BIGINT) 
AS
BEGIN

	UPDATE dbo.WRBHBClientGradeValueDetails SET
	ClientGradeValueId=@ClientGradeValueId,
	CityId=@CityId,CityName=@CityName,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id

	SELECT Id,RowId FROM WRBHBClientGradeValueDetails WHERE Id=@Id

END
GO
