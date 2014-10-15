SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_OutsourceKOTHdr_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[SP_OutsourceKOTHdr_Insert]
GO
/*=============================================
Author Name  : Anbu
Created Date : 01/08/2014 
Section  	 : Guest Service
Purpose  	 : New KOT Entry Header
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_OutsourceKOTHdr_Insert]
(@PropertyId BIGINT,
@PropertyName NVARCHAR(100),
@Date NVARCHAR(100),
@TotalAmount DECIMAL(27,2),
@Createdby  INT)

AS
BEGIN
DECLARE @Id INT;

-- CHECKIN PROPERTY INSERT
INSERT INTO WRBHBOutsourceKOTHdr(PropertyId,PropertyName,Date,CreatedBy,CreatedDate,
ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,TotalAmount)

VALUES(@PropertyId,@PropertyName,CONVERT(Date,@Date,103),@Createdby,GETDATE(),
@Createdby,GETDATE(),1,0,NEWID(),@TotalAmount)


SET @Id=@@IDENTITY;
SELECT Id,RowId FROM WRBHBOutsourceKOTHdr WHERE Id=@Id;
END
GO

