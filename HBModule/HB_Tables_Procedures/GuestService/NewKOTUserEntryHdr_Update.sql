/****** Object:  StoredProcedure [dbo].[SP_NewKOTEntryHdr_Update]    Script Date: 07/30/2014 17:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTUserEntryHdr_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewKOTUserEntryHdr_Update]

Go
/*=============================================
Author Name  : Anbu
Created Date : 30/07/14 
Section  	 : Guest Service
Purpose  	 : KOT Entry  (Header)
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_NewKOTUserEntryHdr_Update](
@PropertyId BIGINT,
@PropertyName NVARCHAR(100),
@Date NVARCHAR(100),
@UserName NVARCHAR(100),
@UserId BIGINT,
@GetType NVARCHAR(100),
@TotalAmount DECIMAL(27,2),
@CreatedBy BIGINT,@Id INT)

AS
BEGIN
	UPDATE WRBHBNewKOTUserEntryHdr SET PropertyName=@PropertyName,Date=@Date,
	PropertyId=@PropertyId,UserName=@UserName,UserId=@UserId,GetType=@GetType,TotalAmount=@TotalAmount,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id;
SELECT Id,RowId FROM WRBHBNewKOTUserEntryHdr WHERE Id=@Id;
END
GO