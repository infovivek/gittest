SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PettyCashRequired_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE SP_PettyCashRequired_Help

Go
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

CREATE PROCEDURE SP_PettyCashRequired_Help
(
@Action NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
 
 SELECT DISTINCT U.UserName,P.PropertyName,PC.Amount FROM WRBHBPettyCash PC
 JOIN WRBHBProperty P ON P.Id=PC.PropertyId
 JOIN WRBHBPropertyUsers U ON U.UserId=PC.UserId
 WHERE PC.IsActive=1 AND PC.IsDeleted=0 --AND U.UserType='Resident Managers' 
 GROUP BY U.UserName,P.PropertyName,PC.Amount ORDER BY PropertyName  
 
 
 END
 END
  