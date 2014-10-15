SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BTCSubmission_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_BTCSubmission_Select]
GO   
/* 
Author Name : ARUN PRASATH K
Created On 	: <Created Date (19/01/2014)>
Section  	: BTCSubmission
Purpose  	: SEARCH
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
CREATE PROCEDURE [Sp_BTCSubmission_Select]
(
@Id			BIGINT,
@Param1		NVARCHAR(100),
@Param2		NVARCHAR(100),
@Param3		BIGINT,
@UserId		BIGINT
)
AS
BEGIN
IF(@Id=0)
BEGIN
   SELECT C.ClientName,CONVERT(NVARCHAR,SubmittedOnDate,103) SubmittedOn,CONVERT(NVARCHAR,ExpectedDate,103) Expected,
   PhysicalInvoice,CollectionStatus ,D.Id
   FROM WRBHBBTCSubmission D 
   JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id=D.ClientId AND C.IsActive=1 AND C.IsDeleted=0
   WHERE D.IsActive=1 AND D.IsDeleted=0  
END
ELSE
BEGIN
	 SELECT C.ClientName,CONVERT(NVARCHAR,SubmittedOnDate,103) SubmittedOn,
	 CONVERT(NVARCHAR,ExpectedDate,103) Expected,PhysicalInvoice,CollectionStatus,
	 Acknowledged,Comments,D.Id,d.ClientId,FileNames,ChkOutHdrId,InvoiceNo,InvoiceType,InvoiceDate,DepositDetilsId
     FROM WRBHBBTCSubmission D 
     JOIN WRBHBClientManagement C WITH(NOLOCK) ON C.Id=D.ClientId AND C.IsActive=1 AND C.IsDeleted=0
     WHERE D.IsActive=1 AND D.IsDeleted=0  AND D.Id=@Id     
END
END

