-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Locality_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Locality_Help]
GO 
-- ===============================================================================
-- Author:shameem
-- Create date:30-01-2014
-- ModifiedBy :Sakthi
-- ModifiedDate:17-MAR-2014
-- Description:	Locality Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Locality_Help](@Action NVARCHAR(100),
@Str1 NVARCHAR(100),@Str2 NVARCHAR(100),@Id1 INT,@Id2 INT)			
AS
BEGIN
IF @Action ='STATELOAD'
 BEGIN
  SELECT  StateName label,Id AS StateId FROM WRBHBState 
  WHERE IsActive=1;
 END
 IF @Action = 'CITYLOAD'
  BEGIN
   SELECT CityName AS label,Id FROM WRBHBCity 
   WHERE IsActive=1 AND StateId=@Id1;
  END
END




	
	