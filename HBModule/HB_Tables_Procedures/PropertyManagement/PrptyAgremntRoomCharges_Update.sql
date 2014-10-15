SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PrptyAgremntRoomCharges_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PrptyAgremntRoomCharges_Update]
GO 
/* 
Author Name : <NAHARJUN.U>
Created On 	: <Created Date (28/02/2014)  >
Section  	: PropertyAgreementsRoomCharge Update 
Purpose  	: PropertyAgreementsRoomCharge Update
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
create procedure Sp_PrptyAgremntRoomCharges_Update
(
@Id				BIGINT,
@AgreementId	BIGINT,
@RackSingle		DECIMAL(27,2),
@RackDouble		DECIMAL(27,2),
@RackTriple		DECIMAL(27,2),
@RSingle		DECIMAL(27,2),
@RDouble		DECIMAL(27,2),
@RTriple		DECIMAL(27,2),
@Facility       NVARCHAR(100),
@Tax			DECIMAL(27,2),
@Inclusive		BIT,
@Amount			DECIMAL(27,2),
@RoomType		NVARCHAR(100),
@Description	NVARCHAR(100),
@LTAgreed		DECIMAL(27,2),
@STAgreed		DECIMAL(27,2),
@LTRack			DECIMAL(27,2),
@STRack			DECIMAL(27,2),
@SC				DECIMAL(27,2),
@Visible		BIT,
@CreatedBy		INT
)
AS
DECLARE @Identity int;
BEGIN
IF NOT EXISTS(SELECT NULL FROM WRBHBPropertyAgreementsRoomType WHERE UPPER(RoomType)=UPPER(@RoomType))
BEGIN
INSERT INTO WRBHBPropertyAgreementsRoomType(RoomType,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,IsActive,IsDeleted,RowId)	
VALUES
(@RoomType,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
END
	INSERT INTO WRBHBPropertyAgreementsRoomChargesHistory 
	(AgreementId,RackSingle,RackDouble,Facility,Tax,Inclusive,Amount,RoomType,CreatedBy,
	CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,RackTriple,Description,Single,RDouble,Triple,
	LTAgreed,STAgreed,LTRack,STRack,SC,Visible)
	VALUES 
	(@AgreementId,@RackSingle,@RackDouble,@Facility,@Tax,@Inclusive,@Amount,@RoomType,
	@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),@RackTriple,@Description,@RSingle,@RDouble,@RTriple,
	@LTAgreed,@STAgreed,@LTRack,@STRack,@SC,@Visible)

	SET  @Identity=@@IDENTITY

UPDATE WRBHBPropertyAgreementsRoomCharges SET AgreementId=@AgreementId,RackSingle=@RackSingle,
	RackDouble=@RackDouble,Facility=@Facility,Tax=@Tax,Inclusive=@Inclusive,Amount=@Amount,RoomType=@RoomType,
	ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),RackTriple=@RackTriple,Description=@Description,Single=@RSingle,
	RDouble=@RDouble,Triple=@RTriple ,LTAgreed=@LTAgreed,STAgreed=@STAgreed,
	LTRack= @LTRack,STRack=@STRack,SC=@SC,Visible=@Visible
	WHERE Id=@Id
		
SELECT Id,RowId FROM WRBHBPropertyAgreementsRoomCharges WHERE Id=@Id

END
