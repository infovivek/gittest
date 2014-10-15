SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Detail_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractClientPref_Detail_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PREFFERD DETAIL UPDATE
Purpose  	: DETAIL UPDATE
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

CREATE PROCEDURE Sp_ContractClientPref_Detail_Update
(
@HeaderId			BIGINT,
@PropertyName       Nvarchar(100),
@PropertyId			BigInt,
@RoomType			NVARCHAR(100),
@RoomId				BIGINT,
@TariffSingle		DECIMAL(27, 2),
@TariffDouble		DECIMAL(27, 2),
@TariffTriple       DECIMAL(27, 2),
@Facility			Nvarchar(100),
@TaxInclusive		BIT,
@TaxPercentage		DECIMAL(27, 2),
@CreatedBy			BIGINT,
@Id					BIGINT,
@ContactPhone 	NVARCHAR(100),
@ContactName 	NVARCHAR(100),
@Email				NVARCHAR(100)
)
AS
BEGIN
UPDATE WRBHBContractClientPref_Details SET HeaderId=@HeaderId,PropertyName=@PropertyName,PropertyId=@PropertyId,RoomType=@RoomType,RoomId=@RoomId,TariffSingle=@TariffSingle,
		TariffDouble=@TariffDouble,TariffTriple=@TariffTriple,Facility=@Facility,TaxInclusive=@TaxInclusive,TaxPercentage=@TaxPercentage,
			ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Email=@Email,ContactPhone=@ContactPhone,ContactName=@ContactName where Id=@Id;
			
	select Id,RowId From WRBHBContractClientPref_Details
	where Id=@Id;
END