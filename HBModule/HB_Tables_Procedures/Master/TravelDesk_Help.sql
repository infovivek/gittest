 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'Sp_TravelDesk_Help') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE  Sp_TravelDesk_Help
GO 
/* 
Author Name : mini
Created On 	: <Created Date (04/07/2014)  >
Section  	: 
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
CREATE PROCEDURE Sp_TravelDesk_Help
(@PAction NVARCHAR(100),@Param1  NVARCHAR(100),
@Param2 NVARCHAR(100),@Id1 bigint,@Id2 bigint,@UserId bigint)
AS
BEGIN
  Create Table #data(FirstName Nvarchar(250),LastName NVARCHAR(100),EmailId nvarchar(100),CltmgntId  Bigint,
 Id BIGINT, EmpCode NVARCHAR(100),Act NVARCHAR(100));
  IF @PAction='CLIENTDTLS'
  BEGIN
	--Table DateFunction
		 SELECT ClientName  AS ClientName,Id as zClientId   FROM WRBHBClientManagement 
		 WHERE IsActive=1 AND IsDeleted=0;  
  END
  IF @PAction='MasterClent-Desk'
  BEGIN
		SELECT ClientName  AS ClientName,Id as zClientId  FROM WRBHBMasterClientManagement M 
		WHERE M.IsActive=1 AND M.IsDeleted=0 
  END
  IF @PAction='CLIENTDTLS-Agency'
  BEGIN
	--Table DateFunction
		 SELECT ClientName  AS ClientName,Id as zClientId   FROM WRBHBClientManagement 
		 WHERE IsActive=1 AND IsDeleted=0;  
  END
	 IF @PAction='STATELOAD'
  BEGIN
  --Table DateFunction
		 SELECT StateName AS StateName,Id as zStateId FROM WRBHBState 
		 WHERE IsActive=1; 
  END
   IF @PAction='CITYLOAD'
  BEGIN
	--Table DateFunction
		 SELECT CityName AS CityName,Id as zCityId FROM WRBHBCity 
		 WHERE IsActive=1 and StateId=@Id1 ; 
  END  
     IF @PAction='RESET'
  BEGIN
	--Table DateFunction
	INSERT INTO #data(FirstName,LastName,EmailId ,CltmgntId ,Id , EmpCode ,Act)
		 SELECT FirstName , LastName,EmailId EmailId,CltmgntId,Id,EmpCode,'InActive' as Act--,ISNULL(DATALENGTH(Password), 0)
		 FROM  WRBHBClientManagementAddClientGuest 
		 WHERE IsActive=1 AND IsDeleted=0 AND CltmgntId=@Id1  and iSNULL(DATALENGTH(Password), 0)=0 
	INSERT INTO #data(FirstName,LastName,EmailId ,CltmgntId ,Id , EmpCode ,Act)
		 SELECT FirstName , LastName,EmailId EmailId,CltmgntId,Id,EmpCode,'Active'  as Act--,ISNULL(DATALENGTH(Password), 0)
		 FROM  WRBHBClientManagementAddClientGuest 
		 WHERE IsActive=1 AND IsDeleted=0 AND CltmgntId=@Id1  and iSNULL(DATALENGTH(Password), 0)!=0 
		 SELECT FirstName,LastName,EmailId ,CltmgntId ,Id , EmpCode ,Act Active FROM #data
  END  
    IF @PAction='UserData'
  BEGIN 
	--	 SELECT FirstName , LastName,Email,Id,Mobile   FROM  WRBHBTravelDesk 
	--	 WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id1; 
		 SELECT FirstName , LastName,EmailId Email,Id,EmpCode,GMobileNo as Mobile   
		 FROM  WRBHBClientManagementAddClientGuest 
		 WHERE IsActive=1 AND IsDeleted=0 AND Id=@Id1;
  END  
   IF @PAction='TravelDeskDatas'
   begin
    if isnull(@Param2,'')='Client'
      BEGIN
        SELECT FirstName , LastName,Email Mail,Id zId,MobileNo Mobile   
		 FROM  WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0  and FirstName!='' and LastName!=''
		  and Email!=''  and   MobileNo!='' AND CltmgntId=@Id1;
       END  
     --IF @PAction='MasterClent-DeskS'
     if isnull(@Param2,'')='MasterClient'
  BEGIN
		SELECT cc.FirstName FirstName, cc.LastName LastName,cc.Email Mail,cc.Id zId,
		cc.MobileNo Mobile,cli.ClientName   ,m.Id
		FROM WRBHBMasterClientManagement M 
		join WRBHBClientManagement cli on m.Id=cli.MasterClientId  and cli.IsActive=1 AND cli.IsDeleted=0  
		join WRBHBClientManagementAddNewClient cc on cli.Id=cc.CltmgntId and  cc.IsActive=1 AND cc.IsDeleted=0  
		WHERE M.IsActive=1 AND M.IsDeleted=0  and FirstName!='' and LastName!=''
		and Email!=''  and   MobileNo!=''  AND m.Id=@Id1;
  END
    if isnull(@Param2,'')=''
      BEGIN
        SELECT FirstName , LastName,Email Mail,Id zId,MobileNo Mobile   
		 FROM  WRBHBClientManagementAddNewClient 
		 WHERE IsActive=1 AND IsDeleted=0  and FirstName!='' and LastName!=''
		  and Email!=''  and   MobileNo!='' AND CltmgntId=@Id1;
       END  
  end
  IF @PAction='Update'
   if isnull(@Param2,'')='DeleteEnduser'
  BEGIN
  UPDATE  WRBHBClientManagementAddClientGuest SET Password=null,ModifiedDate=GETDATE()
   WHERE Id=@Id1;
    UPDATE  WrbhbTravelDesk SET password= null,IsActive=0, IsDeleted=1,ModifiedDate=GETDATE() 
   WHERE Email=isnull(@Param1,'') and Mode='ENDUSER';
  END
 if isnull(@Param2,'')='TravelDesk'
  BEGIN
   UPDATE  WrbhbTravelDesk SET IsActive=0, IsDeleted=1,ModifiedDate=GETDATE() 
   WHERE Id=@Id1 and Mode='TRAVELDESK';
  eND
  --   IF @PAction='TravelDeskDatasbyname'
  --BEGIN
  --SELECT FirstName , LastName,Email Email,Id,'' EmpCode,MobileNo Mobile   
		-- FROM  WRBHBClientManagementAddNewClient 
		-- WHERE IsActive=1 AND IsDeleted=0   AND Id=@Id1;
  --  END  
  End 
   
 