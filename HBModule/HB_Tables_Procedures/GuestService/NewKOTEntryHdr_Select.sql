-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_NewKOTEntryHdr_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_NewKOTEntryHdr_Select]
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

CREATE PROCEDURE [dbo].[SP_NewKOTEntryHdr_Select](@Id INT=NULL)
AS
BEGIN
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF
IF @Id = 0
    BEGIN
		SELECT PropertyName,GuestName,CONVERT(varchar(100),Date,103) as Date,Id
		FROM WRBHBNewKOTEntryHdr 
		WHERE IsActive=1 AND IsDeleted = 0 
	END;        
IF @Id != 0
	
	BEGIN
    --drop table #Product
	CREATE TABLE #Product(ServiceItem NVARCHAR(200),PropertyId INT)
	Declare @Str1 NVARCHAR(100),@PropertyId Int
    --Hdr
	SELECT PropertyName,CONVERT(varchar(100),Date,103) as Date,PropertyId,GuestName,
	RoomNo ,BookingCode ,ClientName ,GuestId,Id,GetType,ISNULL(TotalAmount,0) AS TotalAmount,
	BookingId,RoomId,CheckInId
	FROM WRBHBNewKOTEntryHdr 
	WHERE IsActive = 1 AND IsDeleted = 0 AND Id=@Id;
   	--DETAILS
	SELECT ServiceItem,Quantity,Price,CAST(ISNULL(Amount,0)as DECIMAL(27,2)) AS Amount,Id,ItemId
	FROM WRBHBNewKOTEntryDtl
	WHERE IsActive = 1 AND IsDeleted = 0 AND NewKOTEntryHdrId =@Id;
	--ServiceItems
	SET @Str1=(SELECT GetType FROM WRBHBNewKOTEntryHdr WHERE IsActive = 1 AND IsDeleted = 0 AND Id=@Id)
	SET @PropertyId=(SELECT PropertyId FROM WRBHBNewKOTEntryHdr WHERE IsActive = 1 AND IsDeleted = 0 AND Id=@Id)
	
	IF @Str1='CntractMGH'
	BEGIN
	IF @PropertyId=0
		BEGIN
		INSERT INTO #Product (ServiceItem,PropertyId)
		SELECT ProductName,0 AS Property  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END
		ELSE
		BEGIn
		INSERT INTO #Product (ServiceItem,PropertyId)
	    SELECT ProductName,0 AS Property  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END		
	END
	IF @Str1='Internal Property'
	BEGIN
		IF @PropertyId=0
		BEGIN
		INSERT INTO #Product (ServiceItem,PropertyId)
		SELECT ProductName,0 AS Property  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END
		ELSE
		BEGIn
		INSERT INTO #Product (ServiceItem,PropertyId)
	    SELECT ProductName,0 AS PropertyId  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END	
		 
	END
	ELSE
	BEGIN
		IF @PropertyId=0
		BEGIN
		INSERT INTO #Product (ServiceItem,PropertyId)
		SELECT ProductName,0 AS PropertyId  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END
		ELSE
		BEGIn
		INSERT INTO #Product (ServiceItem,PropertyId)
	    SELECT ProductName,0 AS PropertyId  FROM WRBHBContarctProductMaster		
		WHERE IsActive=1 AND IsDeleted=0 AND TypeService='Food And Beverages'
		END	
	END
	
	    SELECT ServiceItem,PropertyId FROM #Product;
	    
	END
END

 