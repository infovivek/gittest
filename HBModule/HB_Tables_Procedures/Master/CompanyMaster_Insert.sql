 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CompanyMaster_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_CompanyMaster_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: COMPANY MASTER INSERT
		Purpose  	: LOGO INSERT
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
CREATE PROCEDURE [dbo].[Sp_CompanyMaster_Insert]
(
@LegalCompanyName	NVARCHAR(100),
@CompanyShortName	NVARCHAR(100),
@Address			NVARCHAR(100),
@City				BIGINT,
@State				INT,
@Phone				NVARCHAR(100),
@Email				NVARCHAR(100),
@PanCardNo			NVARCHAR(100),
@Logo				NVARCHAR(MAX),
@CreatedBy			INT,
@ImageName			NVARCHAR(100)
) 
AS
BEGIN
INSERT INTO WRBHBCompanyMaster(LegalCompanyName,CompanyShortName,Address,City,State,Phone,Email,PanCardNo,
			IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,ImageName)
VALUES (@LegalCompanyName,@CompanyShortName,@Address,@City,@State,@Phone,@Email,@PanCardNo,1,0,@CreatedBy,GETDATE(),
		@CreatedBy,GETDATE(),NEWID(),@ImageName)
		
 SELECT Id,RowId FROM WRBHBCompanyMaster WHERE Id=@@IDENTITY;		
END		