SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_City_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_City_Update]
GO
/*
 Modified By           Modifed Date     
 1.Sakthi              17 March 2014
*/
CREATE PROCEDURE [dbo].[Sp_City_Update](@City NVARCHAR(100),@CityCode NVARCHAR(100),@StateId INT,
@UsrId BIGINT,@Id BIGINT)
AS  
BEGIN
DECLARE @ErrMsg NVARCHAR(MAX);
IF EXISTS(SELECT NULL FROM WRBHBCity WHERE UPPER(CityName)=UPPER(@City) AND 
StateId=@StateId AND Id  NOT IN (@Id) AND IsActive=1)  
 BEGIN 
  SET @ErrMsg = 'City Already Exists'; 
  SELECT @ErrMsg; 
 END
ELSE
 BEGIN
  UPDATE WRBHBCity SET CityName=@City,CityCode=UPPER(@CityCode) WHERE Id=@Id;
  SELECT Id FROM WRBHBCity WHERE Id=@Id;
 END  
END
  
 