SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CheckInDtls_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_CheckInDtls_Help]
GO 
-- ===============================================================================
-- Author: Shameem
-- Create date:25-04-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	Check In
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_CheckInDtls_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL,
@Id INT=NULL)

AS
BEGIN
IF @Action = 'Room'
 BEGIN
    SELECT  PR.RoomNo,PR.RoomType,PR.PropertyId,PR.Id FROM WRBHBPropertyRooms PR
			JOIN WRBHBPropertyApartment PA ON PR.PropertyId=PA.PropertyId AND PA.IsActive=1 AND PA.IsDeleted=0
			JOIN WRBHBPropertyBlocks PB ON PA.PropertyId=PB.PropertyId AND PB.IsActive=1 AND PB.IsDeleted=0
			JOIN WRBHBProperty P ON PB.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
			JOIN  WRBHBBookingProperty BP ON P.Id=BP.PropertyId AND BP.IsActive=1 AND BP.IsDeleted=0
			WHERE BP.BookingId=@Id AND PR.IsActive=1 AND PR.IsDeleted=0  
 END
END
