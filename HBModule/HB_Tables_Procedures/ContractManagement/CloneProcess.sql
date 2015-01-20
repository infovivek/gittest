SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CloneClientPref_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_CloneClientPref_Insert

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: CLONE CLIENT Copy
Purpose  	: CLONE CLIENT Copy
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

CREATE PROCEDURE Sp_CloneClientPref_Insert
(
@FromId		BIGINT,
@ToId		BIGINT,
@UserId		BIGINT
)
AS
BEGIN
DECLARE @Identity INT
DECLARE @FromHId BIGINT,@ToHId BIGINT,@FromPId BIGINT,@ToPId BIGINT;

SET @FromHId=(Select Id from WRBHBContractClientPref_Header WHERE ClientId=@FromId AND IsActive=1)--@FromId)
SET @ToHId=(Select Id from WRBHBContractClientPref_Header WHERE ClientId=@ToId AND IsActive=1)--@ToId)


	IF NOT EXISTS(SELECT NULL FROM WRBHBContractClientPref_Header WHERE ClientId=@ToId AND IsActive=1 AND IsDeleted=0)
	BEGIN
		INSERT INTO WRBHBContractClientPref_Header(ClientId,Date,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
		IsActive,IsDeleted,RowId) VALUES(@ToId,GETDATE(),@UserId,GETDATE(),@UserId,GETDATE(),1,0,NEWID())
	END
	
	CREATE TABLE #TEMP(HeaderId BIGINT,PropertyName NVARCHAR(100),PropertyId BIGINT,RoomType NVARCHAR(100),
	RoomId BIGINT,TariffSingle DECIMAL(27,2),TariffDouble DECIMAL(27,2),TaxInclusive DECIMAL(27,2),
	TaxPercentage DECIMAL(27,2),RackTariffSingle DECIMAL(27,2),RackTariffDouble DECIMAL(27,2),RackTariffTriple DECIMAL(27,2),
	LTAgreed DECIMAL(27,2),LTRack DECIMAL(27,2),STAgreed DECIMAL(27,2),
	CreatedBy BIGINT,CreatedDate DATETIME,ModifiedBy BIGINT,ModifiedDate DATETIME,
	IsActive BIT,IsDeleted BIT,TariffTriple DECIMAL(27,2),Facility NVARCHAR(100),Email NVARCHAR(100))

	UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1 
	WHERE HeaderId=@FromHId AND PropertyId=@FromPId



CREATE TABLE #Property (PropertyId BIGINT)
INSERT INTO #Property (PropertyId)
Select PropertyId from WRBHBContractClientPref_Details WHERE HeaderId=@FromHId AND IsActive=1

 DECLARE @Cnt int;
   SET @Cnt=(SELECT COUNT(*) FROM #Property);

WHILE @Cnt>0
   BEGIN
		SET @ToHId=(Select Id from WRBHBContractClientPref_Header WHERE ClientId=@ToId AND IsActive=1)
		DECLARE @PrtyId int
		SELECT TOP 1 @PrtyId=PropertyId FROM #Property 
   
		UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1
		WHERE HeaderId=@ToHId AND PropertyId=@PrtyId     
   
		INSERT INTO #TEMP (HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
		TariffDouble,TaxInclusive,TaxPercentage,RackTariffSingle,RackTariffDouble,RackTariffTriple,
		LTAgreed,LTRack,STAgreed,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,
		TariffTriple,Facility,Email)
		
		SELECT @ToHId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
		TariffDouble,TaxInclusive,TaxPercentage,ISNULL(RTariffSingle,0),ISNULL(RTariffDouble,0),
		ISNULL(RTariffTriple,0),ISNULL(LTAgreed,0),ISNULL(LTRack,0),ISNULL(STAgreed,0),
		@UserId,GETDATE(),@UserId,GETDATE(),IsActive,IsDeleted,
		TariffTriple,Facility,Email FROM WRBHBContractClientPref_Details WHERE HeaderId=@FromHId AND PropertyId=@PrtyId 
		AND IsActive=1
		
		DELETE  FROM #Property where PropertyId= @PrtyId
		SET @Cnt=(SELECT COUNT(*) FROM #Property); ;
   END

--SELECT @FromHId,@ToHId,@FromPId
--SET @ToPId=(Select PropertyId from WRBHBContractClientPref_Details WHERE HeaderId=@ToHId)

		
IF EXISTS(SELECT Id FROM WRBHBContractClientPref_Details WHERE HeaderId=@ToHId)
BEGIN

    UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1
	Where HeaderId=@ToHId AND PropertyId=@PrtyId          
	
	INSERT INTO WRBHBContractClientPref_Details(HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
	TariffDouble,TaxInclusive,TaxPercentage,RTariffSingle,RTariffDouble,RTariffTriple,
	LTAgreed,LTRack,STAgreed,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,
	TariffTriple,Facility,Email,RowId)
	
	SELECT HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
	TariffDouble,TaxInclusive,TaxPercentage,RackTariffSingle,RackTariffDouble,RackTariffTriple,
	LTAgreed,LTRack,STAgreed
	,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,
	TariffTriple,Facility,Email,NEWID() FROM #TEMP
	
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBContractClientPref_Details WHERE Id=@Identity;	
END
ELSE
BEGIN
	INSERT INTO WRBHBContractClientPref_Details(HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
	TariffDouble,TaxInclusive,TaxPercentage,RTariffSingle,RTariffDouble,RTariffTriple,
	LTAgreed,LTRack,STAgreed,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,
	TariffTriple,Facility,Email,RowId)
	
	SELECT HeaderId,PropertyName,PropertyId,RoomType,RoomId,TariffSingle,
	TariffDouble,TaxInclusive,TaxPercentage,RackTariffSingle,RackTariffDouble,RackTariffTriple,
	LTAgreed,LTRack,STAgreed,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,
	TariffTriple,Facility,Email,NEWID() FROM #TEMP
	
	SET  @Identity=@@IDENTITY
	SELECT Id,RowId FROM WRBHBContractClientPref_Details WHERE Id=@Identity;	
END
END



	