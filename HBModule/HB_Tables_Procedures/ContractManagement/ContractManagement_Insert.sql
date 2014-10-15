 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractManagement_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractManagement_Insert]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
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
CREATE PROCEDURE [dbo].[Sp_ContractManagement_Insert] 
	(@ContractType nvarchar(100),   @ContractName  nvarchar(100),
   	@ClientName nvarchar(100),
	 @Property  nvarchar(100),      @BookingLevel  nvarchar(100),
	 @StartDate  nvarchar(100),     @EndDate  nvarchar(100),
	 @ExtenstionDate  nvarchar(100),@ContractPriceMode  nvarchar(100),
	 @RateInterval  nvarchar(100),  @SalesExecutive  nvarchar(100),
	 @AgreementDate  nvarchar(100), @CreatedBy BIGINT,
	 @PropertyId BIGINT,@ClientId BIGINT,@SalesExecutiveId bigint,
	 @Types nvarchar(100),@PrintingModel nvarchar(100),@Status nvarchar(100),
	 @TransubName nvarchar(100),@TransubId BIGINT) 
AS
BEGIN 
 IF EXISTS (SELECT NULL FROM  WRBHBContractManagement WHERE UPPER(ContractName)=UPPER(@ContractName)
   and IsDeleted=0 and IsActive=1)
 BEGIN
			SELECT 'Contract Name Already Exists';
 END
 ELSE
 BEGIN
 
 INSERT INTO WRBHBContractManagement(Client,ContractType,ContractName,Property,BookingLevel,StartDate,
           EndDate,ExtenstionDate,ContractPriceMode, RateInterval,SalesExecutive,AgreementDate,
            CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,PropertyId,ClientId,
            SalesExecutiveId,Types,PrintingModel,Status,TransubName,TransubId)
 VALUES(@ClientName, @ContractType,@ContractName,@Property,@BookingLevel,CONVERT(DATE,@StartDate,103),
           CONVERT(DATE,@EndDate,103),CONVERT(DATE,@ExtenstionDate,103),@ContractPriceMode,@RateInterval,
           @SalesExecutive,CONVERT(DATE,@AgreementDate,103),
           @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@PropertyId,@ClientId,
           @SalesExecutiveId,@Types,@PrintingModel,@Status,@TransubName,@TransubId)
 SELECT Id,RowId FROM WRBHBContractManagement WHERE Id=@@IDENTITY
 END
END
GO

 