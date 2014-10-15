SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ScreenMaster_insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ScreenMaster_insert]
GO 
create procedure sp_ScreenMaster_insert
(
@ScreenName     NVARCHAR(100),
@OrderNumber    INT,
@ModuleName     NVARCHAR(100),
@ModuleId		INT,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--@SubModuleName  NVARCHAR(100),
@SWF            NVARCHAR(100),
--@CountId        INT,
@UserID         INT
)
AS
BEGIN
DECLARE @Identity INT,@ErrMsg VARCHAR(8000);
--IF EXISTS (SELECT NULL FROM WRBHBModuleNames WITH (NOLOCK) 
--WHERE UPPER(ModuleName) = UPPER(@ModuleName)  AND IsDeleted = 0 AND IsActive = 1)

--INSERT INTO WRBHBModuleNames(ModuleName,CreatedBy,CreatredDate,IsActive,IsDeleted)
--VALUES (@ModuleName,@UserID,GETDATE(),1,0)

IF @ScreenName = ''
BEGIN
INSERT INTO WRBHBScreenMaster (ScreenName,OrderNumber,ModuleName,/*SubModuleName*/ModuleId,SubModuleId,SWF,CountId,
IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId) 
VALUES(@ModuleName,@OrderNumber,@ModuleName,/*@SubModuleName*/@ModuleId,1 ,@SWF,1,
0,0,@UserID,GETDATE(),@UserId,GETDATE(),NEWID())


END
ELSE
BEGIN
INSERT INTO WRBHBScreenMaster (ScreenName,OrderNumber,ModuleName,/*SubModuleName*/ModuleId,SubModuleId,SWF,CountId,
IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId) 
VALUES(@ScreenName,@OrderNumber,@ModuleName,/*@SubModuleName*/@ModuleId,1 ,@SWF,1,
0,0,@UserID,GETDATE(),@UserId,GETDATE(),NEWID())


END
SET @Identity=@@IDENTITY;
SELECT Id,Rowid FROM WRBHBScreenMaster WHERE Id=@Identity;
END
