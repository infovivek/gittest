---=====
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_usermasterhelp]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_usermasterhelp]
GO 
create procedure sp_usermasterhelp
(
@PAction   nvarchar(100),
@Param1    nvarchar(100),
@Param2    nvarchar(100),
@Id        bigint
)
as 
begin
--declare @Action varchar(100)
DECLARE @UserPassword VARCHAR(100)

DECLARE @Cnt INT;
IF @PAction ='IncCodeGenerate'
BEGIN
/*SET @Cnt=(SELECT COUNT(*) FROM WRBHBUser WHERE ISNULL(CountId,0)=0);
IF @Cnt=0 BEGIN SELECT 1 AS DocNo;END
ELSE BEGIN
SELECT TOP 1 CAST(CountId AS INT)+1 AS DocNo FROM WRBHBUser 
WHERE ISNULL(CountId,0)=0 ORDER BY Id DESC;
END*/
	declare @VChNoPif1 nvarchar(100), @VchCode1 nvarchar(100),@LenChar1 int
	--select top 1 @VchCode=Code from WrbHMSAdvanceAmount order by Code DESC
	--select @VChNoPif='Adv-',@LenChar=len(100000)
	--select @VChNoPif+RIGHT('00000000' +ISNULL(CONVERT(VARCHAR,
	--MAX(CONVERT(NUMERIC,RIGHT(@VchCode,@LenChar)))+1),1),@LenChar) as DocNo;
	SELECT TOP 1 @VchCode1=CountId FROM WRBHBUser ORDER BY CountId DESC;
    SELECT @LenChar1=len(100000);
    SELECT RIGHT(ISNULL(CONVERT(VARCHAR,MAX(CONVERT(NUMERIC,RIGHT(@VchCode1,@LenChar1)))+1),1)
    ,@LenChar1)
    as DocNo;
END

IF @PAction ='User'
BEGIN	
			SELECT  RoleName label,Id UserId,0 as Id,isnull(RoleGroup,'') as  UserType
			 FROM dbo.WRBHBRoles 
			WHERE  IsActive=1  AND IsDeleted=0-- AND UserGroup='Other Roles';
END
IF @PAction ='UserDelete'
BEGIN	
			update WRBHBUserRoles set IsActive=0,IsDeleted=1,ModifiedBy=1,ModifiedDate=GETDATE() where Id=@Id

END
IF @PAction ='Password'
BEGIN
     OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
     SELECT  CONVERT(VARCHAR(100),decryptbykey(UserPassword, 1, convert(VARCHAR(300), 'HB@1wr')))
     AS UserPassword,Id FROM WRBHBUser WHERE Id=@Id
END
IF @PAction ='Password_update'
BEGIN
	 select @UserPassword=@Param2
	 OPEN SYMMETRIC KEY sk_key DECRYPTION BY PASSWORD = 'WARBHB@Pass';
     UPDATE WRBHBUser SET UserPassword= encryptbykey(key_guid('sk_key'),@UserPassword,1,'HB@1wr')
     WHERE Id=@Id
END
END 