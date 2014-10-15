 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SlabTax_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_SlabTax_Update]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: Tax Slab Update
		Purpose  	: LOGO Update
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
CREATE PROCEDURE [dbo].[Sp_SlabTax_Update]
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
@CreatedBy		BIGINT,
@Id				BIGINT
) 
AS
BEGIN
DECLARE @Identity INT
IF EXISTS (SELECT NULL FROM  WRBHBTDSSlab 
 WHERE SlabFrom1=@SlabFrom1 and SlabTo1=@SlabTo1 and SlabTax1=@SlabTax1 and 
	   SlabFrom2=@SlabFrom2 and SlabTo2=@SlabTo2 and SlabTax2=@SlabTax2 and
	   SlabFrom3=@SlabFrom3 and SlabTo3=@SlabTo3 and SlabTax3=@SlabTax3 and Id=@Id)
      -- BedTarif=@BedTariff and ApartTarif=@ApartTarif
       -- and Id=@Id)
BEGIN
UPDATE WRBHBTDSSlab SET SlabFrom1=@SlabFrom1,SlabTo1=@SlabTo1,SlabTax1=@SlabTax1,SlabFrom2=@SlabFrom2,
						SlabTo2=@SlabTo2,SlabTax2=@SlabTax2,SlabFrom3=@SlabFrom3,SlabTo3=@SlabTo3,
						SlabTax3=@SlabTax3,SlabFrom4=@SlabFrom4,SlabTo4=@SlabTo4,SlabTax4=@SlabTax4,
						ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() 
						WHERE Id=@Id AND  IsActive=1 AND IsDeleted=0 

--SET  @Identity=@@IDENTITY
SELECT Id,Rowid FROM WRBHBTDSSlab WHERE Id=@Id;	
END
ELSE
BEGIN
	
	UPDATE   WRBHBTDSSlab SET IsActive=0,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE()
	WHERE Id=@Id AND IsDeleted=0 ;

	INSERT INTO WRBHBTDSSlab(SlabFrom1,SlabTo1,SlabTax1,SlabFrom2,SlabTo2,SlabTax2,SlabFrom3,SlabTo3,SlabTax3,
				SlabFrom4,SlabTo4,SlabTax4,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@SlabFrom1,@SlabTo1,@SlabTax1,@SlabFrom2,@SlabTo2,@SlabTax2,@SlabFrom3,@SlabTo3,@SlabTax3,
				@SlabFrom4,@SlabTo4,@SlabTax4,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
	SET  @Identity=@@IDENTITY
	SELECT Id,Rowid FROM WRBHBTDSSlab WHERE Id=@@IDENTITY;	

END		
END