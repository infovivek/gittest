SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_CheckOut_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_CheckOut_Delete]
GO 
-- ===============================================================================
-- Author	   :	shameem
-- Create date :	08/05/14
-- ModifiedBy  :    , ModifiedDate  : 
-- Description :	checkout delete for Guest Service
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_CheckOut_Delete](@Str NVARCHAR(100),@Id INT)
AS
BEGIN
-- Delete Checkout Details
   DELETE FROM WRBHBChechkOutHdr WHERE Id=@Id;
   
   END