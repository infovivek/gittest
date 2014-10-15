SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientGradeValue_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientGradeValue_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: ClientGradeValue  Insert 
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
CREATE PROCEDURE [dbo].[Sp_ClientGradeValue_Update](
@ClientId		BIGINT,
@GradeId		BIGINT,
@MinValue		DECIMAL(27,2),
@MaxValue		DECIMAL(27,2),	
@CreatedBy		BIGINT,
@Id				BIGINT,
@Grade			NVARCHAR(100),
@NeedGH			BIT,
@ValueStarRatingFlag BIT,
@StarRatingId	BIGINT
) 
AS
BEGIN
UPDATE dbo.WRBHBClientGradeValue SET
ClientId=@ClientId,
GradeId=@GradeId,
MinValue=@MinValue,
MaxValue=@MaxValue,
ModifiedBy=@CreatedBy,
Grade=@Grade,
ModifiedDate=GETDATE(),
NeedGH=@NeedGH ,
ValueStarRatingFlag=@ValueStarRatingFlag,
StarRatingId=@StarRatingId
WHERE Id=@Id
SELECT Id,RowId FROM WRBHBClientGradeValue WHERE Id=@Id
 
END
GO
