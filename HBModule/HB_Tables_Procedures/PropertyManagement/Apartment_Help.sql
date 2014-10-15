SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_Apartment_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_Apartment_Help]
GO 
 /* 
       Author Name : <ARUNPRASATH.k>
		Created On 	: <Created Date (05/02/2014)  >
		Section  	: PROPERTY Apartment Help
		Purpose  	: Apartment Help
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
CREATE PROCEDURE [dbo].[Sp_Apartment_Help](
@PAction		 NVARCHAR(100)=NULL,
@PropertyId      BIGINT,
@Pram1           BIGINT=NULL, 
@Pram2			 NVARCHAR(100)=NULL, 
@UserId          BIGINT
)
AS
BEGIN  
IF @PAction ='Apartment'
BEGIN
			SELECT  BlockId,BlockName FROM WRBHBPropertyApartment 
			where  IsActive=1   
END 
END 