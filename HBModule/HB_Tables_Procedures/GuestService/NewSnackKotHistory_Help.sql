SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewSnackKOTEntryHistory_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE dbo.[SP_NewSnackKOTEntryHistory_Help]

Go
/* 
Author Name : Anbu
Created On 	: <Created Date (24/06/2014)  >
Section  	: SP_NewSnackKOTHistory Help
Purpose  	: SP_NewSnackKOTHistory Help
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

CREATE PROCEDURE dbo.[SP_NewSnackKOTEntryHistory_Help]
(
@Action NVARCHAR(100),
@PropertyId		BIGINT,
@Str1 NVARCHAR(100),
@Str2 NVARCHAR(100),
@Str3 NVARCHAR(100))
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	   --Property
		SELECT DISTINCT P.PropertyName,PropertyId
		FROM WRBHBCheckInHdr C
		JOIN WRBHBProperty P ON C.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
		WHERE C.IsActive=1 AND C.IsDeleted=0 AND  P.Category IN('Internal Property','Managed G H')
		ORDER BY P.PropertyName ASC
			
 END
IF @Action='KOTDETAILS'
 BEGIN
	    CREATE TABLE  #Guest(Date NVARCHAR(100),ConsumerType NVARCHAR(100),Name NVARCHAR(100),BVeg INT,
	    BNonVeg INT,LVeg INT,LNonVeg INT,DVeg INT,DNonVeg INT)
	    --Details for Property and Date 
	    IF(@Str2 ='Guest')
	    BEGIN
	 
	    INSERT INTO #Guest(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	 
	    SELECT CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Guest' AS ConsumerType,KD.GuestName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTDtls KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId 
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103)  
		order by CONVERT(date,KH.Date,103)
		-- MONTH( KH.Date)=Month(@Str1) AND year(KH.Date) =year(@Str1) 
		END
		ELSE IF(@Str2 ='Staff')
		BEGIN
		
		INSERT INTO #Guest(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	    
	    SELECT  CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Staff' AS ConsumerType,KD.UserName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTUser KD  ON KH.Id=KD.KOTEntryHdrId AND	KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)
		
		END
		ELSE IF(@Str2 ='ALL')
		BEGIN
		
		INSERT INTO #Guest(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	    
	    SELECT  CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Guest' AS ConsumerType,KD.GuestName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTDtls KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)
		
		INSERT INTO #Guest(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	   
	    SELECT   CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Staff' AS ConsumerType,KD.UserName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTUser KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 AND KH.PropertyId=@PropertyId
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)  
     END
       SELECT  Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg
       FROM #Guest 
     
   END
 IF @Action='NewKOTDETAILS'
 BEGIN
	    CREATE TABLE  #Guests(Date NVARCHAR(100),ConsumerType NVARCHAR(100),Name NVARCHAR(100),BVeg INT,
	    BNonVeg INT,LVeg INT,LNonVeg INT,DVeg INT,DNonVeg INT)
	    --Details for Property and Date 
	    IF(@Str2 ='Guest')
	    BEGIN
	 
	    INSERT INTO #Guests(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	 
	    SELECT CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Guest' AS ConsumerType,KD.GuestName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTDtls KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0  
		AND CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103)  
		order by CONVERT(date,KH.Date,103)
		-- MONTH( KH.Date)=Month(@Str1) AND year(KH.Date) =year(@Str1) 
		END
		ELSE IF(@Str2 ='Staff')
		BEGIN
		
		INSERT INTO #Guests(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	    
	    SELECT  CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Staff' AS ConsumerType,KD.UserName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTUser KD  ON KH.Id=KD.KOTEntryHdrId AND	KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)
		
		END
		ELSE IF(@Str2 ='ALL')
		BEGIN
		
		INSERT INTO #Guests(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	    
	    SELECT  CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Guest' AS ConsumerType,KD.GuestName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTDtls KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)
		
		INSERT INTO #Guests(Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg)
	   
	    SELECT   CONVERT(NVARCHAR(100),KH.Date,103) AS Date,'Staff' AS ConsumerType,KD.UserName,BreakfastVeg,
	    BreakfastNonVeg,LunchVeg,LunchNonVeg,DinnerVeg,DinnerNonVeg
		FROM WRBHBKOTHdr KH
		JOIN WRBHBKOTUser KD  ON KH.Id=KD.KOTEntryHdrId AND
		KH.IsActive=1 AND KH.IsDeleted=0
		WHERE KD.IsActive=1 AND KD.IsDeleted=0 
		AND  CONVERT(date,KH.Date,103) BETWEEN CONVERT(date,@Str1,103) AND CONVERT(date,@Str3,103) 
		order by CONVERT(date,KH.Date,103)  
     END
       SELECT  Date,ConsumerType,Name,BVeg,BNonVeg,LVeg,LNonVeg,DVeg,DNonVeg
       FROM #Guests 
     
   END
   
 END