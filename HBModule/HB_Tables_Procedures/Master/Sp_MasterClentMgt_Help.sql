SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_MasterClientManagement_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_MasterClientManagement_Help]
GO 
CREATE PROCEDURE [dbo].[SP_MasterClientManagement_Help](@Action NVARCHAR(100),
@Str NVARCHAR(100),@Id INT)
AS
BEGIN
 IF @Action='CONTACTTYPELOAD'
  BEGIN
   CREATE TABLE #TEMP (Id BIGINT NOT NULL, ContactType NVARCHAR(100) NOT NULL)
   INSERT INTO #TEMP (Id,ContactType) VALUES(1,'Admin')
   INSERT INTO #TEMP (Id,ContactType) VALUES(2,'HR')
   INSERT INTO #TEMP (Id,ContactType) VALUES(3,'secretary')
   
   SELECT ContactType,Id from #TEMP WHERE ContactType<>'' GROUP BY ContactType,Id;
   --SELECT ContactType FROM WRBHBClientManagementAddNewClient 
   --WHERE ContactType<>'' GROUP BY ContactType;
  END
 
 IF @Action='PAGELOAD'
  BEGIN
      -- THERE IS NO DATA THEN ONLY LOAD USER TABLE
   SELECT ClientName AS label,Id as Id FROM WRBHBMasterClientManagement
   WHERE IsActive=1;
   
  END
  IF @Action='STATELOAD'
  BEGIN
  SELECT StateName AS label,Id as StateId from WRBHBState WHERE IsActive=1;
  END
  IF @Action='CITYLOAD'
  BEGIN
  SELECT CityName AS label, Id as CityId from WRBHBCity WHERE IsActive=1 AND StateId=@Id;
  END
  IF @Action='LOCALITY'
  BEGIN
  SELECT distinct Locality AS label,Id as LocalityId from WRBHBLocality WHERE IsActive=1 AND CityId=@Id;
  END
END
