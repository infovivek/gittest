--================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ScreenMaster_update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ScreenMaster_update]
GO 
create procedure [dbo].[sp_ScreenMaster_update]
(
@Id				int,
@ScreenName     NVARCHAR(100),
@OrderNumber    INT,
@ModuleName     NVARCHAR(100),
@ModuleId		INT,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
--@SubModuleName  NVARCHAR(100),
@SWF            NVARCHAR(100),
--@CountId        INT,
@UserID         INT
)
as 
begin

update WRBHBScreenMaster set ScreenName=@ScreenName,ModuleName=@ModuleName,ModuleId=@ModuleId,/*SubModuleName=@SubModuleName,*/SWF=@SWF,
ModifiedBy=1,ModifiedDate=getdate() 
where Id=@Id and IsActive=0 and IsDeleted=0;

SELECT Id,RowId FROM WRBHBScreenMaster WHERE Id=@Id

end