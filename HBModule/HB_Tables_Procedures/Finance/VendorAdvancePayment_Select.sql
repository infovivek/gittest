SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_VendorAdvancePayment_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_VendorAdvancePayment_Select]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (11/03/2014)  >
		Section  	: Client Grade Value
		Purpose  	: ClientGradeValue SEARCH
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
CREATE PROCEDURE [dbo].[sp_VendorAdvancePayment_Select](  
@SelectId   BigInt,  
@Pram1      BigInt=NULL,   
@Pram2		NVARCHAR(100)=NULL,  
@UserId     BigInt  
)  
AS  
BEGIN  
IF @SelectId <> 0    
BEGIN   
DECLARE @ClientId BIGINT;   
	SELECT PropertyId,P.PropertyName,AdvanceAmount,
	CONVERT(NVARCHAR,DateofPayment,103) DateofPayment,Comments,BankName,ChequeNumber,
	CONVERT(NVARCHAR,IssueDate,103) IssueDate,PaymentMode,G.Id
	FROM dbo.WRBHBVendorAdvancePayment G
	LEFT OUTER JOIN WRBHBProperty P ON P.Id=G.PropertyId
	WHERE  G.Id=@SelectId   
END      
IF @SelectId=0  
BEGIN  
	SELECT P.PropertyName,g.AdvanceAmount,CONVERT(NVARCHAR,DateofPayment,103) DateofPayment,
	PaymentMode,G.Id 
	FROM dbo.WRBHBVendorAdvancePayment G
	LEFT OUTER JOIN WRBHBProperty P ON P.Id=G.PropertyId	
	WHERE  G.IsDeleted=0 ORDER BY Id DESC   
END   
END  