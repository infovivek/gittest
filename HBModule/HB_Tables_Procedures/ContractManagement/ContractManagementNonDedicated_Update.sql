SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ContractNonDedicated_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[SP_ContractNonDedicated_Update]

Go
CREATE PROCEDURE [dbo].[SP_ContractNonDedicated_Update]
(
@StartDate    nvarchar(100),
@EndDate      nvarchar(100),
@ContractType nvarchar(100),
@ContractName nvarchar(100),
@Property nvarchar(100),
@Client  nvarchar(100),
@ClientId Int,
@PropertyId Int,
@Id        int,
@Createdby int,
@TransName Nvarchar(100),
@TransId bigint
,@Types nvarchar(100)
,@PricingModel nvarchar(100))

AS
BEGIN
UPDATE WRBHBContractNonDedicated SET  StartDate= CONVERT(DATE,@StartDate,103),EndDate= CONVERT(DATE,@EndDate,103),
--ContractType=@ContractType,
ContractName=@ContractName,--Client=@Client,ClientId=@ClientId,
--Property=@Property,PropertyId=@PropertyId,
Types=@Types,PricingModel=@PricingModel,
modifiedby=@createdby,modifieddate=GETDATE() ,TransName=@TransName ,TransId= @TransId
where Id=@Id and IsActive=1 and IsDeleted=0 ;

select Id,RowId From WRBHBContractNonDedicated 
where Id=@Id;
End
GO


