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

namespace HB.Dao
{
    public class BookingRecommendPropertyMailDAO
    {
        SqlCommand command = new SqlCommand();
        DataSet DSBooking = new DataSet();
        string UserData;
        public DataSet Mail(int BookingId)
        {
            User Usr = new Entity.User();
            UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
            "', SctId:" + Usr.SctId + ", Service : BookingRecommendPropertyMailDAO - Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help; 
            command = new SqlCommand();
            DSBooking = new DataSet();
            command.CommandText = StoredProcedures.BookingDtls_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "RecommendProperty";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            DSBooking = new WrbErpConnection().ExecuteDataSet(command, UserData);
            if (DSBooking.Tables[4].Rows[0][0].ToString() == "RmdPty")
            {
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();                
                if (DSBooking.Tables[8].Rows.Count > 0)
                {
                    //message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    message.From = new System.Net.Mail.MailAddress(DSBooking.Tables[2].Rows[0][2].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    //message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    message.From = new System.Net.Mail.MailAddress(DSBooking.Tables[2].Rows[0][1].ToString(), "", System.Text.Encoding.UTF8);
                }
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = " Test Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                {
                    if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                    }
                }
                else
                {
                    for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                    {
                        if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[3].Rows[i][0].ToString()));
                        }
                    }
                    if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                    }
                }
                //Extra CC
                for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                {
                    if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[6].Rows[i][0].ToString()));
                    }
                }
                if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                {
                    message.Bcc.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][4].ToString()));
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();                
                string Imagelocation = "";
                Imagelocation = DSBooking.Tables[5].Rows[0][0].ToString();
                string Imagebody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                    "<tr><td>" +
                    "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    "<tr> " +
                    "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                    "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + DSBooking.Tables[5].Rows[0][1].ToString() + ">" +              //Image Name Change
                    "</th><th width=\"50%\"></th></tr></table>";
                string NameBody =
                    " <p style=\"margin:0px;\">Hello " + DSBooking.Tables[7].Rows[0][0].ToString() + ",</p><br>" +         //Name Change
                    " <p style=\"margin:0px;\">Greetings for the Day.</p><br>" +
                    " <p style=\"margin:0px;\">Rooms are available in below mentioned hotels.   [ Tracking Id: " + DSBooking.Tables[1].Rows[0][2].ToString() + " ]</p>" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\">Property Details :</p>" +
                    " <span style=\"color:#f54d02; font-weight:bold\">City: </span> " + DSBooking.Tables[0].Rows[0][0].ToString() + " " +
                    "<br><br>";                
                string GridBody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Type</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Location</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Room Type</p></th>" +
                    //" <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Base Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Single Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Double Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Inclusions</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #fff;\"><p>Check In Policy</p></th>" +
                    "</tr>";
                for (int j = 0; j < DSBooking.Tables[0].Rows.Count; j++)
                {
                    GridBody +=
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][9].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][3].ToString() + "</p></td>" +
                        //" <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][10].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][7].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][5].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #fff;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][8].ToString() + "</p></td>" +
                        "</tr>";
                }
                GridBody += "</table>";
                GridBody +=
                        "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                        "<span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax </span><ul><li>  &#9733;   - Taxes as applicable</li><li> #   - Including Tax</li></ul></p>" +
                        "<p style=\"font-weight:bold; font-size:13px;\">TO CONFIRM - Reply with your top 2 - 3 preferred hotel and room type to confirmation of your booking as per availablity</p>" +
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; background-color:#eee;\">" +
                        " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                        " <p style=\"margin-top:0px;\"><b>Conditions : </b><ul><li><b>All rates quoted are subject to availability and duration of Stay.</b></li><li>All Tariff quoted are limited and subject to availability and has to be confirmed in 30 mins from the time when these tariff's are generated " + DSBooking.Tables[4].Rows[0][1].ToString() + ".</li><li>While every effort has been made to ensure the accuracy and availablity of all information.</li></ul></p>" +
                        " <p style=\"margin-top:0px;\"><b>Cancellation Policy : </b> <ul><li> Cancellation of booking to be confirmed through Email.</li> " +
                        "<li>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</li>" +
                        "<li>Cancellation policy varies from Property to property. Please verify confirmation email.</li></ul>" +
                        " <p style=\"margin-top:20px;\"><b>Note : </b>" + DSBooking.Tables[1].Rows[0][5].ToString() + "<br>" +
                        " <p style=\"margin-top:20px;\">Kindly confirm the property at the earliest as rooms are subject to availability.<br>" +
                        " <br /> Thanking You,<br />" +
                        " </p><p style=\"margin-top:5px;\">" +
                        " <span style=\"color:#f54d02; font-weight:bold\">" + DSBooking.Tables[1].Rows[0][3].ToString() + "" + //username change
                        " </p></td></tr></table><br><br>";
                /*GridBody +=
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    "<span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax </span><ul><li>  &#9733;   - Taxes as applicable</li><li> #   - Including Tax</li></ul></p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                    " <p style=\"margin-top:0px;\"><b>Conditions : </b><ul><li><b>Please provide us alternate options of hotels/room types, to serve you better</b></li><li><b>All rates quoted are subject to availability and duration of Stay.</b></li><li>All Tariff quoted are limited and subject to availability and has to be confirmed in 30 mins from the time when these tariff's are generated " + DSBooking.Tables[4].Rows[0][1].ToString() + ".</li><li>While every effort has been made to ensure the accuracy and availablity of all information.</li></ul></p>" +
                    " <p style=\"margin-top:0px;\"><b>Cancellation Policy : </b> <ul><li> Cancellation of booking to be confirmed through Email.</li> " +
                    "<li>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</li>" +
                    "<li>Cancellation policy varies from Property to property. Please verify confirmation email.</li></ul>" +
                    " <p style=\"margin-top:20px;\"><b>Note : </b>" + DSBooking.Tables[1].Rows[0][5].ToString() + "<br>" +
                    " <p style=\"margin-top:20px;\">Kindly confirm the property at the earliest as rooms are subject to availability.<br>" +
                    " <br /> Thanking You,<br />" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">" + DSBooking.Tables[1].Rows[0][3].ToString() + "" + //username change
                    " </p></td></tr></table><br><br>"; */               
                message.Body = Imagebody + NameBody + GridBody;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                //smtp.Host = "smtp.gmail.com";smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Recommend Property Mail --> " + message.Subject);
                }                
            }
            return DSBooking;
        }
    }
}
