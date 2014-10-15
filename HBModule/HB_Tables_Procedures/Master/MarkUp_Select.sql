SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MarkUp_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_MarkUp_select]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: MARKUP SELECT
Purpose  	: MARKUP SELECT
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
CREATE PROCEDURE Sp_MarkUp_Select
(
@Id		INT,
@UserId	BIGINT
)
AS
BEGIN
IF(@Id=0)
BEGIN
SELECT Flag,Value,Id FROM WRBHBMarkup
END
IF(@Id!=0)
BEGIN
SELECT Flag,Value,Id FROM WRBHBMarkup WHERE Id=@Id
END
END