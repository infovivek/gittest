SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Header_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractClientPref_Header_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PREFFERD HEADER INSERT
Purpose  	: HEARDER INSERT
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

CREATE PROCEDURE Sp_ContractClientPref_Header_Insert
(
@ClientName 	NVARCHAR(100),
@ClientId		BIGINT,
@CreatedBy   BIGINT
)
AS
BEGIN
DECLARE @Identity int--,@ErrMsg NVARCHAR(MAX);

--IF EXISTS (SELECT NULL FROM WRBHBContractClientPref_Header WITH (NOLOCK) 
--WHERE UPPER(ClientName) = UPPER(@ClientName)  AND IsDeleted = 0 AND IsActive = 1)

--BEGIN
           
--  SET @ErrMsg = 'Client Name Already Exists';
--    SELECT @ErrMsg;
--END

--ELSE
--BEGIN

INSERT INTO WRBHBContractClientPref_Header(ClientName,ClientId,Date,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
			IsActive,IsDeleted,RowId)
VALUES (@ClientName,@ClientId,GETDATE(),@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),1,0,NEWID())

 SET  @Identity=@@IDENTITY
 SELECT Id,RowId FROM WRBHBContractClientPref_Header WHERE Id=@Identity;
 
END
--END