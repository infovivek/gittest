
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_BookingPropertyAssingedGuest_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Update]
GO   
/* 
Author Name : Arun
Created On 	: (28/05/2014)  >
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
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_BookingPropertyAssingedGuest_Update](
@BookingId BIGINT,
@FirstName NVARCHAR(100),
@LastName NVARCHAR(100),
@GuestId	BIGINT,
@CheckInDT NVARCHAR(100),
@CheckOutDT NVARCHAR(100),
@TariffPaymentMode NVARCHAR(100),
@ServicePaymentMode NVARCHAR(100),
@Id BIGINT,
@Remarks NVARCHAR(100),
@UserId  BIGINT,
@DateChangeFlag NVARCHAR(100),
@OldGuestId BIGINT
)
AS
BEGIN
 ---
 DECLARE @BookingLevel NVARCHAR(100),@PROPERTYID BIGINT,@RoomId BIGINT,@Count BIGINT;
 
 SELECT @BookingLevel=BookingLevel FROM WRBHBBooking WHERE Id=@BookingId
 
 
 IF @BookingLevel='Room'
 BEGIN
	UPDATE WRBHBBookingPropertyAssingedGuest SET 
	ChkInDt=CONVERT(DATE,@CheckInDT,103),
	ChkOutDt=CONVERT(DATE,@CheckOutDT,103),
	TariffPaymentMode=@TariffPaymentMode,
	ServicePaymentMode=@ServicePaymentMode,
	CancelModifiedFlag=1,
	CancelRemarks=@Remarks,
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()	
	WHERE Id=@Id AND BookingId=@BookingId;
	
	UPDATE WRBHBBookingGuestDetails SET
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()	
	WHERE GuestId=@OldGuestId AND BookingId=@BookingId;
	
	SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBookingPropertyAssingedGuest
	WHERE  BookingId=@BookingId 
END	
IF @BookingLevel='Bed'
 BEGIN
	UPDATE WRBHBBedBookingPropertyAssingedGuest SET 
	ChkInDt=CONVERT(DATE,@CheckInDT,103),
	ChkOutDt=CONVERT(DATE,@CheckOutDT,103),
	TariffPaymentMode=@TariffPaymentMode,
	ServicePaymentMode=@ServicePaymentMode,
	CancelModifiedFlag=1,
	CancelRemarks=@Remarks,
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()	
	WHERE Id=@Id AND BookingId=@BookingId;
	
	UPDATE WRBHBBookingGuestDetails SET
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()	
	WHERE GuestId=@OldGuestId AND BookingId=@BookingId;
	
	SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBBedBookingPropertyAssingedGuest
	WHERE  BookingId=@BookingId 
END	
IF @BookingLevel='Apartment'
 BEGIN
	UPDATE WRBHBApartmentBookingPropertyAssingedGuest SET 
	ChkInDt=CONVERT(DATE,@CheckInDT,103),
	ChkOutDt=CONVERT(DATE,@CheckOutDT,103),
	TariffPaymentMode=@TariffPaymentMode,
	ServicePaymentMode=@ServicePaymentMode,
	CancelModifiedFlag=1,
	CancelRemarks=@Remarks,
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()	
	WHERE Id=@Id AND BookingId=@BookingId;
	
	UPDATE WRBHBBookingGuestDetails SET
	LastName=@LastName,
	FirstName=@FirstName,
	GuestId=@GuestId,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()
	WHERE GuestId=@OldGuestId AND BookingId=@BookingId;
	
	
	SELECT TOP 1 @PROPERTYID=BookingPropertyId FROM WRBHBApartmentBookingPropertyAssingedGuest
	WHERE  BookingId=@BookingId 
END	
	
	
	---TABLE 0
    SELECT B.BookingCode,U.Email,B.Status,b.CancelRemarks,B.ClientName,
    U.UserName,U.MobileNumber,
    DATENAME(weekday, GETDATE())+','+CONVERT(VARCHAR(12), GETDATE(), 107),
    CONVERT(VARCHAR(12),B.CreatedDate,103) BookingDate,BookingLevel,EmailtoGuest
    FROM WRBHBBooking B
	LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=@UserId
	WHERE B.Id=@BookingId
	
	---TABLE 1
	SELECT Logo FROM dbo.WRBHBCompanyMaster;
	
	
	
	---TABLE 2
	IF ISNULL(@PROPERTYID,0)=0
	BEGIN
		SELECT '' AS PropertyName,'' AS ADDRESS
	END
	ELSE
	BEGIN		
		SELECT ISNULL(PropertyName,''),bp.PropertyName+','+Propertaddress+','+L.Locality+','+C.CityName+','+S.StateName+' - '+Postal AS ADDRESS
		FROM WRBHBProperty BP
		LEFT OUTER JOIN WRBHBLocality L WITH(NOLOCK) ON L.Id=BP.LocalityId
		LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON L.CityId=C.Id
		LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON S.Id=C.StateId 
		WHERE BP.Id=@PROPERTYID
	END
	
	---TABLE 3
	SELECT BP.PropertyName, ISNULL(PU.UserName,'')UserName,
	ISNULL(U.Email,'')Email,ISNULL(U.MobileNumber,'')PhoneNumber,
	ISNULL(BP.Email,'') AS Email
	FROM dbo.WRBHBProperty BP
	LEFT OUTER JOIN WRBHBPropertyUsers PU WITH(NOLOCK) ON BP.Id =PU.PropertyId 
	AND PU.IsActive=1 AND PU.IsDeleted=0 AND UserType in('Resident Managers','Assistant Resident Managers')	
	LEFT OUTER JOIN WRBHBUser U  WITH(NOLOCK) ON  U.Id=PU.UserId
	WHERE BP.Id=@PROPERTYID  AND BP.IsActive=1 AND BP.IsDeleted=0 
	
	-- Dataset Table 4
	SELECT ClientBookerEmail FROM WRBHBBooking WHERE Id=@BookingId;

	-- dataset table 5
	SELECT EmailId FROM WRBHBBookingGuestDetails WHERE BookingId=@BookingId;

	-- dataset table 6
	SELECT Email FROM dbo.WRBHBClientManagementAddNewClient 
	WHERE IsActive=1 AND IsDeleted=0 AND ContactType='Extra C C' AND
	CltmgntId=(SELECT ClientId FROM WRBHBBooking B WHERE B.Id=@BookingId);
	

	
	--dataset table 7
	SELECT ClientLogo FROM dbo.WRBHBClientManagement WHERE Id=(SELECT B.ClientId FROM WRBHBBooking B
	JOIN  WRBHBClientwisePricingModel P ON B.ClientId=P.ClientId 
	AND P.IsActive=1 AND P.IsDeleted=0
	WHERE B.Id=@BookingId)
	
END	
