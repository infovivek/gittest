-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[SP_CheckIn_Select]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_CheckIn_Select]
GO
/*=============================================
Author Name  : shameem
Created Date : 22/05/2014 
Section  	 : Guest service
Purpose  	 : Checkin
Remarks  	 : <Remarks if any>                        
Reviewed By	 : <Reviewed By (Leave it blank)>
*******************************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CheckIn_Select](@Id INT=NULL)
AS
BEGIN
DECLARE @ResId INT;
IF @Id<>0 
BEGIN
SET @ResId=(SELECT BookingId FROM WRBHBCheckInHdr WHERE Id=@Id);
-- HEADER
SELECT RoomId,PropertyId,BookingId,
StateId,GuestId,RefGuestId,ChkInGuest,CheckInNo,convert(nvarchar(100),ArrivalDate,103) as ArrivalDate,ArrivalTime,
convert(nvarchar(100),ChkoutDate,103) as ChkoutDate,RoomNo,GuestName,ClientName,Property,MobileNo,
EmailId,Designation,Nationality,IdProof,ChkinAdvance,Tariff,
Direct,BTC,EmpCode,BookingCode,Image,Id,TimeType,Occupancy,RackTariffSingle,RackTariffDouble,
ApartmentId,BedId,ApartmentType,BedType,Type ,PropertyType,GuestImage,CheckStatus,SingleMarkupAmount,DoubleMarkupAmount,
ClientId,CityId,ServiceCharge
FROM WRBHBCheckInHdr WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id;
END

ELSE
 
BEGIN
SELECT ChkInGuest as GuestName,CheckInNo,Id,
CONVERT(VARCHAR(100),ArrivalDate,103) AS ArrivalDate 
FROM WRBHBCheckInHdr
WHERE IsDeleted=0 AND IsActive=1  ORDER BY Id DESC;
END

END
GO



