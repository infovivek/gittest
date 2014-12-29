SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIHotelHeader_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIHotelHeader_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 19 2014
Section  	: API Hotel Header Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIHotelHeader_Insert](
@HeaderId BIGINT,@HotelId BIGINT,@StarRating INT,@HotelCount INT) 
AS
BEGIN
 IF EXISTS (SELECT NULL FROM WRBHBAPIHotelHeader WHERE HotelId = @HotelId AND
 HeaderId = @HeaderId)
  BEGIN
   UPDATE WRBHBAPIHotelHeader SET StarRating = @StarRating
   WHERE HotelId = @HotelId AND HeaderId = @HeaderId;
   SELECT Id FROM WRBHBAPIHotelHeader
   WHERE HotelId = @HotelId AND HeaderId = @HeaderId
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIHotelHeader(HeaderId,HotelId,StarRating,HotelCount)
   VALUES(@HeaderId,@HotelId,@StarRating,@HotelCount);
   SELECT Id FROM WRBHBAPIHotelHeader WHERE Id=@@IDENTITY;
  END
END
GO
