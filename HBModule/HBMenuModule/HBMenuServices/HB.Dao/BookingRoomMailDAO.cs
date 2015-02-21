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
using System.Net.Mail;
using System.Net;
using System.IO;

namespace HB.Dao
{
    public class BookingRoomMailDAO
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string Err;
        string UserData;
        public DataSet Mail(int BookingId, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help; 
            DataTable dT = new DataTable("Table12");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds=new DataSet();
            command.CommandText = StoredProcedures.BookingDtls_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "RoomBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            Err = "";
            string Flag = "true";
            string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";
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
            if (ds.Tables[10].Rows.Count > 0)
            {
                message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][15].ToString(), "", System.Text.Encoding.UTF8);
            }
            else
            {
                message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][14].ToString(), "", System.Text.Encoding.UTF8);
            }
            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            //message.Subject = "Booking - " + ds.Tables[2].Rows[0][2].ToString();
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
            if (ds.Tables[8].Rows[0][2].ToString() != "")
            {
                string ExtraCC = ds.Tables[8].Rows[0][2].ToString();
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
            message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();           
            string typeofpty = ds.Tables[4].Rows[0][8].ToString();
            string Imagelocation = "";
            string Imagealt = "";
            if (typeofpty == "MGH")
            {
                Imagelocation = ds.Tables[6].Rows[0][4].ToString();
                Imagealt = ds.Tables[6].Rows[0][5].ToString();
                if (Imagelocation == "")
                {
                    Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                    Imagealt = ds.Tables[6].Rows[0][1].ToString();
                }
            }
            else
            {
                Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                Imagealt = ds.Tables[6].Rows[0][1].ToString();
            }           
            string Imagebody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + Imagealt + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
            
            string SecondRow = " <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #ffffff solid 1px\">" +
                        " <tr><td style=\"width: 65%;\">" +
                        " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                        " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                        " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p><br>" + //Date
                        " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p><br>" + //Date
                        " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                        " </td>" +
                        " <td>" +
                        " <p style=\"padding:5px 5px 5px 5px; font-size:13px; color:#000; font-weight:bold; background-color:#ffcc00;\">Please refer your name and " + ds.Tables[4].Rows[0][9].ToString() + " at the time of check-In</p>" +
                        " </td></tr>" +
                        " <tr><td>" +
                        " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                        " </td></tr>" +
                        " </table>";            
            string GuestDetailsTable1 = "";
            // MGH,DdP,
            if ((typeofpty == "MGH") || (typeofpty == "DdP"))
            {
                GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:140px;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Room No</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Occupancy</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:90px;\"><p>Payment Mode<br>for Service</p></th>" +
                    " </tr>";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:140px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][7].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></td>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
            }
            else
            {
                GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room Type</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Tariff / Room / Day</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                    " </tr>";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[4].Rows[0][12].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></td>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
            }
            string Note = "";
            string CheckInPolicy = "";
            string CheckOutPolicy = "";
            if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
            {
                Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
            }
            else if (ds.Tables[1].Rows[0][6].ToString() == "External Property")
            {
                if (ds.Tables[1].Rows[0][11].ToString() == "Serviced Appartments")
                {
                    Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
                }
                else
                {
                    Note = "";
                }
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
            string Taxes = "";
            if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
            {
                //Taxes = "Taxes as applicable";
                Taxes = ds.Tables[4].Rows[0][13].ToString();
            }
            if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
            {
                Taxes = ds.Tables[4].Rows[0][7].ToString();
            }
            string AddressDtls =
                "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax :</span> " + Taxes + "" +
                " </p>"+
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                    " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Address :</span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Phone :</span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Directions :</span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Note :</span> " + Note + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + ds.Tables[2].Rows[0][8].ToString() + "" +
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
                    "  <img src=" + ds.Tables[8].Rows[0][3].ToString() + " width=\"100\" height=\"100\" />" +
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
                    " " + ds.Tables[4].Rows[0][5].ToString() + "" +
                    " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">"+
                    " " + ds.Tables[4].Rows[0][6].ToString() + "</td>" +
                    " </tr></table><br>";                    
            message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
            message.IsBodyHtml = true;
            // SMTP Email email: 
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            smtp.EnableSsl = true;
            smtp.Port = 587;
            //smtp.Host = "smtp.gmail.com";smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
            smtp.Host = "email-smtp.us-west-2.amazonaws.com";smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
            try
            {
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Mail --> " + message.Subject);
            }            
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
                    if (ds.Tables[10].Rows.Count > 0)
                    {
                        message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][15].ToString(), "", System.Text.Encoding.UTF8);
                    }
                    else
                    {
                        message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][14].ToString(), "", System.Text.Encoding.UTF8);
                    }
                    //message1.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message1.Subject = "Booking - " + ds.Tables[2].Rows[0][2].ToString();
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
                        message1.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                    }
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();                    
                    string typeofpty1 = ds.Tables[4].Rows[0][8].ToString();
                    string Imagelocation1 = "";
                    string Imagealt1 = "";
                    if (typeofpty == "MGH")
                    {
                        Imagelocation1 = ds.Tables[6].Rows[0][4].ToString();
                        Imagealt1 = ds.Tables[6].Rows[0][5].ToString();
                        if (Imagelocation1 == "")
                        {
                            Imagelocation1 = ds.Tables[4].Rows[0][10].ToString();
                            Imagealt1 = ds.Tables[4].Rows[0][11].ToString();
                        }
                    }
                    else
                    {
                        Imagelocation1 = ds.Tables[4].Rows[0][10].ToString();
                        Imagealt1 = ds.Tables[4].Rows[0][11].ToString();
                    }                    
                    string Imagebody1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation1 + " width=\"200px\" height=\"52px\" alt=" + Imagealt1 + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";                    
                    string SecondRow1 = " <table width=\"800px\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"left\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #ffffff solid 1px\">" +
                        " <tr><td>" +
                        " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                        " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                        " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p><br>" + //Date
                        " <p style=\"margin:0px;\">Property Name : <span>" + ds.Tables[4].Rows[0][3].ToString() + "</span></p><br>" + //Date
                        " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name                        
                        " </td></tr>" +
                        " <tr><td>" +
                        " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                        " </td></tr>" +
                        " </table>";
                    
                    string GuestDetailsTable11 = "";
                    if ((typeofpty == "MGH") || (typeofpty == "DdP"))
                    {
                        GuestDetailsTable11 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"left\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room No</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                            " </tr>";
                        for (int i = 0; i < ds.Tables[11].Rows.Count; i++)
                        {
                            GuestDetailsTable11 +=
                            "<tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][0].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][10].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][4].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][5].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][6].ToString() + "</p></td>" +
                            " </tr>";
                        }
                        GuestDetailsTable11 += "</table>";
                    }
                    else
                    {
                        GuestDetailsTable11 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room Type</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Agreed Tariff / Room / Day</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                            " </tr>";
                        for (int i = 0; i < ds.Tables[11].Rows.Count; i++)
                        {
                            GuestDetailsTable11 +=
                            "<tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][0].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[4].Rows[0][12].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[11].Rows[i][3].ToString() + "/-</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][4].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][5].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][6].ToString() + "</p></td>" +
                            " </tr>";
                        }
                        GuestDetailsTable11 += "</table>";
                    }
                    string SplReq = ds.Tables[2].Rows[0][8].ToString();
                    if (SplReq == "")
                    {
                        SplReq = " - NA - ";
                    }
                    string MobileNo = ds.Tables[4].Rows[0][4].ToString();
                    if (MobileNo == "")
                    {
                        MobileNo = " - NA - ";
                    }
                    string Stng = ds.Tables[11].Rows[0][8].ToString();
                    string BelowTACcontent = ds.Tables[11].Rows[0][9].ToString();
                    string AddressDtls1 = "";
                    if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
                    //if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
                    {
                        if (Stng != "")
                        {
                            AddressDtls1 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Agreed Tariff & TAC (Per day / Room Night) :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + Stng + "</p>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> Agreed Tariff & TAC :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + BelowTACcontent + "</p>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                " </td></tr></table>";
                        }
                        if (Stng == "")
                        {
                            AddressDtls1 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                " <td width=\"800px\" style=\"padding:12px 5px;\">" +                                
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                " <p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                " </td></tr></table>";
                        }
                    }
                    if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
                    //if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
                    {
                        try
                        {
                            string file = ds.Tables[4].Rows[0][1].ToString();
                            //string file = "D:/Project/HBModule/HB/flex_bin/Proof_of_Stay.pdf";
                            System.Net.Mail.Attachment att = new System.Net.Mail.Attachment(file);
                            att.Name = ds.Tables[4].Rows[0][2].ToString();
                            //att.Name = "Proof_of_Stay.pdf";
                            message1.Attachments.Add(att);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Property Mail --> "+message1.Subject+" PDF Attachment");
                        }
                        AddressDtls1 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                "<p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                "<p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                "</td></tr>" +
                            // first line
                                " <tr style=\"font-size:11px;\">" +
                                "<td width=\"800px\" style=\"padding:12px 5px;\">" +
                                "<p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Note :</p>" +
                                "<ul><li>Kindly send us a confirmation e-mail immediately to stay@hummingbirdindia.com on receipt of this booking request followed by a confirmation voucher. Arrange to send the confirmation voucher within 5 minutes on receipt of this mail. Do not delay in sending the confirmation mail/voucher, as the booking may get cancelled.</li>" +
                            // 2nd line
                                "<li>In case there is any change regarding the above booking, kindly let us know before confirming the booking.</li>" +
                            // 3rd
                                "<li>After check-in, if there is any cancellations/amendments/extensions to this booking, the same MUST be routed through Hummingbird only.</li>" +
                            // 4th
                                "<li>Any escalation regarding the stay needs to be attended and resolved at the property level immediately. All escalations need to be informed to HummingBird through mail and by phone. HummingBird will also assist the property to resolve issues.</li>" +
                            // 5th
                                "<li>Kindly find attached Proof of Stay (POS) which needs to be filled and signed by the guest for all Bill to Company (BTC) bookings. The filled POS has to be attached along with the invoice sent to HummingBird.</li>" +
                            // 6th
                                "<li>If the mode of payment for services is BTC, necessary supporting vouchers (with guest signature) for the service items delivered is to be attached along with invoice.</li>" +
                            // 7th
                                "<li>All the invoices to be raised on “Hummingbird Travel & Stay Pvt Ltd” and all statutory numbers of the property to be mentioned on the invoice. Invoice should reach within three days of the check-out date.</li></td></tr>" +
                                "</table>";
                    }
                    string FooterDtls1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                            " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                            " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                            "" + ds.Tables[4].Rows[0][5].ToString() + "" +
                            " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">"+
                            "" + ds.Tables[4].Rows[0][6].ToString() + "</td></tr></table><br>";
                    
                    message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                    message1.IsBodyHtml = true;
                    // SMTP Email email:
                    System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                    smtp1.EnableSsl = true;                    
                    smtp1.Port = 587;
                    //smtp1.Host = "smtp.gmail.com"; smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    smtp1.Host = "email-smtp.us-west-2.amazonaws.com";smtp1.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    try
                    {
                        smtp1.Send(message1);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Property Mail --> " + message1.Subject);
                    }                   
                }
            }            
            return ds;
        }
    }
}
