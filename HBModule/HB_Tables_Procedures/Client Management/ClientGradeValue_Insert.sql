SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientGradeValue_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientGradeValue_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: ClientGradeValue Insert 
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
CREATE PROCEDURE [dbo].[Sp_ClientGradeValue_Insert](
@ClientId		BIGINT,
@GradeId		BIGINT,
@MinValue		DECIMAL(27,2),
@MaxValue		DECIMAL(27,2),	
@CreatedBy		BIGINT,
@Grade			NVARCHAR(100),
@NeedGH			BIT,
@ValueStarRatingFlag BIT,
@StarRatingId	BIGINT
) 
AS
BEGIN

INSERT INTO dbo.WRBHBClientGradeValue(
ClientId,GradeId,MinValue,MaxValue,CreatedBy,
CreatedDate,ModifiedBy,ModifiedDate,IsActive,
IsDeleted,RowId,Grade,NeedGH,StarRatingId,ValueStarRatingFlag)
 VALUES(@ClientId,@GradeId,@MinValue,@MaxValue,@CreatedBy,GETDATE(),@CreatedBy,
 GETDATE(),1,0,NEWID(),@Grade,@NeedGH,@StarRatingId,@ValueStarRatingFlag)
 SELECT Id,RowId FROM WRBHBClientGradeValue WHERE Id=@@IDENTITY
 
END
GO
