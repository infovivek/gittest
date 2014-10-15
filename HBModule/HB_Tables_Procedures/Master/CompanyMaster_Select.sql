SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CompanyMaster_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_CompanyMaster_Select]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (22/04/2014)  >
Section  	: COMPANY MASTER SELECT
Purpose  	: COMPANY MASTER SELECT
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
CREATE PROCEDURE Sp_CompanyMaster_Select
(
@Id BIGINT
)
AS
BEGIN
IF(@Id=0)
BEGIN
   SELECT CompanyShortName,S.StateName,Email,CM.Id FROM WRBHBCompanyMaster CM
   JOIN WRBHBState S on S.Id=CM.State
   WHERE CM.IsActive=1 AND CM.IsDeleted=0
END

IF(@Id!=0)
BEGIN
	SELECT LegalCompanyName,CompanyShortName,Address,S.StateName as State,C.CityName as City,Phone,
	Email,PanCardNo,Logo,CM.Id,Cm.State as StateId,Cm.City as CityId 
	 FROM WRBHBCompanyMaster CM
	JOIN WRBHBState S on S.Id=CM.State
	JOIN WRBHBCity C on C.Id=CM.City and c.IsActive=1
	WHERE CM.Id=@Id and CM.IsActive=1 and CM.IsDeleted=0 and C.IsDeleted=0
END
END

