-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_Locality_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_Locality_Select]
GO 
-- =============================================
-- Create By : Sakthi
-- Create date : 7 Feb 2014
-- Description : Locality Select
-- Modifiedby        Modified Date
--
-- =============================================
CREATE PROCEDURE [dbo].[SP_Locality_Select](@StateId INT,@CityId BIGINT,
@Id BIGINT)
AS
BEGIN
 IF @StateId = 0 AND @CityId = 0 AND @Id = 0    
  BEGIN
   SELECT L.Locality,L.Id,L.CityId,C.CityName,C.StateId,S.StateName 
   FROM WRBHBLocality L
   LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 
   ORDER BY S.StateName ASC;
  END
 IF @StateId != 0 AND @CityId = 0 AND @Id = 0    
  BEGIN
   SELECT L.Locality,L.Id,L.CityId,C.CityName 
   FROM WRBHBLocality L
   LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND
   S.Id = @StateId ORDER BY S.StateName ASC;
  END
 IF @StateId != 0 AND @CityId != 0 AND @Id = 0    
  BEGIN
   SELECT L.Locality,L.Id FROM WRBHBLocality L
   LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND
   S.Id=@StateId AND C.Id=@CityId ORDER BY S.StateName ASC;
  END
 IF @Id != 0    
  BEGIN
   SELECT L.Locality,L.Id,L.CityId,C.CityName,C.StateId,S.StateName 
   FROM WRBHBLocality L
   LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND L.Id = @Id;
  END 
END
/* ELSE
  BEGIN
   IF @CityId = 0 AND @Id = 0 AND @StateId != 0
    BEGIN
     SELECT L.Locality,L.Id,L.CityId,C.CityName FROM WRBHBLocality L
     LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
     LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
     WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND S.Id=@StateId
     ORDER BY C.CityName ASC;
    END
   ELSE
    BEGIN
     IF @Id = 0 AND @CityId != 0 AND @StateId != 0
      BEGIN
       SELECT L.Locality,L.Id FROM WRBHBLocality L
       LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
       LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
       WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND 
       S.Id=@StateId AND L.CityId=@CityId
       ORDER BY L.Locality;
      END
     ELSE
      BEGIN
       SELECT L.Locality,L.Id FROM WRBHBLocality L
       LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK)ON C.Id=L.CityId
       LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
       WHERE C.IsActive=1 AND S.IsActive=1 AND L.IsActive=1 AND L.Id=@Id;
      END     
    END
  END
END*/

