SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ScreenMaster_select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ScreenMaster_select]
GO 
create procedure sp_ScreenMaster_select
(
@Id int
)
as
begin

if @Id!=0
begin
select ScreenName,OrderNumber AS OrderId,ModuleName,SWF,CreatedDate,CountId,Id
from WRBHBScreenMaster where IsActive=0 and IsDeleted=0 and Id=@Id

--select ModuleName from WRBHBScreenMaster
end

else
begin
select ScreenName,ModuleName,SWF,Id from WRBHBScreenMaster where IsActive=0 and IsDeleted=0
end
end
