SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorRequest_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_VendorRequest_Update]
GO   
/* 
Author Name : Anbu
Created On 	: <Created Date (31/03/2014)  >
Section  	: VendorRequest Update
Purpose  	: VendorRequest Update
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
CREATE PROCEDURE [dbo].[Sp_VendorRequest_Update]
(
@Date			NVARCHAR(100),
@Description	NVARCHAR(MAX),
@VendorName    	NVARCHAR(100),
@Service    	NVARCHAR(100),
@Amount			DECIMAL(27,1),
@CreatedBy		INT,
@Status			NVARCHAR(100),
@PropertyId		BIGINT,
@UserId			BIGINT,
@Id				BIGINT,
@VendorId		BIGINT,
@Total			BIGINT,
@CategoryId		BIGINT
)
AS
BEGIN
DECLARE @Identity int
UPDATE WRBHBVendorRequest SET Date=Convert(date,@Date,103),Description=@Description,VendorName=@VendorName,
Service=@Service,Amount=@Amount,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),TotalAmount=@Total,
CategoryId=@CategoryId,Status=@Status,Remark=0,VendorId=@VendorId 
WHERE Id=@Id
			
SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBVendorRequest WHERE Id=@Identity;
	
END			