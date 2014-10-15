SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_Header_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractClientPref_Header_Update]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PREFFERD HEADER UPDATE
Purpose  	: HEARDER UPDATE
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

CREATE PROCEDURE Sp_ContractClientPref_Header_Update
(
@ClientName		NVARCHAR(100),
@ClientId		BIGINT,
@CreatedBy			BIGINT,
@Id				BIGINT
)
AS
BEGIN
UPDATE WRBHBContractClientPref_Header SET ClientName=@ClientName,ClientId=@ClientId,ModifiedBy=@CreatedBy,
		ModifiedDate=GETDATE() WHERE Id=@Id
		
		select Id,RowId From WRBHBContractClientPref_Header 
		where Id=@Id;
END