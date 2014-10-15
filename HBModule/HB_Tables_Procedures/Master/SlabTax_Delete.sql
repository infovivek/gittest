SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SlabTax_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SlabTax_Delete]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (22/04/2014)  >
Section  	: SLAB TAX DELETE
Purpose  	: SLAB TAX DELETE
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
CREATE PROCEDURE Sp_SlabTax_Delete
(
@Id BIGINT,
@UserId BIGINT
)
AS
BEGIN
 UPDATE WRBHBTDSSlab SET IsActive=0,IsDeleted=1,ModifiedBy=@UserId,ModifiedDate=GETDATE() WHERE Id=@Id
END