SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_APIRateMealPlanInclusionDetails_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_APIRateMealPlanInclusionDetails_Insert]
GO   
/* 
Author Name : Sakthi
Created Date : Aug 19 2014
Section  	: API Meal Plan Details Insert
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date		     Description of Changes
********************************************************************************************************	

*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[SP_APIRateMealPlanInclusionDetails_Insert](
@HotelId BIGINT,
@HeaderId BIGINT,
@RatePlanType NVARCHAR(100),
@RatePlanCode NVARCHAR(100),
@MealPlanCode NVARCHAR(100),
@MealPlan NVARCHAR(100),
@InclusionCode NVARCHAR(MAX))
AS
BEGIN
 INSERT INTO WRBHBAPIRateMealPlanInclusionDtls(HeaderId,HotelId,
 RatePlanType,RatePlanCode,MealPlanCode,MealPlan,InclusionCode)
 VALUES(@HeaderId,@HotelId,dbo.TRIM(@RatePlanType),
 dbo.TRIM(@RatePlanCode),dbo.TRIM(@MealPlanCode),dbo.TRIM(@MealPlan),
 dbo.TRIM(@InclusionCode));
 SELECT Id FROM WRBHBAPIRateMealPlanInclusionDtls WHERE Id=@@IDENTITY;
END
GO
