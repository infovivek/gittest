SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_SSPCodeGeneration_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_SSPCodeGeneration_Insert]
GO   
/* 
Author Name : <ARUNPRASATH.k>
Created On 	: <Created Date (27/03/2014)  >
Section  	: SSPCodeGeneration  Insert 
Purpose  	: SSPCodeGeneration  Insert
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
CREATE PROCEDURE [dbo].[Sp_SSPCodeGeneration_Insert](
@ClientId		BIGINT,
@PropertyId		BIGINT,
@SSPCode		NVARCHAR(100),
@SSPName		NVARCHAR(100),
@BookingLevel	NVARCHAR(100),
@SingleTariff	DECIMAL(22,7),
@DoubleTariff	DECIMAL(22,7),
@TripleTariff	DECIMAL(22,7),
@CreatedBy		BIGINT) 
AS
BEGIN
 --INSERT
 DECLARE @ErrMsg NVARCHAR(100)
 IF EXISTS (SELECT NULL FROM WRBHBSSPCodeGeneration WITH (NOLOCK) 
 WHERE UPPER(SSPName) = UPPER(@SSPName)  AND IsDeleted = 0 AND IsActive = 1)
BEGIN
               
  SET @ErrMsg = 'SSPName Already Exists';
   SELECT @ErrMsg
    
END 
ELSE 
BEGIN
	DECLARE @CNT INT ,@CODE NVARCHAR(100),@CODE1 NVARCHAR(100);
	SELECT @CNT= COUNT(*) FROM  WRBHBSSPCodeGeneration
	IF ISNULL(@CNT,0)=0
	BEGIN
		SELECT @CODE=@SSPCode+'1'
	END
	ELSE
	BEGIN
		SELECT TOP 1 @CODE1=SSPCode  FROM  WRBHBSSPCodeGeneration ORDER BY Id DESC 
		SELECT @CNT=CONVERT(INT,(SUBSTRING ( @CODE1 ,7 , LEN(@CODE1))))+1		
		SELECT @CODE=@SSPCode+CONVERT(NVARCHAR,@CNT)
	END

	INSERT INTO dbo.WRBHBSSPCodeGeneration(ClientId,PropertyId,SSPName,SSPCode,BookingLevel,SingleTariff,
	DoubleTariff,TripleTariff,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive,IsDeleted,RowId) 
	VALUES
	(@ClientId,@PropertyId,@SSPName,@CODE,@BookingLevel,@SingleTariff,
	@DoubleTariff,@TripleTariff,@CreatedBy,GETDATE(),@CreatedBy, GETDATE(),1,0,NEWID())
 
	SELECT Id,RowId FROM WRBHBSSPCodeGeneration WHERE Id=@@IDENTITY
 
END
END
