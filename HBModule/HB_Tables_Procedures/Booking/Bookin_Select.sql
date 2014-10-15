SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Booking_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_Booking_Select]
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
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_Booking_Select](@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100),@Id1 BIGINT,@Id2 BIGINT,@UsrId BIGINT)  
AS  
BEGIN  
 IF @Id1 <> 0  
  BEGIN  
		SELECT A.ClientId,ISNULL(ClientName,'') ClientName,A.GradeId,ISNULL(CG.Grade,'') Grade,
		A.CityId,ISNULL(C.CityName,'') CityName,A.StateId,ISNULL(S.StateName,'') StateName,
		A.PropertyId,ISNULL(B.PropertyName,'') PropertyName,SSPCodeId,SSPCode,
		CONVERT(NVARCHAR,CheckInDate,103) CheckInDate,CONVERT(NVARCHAR,CheckOutDate,103) CheckOutDate,
		Occupancy,A.Id 
		FROM WRBHBBooking A
		LEFT OUTER JOIN dbo.WRBHBProperty  B WITH(NOLOCK)  ON  A.PropertyId=B.Id
		LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON A.StateId=S.Id  
		LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON A.CityId=C.Id 
		LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK) ON  CM.Id=A.ClientId
		LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK) ON CG.Id=A.GradeId
		WHERE A.Id=@Id1;  
		
		SELECT BookingId,GuestId,Designation,FirstName,
		LastName,EmailId,EmpCode,Id FROM WRBHBBookingGuestDetails
		WHERE BookingId=@Id1;
		
		SELECT BookingId,CustomFieldsId,CustomFields,
		CustomFieldsValue,Mandatory,Id FROM WRBHBBookingCustomFieldsDetails
		WHERE BookingId=@Id1;
		
		
 END  
 IF @Id1 = 0  
  BEGIN  
		SELECT ISNULL(ClientName,'') ClientName,ISNULL(C.CityName,'') CityName,ISNULL(S.StateName,'') StateName,
		ISNULL(B.PropertyName,'') PropertyName,
		CONVERT(NVARCHAR,CheckInDate,103) CheckInDate,CONVERT(NVARCHAR,CheckOutDate,103) CheckOutDate,
		Occupancy,A.Id 
		FROM WRBHBBooking A
		LEFT OUTER JOIN dbo.WRBHBProperty  B WITH(NOLOCK)  ON  A.PropertyId=B.Id
		LEFT OUTER JOIN WRBHBState S WITH(NOLOCK) ON A.StateId=S.Id  
		LEFT OUTER JOIN WRBHBCity C WITH(NOLOCK) ON A.CityId=C.Id 
		LEFT OUTER JOIN WRBHBClientManagement CM WITH(NOLOCK) ON  CM.Id=A.ClientId
		LEFT OUTER JOIN WRBHBClientManagementAddClientGuest CG WITH(NOLOCK) ON CG.Id=A.GradeId
		WHERE A.IsDeleted=0 AND A.IsActive=1;   
  END   
END  