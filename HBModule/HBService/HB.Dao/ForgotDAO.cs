using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;

namespace HB.Dao
{
    public class ForgotDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user) 
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:ForgotDAO " + ", ProcName:'";// +StoredProcedures.CheckInHdr_Update; 
       
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return Value;

        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:ForgotDAO Select" + ", ProcName:'" + StoredProcedures.Forgot_Select; 

            DataSet ds = new DataSet();
             Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.Forgot_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1].ToString());

            var Email = document.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
            Cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Email;
            Cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);

            //Email to User
            if ((ds.Tables[0].Rows[0][0].ToString() != "EmailId Is Incorrect"))
            {

                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();

                message.From = new System.Net.Mail.MailAddress("password@hummingbirdindia.com", "HB Password " + (char)0xD8 + "passwordhb@321", System.Text.Encoding.UTF8);

                message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[0].Rows[0][1].ToString()));

                message.Subject = "Password";

                message.Body = "Your Password: " + ds.Tables[0].Rows[0][0];

                message.IsBodyHtml = true;

                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = "smtp.gmail.com";

                smtp.Port = 587;
                smtp.Credentials = new System.Net.NetworkCredential("password@hummingbirdindia.com", "passwordhb@321");

                smtp.EnableSsl = true;
                smtp.Send(message);
            }
            return ds;
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                             "', SctId:" + user.SctId + ", Service:ForgotDAO " + ", Nil:'";// +StoredProcedures.CheckInHdr_Update; 
            
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                            "', SctId:" + user.SctId + ", Service:ForgotDAO " + ", Nil:'";// +StoredProcedures.CheckInHdr_Update; 
            
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
