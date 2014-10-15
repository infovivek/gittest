
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_MasterClientManagement_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_MasterClientManagement_Select]
GO
CREATE PROCEDURE [dbo].[SP_MasterClientManagement_Select](@Id BIGINT)
AS
BEGIN
IF @Id=0
  BEGIN
   SELECT C.ClientName,C.CCity AS City,C.CLocality AS Locality,C.Id 
   FROM WRBHBMasterClientManagement c  
   WHERE C.IsActive=1 AND C.IsDeleted=0 ORDER BY C.Id desc;
  END
  IF @Id<>0
  BEGIN
   SELECT C.ClientName,C.CAddress1,C.CAddress2,C.CCountry,C.CState,
   C.CCity,C.CLocality,C.CPincode,C.DomainName,
   C.CPhoneNo1,C.CPhoneNo2,C.CPhoneNo3,C.CPhoneNo4,
   C.CPhoneNo5,C.ClientLogo,C.Id,C.ContactNo,InCCountry
   FROM WRBHBMasterClientManagement C
   WHERE Id=@Id
  
   --
   SELECT ContactType,Title,FirstName,LastName,MobileNo,Email,AlternateEmail,
   Id FROM WRBHBClientManagementAddNewClient WHERE CltmgntId=@Id AND
   IsDeleted=0 AND IsActive=1;
   --
   --
   END
END
GO
