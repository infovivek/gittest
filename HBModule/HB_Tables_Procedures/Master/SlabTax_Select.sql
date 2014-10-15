 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SlabTax_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SlabTax_Select]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: COMPANY MASTER INSERT
		Purpose  	: LOGO INSERT
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
CREATE PROCEDURE [dbo].[Sp_SlabTax_Select]
(
@Id				BIGINT,
@UserId			BIGINT
) 
AS
BEGIN
IF(@Id=0)
BEGIN
SELECT SlabFrom1,SlabTo1,SlabTax1,--SlabFrom2,SlabTo2,SlabTax2,SlabFrom3,SlabTo3,SlabTax3,SlabFrom4,SlabTo4,SlabTax4,
				Id FROM WRBHBTDSSlab WHERE IsActive=1 AND IsDeleted=0 
END
ELSE
BEGIN
	SELECT SlabFrom1,SlabTo1,SlabTax1,SlabFrom2,SlabTo2,SlabTax2,SlabFrom3,SlabTo3,SlabTax3,
				SlabFrom4,SlabTo4,SlabTax4,Id FROM WRBHBTDSSlab WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id
				
	SELECT SlabFrom1,SlabTo1,SlabTax1,SlabFrom2,SlabTo2,SlabTax2,SlabFrom3,SlabTo3,SlabTax3,
				SlabFrom4,SlabTo4,SlabTax4,Id FROM WRBHBTDSSlab WHERE IsActive=0 AND IsDeleted=0 AND Id=@Id			
END		
END		