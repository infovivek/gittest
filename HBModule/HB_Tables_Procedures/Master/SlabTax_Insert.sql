 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SlabTax_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SlabTax_Insert]
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
CREATE PROCEDURE [dbo].[Sp_SlabTax_Insert]
(
@SlabFrom1		DECIMAL(27,2),
@SlabTo1		DECIMAL(27,2),
@SlabTax1		DECIMAL(27,2),
@SlabFrom2		DECIMAL(27,2),
@SlabTo2		DECIMAL(27,2),
@SlabTax2		DECIMAL(27,2),
@SlabFrom3		DECIMAL(27,2),
@SlabTo3		DECIMAL(27,2),
@SlabTax3		DECIMAL(27,2),
@SlabFrom4		DECIMAL(27,2),
@SlabTo4		DECIMAL(27,2),
@SlabTax4		DECIMAL(27,2),
@CreatedBy		BIGINT
) 
AS
BEGIN
INSERT INTO WRBHBTDSSlab(SlabFrom1,SlabTo1,SlabTax1,SlabFrom2,SlabTo2,SlabTax2,SlabFrom3,SlabTo3,SlabTax3,
				SlabFrom4,SlabTo4,SlabTax4,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
				
VALUES (@SlabFrom1,@SlabTo1,@SlabTax1,@SlabFrom2,@SlabTo2,@SlabTax2,@SlabFrom3,@SlabTo3,@SlabTax3,
				@SlabFrom4,@SlabTo4,@SlabTax4,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
		
 SELECT Id,RowId FROM WRBHBTDSSlab WHERE Id=@@IDENTITY;		
END		