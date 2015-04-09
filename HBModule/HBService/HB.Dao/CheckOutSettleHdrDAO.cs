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
    public class CheckOutSettleHdrDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutSettleHdr ChkOutSet = new CheckOutSettleHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutSet.CheckOutHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutHdrId"].Value);
            ChkOutSet.PayeeName = doc.SelectSingleNode("HdrXml").Attributes["PayeeName"].Value;
            ChkOutSet.Address = doc.SelectSingleNode("HdrXml").Attributes["Address"].Value;
            ChkOutSet.Consolidated = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Consolidated"].Value);
          
            Cmd = new SqlCommand();
            if (ChkOutSet.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdrSettleHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutSet.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutHdrSettleHdr_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutSet.CheckOutHdrId;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutSet.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutSet.Address;
            Cmd.Parameters.Add("@Consolidated", SqlDbType.Bit).Value =ChkOutSet.Consolidated;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");


            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            message.From = new System.Net.Mail.MailAddress("noreply@hummingbirdindia.com", "HummingBird", System.Text.Encoding.UTF8);
            string Valid = ""; string Err = "";
           
            if (ds.Tables[1].Rows[0][3].ToString() != "") // GuestMail 
            {
                int Cntfalse = 0;
                    if (ds.Tables[1].Rows[0][3].ToString() != "")
                    {
                        string ExtraCC = ds.Tables[1].Rows[0][3].ToString();
                        var ExtraCCEmail = ExtraCC.Split(',');
                        int cnt = ExtraCCEmail.Length;
                        for (int i = 0; i < cnt; i++)
                        {
                            if (ExtraCCEmail[i].ToString() != "")
                            {
                                Valid = EmailValidate(ExtraCCEmail[i].ToString());
                                if (Valid == "True")
                                {
                                    message.To.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                                }
                                else
                                {
                                    Cntfalse += 1;
                                }
                            }
                        }
                        if (Cntfalse == cnt)
                        {
                            
                            message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
                            
                        }
                        else
                        {
                            
                            message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
                            
                        }
                    }
                    else
                    {
                        
                        message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
                        
                    }

      //      //for mail to direct mode
      //      string Valid = ""; string Err = "";
      //      //     string Email = "shiv@hummingbirdindia.com";
      //   //   string Email = "shameem@warblerit.com";
      //      string Email = ds.Tables[1].Rows[0][3].ToString();
      //      Valid = EmailValidate(Email);

      //      if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
      //      {

      //          System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
      //   //       message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
      //          message.From = new System.Net.Mail.MailAddress("feedbackhb@hummingbirdindia.com", "Hummingbird Feedback", System.Text.Encoding.UTF8);
      //          if (Valid == "True")
      //          {
      //              message.To.Add(new System.Net.Mail.MailAddress(Email));
      //          }
      //          else
      //          {
      //              Err = "";
      //          }
      ////          message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
      //          message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
      //          //     message.Bcc.Add(new System.Net.Mail.MailAddress("silam@hummingbirdindia.com"));
      //          //     message.Bcc.Add(new System.Net.Mail.MailAddress("karthik@hummingbirdindia.com"));

                message.Subject = "FeedBack Form";
                string Imagelocation = "";
                {
                    if (ds.Tables[1].Rows[0][0].ToString() != "")
                        Imagelocation = ds.Tables[1].Rows[0][2].ToString();
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
                    //        " <span> System generated email. Please do not reply. </span>" +
                          " <style=\"margin-top:20px;\">" +
                    //     " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][2].ToString() + "</span><br>" +
                          " </td></tr></table>";
                string AddressDtls =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                           " <tr style=\"font-size:12px;\">" +
                           " <td width=\"600\" style=\"padding:3px 5px;\">" +
                           " <p style=\"margin-top:10px;\">" +
                           "<span>Dear Guest , </span> " + " <br>" +
                           " </p>" +
                           "<span>Thank you for Booking HummingBird. " +
                            " <br>" +
                            " <br>" +
                           "<span>We request you to share your feedback during your stay at <B> " + ds.Tables[1].Rows[0][0].ToString() + "  </B>  " +
                           "from  <B>" + ds.Tables[1].Rows[0][1].ToString() + " </B>. This feedback will help us improve  " +
                           "our service and also shown on our site as a user rating. Many travelers depend on these ratings to choose a Hotel. " +
                           " <br>" +
                           " <br>" +
                      //     "http://sstage.in/Form?data=398EC317-23C5-4DC9-B254-A9B39E128507" +
                           "<span> Submit your feedback here.  " +
                           " <br>" +
                           " <br>" +
                          

                           "<tr>" +
                           "<td align=\"center\" width=\"150\" height=\"40\" bgcolor=\"#e6802b\" style=\"-webkit-border-radius: 5px; -moz-border-radius: 6px; border-radius: 15px; color: #ffffff; display: block;\">" +
                         //  "<a href=\"http://www.hummingbirdindia.com/Feedback?data=E6C6CEAC-9A10-459F-88D8-F10287824DBA\" target=\"_blank\" style=\"font-size:16px; font-weight: bold; font-family: Helvetica, Arial, sans-serif; text-decoration: none; line-height:40px; width:100%; display:inline-block\"><span style=\"color: #FFFFFF\">Leave Feedback</span></a>" +
                           "<a href=\"http://www.hummingbirdindia.com/Feedback?data=" + ds.Tables[0].Rows[0][1].ToString() + " target=\"_blank\" style=\"font-size:16px; font-weight: bold; font-family: Helvetica, Arial, sans-serif; text-decoration: none; line-height:40px; width:100%; display:inline-block\"><span style=\"color: #FFFFFF\">Leave Feedback</span></a>" +
                           "</td></tr> " +
                           "<br>" +
                            "<span>We look forward to serving you many more times in the future.  " +
                           " <br>" +


                           " </p>" +
                           "<br>" +




                           " </p></td></tr></table>";

                string FooterDtls =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                   " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                   " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Best regards, <br>" +
                   "<br>" +
                   " Team Humming Bird  </p> " + " <br>" +
                    //   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                    //   " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" +// Disclaimer + "</p>" +
                   " </td></tr> </table>";

                message.Body = Imagebody + Header + AddressDtls + FooterDtls;
                message.IsBodyHtml = true;



                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                //Local test for below smtp 
                //smtp.Host = "smtp.gmail.com";

                smtp.Port = 587;
                smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                //smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " -->Internal Feedback Checkout --> " + message.Subject);
                }
            
          }//Mail Close 

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

        public DataSet Search(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            //Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.CheckOut_Select;
            //Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
        public DataSet HelpResult(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            //Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.CheckOutHdrService_Help;
            //Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            //Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            //Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            //Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
    
