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
 IF EXISTS (SELECT NULL FROM WRBHBAPIRateMealPlanInclusionDtls
 WHERE HotelId = @HotelId AND HeaderId = @HeaderId AND 
 RatePlanCode = @RatePlanCode)
  BEGIN
   UPDATE WRBHBAPIRateMealPlanInclusionDtls SET RatePlanType = @RatePlanType,
   MealPlanCode = @MealPlanCode,MealPlan = @MealPlan,Dt = GETDATE(),
   InclusionCode = @InclusionCode WHERE HotelId = @HotelId AND 
   HeaderId = @HeaderId AND RatePlanCode = @RatePlanCode;
   SELECT Id FROM WRBHBAPIRateMealPlanInclusionDtls
   WHERE HotelId = @HotelId AND HeaderId = @HeaderId AND 
   RatePlanCode = @RatePlanCode;   
  END
 ELSE
  BEGIN
   INSERT INTO WRBHBAPIRateMealPlanInclusionDtls(HeaderId,HotelId,
   RatePlanType,RatePlanCode,MealPlanCode,MealPlan,InclusionCode,Dt)
   VALUES(@HeaderId,@HotelId,dbo.TRIM(@RatePlanType),
   dbo.TRIM(@RatePlanCode),dbo.TRIM(@MealPlanCode),dbo.TRIM(@MealPlan),
   dbo.TRIM(@InclusionCode),GETDATE());
   SELECT Id FROM WRBHBAPIRateMealPlanInclusionDtls WHERE Id=@@IDENTITY;
  END
END
GO
