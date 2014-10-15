SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ContractNonDedicatedApartment_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[SP_ContractNonDedicatedApartment_Insert]

Go
CREATE PROCEDURE [dbo].[SP_ContractNonDedicatedApartment_Insert](
@NonDedicatedContractId bigint,
@ApartmentType    nvarchar(100),
@ApartTarif       decimal(27,2),
@RoomTariff       decimal(27,2),
@DoubleTariff	  decimal(27,2),
@TripleTarif	  decimal(27,2),
@BedTariff		  decimal(27,2),
@Description	  nvarchar(100),
@ApartmentId	  Bigint,
@RoomId			  Bigint,
@BedId			  Bigint,
@Createdby		  Bigint,
@PropertyName     nvarchar(100),
@PropertyId       bigint,
@PropertyCategory nvarchar(100))

AS
BEGIN
DECLARE @Identity int
INSERT INTO WRBHBContractNonDedicatedApartment(NondedContractId,ApartMentType,RoomTarif,DoubleTarif,
BedTarif,ApartmentId,RoomId,BedId,CreatedBy,Createddate,Modifiedby,Modifieddate,IsActive,IsDeleted,Rowid,
Property,PropertyId,ApartTarif,PropertyCategory,TripleTarif,Description)
VALUES (@NonDedicatedContractId, @ApartmentType,@RoomTariff,@DoubleTariff,
@BedTariff,@ApartmentId,@RoomId,@BedId,@Createdby,GETDATE(),@Createdby,GETDATE(),1,0,NEWID(),
@PropertyName,@PropertyId,@ApartTarif,@PropertyCategory,@TripleTarif,@Description)

SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBContractNonDedicatedApartment WHERE Id=@Identity;
END