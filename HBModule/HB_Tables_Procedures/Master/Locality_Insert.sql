-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Locality_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Locality_Insert]
GO 
-- ===============================================================================
-- Author : Sakthi
-- Create date : 06-Feb-2014
-- ModifiedBy :
-- Modified Date :    
-- Description:	Locality Insert
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Locality_Insert](@CityId BIGINT, 
@Locality NVARCHAR(100), @UserId BIGINT)
AS
BEGIN
 IF EXISTS(SELECT Id FROM WRBHBLocality WHERE IsActive=1 AND 
 CityId=@CityId AND LOWER(Locality)=LOWER(@Locality))
  BEGIN
   SELECT 'Locality Already Exists.' AS Msg;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBLocality(CityId,Locality,CreatedBy,CreatedDate,
   ModifiedBy,ModifiedDate,IsActive,RowId,IsDeleted)
   VALUES(@CityId,@Locality,@UserId,GETDATE(),@UserId,GETDATE(),1,
   NEWID(),0);					
   SELECT Id,RowId FROM WRBHBLocality WHERE Id=@@IDENTITY;
  END
END
GO