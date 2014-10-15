SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Booking_Delete]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Booking_Delete]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (25/03/2014)  >
		Section  	: Booking Delete
		Purpose  	: Booking Delete
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
CREATE PROCEDURE [dbo].[Sp_Booking_Delete](
@Id   			 BigInt, 
@Pram1			 NVARCHAR(100)=NULL, 
@Pram2		     BigInt, 
@UserId          BigInt
)
AS
BEGIN   
			UPDATE WRBHBBooking SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  Id =@Id; 
			
			UPDATE dbo.WRBHBBookingCustomFieldsDetails SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  BookingId=@Id; 
			
			UPDATE dbo.WRBHBBookingGuestDetails SET ModifiedBy=@UserId,ModifiedDate=GETDATE(),IsDeleted=1,IsActive=0
			WHERE  BookingId =@Id; 			
			 
END