using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using test1.Models;

namespace test1.Controllers
{
    public class PayUController : Controller
    {
        //
        // GET: /PayU/
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        SendingMailController Mail = new SendingMailController();
        public string action1 = string.Empty;
        public string hash1 = string.Empty;
        public string txnid1 = string.Empty;

        public ActionResult Success()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            try
            {
                string Label1;
                string Label2;
                string Label3;
                Int64 Id = 0;
                string[] merc_hash_vars_seq;
                string merc_hash_string = string.Empty;
                string merc_hash = string.Empty;
                string order_id = string.Empty;
                string hash_seq = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10";
                Label1 = "mihpayid : " + Request.Form["mihpayid"] + ",<br> mode : " + Request.Form["mode"] +
                    ",<br> status : " + Request.Form["status"] + ",<br> key : " + Request.Form["key"] +
                    ",<br> txnid : " + Request.Form["txnid"] + ",<br> amount : " + Request.Form["amount"] +
                    ",<br> discount : " + Request.Form["discount"] + ",<br> offer : " + Request.Form["offer"] +
                    ",<br> productinfo : " + Request.Form["productinfo"] + ",<br> firstname : " + Request.Form["firstname"] +
                    ",<br> lastname : " + Request.Form["lastname"] + ",<br> Hash : " + Request.Form["Hash"] +
                    ",<br> Error : " + Request.Form["Error"] + ",<br> bankcode : " + Request.Form["bankcode"] +
                    ",<br> udf5 : " + Request.Form["udf5"] +
                    ",<br> PG_TYPE : " + Request.Form["PG_TYPE"] + ",<br> bank_ref_num : " + Request.Form["bank_ref_num"];
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_PayU_Insert_FrontEnd";
                command.CommandType = CommandType.StoredProcedure;
                if (Request.Form["status"] == "success")
                {
                    merc_hash_vars_seq = hash_seq.Split('|');
                    Array.Reverse(merc_hash_vars_seq);
                    merc_hash_string = ConfigurationManager.AppSettings["SALT"] + "|" + Request.Form["status"];
                    foreach (string merc_hash_var in merc_hash_vars_seq)
                    {
                        merc_hash_string += "|";
                        merc_hash_string = merc_hash_string + (Request.Form[merc_hash_var] != null ? Request.Form[merc_hash_var] : "");
                    }
                    merc_hash = Generatehash512(merc_hash_string).ToLower();
                    if (merc_hash != Request.Form["hash"])
                    {
                        Response.Write("Hash value did not matched");
                        command.Parameters.Add("@Hashstatus", SqlDbType.NVarChar).Value = "status : success,Hash value not matched";
                    }
                    else
                    {
                        order_id = Request.Form["txnid"];
                        //Response.Write("value matched");                        
                        command.Parameters.Add("@Hashstatus", SqlDbType.NVarChar).Value = "status : success,Hash value matched";
                    }
                    Label3 = "Your Payment is received. An Automated email confirmation will be sent to confirm your Stay in 10 mins.";
                }
                else if (Request.Form["status"] == "failure")
                {
                    Label3 = "Your Payment is failure.Try Again";
                    command.Parameters.Add("@Hashstatus", SqlDbType.NVarChar).Value = "status : failure";
                }
                else
                {
                    Label3 = "Invalid Process.";
                    //Response.Write("Hash value did not matched");
                    // osc_redirect(osc_href_link(FILENAME_CHECKOUT, 'payment' , 'SSL', null, null,true));                    
                    //command.Parameters.Add("@Hashstatus", SqlDbType.NVarChar).Value = "status : failure,Hash value not matched";
                }
                if ((Request.Form["status"] == "failure") || (Request.Form["status"] == "success"))
                {
                    command.Parameters.Add("@mihpayid", SqlDbType.NVarChar).Value = Request.Form["mihpayid"];
                    command.Parameters.Add("@mode", SqlDbType.NVarChar).Value = Request.Form["mode"];
                    command.Parameters.Add("@status", SqlDbType.NVarChar).Value = Request.Form["status"];
                    command.Parameters.Add("@Merchantkey", SqlDbType.NVarChar).Value = Request.Form["key"];
                    command.Parameters.Add("@txnid", SqlDbType.NVarChar).Value = Request.Form["txnid"];
                    command.Parameters.Add("@amount", SqlDbType.NVarChar).Value = Request.Form["amount"];
                    Label2 = Request.Form["discount"];
                    command.Parameters.Add("@discount", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["offer"];
                    command.Parameters.Add("@offer", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    command.Parameters.Add("@productinfo", SqlDbType.NVarChar).Value = Request.Form["productinfo"];
                    command.Parameters.Add("@firstname", SqlDbType.NVarChar).Value = Request.Form["firstname"];

                    Label2 = Request.Form["lastname"];
                    command.Parameters.Add("@lastname", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["address1"];
                    command.Parameters.Add("@address1", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["address2"];
                    command.Parameters.Add("@address2", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["city"];
                    command.Parameters.Add("@city", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["state"];
                    command.Parameters.Add("@state", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : ""; ;

                    Label2 = Request.Form["country"];
                    command.Parameters.Add("@country", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["zipcode"];
                    command.Parameters.Add("@zipcode", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    command.Parameters.Add("@email", SqlDbType.NVarChar).Value = Request.Form["email"];
                    command.Parameters.Add("@phone", SqlDbType.NVarChar).Value = Request.Form["phone"];

                    Label2 = Request.Form["udf1"];
                    command.Parameters.Add("@udf1", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : ""; ;

                    Label2 = Request.Form["udf2"];
                    command.Parameters.Add("@udf2", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["udf3"];
                    command.Parameters.Add("@udf3", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["udf4"];
                    command.Parameters.Add("@udf4", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["udf5"];
                    command.Parameters.Add("@udf5", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    command.Parameters.Add("@Hash", SqlDbType.NVarChar).Value = Request.Form["Hash"];
                    command.Parameters.Add("@Error", SqlDbType.NVarChar).Value = Request.Form["Error"];
                    command.Parameters.Add("@bankcode", SqlDbType.NVarChar).Value = Request.Form["bankcode"];
                    command.Parameters.Add("@PG_TYPE", SqlDbType.NVarChar).Value = Request.Form["PG_TYPE"];
                    command.Parameters.Add("@bank_ref_num", SqlDbType.NVarChar).Value = Request.Form["bank_ref_num"];
                    Label2 = Request.Form["shipping_firstname"];
                    command.Parameters.Add("@shipping_firstname", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_lastname"];
                    command.Parameters.Add("@shipping_lastname", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_address1"];
                    command.Parameters.Add("@shipping_address1", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_address2"];
                    command.Parameters.Add("@shipping_address2", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_city"];
                    command.Parameters.Add("@shipping_city", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_state"];
                    command.Parameters.Add("@shipping_state", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_country"];
                    command.Parameters.Add("@shipping_country", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_zipcode"];
                    command.Parameters.Add("@shipping_zipcode", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    Label2 = Request.Form["shipping_phone"];
                    command.Parameters.Add("@shipping_phone", SqlDbType.NVarChar).Value = Label2 != null ? Label2 : "";

                    command.Parameters.Add("@unmappedstatus", SqlDbType.NVarChar).Value = Request.Form["unmappedstatus"];
                    ds = new WrbErpConnection().ExecuteDataSet(command, "");
                    if (Request.Form["status"] == "failure")
                    {
                        return View("Failure");
                    }
                    if (Request.Form["status"] == "success")
                    {
                        try
                        {                         
                                Id = Convert.ToInt64(ds.Tables[0].Rows[0][0].ToString());
                                string level = ds.Tables[0].Rows[0][1].ToString();


                                if (level.ToUpper() == "ROOM")
                                {
                                    if(ds.Tables[0].Rows[0][2].ToString() == "MMT")
                                    {
                                        Mail.MMTBookingConfirmedMail(Convert.ToInt32(Id));
                                    }
                                    else
                                    {
                                        Mail.RoomBookingMail(Id);
                                    }                                  
                                }
                                if (level.ToUpper() == "BED")
                                {
                                    Mail.BedBookingMail(Id);
                                }
                                if (level.ToUpper() == "APARTMENT")
                                {
                                    Mail.ApartmentBookingMail(Id);
                                }                               
                            
                            return View();
                        }
                        catch (Exception exe)
                        {
                            CreateLogFiles Err = new CreateLogFiles();
                            Err.ErrorLog("success page Error - PayU Id error : " + exe.Message);
                            return RedirectToAction("Failure", "Search", new  { msg = "Payment Received Successfully but Confirmation Email is not sent to you because of some error so please contact your booking team"});
                        }
                    }
                    else
                    {
                        return RedirectToAction("Failure", "Search");
                    }
                }
            }
            catch (Exception ex)
            {

                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog("success page Error : Empty Click - " + ex.Message);
                return RedirectToAction("Failure", "Search");
            }
            return View();
        }

        public ActionResult Failure()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            return View();
        }

        public string Generatehash512(string text)
        {

            byte[] message = Encoding.UTF8.GetBytes(text);
            UnicodeEncoding UE = new UnicodeEncoding();
            byte[] hashValue;
            SHA512Managed hashString = new SHA512Managed();
            string hex = "";
            hashValue = hashString.ComputeHash(message);
            foreach (byte x in hashValue)
            {
                hex += String.Format("{0:x2}", x);
            }
            return hex;
        }


    }
}