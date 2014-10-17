-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BTCSubmission_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BTCSubmission_Help]
GO 
-- ===============================================================================
-- Author:Arunprasath
-- Create date:13-08-2014
-- ModifiedBy :-
-- ModifiedDate:-
-- Description:	BTCSubmission Help
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_BTCSubmission_Help](
@Action NVARCHAR(100),
@Param1	 BIGINT, 
@Param2	 BIGINT,
@Param3	 NVARCHAR(100),
@Param4	 NVARCHAR(100),
@Param5	 NVARCHAR(100),
@UserId  BIGINT)			
AS
BEGIN
IF @Action ='Client'
BEGIN
	SELECT ClientName ,Id ZId FROM WRBHBClientManagement
	WHERE IsActive=1 AND IsDeleted=0 
	--and id=1528 
	
	SELECT FirstName,Id ZId FROM WRBHBUser WHERE IsActive=1 AND IsDeleted=0
END	
IF @Action ='Not Submitted'
BEGIN
	SELECT CONVERT(NVARCHAR,H.DepositedDate,103) as SubmittedDate,D.InvoiceNo InvoiceNo,
	BillType InvoiceType,CONVERT(NVARCHAR,R.CreatedDate,103) InvoiceDate,
	'Not Submitted' CollectionStatus,D.ChkOutHdrId,D.ClientId,D.Id DepositDetilsId,
	0 Id,0 checks
	FROM WRBHBDeposits H
	JOIN WRBHBDepositsDlts D WITH(NOLOCK) ON D.DepHdrId=H.Id AND D.IsActive=1 AND D.IsDeleted=0
	AND D.ClientId=@Param1
	AND D.Id NOT IN(SELECT DepositDetilsId FROM WRBHBBTCSubmission WHERE IsActive=1 AND IsDeleted=0)
	JOIN dbo.WRBHBChechkOutHdr R WITH(NOLOCK) ON D.ChkOutHdrId=R.Id AND D.IsActive=1 AND D.IsDeleted=0
	WHERE H.Mode='BTC' AND  H.IsActive=1 AND H.IsDeleted=0 AND BTCTo='Commercial'
END	
IF @Action ='Submitted'
BEGIN
	CREATE TABLE #TEMPSubmitted(SubmittedDate NVARCHAR(100),InvoiceNo NVARCHAR(100),InvoiceType NVARCHAR(100),
	InvoiceDate NVARCHAR(100),CollectionStatus NVARCHAR(100),ChkOutHdrId NVARCHAR(100),ClientId BIGINT,
	DepositDetilsId BIGINT,Id BIGINT,checks BIGINT,Total DECIMAL(27,2))
	
	INSERT INTO #TEMPSubmitted(SubmittedDate,InvoiceNo,InvoiceType,InvoiceDate,CollectionStatus,ChkOutHdrId,
	ClientId,DepositDetilsId,Id,checks,Total)
	SELECT CONVERT(NVARCHAR,H.DepositedDate,103) as SubmittedDate,D.InvoiceNo InvoiceNo,
	BillType InvoiceType,CONVERT(NVARCHAR,R.CreatedDate,103) InvoiceDate,
	'Submitted' CollectionStatus,D.ChkOutHdrId,D.ClientId,D.Id DepositDetilsId,
	0 Id,0 checks,R.ChkOutTariffTotal 
	FROM WRBHBDeposits H
	JOIN WRBHBDepositsDlts D WITH(NOLOCK) ON D.DepHdrId=H.Id AND D.IsActive=1 AND D.IsDeleted=0
	AND D.ClientId=@Param1 
	AND D.Id NOT IN(SELECT DepositDetilsId FROM WRBHBBTCSubmission WHERE IsActive=1 AND IsDeleted=0)
	JOIN dbo.WRBHBChechkOutHdr R WITH(NOLOCK) ON D.ChkOutHdrId=R.Id AND D.IsActive=1 AND D.IsDeleted=0
	WHERE H.Mode='BTC' AND  H.IsActive=1 AND H.IsDeleted=0 AND BTCTo='Client'
	
	INSERT INTO #TEMPSubmitted(SubmittedDate,InvoiceNo,InvoiceType,InvoiceDate,CollectionStatus,ChkOutHdrId,
	ClientId,DepositDetilsId,Id,checks,Total)
	SELECT ISNULL(B.SubmittedOnDate,''),ISNULL(B.InvoiceNo,''),ISNULL(InvoiceType,''),CONVERT(NVARCHAR,InvoiceDate,103),CollectionStatus,ISNULL(ChkOutHdrId,0),
	ClientId,ISNULL(DepositDetilsId,0),B.Id,0,COH.ChkOutTariffTotal
	FROM WRBHBBTCSubmission B
	JOIN WRBHBChechkOutHdr COH ON B.ChkOutHdrId=COH.Id 
	WHERE B.IsActive=1 AND B.IsDeleted=0 AND CollectionStatus='Submitted' AND B.ClientId=@Param1
	
	SELECT SubmittedDate,InvoiceNo,InvoiceType,InvoiceDate,CollectionStatus,ChkOutHdrId,
	ClientId,DepositDetilsId,Id,checks,Total FROM #TEMPSubmitted	
END
IF @Action ='IMAGEUPLOAD'
BEGIN
	UPDATE WRBHBBTCSubmission SET FilePath=@Param3 WHERE Id=@Param1
END
END

--TRUNCATE TABLE WRBHBBTCSubmission