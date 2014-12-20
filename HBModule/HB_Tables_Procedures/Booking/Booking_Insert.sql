SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Booking_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_Booking_Insert]
GO   
/* 
Author Name : <Sakthi>
Created On 	: <Created Date (April/08/2014)  >
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
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Booking_Insert](
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
@UsrId BIGINT,
@Sales NVARCHAR(100),
@CRM NVARCHAR(100),
@ClientBookerId BIGINT,
@ClientBookerName NVARCHAR(100),
@ClientBookerEmail NVARCHAR(100),
@EmailtoGuest BIT,
@Note NVARCHAR(1000),
@SpecialRequirements NVARCHAR(1000),
@Status NVARCHAR(100),
@AMPM NVARCHAR(100),
@BookingLevel NVARCHAR(100),
@HRPolicy BIT,
@HRPolicyOverrideRemarks NVARCHAR(500),
@PropertyRefNo NVARCHAR(100))
AS
BEGIN
 DECLARE @Cnt INT,@TrackingNo BIGINT,@BookingCode BIGINT;
 DECLARE @ContactTypeId INT;
-- Tracking Code Begin
 IF @Status = 'RmdPty'
  BEGIN
   SET @Cnt=(SELECT COUNT(*) FROM WRBHBBooking WHERE IsDeleted=0 AND 
   IsActive=1 AND TrackingNo != 0);
   IF @Cnt = 0
    BEGIN
     SET @TrackingNo=1;
    END
   ELSE
    BEGIN
     SET @TrackingNo = (SELECT TOP 1 TrackingNo+1 FROM WRBHBBooking 
     WHERE IsDeleted=0 AND IsActive=1 AND TrackingNo != 0 
     ORDER BY Id DESC);
    END
   SET @BookingCode=0;
  END
 ELSE
  BEGIN
   SET @TrackingNo=0;SET @BookingCode=0;
  END
-- Tracking Code End
-- Client Contact Type Begin
 IF EXISTS (SELECT NULL FROM WRBHBClientContactType 
 WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Booker')
  BEGIN
   SELECT @ContactTypeId=Id FROM WRBHBClientContactType 
   WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Booker';
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBClientContactType(ContactType,CreatedBy,CreatedDate,
   ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
   VALUES('Booker',@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID());
   SET @ContactTypeId=@@IDENTITY;
  END
-- Client Contact Type End
-- New Booker Insert Begin
 IF @ClientBookerId = 0
  BEGIN
   IF EXISTS (SELECT NULL FROM WRBHBClientManagementAddNewClient
   WHERE IsActive=1 AND IsDeleted=0 AND CltmgntId=@ClientId AND
   Email=@ClientBookerEmail AND ContactType='Booker')
    BEGIN
     SELECT TOP 1 @ClientBookerId=Id,@ClientBookerName=FirstName,
     @ClientBookerEmail=Email FROM WRBHBClientManagementAddNewClient
     WHERE IsActive=1 AND IsDeleted=0 AND CltmgntId=@ClientId AND
     Email=@ClientBookerEmail AND ContactType='Booker';
    END
   ELSE
    BEGIN
     INSERT INTO WRBHBClientManagementAddNewClient(CltmgntId,ContactType,Title,
     FirstName,LastName,Gender,Designation,MobileNo,Email,AlternateEmail,
     CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
     ContactTypeId)
     VALUES(@ClientId,'Booker','Mr',@ClientBookerName,'','','Booker','',
     @ClientBookerEmail,'',@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
     @ContactTypeId);
     SET @ClientBookerId=@@IDENTITY;
    END
  END
-- Booking Insert Begin
 INSERT INTO WRBHBBooking(ClientId,GradeId,StateId,CityId,ClientName,
 CheckInDate,ExpectedChkInTime,CheckOutDate,GradeName,StateName,CityName,
 SpecialRequirements,BookingCode,CreatedBy,CreatedDate,ModifiedBy,
 ModifiedDate,IsActive,IsDeleted,RowId,Status,Sales,ClientBookerId,
 ClientBookerName,ClientBookerEmail,EmailtoGuest,Note,CRM,TrackingNo,
 AMPM,BookingLevel,PONo,CancelStatus,BookedDt,BookedUsrId,HRPolicy,
 HRPolicyOverrideRemarks,PropertyRefNo)
 VALUES(@ClientId,@GradeId,@StateId,@CityId,@ClientName,
 CONVERT(DATE,@CheckInDate,103),RTRIM(LTRIM(@ExpectedChkInTime)),
 CONVERT(DATE,@CheckOutDate,103),@GradeName,@StateName,@CityName,
 @SpecialRequirements,@BookingCode,@UsrId,GETDATE(),@UsrId,
 GETDATE(),1,0,NEWID(),@Status,@Sales,@ClientBookerId,
 @ClientBookerName,@ClientBookerEmail,@EmailtoGuest,@Note,@CRM,@TrackingNo,
 @AMPM,@BookingLevel,'','',GETDATE(),@UsrId,@HRPolicy,
 @HRPolicyOverrideRemarks,@PropertyRefNo);
 SELECT Id,RowId,BookingCode,ExpectedChkInTime FROM WRBHBBooking 
 WHERE Id = @@IDENTITY; 
-- Booking Insert End
END
GO
