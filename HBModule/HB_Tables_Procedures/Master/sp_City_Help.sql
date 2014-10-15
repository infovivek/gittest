SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_City_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_City_Help]
GO
/*
 Modified By           Modifed Date     
 1.Sakthi              17 March 2014
*/ 
CREATE PROCEDURE [dbo].[sp_City_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Id BIGINT)
AS
BEGIN
IF @Action ='STATELOAD'
 BEGIN
  SELECT  StateName label,Id AS StateId FROM WRBHBState 
  WHERE IsActive=1;
 END
END