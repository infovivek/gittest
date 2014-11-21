 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientWisePricingModel_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_ClientWisePricingModel_Insert
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (25/06/2014)  >
		Section  	: ClientWisePricingModel INSERT
		Purpose  	: ClientWisePricingModel INSERT
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
CREATE PROCEDURE [dbo].Sp_ClientWisePricingModel_Insert
(
@PricingModelId		BIGINT,
@ClientId			BIGINT,
@CreatedBy			INT,
@FromDate			NVARCHAR(100),
@ToDate				NVARCHAR(100)
) 
AS
BEGIN
IF EXISTS(SELECT NULL FROM WRBHBClientwisePricingModel WHERE PricingmodelId=@PricingModelId AND ClientId=@ClientId
			AND IsActive=1 AND IsDeleted=0)
BEGIN
 UPDATE WRBHBClientwisePricingModel SET PricingModelId=@PricingModelId,ClientId=@ClientId,ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE(),EffectivefromDate=Convert(datetime,@FromDate),
	EffectiveToDate=CONVERT(datetime,@ToDate,103) WHERE PricingmodelId=@PricingModelId AND ClientId=@ClientId
	
	SELECT Id,RowId FROM WRBHBClientwisePricingModel WHERE PricingmodelId=@PricingModelId AND ClientId=@ClientId; 

 END
 ELSE
 BEGIN
INSERT INTO WRBHBClientwisePricingModel(PricingModelId,ClientId,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,
			ModifiedDate,RowId,EffectivefromDate,EffectiveToDate)
VALUES (@PricingModelId,@ClientId,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),
CONVERT(datetime,@FromDate,103),CONVERT(datetime,@ToDate,103))
		
 SELECT Id,RowId FROM WRBHBClientwisePricingModel WHERE Id=@@IDENTITY;		
END	
END	


