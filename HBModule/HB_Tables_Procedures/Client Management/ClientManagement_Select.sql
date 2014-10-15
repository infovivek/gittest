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
-- Description:	Client Management Select
-- =============================================
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_ClientManagement_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_ClientManagement_Select]
GO
CREATE PROCEDURE [dbo].[SP_ClientManagement_Select](@Id BIGINT)
AS
BEGIN
 IF @Id=0
  BEGIN
   SELECT C.ClientName,C1.ClientName AS MasterClient,C.Status,C.Id,C.CCity,C.CLocality 
   FROM WRBHBClientManagement C
   LEFT OUTER JOIN WRBHBMasterClientManagement C1 WITH(NOLOCK)ON 
   C.MasterClientId=C1.Id 
   WHERE C.IsActive=1 AND C.IsDeleted=0 ORDER BY C.ClientName;
  END
 IF @Id<>0
  BEGIN
   SELECT C.ClientName,C.CAddress1,C.CAddress2,C.CCountry,C.InCCountry,C.CState,
   C.CCity,C.CLocality,C.CPincode,C.DirectPay,C.BTC,C.CreditLimit,
   C.CreditPeriod,C.Status,C.BAddress1,C.BAddress2,C.BCountry,C.InBCountry,
   C.BState,C.BCity,C.BLocality,C.BPincode,C.DomainName,
   C.IndustryType,C.CPhoneNo1,C.CPhoneNo2,C.CPhoneNo3,C.CPhoneNo4,
   C.CPhoneNo5,ISNULL(C.ClientLogo,'') ClientLogo,C.Id,C.CreditPeriodNumber,C.ContactNo,
   ISNULL(C1.ClientName,'Select Master Client') AS 
   MasterClient,U1.UserName AS SalesExecutive,U2.UserName AS CRM,
   U3.UserName AS KeyAccountPerson,C.MasterClientId,
   C.SalesExecutiveId,C.CRMId,C.KeyAccountPersonId,C.ServiceCharge ,
   ISNULL(ImageName,'') AS ImageName
   FROM WRBHBClientManagement C
   LEFT OUTER JOIN WRBHBMasterClientManagement C1 WITH(NOLOCK)ON 
   C.MasterClientId=C1.Id 
   LEFT OUTER JOIN WRBHBUser U1 WITH(NOLOCK)ON 
   C.SalesExecutiveId=U1.Id
   LEFT OUTER JOIN WRBHBUser U2 WITH(NOLOCK)ON 
   C.CRMId=U2.Id
   LEFT OUTER JOIN WRBHBUser U3 WITH(NOLOCK)ON 
   C.KeyAccountPersonId=U3.Id
   WHERE C.Id=@Id;
   --
   SELECT ContactType EscalationLevel,Title,FirstName,LastName,MobileNo,Email,AlternateEmail,
   Id,Designation FROM WRBHBClientManagementAddNewClient WHERE CltmgntId=@Id AND
   IsDeleted=0 AND IsActive=1;
   --
   SELECT EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,ISNULL(Designation,'') Designation,
   Id FROM WRBHBClientManagementAddClientGuest WHERE CltmgntId=@Id AND
   IsDeleted=0 AND IsActive=1;
   --
   SELECT FieldName,FieldType,FieldValue,Mandatory,Visible,Id 
   FROM WRBHBClientManagementCustomFields WHERE CltmgntId=@Id AND
   IsDeleted=0 AND IsActive=1;
  END
END
GO
