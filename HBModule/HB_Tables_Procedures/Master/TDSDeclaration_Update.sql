
GO
/****** Object:  StoredProcedure [dbo].[Sp_Tia&ATia_Update]    Script Date: 07/07/2014 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TDSDeclaration_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].Sp_TDSDeclaration_Update
GO

/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: TDSDeclaration_Update
		Purpose  	: TDSDeclaration_Update
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
CREATE PROCEDURE [dbo].[Sp_TDSDeclaration_Update]
(
@PropertyId			BIGINT,
@OwnerId			BIGINT,
@PanNo				NVARCHAR(100),
@TDSPercentage		DECIMAL(27,2),
@Date			    NVARCHAR(100),
@FinancialYear		NVARCHAR(100),
@Image				NVARCHAR(MAX),
@CreatedBy			INT,
@Id					BIGINT
) 
AS
BEGIN
Update WRBHBTDSDeclaration SET PropertyId=@PropertyId,OwnerId=@OwnerId,PANNO=@PanNo,TDSPercentage=@TDSPercentage,
		FinancialYearId=@FinancialYear,Image=@Image,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),Date=@Date
		WHERE Id=@Id
		
 SELECT Id,RowId FROM WRBHBTDSDeclaration WHERE Id=@@IDENTITY;		
END
