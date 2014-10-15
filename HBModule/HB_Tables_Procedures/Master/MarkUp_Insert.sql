SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MarkUp_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_MarkUp_Insert]
GO   
/* 
Author Name : NAHARJUN
Created On 	: <Created Date (08/04/2014)  >
Section  	: MARKUP INSERT
Purpose  	: MARKUP INSERT
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
CREATE PROCEDURE Sp_MarkUp_Insert
(
@Flag		INT,
@Value		BIGINT,
--@Value2		BIGINT,
@CreatedBy	BIGINT,
@Id			BIGINT
)
AS
BEGIN
IF(@Id!=0)
BEGIN
	UPDATE WRBHBMarkup SET IsActive=0,IsDeleted=1,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() WHERE Id=@Id

	INSERT INTO WRBHBMarkup (Flag,Value,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
	VALUES (@Flag,@Value,1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
	
	SELECT Id,RowId FROM WRBHBMarkup WHERE Id=@@IDENTITY;	
END
END