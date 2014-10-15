SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Registration_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Registration_Help]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: REGISTRATION HELP
Purpose  	: REGISTRATION HELP
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
CREATE PROCEDURE Sp_Registration_Help
(
@Action NVARCHAR(100),
--@Id		BIGINT,
@UserId BIGINT
)
AS
BEGIN
 IF @Action='PAGELOAD'
 BEGIN
		SELECT  ClientName AS Client, Id as Id FROM WRBHBClientManagement WHERE IsActive=1 AND IsDeleted=0
		order by ClientName
 END
END