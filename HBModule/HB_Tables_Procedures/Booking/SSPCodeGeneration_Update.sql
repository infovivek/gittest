SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGeneration_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGeneration_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGeneration  UPDATE 
Purpose  	: SSPCodeGeneration  UPDATE 
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGeneration_Update](
@ClientId		BIGINT,
@PropertyId		BIGINT,
@SSPCode		NVARCHAR(100),
@SSPName		NVARCHAR(100),
@BookingLevel	NVARCHAR(100),
@SingleTariff	DECIMAL(22,7),
@DoubleTariff	DECIMAL(22,7),
@TripleTariff	DECIMAL(22,7),
@CreatedBy		BIGINT,
@Id				BIGINT) 
AS
BEGIN
 --UPDATE
 
	UPDATE dbo.WRBHBSSPCodeGeneration SET 
	ClientId=@ClientId,
	PropertyId=@PropertyId,
	SSPName=@SSPName,
	SSPCode=@SSPCode,
	BookingLevel=@BookingLevel,
	SingleTariff=@SingleTariff,
	DoubleTariff=@DoubleTariff,
	TripleTariff=@TripleTariff,	
	ModifiedBy=@CreatedBy,
	ModifiedDate=GETDATE()
	WHERE Id=@Id
	SELECT Id,RowId FROM WRBHBSSPCodeGeneration WHERE Id=@Id
 
END
GO
