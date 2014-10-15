SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MapPOAndVendorPaymentDtls_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_MapPOAndVendorPaymentDtls_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (05/02/2014)  >
Section  	: Apartment  Insert 
Purpose  	: Apartment  Insert
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
CREATE PROCEDURE [dbo].[Sp_MapPOAndVendorPaymentDtls_Insert](
@MapPOAndVendorPaymentHdrId		BIGINT,
@CheckOutId						BIGINT,
@BookingId						BIGINT,
@PONo							NVARCHAR(100),
@BookingCode					NVARCHAR(100),
@BillAmount						DECIMAL(27,2),
@POAmount						DECIMAL(27,2),
@Adjustment						DECIMAL(27,2),
@GuestName						nvarchar(100),
@StayDuration					NVARCHAR(100),
@CreatedBy						NVARCHAR(100)
) 
AS
BEGIN
 --INSERT
 
 INSERT INTO WRBHBMapPOAndVendorPaymentDtls(MapPOAndVendorPaymentHdrId,
 CheckOutId,BookingId,PONo,BookingCode,BillNumber,BillAmount,POAmount,Adjustment,
 GuestName,StayDuration,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId)
 VALUES(@MapPOAndVendorPaymentHdrId,@CheckOutId,@BookingId,@PONo,@BookingCode,
 '',@BillAmount,@POAmount,@Adjustment,@GuestName,@StayDuration,@CreatedBy,GETDATE(),@CreatedBy,
 GETDATE(),1,0,NEWID())
 
 SELECT Id,RowId,MapPOAndVendorPaymentHdrId FROM WRBHBMapPOAndVendorPaymentDtls WHERE Id=@@IDENTITY
 
 SELECT PropertyName,Id ZId FROM  WRBHBProperty 
 WHERE Category='External Property' AND IsDeleted=0 AND IsActive=1
 
END
GO
