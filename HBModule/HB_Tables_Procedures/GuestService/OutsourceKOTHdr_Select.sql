-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_OutsourceKOTHdr_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_OutsourceKOTHdr_Select]
GO
/*=============================================
Author Name  : Anbu
Created Date : 01/08/14
Section  	 : Guest service
Purpose  	 : OutsourceKOTHdr
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_OutsourceKOTHdr_Select](@Id INT=NULL)
AS
BEGIN
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF
IF @Id = 0
    BEGIN
		SELECT PropertyName,CONVERT(varchar(100),Date,103) as Date,Id
		FROM WRBHBOutsourceKOTHdr 
		WHERE IsActive=1 AND IsDeleted = 0 
	END;        
IF @Id != 0
	
	BEGIN
    --drop table #Product
	CREATE TABLE #Product(ServiceItem NVARCHAR(200),PropertyId INT)
	Declare @Str1 NVARCHAR(100),@PropertyId Int
    --Hdr
	SELECT PropertyName,CONVERT(varchar(100),Date,103) as Date,PropertyId,Id,
	ISNULL(TotalAmount,0) AS TotalAmount
	FROM WRBHBOutsourceKOTHdr 
	WHERE IsActive = 1 AND IsDeleted = 0 AND Id=@Id;
   	--DETAILS
	SELECT ServiceItem,Quantity,Price,CAST(ISNULL(Amount,0)as DECIMAL(27,2)) AS Amount,Id,ItemId
	FROM WRBHBOutsourceKOTDtl
	WHERE IsActive = 1 AND IsDeleted = 0 AND OutsourceKOTHdrId =@Id;
	--ServiceItems
	SELECT ServiceItem,0 AS PropertyId  FROM WRBHBOutsourceServiceItems		
	WHERE IsActive=1 AND IsDeleted=0 
		
	    
	END
END

 