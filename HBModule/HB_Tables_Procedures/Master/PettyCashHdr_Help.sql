SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_PettyCashHdr_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_PettyCashHdr_Help]
GO
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: PETTYCASH HELP
Purpose  	: PETTYCASH HELP
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

CREATE PROCEDURE [dbo].[Sp_PettyCashHdr_Help]
(
@Action NVARCHAR(100),
--@Str NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT

)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
 	SELECT Id,HeaderName as ExpenseHead FROM WRBHBExpenseHeads WHERE ExpenseGroupId=@Id AND Status='Active'
 
 --PROPERTY
	SELECT DISTINCT P.PropertyName Property,P.Id Id	
	FROM WRBHBPropertyUsers  PU 
    JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	WHERE PU.UserId=@UserId AND 
	P.Category IN('Internal Property','Managed G H') AND
	PU.IsActive=1 AND PU.IsDeleted=0 AND PU.UserType IN('Resident Managers' ,'Assistant Resident Managers')
	 
	  --Expanse Group
    SELECT Id as data,ExpenseHead as label FROM WRBHBExpenseGroup
    
    SELECT ClosingBalance FROM    WRBHBPettyCashHdr 
    WHERE UserId=@UserId AND Id = (SELECT MAX(Id)  FROM WRBHBPettyCashHdr WHERE UserId=@UserId)
    
 END
 END
 
 
