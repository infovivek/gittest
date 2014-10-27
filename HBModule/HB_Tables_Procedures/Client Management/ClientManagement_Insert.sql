-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sakthi
-- Create date: 19 Feb 2014
-- Description:	Client Management Insert
-- Modified Name                Modified Date
-- =============================================
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ClientManagement_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ClientManagement_Insert]
GO
CREATE PROCEDURE [dbo].[SP_ClientManagement_Insert](@MasterClientId BIGINT,@MasterClient NVARCHAR(100),
@SalesExecutiveId BIGINT,@KeyAccountPersonId BIGINT,@CRMId BIGINT,
@ClientName NVARCHAR(100),@CAddress1 NVARCHAR(100),@CAddress2 NVARCHAR(100),
@CCountry NVARCHAR(100),@InCCountry NVARCHAR(100),@CState NVARCHAR(100),@CCity NVARCHAR(100),
@CLocality NVARCHAR(100),@CPincode NVARCHAR(100),@DirectPay BIT,@BTC BIT,
@CreditLimit DECIMAL(27,2),@Status NVARCHAR(100),
@BAddress1 NVARCHAR(100),@BAddress2 NVARCHAR(100),@BCountry NVARCHAR(100),@InBCountry NVARCHAR(100), 
@BState NVARCHAR(100),@BCity NVARCHAR(100),@BLocality NVARCHAR(100),
@BPincode NVARCHAR(100),@DomainName NVARCHAR(100),@IndustryType NVARCHAR(100),
@CPhoneNo1 NVARCHAR(100),@CPhoneNo2 NVARCHAR(100),@CPhoneNo3 NVARCHAR(100),
@CPhoneNo4 NVARCHAR(100),@CPhoneNo5 NVARCHAR(100),@ClientLogo NVARCHAR(MAX),
@UsrId BIGINT,@ContactNo NVARCHAR(100),@CreditPeriod NVARCHAR(100),
@CreditPeriodNumber NVARCHAR(100),@ServiceCharge BIT)
AS
BEGIN
DECLARE @NewId INT
--IF NOT EXISTS(SELECT NULL FROM WRBHBMasterClientManagement WHERE   
--   UPPER(MasterClient)=UPPER(@MasterClient))
--   BEGIN
--   INSERT INTO WRBHBClientManagementMasterClient (MasterClient,IsActive)
--   VALUES (@MasterClient,1)
--     SET @MasterClientIds=@@IDENTITY; 
   
 INSERT INTO WRBHBClientManagement(MasterClientId,SalesExecutiveId,
 KeyAccountPersonId,CRMId,ClientName,CAddress1,CAddress2,CCountry,InCCountry,CState,
 CCity,CLocality,CPincode,DirectPay,BTC,CreditLimit,CreditPeriod,Status,
 BAddress1,BAddress2,BCountry,InBCountry,BState,BCity,BLocality,BPincode,DomainName,
 IndustryType,CPhoneNo1,CPhoneNo2,CPhoneNo3,CPhoneNo4,CPhoneNo5,ClientLogo,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
 CreditPeriodNumber,ContactNo,ServiceCharge)
 VALUES(@MasterClientId,@SalesExecutiveId,@KeyAccountPersonId,@CRMId,
 @ClientName,@CAddress1,@CAddress2,@CCountry,@InCCountry,@CState,@CCity,@CLocality,
 @CPincode,@DirectPay,@BTC,@CreditLimit,@CreditPeriod,@Status,@BAddress1,
 @BAddress2,@BCountry,@InBCountry,@BState,@BCity,@BLocality,@BPincode,@DomainName,
 @IndustryType,@CPhoneNo1,@CPhoneNo2,@CPhoneNo3,@CPhoneNo4,@CPhoneNo5,
 @ClientLogo,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
 @CreditPeriodNumber,@ContactNo,@ServiceCharge);
 
 SET @NewId=@@IDENTITY;
 
 UPDATE WRBHBClientManagement SET  TRClientURL='http://tr.staysimplyfied.com/?'+''+REPLACE(CAST(RowId AS NVARCHAR(100)),'-','')
 WHERE Id=@NewId
  
 SELECT Id,RowId FROM WRBHBClientManagement WHERE Id=@NewId;
END






