 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CompanyMaster_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_CompanyMaster_Help]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: COMPANY MASTER HELP
		Purpose  	: COMPANY MASTER HELP
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
CREATE PROCEDURE [dbo].[Sp_CompanyMaster_Help]
(
@Action		NVARCHAR(100),
@Str1		NVARCHAR(100),
@Str2		NVARCHAR(100),
@Id1		INT,
@Id2		INT
)
AS
BEGIN
IF @Action ='STATELOAD'
 BEGIN
  SELECT  StateName label,Id AS StateId FROM WRBHBState 
  WHERE IsActive=1 
 END
 IF @Action = 'CITYLOAD'
  BEGIN
   SELECT CityName AS label,Id  FROM WRBHBCity 
   WHERE IsActive=1 AND StateId=@Id1 ORDER BY CityName
  END
  IF @Action='IMAGEUPLOAD'
	BEGIN
		UPDATE WRBHBCompanyMaster SET Logo=@Str1
		SELECT @Str1 Logo
	END
	IF @Action='Pageload'
	BEGIN
	SELECT top 1 LegalCompanyName,CompanyShortName,Address,S.StateName as State,C.CityName as City,Phone,
	Email,PanCardNo,Logo,CM.Id,Cm.State as StateId,Cm.City as CityId,ImageName 
	 FROM WRBHBCompanyMaster CM
	LEFT OUTER JOIN WRBHBState S on S.Id=CM.State
	LEFT OUTER JOIN WRBHBCity C on C.Id=CM.City and c.IsActive=1
	WHERE  CM.IsActive=1 and CM.IsDeleted=0 and C.IsDeleted=0
	order by cm.Id desc;
		
	END
END
 