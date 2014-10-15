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
@BookingLevel NVARCHAR(100))
AS
BEGIN   
 UPDATE WRBHBBooking SET CheckInDate=CONVERT(DATE,@CheckInDate,103),
 CheckOutDate=CONVERT(DATE,@CheckOutDate,103),
 ExpectedChkInTime=@ExpectedChkInTime,--BookingCode=@BookingCode,
 SpecialRequirements=@SpecialRequirements,Status=@Status,AMPM=@AMPM,
 EmailtoGuest=@EmailtoGuest,BookedDt=GETDATE(),BookedUsrId=@UsrId
 WHERE Id=@Id;
 SELECT Id,RowId,BookingCode FROM WRBHBBooking WHERE Id=@Id;
 --select * from wrbhbbooking where Id=@Id;
END
GO