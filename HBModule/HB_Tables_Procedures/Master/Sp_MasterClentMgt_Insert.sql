SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anbu
-- Create date: 13 Mar 2014
-- Description:	Master Client Management Insert
-- Modified Name                Modified Date
-- =============================================
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_MasterClientManagement_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_MasterClientManagement_Insert]
GO
CREATE PROCEDURE [dbo].[SP_MasterClientManagement_Insert](
@ClientName NVARCHAR(1000),@CAddress1 NVARCHAR(1000),@CAddress2 NVARCHAR(1000),
@CCountry NVARCHAR(100),@InCCountry NVARCHAR(100),@CState NVARCHAR(100),@CCity NVARCHAR(100),
@CLocality NVARCHAR(100),@CPincode NVARCHAR(100),@DomainName NVARCHAR(100),
@CPhoneNo1 NVARCHAR(100),@CPhoneNo2 NVARCHAR(100),@CPhoneNo3 NVARCHAR(100),
@CPhoneNo4 NVARCHAR(100),@CPhoneNo5 NVARCHAR(100),@ClientLogo NVARCHAR(MAX),
@UsrId BIGINT,@ContactNo NVARCHAR(100))
AS
BEGIN
DECLARE @CreatedBy int,@ErrMsg NVARCHAR(MAX);
IF  EXISTS(SELECT NULL FROM WRBHBMasterClientManagement WHERE   
   UPPER(ClientName)=UPPER(@ClientName))
   BEGIN
    SET @ErrMsg = 'ClientName Already Exists';
        
    SELECT @ErrMsg;
             
 END
 ELSE  
  BEGIN 
 INSERT INTO WRBHBMasterClientManagement(ClientName,CAddress1,
 CAddress2,CCountry,InCCountry,CState, CCity,CLocality,CPincode,
 DomainName, CPhoneNo1,CPhoneNo2,CPhoneNo3,CPhoneNo4,CPhoneNo5,ClientLogo,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,ContactNo)
 VALUES(@ClientName,@CAddress1,@CAddress2,@CCountry,@InCCountry,
 @CState,@CCity,@CLocality, @CPincode,@DomainName,@CPhoneNo1,@CPhoneNo2,@CPhoneNo3,
 @CPhoneNo4,@CPhoneNo5, @ClientLogo,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
 @ContactNo);
 
 SELECT Id,RowId FROM WRBHBMasterClientManagement WHERE Id=@@IDENTITY;
END
END