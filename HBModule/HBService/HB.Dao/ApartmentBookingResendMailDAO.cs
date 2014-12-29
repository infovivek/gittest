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
    public class ApartmentBookingResendMailDAO
    {
        String UserData;
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string Err;
        public DataSet Mail(int BookingId, string Email, string UsrEmail,User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : ApartmentBookingResendMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            DataTable dT = new DataTable("Table11");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds = new DataSet();
            command.CommandText = StoredProcedures.BookingDtls_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "ApartmentBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            if (ds.Tables[10].Rows.Count > 0)
            {
                message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
            }
            else
            {
                //message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
            }
            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            //message.Subject = "Apartment Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
            var Mail = Email.Split(',');
            for (int i = 0; i < Mail.Length; i++)
            {
                if (Mail[i].ToString() != "")
                {
                    message.To.Add(new System.Net.Mail.MailAddress(Mail[i].ToString()));
                }
            }
            if (UsrEmail != "")
            {
                message.CC.Add(new System.Net.Mail.MailAddress(UsrEmail));
            }
            message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            string Imagelocation = "";
            Imagelocation = ds.Tables[6].Rows[0][0].ToString();
            string Imagebody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
            string SecondRow =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
                " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                " </td> </tr></table>";
            // Dataset Table 0 begin
            string GuestDetailsTable1 =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date / Expected Time</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Tariff / Apartment / Day</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode<br>for Tariff</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode<br>for Service</p></th>" +
                " </tr>";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                GuestDetailsTable1 +=
                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                " </tr>";
            }
            GuestDetailsTable1 += "</table>";
            // Dataset Table 0 end
            string Note = "";
            string CheckInPolicy = "";
            string CheckOutPolicy = "";
            if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
            {
                Note = "This booking entitles you to use the whole apartment.";
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
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                " <td width=\"800px\" style=\"padding:12px 5px;\">" +
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
                " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + Spl + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check-in Policy : </span> " + CheckInPolicy + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy : </span> " + CheckOutPolicy + "" +
                " </p><p style=\"margin-top:12px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> ( 9:00 AM  to  5:00 PM )<br>" +
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
                 " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
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
                 " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
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
                 " <li><span>800px refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                 " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                 " </tr></table><br>";*/
            string FooterDtls =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                    " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                    " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                    " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                    " </tr></table><br>";
            message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
            message.IsBodyHtml = true;
            // SMTP Email email:
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            smtp.EnableSsl = true;
            smtp.Port = 587;
            smtp.Host = "email-smtp.us-west-2.amazonaws.com";smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
            Err = "";
            try
            {
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Apartment Level Booking Confirmation Resend Mail --> " + message.Subject);
                Err = ex.Message + " --> Apartment Resend Mail --> " + message.Subject;
            }
            if (Err != "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
            }
            if (Err == "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
            }
            return ds;
        }
    }
}
