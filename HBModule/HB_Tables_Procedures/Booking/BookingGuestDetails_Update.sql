SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_BookingGuestDetails_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_BookingGuestDetails_Update]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (25/03/2014)  >
Section  	: Custom Fields Details  Insert 
Purpose  	: Custom Fields Details  Insert
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************
Sakthi                                              Grade, Nationality Added and Alterations	
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_BookingGuestDetails_Update](
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
@Title NVARCHAR(100),
@Id BIGINT)
AS
BEGIN
 UPDATE WRBHBBookingGuestDetails SET Designation=@Designation,
 FirstName=@FirstName,LastName=@LastName,EmailId=@EmailId,
 EmpCode=@EmpCode,ModifiedBy=@UsrId,ModifiedDate=GETDATE(),
 Nationality=@Nationality,MobileNo=dbo.TRIM(@MobileNo),
 Title=@Title WHERE Id=@Id;
 --
 UPDATE WRBHBClientManagementAddClientGuest SET EmpCode=@EmpCode,
 FirstName=@FirstName,LastName=@LastName,GMobileNo=dbo.TRIM(@MobileNo),
 EmailId=@EmailId,Designation=@Designation,Nationality=@Nationality,
 Title=@Title WHERE Id=@GuestId;
 ---
 SELECT Id,RowId FROM WRBHBBookingGuestDetails WHERE Id=@Id; 
END
GO
