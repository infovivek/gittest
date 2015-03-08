SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PayU_Insert]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_PayU_Insert]
GO
CREATE PROCEDURE [dbo].[SP_PayU_Insert](@mihpayid NVARCHAR(100),
@mode NVARCHAR(100),@status NVARCHAR(100),@Merchantkey NVARCHAR(100),
@txnid NVARCHAR(100),@amount NVARCHAR(100),@discount NVARCHAR(100),
@offer NVARCHAR(100),@productinfo NVARCHAR(100),@firstname NVARCHAR(100),
@lastname NVARCHAR(100),@address1 NVARCHAR(100),@address2 NVARCHAR(100),
@city NVARCHAR(100),@state NVARCHAR(100),@country NVARCHAR(100),@zipcode NVARCHAR(100),
@email NVARCHAR(100),@phone NVARCHAR(100),@udf1 NVARCHAR(100),@udf2 NVARCHAR(100),
@udf3 NVARCHAR(100),@udf4 NVARCHAR(100),@udf5 NVARCHAR(100),@Hash NVARCHAR(MAX),
@Error NVARCHAR(100),@bankcode NVARCHAR(100),@PG_TYPE NVARCHAR(100),
@bank_ref_num NVARCHAR(100),@shipping_firstname NVARCHAR(100),
@shipping_lastname NVARCHAR(100),@shipping_address1 NVARCHAR(100),
@shipping_address2 NVARCHAR(100),@shipping_city NVARCHAR(100),
@shipping_state NVARCHAR(100),@shipping_country NVARCHAR(100),
@shipping_zipcode NVARCHAR(100),@shipping_phone NVARCHAR(100),
@unmappedstatus NVARCHAR(100),@Hashstatus NVARCHAR(100)) 
AS
BEGIN 
 /*UPDATE WrbHBPayU SET mihpayid = @mihpayid,mode = @mode,status = @status,
 Merchantkey = @Merchantkey,amount = @amount,discount = @discount,offer = @offer,
 productinfo = @productinfo,firstname = @firstname,email = @email,phone = @phone,
 Hash = @Hash,Error = @Error,bankcode = @bankcode,PG_TYPE = @PG_TYPE,
 bank_ref_num = @bank_ref_num,unmappedstatus = @unmappedstatus 
 WHERE BookingRowId = @txnid AND Id = @udf5;*/
 /*UPDATE WrbHBPayU SET mihpayid=@mihpayid,mode=@mode,status=@status,
 Merchantkey=@Merchantkey,amount=@amount,discount=@discount,offer=@offer,
 productinfo=@productinfo,firstname=@firstname,lastname=@lastname,address1=@address1,
 address2=@address2,city=@city,state=@state,country=@country,zipcode=@zipcode,
 email=@email,phone=@phone,udf1=@udf1,udf2=@udf2,udf3=@udf3,udf4=@udf4,Hash=@Hash,
 Error=@Error,bankcode=@bankcode,PG_TYPE=@PG_TYPE,bank_ref_num=@bank_ref_num,
 shipping_firstname=@shipping_firstname,shipping_lastname=@shipping_lastname,
 shipping_address1=@shipping_address1,shipping_address2=@shipping_address2,
 shipping_city=@shipping_city,shipping_state=@shipping_state,
 shipping_country=@shipping_country,shipping_zipcode=@shipping_zipcode,
 shipping_phone=@shipping_phone,unmappedstatus=@unmappedstatus,
 Hashstatus=@Hashstatus,udf5 = @udf5
 WHERE BookingRowId = @txnid AND Id = @udf5;
 SELECT @udf5;*/
 INSERT INTO WrbHBPayU(BookingRowId,Sendhash,mihpayid,mode,status,Merchantkey,amount,
 discount,offer,productinfo,firstname,lastname,address1,address2,city,state,country,
 zipcode,email,phone,udf1,udf2,udf3,udf4,udf5,Hash,Error,bankcode,PG_TYPE,bank_ref_num,
 shipping_firstname,shipping_lastname,shipping_address1,shipping_address2,shipping_city,
 shipping_state,shipping_country,shipping_zipcode,shipping_phone,unmappedstatus,
 Hashstatus)
 VALUES(@txnid,'',@mihpayid,@mode,@status,@Merchantkey,@amount,@discount,@offer,
 @productinfo,@firstname,@lastname,@address1,@address2,@city,@state,@country,
 @zipcode,@email,@phone,@udf1,@udf2,@udf3,@udf4,@udf5,@Hash,@Error,@bankcode,
 @PG_TYPE,@bank_ref_num,@shipping_firstname,@shipping_lastname,@shipping_address1,
 @shipping_address2,@shipping_city,@shipping_state,@shipping_country,
 @shipping_zipcode,@shipping_phone,@unmappedstatus,@Hashstatus);
 SELECT Id FROM WRBHBBooking WHERE REPLACE(ROWID,'-','') = @txnid;
 SELECT Id FROM WrbHBPayU WHERE Id = @@IDENTITY;
END
GO
