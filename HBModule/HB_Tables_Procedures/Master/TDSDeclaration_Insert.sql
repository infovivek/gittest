
GO
/****** Object:  StoredProcedure [dbo].[Sp_Tia&ATia_Insert]    Script Date: 07/07/2014 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TDSDeclaration_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TDSDeclaration_Insert
GO

/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TDSDeclaration_Insert
		Purpose  	: TDSDeclaration_Insert
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
CREATE PROCEDURE [dbo].[Sp_TDSDeclaration_Insert]
(
@PropertyId			BIGINT,
@OwnerId			BIGINT,
@PanNo				NVARCHAR(100),
@TDSPercentage		DECIMAL(27,2),
@Date			    NVARCHAR(100),
@FinancialYear		NVARCHAR(100),
@Image				NVARCHAR(MAX),
@CreatedBy			INT
) 
AS
BEGIN
IF EXISTS (SELECT NULL FROM WRBHBTDSDeclaration WITH (NOLOCK) WHERE PropertyId=@PropertyId AND 
OwnerId=@OwnerId AND FinancialYearId=@FinancialYear AND IsDeleted = 0 AND IsActive = 1)
BEGIN
UPDATE WRBHBTDSDeclaration SET IsActive=0,IsDeleted=1 WHERE PropertyId=@PropertyId AND 
OwnerId=@OwnerId AND FinancialYearId=@FinancialYear AND IsDeleted = 0 AND IsActive = 1

INSERT INTO WRBHBTDSDeclaration(PropertyId,OwnerId,PANNO,TDSPercentage,FinancialYearId,Image,IsActive,IsDeleted,
			CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
VALUES (@PropertyId,@OwnerId,@PanNo,@TDSPercentage,@FinancialYear,@Image,
		1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
		
 SELECT Id,RowId FROM WRBHBTDSDeclaration WHERE Id=@@IDENTITY;	

END
ELSE
BEGIN
INSERT INTO WRBHBTDSDeclaration(PropertyId,OwnerId,PANNO,TDSPercentage,FinancialYearId,Image,IsActive,IsDeleted,
			CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,Date)
VALUES (@PropertyId,@OwnerId,@PanNo,@TDSPercentage,@FinancialYear,@Image,
		1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID(),COnvert(date,@Date,103))
		
 SELECT Id,RowId FROM WRBHBTDSDeclaration WHERE Id=@@IDENTITY;		
END
END
