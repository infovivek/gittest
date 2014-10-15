 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientWisePricingModel_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_ClientWisePricingModel_Help
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (25/06/2014)  >
		Section  	: ClientWisePricingModel Help
		Purpose  	: ClientWisePricingModel Help
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
CREATE PROCEDURE [dbo].Sp_ClientWisePricingModel_Help
(
@Action		NVARCHAR(100),
@Str		NVARCHAR(100),
@Id			INT
) 
AS
BEGIN
IF @Action='PAGELOAD'
	BEGIN
		SELECT Name AS label,Id AS data FROM WRBHBTransSubsPriceModel WHERE IsActive=1 AND IsDeleted=0
	END
IF @Action='CLIENTLOAD'
	BEGIN
		SELECT ClientName,Id AS ClientId,CONVERT(nvarchar(100),GETDATE(),103) as DateId--,0 as Id
		 FROM WRBHBClientManagement 
		WHERE Id NOT IN (SELECT ClientId FROM WRBHBClientwisePricingModel WHERE IsActive=1) AND IsActive=1 AND IsDeleted=0 
		ORDER BY ClientName
	END
IF @Action='LASTCLIENT'	
	BEGIN	
		SELECT CM.ClientName,CPM.ClientId,CPM.Id,
		ISNULL (CONVERT(NVARCHAR(100),EffectivefromDate,103),CONVERT(NVARCHAR(100),GETDATE(),103)) AS Date--as Date,Convert(NVARCHAR(100),EffectivefromDate,103) AS DATE 
		FROM WRBHBClientwisePricingModel CPM
		JOIN WRBHBTransSubsPriceModel PM ON PM.Id=CPM.PricingModelId
		JOIN WRBHBClientManagement CM ON CM.Id=CPM.ClientId
		WHERE CPM.PricingModelId=@Id AND CPM.IsActive=1 AND CPM.IsDeleted=0 AND PM.IsActive=1 and PM.IsDeleted=0
		ORDER BY ClientName
	END
IF @Action='CLIENTDELETE'
	BEGIN
		UPDATE WRBHBClientwisePricingModel SET IsActive=0,IsDeleted=1 WHERE Id=@Id
	END	
END	

