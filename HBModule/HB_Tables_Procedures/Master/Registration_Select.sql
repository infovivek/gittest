SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Registration_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Registration_Select]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: REGISTRATION Select
Purpose  	: REGISTRATION Select
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
CREATE PROCEDURE Sp_Registration_Select
(
@ClientId		BIGINT,
--@Active			NVARCHAR(100),
@Id				BIGINT,
@UserId			BIGINT
)
AS
BEGIN
IF(@Id=0)
	BEGIN
	 SELECT FirstName,Mobile,Email,IsActive as Active,ClientId,Id FROM WRBHBExternal_Users 
	 WHERE IsDeleted=0
	END
ELSE
	BEGIN
	 SELECT Title,FirstName,LastName,Mobile,Email,EX.IsActive as Active,cm.ClientName as ClientName,ClientId as data,Ex.Id as Id
	  FROM WRBHBExternal_Users EX
	 join WRBHBClientManagement CM on CM.Id=EX.ClientId and cm.IsActive=1 and cm.IsDeleted=0
	  WHERE ex.IsDeleted=0 and ex.Id=@Id
	END	
--BEGIN
--	IF((@ClientId != 0) AND (@Active=null))
--	BEGIN
--		SELECT FirstName,Email,Mobile FROM WRBHBExternal_Users WHERE ClientId=@ClientId
--	END
--	ELSE IF((@ClientId = 0) AND(@Active = 'Active'))
--	BEGIN
--		SELECT FirstName,Email,Mobile FROM WRBHBExternal_Users WHERE IsActive=1
--	END
--	ELSE IF((@ClientId = 0) AND (@Active = 'InActive'))
--	BEGIN
--		SELECT FirstName,Email,Mobile FROM WRBHBExternal_Users WHERE IsActive=0
--	END
--	ELSE IF((@ClientId !=0) AND (@Active != NULL))
--	BEGIN
--		SELECT FirstName,Email,Mobile FROM WRBHBExternal_Users WHERE ClientId=@ClientId AND IsActive=@Active
--	END
	
END	

