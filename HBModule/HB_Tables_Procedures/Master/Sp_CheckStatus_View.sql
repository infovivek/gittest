SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE 
ID = OBJECT_ID(N'[dbo].[Sp_CheckStatus_View]') 
AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_CheckStatus_View]
GO 
 

CREATE   PROCEDURE Sp_CheckStatus_View(@CreatedBy INT) 
AS
BEGIN 
SELECT UserName FROM  WRBHBUser where Id=1;
END 