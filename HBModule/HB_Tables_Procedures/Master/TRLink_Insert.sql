 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TRLink_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TRLink_Insert]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (25/07/2014)  >
		Section  	: TRLink Generation
		Purpose  	: TRLink Generation
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
CREATE PROCEDURE [dbo].[Sp_TRLink_Insert]
(
@ClientId	BIGINT,
@UserId		BIGINT
) 
AS
BEGIN
DECLARE @ErrMsg NVARCHAR(MAX);
IF EXISTS(SELECT NULL FROM WRBHBTRLink WITH (NOLOCK) 
        WHERE  ClientId=@ClientId AND IsDeleted=0 AND IsActive=1 )   
   BEGIN  
		SET @ErrMsg = 'Link Already Exist For This Client';  
		SELECT @ErrMsg;     
   END 
ELSE
BEGIN    
DECLARE @RowId NVARCHAR(100),@TRLink NVARCHAR(100);
SET @RowId=(SELECT LEFT(RowId,8) FROM WRBHBClientManagement WHERE Id=@ClientId)
SET @TRLink='www.staysimplyfied.com/'+@RowId
--SELECT @TRLink

INSERT INTO WRBHBTRLink(ClientId,TRLink,IsActive,IsDeleted,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId)
VALUES (@ClientId,@TRLink,1,0,@UserId,GETDATE(),@UserId,GETDATE(),NEWID())
		
 SELECT Id,RowId,TRLink FROM WRBHBTRLink WHERE Id=@@IDENTITY;		
END		
END

