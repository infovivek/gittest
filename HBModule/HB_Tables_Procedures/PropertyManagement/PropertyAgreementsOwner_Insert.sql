SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreementsOwner_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreementsOwner_Insert]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (27/02/2014)>
Section  	: PropertyAgreementsOwner Insert 
Purpose  	: PropertyAgreementsOwner Insert
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
CREATE PROCEDURE [dbo].[sp_PropertyAgreementsOwner_Insert]
(
@AgreementId	BIGINT,
@OwnerId		BIGINT,
@OwnerName		NVARCHAR(100),
@SplitPer		DECIMAL(27, 2),
@CreatedBy		INT
)
AS
BEGIN
INSERT INTO WRBHBPropertyAgreementsOwner 
(AgreementId,OwnerId,OwnerName,SplitPer,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
VALUES 
(@AgreementId,@OwnerId,@OwnerName,@SplitPer,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

SELECT Id,RowId FROM WRBHBPropertyApartment WHERE Id=@@IDENTITY
END