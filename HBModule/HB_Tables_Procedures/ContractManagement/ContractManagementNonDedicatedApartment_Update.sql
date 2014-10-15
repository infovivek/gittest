SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ContractNonDedicatedApartment_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE [dbo].[SP_ContractNonDedicatedApartment_Update]

Go
CREATE PROCEDURE [dbo].[SP_ContractNonDedicatedApartment_Update]
(
@NonDedicatedContractId bigint,
@ApartmentType    nvarchar(100),
@ApartTarif       decimal(27,2),
@RoomTariff       decimal(27,2),
@DoubleTariff     decimal(27,2),
@TripleTarif	  decimal(27,2),
@BedTariff        decimal(27,2),
@Description	  nvarchar(100),
@Id               bigint,
@ApartmentId	  Bigint,
@RoomId			  Bigint,
@BedId			  Bigint,
@Createdby		  Bigint,
@PropertyName     nvarchar(100),
@PropertyId       bigint,
@PropertyCategory nvarchar(100))


AS
BEGIN
DECLARE @Identity int;
IF EXISTS (SELECT NULL FROM  WRBHBContractNonDedicatedApartment 
 WHERE RoomTarif=@RoomTariff and DoubleTarif=@DoubleTariff and 
       BedTarif=@BedTariff and ApartTarif=@ApartTarif
        and Id=@Id)
 BEGIN 
		UPDATE WRBHBContractNonDedicatedApartment SET ApartMentType=@ApartmentType,
		RoomTarif=@RoomTariff,DoubleTarif=@DoubleTariff,BedTarif=@BedTariff,
		Property=@PropertyName,PropertyId=@PropertyId,ApartTarif=@ApartTarif,
		modifiedby=@createdby,modifieddate=GETDATE(),PropertyCategory=@PropertyCategory,
		TripleTarif=@TripleTarif,Description=@Description
		where Id=@Id and IsActive=1 and IsDeleted=0 ;

		select Id,RowId From WRBHBContractNonDedicatedApartment 
		where Id=@Id;

end
else
begin

	UPDATE   WRBHBContractNonDedicatedApartment SET  
		IsActive=0,
		ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
		WHERE Id=@Id AND IsDeleted=0 ;

INSERT INTO WRBHBContractNonDedicatedApartment(NondedContractId,ApartMentType,RoomTarif,DoubleTarif,
BedTarif,ApartmentId,RoomId,BedId,CreatedBy,Createddate,Modifiedby,Modifieddate,IsActive,IsDeleted,Rowid,
Property,PropertyId,ApartTarif,PropertyCategory,TripleTarif,Description)
VALUES (@NonDedicatedContractId, @ApartmentType,@RoomTariff,@DoubleTariff,
@BedTariff,@ApartmentId,@RoomId,@BedId,@Createdby,GETDATE(),@Createdby,GETDATE(),1,0,NEWID(),
@PropertyName,@PropertyId,@ApartTarif,@PropertyCategory,@TripleTarif,@Description)

SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBContractNonDedicatedApartment WHERE Id=@Identity;
end
END
  
