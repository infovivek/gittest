using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;
using System.Text.RegularExpressions;

namespace HB.Dao
{
    public class BedBookingMailDAO
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string Err;
        String UserData;
        public DataSet Mail(int BookingId, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BedBookingMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help; 
            DataTable dT = new DataTable("Table11");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds = new DataSet();
            command.CommandText = StoredProcedures.BookingDtls_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BedBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            Err = "";
            string Flag = "true";
            string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|" +
               @"0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z]" +
               @"[a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";
            for (int j = 0; j < ds.Tables[9].Rows.Count; j++)
            {
                if (ds.Tables[9].Rows[j][0].ToString() != "")
                {
                    System.Text.RegularExpressions.Match match =
                        Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                    if (!match.Success)
                    {
                        if (Flag == "true")
                        {
                            Err += ds.Tables[9].Rows[j][0].ToString(); Flag = "false";
                        }
                        else
                        {
                            Err = Err + ", " + ds.Tables[9].Rows[j][0].ToString();
                        }
                    }
                }
            }
            if (Err != "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
                return ds;
            }
            if (Err == "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
            }
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            //ds.Tables[1].Rows[0][4].ToString()
            if (ds.Tables[10].Rows.Count > 0)
            {
                message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
            }
            else
            {
                message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
            }
            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            //message.Subject = "Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
            if (ds.Tables[4].Rows[0][0].ToString() == "0")
            {
                if (ds.Tables[8].Rows[0][0].ToString() != "")
                {
                    message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                }
            }
            else
            {
                for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                {
                    if (ds.Tables[5].Rows[i][0].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                    }
                }
                if (ds.Tables[8].Rows[0][0].ToString() != "")
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                }
            }
            //Extra CC
            for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
            {
                if (ds.Tables[7].Rows[i][0].ToString() != "")
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                }
            }
            // Extra CC email from Front end
            if (ds.Tables[8].Rows[0][1].ToString() != "")
            {
                string ExtraCC = ds.Tables[8].Rows[0][1].ToString();
                var ExtraCCEmail = ExtraCC.Split(',');
                int cnt = ExtraCCEmail.Length;
                for (int i = 0; i < cnt; i++)
                {
                    if (ExtraCCEmail[i].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                    }
                }
            }
            //
            if (ds.Tables[2].Rows[0][4].ToString() != "")
            {
                message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
            }
            message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            /*if (ds.Tables[10].Rows.Count > 0)
            {
                BMail.From = "homestay@uniglobeatb.co.in";
                //BMail.To.Add("sakthi@warblerit.com");
                //BMail.Subject = "Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                BMail.To.Add("booking_confirmation@staysimplyfied.com");                
                if (ds.Tables[4].Rows[0][0].ToString() == "0")
                {
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        BMail.To.Add(ds.Tables[8].Rows[0][0].ToString());
                    }
                }
                else
                {
                    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                    {
                        if (ds.Tables[5].Rows[i][0].ToString() != "")
                        {
                            BMail.To.Add(ds.Tables[5].Rows[i][0].ToString());
                        }
                    }
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        BMail.Cc.Add(ds.Tables[8].Rows[0][0].ToString());
                    }
                }
                //Extra CC
                for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                {
                    if (ds.Tables[7].Rows[i][0].ToString() != "")
                    {
                        BMail.Cc.Add(ds.Tables[7].Rows[i][0].ToString());
                    }
                }
                //
                if (ds.Tables[2].Rows[0][4].ToString() != "")
                {
                    BMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                }
                BMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                BMail.Bcc.Add("vivek@warblerit.com");
                BMail.Bcc.Add("arun@warblerit.com");
                BMail.Bcc.Add("sakthi@warblerit.com");
                BMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            }
            else
            {
                message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                if (ds.Tables[4].Rows[0][0].ToString() == "0")
                {
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                    }
                }
                else
                {
                    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                    {
                        if (ds.Tables[5].Rows[i][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                        }
                    }
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                    }
                }
                //Extra CC
                for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                {
                    if (ds.Tables[7].Rows[i][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                    }
                }
                //
                if (ds.Tables[2].Rows[0][4].ToString() != "")
                {
                    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();               
            }*/
            string Imagelocation = "";
            Imagelocation = ds.Tables[6].Rows[0][0].ToString();
            string Imagebody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
            /*string Imagebody =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                " <tr><td width=\"100%\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                " <img src=" + Imagelocation + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +
                " </td></tr></table>";*/
            string SecondRow =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
                " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                " </td></tr><tr><td width=\"100%\" style=\"margin-bottom:\">" +
                " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                " </td> </tr></table>";
            // Dataset Table 0 begin
            string GuestDetailsTable1 =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Bed / Day</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                " </tr>";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                GuestDetailsTable1 +=
                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                " </tr>";
            }
            GuestDetailsTable1 += "</table>";
            // Dataset Table 0 end
            string Note = "";
            string CheckInPolicy = "";
            string CheckOutPolicy = "";
            if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
            {
                Note = "This booking entitles you to use 1 bed in the room during your stay. There may be another bed in the same room, where another guest may be staying. Your room may have an attached or non-attached bath. Guests in a room will be sharing all amenities in the room and the bath.";
            }                
            if (ds.Tables[1].Rows[0][8].ToString() != "")
            {
                CheckInPolicy = ds.Tables[1].Rows[0][8].ToString() + ' ' + ds.Tables[1].Rows[0][9].ToString();
            }
            else
            {
                CheckInPolicy = "12 PM";
            }
            if (ds.Tables[1].Rows[0][10].ToString() != "")
            {
                CheckOutPolicy = ds.Tables[1].Rows[0][10].ToString() + ' ' + ds.Tables[1].Rows[0][7].ToString();
            }
            else
            {
                CheckOutPolicy = "12 PM";
            }
            string Spl = ds.Tables[2].Rows[0][8].ToString();
            if (Spl == "")
            {
                Spl = "- NA -";
            }
            string AddressDtls =
                "<p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Tax : </span>Taxes as applicable " +
                " </p>"+
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                    " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Address : </span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Phone : </span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Directions : </span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Note : </span> " + Note + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements : </span> " + Spl + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check-in Policy : </span> " + CheckInPolicy + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy : </span> " + CheckOutPolicy + "" +
                " </p><p style=\"margin-top:12px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong> 1800-425-3454</strong> ( 9:00 AM  to  5:00 PM )<br>" +
                " </p></td></tr></table>";
            // Dataset Table 1 Begin
            string UserName = "";
            string EmailId = "";
            string PhoneNo = "";
            for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
            {
                if (i == 0)
                {
                    if (ds.Tables[3].Rows[i][1].ToString() != "")
                    {
                        UserName = ds.Tables[3].Rows[i][1].ToString();
                    }
                    if (ds.Tables[3].Rows[i][2].ToString() != "")
                    {
                        EmailId = ds.Tables[3].Rows[i][2].ToString();
                    }
                    if (ds.Tables[3].Rows[i][3].ToString() != "")
                    {
                        PhoneNo = ds.Tables[3].Rows[i][3].ToString();
                    }
                }
                else
                {
                    if (ds.Tables[3].Rows[i][1].ToString() != "")
                    {
                        UserName += " , " + ds.Tables[3].Rows[i][1].ToString();
                    }
                    if (ds.Tables[3].Rows[i][2].ToString() != "")
                    {
                        EmailId += " , " + ds.Tables[3].Rows[i][2].ToString();
                    }
                    if (ds.Tables[3].Rows[i][3].ToString() != "")
                    {
                        PhoneNo += " , " + ds.Tables[3].Rows[i][3].ToString();
                    }
                }
            }
            string QRCode =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                    " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                    "  <br /><br />" +
                    "  <img src=" + ds.Tables[8].Rows[0][2].ToString() + " width=\"100\" height=\"100\" />" +
                    " <p style=\"margin-top:5px;\">" +
                    "  *NOTE: Download QRCode reader to get propery address to your maps" +
                    "    </p>" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                    " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                    " </tr></table>";
            //string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
            /*string FooterDtls =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                    " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                    " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                    " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                    " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                    " <li><span>100% refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                    " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                    " </tr></table><br>";*/
            string FooterDtls =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                    " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                    " </tr></table><br>";
                    /*<tr style=\"font-size:0px; font-weight:normal;\"> " +
                    " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                    " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                    " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                    " </td></tr> </table>";*/
            message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
            message.IsBodyHtml = true;
            // SMTP Email email:
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            smtp.EnableSsl = true;            
            smtp.Port = 587;
            //smtp.Host = "smtp.gmail.com";smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
            smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
            try
            {
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Bed Level Booking Confirmation Mail --> " + message.Subject);
            }
            /*if (ds.Tables[10].Rows.Count > 0)
            {
                BMail.HtmlBody = message.Body;
                SmtpServer BServer = new SmtpServer("mail.uniglobeatb.co.in");
                BServer.User = "homestay@uniglobeatb.co.in";
                BServer.Password = "Atb@33%";
                BServer.Port = 465;
                BServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                SmtpClient BSmtp = new SmtpClient();                
                try
                {
                    BSmtp.SendMail(BServer, BMail);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + "Bed Level Booking Confirmation Mail in Port 465" + BMail.Subject);
                }
            }
            else
            {
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + "Bed Level Booking Confirmation Mail in Port 587" + message.Subject);
                }                
            }*/

            // Property Mail
            if (ds.Tables[3].Rows.Count > 0)
            {
                if (ds.Tables[3].Rows[0][4].ToString() != "")
                {
                    string PropertyMail = ds.Tables[3].Rows[0][4].ToString();
                    //string PropertyMail = "sakthi@warblerit.com,vivek@warblerit.com,arun@warblerit.com";
                    var PtyMail = PropertyMail.Split(',');
                    int cnt = PtyMail.Length;
                    System.Net.Mail.MailMessage message1 = new System.Net.Mail.MailMessage();
                    //SmtpMail PMail = new SmtpMail("TryIt");
                    //ds.Tables[1].Rows[0][4].ToString()
                    if (ds.Tables[10].Rows.Count > 0)
                    {
                        message1.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    }
                    else
                    {
                        message1.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    }
                    //message1.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message1.Subject = "Bed Booking Confirmation Property  - " + ds.Tables[2].Rows[0][2].ToString();
                    for (int i = 0; i < cnt; i++)
                    {
                        if (PtyMail[i].ToString() != "")
                        {
                            message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                        }
                    }
                    for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                    {
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            message1.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][2].ToString()));
                        }
                    }
                    if (ds.Tables[2].Rows[0][4].ToString() != "")
                    {
                        message1.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                    }
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    /*if (ds.Tables[10].Rows.Count > 0)
                    {
                        PMail.From = "homestay@uniglobeatb.co.in";
                        for (int i = 0; i < cnt; i++)
                        {
                            if (PtyMail[i].ToString() != "")
                            {
                                PMail.To.Add(PtyMail[i].ToString());
                            }
                        }
                        if (ds.Tables[2].Rows[0][4].ToString() != "")
                        {
                            PMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                        }
                        PMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                        PMail.Bcc.Add("vivek@warblerit.com");
                        PMail.Bcc.Add("sakthi@warblerit.com");
                        PMail.Bcc.Add("arun@warblerit.com");
                        PMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    }
                    else
                    {
                        message1.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                        for (int i = 0; i < cnt; i++)
                        {
                            if (PtyMail[i].ToString() != "")
                            {
                                message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                            }
                        }
                        if (ds.Tables[2].Rows[0][4].ToString() != "")
                        {
                            message1.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                        }
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                        message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    }*/
                    string Imagelocation1 = "";
                    Imagelocation1 = ds.Tables[6].Rows[0][2].ToString();
                    string Imagebody1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][3].ToString() + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
                    /*string Imagebody1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                        " <tr><td width=\"100%\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                        " <img src=" + Imagelocation1 + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][3].ToString() + ">" +
                        " </td></tr></table>";*/
                    string SecondRow1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                        " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                        " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                        " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                        " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                        " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                        " <p style=\"margin:0px;\">Property Name : <span>" + ds.Tables[4].Rows[0][1].ToString() + "</span></p>" + //Date
                        " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                        " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                        " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                        " </td></tr><tr><td width=\"100%\" style=\"margin-bottom:\">" +
                        " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                        " </td> </tr></table>";
                    string GuestDetailsTable11 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Bed / Day</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                        " </tr>";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable11 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td></tr>";
                    }
                    GuestDetailsTable11 += "</table>";
                    string SplReq = ds.Tables[2].Rows[0][8].ToString();
                    if(SplReq == "")
                    {
                        SplReq = "- NA -";
                    }
                    string MobileNo = ds.Tables[4].Rows[0][2].ToString();
                    if (MobileNo == "")
                    {
                        MobileNo = " - NA - ";
                    }
                    string AddressDtls1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                        " <tr style=\"font-size:11px; background-color:#eee;\">" +
                        " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                        " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details : </p>" +
                        "<p style=\"margin-top:5px; margin-left:25px\">" + MobileNo +" </p>"+
                        " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request </p>" +
                        "<p style=\"margin-top:5px; margin-left:25px\">" + SplReq +" </p></td></tr></table>";
                    //string Disclaimer1 = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                    /*string FooterDtls1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                            " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                            " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                            " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                            " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                            " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                            " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                            " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                            " <li><span>100% refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                            " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                            " </tr></table><br>";*/
                    string FooterDtls1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                    " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                    " </tr></table><br>";
                            /*<tr style=\"font-size:0px; font-weight:normal;\"> " +
                            " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                            " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:10px;\">Disclaimer :</p>" +
                            " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer1 + "</p>" +
                            " </td></tr> </table>";*/
                    message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                    message1.IsBodyHtml = true;
                    // SMTP Email email:
                    System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                    smtp1.EnableSsl = true;                    
                    smtp1.Port = 587;
                    //smtp1.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    smtp1.Host = "email-smtp.us-west-2.amazonaws.com"; smtp1.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    try
                    {
                        smtp1.Send(message1);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> Bed Level Booking Confirmation Property Mail --> " + message1.Subject);
                    }
                    /*if (ds.Tables[10].Rows.Count > 0)
                    {
                        PMail.HtmlBody = message1.Body;
                        SmtpServer PServer = new SmtpServer("mail.uniglobeatb.co.in");
                        PServer.User = "homestay@uniglobeatb.co.in";
                        PServer.Password = "Atb@33%";
                        PServer.Port = 465;
                        PServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                        SmtpClient PSmtp = new SmtpClient();
                        try
                        {
                            PSmtp.SendMail(PServer, PMail);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + "Bed Level Booking Property Mail in Port 465" + PMail.Subject);
                        }
                    }
                    else
                    {
                        System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                        smtp1.EnableSsl = true;
                        smtp1.Host = "smtp.gmail.com";
                        smtp1.Port = 587;
                        smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        try
                        {
                            smtp1.Send(message1);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + "Bed Level Booking Property Mail in Port 587" + message1.Subject);
                        }
                        //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                        //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");                        
                    }*/
                }
            }
            return ds;
        }
    }
}
