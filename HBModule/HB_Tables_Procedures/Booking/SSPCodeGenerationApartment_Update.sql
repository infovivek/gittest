SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGenerationApartment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGenerationApartment_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGenerationApartment  Update 
Purpose  	: SSPCodeGenerationApartment  Update
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGenerationApartment_Update](
@SSPCodeGenerationId		BIGINT,
@ApartmentId				BIGINT,
@ApartmentNo				NVARCHAR(100),
@ApartmentType				NVARCHAR(100),
@SingleTariff				DECIMAL(22,7),
@DoubleTariff				DECIMAL(22,7),
@CreatedBy					BIGINT,
@Id							BIGINT) 
AS
BEGIN
 --Update
 
	UPDATE dbo.WRBHBSSPCodeGenerationApartment SET
	SSPCodeGenerationId=@SSPCodeGenerationId,
	ApartmentNo=@ApartmentNo,
	ApartmentType=@ApartmentType,
	ApartmentId=@ApartmentId,
	SingleTariff=@SingleTariff,
	DoubleTariff=@DoubleTariff,
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id
	SELECT Id,RowId FROM WRBHBSSPCodeGenerationApartment WHERE Id=@Id
 
END
GO
