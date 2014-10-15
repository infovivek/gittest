-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Locality_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Locality_Update]
GO 
-- ===============================================================================
-- Author : Sakthi
-- Create date : 06-Feb-2014
-- ModifiedBy :
-- Modified Date :    
-- Description:	Locality Update
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_Locality_Update](@CityId BIGINT, 
@Locality NVARCHAR(100), @UserId BIGINT, @Id BIGINT)
AS
BEGIN
 IF EXISTS(SELECT NULL FROM WRBHBLocality 
 WHERE Id NOT IN (@Id) AND LOWER(Locality)=LOWER(@Locality) AND IsActive=1)
  BEGIN
   SELECT 'Locality Already Exists.';
  END
 ELSE
  BEGIN
   UPDATE WRBHBLocality SET Locality=@Locality,ModifiedBy=@UserId,
   ModifiedDate=GETDATE() WHERE Id=@Id;
   SELECT Id,RowId FROM WRBHBLocality WHERE Id=@Id;
  END
END
GO