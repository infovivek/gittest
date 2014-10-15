SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ContractNonDedicated_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[SP_ContractNonDedicated_Insert]

Go
CREATE PROCEDURE [dbo].[SP_ContractNonDedicated_Insert](
@StartDate    nvarchar(100),
@EndDate     nvarchar(100),
@ContractType nvarchar(100),
@ContractName nvarchar(100),
@Property nvarchar(100),
@Client  nvarchar(100),
@ClientId Bigint,
@PropertyId Bigint,
@Createdby Bigint,
@TransName Nvarchar(100),
@TransId bigint
,@Types nvarchar(100)
,@PricingModel nvarchar(100))

AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);
IF EXISTS (SELECT NULL FROM WRBHBContractNonDedicated WITH (NOLOCK) 
WHERE UPPER(ContractName) = UPPER(@ContractName)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
               
  SET @ErrMsg = 'ContractName Already Exists';
        
  SELECT @ErrMsg;
             
 END
 ELSE
 BEGIN
 
INSERT INTO WRBHBContractNonDedicated(StartDate,EndDate,ContractType,ContractName,Property,
Client,ClientId,PropertyId,CreatedBy,CreatedDate,Modifiedby,Modifieddate,IsActive,IsDeleted,Rowid,
TransName,TransId,PricingModel,Types)
VALUES (CONVERT(DATE,@StartDate,103),CONVERT(DATE,@EndDate,103),@ContractType,@ContractName,@Property,
@Client,@ClientId,@PropertyId,@Createdby,GETDATE(),@Createdby,GETDATE(),1,0,NEWID(),
@TransName,@TransId,@PricingModel,@Types)

SET  @Identity=@@IDENTITY
SELECT Id,RowId FROM WRBHBContractNonDedicated WHERE Id=@Identity;
END
END
 