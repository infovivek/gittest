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
@UsrId BIGINT,@CityCode NVARCHAR(100))
AS
BEGIN 
 IF EXISTS (SELECT NULL FROM WRBHBAPIHeader WHERE CityCode = @CityCode AND 
 IsActive=1 AND IsDeleted=0)
  BEGIN
   UPDATE WRBHBAPIHeader SET FromDt = @FromDt,ToDt = @ToDt,CityId = 0,
   ModifiedDate = GETDATE() WHERE CityCode = @CityCode AND 
   IsActive = 1 AND IsDeleted = 0;
   SELECT TOP 1 Id,CityCode,'New','Exists' FROM WRBHBAPIHeader 
   WHERE CityCode = @CityCode AND IsActive = 1 AND IsDeleted=0 ORDER BY Id DESC;
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIHeader(CityCode,FromDt,ToDt,CreatedBy,
   CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,CityId)
   VALUES(dbo.TRIM(@CityCode),@FromDt,@ToDt,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,
   NEWID(),0);
   SELECT Id,CityCode,'New' FROM WRBHBAPIHeader WHERE Id=@@IDENTITY;
  END
END
GO
