SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreement_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreement_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY Agreement Help
		Purpose  	: PROPERTYAgreement Help
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
CREATE PROCEDURE [dbo].[sp_PropertyAgreement_Help](
@PAction		 NVARCHAR(100)=NULL,
@PropertyId      BIGINT,
@Pram1           BIGINT=NULL, 
@Pram2			 NVARCHAR(100)=NULL, 
@UserId          BIGINT
)
AS
BEGIN  
IF @PAction ='PROPERTYOWNER'
 BEGIN
  SELECT RentalType,MaintenanceAmount,Tenure,Id FROM WRBHBPropertyAgreements  
  WHERE  IsDeleted=0;--PropertyId=@PropertyId AND
 END
 IF @PAction ='Apartment'
 BEGIN
	IF	@Pram2!='Internal Property'
	BEGIN
		SELECT PropertyName AS label,Id data FROM WRBHBProperty 
		WHERE IsDeleted=0;
	END
	ELSE
	BEGIN
	
		SELECT B.BlockName+' - '+ApartmentNo label ,A.Id data FROM dbo.WRBHBPropertyApartment A
		JOIN dbo.WRBHBPropertyBlocks B ON A.BlockId= B.Id
		WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0 AND 
		A.Id NOT IN(SELECT ISNULL(ApartmentId,0) FROM WRBHBPropertyAgreements WHERE PropertyId=@PropertyId);
		
	END		
 END
 IF @PAction ='ApartmentOwner'
 BEGIN
	IF	@Pram2!='Internal Property'
	BEGIN
		DECLARE @COUNT INT;
		SELECT @COUNT=COUNT(*)FROM dbo.WRBHBPropertyOwnerProperty A
		JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
		WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		
		IF @COUNT=1
		BEGIN
			SELECT S.FirstName Owner,S.Id AS OwnerId,0 AS Id,100 AS SplitPer  FROM dbo.WRBHBPropertyOwnerProperty A
			JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
			WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		END
		ELSE
		BEGIN
			SELECT S.FirstName Owner,S.Id AS OwnerId,0 AS Id,0 AS SplitPer  FROM dbo.WRBHBPropertyOwnerProperty A
			JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
			WHERE A.PropertyId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		END
	END
	ELSE
	BEGIN
	DECLARE @COUNT1 INT;
		SELECT @COUNT1=COUNT(*) FROM WRBHBPropertyOwnerApartment A
		JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
		WHERE ApartmentId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		
		IF @COUNT1=1
		BEGIN		
			SELECT S.FirstName Owner,S.Id AS OwnerId,0 AS Id,100 AS SplitPer  FROM WRBHBPropertyOwnerApartment A
			JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
			WHERE ApartmentId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		END
		ELSE
		BEGIN
			SELECT S.FirstName Owner,S.Id AS OwnerId,0 AS Id,0 AS SplitPer  FROM WRBHBPropertyOwnerApartment A
			JOIN WRBHBPropertyOwners S WITH(NOLOCK) ON A.OwnerId=S.Id AND S.IsDeleted=0 AND S.IsActive=1
			WHERE ApartmentId=@PropertyId AND A.IsDeleted=0 AND A.IsActive=1;
		END	
		
	END		
 END
 IF @PAction ='AgreementRooms'
 BEGIN
		SELECT RoomType,Id FROM WRBHBPropertyAgreementsRoomType
				
 END
 IF @PAction ='SavedAggrementDetails'
 BEGIN
		
		IF	@Pram2!='Internal Property'
		BEGIN		
			declare @SelectId BIGINT;
			SELECT @SelectId=Id FROM WRBHBPropertyAgreements A WHERE PropertyId=@PropertyId and IsActive=1 and IsDeleted=0
			SELECT A.PropertyId,CONVERT(NVARCHAR(100),DateOfAgreement,103) AS DateOfAgreement,
			CONVERT(NVARCHAR(100),RentalStartDate,103) AS RentalStartDate,NoticePeriod,LockInPeriod,
			StartingRentalMonth,RentalType,  
			Tenure, CONVERT(NVARCHAR(100),ExpiryDate,103) AS ExpiryDate,RentInclusive,
			Escalation,DurationEscalation,A.Id,CONVERT(NVARCHAR(100),StartingMaintenanceMonth,103) StartingMaintenanceMonth,
			MaintenanceAmount,AssociationName,AssociationId,ISNULL(ApartmentId,0)ApartmentId,
			ISNULL(b.BlockName+' - '+S.ApartmentNo,'') ApartmentName,Paid,CONVERT(NVARCHAR,isnull(AdvanceDate,''),103) AdvanceDate,
			AdvanceType,Bank,ChqNeft,AdvanceAmount,MaintenanceType,A.Status as Status,TAC,TACPer--,Flag,Tariff,Checks
			FROM WRBHBPropertyAgreements A
			LEFT OUTER JOIN dbo.WRBHBPropertyApartment S WITH(NOLOCK) ON A.ApartmentId=S.Id
			LEFT OUTER JOIN dbo.WRBHBPropertyBlocks B ON S.BlockId= B.Id 
			WHERE  A.Id=@SelectId;
			
			SELECT   CONVERT(NVARCHAR(100),StartDate,103) StartDate,CONVERT(NVARCHAR(100),EndDate,103) EndDate,Escalation,Rental ,Id
			FROM WRBHBPropertyAgreementsDetails WHERE  AgreementId=@SelectId;

			SELECT AgreementId,OwnerId,OwnerName Owner,SplitPer,Id FROM dbo.WRBHBPropertyAgreementsOwner
			WHERE AgreementId=@SelectId;

			SELECT AgreementId,RackSingle,RackDouble,RackTriple,Single,RDouble,Triple,Facility,Tax,Description as Description,
			Inclusive,Amount,RoomType,ISNULL(STAgreed,0) STAgreed,ISNULL(STRack,0) STRack,ISNULL(LTAgreed,0) LTAgreed,
			ISNULL(LTRack,0) LTRack,ISNULL(SC,0) SC,ISNULL(Visible,0) Visible,Id 
			FROM WRBHBPropertyAgreementsRoomCharges WHERE AgreementId=@SelectId AND IsActive=1 AND IsDeleted=0
	END
	else
	BEGIN
	--SELECT @SelectId=Id FROM WRBHBPropertyAgreements A WHERE PropertyId=@PropertyId and IsActive=1 and IsDeleted=0
			SELECT A.PropertyId,CONVERT(NVARCHAR(100),DateOfAgreement,103) AS DateOfAgreement,
			CONVERT(NVARCHAR(100),RentalStartDate,103) AS RentalStartDate,NoticePeriod,LockInPeriod,
			StartingRentalMonth,RentalType,  
			Tenure, CONVERT(NVARCHAR(100),ExpiryDate,103) AS ExpiryDate,RentInclusive,
			Escalation,DurationEscalation,A.Id,CONVERT(NVARCHAR(100),StartingMaintenanceMonth,103) StartingMaintenanceMonth,
			MaintenanceAmount,AssociationName,AssociationId,ISNULL(ApartmentId,0)ApartmentId,
			ISNULL(b.BlockName+' - '+S.ApartmentNo,'') ApartmentName,Paid,CONVERT(NVARCHAR,isnull(AdvanceDate,''),103) AdvanceDate,
			AdvanceType,Bank,ChqNeft,AdvanceAmount,MaintenanceType,A.Status as Status,TAC,TACPer--,Flag,Tariff,Checks
			FROM WRBHBPropertyAgreements A
			LEFT OUTER JOIN dbo.WRBHBPropertyApartment S WITH(NOLOCK) ON A.ApartmentId=S.Id
			LEFT OUTER JOIN dbo.WRBHBPropertyBlocks B ON S.BlockId= B.Id 
			WHERE  A.Id=@SelectId;
			
			SELECT   CONVERT(NVARCHAR(100),StartDate,103) StartDate,CONVERT(NVARCHAR(100),EndDate,103) EndDate,Escalation,Rental ,Id
			FROM WRBHBPropertyAgreementsDetails WHERE  AgreementId=@SelectId;

			SELECT AgreementId,OwnerId,OwnerName Owner,SplitPer,Id FROM dbo.WRBHBPropertyAgreementsOwner
			WHERE AgreementId=@SelectId;

			SELECT AgreementId,RackSingle,RackDouble,RackTriple,Single,RDouble,Triple,Facility,Tax,
			Description as Description,Inclusive,Amount,RoomType,ISNULL(STAgreed,0) STAgreed,ISNULL(STRack,0) STRack,ISNULL(LTAgreed,0) LTAgreed,
			ISNULL(LTRack,0) LTRack,ISNULL(SC,0) SC,ISNULL(Visible,0) Visible,Id 
			FROM WRBHBPropertyAgreementsRoomCharges WHERE AgreementId=@SelectId AND IsActive=1 AND IsDeleted=0
	
	END			
 END
   
 IF @PAction ='Deactivate'
 BEGIN
           UPDATE WRBHBPropertyAgreements SET Status=0 
           WHERE Id=@PropertyId AND IsActive=1 AND IsDeleted=0;
 END
 IF @PAction='AGGREMENTDELETE'
BEGIN
			UPDATE WRBHBPropertyAgreementsRoomCharges SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),
			IsDeleted=1,IsActive=0 WHERE Id=@PropertyId
			
END
END

