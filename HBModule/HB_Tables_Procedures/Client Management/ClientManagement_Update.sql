SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ClientManagement_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ClientManagement_Update]
GO 

/****** Object:  StoredProcedure [dbo].[SP_ClientManagement_Update]    Script Date: 03/11/2014 18:07:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ClientManagement_Update](@MasterClientId BIGINT,@MasterClient NVARCHAR(100),
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
@CreditPeriodNumber NVARCHAR(100),@Id BIGINT,@ServiceCharge BIT)
AS
BEGIN
	DECLARE @TRURL NVARCHAR(100)
	SET @TRURL=(SELECT TRClientURL FROM WRBHBClientManagement WHERE Id=@Id)
	IF(@TRURL !='')
		BEGIN
			 UPDATE WRBHBClientManagement SET MasterClientId=@MasterClientId,
			 SalesExecutiveId=@SalesExecutiveId,KeyAccountPersonId=@KeyAccountPersonId,
			 CRMId=@CRMId,ClientName=@ClientName,CAddress1=@CAddress1,
			 CAddress2=@CAddress2,CCountry=@CCountry,InCCountry=@InCCountry,CState=@CState,CCity=@CCity,
			 CLocality=@CLocality,CPincode=@CPincode,DirectPay=@DirectPay,BTC=@BTC,
			 CreditLimit=@CreditLimit,CreditPeriod=@CreditPeriod,Status=@Status,
			 BAddress1=@BAddress1,BAddress2=@BAddress2,BCountry=@BCountry,InBCountry=@InBCountry,BState=@BState,
			 BCity=@BCity,BLocality=@BLocality,BPincode=@BPincode,DomainName=@DomainName,
			 IndustryType=@IndustryType,CPhoneNo1=@CPhoneNo1,CPhoneNo2=@CPhoneNo2,
			 CPhoneNo3=@CPhoneNo3,CPhoneNo4=@CPhoneNo4,CPhoneNo5=@CPhoneNo5,
			 ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
			 CreditPeriodNumber=@CreditPeriodNumber,ContactNo=@ContactNo,ServiceCharge=@ServiceCharge 
			 WHERE Id=@Id;
			 SELECT Id,RowId FROM WRBHBClientManagement WHERE Id=@Id;
		 END
 ELSE
		 BEGIN
			 UPDATE WRBHBClientManagement SET MasterClientId=@MasterClientId,
			 SalesExecutiveId=@SalesExecutiveId,KeyAccountPersonId=@KeyAccountPersonId,
			 CRMId=@CRMId,ClientName=@ClientName,CAddress1=@CAddress1,
			 CAddress2=@CAddress2,CCountry=@CCountry,InCCountry=@InCCountry,CState=@CState,CCity=@CCity,
			 CLocality=@CLocality,CPincode=@CPincode,DirectPay=@DirectPay,BTC=@BTC,
			 CreditLimit=@CreditLimit,CreditPeriod=@CreditPeriod,Status=@Status,
			 BAddress1=@BAddress1,BAddress2=@BAddress2,BCountry=@BCountry,InBCountry=@InBCountry,BState=@BState,
			 BCity=@BCity,BLocality=@BLocality,BPincode=@BPincode,DomainName=@DomainName,
			 IndustryType=@IndustryType,CPhoneNo1=@CPhoneNo1,CPhoneNo2=@CPhoneNo2,
			 CPhoneNo3=@CPhoneNo3,CPhoneNo4=@CPhoneNo4,CPhoneNo5=@CPhoneNo5,
			 ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
			 CreditPeriodNumber=@CreditPeriodNumber,ContactNo=@ContactNo,ServiceCharge=@ServiceCharge, 
			 TRClientURL='http://tr.staysimplyfied.com/?'+''+REPLACE(CAST(RowId AS NVARCHAR(100)),'-','')
			 WHERE Id=@Id;
			 SELECT Id,RowId FROM WRBHBClientManagement WHERE Id=@Id;
		 END
END

GO


