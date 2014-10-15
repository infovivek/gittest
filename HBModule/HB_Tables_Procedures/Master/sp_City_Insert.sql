SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_City_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_City_Insert]
GO
/*
 Modified By           Modifed Date     
 1.Sakthi              17 March 2014
*/
CREATE PROCEDURE [dbo].[Sp_City_Insert](@City NVARCHAR(100),@CityCode NVARCHAR(100),@StateId INT,
@UsrId BIGINT)
AS
BEGIN
DECLARE @ErrMsg NVARCHAR(MAX);
IF EXISTS(SELECT NULL FROM WRBHBCity WHERE UPPER(CityName)=UPPER(@City) AND 
StateId=@StateId AND IsActive=1)
 BEGIN
  SET @ErrMsg = 'City Already Exists'; 
  SELECT @ErrMsg; 
 END
ELSE
 BEGIN    
  INSERT INTO WRBHBCity(CityName,StateId,CreatedBy,CreatedDate,ModifiedBy,
  ModifiedDate,IsActive,IsDeleted,RowId,CityCode)  
  VALUES(@City,@StateId,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),UPPER(@CityCode));
  SELECT Id FROM WRBHBCity WHERE Id=@@IDENTITY; 
 END
END   
