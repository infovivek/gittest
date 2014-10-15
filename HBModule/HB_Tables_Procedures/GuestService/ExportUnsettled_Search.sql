
GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ExportUnsettled_Search]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ExportUnsettled_Search]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (11/9/2014)>
Section  	: EXPORT UNSETTLED Search
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

CREATE PROCEDURE [dbo].[Sp_ExportUnsettled_Search]
(
@Id			BIGINT,
@FromDate	NVARCHAR(100),
@ToDate		NVARCHAR(100),
@UserId		BIGINT
)
 AS							
 BEGIN
 --NOTHING IS GIVEN
 IF @Id=0 AND @FromDate='' AND @ToDate=''
 BEGIN
	SELECT B.BookingCode AS BC,COH.ClientName AS Client,GuestName AS Guest,Property,Stay,COH.CheckOutDate,
	ChkOutTariffNetAmount AS Total,InVoiceNo FROM WRBHBChechkOutHdr COH
	JOIN WRBHBBooking B ON B.Id=COH.BookingId WHERE COH.Status='UnSettled' AND COH.IsActive=1 AND COH.IsDeleted=0
	ORDER BY B.BookingCode
 END
 --ONLY PROPERTY IS GIVEN
	IF @Id!=0 AND @FromDate='' AND @ToDate=''
	BEGIN
		SELECT B.BookingCode AS BC,COH.ClientName AS Client,GuestName AS Guest,Property,Stay,COH.CheckOutDate,
		ChkOutTariffNetAmount AS Total,InVoiceNo FROM WRBHBChechkOutHdr COH
		JOIN WRBHBBooking B ON B.Id=COH.BookingId
		 WHERE PropertyId=@Id AND COH.Status='UnSettled' AND COH.IsActive=1 AND COH.IsDeleted=0
		 ORDER BY B.BookingCode
	END
	
--ONLY DATE IS GIVEN
	IF @Id=0 AND @FromDate!='' AND @ToDate!=''
	BEGIN
		SELECT B.BookingCode AS BC,COH.ClientName AS Client,GuestName AS Guest,Property,Stay,COH.CheckOutDate,
		ChkOutTariffNetAmount AS Total,InVoiceNo FROM WRBHBChechkOutHdr COH
		JOIN WRBHBBooking B ON B.Id=COH.BookingId WHERE CONVERT(DATE,COH.CheckOutDate,103) BETWEEN 
		CONVERT(DATE,@FromDate,103)	AND	CONVERT(DATE,@ToDate,103) AND COH.Status='UnSettled' AND 
		COH.IsActive=1 AND COH.IsDeleted=0 ORDER BY B.BookingCode
	END	

--PROPERTY AND DATE BOTH ARE GIVEN
	IF @Id!=0 AND @FromDate!='' AND @ToDate!=''
	BEGIN
		SELECT B.BookingCode AS BC,COH.ClientName AS Client,GuestName AS Guest,Property,Stay,COH.CheckOutDate,ChkOutTariffNetAmount AS Total,
		InVoiceNo FROM WRBHBChechkOutHdr COH
		JOIN WRBHBBooking B ON B.Id=COH.BookingId WHERE PropertyId=@Id AND CONVERT(DATE,COH.CheckOutDate,103) 
		BETWEEN CONVERT(DATE,@FromDate,103) AND CONVERT(DATE,@ToDate,103) AND COH.Status='UnSettled' 
		AND COH.IsActive=1 AND COH.IsDeleted=0 ORDER BY B.BookingCode
	END	
 END