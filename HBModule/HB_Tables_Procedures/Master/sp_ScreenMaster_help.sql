SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_ScreenMaster_help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_ScreenMaster_help]
GO 
create procedure sp_ScreenMaster_help
(
@Action Nvarchar(100),
@Id int
)
as 
begin
 
IF @Action ='PAGELOAD'
Begin
	declare @VChNoPif1 nvarchar(100), @VchCode1 nvarchar(100),@LenChar1 int 
	SELECT TOP 1 @VchCode1=CountId FROM WRBHBScreenMaster ORDER BY CountId DESC;
	
    SELECT @LenChar1=len(100000);
    SELECT RIGHT(ISNULL(CONVERT(VARCHAR,MAX(CONVERT(NUMERIC,RIGHT(@VchCode1,@LenChar1)))+1),1)
    ,@LenChar1)
    as CountId;
    --Getting Date
    SELECT CONVERT(VARCHAR(100),GETDATE(),103) AS Dt;
    
    SELECT DISTINCT ModuleName as label,Id as data FROM WRBHBScreenMaster
    where ModuleId=0
 END
 END