SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIRoomTypeDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIRoomTypeDetails_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 19 2014
Section  	: API Room Type Details Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIRoomTypeDetails_Insert](
@HotelId BIGINT,
@HeaderId BIGINT,
@RoomTypeName NVARCHAR(100),
@RoomTypeCode NVARCHAR(100))
AS
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBAPIRoomTypeDtls WHERE HeaderId = @HeaderId AND
 HotelId = @HotelId AND RoomTypecode = @RoomTypeCode)
  BEGIN
   UPDATE WRBHBAPIRoomTypeDtls SET RoomTypename = @RoomTypeName,
   Dt = GETDATE()
   WHERE HeaderId = @HeaderId AND HotelId = @HotelId AND 
   RoomTypecode = @RoomTypeCode;
   SELECT Id FROM WRBHBAPIRoomTypeDtls WHERE HeaderId = @HeaderId AND
   HotelId = @HotelId AND RoomTypecode = @RoomTypeCode;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIRoomTypeDtls(HeaderId,HotelId,RoomTypeName,RoomTypeCode,Dt)
   VALUES(@HeaderId,@HotelId,dbo.TRIM(@RoomTypeName),dbo.TRIM(@RoomTypeCode),
   GETDATE());
   SELECT Id FROM WRBHBAPIRoomTypeDtls WHERE Id=@@IDENTITY;
  END
END
GO
