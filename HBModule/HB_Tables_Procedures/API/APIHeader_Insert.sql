SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIHeader_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIHeader_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 19 2014
Section  	: API Header Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIHeader_Insert](
@FromDt NVARCHAR(100),@ToDt NVARCHAR(100),
@UsrId BIGINT,@CityId BIGINT) 
AS
BEGIN 
 DECLARE @CityCode NVARCHAR(100) = '';
 SET @CityCode = (SELECT ISNULL(CityCode,'') FROM WRBHBCity WHERE Id=@CityId);
 INSERT INTO WRBHBAPIHeader(CityCode,FromDt,ToDt,CreatedBy,CreatedDate,
 ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,CityId)
 VALUES(dbo.TRIM(@CityCode),@FromDt,@ToDt,@UsrId,GETDATE(),@UsrId,GETDATE(),
 1,0,NEWID(),@CityId);
 --
 --DECLARE @SDF NVARCHAR(1000) = '';
 --SET @SDF ='"<StayDateRange start=\"'+@FromDt+'\" end=\"'+@ToDt+'\"/>"';
 --
 SELECT Id,CityCode,'New' FROM WRBHBAPIHeader WHERE Id=@@IDENTITY;
 /*IF EXISTS (SELECT NULL FROM WRBHBAPIHeader WHERE CityId=@CityId AND
 CityCode=@CityCode AND IsActive=1 AND IsDeleted=0)-- AND
 --CONVERT(DATE,CreatedDate,103)=CONVERT(DATE,GETDATE(),103))
  BEGIN
   SELECT TOP 1 Id,CityCode,'Exists' FROM WRBHBAPIHeader 
   WHERE CityId=@CityId AND CityCode=@CityCode AND IsActive=1 AND 
   IsDeleted=0 ORDER BY Id DESC; --AND
   --CONVERT(DATE,CreatedDate,103)=CONVERT(DATE,GETDATE(),103);
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIHeader(CityCode,FromDt,ToDt,CreatedBy,
   CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,CityId)
   VALUES(dbo.TRIM(@CityCode),@FromDt,@ToDt,@UsrId,GETDATE(),
   @UsrId,GETDATE(),1,0,NEWID(),@CityId);
   SELECT Id,CityCode,'New' FROM WRBHBAPIHeader WHERE Id=@@IDENTITY;
  END*/
 /*SET @CityCode = (SELECT ISNULL(CityCode,'') FROM WRBHBAPICityCode 
 WHERE Id=@CityId);
 IF EXISTS (SELECT NULL FROM WRBHBAPIHeader WHERE CityId=@CityId AND
 CityCode=@CityCode AND IsActive=1 AND IsDeleted=0)
  BEGIN
   SELECT Id,CityCode,'Exists' FROM WRBHBAPIHeader WHERE CityId=@CityId AND
   CityCode=@CityCode AND IsActive=1 AND IsDeleted=0;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIHeader(CityCode,FromDt,ToDt,CreatedBy,
   CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,CityId)
   VALUES(dbo.TRIM(@CityCode),@FromDt,@ToDt,@UsrId,GETDATE(),
   @UsrId,GETDATE(),1,0,NEWID(),@CityId);
   SELECT Id,CityCode,'New' FROM WRBHBAPIHeader WHERE Id=@@IDENTITY;
  END*/
END
GO
