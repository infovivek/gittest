-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_KOTEnrty_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_KOTEnrty_Select]
GO
/*=============================================
Author Name  : shameem
Created Date : 08/05/14
Section  	 : Guest service
Purpose  	 : KOT Entry
*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
Name			Date			Signature			Description of Changes
********************************************************************************************************	

*******************************************************************************************************
-- =============================================*/

CREATE PROCEDURE [dbo].[SP_KOTEnrty_Select](@Id INT=NULL)
AS
BEGIN
IF @Id = 0
    BEGIN
    select h.PropertyName,CONVERT(varchar(100),h.Date,103) as Date,h.Id
	from WRBHBKOTHdr h
	left outer join WRBHBKOTDtls d on h.Id = d.KOTEntryHdrId
	where h.IsActive=1 and h.IsDeleted = 0 and
	d.IsActive =1 and d.IsDeleted = 0
	END;        
IF @Id != 0
    BEGIN
	SELECT PropertyName,CONVERT(varchar(100),Date,103) as Date,PropertyId,BookingId,Id
	FROM WRBHBKOTHdr 
	WHERE IsActive = 1 and IsDeleted = 0 and Id=@Id;

	--DETAILS
	select KOTEntryHdrId,PropertyId,BookingId,BookingCode,GuestName,RoomNo,
	BreakfastVeg,BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,Id
	from WRBHBKOTDtls
	where IsActive = 1 and IsDeleted = 0 and KOTEntryHdrId = @Id;
	
	--USER
	SELECT KOTEntryHdrId,UserName,UserId,
	BreakfastVeg,BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg,Id
	from WRBHBKOTUser
	where IsActive = 1 and IsDeleted = 0 and KOTEntryHdrId = @Id;
	
	
	END

END
GO




 