SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TransSubsPriceModel_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)

DROP PROCEDURE Sp_TransSubsPriceModel_Help

Go
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (12/03/2014)  >
Section  	: TRANSSUBSPRICEMODEL HELP
Purpose  	: MODEL HELP
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

CREATE PROCEDURE Sp_TransSubsPriceModel_Help
(
@Action NVARCHAR(100),
--@Str NVARCHAR(100),
@UserId BIGINT,
@Id		BIGINT
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
  ----To Load Types in HelpText
  -- SELECT DISTINCT Types AS label FROM WRBHBTransSubsPriceModel
  -- WHERE IsActive=1;
   
   SELECT Types,Name,Amount,Id,AllowedBookings as AllowedBooking
    FROM WRBHBTransSubsPriceModel WHERE IsActive=0 and IsDeleted=0
   
     
 END
 IF @Action='TYPELOAD'
  BEGIN
   CREATE TABLE #TYPE(Types NVARCHAR(100));
   INSERT INTO #TYPE(Types)SELECT 'Transcription';
   INSERT INTO #TYPE(Types)SELECT 'Subscription';
   SELECT Types FROM #TYPE;
   
   -- SELECT Types,Name,Id FROM WRBHBTransSubsPriceModel
  END
  
 IF @Action='MODELDELETE'
	BEGIN
		UPDATE WRBHBTransSubsPriceModel SET IsDeleted=1,IsActive=0,ModifiedBy=@UserId WHERE  Id=@Id;
	END
 END 