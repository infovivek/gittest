SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_MasterClientManagement_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_MasterClientManagement_Delete]
GO 
CREATE PROCEDURE [dbo].[SP_MasterClientManagement_Delete](
@Id   Int 
)
AS
BEGIN 
 UPDATE WRBHBMasterClientManagement SET IsActive=0,IsDeleted=1 WHERE Id =@Id; 
END