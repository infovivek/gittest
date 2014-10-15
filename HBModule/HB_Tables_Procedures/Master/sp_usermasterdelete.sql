SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_usermasterdelete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_usermasterdelete]
GO 
create procedure sp_usermasterdelete
(
@Id		bigint
)
as
begin

update WRBHBUser set IsActive=0,IsDeleted=1,ModifiedBy=1,ModifiedDate=GETDATE() where Id=@Id

update WRBHBUserRoles set IsActive=0,IsDeleted=1,ModifiedBy=1,ModifiedDate=GETDATE() where UserId=@Id


end