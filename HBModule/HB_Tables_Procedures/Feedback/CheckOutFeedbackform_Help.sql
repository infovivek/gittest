SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = OBJECT_ID(N'[dbo].[Sp_CheckOutFeedbackform_Help]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Sp_CheckOutFeedbackform_Help]
GO
 
CREATE PROCEDURE [dbo].[Sp_CheckOutFeedbackform_Help]
(
@Action NVARCHAR(100)=NULL,
@FromDt NVARCHAR(100)=NULL,
@ToDt  NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Str2 NVARCHAR(100)=NULL, 
@Id1 INT=NULL,
@Id2 INT=NULL, 
@UserId INT=NULL
)
AS
 -- Set @Str1='C6953DF4-41BB-4BDE-8A34-23B81BA716034';
 -- Select LEN(@Str1);
BEGIN
	IF @Action ='Pageload'
	BEGIN

If(@Str1!='')and(LEN(@Str1)>35)
Begin
	Declare @Bookingcode Int,@CheckoutId Int,@Images Nvarchar(500),@Mobile Nvarchar(100),@chkinhdrId Bigint;
	
	Set @Images =(Select top 1 ImageName from WRBHBCompanyMaster where IsActive=1 )
	--Select ChkOutHdrId,RowId from WRBHBCheckOutSettleHdr where ChkOutHdrId=2224
	--Set @CheckoutId=(Select Id from WRBHBChechkOutHdr where rowid=@Str1 and isactive=1)
	Set @CheckoutId=(Select ChkOutHdrId from WRBHBCheckOutSettleHdr 
	                  where rowid=@Str1 and isactive=1)
	Set @Bookingcode =(Select top 1 BookingCode from WRBHBBooking H 
	            join WRBHBBookingPropertyAssingedGuest D on H.Id=d.BookingId  where CheckOutHdrId=@CheckoutId)

Set @chkinhdrId =(Select top 1 ChkInHdrId from WRBHBChechkOutHdr 
	                  where Id=@CheckoutId and IsActive=1  and IsDeleted=0) 
Set @Mobile =(Select top 1 MobileNo from WRBHBCheckInHdr 
	                  where Id=@chkinhdrId and IsActive=1  and IsDeleted=0 and MobileNo!=0)
	                  
	 Select  Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
	 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
	 @Bookingcode  Bookingcode, GETDATE() CreatedDate,RowId ,@Images Images,Email,isnull(@Mobile,'') as Mobile
	 from WRBHBChechkOutHdr
	 where Id=@CheckoutId and IsActive=1  and IsDeleted=0 and 
	  Id Not in (select isnull(CheckOutId,0) from WRBHBFeedBckForms)and
	   CONVERT(date,CreatedDate,103) <= CONVERT(date,GETDATE(),103)
	 
End
else
begin
	Select 'No data'
End
	 EnD
  
 IF @Action ='DataDelete'
	BEGIN
			 Update  WRBHBChechkOutHdr  Set Email= @Str1
			 where  IsActive=1  and  IsDeleted=0   and Id=@Id1; 
	 End
 
IF @Action ='DataUpdate'
	BEGIN
			 Update  WRBHBChechkOutHdr  Set Email= @Str1
			 where  IsActive=1  and  IsDeleted=0   and Id=@Id1; 
			 
	Select H.Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
	 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
	 0  Bookingcode, GETDATE() CreatedDate,HH.RowId RowId,'' Images,Email,'' as Mobile
	 from WRBHBChechkOutHdr H
	 join WRBHBCheckOutSettleHdr HH on H.Id=HH.ChkOutHdrId and HH.IsActive=1 and HH.IsDeleted=0
	 where  H.IsActive=1  and H.IsDeleted=0 --and hh.RowId='C3A7B608-5522-45F8-9FB4-DC7A57C3ED09'-- and H.Id=
	 order by H.Id Desc
	 
	 End

  
 
 IF @Action ='DataGrid'
	BEGIN
		If(@ToDt!='')-- prpty wise fileter
		Begin
			 Select top 10 H.Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
			 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
			 0  Bookingcode, GETDATE() CreatedDate,HH.RowId RowId,'' Images,Email,'' as Mobile
			 from WRBHBChechkOutHdr H
			 join WRBHBCheckOutSettleHdr HH on H.Id=HH.ChkOutHdrId and HH.IsActive=1 and HH.IsDeleted=0
			 where  H.IsActive=1  and H.IsDeleted=0 --and hh.RowId='C3A7B608-5522-45F8-9FB4-DC7A57C3ED09'-- and H.Id=
			 and CONVERT(date,HH.CreatedDate,103) <= CONVERT(date,GETDATE(),103)
			 and Property like '%'+@ToDt+'%'
			 order by H.Id Desc
		 END
		 If(@Str1!='')-- Client wise fileter
		Begin
			 Select top 10 H.Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
			 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
			 0  Bookingcode, GETDATE() CreatedDate,HH.RowId RowId,'' Images,Email,'' as Mobile
			 from WRBHBChechkOutHdr H
			 join WRBHBCheckOutSettleHdr HH on H.Id=HH.ChkOutHdrId and HH.IsActive=1 and HH.IsDeleted=0
			 where  H.IsActive=1  and H.IsDeleted=0 --and hh.RowId='C3A7B608-5522-45F8-9FB4-DC7A57C3ED09'-- and H.Id=
			 and CONVERT(date,HH.CreatedDate,103) <= CONVERT(date,GETDATE(),103)
			  and ClientName like '%'+@Str1+'%'
			 order by H.Id Desc
		 END
		 If(@Str2!='') -- guestwise wise fileter
		Begin
			 Select top 10 H.Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
			 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
			 0  Bookingcode, GETDATE() CreatedDate,HH.RowId RowId,'' Images,Email,'' as Mobile
			 from WRBHBChechkOutHdr H
			 join WRBHBCheckOutSettleHdr HH on H.Id=HH.ChkOutHdrId and HH.IsActive=1 and HH.IsDeleted=0
			 where  H.IsActive=1  and H.IsDeleted=0 --and hh.RowId='C3A7B608-5522-45F8-9FB4-DC7A57C3ED09'-- and H.Id=
			 and CONVERT(date,HH.CreatedDate,103) <= CONVERT(date,GETDATE(),103)
			 and GuestName like '%'+@Str2+'%'
			 order by H.Id Desc
		 END
		 If(@Str2='') and  (@Str1='') and (@ToDt='')
		Begin
		    Select   H.Id ,BookingId,ChkInHdrId,GuestName GuestName,ClientName,ClientId,Property,PropertyId,GuestId,
			 convert(nvarchar(100),CheckInDate,103)Column1,convert(nvarchar(100),CheckOutDate,103) Column2,
			 0  Bookingcode, GETDATE() CreatedDate,HH.RowId RowId,'' Images,Email,'' as Mobile
			 from WRBHBChechkOutHdr H
			 join WRBHBCheckOutSettleHdr HH on H.Id=HH.ChkOutHdrId and HH.IsActive=1 and HH.IsDeleted=0
			 where  H.IsActive=1  and H.IsDeleted=0 --and hh.RowId='C3A7B608-5522-45F8-9FB4-DC7A57C3ED09'-- and H.Id=
			 and CONVERT(date,HH.CreatedDate,103) <= CONVERT(date,GETDATE(),103) 
			 order by H.Id Desc
		End
		 
	End
 End 
 
--exec [dbo].[Sp_CheckOutFeedbackform_Help] @Action=N'Pageload',@FromDt=N'',@ToDt=N'',@Str1=N'C6953DF4-41BB-4BDE-8A34-23B81BA716034',@Str2=N'',@Id1=0,@Id2=0,@UserId=0

--ALTER TABLE WRBHBFeedBckForms
--ADD Email nvarchar(200)

--ALTER TABLE WRBHBFeedBckForms
--Add Mobile nvarchar(200)

--Update WRBHBFeedBckForms set MObile='',Email=''
 
   