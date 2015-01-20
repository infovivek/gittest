SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Detail_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractClientPref_Detail_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PREFFERD DETAIL INSERT
Purpose  	: DETAIL INSERT
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
Vivek			26/07/2014		Vivek				Contact Phone and Name
********************************************************************************************************	
*******************************************************************************************************
*/

CREATE PROCEDURE Sp_ContractClientPref_Detail_Insert
(
@HeaderId		BIGINT,
@PropertyName		NVARCHAR(100),
@PropertyId		BIGINT,
@RoomType		NVARCHAR(100),
@RoomId			BIGINT,
@TariffSingle	DECIMAL(27, 2),
@TariffDouble	DECIMAL(27, 2),
@TariffTriple       DECIMAL(27, 2),
@LTariffSingle	DECIMAL(27, 2),
@LTariffDouble	DECIMAL(27, 2),
@LTariffTriple       DECIMAL(27, 2),
@Facility			Nvarchar(100),
@TaxInclusive	BIT,
@LTAgreed	DECIMAL(27, 2),
@LTRack	DECIMAL(27, 2),
@STAgreed	DECIMAL(27, 2),
@CreatedBy		BIGINT,
@ContactPhone 	NVARCHAR(100),
@ContactName 	NVARCHAR(100),
@Email		 	NVARCHAR(100)
)
AS
BEGIN
DECLARE @Identity int

UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1
		WHERE HeaderId=@HeaderId AND PropertyId=@PropertyId  

	INSERT INTO WRBHBContractClientPref_Details(HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
	TariffDouble,TariffTriple,RTariffSingle,RTariffDouble,RTariffTriple,Facility,TaxInclusive,TaxPercentage,
	LTAgreed,LTRack,STAgreed,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Email,ContactPhone,ContactName)
	VALUES (@HeaderId,@PropertyName,@PropertyId,@RoomType,@RoomId,@TariffSingle,@TariffDouble,
	@TariffTriple,@LTariffSingle,@LTariffDouble,@LTariffTriple,@Facility,@TaxInclusive,0,
	@LTAgreed,@LTRack,@STAgreed,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@Email,
	@ContactPhone,@ContactName)		
		
SET  @Identity=@@IDENTITY
SELECT Id,RowId FROM WRBHBContractClientPref_Details WHERE Id=@Identity;	
END


