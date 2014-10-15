 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagement_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagement_Update]
GO   
/* 
        Author Name : mini
		Created On 	: <Created Date (11/03/2014)  >
		Section  	: CONTRACT MANAGEMENT 
		Purpose  	: CONTRACT Insert
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
CREATE PROCEDURE Sp_ContractManagement_Update 
	(@ContractType nvarchar(100),   @ContractName  nvarchar(100),
	 @ClientName nvarchar(100),
	 @Property  nvarchar(100),      @BookingLevel  nvarchar(100),
	 @StartDate  nvarchar(100),     @EndDate  nvarchar(100),
	 @ExtenstionDate  nvarchar(100),@ContractPriceMode  nvarchar(100),
	 @RateInterval  nvarchar(100),  @SalesExecutive  nvarchar(100),
	 @AgreementDate  nvarchar(100), @CreatedBy BIGINT,
	 @PropertyId BIGINT,@ClientId BIGINT,@SalesExecutiveId bigint,
	 @Types nvarchar(100),@PrintingModel nvarchar(100),@Status nvarchar(100),
	 @TransubName nvarchar(100),@TransubId BigInt,
	 @Id bigint) 
AS
BEGIN 
 --IF EXISTS (SELECT NULL FROM  WRBHBContractManagement WHERE UPPER(ContractName)=UPPER(@ContractName))
 --BEGIN
	--		SELECT 'Contract Name Already Exists';
 --END
 --ELSE
 --BEGIN
update WRBHBContractManagement set BookingLevel=@BookingLevel,ContractName=@ContractName,
ContractPriceMode=@ContractPriceMode,RateInterval=@RateInterval,
ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Types=@Types,PrintingModel=@PrintingModel,Status=@Status,
TransubName=@TransubName,TransubId=@TransubId, 
StartDate= CONVERT(DATE,@StartDate,103),EndDate= CONVERT(DATE,@EndDate,103),
AgreementDate= CONVERT(DATE,@AgreementDate,103)
WHERE Id=@Id;
--Client,ContractType,ClientId,Property,PropertyId, 
 SELECT Id,RowId FROM WRBHBContractManagement WHERE Id=@Id;
 END
 
GO

 