 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchProperty_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchProperty_Help
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (02/09/2014)  >
		Section  	: SEARCH PROPERTY HELP
		Purpose  	: SEARCH PROPERTY HELP
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
CREATE PROCEDURE Sp_SearchProperty_Help
(
@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@Id			INT
)
AS							
BEGIN						--DROP TABLE #TEMP1  DROP TABLE #TEMP3 DROP TABLE #TEMPF
	IF @Action='Pageload'	
	BEGIN
		CREATE TABLE #TEMP1(PId BIGINT,Property NVARCHAR(1000),Category NVARCHAR(1000),Description NVARCHAR(2200),
		Address NVARCHAR(1000),Locality NVARCHAR(1000),LId BIGINT,City NVARCHAR(1000),CId BIGINT,State NVARCHAR(1000),
		SId BIGINT,Postal NVARCHAR(1000),Phone NVARCHAR(1000),Directions NVARCHAR(2200),Keyword NVARCHAR(1000),
		Email NVARCHAR(1000),Type NVARCHAR(1000))
	
		INSERT INTO #TEMP1(PId,Property,Category,Description,Address,Locality,LId,City,CId,State,SId,Postal,Phone,
		Directions,Keyword,Email,Type)
		
		SELECT P.Id,PropertyName,Category,substring(PropertDescription,0,500),Propertaddress,L.Locality as Locality,
		P.LocalityId as LId,C.CityName AS City,P.CityId AS CId,S.StateName AS State,P.StateId AS SId,Postal,Phone,
		Directions,Keyword,Email,T.PropertyType AS Type 
		FROM WRBHBProperty P
		left outer JOIN WRBHBCity C ON P.CityId=C.Id and c.IsActive=1 and c.IsDeleted=0
		left outer JOIN WRBHBState S ON P.StateId=S.Id and s.IsActive=1-- and s.IsDeleted=0
		left outer JOIN WRBHBLocality L ON P.LocalityId=L.Id and l.IsActive=1 and l.IsDeleted=0
		left outer JOIN WRBHBPropertyType T ON P.PropertyType=T.Id  
		WHERE P.IsActive=1 AND P.IsDeleted=0
		AND P.Id NOT IN (SELECT DISTINCT PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		ORDER BY PropertyName
		
		
		--INSERT INTO #TEMP1(PId,Property,Category,Description,Address,Locality,LId,City,CId,State,SId,Postal,Phone,
		--Directions,Keyword,Email,Type)
		
		--SELECT P.Id,p.PropertyName,'CPP' Category,substring(PropertDescription,0,500),Propertaddress,L.Locality as Locality,
		--P.LocalityId as LId,C.CityName AS City,P.CityId AS CId,S.StateName AS State,P.StateId AS SId,Postal,Phone,
		--Directions,Keyword,p.Email,ISNULL(T.PropertyType,'') AS Type 
		--FROM WRBHBContractClientPref_Details D 
		--left outer join WRBHBProperty P on p.id=d.PropertyId
		--left outer JOIN WRBHBCity C ON P.CityId=C.Id and c.IsActive=1 and c.IsDeleted=0
		--left outer JOIN WRBHBState S ON P.StateId=S.Id and s.IsActive=1-- and s.IsDeleted=0
		--left outer JOIN WRBHBLocality L ON P.LocalityId=L.Id and l.IsActive=1 and l.IsDeleted=0
		--left outer JOIN WRBHBPropertyType T ON P.PropertyType=T.Id  
		--WHERE P.IsActive=1 AND P.IsDeleted=0
		--Group by P.Id,p.PropertyName,PropertDescription,Propertaddress,L.Locality,
		--P.LocalityId ,C.CityName ,P.CityId ,S.StateName ,P.StateId,Postal,Phone,
		--Directions,Keyword,p.Email,T.PropertyType
		--ORDER BY p.PropertyName
		
		SELECT PropertyName AS Property,Id AS ZId FROM WRBHBProperty WHERE IsActive=1 AND IsDeleted=0
		ORDER BY PropertyName
	
		SELECT DISTINCT S.StateName AS State,S.Id AS StateId FROM WRBHBProperty P
		JOIN WRBHBState S ON P.StateId=S.Id ORDER BY StateName
	
		SELECT DISTINCT C.CityName AS City,P.CityId AS CityId FROM WRBHBProperty P
		JOIN WRBHBCity C ON P.CityId=C.Id ORDER BY CityName
		
		SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') PropertDescription,
		ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
		CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
		Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type from #TEMP1 order by Property
	 	
	END
	
	IF @Action='cityload'	
	BEGIN
		SELECT DISTINCT C.CityName AS City,P.CityId AS CityId FROM WRBHBProperty P
		JOIN WRBHBCity C ON P.CityId=C.Id WHERE C.StateId=@Id
		ORDER BY CityName 
	END
END	

