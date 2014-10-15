 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_CompanyMaster_Update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_CompanyMaster_Update]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (22/04/2014)  >
		Section  	: COMPANY MASTER UPDATE
		Purpose  	: LOGO UPDATE
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
CREATE PROCEDURE [dbo].[Sp_CompanyMaster_Update]
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
@Id					INT,
@ImageName			NVARCHAR(100)
) 
AS
BEGIN
update WRBHBCompanyMaster set LegalCompanyName=@LegalCompanyName,CompanyShortName=@CompanyShortName,
							  Address=@Address,City=@City,State=@State,Phone=@Phone,Email=@Email,
							  PanCardNo=@PanCardNo,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),
							  ImageName=@ImageName
		WHERE Id=@Id
SELECT Id,Rowid FROM WRBHBCompanyMaster WHERE Id=@Id		
END		