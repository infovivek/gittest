SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Locality_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Locality_Delete]
GO 
/*
Modified Date           Modified By
17 march 2014           Sakthi           Mulitiple Procedures Same name
*/
CREATE PROCEDURE [dbo].[SP_Locality_Delete](@Id BIGINT,@UsrId BIGINT)
AS
BEGIN
 UPDATE WRBHBLocality SET IsActive=0,IsDeleted=1,ModifiedBy=@UsrId,
 ModifiedDate=GETDATE() WHERE Id =@Id; 
END