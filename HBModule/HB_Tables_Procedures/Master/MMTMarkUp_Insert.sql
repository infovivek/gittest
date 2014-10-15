SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MMTMarkUp_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_MMTMarkUp_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (27/08/2014)  >
Section  	: MMTMARKUP INSERT
Purpose  	: MMTMARKUP INSERT
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
CREATE PROCEDURE Sp_MMTMarkUp_Insert
(
@MMT		DECIMAL(27,2),
@CreatedBy	BIGINT,
@Id			BIGINT
)
AS
BEGIN 

INSERT INTO WRBHBMMTMarkupHistory(MMTMarkup,IsActive,IsDeleted,CreatedBy,
CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES(@MMT,0,1,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID());
		
		
delete WRBHBMMTMarkup;
		INSERT INTO WRBHBMMTMarkup(MMTMarkup,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
		VALUES(@MMT,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
		
		SELECT Id,RowId FROM WRBHBMMTMarkup WHERE Id=@@IDENTITY;
	 	
END

--truncate table WRBHBMMTMarkupHistory
--truncate table WRBHBMMTMarkup