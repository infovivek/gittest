SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientGradeValue_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ClientGradeValue_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (10/03/2014)  >
		Section  	: CLIENTGRADEVALUE Help
		Purpose  	: Apartment Help
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
CREATE PROCEDURE [dbo].[Sp_ClientGradeValue_Help](
@PAction		 NVARCHAR(100)=NULL,
@Pram1			 BIGINT,
@Pram2           BIGINT=NULL, 
@Pram3			 NVARCHAR(100)=NULL,
@Pram4			 NVARCHAR(100)=NULL, 
@UserId          BIGINT
)
AS
BEGIN 
IF @PAction ='Client'
BEGIN
			SELECT  Id,ClientName label FROM WRBHBClientManagement 
			WHERE  IsActive=1  AND IsDeleted=0  
END 
IF @PAction ='Grade'
BEGIN
			
			SELECT  Id,Grade label FROM dbo.WRBHBGradeMaster 
			WHERE  IsActive=1  AND IsDeleted=0 and ClientId=@Pram1			
			
END 
IF @PAction ='State'
BEGIN
			SELECT  StateName label,Id AS StateId FROM WRBHBState 
			WHERE IsActive=1 
			ORDER BY StateName ASC
			
			SELECT PropertyType as label, Id as data FROM WRBHBPropertyTYPE 
			
END 
IF @PAction ='City'
BEGIN
			SELECT  CityName label,C.Id as CityId,0 as Id FROM WRBHBCity C			
			WHERE C.IsActive=1  AND StateId=@Pram1
			AND C.Id NOT IN(	
			SELECT D.CityId FROM  WRBHBClientGradeValue G
			JOIN  dbo.WRBHBClientGradeValueDetails D WITH(NOLOCK) ON D.ClientGradeValueId=G.Id
			WHERE  G.GradeId=@Pram2 AND G.ClientId=CAST(@Pram3 AS INT))
			ORDER BY CityName ASC 
END 
IF @PAction ='CityFilter'
BEGIN
			SELECT  CityName label,C.Id as CityId,0 as Id FROM WRBHBCity C			
			WHERE C.IsActive=1 AND C.Id NOT IN(	
			SELECT D.CityId FROM  WRBHBClientGradeValue G
			JOIN  dbo.WRBHBClientGradeValueDetails D WITH(NOLOCK) ON D.ClientGradeValueId=G.Id AND D.IsActive=1 AND D.IsDeleted=0
			WHERE  G.GradeId=@Pram2 AND G.ClientId=CAST(@Pram1 AS INT)AND G.IsActive=1 AND G.IsDeleted=0)
			ORDER BY CityName ASC
			 
END 
IF @PAction ='CityLoad'
BEGIN
			SELECT  CityName label,Id as CityId,0 as Id FROM WRBHBCity 
			WHERE IsActive=1 order by CityName
END 
IF @PAction ='Delete'
BEGIN
			UPDATE WRBHBClientGradeValueDetails SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0 
			WHERE  Id=@Pram1;
END
IF @PAction ='Select'
BEGIN
	DECLARE @SelectId BIGINT,@ClientId BIGINT;
	SELECT @SelectId=Id FROM WRBHBClientGradeValue WHERE ClientId=@Pram1 AND GradeId=@Pram2
	SELECT ClientName,G.Grade,G.Id,ClientId,
	GradeId,MinValue,MaxValue 
	FROM dbo.WRBHBClientGradeValue G
	LEFT OUTER JOIN WRBHBClientManagement C ON C.Id=G.ClientId	
	WHERE  G.Id=@SelectId
		
	SELECT CityId,CityName label ,Id
	FROM WRBHBClientGradeValueDetails
	WHERE ClientGradeValueId=@SelectId AND IsDeleted=0
	ORDER BY CityName ASC
	
	SELECT @ClientId=ClientId FROM dbo.WRBHBClientGradeValue G WHERE  G.Id=@SelectId
	
	
	SELECT  Id,Grade label FROM dbo.WRBHBClientManagementAddClientGuest 
	WHERE  IsActive=1  AND IsDeleted=0 and CltmgntId=@ClientId 
	
END
IF @PAction ='GradeSave'
BEGIN
		DECLARE @GradeId BIGINT;
		IF @Pram2 = 0
		BEGIN	
		IF NOT EXISTS (SELECT NULL FROM WRBHBGradeMaster WITH (NOLOCK)
		WHERE UPPER(Grade) = UPPER(@Pram3)  AND IsDeleted = 0 AND IsActive = 1 AND ClientId=@Pram1)

		BEGIN
		INSERT INTO WRBHBGradeMaster(Grade,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,IsDeleted,RowId,ClientId)

		VALUES(@Pram3,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID(),@Pram1)

		SELECT @GradeId =@@IDENTITY;
		END
		ELSE
		BEGIN
		SELECT @GradeId=Id FROM WRBHBGradeMaster WITH (NOLOCK)
		WHERE UPPER(Grade) = UPPER(@Pram3)  AND IsDeleted = 0 AND IsActive = 1 AND ClientId=@Pram1
		END
		INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,Grade,Designation,CreatedBy,
		CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,CompanyName,
	    EmpCode,FirstName,LastName,GMobileNo,EmailId,RangeMin,RangeMax,GradeId)
		VALUES(@Pram1,@Pram3,@Pram4,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID(),
		'','','','','','',0,0,@GradeId)
	END	
END 

END 