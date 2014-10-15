SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ScreenMaster_delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ScreenMaster_delete]
GO 

CREATE PROCEDURE sp_ScreenMaster_delete
(
@Id INT,
@UserId int
)
AS
BEGIN
UPDATE WRBHBScreenMaster SET IsActive=1,IsDeleted=1,ModifiedBy=@UserId,
ModifiedDate=GETDATE() WHERE Id=@Id;    
END
