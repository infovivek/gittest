SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreement_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreement_Select]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY Agreement USER
		Purpose  	: PROPERTYAgreement SEARCH
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
CREATE PROCEDURE [dbo].[sp_PropertyAgreement_Select](  
@SelectId        BigInt,  
@Pram1           BigInt=NULL,   
@Pram2           NVARCHAR(100)=NULL,  
@UserId          BigInt  
)  
AS  
BEGIN  
IF @SelectId <> 0    
BEGIN    
  DECLARE @Category NVARCHAR(100),@PropertyId BIGINT;
  --SELECT @PropertyId=PropertyId FROM WRBHBPropertyOwners WHERE Id=@SelectId ;
  SELECT @Category=Category FROM WRBHBProperty WHERE Id=@Pram1 ; 
  --SELECT @Category;
  IF @Category!='Internal Property'
  BEGIN  
 
	 SELECT PropertyId,CONVERT(NVARCHAR(100),DateOfAgreement,103) AS DateOfAgreement,
	 CONVERT(NVARCHAR(100),RentalStartDate,103) AS RentalStartDate,NoticePeriod,LockInPeriod,
	 StartingRentalMonth,RentalType,A.Status as Status,  
	 Tenure, CONVERT(NVARCHAR(100),ExpiryDate,103) AS ExpiryDate,RentInclusive,
	 Escalation,DurationEscalation,A.Id,CONVERT(NVARCHAR(100),StartingMaintenanceMonth,103) StartingMaintenanceMonth,
	 MaintenanceAmount,AssociationName,AssociationId,ISNULL(OwnerPropertyId,0) ApartmentId,
	 ISNULL(S.PropertyName,'') ApartmentName,Paid,CONVERT(NVARCHAR,isnull(AdvanceDate,''),103) AdvanceDate,
	 AdvanceType,Bank,ChqNeft,AdvanceAmount,MaintenanceType,TAC,TACPer --,Flag,Tariff,Checks
	 FROM WRBHBPropertyAgreements A
	 LEFT OUTER JOIN dbo.WRBHBProperty S WITH(NOLOCK) ON A.OwnerPropertyId=S.Id
	 WHERE  A.Id=@SelectId;
	 
	 SELECT   CONVERT(NVARCHAR(100),StartDate,103) StartDate,CONVERT(NVARCHAR(100),EndDate,103) EndDate,Escalation,Rental ,Id
	 FROM WRBHBPropertyAgreementsDetails WHERE  AgreementId=@SelectId;
	 
	 SELECT AgreementId,OwnerId,OwnerName Owner,SplitPer,Id FROM dbo.WRBHBPropertyAgreementsOwner
	 WHERE AgreementId=@SelectId;
	 
	 SELECT AgreementId,RackSingle,RackDouble,RackTriple,Facility,Tax,Description as Description,Inclusive,Amount,RoomType,
	 LTAgreed,STAgreed,LTRack,STRack,SC,Visible,Id 
	 FROM WRBHBPropertyAgreementsRoomCharges WHERE AgreementId=@SelectId AND IsActive=1 AND IsDeleted=0
	 
	 
  END
  ELSE
  BEGIN
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
  END	 
   
 SELECT   CONVERT(NVARCHAR(100),StartDate,103) StartDate,CONVERT(NVARCHAR(100),EndDate,103) EndDate,Escalation,Rental ,Id
 FROM WRBHBPropertyAgreementsDetails WHERE  AgreementId=@SelectId;
 
 SELECT AgreementId,OwnerId,OwnerName Owner,SplitPer,Id FROM dbo.WRBHBPropertyAgreementsOwner
 WHERE AgreementId=@SelectId;
 
 SELECT AgreementId,RackSingle,RackDouble,RackTriple,Facility,Tax,Description as Description,Inclusive,Amount,RoomType,
 LTAgreed,STAgreed,LTRack,STRack,SC,Visible,Id 
 FROM WRBHBPropertyAgreementsRoomCharges WHERE AgreementId=@SelectId AND IsActive=1 AND IsDeleted=0
END   
   
IF @SelectId=0  
BEGIN  
 DECLARE @Category1 NVARCHAR(100);
 SELECT @Category1=Category FROM WRBHBProperty WHERE Id=@Pram1 ;

 IF @Category1='Internal Property'
 BEGIN 
	 SELECT CONVERT(NVARCHAR(100),DateOfAgreement,103 ) DateOfAgreement,StartingRentalMonth ,ApartmentName ApartmentNo,RentalType,Id 
	 FROM dbo.WRBHBPropertyAgreements WHERE PropertyId=@Pram1 AND IsActive=1 AND  IsDeleted=0   ORDER BY Id DESC
  END
 ELSE
 BEGIN 
	 SELECT ISNULL(RoomType,'') RoomType,ISNULL(RackSingle,0) AgreedTariffSingle,
	 ISNULL(RackDouble,0)AgreedTariffDouble,ISNULL(RackTriple,0)AgreedTariffTriple,Description,
	 ISNULL(Facility,'')Facility,ISNULL(Tax,0) Tax,ISNULL(Inclusive,'false') Inclusive,
	 ISNULL(STAgreed,0) STAgreed,ISNULL(STRack,0) STRack,ISNULL(LTAgreed,0) LTAgreed,
	 ISNULL(LTRack,0) LTRack,ISNULL(SC,0) SC,Visible,P.Id 
	 FROM dbo.WRBHBPropertyAgreements P
	 LEFT OUTER JOIN WRBHBPropertyAgreementsRoomCharges C ON C.AgreementId=P.Id
	 WHERE P.PropertyId=@Pram1 AND P.IsActive=1 AND  P.IsDeleted=0  ORDER BY P.Id DESC
 END 
END   
END  