SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_KOTEntry_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_KOTEntry_Delete]
Go
-- =============================================
-- Author:		shameem
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE[dbo].[Sp_KOTEntry_Delete](@Id INT,@UserId INT)
AS
BEGIN
UPDATE WRBHBKOTHdr SET IsDeleted=1,IsActive=0,
ModifiedBy=@UserId,ModifiedDate=GETDATE() WHERE Id=@Id;
UPDATE WRBHBKOTDtls SET IsDeleted=1,IsActive=0,
ModifiedBy=@UserId,ModifiedDate=GETDATE() WHERE KOTEntryHdrId=@Id;	
UPDATE WRBHBKOTUser SET IsDeleted=1,IsActive=0,
ModifiedBy=@UserId,ModifiedDate=GETDATE() WHERE KOTEntryHdrId=@Id;	
END