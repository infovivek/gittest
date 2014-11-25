SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorRequest_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_VendorRequest_Insert]
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
CREATE PROCEDURE [dbo].[Sp_VendorRequest_Insert]
(
@PropertyId		BIGINT,
@Property		NVARCHAR(100),
@CategoryId		BIGINT,
@Category		NVARCHAR(100),
@VendorId		BIGINT,
@VendorName    	NVARCHAR(100),
@Service	    NVARCHAR(100),
@Type			NVARCHAR(100),
@ApartmentId	BIGINT,
@RoomId			BIGINT,
@Date			NVARCHAR(100),
@Amount			DECIMAL(27,2),
@BillNo			NVARCHAR(100),
@Duedate		NVARCHAR(100),
@VendorBill		NVARCHAR(100),
@Description	NVARCHAR(max),
@Temp			Bit,
@CreatedBy		INT,
@Status			NVARCHAR(100),
@UserId			BIGINT
)
AS
BEGIN
DECLARE @Identity int
IF(ISNULL(@Temp,'') !='false')
BEGIN
INSERT INTO	WRBHBVendorRequestTemp (PropertyId,Property,CategoryId,Category,VendorId,VendorName,Service,Type,
			ApartmentId,RoomId,Date,Amount,BillNo,Duedate,VendorBill,Description,
			IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Status,UserId,Flag,Partial)
	VALUES (@PropertyId,@Property,@CategoryId,@Category,@VendorId,@VendorName,@Service,@Type,@ApartmentId,
			@RoomId,Convert(date,@Date,103),@Amount,@BillNo,@Duedate,@VendorBill,
			@Description,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),
			NEWID(),@Status,@UserId,1,0)
	
	SET  @Identity=@@IDENTITY
	SELECT Id,Rowid,@Temp FROM WRBHBVendorRequest WHERE Id=@Identity;
END
ELSE
BEGIN
INSERT INTO	WRBHBVendorRequest (PropertyId,Property,CategoryId,Category,VendorId,VendorName,Service,Type,
			ApartmentId,RoomId,Date,Amount,BillNo,Duedate,VendorBill,Description,
			IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Status,UserId,Flag,Partial)
	VALUES (@PropertyId,@Property,@CategoryId,@Category,@VendorId,@VendorName,@Service,@Type,@ApartmentId,
			@RoomId,Convert(date,@Date,103),@Amount,@BillNo,@Duedate,@VendorBill,
			@Description,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),
			NEWID(),@Status,@UserId,1,0)
			
			SET  @Identity=@@IDENTITY
			SELECT Id,Rowid,'false' FROM WRBHBVendorRequest WHERE Id=@Identity;
END
END			

 