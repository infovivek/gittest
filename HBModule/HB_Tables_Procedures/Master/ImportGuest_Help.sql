
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ImportGuest_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_ImportGuest_Help
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

CREATE PROCEDURE [dbo].[Sp_ImportGuest_Help]
(
@Action NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT,
@ClientId BIGINT
)
 AS
 BEGIN
   IF @Action='PAGELOAD'
   BEGIN
		SELECT ClientName as Client,Id as Id FROM WRBHBClientManagement 
		WHERE IsActive=1 AND IsDeleted=0
		GROUP BY ClientName,Id
		ORDER BY ClientName ASC
   END
 IF @Action='GUESTDELETE'
	BEGIN
		UPDATE WRBHBClientManagementAddClientGuest SET IsDeleted=1,IsActive=0,ModifiedBy=@UserId 
		WHERE Id=@Id;
	END
 END 	 