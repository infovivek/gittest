GO
/****** Object:  StoredProcedure [dbo].[Sp_ImportGuest_Help]    Script Date: 07/03/2014 11:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractBill_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractBill_Help]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (1/04/2014)  >
Section  	: CONTRACT BILL HELP
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

CREATE PROCEDURE [dbo].[Sp_ContractBill_Help]
(
@Action NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT,
@Mode	NVARCHAR(100)
)
 AS							--DROP TABLE #TEMP
 BEGIN

		--CREATE TABLE #TEMP (StartDate DATE,EndDate DATE,Days BIGINT,Rental DECIMAL(27,2),RentalTax DECIMAL(27,2),
		--Id BIGINT,ClientId BIGINT,InvoiceNo NVARCHAR(100),Type NVARCHAR(100),CurrentDate DATE)
		
		DECLARE @StartDate DATE,@Enddate DATE,@ContractEndDate DATE,@ContractName NVARCHAR(100),
		@InVoiceNo NVARCHAR(100),@Tax DECIMAL(27,2),@Tempinvoiceno nvarchar(100),
		@StateId BIGINT,@i INT,@DateDiff INT,@ClientId BIGINT;
		
		--INSERT INTO #TEMP (StartDate,EndDate,Days,Rental,RentalTax,Id,ClientId,InvoiceNo,Type,CurrentDate)

		--SELECT @StartDate AS StartDate,@enddate AS EndDate,DateDiff(DAY,@StartDate,@enddate) AS Days,
		--Convert(DECIMAL(27,2),IMA.RentelAmount) AS Rental,Convert(decimal(27,2),
		--IMA.RentelAmount*12/100) AS RentalTax,
		--IMA.ContractId,IMA.ClientId,ISNULL(IMA.InvoiceNo,''),IMA.Type AS Type,GETDATE() 
		--FROM dbo.WRBHBContractManagement CM
		--JOIN WRBHBInvoiceManagedGHAmount IMA on IMA.ClientId=CM.ClientId AND IMA.ContractId=CM.Id
		--WHERE  IMA.IsActive=1 AND IMA.IsDeleted=0 
		---- and IMA.ContractId=@Id 
		--order by IMA.Id ASC	 
		
		
		--SELECT StartDate,EndDate,Days,Rental,RentalTax,(Rental+RentalTax) AS TotalTariff,Id AS ContractId,ClientId
		-- FROM #TEMP WHERE Id=@Id AND MONTH(CONVERT(DATE,EndDate,103))<= MONTH(CONVERT(DATE,@ContractEndDate,103)) AND
		-- YEAR(CONVERT(DATE,EndDate,103))<= YEAR(CONVERT(DATE,@ContractEndDate,103))
   IF @Action='PAGELOAD'
   BEGIN 
   
		IF @Mode='Contract'
		BEGIN
			SELECT DISTINCT Client,CM.ClientId as ZId 
			FROM WRBHBContractManagement CM
			JOIN  WRBHBInvoiceManagedGHAmount IMA ON CM.Id=IMA.ContractId 
			WHERE IMA.IsActive=1 AND IMA.IsDeleted=0 
			AND IMA.Type!=' Managed Contracts '
		END
		ELSE
		BEGIN
			SELECT DISTINCT Client,CM.ClientId as ZId 
			FROM WRBHBContractManagement CM
			JOIN  WRBHBInvoiceManagedGHAmount IMA ON CM.Id=IMA.ContractId 
			WHERE IMA.IsActive=1 AND IMA.IsDeleted=0
			AND IMA.Type=' Managed Contracts '
		END
		
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		DateDiff(DAY,T1.StartDate,T1.EndDate)+1 AS Days,RentelAmount,LTTax,
		CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(RentelAmount+LTTax+STTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo,SubString(Type,0,3) as Type
		FROM WRBHBInvoiceManagedGHAmount T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' 
		AND T1.Type!=' Managed Contracts ' AND ISNULL(T1.InvoiceNo,'')!='' AND T1.IsActive=1 and T1.IsDeleted=0 
		
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		DateDiff(DAY,T1.StartDate,T1.EndDate)+1 AS Days,RentelAmount,STTax,
		CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(RentelAmount+STTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo,SubString(Type,0,3) as Type 
		FROM WRBHBInvoiceManagedGHAmount T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE MONTH(CONVERT(DATE,T1.EndDate,103))<=MONTH(CONVERT(DATE,GETDATE(),103)) AND InvoiceNo!='' 
		AND T1.Type=' Managed Contracts ' AND ISNULL(T1.InvoiceNo,'')!='' AND T1.IsActive=1 and T1.IsDeleted=0 
	END
	
   IF @Action='CONTRACTLOAD'
   BEGIN
		IF @Mode='Contract'
		BEGIN
			SELECT ContractName +'-'+CAST(MONTH(CONVERT(NVARCHAR(100),RentDate,103)) AS NVARCHAR)+'-'+CAST(YEAR(CONVERT(NVARCHAR(100),RentDate,103)) AS NVARCHAR) as label,
			CM.Id as data FROM WRBHBContractManagement CM
			JOIN  WRBHBInvoiceManagedGHAmount IMA ON CM.Id=IMA.ContractId WHERE CM.ClientId=@Id AND 
			CM.IsActive=1 AND CM.IsDeleted=0 AND IMA.Type!=' Managed Contracts ' AND IMA.IsActive=1
			AND IMA.IsDeleted=0 AND ISNULL(IMA.InvoiceNo,'')=''
		END
		ELSE
		BEGIN
		--select @id
			SELECT ContractName+'-'+CAST(MONTH(CONVERT(NVARCHAR(100),RentDate,103)) AS NVARCHAR)+'-'+CAST(YEAR(CONVERT(NVARCHAR(100),RentDate,103)) AS NVARCHAR) as label,CM.Id as data FROM WRBHBContractManagement CM
			JOIN  WRBHBInvoiceManagedGHAmount IMA ON CM.Id=IMA.ContractId WHERE CM.ClientId=@Id AND 
			CM.IsActive=1 AND CM.IsDeleted=0 AND IMA.Type=' Managed Contracts ' AND  IMA.IsActive=1
			AND IMA.IsDeleted=0 AND ISNULL(IMA.InvoiceNo,'')=''
		END
   END
   IF @Action='CONTRACTLOADClient'
   BEGIN
   
		
		SELECT DISTINCT Convert(NVARCHAR(100),T1.StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),T1.EndDate,103) AS EndDate,
		DateDiff(DAY,T1.StartDate,T1.EndDate)+1 AS Days,RentelAmount,LTTax,
		CONVERT(nvarchar(100),CONVERT(DECIMAL(27,2),(RentelAmount+LTTax+STTax))) AS TariffAmount,
		T1.Id AS ContractId,T1.ClientId,CM.ClientName AS Client,
		CON.ContractName as ContractName,InvoiceNo,SubString(Type,0,3) as Type
		FROM WRBHBInvoiceManagedGHAmount T1
		JOIN WRBHBClientManagement CM ON T1.ClientId=CM.Id
		JOIN WRBHBContractManagement CON ON T1.Id=CON.Id
		WHERE T1.ClientId=@Id AND ISNULL(T1.InvoiceNo,'')!='' AND T1.IsActive=1 and T1.IsDeleted=0 
		
   END		
   
   IF @Action='CONTRACTDETAIL'
   BEGIN
		CREATE TABLE #TEMP1 (StartDate DATE,EndDate DATE,Days BIGINT,Rental DECIMAL(27,2),RentalTax DECIMAL(27,2),
		Id BIGINT,ClientId BIGINT,InvoiceNo NVARCHAR(100),Type NVARCHAR(100),CurrentDate DATE)
		
		--Luxry Tax
		CREATE TABLE #BookingData(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		CheckInDate DATE,CheckOurDate DATE)
		
		CREATE TABLE #BookingDataTariff(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		PId BIGINT PRIMARY KEY IDENTITY(1,1),CheckInDate DATE,CheckOurDate DATE)
		
		CREATE TABLE #BookingDataTariffFinal(BookingId BIGINT,PropertyAssingedGuestId BIGINT,BookingLevel NVARCHAR(100),
		Tariff DECIMAL(27,2),TodayDate DATE,Occupancy NVARCHAR(100),GuestId BIGINT,RoomCaptured INT,
		RoomId BIGINT,BedId BIGINT,ApartmentId BIGINT,StateId BIGINT,ClientId BIGINT,PropertyId BIGINT,
		CheckInDate DATE,CheckOurDate DATE,PId BIGINT PRIMARY KEY IDENTITY(1,1))
		
		CREATE TABLE #LuxuryTax1(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2))  

		CREATE TABLE #LuxuryTax2(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2),  
		DATE NVARCHAR(100))
		
		CREATE TABLE #LuxuryTax3(LuxuryTax DECIMAL(27,2),LuxuryTax1 DECIMAL(27,2),LuxuryTax2 DECIMAL(27,2),LuxuryTax3 DECIMAL(27,2),  
		ServiceTax DECIMAL(27,2),FromDT NVARCHAR(100),ToDT NVARCHAR(100),RackTariffFlag BIT,Id BIGINT,  
		TariffAmtFrom DECIMAL(27,2),TariffAmtFrom1 DECIMAL(27,2),TariffAmtFrom2 DECIMAL(27,2),TariffAmtFrom3 DECIMAL(27,2),  
		TariffAmtTo DECIMAL(27,2),TariffAmtTo1 DECIMAL(27,2),TariffAmtTo2 DECIMAL(27,2),TariffAmtTo3 DECIMAL(27,2),  
		DATE NVARCHAR(100))
		
		CREATE TABLE #FINALLuxury(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),
		LT DECIMAL(27,2),ST DECIMAL(27,2),DATE NVARCHAR(100),ContractId BIGINT)  

		CREATE TABLE #FINAL(TARIFF DECIMAL(27,2),LuxuryTax DECIMAL(27,2),ServiceTax DECIMAL(27,2),
		LT DECIMAL(27,2),ST DECIMAL(27,2),ContractId BIGINT) 
		
		DECLARE @NEWTYPE NVARCHAR(100)
		
		
		SELECT @ContractName=ContractName,@ContractEndDate=CONVERT(DATE,EndDate,103) 
		FROM WRBHBContractManagement WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
		
		SET @StartDate=(SELECT DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)))
		
		IF(MONTH(CONVERT(DATE,@ContractEndDate,103))=MONTH(CONVERT(DATE,GETDATE(),103)))AND (YEAR(CONVERT(DATE,@ContractEndDate,103))=YEAR(CONVERT(DATE,GETDATE(),103)))
		BEGIN
			SET @Enddate=@ContractEndDate
		END
		ELSE
		BEGIN
			SET @Enddate=(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))		
		END
		
				
		SET @Tax=(SELECT BusinessSupportST FROM WRBHBTaxMaster WHERE StateId=17)
		
		
		
		IF @Mode='ManagedContract'
		BEGIN
			SELECT @NEWTYPE=' Managed Contracts ',@ContractName='MAN'
			
		END
		ELSE
		BEGIN	
			SELECT @NEWTYPE=' Dedicated Contracts ',@ContractName='DED'
		END
		
		SET @Tempinvoiceno = (SELECT TOP 1 InVoiceNo FROM WRBHBInvoiceManagedGHAmount 
		WHERE  IsActive=1 AND IsDeleted=0 AND Type=@NEWTYPE AND ISNULL(InvoiceNo,'')!='' order by Id desc)
		
		SELECT @StateId=17;			
		
		IF ISNULL(@Tempinvoiceno , '' )= ''
		BEGIN
			SET @InVoiceNo = SUBSTRING(upper(@ContractName),0,4)+'/'+'1'
		END
		ELSE
		BEGIN
			SET @InVoiceNo = 
			SUBSTRING(@Tempinvoiceno,0,6)+
			CAST(CAST(SUBSTRING(@Tempinvoiceno,6,LEN(@Tempinvoiceno)) AS VARCHAR) + 1 AS VARCHAR); 
		END
		
		--RENT DATA WILL BE TAKE HERE
		INSERT INTO #TEMP1 (StartDate,EndDate,Days,Rental,RentalTax,Id,ClientId,InvoiceNo,Type,CurrentDate)

		SELECT @StartDate AS StartDate,@enddate AS EndDate,DateDiff(DAY,@StartDate,@enddate) AS Days,
		Convert(DECIMAL(27,2),IMA.RentelAmount) AS Rental,Convert(decimal(27,2),
		IMA.RentelAmount*12/100) AS RentalTax,
		IMA.ContractId,IMA.ClientId,ISNULL(IMA.InvoiceNo,''),IMA.Type AS Type,GETDATE() 
		FROM dbo.WRBHBContractManagement CM
		JOIN WRBHBInvoiceManagedGHAmount IMA on IMA.ClientId=CM.ClientId AND IMA.ContractId=CM.Id
		WHERE  IMA.IsActive=1 AND IMA.IsDeleted=0 
		AND IMA.ContractId=@Id 
		order by IMA.Id ASC
		
		
		
		--Luxry Tax Take
			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),
			ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),GETDATE(),103) between CONVERT(nvarchar(100),Date,103) and  
			CONVERT(nvarchar(100),DateTo,103)    
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId 
			
			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),
			ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),Date,103) <= CONVERT(nvarchar(100),GETDATE(),103)   
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  

			INSERT INTO #LuxuryTax1(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Id,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,  
			TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			SELECT ISNULL(LTaxPer,0),ISNULL(LTaxPer1,0),ISNULL(LTaxPer2,0),ISNULL(LTaxPer3,0),
			ISNULL(BusinessSupportST,0),CONVERT(varchar(100),Date,103),  
			CONVERT(varchar(100),ISNULL(DateTo,GETDATE()),103),ISNULL(RackTariff,0),Id,TariffAmtFrom,TariffAmtFrom1,  
			TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3    
			FROM WRBHBTaxMaster  
			WHERE CONVERT(nvarchar(100),GETDATE(),103)<= CONVERT(nvarchar(100),DateTo,103)    
			AND IsActive=1 AND IsDeleted=0 AND StateId=@StateId  
			 
			
			--SELECT * from #LuxuryTax1  
			
			SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
			FROM #LuxuryTax1;    
			WHILE (@DateDiff>=0)  
			BEGIN         
				INSERT INTO #LuxuryTax2(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,Date,TariffAmtFrom,TariffAmtFrom1,  
				TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
				SELECT TOP 1 LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,RackTariffFlag,CONVERT(NVARCHAR,DATEADD(DAY,@i,CONVERT(DATE,FromDT,103)),103),  
				TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,TariffAmtTo1,TariffAmtTo2,TariffAmtTo3     
				FROM #LuxuryTax1  
				SET @i=@i+1  
				SET @DateDiff=@DateDiff-1     
				IF @DateDiff=0  
				BEGIN  
				DELETE FROM #LuxuryTax1  
				WHERE Id IN(SELECT TOP 1 Id FROM #LuxuryTax1)  
				SELECT TOP 1 @i=0,@DateDiff=DATEDIFF(day, CONVERT(DATE,FromDT,103), CONVERT(DATE,ToDT,103))+1     
				FROM #LuxuryTax1;  
			END  
			END
			
			--CURRENT DATE LUXRY PER ENTRY TAKE HERE
			INSERT INTO #LuxuryTax3(LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,
			RackTariffFlag,Date,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,
			TariffAmtTo1,TariffAmtTo2,TariffAmtTo3)  
			
			SELECT LuxuryTax,LuxuryTax1,LuxuryTax2,LuxuryTax3,ServiceTax,FromDT,ToDT,
			RackTariffFlag,Date,TariffAmtFrom,TariffAmtFrom1,TariffAmtFrom2,TariffAmtFrom3,TariffAmtTo,
			TariffAmtTo1,TariffAmtTo2,TariffAmtTo3 FROM #LuxuryTax2
			WHERE CONVERT(DATE,Date,103)= CONVERT(DATE,GETDATE(),103)
			
			
			--SLAB 1 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date,ContractId)  
		SELECT D.Rental, ISNULL(h.LuxuryTax*(D.Rental)/100,0),0,ISNULL(h.LuxuryTax,0),  
		ISNULL(h.ServiceTax,0),D.CurrentDate,d.Id   
		FROM #LuxuryTax3 h  
		join #TEMP1 d ON CONVERT(DATE,H.Date,103) = CONVERT(DATE,D.CurrentDate ,103) 
		WHERE  (D.Rental) between h.TariffAmtFrom AND h.TariffAmtTo  
		
		 
		--SLAB 2 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date,ContractId)  
		SELECT D.Rental,ISNULL(h.LuxuryTax1*(D.Rental)/100,0),0,ISNULL(h.LuxuryTax1,0),  
		ISNULL(h.ServiceTax,0),D.CurrentDate,d.Id   
		FROM #LuxuryTax3 h  
		join #TEMP1 d ON CONVERT(DATE,H.Date,103) = CONVERT(DATE,D.CurrentDate ,103)  
		WHERE  D.Rental between h.TariffAmtFrom1 AND h.TariffAmtTo1  
		
		 
		--SLAB 3 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date,ContractId)  
		SELECT D.Rental,ISNULL(h.LuxuryTax2*D.Rental/100,0),0,ISNULL(h.LuxuryTax2,0),  
		ISNULL(h.ServiceTax,0),D.Rental,d.Id   
		FROM #LuxuryTax3 h  
		join #TEMP1 d ON CONVERT(DATE,H.Date,103) = CONVERT(DATE,D.CurrentDate ,103) 
		WHERE  D.Rental between h.TariffAmtFrom2 AND h.TariffAmtTo2  
		

		--SLAB 4 CHECK   
		INSERT INTO #FINALLuxury(TARIFF,LuxuryTax,ServiceTax,LT,ST,Date,ContractId)  
		SELECT D.Rental,ISNULL(h.LuxuryTax3*D.Rental/100,0),0,ISNULL(h.LuxuryTax3,0),  
		ISNULL(h.ServiceTax,0),D.CurrentDate,d.Id
		FROM #LuxuryTax3 h  
		join #TEMP1 d ON CONVERT(DATE,H.Date,103) = CONVERT(DATE,D.CurrentDate ,103)  
		WHERE  D.Rental between h.TariffAmtFrom3 AND h.TariffAmtTo3  
		
		---FINAL CALCULATION
		INSERT INTO #FINAL(TARIFF,LuxuryTax,ServiceTax,LT,ST,ContractId)  
		SELECT SUM(TARIFF),SUM(TARIFF)*LT/100,SUM(TARIFF)*ST/100,LT,ST,ContractId FROM   
		#FINALLuxury  
		GROUP BY TARIFF,LuxuryTax,ServiceTax,LT,ST,ContractId 
		
				
		SELECT CONVERT(NVARCHAR(100),@StartDate,103) AS StartDate,
		CONVERT(NVARCHAR(100),@Enddate,103) AS EndDate,
		DateDiff(DAY,@StartDate,@enddate)+1 Days,CAST(TARIFF AS NUMERIC(36,2)) AS TariffAmount,
		CAST(LuxuryTax AS NUMERIC(36,2)) AS TTax,
		CAST((TARIFF+LuxuryTax+ServiceTax+(ServiceTax*2/100)+(ServiceTax*1/100))AS NUMERIC(36,2)) AS TotalTariff,
		IMA.Id AS IMAId,CAST((ServiceTax+ServiceTax*2/100+ServiceTax*1/100)AS NUMERIC(36,2)) ServiceTax,
		CAST(ServiceTax*2/100 AS NUMERIC(36,2)) Cess,CAST(ServiceTax*1/100 AS NUMERIC(36,2)) HCess,
		T.ContractId,IMA.ClientId,@InVoiceNo InvoiceNo,CAST(LT AS NUMERIC(36,2)) LT,CAST(ST AS NUMERIC(36,2)) ST
		FROM #FINAL T
		JOIN WRBHBInvoiceManagedGHAmount IMA ON IMA.ContractId=T.ContractId
		WHERE T.ContractId=@Id --AND IMA.Type!=' Managed Contracts '
		
   END		
 END 	