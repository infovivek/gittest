 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SearchProperty_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_SearchProperty_Search
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: Search Property Search
		Purpose  	: Search Property Search
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
CREATE PROCEDURE Sp_SearchProperty_Search
(
--@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@Str2		NVARCHAR(100),
@Id1		INT,
@Id2		INT,
@Id3		INT
)
AS											--DROP TABLE #TEMP1
BEGIN
		CREATE TABLE #TEMP1(PId BIGINT,Property NVARCHAR(1000),Category NVARCHAR(1000),Description NVARCHAR(2200),
		Address NVARCHAR(1000),Locality NVARCHAR(1000),LId BIGINT,City NVARCHAR(1000),CId BIGINT,State NVARCHAR(1000),
		SId BIGINT,Postal NVARCHAR(1000),Phone NVARCHAR(1000),Directions NVARCHAR(2200),Keyword NVARCHAR(1000),
		Email NVARCHAR(1000),Type NVARCHAR(1000))
	
		INSERT INTO #TEMP1(PId,Property,Category,Description,Address,Locality,LId,City,CId,State,SId,Postal,Phone,
		Directions,Keyword,Email,Type)
		
		SELECT P.Id,PropertyName,Category,PropertDescription,Propertaddress,L.Locality as Locality,
		P.LocalityId as LId,C.CityName AS City,P.CityId AS CId,S.StateName AS State,P.StateId AS SId,Postal,Phone,
		Directions,Keyword,Email,T.PropertyType AS Type 
		FROM WRBHBProperty P
		left outer JOIN WRBHBCity C ON P.CityId=C.Id and c.IsActive=1 and c.IsDeleted=0
		left outer JOIN WRBHBState S ON P.StateId=S.Id and s.IsActive=1-- and s.IsDeleted=0
		left outer JOIN WRBHBLocality L ON P.LocalityId=L.Id and l.IsActive=1 and l.IsDeleted=0
		left outer JOIN WRBHBPropertyType T ON P.PropertyType=T.Id  
		WHERE P.IsActive=1 AND P.IsDeleted=0
		AND P.Id NOT IN (SELECT distinct PropertyId from WRBHBContractClientPref_Details
		WHERE IsActive=1 AND IsDeleted=0)
		ORDER BY PropertyName
		
		
		--INSERT INTO #TEMP1(PId,Property,Category,Description,Address,Locality,LId,City,CId,State,SId,Postal,Phone,
		--Directions,Keyword,Email,Type)
		
		--SELECT P.Id,p.PropertyName,'CPP' Category,PropertDescription,Propertaddress,L.Locality as Locality,
		--P.LocalityId as LId,C.CityName AS City,P.CityId AS CId,S.StateName AS State,P.StateId AS SId,Postal,Phone,
		--Directions,Keyword,p.Email,T.PropertyType AS Type 
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
	
		IF @Id1=0 AND @Id2=0 AND @Id3=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type from #TEMP1 order by Property
		END
		
		---ONE DATA IS GIVEN
		---PROPERTY IS GIVEN
		IF @Id1!=0 AND @Id2=0 AND @Id3=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 ORDER BY Property
		END
		
		---PROPERTY TYPE IS GIVEN
		IF @Id1=0 AND @Id2=0 AND @Id3=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE Category=@Str1 ORDER BY Property
		END
		
		---STATE IS GIVEN
		IF @Id1=0 AND @Id2!=0 AND @Id3=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE SId=@Id2 ORDER BY Property
		END
		
		---CITY IS GIVEN
		IF @Id1=0 AND @Id2=0 AND @Id3!=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE CId=@Id3 ORDER BY Property
		END
		
		--TWO DATA ARE GIVEN
		--PROPERTY AND TYPE ARE GIVEN
		IF @Id1!=0 AND @Id2=0 AND @Id3=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND Category=@Str1 ORDER BY Property
		END
		 
		--PROPERTY AND STATE ARE GIVEN
		IF @Id1!=0 AND @Id2!=0 AND @Id3=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND SId=@Id2 ORDER BY Property
		END
		
		--PROPERTY AND CITY ARE GIVEN
		IF @Id1!=0 AND @Id2=0 AND @Id3!=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND CId=@Id3 ORDER BY Property
		END
		
		--TYPE AND STATE ARE GIVEN
		IF @Id1=0 AND @Id2!=0 AND @Id3=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE Category=@Str1 AND SId=@Id2 ORDER BY Property
		END
		
		--TYPE AND CITY ARE GIVEN
		IF @Id1=0 AND @Id2=0 AND @Id3!=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE Category=@Str1 AND CId=@Id3 ORDER BY Property
		END
		
		--STATE AND CITY ARE GIVEN
		IF @Id1=0 AND @Id2!=0 AND @Id3!=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE SId=@Id2 AND CId=@Id3 ORDER BY Property
		END
		
		--THREE DATA ARE GIVEN
		--PROPERTY,TYPE AND STATE ARE GIVEN
		IF @Id1!=0 AND @Id2!=0 AND @Id3=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND SId=@Id2 AND Category=@Str1 ORDER BY Property
		END
		
		--PROPERTY,CITY AND STATE ARE GIVEN
		IF @Id1!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND SId=@Id2 AND CId=@Id3 ORDER BY Property
		END
		
		--TYPE,STATE AND CITY ARE GIVEN
		IF @Id1=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE Category=@Str1 AND SId=@Id2 AND CId=@Id3 ORDER BY Property
		END
		
		--ALL DATA ARE GIVEN
		IF @Id1!=0 AND @Id2!=0 AND @Id3!=0 AND @Str1!=''
		BEGIN
			SELECT PId,ISNULL(Property,'') as PropertyName,ISNULL(Category,'') Category,ISNULL(Description,'') 
			PropertDescription,ISNULL(Address,'') Propertaddress,ISNULL(Locality,'') Locality,LId,ISNULL(City,'') City,
			CId,ISNULL(State,'') State,SId,ISNULL(Postal,'') Postal,ISNULL(Phone,'') Phone,ISNULL(Directions,'') 
			Directions,ISNULL(Keyword,'') Keyword,ISNULL(Email,'') Email,ISNULL(Type,'') Type FROM #TEMP1 
			WHERE PId=@Id1 AND Category=@Str1 AND SId=@Id2 AND CId=@Id3 ORDER BY Property
		END
	END
