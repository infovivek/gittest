GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientColumn_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientColumn_Help]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (1/04/2014)  >
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi - Fields Added & Procedure Alteration
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_ClientColumn_Help](@Action NVARCHAR(100),@Id BIGINT)
AS
BEGIN
 IF @Action = 'PAGELOAD'
  BEGIN
   SELECT ClientName,Id as ZId FROM WRBHBClientManagement 
   WHERE IsActive = 1 AND IsDeleted = 0 ORDER BY ClientName ASC;
  END
 IF @Action = 'LASTDATA'
  BEGIN
   SELECT TOP 1 Id,Column1,Column2,Column3,Column4,Column5,Column6,Column7,
   Column8,Column9,Column10,ClientId,Column1Mandatory,Column2Mandatory,
   Column3Mandatory,Column4Mandatory,Column5Mandatory,Column6Mandatory,
   Column7Mandatory,Column8Mandatory,Column9Mandatory,Column10Mandatory,
   UpdateChkColumn1,UpdateChkColumn2,UpdateChkColumn3,
   UpdateChkColumn4,UpdateChkColumn5,UpdateChkColumn6,
   UpdateChkColumn7,UpdateChkColumn8,UpdateChkColumn9,
   UpdateChkColumn10
   FROM WRBHBClientColumns 
   WHERE IsActive = 1 AND IsDeleted = 0 AND ClientId = @Id
   ORDER BY Id DESC;
   END		
 END 	 