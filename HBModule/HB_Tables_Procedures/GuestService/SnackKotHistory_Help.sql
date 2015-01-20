SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_SnackKOTHistory_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_SnackKOTHistory_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (25/06/2014)  >
Section  	: SP_SnackKOTHistory Help
Purpose  	: SP_SnackKOTHistory Help
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

CREATE PROCEDURE dbo.[SP_SnackKOTHistory_Help]
(
@Action NVARCHAR(100),
@PropertyId		BIGINT,
@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100),
@GuestId       BIGINT,
@BookingId       BIGINT)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
 	   --Property
		SELECT DISTINCT P.PropertyName AS Property,P.Id AS PropertyId
		FROM WRBHBCheckInHdr C
		JOIN WRBHBProperty  P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		JOIN WRBHBPropertyUsers PU ON P.Id=PU.PropertyId AND PU.IsActive=1 AND PU.IsDeleted=0
		WHERE C.IsActive=1 AND C.IsDeleted=0 AND  P.Category IN('Internal Property','Managed G H')
		AND PU.UserId=@PropertyId
		ORDER BY P.PropertyName ASC
		
		SELECT DISTINCT CH.BookingId,CH.ChkoutDate,'Guest' AS Type,KH.GuestName,CH.RoomNo,
	    SUM(CAST(ISNULL(KD.Amount,0)as DECIMAL(27,2))) AS Amount,'Raised' as Status,
	    KH.GuestId
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KH.GuestId=CH.GuestId AND CH.IsActive=1 AND CH.IsDeleted=0
		group by CH.BookingId,
		KH.GuestName,CH.RoomNo,KH.GuestId,CH.ChkoutDate
		
		
 END
  IF @Action='SNACKKOTDETAILS'
  BEGIN
        CREATE TABLE  #Guest(BookingId INT,Date NVARCHAR(100),Type NVARCHAR(100),Name NVARCHAR(100),
		Apartment NVARCHAR(100),Amount DECIMAL(27,2),Status NVARCHAR(100),GuestId INT)
  BEGIN
        
        INSERT INTO #Guest(BookingId,Date,Type,Name,Apartment,Amount,Status,GuestId)
	    	         
	    SELECT DISTINCT CH.BookingId,CONVERT(NVARCHAR,KH.Date,105) ,'Guest' AS Type,KH.GuestName,CH.RoomNo,
	    (CAST(ISNULL(KD.Amount,0)as DECIMAL(27,2))) AS Amount,'Raised' as Status,
	    KH.GuestId
		FROM WRBHBNewKOTEntryHdr KH
		JOIN WRBHBNewKOTEntryDtl KD ON KH.Id=KD.NewKOTEntryHdrId AND KD.IsActive=1 AND KD.IsDeleted=0
		JOIN WRBHBCheckInHdr CH ON KH.GuestId=CH.GuestId AND KH.CheckInId=CH.Id
		AND CH.IsActive=1 AND CH.IsDeleted=0
		WHERE KH.PropertyId=@PropertyId  AND KH.IsActive=1 And KH.IsDeleted=0
		AND KH.Date BETWEEN CONVERT(Date,@Str1 ,103)
		AND CONVERT(Date,@Str2,103) AND ISNULL(KH.ChkoutServiceFlag,0)!=0
				 
		END	
  	
       SELECT  Date AS Date,Type,
       BookingId,GuestId,Name,Apartment,SUM(Amount) AS Amount,Status
       FROM #Guest 
       Group by Date,Type,BookingId,GuestId,Name,Apartment,Status
      
  END
 IF @Action='Guest'
	BEGIN
		SELECT DISTINCT GuestId,PropertyId FROM WRBHBNewKOTEntryHdr
		WHERE PropertyId=@PropertyId
	END
 
  IF @Action='Print'
	BEGIN
	
	CREATE TABLE #TaxAmount(ServiceTax DECIMAL(27,2),VAT DECIMAL(27,2),Cess DECIMAL(27,2),HECess DECIMAL(27,2),
	PropertyId INT)
	INSERT INTO #TaxAmount(ServiceTax,VAT,Cess,HECess,PropertyId)
	
	SELECT T.RestaurantST,T.VAT,T.Cess,T.HECess,P.Id
	FROM WRBHBTaxMaster T
	JOIN WRBHBState S ON T.StateId=S.Id AND S.IsActive=1
	JOIN WRBHBProperty P ON S.Id=P.StateId AND P.IsActive=1 AND P.IsDeleted=0
	WHERE P.Id=@PropertyId AND T.IsActive=1 AND T.IsDeleted=0
	
	
		
	CREATE TABLE #Service(ServiceItem NVARCHAR(100),Quantity INT,Price DECIMAL(27,2),Amount DECIMAL(27,2),
	PropertyId INT)
	INSERT INTO #Service(ServiceItem,Quantity,Price,Amount,PropertyId)
	
	SELECT ServiceItem,SUM(Quantity) AS Quantity,Price,SUM(Quantity)*(Price) AS Amount,H.PropertyId
	FROM  WRBHBNewKOTEntryHdr H
	JOIN WRBHBNewKOTEntryDtl D ON H.Id=D.NewKOTEntryHdrId AND D.IsActive = 1 AND D.IsDeleted=0
	WHERE H.GuestId =@GuestId  AND H.PropertyId=@PropertyId AND Price !=0 
	AND ISNULL(H.ChkoutServiceFlag,0)!=0 AND H.IsActive=1 AND H.IsDeleted=0
	AND H.BookingId=@BookingId AND H.Date=@Str2
	group by  ServiceItem,Price,PropertyId
	
	INSERT INTO #Service(ServiceItem,Quantity,Price,Amount,PropertyId)
	
	SELECT ServiceItem,SUM(Quantity) AS Quantity,Price,Amount AS Amount,H.PropertyId
	FROM  WRBHBNewKOTEntryHdr H
	JOIN WRBHBNewKOTEntryDtl D  ON D.NewKOTEntryHdrId=H.Id AND H.IsActive = 1 AND H.IsDeleted=0
	WHERE H.GuestId =@GuestId  AND H.PropertyId=@PropertyId 
	AND ISNULL(H.ChkoutServiceFlag,0)!=0  AND H.IsActive=1 AND H.IsDeleted=0
	AND H.BookingId=@BookingId  AND Price =0 AND H.Date=@Str2
	group by  ServiceItem,Price,PropertyId,Amount
	
	CREATE TABLE #Calc(TotalAmount DECIMAL(27,2),ServiceTax DECIMAL(27,2),
	VAT DECIMAL(27,2),Cess DECIMAL(27,2),HECess DECIMAL(27,2),PropertyId INT)
	
	INSERT INTO #Calc(TotalAmount,ServiceTax,VAT,Cess,HECess,PropertyId) 
	SELECT SUM(S.Amount) AS TotalAmount,SUM(S.Amount)*T.ServiceTax/100 AS ServiceTax,SUM(S.Amount)*T.VAT/100 AS VAT,
	SUM(S.Amount)*T.Cess/100 AS Cess,SUM(S.Amount)*T.HECess/100 AS HECess,S.PropertyId
	FROM #Service S
	JOIN #TaxAmount T ON S.PropertyId=T.PropertyId
	group by T.ServiceTax,T.VAT,T.Cess,T.HECess,S.PropertyId
	
	
	DECLARE @CompanyName VARCHAR(100),@Address NVARCHAR(100),@Date NVARCHAR(100);
	SET @CompanyName=(SELECT LegalCompanyName FROM WRBHBCompanyMaster)
	SET @Address=(SELECT Address FROM WRBHBCompanyMaster)
	
	SELECT DISTINCT H.GuestName as Name,--CONVERT(NVARCHAR,H.Date,105) AS ArrivalDate,
	H.RoomNo,CH.BookingId,H.ClientName,CONVERT(NVARCHAR,CH.ArrivalDate,103) AS ChkInDt,
	CONVERT(NVARCHAR,CH.ChkOutDate,103) AS ChkOutDt,S.ServiceItem AS Item,S.Quantity,S.Price,S.Amount,
	C.TotalAmount,C.ServiceTax AS SerivceTax,C.VAT AS Vat,C.Cess,HECess AS HCess,
	(ISNULL(C.TotalAmount,0)+ISNULL(C.ServiceTax,0)+ISNULL(C.VAT,0)+ISNULL(C.Cess,0)+ISNULL(C.HECess,0))
	AS NetAmount,P.PropertyName,P.Propertaddress AS Propertyaddress,
	@CompanyName AS CompanyName,@Address As CompanyAddress
	FROM WRBHBNewKOTEntryDtl D
	JOIN WRBHBNewKOTEntryHdr H ON D.NewKOTEntryHdrId=H.Id AND H.IsActive = 1 AND H.IsDeleted=0
	JOIN WRBHBCheckInHdr CH ON H.GuestId=CH.GuestId AND H.CheckInId=CH.Id AND CH.IsActive=1 AND CH.IsDeleted=0
	JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	JOIN #Service S ON P.Id=S.PropertyId
	JOIN #Calc    C ON S.PropertyId=C.PropertyId
	WHERE D.IsActive=1 AND D.IsDeleted = 0 AND  H.GuestId =@GuestId  AND H.PropertyId=@PropertyId
	AND CH.BookingId=@BookingId AND H.Date=@Str2
	
	END
 END
 
