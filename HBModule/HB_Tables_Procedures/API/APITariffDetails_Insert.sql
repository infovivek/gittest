SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APITariffDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APITariffDetails_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 20 2014
Section  	: API Tariff Details Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APITariffDetails_Insert](
@HeaderId BIGINT,
@HotelId BIGINT,
@RoomRateHdrId BIGINT,
@RoomTariffroomNumber NVARCHAR(100),
@Tarifftype NVARCHAR(100),
@Tariffgroup NVARCHAR(100),
@Tariffamount DECIMAL(27,2))
AS
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBAPITariffDtls WHERE HeaderId = @HeaderId AND
 HotelId = @HotelId AND RoomRateHdrId = @RoomRateHdrId AND 
 RoomTariffroomNumber = @RoomTariffroomNumber AND Tariffgroup = @Tariffgroup)
  BEGIN
   UPDATE WRBHBAPITariffDtls SET Tariffamount = @Tariffamount
   WHERE HeaderId = @HeaderId AND HotelId = @HotelId AND 
   RoomRateHdrId = @RoomRateHdrId AND 
   RoomTariffroomNumber = @RoomTariffroomNumber AND Tariffgroup = @Tariffgroup;
   SELECT Id FROM WRBHBAPITariffDtls
   WHERE HeaderId = @HeaderId AND HotelId = @HotelId AND 
   RoomRateHdrId = @RoomRateHdrId AND 
   RoomTariffroomNumber = @RoomTariffroomNumber AND Tariffgroup = @Tariffgroup;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPITariffDtls(HeaderId,HotelId,RoomRateHdrId,
   Tarifftype,Tariffgroup,Tariffamount,RoomTariffroomNumber)
   VALUES(@HeaderId,@HotelId,@RoomRateHdrId,dbo.TRIM(@Tarifftype),
   dbo.TRIM(@Tariffgroup),@Tariffamount,dbo.TRIM(@RoomTariffroomNumber));
   SELECT Id FROM WRBHBAPITariffDtls WHERE Id=@@IDENTITY;
  END
END
GO
