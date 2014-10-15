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
    public class AddUserDAO
    {
        String UserData;
        public DataSet Save(string Hdrval, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
            AddUser Au = new  AddUser();
           Au.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
           Au.Title = document.SelectSingleNode("//HdrXml").Attributes["Title"].Value;
           Au.FirstName = document.SelectSingleNode("//HdrXml").Attributes["FirstName"].Value;
           Au.LastName = document.SelectSingleNode("//HdrXml").Attributes["LastName"].Value;
           Au.Mobile = document.SelectSingleNode("//HdrXml").Attributes["Mobile"].Value;
           Au.Email = document.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
           Au.Active = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Activation"].Value);
           Au.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value); 
           if (Au.Id != 0)
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                     "', SctId:" + user.SctId + ", Service:AddUserDAO Update" + ", ProcName:'" + StoredProcedures.AddUser_Update; 

              command.CommandText = StoredProcedures.AddUser_Update;
              command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Au.Id;
           }
           else
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                     "', SctId:" + user.SctId + ", Service:AddUserDAO Insert" + ", ProcName:'" + StoredProcedures.AddUser_Insert; 

               command.CommandText = StoredProcedures.AddUser_Insert;
           }
             command.CommandType = CommandType.StoredProcedure; 
             command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value=Au.ClientId;
             command.Parameters.Add("@Title", SqlDbType.NVarChar).Value = Au.Title;
             command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value =Au.FirstName;
             command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value =Au.LastName;
             command.Parameters.Add("@Mobile", SqlDbType.BigInt).Value = Au.Mobile;
             command.Parameters.Add("@Email", SqlDbType.NVarChar).Value =Au.Email;
             command.Parameters.Add("@Agreed", SqlDbType.NVarChar).Value = Au.Active;      
             command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

           ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

           //Email to User
           if ((ds.Tables[0].Rows[0][0].ToString() != "Email Already Exists")) 
           {

               System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();

               message.From = new System.Net.Mail.MailAddress("password@hummingbirdindia.com", "HB Password " + (char)0xD8 + "passwordhb@321", System.Text.Encoding.UTF8);

               message.To.Add(new System.Net.Mail.MailAddress(Au.Email));

               message.Subject = "Password";

               message.Body = "Your Password: " + ds.Tables[0].Rows[0][2];

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
       public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                     "', SctId:" + user.SctId + ", Service:AddUserDAO Select" + ", ProcName:'" + StoredProcedures.AddUser_Select; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.AddUser_Select;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
           //command.Parameters.Add("@Active", SqlDbType.NVarChar).Value = data[2].ToString();
           command.Parameters.Add("@Id", SqlDbType.VarChar).Value = data[1].ToString(); 
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Delete(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:AddUserDAO Delete" + ", ProcName:'" + StoredProcedures.AddUser_Delete; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.AddUser_Delete;
           command.CommandType = CommandType.StoredProcedure;
           //command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[0].ToString());
           command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Help(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:AddUserDAO Help" + ", ProcName:'" + StoredProcedures.AddUser_Help; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.AddUser_Help;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
          // command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }

   }
 }
