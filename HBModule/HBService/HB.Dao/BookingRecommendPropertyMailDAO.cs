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
                //DSBooking.Tables[1].Rows[0][4].ToString()
                if (DSBooking.Tables[8].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
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
                /*if (DSBooking.Tables[8].Rows.Count > 0)
                {
                    Mail.From = "homestay@uniglobeatb.co.in";
                    Mail.To.Add("booking_confirmation@staysimplyfied.com");
                    if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                    {
                        if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                        {
                            Mail.To.Add(DSBooking.Tables[1].Rows[0][1].ToString());
                        }
                    }
                    else
                    {
                        for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                        {
                            if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                            {
                                Mail.To.Add(DSBooking.Tables[3].Rows[i][0].ToString());
                            }
                        }
                        if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                        {
                            Mail.Cc.Add(DSBooking.Tables[1].Rows[0][1].ToString());
                        }                        
                    }
                    //Extra CC
                    for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                    {
                        if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                        {
                            Mail.Cc.Add(DSBooking.Tables[6].Rows[i][0].ToString());
                        }
                    }
                    if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                    {
                        Mail.Bcc.Add(DSBooking.Tables[1].Rows[0][4].ToString());
                    }
                    Mail.Bcc.Add("bookingbcc@staysimplyfied.com");
                    Mail.Bcc.Add("vivek@warblerit.com");
                    Mail.Bcc.Add("sakthi@warblerit.com");
                    Mail.Bcc.Add("arun@warblerit.com");
                    Mail.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
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
                    message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                    message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                }*/
                string Imagelocation = "";
                Imagelocation = DSBooking.Tables[5].Rows[0][0].ToString();
                string Imagebody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                    "<tr><td>" +
                    "<table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
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
                /*string NameBody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"400\" style=\" padding-bottom:20px;\">" +
                    " <p style=\"margin:0px;\">Hello " + DSBooking.Tables[2].Rows[0][1].ToString() + ",</p>" +         //Name Change
                    " <p style=\"margin:0px;\">Greetings for the Day.</p>" +
                    " <p style=\"margin:0px;\">Rooms are available in below mentioned hotels.   [Tracking Id: " + DSBooking.Tables[1].Rows[0][2].ToString() + "]</p>" +
                    " </td></tr>" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\">Property Details</p>" +
                    " " +
                    " <span style=\"color:#f54d02; font-weight:bold\">City: </span> " + DSBooking.Tables[0].Rows[0][0].ToString()  + " " +
                    " "+
                    " </table>";*/
                string GridBody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property &darr;</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Location</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Room Type</p></th>" +
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
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][3].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][7].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][5].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #fff;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][8].ToString() + "</p></td>" +
                        "</tr>";
                }
                GridBody += "</table>";
                GridBody +=
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    "<span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax </span><ul><li>  &#9733;   - Taxes as applicable</li><li> #   - Net Tariff</li></ul></p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"600\" style=\"padding:12px 5px;\">" +
                    " <p style=\"margin-top:0px;\"><b>Conditions : </b> <ul><li>All rates quoted are subject to availability and duration of Stay.</li><li>All Tariff quoted are limited and subject to availability and has to be confirmed in 30 mins from the time when these tariff's are generated " + DSBooking.Tables[4].Rows[0][1].ToString() + ".</li><li>While every effort has been made to ensure the accuracy and availablity of all information.</li></ul></p>" +
                    " <p style=\"margin-top:0px;\"><b>Cancellation Policy : </b> <ul><li> Cancellation of booking to be confirmed through Email.</li> " +
                    "<li>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</li>" +
                    "<li>100% refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</li> " +
                    "<li>1 day tariff will be charged for No-show without intimation.</li></ul>" +
                    " <p style=\"margin-top:20px;\"><b>Note : </b>" + DSBooking.Tables[1].Rows[0][5].ToString() + "<br>" +
                    " <p style=\"margin-top:20px;\">Kindly confirm the property at the earliest as rooms are subject to availability.<br>" +
                    " <br /> Thanking You,<br />" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">" + DSBooking.Tables[1].Rows[0][3].ToString() + "" + //username change
                    " </p></td></tr></table><br><br>";
                //string Disclaimer = "This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                /*GridBody +=
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                     " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                     " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                     " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                     " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                     " </td></tr> </table>";*/
                /*GridBody +=
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                     "<hr>"+
                     " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:5px;\">Disclaimer :</p>" +
                     " <p style=\"font-size:10px; padding-top:0px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                     " </td></tr> </table>";*/
                message.Body = Imagebody + NameBody + GridBody;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                //smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
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
