----============
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[sp_usermasterupdate]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[sp_usermasterupdate]
GO 
create procedure sp_usermasterupdate
(
@Id                   bigint,
--@Title              nvarchar(100),
@UserName             nvarchar(100),
--@UserPassword		  nvarchar(100),
--@UserGroup		  nvarchar(100),
--@UserRoles			  nvarchar(100),
@Email				  nvarchar(100),
@FirstName			  nvarchar(100),
@LastName			  nvarchar(100),
@Address			  nvarchar(100),
@State				  nvarchar(100),
@City				  nvarchar(100),
@Zip				  nvarchar(100),
--@PhoneNumber		  nvarchar(100),
@MobileNumber		  nvarchar(100),
@CreatedBy			  bigint,
@EmployeeID			  nvarchar(100),
@CountId			  bigint
)
as 
begin
--DECLARE @InsId INT,@ErrMsg NVARCHAR(MAX);
--IF EXISTS(SELECT NULL FROM WRBHBUser WITH (NOLOCK) WHERE UserName=@UserName AND Email=@Email AND IsDeleted=0 AND IsActive=1) 
--BEGIN
--SET @ErrMsg = 'UserName or EmailId Already Exist';
--SELECT @ErrMsg;
--end
--else
begin
update WRBHBUser set /*Title=@Title*/UserName=@FirstName/*UserPassword=@UserPassword,UserGroup=@UserGroup,Email=@Email*/,FirstName=@FirstName,
                     LastName=@LastName,Address=@Address,State=@State,City=@City,Zip=@Zip,/*PhoneNumber=@PhoneNumber*/MobileNumber=@MobileNumber,
                     CreatedBy=@CreatedBy,CreatedDate=GETDATE(),ModifiedBy=@CreatedBy,ModifiedDate=GETDATE(),EmployeeID=@EmployeeID where Id=@Id
                     
SELECT Id,RowId FROM WRBHBUser WHERE Id=@Id;                     
end
end