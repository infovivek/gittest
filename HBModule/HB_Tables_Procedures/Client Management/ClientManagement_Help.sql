SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ClientManagement_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ClientManagement_Help]
GO 
/* 
Author Name : SAKTHI
Created On 	: <Created Date (24/02/2014)  >
Section  	: CLIENT MANAGEMENT Help
Purpose  	: CLIENT Help
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
CREATE PROCEDURE [dbo].[SP_ClientManagement_Help](@Action NVARCHAR(100),
@Str NVARCHAR(400),@Str1 NVARCHAR(100),@Id INT)
AS
BEGIN
	IF @Action='CONTACTTYPELOAD'
	BEGIN
		--CREATE TABLE #TEMP (Id BIGINT NOT NULL, ContactType NVARCHAR(100) NOT NULL)
		--INSERT INTO #TEMP (Id,ContactType) VALUES(1,'Admin')
		--INSERT INTO #TEMP (Id,ContactType) VALUES(2,'HR')
		--INSERT INTO #TEMP (Id,ContactType) VALUES(3,'secretary')
		--INSERT INTO #TEMP (Id,ContactType) VALUES(3,'Booker')
		--INSERT INTO #TEMP (Id,ContactType) VALUES(3,'Extra C C')
		--SELECT ContactType,Id from #TEMP WHERE ContactType<>'' GROUP BY ContactType,Id;
		SELECT ContactType ContactType,Id  FROM WRBHBClientContactType GROUP BY ContactType,Id;
	END
	IF @Action='TITLELOAD'
	BEGIN
		CREATE TABLE #TITLE(Title NVARCHAR(100));
		INSERT INTO #TITLE(Title)SELECT 'Mr';
		INSERT INTO #TITLE(Title)SELECT 'Ms';
		SELECT Title FROM #TITLE;
	END
	IF @Action='FIELDTYPELOAD'
	BEGIN
		CREATE TABLE #FIELDTYPE(FieldType NVARCHAR(100));
		INSERT INTO #FIELDTYPE(FieldType)SELECT 'Text Box';
		INSERT INTO #FIELDTYPE(FieldType)SELECT 'List Box';
		SELECT FieldType FROM #FIELDTYPE;
	END
	IF @Action='PAGELOAD'
	BEGIN

		-- THERE IS NO DATA THEN ONLY LOAD USER TABLE
		SELECT ClientName ,Id as Id,CAddress1 CAId,CAddress2 CA2Id,CCountry CCId,CState SId,CCity CId,
		CLocality LId,CPincode PId 
		FROM WRBHBMasterClientManagement
		WHERE IsActive=1 order by ClientName asc;
		-- Sales Executive
		SELECT FirstName AS label,Hd.Id as Id  FROM WRBHBUser  hd
		join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
		WHERE rl.Roles='Sales Executive' AND hd.IsActive=1 AND hd.IsDeleted=0;
		-- C R M
		SELECT FirstName AS label,Hd.Id as Id  FROM WRBHBUser  hd
		join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0 
		WHERE  rl.Roles='CRM'  AND hd.IsActive=1 AND hd.IsDeleted=0;
		-- Key Account Person
		SELECT FirstName AS label,Hd.Id as Id  FROM WRBHBUser  hd
		join WRBHBUserRoles rl on hd.Id=rl.UserId and rl.IsActive=1 and rl.IsDeleted=0
		WHERE  rl.Roles='Key Account Person'  AND hd.IsActive=1 AND hd.IsDeleted=0;
		---MasterClient hlptxt
		--SELECT * FROM WRBHBClientManagementMasterClient

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
	IF @Action='MODELDELETE'
	BEGIN
		UPDATE WRBHBClientManagementAddNewClient SET IsDeleted=1,IsActive=0 WHERE  Id=@Id;
		UPDATE WRBHBClientManagementAddClientGuest SET IsDeleted=1,IsActive=0 WHERE  Id=@Id;
	END
	IF @Action='IMAGEUPLOAD'
	BEGIN
		UPDATE WRBHBClientManagement SET ClientLogo=@Str,ImageName=@Str1 WHERE Id=@Id
	END
	IF @Action='MasterClientAddress'
	BEGIN
		SELECT ClientName ,Id as Id,ISNULL(CAddress1,'') CAId,ISNULL(CAddress2,'') CA2Id,
		ISNULL(CCountry,'') CCId,ISNULL(CState,'') SId,ISNULL(CCity,'') CId,
		ISNULL(CLocality,'') LId,ISNULL(CPincode,'') PId,ISNULL(InCCountry,'') CName 
		FROM WRBHBMasterClientManagement
		WHERE IsActive=1 AND Id=@Id ;
		
		SELECT StateName AS label,Id as StateId from WRBHBState WHERE IsActive=1;
		
		
	END
	IF @Action='TRPageload'
	BEGIN
	 SELECT ClientName,Id FROM WRBHBClientManagement 
	 WHERE  Status='Active' AND IsActive=1 AND IsDeleted=0
	END
	IF @Action='Client'
	BEGIN
	 SELECT TrClientURL FROM WRBHBClientManagement 
	 WHERE  Id=@Id AND IsActive=1 AND IsDeleted=0
	END
END

