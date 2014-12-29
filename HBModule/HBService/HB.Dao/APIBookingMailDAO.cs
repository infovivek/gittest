using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Text.RegularExpressions;

namespace HB.Dao
{
    public class APIBookingMailDAO
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string UserData;
        public DataSet Mail(int BookingId, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + 
                       ", ScreenName:'" + user.ScreenName + "', SctId:" + user.SctId + 
                       ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;            
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            try
            {
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.BookingDtls_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTBookingConfirmed";
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);               
                if (ds.Tables[5].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                }
                else
                {
                    //message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                }
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.To.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Subject = "MMT Testing Booking Confirmation - " + ds.Tables[2].Rows[0][0].ToString();
                message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                if (ds.Tables[2].Rows[0][6].ToString() == "0")
                {
                    if (ds.Tables[2].Rows[0][7].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][7].ToString()));
                    }
                }
                else
                {
                    for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                    {
                        if (ds.Tables[3].Rows[i][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][0].ToString()));
                        }
                    }
                    if (ds.Tables[2].Rows[0][7].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][7].ToString()));
                    }
                }
                // Extra CC email from Front end
                if (ds.Tables[2].Rows[0][9].ToString() != "")
                {
                        string ExtraCC = ds.Tables[2].Rows[0][9].ToString();
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
                if (ds.Tables[2].Rows[0][4].ToString() != "")
                {
                    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][0].ToString();
                string Imagelocation = "";
                Imagelocation = ds.Tables[4].Rows[0][0].ToString();
                string Imagebody =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[4].Rows[0][1].ToString() + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                string SecondRow =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"300\" style=\" padding-bottom:1px;\">" +
                    " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][0].ToString() + " </span></p>" + //Reservation
                    /*" <p style=\"margin:0px;\">Ref : <span>" + ds.Tables[2].Rows[0][8].ToString() + "</span></p><br>" +*/
                    " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p><br>" +             //Name                    
                    " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][2].ToString() + "</span></p><br>" + //Date
                    " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p><br>" + //company name
                    " </td><td width=\"300\"><p style=\"padding:25px 25px 25px 25px; font-size:13px; color:#000; font-weight:bold; background-color:#ffcc00;\">Please refer your name and reference number - " + ds.Tables[2].Rows[0][8].ToString() + " at the time of check-In</p>" +
                    " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                    " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                    " </td> </tr></table>";
                string GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Tariff / Room / Day</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                    " </tr>";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></th>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
                //                
                string CheckInPolicy = "";
                if (ds.Tables[1].Rows[0][4].ToString() != "")
                {
                    CheckInPolicy = ds.Tables[1].Rows[0][4].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                //
                string CheckOutPolicy = "";
                if (ds.Tables[1].Rows[0][5].ToString() != "")
                {
                    CheckOutPolicy = ds.Tables[1].Rows[0][5].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                //
                string Note = "";               
                if (ds.Tables[1].Rows[0][6].ToString() == "MMT") { Note = " - NA - "; } else { Note = " - NA - "; }
                //
                string SplReq = "";
                if (ds.Tables[2].Rows[0][5].ToString() == "") { SplReq = " - NA - "; }
                else { SplReq = ds.Tables[2].Rows[0][5].ToString(); }
                //
                string AddressDtls =
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax :</span> " + ds.Tables[3].Rows[0][1].ToString() + "" +
                    " </p>"+
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                        " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][0].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address :</span> " + ds.Tables[1].Rows[0][1].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone :</span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions :</span>" + ds.Tables[1].Rows[0][3].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note :</span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + SplReq + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check In Policy :</span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy :</span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> (9:00 AM  to  5:00 PM)<br>" +
                    " </p></td></tr></table>";
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";                
                string QRCode =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                        "  <br /><br />" +
                        "  <img src=" + ds.Tables[2].Rows[0][10].ToString() + " width=\"100\" height=\"100\" />" +
                        " <p style=\"margin-top:5px;\">" +
                        "  *NOTE: Download QRCode reader to get propery address to your maps" +
                        "    </p>" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                        " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                        " </tr></table>";
                string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[1].Rows[0][7].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[1].Rows[0][8].ToString() + "</td>" +
                        " </tr></table><br>";
                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email: 
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;                
                smtp.Port = 587;
                //smtp.Host = "smtp.gmail.com";
                //smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Room Level Booking MMT Confirmation Mail --> " + message.Subject);
            }
            return ds;
        }
    }
}
