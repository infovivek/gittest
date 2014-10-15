 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PropertyOwner_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PropertyOwner_Update]
GO   
/* 
        Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY OWNER 
		Purpose  	: PROPERTY OWNER Update
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
CREATE PROCEDURE [dbo].[sp_PropertyOwner_Update] (
 @PropertyId BIGINT,@Title NVARCHAR(100),
 @FirstName NVARCHAR(100),@Lastname NVARCHAR(100),
 @LedgerName NVARCHAR(100),@EmailID NVARCHAR(100),
 @Phone NVARCHAR(100),@Alternatephone NVARCHAR(100),
 @TDSPer BIGINT,@Address NVARCHAR(100),
 @City NVARCHAR(100),@LocalityArea NVARCHAR(100),
 @State NVARCHAR(100),@Postal NVARCHAR(100),
 @PaymentMode bit,@PayeeName NVARCHAR(100),
 @AccountNumber NVARCHAR(100),@AccountType NVARCHAR(100),
 @Bank NVARCHAR(100),@BranchAddress NVARCHAR(100),
 @IFSC NVARCHAR(100),@SWIFTCode NVARCHAR(100),
 @PANNO NVARCHAR(100), @TIN NVARCHAR(100),
 @ST NVARCHAR(100),@VAT NVARCHAR(100),
 @RackRates NVARCHAR(100),@CreatedBy    BIGINT,
 @CityId int,@StateId int,@LocalityId int,  
 @Id  BIGINT 
)   
AS  
BEGIN  
DECLARE @Identity int,@IsActive BIT,@IsDeleted BIT,@RowId UNIQUEIDENTIFIER;   
SELECT @RowId =NEWID(),@IsActive=0,@IsDeleted=0;  
  UPDATE  WRBHBPropertyOwners SET IsActive=0 ,ModifiedBy= @CreatedBy,ModifiedDate=GETDATE() WHERE Id=@Id
 --IF NOT EXISTS(SELECT NULL FROM WRBHBLocality WHERE   
 --  UPPER(Locality)=UPPER(@Localityarea) AND CityId=@CityId)  
 -- BEGIN    
	
 --    INSERT INTO WRBHBLocality(Locality,CityId,CreatedBy,CreatedDate,  
 --    ModifiedBy,ModifiedDate,IsActive,RowId)  
 --    VALUES(@Localityarea,@CityId,@CreatedBy,GETDATE(),@CreatedBy,  
 --    GETDATE(),1,NEWID());  
 --    SET @LocalityId=@@IDENTITY; 
       
 -- END  
 --ELSE  
 -- BEGIN  
	
 --  SELECT @LocalityId=Id FROM WRBHBLocality WHERE    
 --  UPPER(Locality)=UPPER(@Localityarea) AND CityId=@CityId
  
 -- END
   
 INSERT INTO dbo.WRBHBPropertyOwners(
 PropertyId,Title,FirstName,Lastname,LedgerName,EmailID,Phone,Alternatephone,
 TDSPer,Address,City,LocalityArea,State,Postal,PaymentMode,PayeeName,
 AccountNumber,AccountType,Bank,BranchAddress,IFSC,SWIFTCode,PANNO,
 TIN,ST,VAT,RackRates,CityId,StateId,LocalityId  ,
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId)  
 
 VALUES(
 @PropertyId,@Title,@FirstName,@Lastname,@LedgerName,@EmailID,@Phone,@Alternatephone,
 @TDSPer,@Address,@City,@LocalityArea,@State,@Postal,@PaymentMode,@PayeeName,
 @AccountNumber,@AccountType,@Bank,@BranchAddress,@IFSC,@SWIFTCode,@PANNO,
 @TIN,@ST,@VAT,@RackRates,@CityId,@StateId,@LocalityId,
 @CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID()); 

SELECT Id , RowId FROM WRBHBPropertyOwners WHERE Id=@@IDENTITY  
END  
  