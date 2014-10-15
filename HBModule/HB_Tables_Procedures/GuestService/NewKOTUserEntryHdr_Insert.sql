/****** Object:  StoredProcedure [dbo].[SP_NewKOTEntryHdr_Insert]    Script Date: 07/30/2014 17:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTUserEntryHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewKOTUserEntryHdr_Insert]

Go
/*=============================================
Author Name  : Anbu
Created Date : 30/07/2014 
Section  	 : Guest Service
Purpose  	 : New KOT Entry Header
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_NewKOTUserEntryHdr_Insert](@PropertyId BIGINT,
@PropertyName NVARCHAR(100),
@Date NVARCHAR(100),
@UserName NVARCHAR(100),
@UserId BIGINT,
@GetType NVARCHAR(100),
@TotalAmount DECIMAL(27,2),
@CreatedBy BIGINT)

AS
BEGIN
DECLARE @Id INT;

-- CHECKIN PROPERTY INSERT
INSERT INTO WRBHBNewKOTUserEntryHdr(PropertyId,PropertyName,Date,UserName,UserId,GetType,TotalAmount,CreatedBy,
CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)

VALUES(@PropertyId,@PropertyName,CONVERT(Date,@Date,103),@UserName,@UserId,@GetType,@TotalAmount,
@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())


SET @Id=@@IDENTITY;
SELECT Id,RowId FROM WRBHBNewKOTUserEntryHdr WHERE Id=@Id;
END
GO