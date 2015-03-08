SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorRequestDtl_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_VendorRequestDtl_Insert]
GO   
/* 
Author Name : Anbu
Created On 	: <Created Date (31/03/2014)  >
Section  	: VendorRequest INSERT
Purpose  	: PRODUCT INSERT
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
CREATE PROCEDURE [dbo].[Sp_VendorRequestDtl_Insert]
(
@VendorRequestHdrId INT,
@TempSave			nvarchar(100),
@ApartmentId		BIGINT,
@RoomId				BIGINT,
@FilePath			NVARCHAR(100),
@Description		NVARCHAR(max),
@BillNo				NVARCHAR(100),
@Amount				DECIMAL(27,2),
@CreatedBy			INT
)
AS
BEGIN
DECLARE @Identity int
IF(@FilePath !='')
	BEGIN
	IF(@Amount !=0)
	--IF(ISNULL(@TempSave,'') ='False')
	BEGIN
	
		UPDATE WRBHBVendorRequest SET Partial=1 WHERE Id=@VendorRequestHdrId
		
		INSERT INTO	WRBHBVendorRequestDtl (VendorRequestHdrId,ApartmentId,RoomId,Filepath,Description,
				BillNo,Amount,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES (@VendorRequestHdrId,@ApartmentId,@RoomId,@FilePath,@Description,@BillNo,@Amount,
				1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
		SET  @Identity=@@IDENTITY
	END		
	END
END			
----IF(ISNULL(@TempSave,'') ='False')
--	BEGIN
--		INSERT INTO	WRBHBVendorRequestDtl (VendorRequestHdrId,ApartmentId,RoomId,Filepath,Description,
--				BillNo,Amount,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
--		VALUES (@VendorRequestHdrId,@ApartmentId,@RoomId,@FilePath,@Description,@BillNo,@Amount,
--				1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
--		SET  @Identity=@@IDENTITY
		
--		--DELETE FROM WRBHBVendorRequestTempDtl  		
--		--WHERE VendorRequestHdrId=@VendorRequestHdrId
--	END
--	--ELSE
--	--BEGIN
--	--   INSERT INTO	WRBHBVendorRequestTempDtl (VendorRequestHdrId,ApartmentId,RoomId,Filepath,Description,
--	--				BillNo,Amount,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
--	--	VALUES (@VendorRequestHdrId,@ApartmentId,@RoomId,@FilePath,@Description,@BillNo,@Amount,
--	--			1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
--	--	SET  @Identity=@@IDENTITY
--	--END
--	END