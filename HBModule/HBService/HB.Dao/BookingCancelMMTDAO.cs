using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Xml;
using HB.Entity;

namespace HB.Dao
{
    public class BookingCancelMMTDAO
    {
        SqlCommand command = new SqlCommand();
        string UserData = "";
        string Success = "";
        int n = 0;
        public DataSet FnCancel(string[] data, User user)
        {
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                       ", SctId : " + user.SctId + ", Service : BookingCancelMMTDAO" +
                       ", ProcName: SP_BookingCancel_Help";
            DataSet ds = new DataSet();
            command = new SqlCommand();
            command.CommandText = "SP_BookingCancel_Help";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = data[3].ToString();
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/cancel/v1.0/cancelBooking");
            HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
            httpRequest.Method = "POST";
            httpRequest.ContentType = "application/xml; charset=utf-8";
            httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
            //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
            httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
            httpRequest.ProtocolVersion = HttpVersion.Version11;
            httpRequest.Credentials = CredentialCache.DefaultCredentials;
            httpRequest.Timeout = 100000000;
            Stream requestStream = httpRequest.GetRequestStream();
            //Create Stream and Complete Request             
            StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
            StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            soapRequest.Append("<MMTHotelCancelRequest>");
            soapRequest.Append("<POS>");
            //soapRequest.Append("<Requestor type=\"B2B\" idContext=\"AFF\" id=\"AFF13416\" channel=\"AFF\"/>");//test
            soapRequest.Append("<Requestor type=\"B2B\" idContext=\"AFF\" id=\"AFF14453\" channel=\"AFF\"/>");//live
            soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
            //soapRequest.Append("<Token>AFF13416</Token>");//TEST
            soapRequest.Append("<Token>AFF14453</Token>");//LIVE
            soapRequest.Append("</POS>");
            soapRequest.Append("<CancelReqDetail actionType=\"commit\">");
            soapRequest.Append("<BookingIdList>");
            //soapRequest.Append("<BookingID status=\"confirmed\" type=\"FULL\">NH470872970728</BookingID>");// TEST
            soapRequest.Append("<BookingID status=\"confirmed\" type=\"FULL\">"+ds.Tables[0].Rows[0][0].ToString()+"</BookingID>");// LIVE
            soapRequest.Append("</BookingIdList>");
            soapRequest.Append("</CancelReqDetail>");
            soapRequest.Append("</MMTHotelCancelRequest>");
            streamWriter.Write(soapRequest.ToString());
            streamWriter.Close();
            //Get the Response
            HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
            StreamReader srd = new StreamReader(wr.GetResponseStream());
            string ResponseXML = srd.ReadToEnd();
            XmlDocument document = new XmlDocument();
            document.LoadXml(ResponseXML);            
            n = document.SelectNodes("//ResponseCode").Count;
            if (n != 0)
            {
                Success = document.SelectNodes("//ResponseCode")[0].Attributes["success"].Value;
                if (Success == "false")
                {
                    string Errorcode = document.SelectNodes("//Error")[0].Attributes["code"].Value;
                    string Description = document.SelectNodes("//Description")[0].InnerText;
                    //
                    command = new SqlCommand();
                    command.CommandText = "SP_BookingCancel_Help";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTBookingCancelDataUpdateError";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Errorcode;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = Description;
                    DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }
                if (Success == "true")
                {
                    string TotalCancelAmount = document.SelectNodes("//TotalCancelAmount")[0].InnerText;
                    string CancellationMarkup = document.SelectNodes("//CancellationMarkup")[0].InnerText;
                    //
                    command = new SqlCommand();
                    command.CommandText = "SP_BookingCancel_Help";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTBookingCancelDataUpdate";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = TotalCancelAmount;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = CancellationMarkup;
                    DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                    //
                    DataSet ds22 = new SMSCancel().FnSMSBookingCancel(Convert.ToInt32(data[2].ToString()), user);
                    //
                    if (data[4].ToString() == "true")
                    {
                        try
                        {
                            ds = new DataSet();
                            command = new SqlCommand();
                            command.CommandText = "SP_BookingCancel_Help";
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTBookingCancelUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                            command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = data[3].ToString();
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            //
                            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                            //DSBooking.Tables[1].Rows[0][4].ToString()    
                            //message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                            message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            //message.Subject = " Test Booking Canceled - " + ds.Tables[0].Rows[0][2].ToString();
                            //message.To.Add(new System.Net.Mail.MailAddress("stay@staysimplyfied.com"));
                            message.To.Add(new System.Net.Mail.MailAddress("stay@hummingbirdindia.com"));
                            if (ds.Tables[0].Rows[0][0].ToString() == "0")
                            {
                                message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[0].Rows[0][1].ToString()));
                                //string sd = ds.Tables[0].Rows[0][1].ToString();
                            }
                            else
                            {
                                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                                {
                                    message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[1].Rows[i][0].ToString()));
                                    //string ddfs = ds.Tables[1].Rows[i][0].ToString();
                                }
                                if (ds.Tables[0].Rows[0][1].ToString() != "")
                                {
                                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[0].Rows[0][1].ToString()));
                                    //string sdfsdf = ds.Tables[0].Rows[0][1].ToString();
                                }
                            }
                            if (ds.Tables[2].Rows.Count > 0)
                            {
                                if (ds.Tables[2].Rows[0][0].ToString() != "")
                                {
                                    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][0].ToString()));
                                    //string sdfsfsdf = ds.Tables[2].Rows[0][0].ToString();
                                }
                            }
                            message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                            message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            message.Subject = "Booking Canceled - " + ds.Tables[0].Rows[0][2].ToString();
                            string Imagelocation = ds.Tables[3].Rows[0][0].ToString();
                            string Imagebody =
                               " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                               " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                               " <tr><td width=\"50%\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                               " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"staysimplyfied\">" +
                               " </td></tr></table>";
                            string AddressDtls =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                             " <tr style=\"font-size:11px; background-color:#eee;\">" +
                             " <td width=\"600\" style=\"padding:12px 5px;\">" +
                              "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:black; font-weight:bold\">Your booking number " + ds.Tables[0].Rows[0][2].ToString() + "   has been cancelled. Details are as follows: </span><br>" +
                             " </p>" +
                             " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Cancel Details</p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Booking Date : </span> " + ds.Tables[0].Rows[0][3].ToString() + "  <br>" +
                             " </p>" +
                             "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Client Name: </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + ds.Tables[4].Rows[0][0].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Booking Level: </span> " + ds.Tables[0].Rows[0][5].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Reason: </span> " + data[3].ToString() + "  <br>" +
                             " </p></td></tr></table>";

                            string GuestDetailsTable1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>No Of Room Nights</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Status</p></th>" +
                            " </tr>";
                            for (int i = 0; i < n; i++)
                            {
                                GuestDetailsTable1 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[5].Rows[0][0].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[5].Rows[0][1].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[5].Rows[0][2].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[5].Rows[0][3].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">Canceled</p></td>" +
                                " </tr>";
                            }
                            GuestDetailsTable1 += "</table>";
                            string Footer =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                             " <tr style=\"font-size:11px; background-color:#eee;\">" +
                             " <td width=\"600\" style=\"padding:12px 5px;\">" +
                              "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Looking forward to your next stay with us! </span><br>" +
                             " </p>" +
                             " <p style=\"color:black; font-weight:bold; margin:0px; font-size:14px;\"> Please refrain from sending emails to this id as the inbox is not monitored. Please reply to stay@hummingbirdindia.com for clarifications, if any.</p>" +
                             " </td></tr></table>";
                            string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                            string FooterDtls =
                                 " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                 " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                                 " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                                 " STAY SIMPLYFIED Travel and stay Pvt Ltd</p><br><hr>" +
                                 " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                                 " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                                 " </td></tr> </table>";
                            message.Body = Imagebody + AddressDtls + GuestDetailsTable1 + Footer + FooterDtls;
                            message.IsBodyHtml = true;
                            // SMTP Email email:
                            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                            smtp.Port = 587;
                            smtp.EnableSsl = true;
                            //smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                            smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                            smtp.Send(message);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " --> Booking Canceled --> " + ds.Tables[0].Rows[0][2].ToString());
                        }
                    }
                }
            }
            else
            {
                Success = "false";
            }
            if (Success == "true")
            {
                ds = new DataSet();
                command = new SqlCommand();
                command.CommandText = "SP_BookingCancel_Help";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTCancelSuccess";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Success;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = "";
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else
            {
                if (n == 0)
                {
                    ds = new DataSet();
                    command = new SqlCommand();
                    command.CommandText = "SP_BookingCancel_Help";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTCancelSuccess";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Success;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = 0;
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = 0;
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = "";
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }
                else
                {
                    ds = new DataSet();
                    command = new SqlCommand();
                    command.CommandText = "SP_BookingCancel_Help";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTCancelSuccess";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Success;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = 0;
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = "";
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }
            }
            return ds;
        }
    }
}
