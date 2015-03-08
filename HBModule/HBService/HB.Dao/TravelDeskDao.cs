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
using System.Data.Sql;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace HB.Dao
{
   public class TravelDeskDao
    {
        string UserData;
        public DataSet Save(string[] Hdrval, User user)
        { 
            TravelDesk Td = new TravelDesk();
            XmlDocument document = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            String Mode;
            //User Insert(detailed)
            document.LoadXml(Hdrval[1].ToString());
            Td.Mode = document.SelectSingleNode("//HdrXml").Attributes["Mode"].Value;
            if (Td.Mode == "TRAVELAGENCY")
            {
                Td.Email = document.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
                Td.FirstName = document.SelectSingleNode("//HdrXml").Attributes["FirstName"].Value;
                Td.MobileNumber = document.SelectSingleNode("//HdrXml").Attributes["Mobile"].Value;

                Td.Designation = document.SelectSingleNode("//HdrXml").Attributes["Designation"].Value;
                Td.LastName = document.SelectSingleNode("//HdrXml").Attributes["LastName"].Value;
                Td.Address = document.SelectSingleNode("//HdrXml").Attributes["address"].Value;
                Td.City = document.SelectSingleNode("//HdrXml").Attributes["City"].Value;
                Td.Office = document.SelectSingleNode("//HdrXml").Attributes["Office"].Value;
                Td.State = document.SelectSingleNode("//HdrXml").Attributes["State"].Value;
                Td.Website = document.SelectSingleNode("//HdrXml").Attributes["Website"].Value;
                Td.StateId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["StateId"].Value);
                Td.CityId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["CityId"].Value);
                Td.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
                document.LoadXml(Hdrval[2].ToString());
                int n;
                n = (document).SelectNodes("//GridXml").Count;
                for (int i = 0; i < n; i++)
                {

                    if (document.SelectNodes("//GridXml")[i].Attributes["ClientId"].Value == "")
                    {
                        Td.ClientId = 0;
                    }
                    else
                    {
                        Td.ClientId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ClientId"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["ClientName"].Value == "")
                    {
                        Td.ClientName = "";
                    }
                    else
                    {
                        Td.ClientName = document.SelectNodes("//GridXml")[i].Attributes["ClientName"].Value;
                    } 
                    SqlCommand command = new SqlCommand();
                    if (Td.Id != 0)
                    {
                        Mode = "Update";
                        UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                            "',SctId:" + user.SctId + ",Service:TravelDeskDao Update" + ",ProcName:'" + StoredProcedures.TravelAgency_Update;

                      //  command.CommandText = StoredProcedures.TravelAgency_Update;
                        command.Parameters.Add("@Id", SqlDbType.Int).Value = Td.Id;
                    }
                    else
                    {
                        Mode = "Save";
                        UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                         "',SctId:" + user.SctId + ",Service:TravelDeskDao Insert" + ",ProcName:'" + StoredProcedures.TravelAgency_Insert;

                        command.CommandText = StoredProcedures.TravelAgency_Insert;
                    }
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = Td.FirstName;
                    command.Parameters.Add("@MobileNumber", SqlDbType.NVarChar).Value = Td.MobileNumber;
                    command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = Td.ClientName;
                    command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = Td.Designation;
                    command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value =Td.LastName;

                    command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Td.Email;
                    command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = Td.Address;
                    command.Parameters.Add("@City", SqlDbType.NVarChar).Value = Td.City;
                    command.Parameters.Add("@Office", SqlDbType.NVarChar).Value =Td.Office;
                    command.Parameters.Add("@State", SqlDbType.NVarChar).Value = Td.State;

                    command.Parameters.Add("@Website", SqlDbType.NVarChar).Value = Td.Website;
                    command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Td.ClientId;
                    command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Td.StateId;
                    command.Parameters.Add("@CityId", SqlDbType.BigInt).Value =  Td.CityId;
                    command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                    command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = Td.Mode;
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }//For Loop 
                    string Valid = ""; string Err = "";
                    Valid = EmailValidate(Td.Email);

                    if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
                    {

                        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                       // message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                        message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
                        if (Valid == "True")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(Td.Email));
                        }
                        else
                        {
                            Err = "";
                        }
                        message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("minidurai@warblerit.com"));
                        message.Subject = "Welcome to Stay Simplified ";

                        string Imagelocation = "";
                        {
                            if (ds.Tables[1].Rows[0][0].ToString() != "")
                                Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                        }
                        message.Body = "";
                        string Imagebody =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                           " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                           " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
                           " </td></tr></table>";

                        string Header =
                          " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                          " <tr style=\"font-size:12px; \">" +
                          " <td width=\"600\" style=\"padding:12px 5px;\">" +
                          " <p style=\"margin-top:20px;\">" +
                          " <span> System generated email. Please do not reply. </span>" +
                          " <style=\"margin-top:20px;\">" +
                          " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][3].ToString() + "</span><br>" +
                          " </td></tr></table>";

                        string AddressDtls =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                           " <tr style=\"font-size:12px;\">" +
                           " <td width=\"600\" style=\"padding:3px 5px;\">" +
                           " <p style=\"margin-top:10px;\">" +
                           " <span>Dear " + Td.FirstName + " </span> " + " <br>" +
                            " </p>" +
                           " <span>Welcome to Stay Simplyfied. India's first digital automation platform for Business STAY.</span> "+
                            " <br>" + " </p>" + " <p style=\"margin-top:20px;\">" +
                           " <span>Your Password has been reset and you can login by using your email address and password by visiting our website or at the following URL:http://www.staysimplyfied.com </span> " +
                           " </p>" +
                           " <p style=\"margin-top:20px;\">" +
                           " <span>We request you to make note of your user credentials.</span> " + "  <br>" +
                            " </p>" +
                           " <span style=\"font-weight:bold\"> Username : " + Td.Email + " </span> " + "  <br>" +
                           " <span style=\"font-weight:bold\"> Password : " + ds.Tables[0].Rows[0][2] + " </span> " + "  <br>" +
                           " <p style=\"margin-top:20px;\">" +
                           " <span>  If you have problems signing in, please call 1800-425-3454 or email us at stay@staysimplyfied.com </span> " + "  <br>" +
                           " </p>" +
                           " <p style=\"margin-top:20px;\">" +
                           //" <span>  We look forward to your patronage and hope you continue to support us. </span> " +
                           " </p></td></tr></table>";

                        string Disclaimer = "";// "This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                        string FooterDtls =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                             " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                             " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                             " Team Stay Simplyfied </p> " + " <br>" +
                          //   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                          //   " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" +// Disclaimer + "</p>" +
                             " </td></tr> </table>";

                        message.Body = Imagebody + Header + AddressDtls +FooterDtls;
                            message.IsBodyHtml = true; 
                        // SMTP Email email:
                            //System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                            //smtp.Host = "smtp.gmail.com";

                            //smtp.Port = 587;
                            //smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                            //smtp.Credentials = new System.Net.NetworkCredential("noreply@staysimplyfied.com", "reset@12");
                            //smtp.EnableSsl = true;
                            //smtp.Send(message);
                            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                            smtp.EnableSsl = true;
                            smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                            smtp.Port = 587;
                            smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                            try
                            {
                                smtp.Send(message);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + " --> Welcome to Stay Simplified --> " + message.Subject);
                            }   
                    }
               
            }//If End Here
            else
            {
                Td.Email = document.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
                Td.FirstName = document.SelectSingleNode("//HdrXml").Attributes["FirstName"].Value;
                Td.MobileNumber = document.SelectSingleNode("//HdrXml").Attributes["Mobile"].Value;
                //Td.Mode = document.SelectSingleNode("//HdrXml").Attributes["Mode"].Value;
                SqlCommand command = new SqlCommand();
                Td.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
                if (Td.Id != 0)
                {
                    Mode = "Update";
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                        "',SctId:" + user.SctId + ",Service:TravelDeskDao Update" + ",ProcName:'" + StoredProcedures.TravelDesk_Update;

                    command.CommandText = StoredProcedures.TravelDesk_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = Td.Id;
                }
                else
                {
                    Mode = "Save";
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:TravelDeskDao Insert" + ",ProcName:'" + StoredProcedures.TravelDesk_Insert;

                    command.CommandText = StoredProcedures.TravelDesk_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = Td.FirstName;
                command.Parameters.Add("@MobileNumber", SqlDbType.NVarChar).Value = Td.MobileNumber;
                command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["ClientName"].Value;
                command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Designation"].Value;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["LastName"].Value;

                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Td.Email;
                command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["address"].Value;
                command.Parameters.Add("@City", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["City"].Value;
                command.Parameters.Add("@Office", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Office"].Value;
                command.Parameters.Add("@State", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["State"].Value;

                //   command.Parameters.Add("@Password", SqlDbType.NVarChar).Value = 0;// document.SelectSingleNode("//HdrXml").Attributes["State"].Value;

                command.Parameters.Add("@Website", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Website"].Value;
                command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
                command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["StateId"].Value);
                command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["CityId"].Value);
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = Td.Mode;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                string Valid = ""; string Err = "";
                Valid = EmailValidate(Td.Email);

                if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist") && (Td.Id == 0))
                {

                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                   // message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
                    if (Valid == "True")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(Td.Email));
                    }
                    else
                    {
                        Err = "";
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("minidurai@warblerit.com"));
                    message.Subject = "Welcome to Stay Simplified ";

                    string Imagelocation = "";
                    {
                        if (ds.Tables[1].Rows[0][0].ToString() != "")
                            Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                    }
                    message.Body = "";
                    string Imagebody =
                       " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                       " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                       " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                       " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
                       " </td></tr></table>";

                    string Header =
                      " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                      " <tr style=\"font-size:12px; \">" +
                      " <td width=\"600\" style=\"padding:12px 5px;\">" +
                      " <p style=\"margin-top:20px;\">" +
                      " <span> System generated email. Please do not reply. </span>" +
                      " <style=\"margin-top:20px;\">" +
                      " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][3].ToString() + "</span><br>" +
                      " </td></tr></table>";

                    string AddressDtls =
                       " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                       " <tr style=\"font-size:12px;\">" +
                       " <td width=\"600\" style=\"padding:3px 5px;\">" +
                       " <p style=\"margin-top:10px;\">" +
                       " <span>Dear " + Td.FirstName + " </span> " + " <br>" +
                       " </p>" +
                       " <span>Welcome to Stay Simplyfied. India's first digital automation platform for Business STAY.</span> " +
                       " <br>" + " </p>" + " <p style=\"margin-top:20px;\">" +
                       " <span>Your Password has been reset and you can login by using your email address and password by visiting our website or at the following URL:http://www.staysimplyfied.com </span> " +
                       " </p>" +
                       " <p style=\"margin-top:20px;\">" +
                       " <span>We request you to make note of your user credentials.</span> " + "  <br>" +
                       " </p>" +
                       " <span style=\"font-weight:bold\"> Username : " + Td.Email + " </span> " + "  <br>" +
                       " <span style=\"font-weight:bold\"> Password : " + ds.Tables[0].Rows[0][2] + " </span> " + "  <br>" +
                       " <p style=\"margin-top:20px;\">" +
                       " <span>  If you have problems signing in, please call 1800-425-3454 or email us at stay@staysimplyfied.com </span> " + "  <br>" +
                       " </p>" +
                       " <p style=\"margin-top:20px;\">" +
                       //" <span>  We look forward to your patronage and hope you continue to support us. </span> " +
                       " </p></td></tr></table>";

                    string Disclaimer = "";//"This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                    string FooterDtls =
                         " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                         " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                         " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                         " Team Stay Simplyfied </p> " + " <br>" +
                        // " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                        // " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" +// Disclaimer + "</p>" +
                         " </td></tr> </table>";
                    if (Mode == "Save")
                    {
                        message.Body = Imagebody + Header + AddressDtls +FooterDtls;
                        message.IsBodyHtml = true;
                    }
                    if (Mode == "Update")
                    {
                        message.Body = Imagebody + Header + AddressDtls + FooterDtls;
                        message.IsBodyHtml = true;
                    }
                    // SMTP Email email:
                    //System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    //smtp.Host = "smtp.gmail.com";

                    //smtp.Port = 587;
                    ////smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    //smtp.Credentials = new System.Net.NetworkCredential("noreply@staysimplyfied.com", "reset@12");
                    //smtp.EnableSsl = true;
                    //smtp.Send(message);
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                    smtp.Port = 587;
                    smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    try
                    {
                        smtp.Send(message);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> Travel Agency --> " + message.Subject);
                    }  
                }
                //if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
                if (Td.Mode == "ENDUSER")
                {
                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                   // message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
                    if (Valid == "True")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(Td.Email));
                    }
                    else
                    {
                        Err = "INvalid Email";
                        return ds;
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("minidurai@warblerit.com"));
                    message.Subject = "Stay Simplified Account Password Reset ";

                    string Imagelocation = "";
                    {
                        if (ds.Tables[1].Rows[0][0].ToString() != "")
                            Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                    }
                    message.Body = "";
                    string Imagebody =
                       " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                       " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                       " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                       " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
                       " </td></tr></table>";

                    string Header =
                      " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                      " <tr style=\"font-size:12px; \">" +
                      " <td width=\"600\" style=\"padding:12px 5px;\">" +
                      " <p style=\"margin-top:10px;\">" +
                      " <span> System generated email. Please do not reply. </span>" +
                      " <style=\"margin-top:10px;\">" +
                      " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][3].ToString() + "</span><br>" +
                      " </td></tr></table>";

                    string AddressDtls =
                       " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                       " <tr style=\"font-size:12px;\">" +
                       " <td width=\"600\" style=\"padding:3px 5px;\">" +
                       " <p style=\"margin-top:10px;\">" +
                       " <span>Dear " + Td.FirstName + " </span> " + " <br>" +
                       " </p>" +
                       " <span>Welcome to Stay Simplyfied. India's first digital automation platform for Business STAY.</span> " +
                       " <br>" + " </p>" + " <p style=\"margin-top:20px;\">" +
                       " <span>Your Password has been reset and you can login by using your email address and password by visiting our website or at the following URL:http://www.staysimplyfied.com </span> " +
                       " </p>" +
                       " <p style=\"margin-top:20px;\">" +
                       " <span>We request you to make note of your user credentials.</span> " + "  <br>" +
                        " </p>" +
                       " <span style=\"font-weight:bold\"> Username : " + Td.Email + " </span> " + "  <br>" +
                       " <span style=\"font-weight:bold\"> Password : " + ds.Tables[0].Rows[0][2] + " </span> " + "  <br>" +
                       " <p style=\"margin-top:20px;\">" +
                       " <span>  If you have problems signing in, please call 1800-425-3454 or email us at stay@staysimplyfied.com </span> " + "  <br>" +
                       " </p>" +
                       " <p style=\"margin-top:20px;\">" +
                      // " <span>  We look forward to your patronage and hope you continue to support us. </span> " +
                       " </p></td></tr></table>";

                    string Disclaimer = "";//"This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                    string FooterDtls =
                         " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                         " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                         " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                         " Team Stay Simplyfied </p> " + " <br>" +
                       //  " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                      //   " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + //Disclaimer + "</p>" +
                         " </td></tr> </table>";
                    message.Body = Imagebody + Header + AddressDtls + FooterDtls;
                    message.IsBodyHtml = true;

                    //System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    //smtp.Host = "smtp.gmail.com";

                    //smtp.Port = 587;
                    ////smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    //smtp.Credentials = new System.Net.NetworkCredential("noreply@staysimplyfied.com", "reset@12");
                    //smtp.EnableSsl = true;
                    //smtp.Send(message);
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                    smtp.Port = 587;
                    smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    try
                    {
                        smtp.Send(message);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> Travel Desk ENDUSER   --> " + message.Subject);
                    }  
                }
            }
            return ds;
        }
        private String EmailValidate(String EmailId)
        {
            string pattern = null;
            string Msg = null;
            pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

            if (Regex.IsMatch(EmailId, pattern))
            {
                Msg = "True";
            }
            else
            {
                Msg = "False";
            }
            return Msg;
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
               "',SctId:" + user.SctId + ",Service:TravelDeskDao Search" + ",ProcName:'" + StoredProcedures.TravelDesk_Delete;
         
            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.TravelDesk_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(Hdrval[1].ToString());
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Search(string[] Hdrval, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
               "',SctId:" + user.SctId + ",Service:TravelDeskDao Search" + ",ProcName:'" + StoredProcedures.TravelDesk_Select;
            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.TravelDesk_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@Param2", SqlDbType.NVarChar).Value = Hdrval[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
              "',SctId:" + user.SctId + ",Service:TravelDeskDao  Help" + ",ProcName:'" + StoredProcedures.TravelDesk_Help;

            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.TravelDesk_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.NVarChar).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@Param2", SqlDbType.NVarChar).Value = Hdrval[3].ToString();
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Hdrval[4].ToString();
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Hdrval[5].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}

