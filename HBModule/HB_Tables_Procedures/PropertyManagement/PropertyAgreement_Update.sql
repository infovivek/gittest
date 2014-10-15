 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyAgreement_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyAgreement_Update]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY  AGREEMENTS
		Purpose  	: PROPERTY  AGREEMENTS Update
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
CREATE PROCEDURE [dbo].[sp_PropertyAgreement_Update] (
@PropertyId					BIGINT,
@OwnerId					BIGINT,
@DateOfAgreement			 NVARCHAR(100),
@RentalStartDate			 NVARCHAR(100),
@NoticePeriod				BIGINT,
@LockInPeriod				BIGINT,
@StartingRentalMonth		NVARCHAR(100),
@RentalType					NVARCHAR(100),
@StartingMaintenanceMonth	NVARCHAR(100),
@MaintenanceAmount			DECIMAL(27,2),
@Tenure						NVARCHAR(100),
@ExpiryDate					NVARCHAR(100),
@RentInclusive				BIT,
@Createdby					BIGINT,  
@Id							BigInt,
@AssociationName			NVARCHAR(100),
@ApartmentId	BIGINT,
@ApartmentName  NVARCHAR(100),
@Paid			NVARCHAR(100),
@AdvanceDate	NVARCHAR(100),
@AdvanceType	NVARCHAR(100),
@Bank           NVARCHAR(100),
@ChqNeft		NVARCHAR(100),
@AdvanceAmount	DECIMAL(27,2),
@MaintenanceType nvarchar(100),
@Status         Bit,
@TAC	        BIT,
@TACPer         DECIMAL(27,2)
--@Flag			BIGINT,
--@Tariff			DECIMAL(27,2),
--@Check			BIGINT
)   
AS  
BEGIN 
DECLARE @Identity int,@IsActive BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER;  
DECLARE @AssociationId BIGINT; 
SELECT @RowId =NEWID(),@IsActive=0,@IsDeleted=0;  
  
--UPDATE   WRBHBPropertyAgreements SET  
--IsActive=0,
--ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
--WHERE Id=@Id;

IF EXISTS (SELECT NULL FROM WRBHBPropertyAgreementsAssociationName WHERE UPPER(AssociationName)=@AssociationName)
BEGIN 
	SELECT @AssociationId=Id FROM WRBHBPropertyAgreementsAssociationName WHERE UPPER(AssociationName)=@AssociationName
END
ELSE
BEGIN
INSERT INTO WRBHBPropertyAgreementsAssociationName
(AssociationName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
VALUES 
(@AssociationName,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())
SELECT @AssociationId=@@IDENTITY
END
  --INSERT 
  
  DECLARE @Category NVARCHAR(100);
  --SELECT @PropertyId=PropertyId FROM WRBHBPropertyOwners WHERE Id=@OwnerId ;
  SELECT @Category=Category FROM WRBHBProperty WHERE Id=@PropertyId ;
  
  IF @Category!='Internal Property'
  BEGIN 
  
		INSERT INTO dbo.WRBHBPropertyAgreementsHistory( 
		PropertyId,DateOfAgreement,RentalStartDate,NoticePeriod,LockInPeriod,
		StartingRentalMonth,RentalType,Tenure,ExpiryDate,RentInclusive,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Escalation,DurationEscalation,
		StartingMaintenanceMonth,MaintenanceAmount,AssociationName,AssociationId,
		ApartmentId,ApartmentName,OwnerPropertyId,PropertyName,Paid,AdvanceDate,
		AdvanceType,Bank,ChqNeft,AdvanceAmount,MaintenanceType,Status,TAC,TACPer)
		--Flag,Tariff,Checks)   
		VALUES( @PropertyId,CONVERT(DATETIME,@DateOfAgreement,103),
		CONVERT(DATETIME,@RentalStartDate,103),@NoticePeriod,@LockInPeriod,
		@StartingRentalMonth,@RentalType,
		@Tenure, CONVERT(DATETIME,@ExpiryDate,103),@RentInclusive,
		@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),'','',
		CONVERT(DATETIME,@StartingMaintenanceMonth,103),@MaintenanceAmount,@AssociationName,@AssociationId,
		0,'',@ApartmentId,@ApartmentName,@Paid,CONVERT(DATETIME,@AdvanceDate,103),
		@AdvanceType,@Bank,@ChqNeft,@AdvanceAmount,@MaintenanceType,@Status,@TAC,
		@TACPer)--,@Flag,@Tariff,@Check); 
		
		
		UPDATE dbo.WRBHBPropertyAgreements SET PropertyId=@PropertyId,DateOfAgreement=CONVERT(DATETIME,@DateOfAgreement,103)
		,RentalStartDate=CONVERT(DATETIME,@RentalStartDate,103),NoticePeriod=@NoticePeriod,LockInPeriod=@LockInPeriod,
		StartingRentalMonth=@StartingRentalMonth,RentalType=@RentalType,Tenure=@Tenure,ExpiryDate=CONVERT(DATETIME,@ExpiryDate,103),
		RentInclusive=@RentInclusive,ModifiedBy=@Createdby,ModifiedDate=GETDATE(),Escalation='',DurationEscalation='',
		StartingMaintenanceMonth=CONVERT(DATETIME,@StartingMaintenanceMonth,103),MaintenanceAmount=@MaintenanceAmount,
		AssociationName=@AssociationName,AssociationId=@AssociationId,ApartmentId=@ApartmentId,ApartmentName=@ApartmentName,
		OwnerPropertyId=0,PropertyName='',Paid=@Paid,AdvanceDate=CONVERT(DATETIME,@AdvanceDate,103),
		AdvanceType=@AdvanceType,Bank=@Bank,ChqNeft=@ChqNeft,AdvanceAmount=@AdvanceAmount,MaintenanceType=@MaintenanceType,
		Status=@Status,TAC=@TAC,TACPer=@TACPer
		WHERE Id=@Id;
		SELECT Id , RowId FROM WRBHBPropertyAgreements WHERE Id=@Id
   END	
   ELSE
   BEGIN
   
		INSERT INTO dbo.WRBHBPropertyAgreementsHistory( 
		PropertyId,DateOfAgreement,RentalStartDate,NoticePeriod,LockInPeriod,
		StartingRentalMonth,RentalType,Tenure,ExpiryDate,RentInclusive,
		CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,Escalation,DurationEscalation,
		StartingMaintenanceMonth,MaintenanceAmount,AssociationName,AssociationId,
		ApartmentId,ApartmentName,OwnerPropertyId,PropertyName,Paid,AdvanceDate,
		AdvanceType,Bank,ChqNeft,AdvanceAmount,MaintenanceType,Status,TAC,TACPer)--,Flag,Tariff,Checks)   
		VALUES( @PropertyId,CONVERT(DATETIME,@DateOfAgreement,103),
		CONVERT(DATETIME,@RentalStartDate,103),@NoticePeriod,@LockInPeriod,
		@StartingRentalMonth,@RentalType,
		@Tenure, CONVERT(DATETIME,@ExpiryDate,103),@RentInclusive,
		@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID(),'','',
		CONVERT(DATETIME,@StartingMaintenanceMonth,103),@MaintenanceAmount,@AssociationName,@AssociationId,
		@ApartmentId,@ApartmentName,0,'',@Paid,CONVERT(DATETIME,@AdvanceDate,103),
		@AdvanceType,@Bank,@ChqNeft,@AdvanceAmount,@MaintenanceType,@Status,@TAC,@TACPer);--,@Flag,@Tariff,@Check);    
		
		
		UPDATE dbo.WRBHBPropertyAgreements SET PropertyId=@PropertyId,DateOfAgreement=CONVERT(DATETIME,@DateOfAgreement,103)
		,RentalStartDate=CONVERT(DATETIME,@RentalStartDate,103),NoticePeriod=@NoticePeriod,LockInPeriod=@LockInPeriod,
		StartingRentalMonth=@StartingRentalMonth,RentalType=@RentalType,Tenure=@Tenure,ExpiryDate=CONVERT(DATETIME,@ExpiryDate,103),
		RentInclusive=@RentInclusive,ModifiedBy=@Createdby,ModifiedDate=GETDATE(),Escalation='',DurationEscalation='',
		StartingMaintenanceMonth=CONVERT(DATETIME,@StartingMaintenanceMonth,103),MaintenanceAmount=@MaintenanceAmount,
		AssociationName=@AssociationName,AssociationId=@AssociationId,ApartmentId=@ApartmentId,ApartmentName=@ApartmentName,
		OwnerPropertyId=0,PropertyName='',Paid=@Paid,AdvanceDate=CONVERT(DATETIME,@AdvanceDate,103),
		AdvanceType=@AdvanceType,Bank=@Bank,ChqNeft=@ChqNeft,AdvanceAmount=@AdvanceAmount,MaintenanceType=@MaintenanceType,
		Status=@Status,TAC=@TAC,TACPer=@TACPer
		WHERE Id=@Id;
		
		SELECT Id , RowId FROM WRBHBPropertyAgreements WHERE Id=@Id
   END 
  
 --SELECT Id,RowId FROM WRBHBPropertyAgreements WHERE Id=@@IDENTITY;  
 END  



