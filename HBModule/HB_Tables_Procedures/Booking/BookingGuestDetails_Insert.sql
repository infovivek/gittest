SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BookingGuestDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_BookingGuestDetails_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: Booking Guest Details  Insert 
Purpose  	: Booking Guest Details  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	
sakthi          april 08 2014    Grade and Guest insert           
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_BookingGuestDetails_Insert](
@BookingId BIGINT,
@GuestId BIGINT,
@Designation NVARCHAR(100),
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@EmailId NVARCHAR(100),
@EmpCode NVARCHAR(100),
@UsrId BIGINT,
@Grade NVARCHAR(100),
@GradeId INT,
@Nationality NVARCHAR(100),
@MobileNo NVARCHAR(100),
@Title NVARCHAR(100)) 
AS
BEGIN
-- GET CLIENT ID
DECLARE @ClientId BIGINT;
SET @ClientId=(SELECT ClientId FROM WRBHBBooking WHERE Id=@BookingId);
-- GRADE INSERT
IF @GradeId = 0
 BEGIN
  IF @Grade != ''
   BEGIN
    DECLARE @Cnt INT;
    SET @Cnt=(SELECT COUNT(*) FROM WRBHBGradeMaster 
    WHERE Grade=@Grade AND IsDeleted=0 AND IsActive=1 AND 
    ClientId=@ClientId);
    --select @Cnt,@ClientId;return;
    IF @Cnt != 0
     BEGIN
      SET @GradeId=(SELECT TOP 1 Id FROM WRBHBGradeMaster WHERE IsDeleted=0 AND 
      IsActive=1 AND ClientId=@ClientId AND Grade=@Grade
      ORDER BY Id DESC);
     END
    ELSE
     BEGIN
      INSERT INTO WRBHBGradeMaster(Grade,CreatedBy,CreatedDate,ModifiedBy,
	  ModifiedDate,IsActive,IsDeleted,RowId,ClientId)
	  VALUES(@Grade,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
	  @ClientId);
	  SET @GradeId=@@IDENTITY;
     END
   END  
 END
-- CLIENT GUEST INSERT
IF @GuestId = 0
 BEGIN
  INSERT INTO WRBHBClientManagementAddClientGuest(CltmgntId,CompanyName,
  EmpCode,FirstName,LastName,Grade,GMobileNo,EmailId,RangeMin,RangeMax,
  CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId,
  Designation,GradeId,Nationality,Title)
  VALUES(@ClientId,'',@EmpCode,@FirstName,@LastName,@Grade,
  dbo.TRIM(@MobileNo),dbo.TRIM(@EmailId),
  0,0,@UsrId,GETDATE(),@UsrId,GETDATE(),1,0,NEWID(),
  @Designation,@GradeId,@Nationality,@Title);
  SET @GuestId=@@IDENTITY;
 END
ELSE
 BEGIN
  UPDATE WRBHBClientManagementAddClientGuest SET EmpCode=@EmpCode,
  FirstName=@FirstName,LastName=@LastName,
  GMobileNo=dbo.TRIM(@MobileNo),
  EmailId=dbo.TRIM(@EmailId),Designation=@Designation,Nationality=@Nationality,
  Title=@Title,Grade=@Grade,GradeId=@GradeId
  WHERE Id=@GuestId AND CltmgntId=@ClientId;
 END
--INSERT
 INSERT INTO WRBHBBookingGuestDetails(BookingId,GuestId,GradeId,EmpCode,
 Title,FirstName,LastName,Grade,Designation,EmailId,MobileNo,Nationality,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)
 VALUES(@BookingId,@GuestId,@GradeId,@EmpCode,@Title,@FirstName,@LastName,
 @Grade,@Designation,dbo.TRIM(@EmailId),dbo.TRIM(@MobileNo),@Nationality,@UsrId,
 GETDATE(),@UsrId,GETDATE(),1,0,NEWID());
 SELECT Id,RowId FROM WRBHBBookingGuestDetails WHERE Id=@@IDENTITY; 
END
GO
