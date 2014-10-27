SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_TrGenerateClient_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_TrGenerateClient_Help]
GO 
 /* 
       Author Name : <Anbu>
		Created On 	: <Created Date (25/10/2014)  >
		Section  	: TrGenerateClient
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
CREATE PROCEDURE [dbo].[Sp_TrGenerateClient_Help]
(
@PAction		 NVARCHAR(100)=NULL,
@Id				 BIGINT,
@Str			 NVARCHAR(100)=NULL, 
@UserId          BIGINT
)
AS
BEGIN 
IF @PAction ='Pageload'
BEGIN
			SELECT  Id,ClientName label FROM WRBHBClientManagement 
			WHERE  IsActive=1  AND IsDeleted=0 AND  Status='Active' 
END
IF @PAction ='Generate'
BEGIN
			DECLARE @Id1 INT
			SET @Id1=(SELECT Id FROM WRBHBTrClient WHERE ClientId=@Id)
			
			IF(@Id1 !=0)
			BEGIN
				SELECT  TrClient FROM WRBHBTrClient 
				WHERE  IsActive=1  AND IsDeleted=0 AND ClientId=@Id
			END
			ELSE
			BEGIN
				SELECT  SUBSTRING(CONVERT(NVARCHAR(100),RowId,103),0,9) FROM WRBHBClientManagement 
				WHERE  IsActive=1  AND IsDeleted=0  AND Id=@Id
			END
END
END