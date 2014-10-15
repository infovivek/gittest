SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TransSubsPriceModel_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TransSubsPriceModel_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TRANSSUBSPRICEMODEL INSERT
Purpose  	: PRICE MODEL INSERT
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/
CREATE PROCEDURE Sp_TransSubsPriceModel_Insert
(
@Types			NVARCHAR(50),
@Name			NVARCHAR(100),
@Amount			DECIMAL(27, 2),
@AllowedBookings	BIGINT,
@UserId			BIGINT,
@EscalationTenure	NVARCHAR(100),
@EscalationPercentage DECIMAL(27, 2)	
)
AS
BEGIN
DECLARE @Identity int,@ErrMsg NVARCHAR(MAX);

IF EXISTS (SELECT NULL FROM WRBHBTransSubsPriceModel WITH (NOLOCK) 
WHERE UPPER(Name) = UPPER(@Name)  AND IsDeleted = 0 AND IsActive = 1)

BEGIN
           
  SET @ErrMsg = 'Name Already Exists';
    SELECT @ErrMsg;
END
ELSE
BEGIN
INSERT INTO WRBHBTransSubsPriceModel (Types,Name,Amount,AllowedBookings,CreatedBy,CreatedDate,ModifiedBy,
			ModifiedDate,IsActive,IsDeleted,RowId,EscalationTenure,EscalationPercentage)
VALUES (@Types,@Name,@Amount,@AllowedBookings,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID(),@EscalationTenure,
			@EscalationPercentage)

SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBTransSubsPriceModel WHERE Id=@Identity;
END
END