SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreementsOwner_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreementsOwner_Update]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (27/02/2014)  >
Section  	: PropertyAgreementsOwner Update 
Purpose  	: PropertyAgreementsOwner Update
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
create procedure [dbo].[sp_PropertyAgreementsOwner_Update]
(
@Id				BIGINT,
@AgreementId	BIGINT,
@OwnerId		BIGINT,
@OwnerName		NVARCHAR(100),
@SplitPer		DECIMAL(27, 2),
@CreatedBy		INT
)
AS
BEGIN
UPDATE WRBHBPropertyAgreementsOwner SET 
AgreementId=@AgreementId,
OwnerId=@OwnerId,
OwnerName=@OwnerName,
SplitPer=@SplitPer,
ModifiedBy=@CreatedBy,
ModifiedDate=GETDATE()
WHERE Id=@Id

SELECT Id,RowId FROM WRBHBPropertyApartment WHERE Id=@Id
END