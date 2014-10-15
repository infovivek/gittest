SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ContractClientPref_DELETE]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ContractClientPref_DELETE]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (19/03/2014)  >
Section  	: CONTRACT CLIENT PREFFERD DELETE
Purpose  	: DELETE
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

CREATE PROCEDURE Sp_ContractClientPref_Delete
(
@Id		INT,
@UserId INT
)
AS
BEGIN
UPDATE WRBHBContractClientPref_Details SET IsActive=0,IsDeleted=1,ModifiedBy=@UserId
Where HeaderId=@Id

UPDATE WRBHBContractClientPref_Header SET IsActive=0,IsDeleted=1,ModifiedBy=@UserId
Where Id=@Id
END