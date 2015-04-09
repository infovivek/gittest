SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_ContractClientPref_Help

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CONTRACT CLIENT PREF HELP
Purpose  	: PRODUCT HELP
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
Vivek			26/07/2014		Vivek				Contact Name and Number addition
/*****************/***************************************************************************************		
*******************************************************************************************************
*/

CREATE PROCEDURE Sp_ContractClientPref_Help
(
@PAction NVARCHAR(100),
@UserId INT,
@Id		INT
)
 AS
 BEGIN
 IF @PAction='PAGELOAD'
 BEGIN 
 --Table DateFunction
   select Id,ClientName from WRBHBClientManagement 
   where IsActive=1 AND IsDeleted=0 order by ClientName asc; 
   
 
  END
  IF @PAction='GridPropertyManaged'
  BEGIN 
  --Table2 DateFunction
    Select P.Id as PropertyId,(P.PropertyName+','+C.CityName+','+S.StateName) as Property from WRBHBProperty P
    JOIN WRBHBState S ON P.StateId=S.Id AND S.IsActive=1
    JOIN WRBHBCity C  ON P.CityId=C.Id AND C.IsActive=1 AND C.IsDeleted=0
    where P.IsActive=1 and P.IsDeleted=0 AND Category='External Property';
 End
 IF @PAction='LastData'
 BEGIN
	DECLARE @HeaderId BIGINT;
	SELECT @HeaderId=Id FROM WRBHBContractClientPref_Header WHERE ClientId=@Id
	SELECT CM.ClientName,ClientId,Date,CP.Id FROM WRBHBContractClientPref_Header CP 
	JOIN WRBHBClientManagement CM ON CP.ClientId=CM.Id AND CM.IsActive=1 AND CM.IsDeleted=0
	WHERE CP.Id=@HeaderId AND CP.IsActive=1 AND CP.IsDeleted=0;
    
    SELECT HeaderId,P.PropertyName as Property,PropertyId,RoomType,RoomId,Isnull(TariffSingle,0) AS ATariffSingle,
    Isnull(TariffDouble,0) ATariffDouble,
    Isnull(TariffTriple,0) AS ATariffTriple,Isnull(RTariffSingle,0) AS RTariffSingle,
    Isnull(RTariffDouble,0) AS RTariffDouble,Isnull(RTariffTriple,0) AS RTariffTriple,
    Facility,TaxInclusive as Inclusive ,TaxPercentage as Tax,Isnull(LTAgreed,0) AS LTAgreed,
    Isnull(LTRack,0) AS LTRack,Isnull(STAgreed,0) AS STAgreed,Isnull(C.Email,'') as ContactEmail,
    Isnull (ContactName,'') as ContactName,Isnull (ContactPhone,'') as ContactPhone,C.Id
	FROM WRBHBContractClientPref_Details C
	JOIN WRBHBProperty P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	WHERE HeaderId=@HeaderId AND C.IsActive=1 AND C.IsDeleted=0 ORDER BY P.PropertyName
 
	
	SELECT ISNULL(HeaderId,0) AS ClientId,ISNULL(P.PropertyName,'') AS Property,ISNULL(RoomType,'') AS RoomType,
	Isnull(TariffSingle,0) AS ATariffSingle,Isnull(TariffDouble,0) ATariffDouble,
    Isnull(TariffTriple,0) AS ATariffTriple,Isnull(RTariffSingle,0) AS RTariffSingle,
    Isnull(RTariffDouble,0) AS RTariffDouble,Isnull(RTariffTriple,0) AS RTariffTriple,
    ISNULL(Facility,'') AS Facility,ISNULL(TaxInclusive,0) as Inclusive ,ISNULL(TaxPercentage,0) as Tax,Isnull(LTAgreed,0) AS LTAgreed,
    Isnull(LTRack,0) AS LTRack,Isnull(STAgreed,0) AS STAgreed,
    Isnull(C.Email,'') as ContactEmail,Isnull (ContactName,'') as ContactName,
    Isnull (ContactPhone,'') as ContactPhone
	FROM WRBHBContractClientPref_Details C
	JOIN WRBHBProperty P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
	WHERE HeaderId=@HeaderId AND C.IsActive=1 AND C.IsDeleted=0 ORDER BY P.PropertyName
 
 
 
 --  SELECT HeaderId,PropertyName as Property,PropertyId,RoomType,RoomId,TariffSingle,TariffDouble,TaxInclusive as Inclusive ,TaxPercentage as Tax,D.Id
	--FROM WRBHBContractClientPref_Header H
	--join WRBHBContractClientPref_Details D  on H.Id=D.HeaderId and d.IsActive=1 and d.IsDeleted=0 
	--WHERE H.Id=@Id and H.IsActive=1 and H.IsDeleted=0;
	
	--Select Id FROM WRBHBContractClientPref_Header where Id=@Id and IsActive=1 and IsDeleted=0;
 ----Table3 DateFunction
 --      Select PR.RoomType+' - '+Pr.RoomNo+' - '+PR.RoomCategory as RoomType,pr.Id as RoomId
 --      from WRBHBProperty prty
 --      join WRBHBPropertyRooms PR on PR.PropertyId=prty.Id and PR.IsActive=1 and PR.IsDeleted=0 
 --      where prty.IsActive=1 and prty.IsDeleted=0 and prty.Id=@Id
 --      group by PR.Id,PR.RoomType,PR.RoomNo,PR.RoomCategory
    
 END
IF @PAction='Delete'
 BEGIN
		 UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1
		 WHERE Id=@Id  
 END
 END
 
 
 
 