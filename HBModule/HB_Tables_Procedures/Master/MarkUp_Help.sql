 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_MarkUp_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_MarkUp_Help]
GO   
/* 
        Author Name : <Naharjun.U>
		Created On 	: <Created Date (13/05/2014)  >
		Section  	: MARKUP HELP
		Purpose  	: MARKUP HELP
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
CREATE PROCEDURE [dbo].[Sp_MarkUp_Help]
(
@Action		NVARCHAR(100),
--@Str1		NVARCHAR(100),
--@Str2		NVARCHAR(100),
@UserId		INT,
@Id		INT
)
AS
BEGIN


IF @Action='Pageload'
BEGIN
	SELECT Value,Flag,Id FROM WRBHBMarkup WHERE IsActive=1 AND IsDeleted=0
	
	--Declare @Id1 INT
--set @Id1=(SELECT TOP 1 Id from WRBHBMarkup where IsActive=1 order by Id desc)

	CREATE TABLE #TEMP(Id BIGINT,Flag nvarchar(100),Value nvarchar(100),CreatedDate nvarchar(100),CreatedBy nvarchar(100)) 
	INSERT INTO #TEMP (Id,Flag,Value,CreatedDate,CreatedBy)
	
	SELECT M.Id,'%' as Flag,Value,Convert(nvarchar(100),M.CreatedDate,103) as CreatedDate,U.FirstName as CreatedBy
	FROM WRBHBMarkup M
	LEFT OUTER JOIN WRBHBUser U ON U.Id=M.CreatedBy and U.IsActive=1 and u.IsDeleted=0
	WHERE M.IsActive=0 and M.IsDeleted=1 and Flag=1 order by M.Id desc; 
	
	INSERT INTO #TEMP (Id,Flag,Value,CreatedDate,CreatedBy)
	SELECT M.Id,'Rs' as Flag,Value,Convert(nvarchar(100),M.CreatedDate,103) as CreatedDate,U.FirstName as CreatedBy
	FROM WRBHBMarkup M
	LEFT OUTER JOIN WRBHBUser U ON U.Id=M.CreatedBy and U.IsActive=1 and u.IsDeleted=0
	WHERE M.IsActive=0 and M.IsDeleted=1 and Flag=0 order by M.Id desc;
	
	SELECT TOP 10 Id,Flag,Value,CreatedDate,CreatedBy FROM #TEMP order by Id desc
	
	SELECT TOP 10 MMTMarkup,M.Id,U.FirstName as CreatedBy,Convert(nvarchar(100),M.CreatedDate,103) as CreatedDate
	FROM WRBHBMMTMarkupHistory M
	JOIN WRBHBUser U ON U.Id=M.CreatedBy and U.IsActive=1 and u.IsDeleted=0
	and M.Id not in (Select Id from WRBHBMMTMarkup)
	and M.isactive=0 and M.IsDeleted=1
	 order by M.Id desc
	
	Select Id,MMTMarkup from WRBHBMMTMarkup
END
END

