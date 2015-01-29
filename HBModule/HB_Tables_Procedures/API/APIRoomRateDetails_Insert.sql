SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIRoomRateDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIRoomRateDetails_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 20 2014
Section  	: API Room Rate Details Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIRoomRateDetails_Insert](
@HeaderId BIGINT,
@HotelId BIGINT,
@RoomRateroomTypeCode NVARCHAR(100),
@RoomRateratePlanCode NVARCHAR(100),
@RoomRateavailableCount NVARCHAR(100),
@RoomRateavailStatus NVARCHAR(100),
@PenaltyDescription NVARCHAR(MAX))
AS
BEGIN
 /*DECLARE @TMP NVARCHAR(MAX) = '',@TMP1 NVARCHAR(MAX) = '';
 DECLARE @TMP2 NVARCHAR(MAX) = '',@TMP3 NVARCHAR(MAX) = '';
 DECLARE @TMP4 NVARCHAR(MAX) = '';
 SET @TMP = dbo.TRIM(REPLACE(@PenaltyDescription,'MakeMyTrip','StaySimplyfied'));
 SET @TMP1 = dbo.TRIM(REPLACE(@TMP,'Make My Trip','StaySimplyfied'));
 DECLARE @SubStng NVARCHAR(10) = SUBSTRING(@TMP1,LEN(@TMP1)-1,LEN(@TMP1));
 IF @SubStng != '.'
  BEGIN
   SET @TMP2 = @TMP1+'.';
  END
 SET @TMP3 = dbo.TRIM('<ul><li>'+REPLACE(@TMP2,'.','.</li><li>'));
 DECLARE @SubStng1 NVARCHAR(10) = SUBSTRING(@TMP3,LEN(@TMP3)-3,LEN(@TMP3));
 IF @SubStng1 = '<li>'
  BEGIN
   SET @TMP4 = SUBSTRING(@TMP3,0,LEN(@TMP3)-4)+'</ul>';
  END*/
 DECLARE @TMP NVARCHAR(MAX) = '',@TMP1 NVARCHAR(MAX) = '';
 DECLARE @TMP2 NVARCHAR(MAX) = '';
 SET @TMP = dbo.TRIM(REPLACE(@PenaltyDescription,'MakeMyTrip','StaySimplyfied'));
 SET @TMP1 = dbo.TRIM(REPLACE(@TMP,'Make My Trip','StaySimplyfied')); 
 SET @TMP2 = dbo.TRIM('<ul><li>'+@TMP1+'</li></ul>');
 IF EXISTS (SELECT NULL FROM WRBHBAPIRoomRateDtls WHERE HeaderId = @HeaderId AND
 HotelId = @HotelId AND RoomRateratePlanCode = @RoomRateratePlanCode AND
 RoomRateroomTypeCode = @RoomRateroomTypeCode)
  BEGIN
   UPDATE WRBHBAPIRoomRateDtls SET 
   RoomRateavailableCount = @RoomRateavailableCount,
   RoomRateavailStatus = @RoomRateavailStatus,
   PenaltyDescription = @TMP2,Dt = GETDATE()
   WHERE HeaderId = @HeaderId AND HotelId = @HotelId AND 
   RoomRateratePlanCode = @RoomRateratePlanCode AND
   RoomRateroomTypeCode = @RoomRateroomTypeCode;
   SELECT Id FROM WRBHBAPIRoomRateDtls
   WHERE HeaderId = @HeaderId AND HotelId = @HotelId AND 
   RoomRateratePlanCode = @RoomRateratePlanCode AND
   RoomRateroomTypeCode = @RoomRateroomTypeCode;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIRoomRateDtls(HotelId,HeaderId,
   RoomRateroomTypeCode,RoomRateratePlanCode,
   RoomRateavailableCount,RoomRateavailStatus,PenaltyDescription,Dt)
   VALUES(@HotelId,@HeaderId,dbo.TRIM(@RoomRateroomTypeCode),
   dbo.TRIM(@RoomRateratePlanCode),dbo.TRIM(@RoomRateavailableCount),
   dbo.TRIM(@RoomRateavailStatus),dbo.TRIM(@TMP2),GETDATE());
   SELECT Id FROM WRBHBAPIRoomRateDtls WHERE Id=@@IDENTITY;
  END
END
GO
