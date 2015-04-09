SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Booking_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_Booking_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: Booking  Insert 
Purpose  	: Booking  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************
Sakthi                                              Fields Added and Alterations	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Booking_Update](
@ClientId BIGINT,
@GradeId BIGINT,
@StateId BIGINT,
@CityId BIGINT,
@ClientName NVARCHAR(100),
@CheckInDate NVARCHAR(100),
@ExpectedChkInTime NVARCHAR(100),
@CheckOutDate NVARCHAR(100),
@GradeName NVARCHAR(100),
@StateName NVARCHAR(100),
@CityName NVARCHAR(100),
@SpecialRequirements NVARCHAR(1000),
@UsrId BIGINT,
@Sales NVARCHAR(100),
@CRM NVARCHAR(100),
@ClientBookerId BIGINT,
@ClientBookerName NVARCHAR(100),
@ClientBookerEmail NVARCHAR(100),
@EmailtoGuest BIT,
@Id BIGINT,
@Note NVARCHAR(1000),
@Status NVARCHAR(100),
@AMPM NVARCHAR(100),
@BookingLevel NVARCHAR(100),
@ExtraCCEmail NVARCHAR(1000),
@HRPolicy BIT,
@HRPolicyOverrideRemarks NVARCHAR(500),
@PropertyRefNo NVARCHAR(100),
@PaymentFlag BIT)
AS
BEGIN
 DECLARE @HBStay NVARCHAR(100) = '';
 IF @PropertyRefNo = 'StayCorporateHB'
  BEGIN
   SET @HBStay = 'StayCorporateHB';
   SET @PropertyRefNo = '';
  END
 ELSE
  BEGIN
   SET @HBStay = '';
  END
 --
 IF @BookingLevel = 'Room'
  BEGIN
   IF @PaymentFlag = 1 BEGIN SET @PaymentFlag = 0 END
   ELSE BEGIN SET @PaymentFlag = 1 END
  END
 --   
 UPDATE WRBHBBooking SET CheckInDate = CONVERT(DATE,@CheckInDate,103),
 CheckOutDate = CONVERT(DATE,@CheckOutDate,103),
 ExpectedChkInTime = @ExpectedChkInTime,Status = @Status,AMPM = @AMPM,
 SpecialRequirements = @SpecialRequirements,BookedDt = GETDATE(),
 BookedUsrId = @UsrId,ExtraCCEmail = @ExtraCCEmail,EmailtoGuest = 1,
 PropertyRefNo = @PropertyRefNo,PaymentFlag = @PaymentFlag,
 HBStay = @HBStay WHERE Id = @Id;
 SELECT Id,RowId,BookingCode FROM WRBHBBooking WHERE Id = @Id;
 IF @PaymentFlag = 0
  BEGIN
   UPDATE WRBHBBooking SET Status = 'Payment' WHERE Id = @Id;
  END
END
GO