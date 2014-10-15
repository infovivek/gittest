
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientCloumn_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ClientCloumn_Help]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (1/04/2014)  >
Section  	: IMPORT GUEST HELP
Purpose  	: IMPORT HELP
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

CREATE PROCEDURE [dbo].[Sp_ClientCloumn_Help]
(
@Action NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT
)
 AS
 BEGIN
   IF @Action='PAGELOAD'
   BEGIN
		SELECT ClientName as ClientName,Id as ZId FROM WRBHBClientManagement WHERE IsActive=1 AND IsDeleted=0
		ORDER BY ClientName
	END
   IF @Action='LASTDATA'
   BEGIN
		SELECT Id,Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,ClientId
		FROM WRBHBClientColumns WHERE ClientId=@Id
   END		
 END 	 