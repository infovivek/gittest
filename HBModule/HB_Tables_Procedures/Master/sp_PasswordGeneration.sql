----============
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_PasswordGeneration]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_PasswordGeneration]
GO 

create proc sp_PasswordGeneration
    @len int,
    @min tinyint = 48,
    @range tinyint = 74,
    @exclude varchar(50) = '0:;<=>?@O[]`^\/',
    @output varchar(50) output
as 
begin
    declare @char char
    set @output = ''
 
    while @len > 0 begin
       select @char = char(round(rand() * @range + @min, 0))
       if charindex(@char, @exclude) = 0 begin
           set @output += @char
           set @len = @len - 1
       end
    end
;



declare @newpwd varchar(20)


-- all values between ASCII code 48 - 122 excluding defaults
exec sp_PasswordGeneration @len=8, @output=@newpwd out
select @newpwd
end