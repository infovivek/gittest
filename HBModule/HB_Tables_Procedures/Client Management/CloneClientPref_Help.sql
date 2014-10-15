 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CloneClientPref_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_CloneClientPref_Help
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (25/06/2014)  >
		Section  	:  CloneClientPref Help
		Purpose  	:  CloneClientPref Help
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
CREATE PROCEDURE [dbo].Sp_CloneClientPref_Help
(
@Action		NVARCHAR(100),
@Str		NVARCHAR(100),
@Id			INT
) 
AS
BEGIN
IF @Action='PAGELOAD'
	BEGIN
		SELECT ClientName,Id AS ClientId FROM WRBHBClientManagement 
		--WHERE Id NOT IN (SELECT ClientId FROM WRBHBClientwisePricingModel WHERE IsActive=1) AND IsActive=1 AND IsDeleted=0 
		ORDER BY ClientName
	END
END	

