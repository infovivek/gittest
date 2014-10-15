SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TRLink_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TRLink_Help]
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

CREATE PROCEDURE [dbo].[Sp_TRLink_Help]
(
@Action NVARCHAR(100),
@Id		BIGINT,
@UserId BIGINT

)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
	SELECT ClientName as Client,Id FROM WRBHBClientManagement WHERE IsActive=1 AND IsDeleted=0	
 END
 
 IF @Action='LINKLOAD'
 BEGIN
	SELECT TRLink FROM WRBHBTRLink WHERE ClientId=@Id AND IsActive=1 AND IsDeleted=0
	
	DECLARE @RowId NVARCHAR(100),@TRLink NVARCHAR(100);
SET @RowId=(SELECT LEFT(RowId,8) FROM WRBHBClientManagement WHERE Id=@Id)
SET @TRLink='www.staysimplyfied.com/'+@RowId

SELECT @TRLink as TRLink
 END
 END
 
