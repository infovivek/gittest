SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_City_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[sp_City_Select]
GO
/*
 Modified By           Modifed Date     
 1.Sakthi              17 March 2014
*/
CREATE PROCEDURE [dbo].[sp_City_Select](@StateId INT,@Id BIGINT)
AS  
BEGIN
 IF @StateId = 0 AND @Id = 0    
  BEGIN
   SELECT C.CityName,C.Id,S.StateName,C.StateId FROM dbo.WRBHBCity C
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 ORDER BY S.StateName ASC;
  END
 IF @StateId != 0 AND @Id = 0    
  BEGIN
   SELECT C.CityName,C.Id,S.StateName,C.StateId FROM dbo.WRBHBCity C
   LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
   WHERE C.IsActive=1 AND S.IsActive=1 AND S.Id=@StateId 
   ORDER BY C.CityName ASC;
  END
 IF @Id != 0    
  BEGIN
   SELECT C.CityName,C.Id,S.StateName,C.StateId,C.CityCode FROM dbo.WRBHBCity C
     LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
     WHERE C.IsActive=1 AND S.IsActive=1 AND C.Id=@Id;
  END
END
/*ELSE
  BEGIN
   IF @Id=0
    BEGIN
     SELECT C.CityName,C.Id,S.StateName,C.StateId FROM dbo.WRBHBCity C
     LEFT OUTER JOIN dbo.WRBHBState S WITH(NOLOCK)ON C.StateId=S.Id
     WHERE C.IsActive=1 AND C.StateId=@StateId AND S.IsActive=1 
     ORDER BY C.Id DESC;
    END
   ELSE
    BEGIN
     
    END   
  END
 END
IF @Id =0
Begin  
 IF @StateId !=0
	BEGIN
		 SELECT C.CityName,C.Id,S.StateName 
		 FROM dbo.WRBHBCity C
		 LEFT OUTER JOIN dbo.WRBHBState S ON C.StateId=S.Id
		 WHERE  C.IsActive=1 AND StateId=@StateId
		 ORDER BY Id DESC
	 END 
  ELSE
	 BEGIN
		 SELECT C.CityName,C.Id ,S.StateName
		 FROM dbo.WRBHBCity C
		 LEFT OUTER JOIN dbo.WRBHBState S ON C.StateId=S.Id
		 WHERE  C.IsActive=1  
		 ORDER BY Id DESC
	 END
 END*/  
 