SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CloneClientPref_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_CloneClientPref_Help

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CLONE CLIENT HELP
Purpose  	: CLONE CLIENT HELP
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

CREATE PROCEDURE Sp_CloneClientPref_Help
(
@Action NVARCHAR(100),
@UserId INT,
@Id		INT,
@Id1	INT
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
	BEGIN 
		SELECT ClientId as ZId,CM.ClientName FROM WRBHBContractClientPref_Header CPH
		JOIN WRBHBClientManagement CM ON CPH.ClientId=CM.Id
		WHERE CPH.IsActive=1 ORDER BY ClientName ASC
		
		SELECT ClientName as MasterClient,Id as ZId FROM WRBHBMasterClientManagement 
		WHERE IsActive=1 AND IsDeleted=0 ORDER BY MasterClient ASC
		
		SELECT Id ClientId,ClientName ClientName FROM WRBHBClientManagement
		WHERE IsActive=1 AND IsDeleted=0 ORDER BY ClientName ASC
	END

 IF @Action='CLIENTLOAD'
 BEGIN
		--SELECT CM.ClientName as ClientName,ClientId as ClientId FROM WRBHBContractClientPref_Header CPH
		--JOIN WRBHBClientManagement CM ON CPH.ClientId=CM.Id
		--WHERE CPH.ClientId!=@Id AND CPH.IsActive=1 ORDER BY ClientName ASC
		SELECT Id ClientId,ClientName ClientName FROM WRBHBClientManagement
		WHERE IsActive=1 AND Id!=@Id ORDER BY ClientName ASC	
 END
 IF @Action='FILTER'
 BEGIN
	SELECT Id ClientId,ClientName ClientName FROM WRBHBClientManagement
		WHERE IsActive=1 AND Id!=@Id AND MasterClientId=@Id1 ORDER BY ClientName ASC
 END
 END