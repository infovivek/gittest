 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientColumn_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_ClientColumn_Insert]
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
CREATE PROCEDURE [dbo].[Sp_ClientColumn_Insert]
(
@ClientId	BIGINT,
@Column1	NVARCHAR(100),
@Column2	NVARCHAR(100),
@Column3	NVARCHAR(100),
@Column4	NVARCHAR(100),
@Column5	NVARCHAR(100),
@Column6	NVARCHAR(100),
@Column7	NVARCHAR(100),
@Column8	NVARCHAR(100),
@Column9	NVARCHAR(100),
@Column10	NVARCHAR(100),
@CreatedBy	BIGINT
) 
AS
BEGIN
INSERT INTO WRBHBClientColumns (ClientId,Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,
			Column10,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
VALUES (@ClientId,@Column1,@Column2,@Column3,@Column4,@Column5,@Column6,@Column7,@Column8,@Column9,@Column10,
		1,0,@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NEWID())
		
 SELECT Id,RowId FROM WRBHBClientColumns WHERE Id=@@IDENTITY;		
END		