
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExportUnsettled_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ExportUnsettled_Help]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (11/09/2014)  >
Section  	: EXPORT UNSETTLED HELP
Purpose  	: 
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

CREATE PROCEDURE [dbo].[Sp_ExportUnsettled_Help]
(
@Action NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT
)
 AS							
 BEGIN
	SELECT DISTINCT Property,PropertyId ZId from WRBHBChechkOutHdr where IsActive=1 AND IsDeleted=0
	AND PropertyId!='' ORDER BY Property
	
	SELECT B.BookingCode AS BC,COH.ClientName AS Client,GuestName AS Guest,Property,Stay,COH.CheckOutDate,
	ChkOutTariffNetAmount AS Total,InVoiceNo FROM WRBHBChechkOutHdr COH
	JOIN WRBHBBooking B ON B.Id=COH.BookingId WHERE COH.Status='UnSettled' AND COH.IsActive=1 AND COH.IsDeleted=0
	ORDER BY B.BookingCode
 END