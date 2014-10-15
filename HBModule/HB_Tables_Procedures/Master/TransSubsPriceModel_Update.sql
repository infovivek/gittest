SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TransSubsPriceModel_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TransSubsPriceModel_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TRANSSUBSPRICEMODEL UPDATE
Purpose  	: PRICE MODEL UPDATE
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
CREATE PROCEDURE Sp_TransSubsPriceModel_Update
(
@Types				NVARCHAR(100),
@Name				NVARCHAR(100),
@Amount				DECIMAL(27, 2),
@AllowedBookings	BIGINT,
@UserId				BIGINT,
@Id					BIGINT,
@EscalationTenure	NVARCHAR(100),
@EscalationPercentage DECIMAL(27, 2)
)
AS
BEGIN
DECLARE @Identity int
Begin 
IF EXISTS (SELECT NULL FROM  WRBHBTransSubsPriceModel 
 WHERE Amount=@Amount and AllowedBookings=@AllowedBookings and Id=@Id)
      Begin  
	UPDATE WRBHBTransSubsPriceModel SET Name =@Name,Amount=@Amount,AllowedBookings=@AllowedBookings,
	 modifiedby=@UserId,modifieddate=GETDATE(),EscalationPercentage=@EscalationPercentage,
	 EscalationTenure=@EscalationTenure 
		where Id=@Id and IsActive=1 and IsDeleted=0 ; 

	 
	select Id,RowId From WRBHBTransSubsPriceModel where Id=@Id;
	end
else
begin		
			UPDATE WRBHBTransSubsPriceModel SET  IsActive=0,IsDeleted=1 WHERE Id=@Id
			INSERT INTO WRBHBTransSubsPriceModel (Types,Name,Amount,AllowedBookings,CreatedBy,CreatedDate,ModifiedBy,
			ModifiedDate,IsActive,IsDeleted,RowId,EscalationTenure,EscalationPercentage)
VALUES (@Types,@Name,@Amount,@AllowedBookings,@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID(),@EscalationTenure,
			@EscalationPercentage)

SET @Identity=@@IDENTITY;
SELECT Id,Rowid FROM WRBHBTransSubsPriceModel WHERE Id=@Identity;
End
END		
End
