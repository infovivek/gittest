SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_MasterClientManagement_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_MasterClientManagement_Update]
GO 

/****** Object:  StoredProcedure [dbo].[SP_ClientManagement_Update]    Script Date: 03/11/2014 18:07:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MasterClientManagement_Update](
@ClientName NVARCHAR(1000),@CAddress1 NVARCHAR(1000),@CAddress2 NVARCHAR(1000),
@CCountry NVARCHAR(100),@InCCountry NVARCHAR(100),@CState NVARCHAR(100),@CCity NVARCHAR(100),
@CLocality NVARCHAR(100),@CPincode NVARCHAR(100),@DomainName NVARCHAR(100),
@CPhoneNo1 NVARCHAR(100),@CPhoneNo2 NVARCHAR(100),@CPhoneNo3 NVARCHAR(100),
@CPhoneNo4 NVARCHAR(100),@CPhoneNo5 NVARCHAR(100),@ClientLogo NVARCHAR(MAX),
@UsrId BIGINT,@ContactNo NVARCHAR(100),@Id BIGINT)
AS
BEGIN
 UPDATE WRBHBMasterClientManagement SET 
 ClientName=@ClientName,CAddress1=@CAddress1, CAddress2=@CAddress2,CCountry=@CCountry,
 InCCountry=@InCCountry,CState=@CState,CCity=@CCity,
 CLocality=@CLocality,CPincode=@CPincode,DomainName=@DomainName,
 CPhoneNo1=@CPhoneNo1,CPhoneNo2=@CPhoneNo2, CPhoneNo3=@CPhoneNo3,CPhoneNo4=@CPhoneNo4,CPhoneNo5=@CPhoneNo5,
 ClientLogo=@ClientLogo,ModifiedBy=@UsrId,ModifiedDate=GETDATE(),ContactNo=@ContactNo WHERE Id=@Id;
 SELECT Id,RowId FROM WRBHBMasterClientManagement WHERE Id=@Id;
END

GO