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

namespace HB.Dao
{

    public class UserMasterDao
    {
         string UserData;
        /* public DataSet Save(string[] data, User User)
         {
            
         }*/
        
         public DataSet Save(string[] Hdrval, User user)
         {
             UserMaster UserM = new UserMaster();
             XmlDocument document = new XmlDocument();
             DataSet ds = new DataSet();
             DataTable dTable = new DataTable("ERRORTBL");
             dTable.Columns.Add("Exception");

//User Insert(detailed)
                 document.LoadXml(Hdrval[1].ToString());
                 UserM.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
                 UserM.UserName = document.SelectSingleNode("HdrXml").Attributes["UserName"].Value;
                 //UserM.UserPassword = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["UserPassword"].Value);
                // UserM.UserGroup = document.SelectSingleNode("HdrXml").Attributes["UserGroup"].Value;
                // UserM.UserRoles = document.SelectSingleNode("HdrXml").Attributes["UserRoles"].Value;
                 UserM.Email = document.SelectSingleNode("HdrXml").Attributes["Email"].Value;
                 UserM.FirstName = document.SelectSingleNode("HdrXml").Attributes["FirstName"].Value;
                 UserM.LastName = document.SelectSingleNode("HdrXml").Attributes["LastName"].Value;
                 UserM.Address = document.SelectSingleNode("HdrXml").Attributes["Address"].Value;
                 UserM.City = document.SelectSingleNode("HdrXml").Attributes["City"].Value;
                 UserM.State = document.SelectSingleNode("HdrXml").Attributes["State"].Value;
                 UserM.Zip = document.SelectSingleNode("HdrXml").Attributes["Zip"].Value;
                // UserM.PhoneNumber = document.SelectSingleNode("HdrXml").Attributes["PhoneNumber"].Value;
                 UserM.MobileNumber = document.SelectSingleNode("HdrXml").Attributes["MobileNumber"].Value;
               //  UserM.Title = document.SelectSingleNode("HdrXml").Attributes["Title"].Value;
                 UserM.CountId = document.SelectSingleNode("HdrXml").Attributes["CountId"].Value;
                 SqlCommand command = new SqlCommand();

            

             if (UserM.Id != 0)
                 {
                     UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                         "',SctId:" + user.SctId + ",Service:  UserMasterDao Update" + ",ProcName:'" + StoredProcedures.UserMaster_Update;

                     command.CommandText = StoredProcedures.UserMaster_Update;
                     command.Parameters.Add("@Id", SqlDbType.Int).Value = UserM.Id;
                 }
                 else
                 {
                     UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                         "',SctId:" + user.SctId + ",Service:  UserMasterDao save" + ",ProcName:'" + StoredProcedures.UserMaster_Insert;
                     command.CommandText = StoredProcedures.UserMaster_Insert;
                 }
                 command.CommandType = CommandType.StoredProcedure;
                // command.Parameters.Add("@Title", SqlDbType.NVarChar).Value = UserM.Title;
                 command.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = UserM.UserName;
                // command.Parameters.Add("@UserPassword", SqlDbType.NVarChar).Value = UserM.UserPassword;
                // command.Parameters.Add("@UserGroup", SqlDbType.NVarChar).Value = UserM.UserGroup;
               //  command.Parameters.Add("@UserRoles", SqlDbType.NVarChar).Value = UserM.UserRoles;
                 command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = UserM.Email;
                 command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = UserM.FirstName;
                 command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = UserM.LastName;
                 command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = UserM.Address;
                 command.Parameters.Add("@City", SqlDbType.NVarChar).Value = UserM.City;
                 command.Parameters.Add("@State", SqlDbType.NVarChar).Value = UserM.State;
                 command.Parameters.Add("@Zip", SqlDbType.NVarChar).Value = UserM.Zip;
              //   command.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar).Value = UserM.PhoneNumber;
                 command.Parameters.Add("@MobileNumber", SqlDbType.NVarChar).Value = UserM.MobileNumber;
                 command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                 command.Parameters.Add("@EmployeeId", SqlDbType.NVarChar).Value = "1001";
                 command.Parameters.Add("@CountId", SqlDbType.BigInt).Value =0;
                 ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                 //Email to User
                 if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist") && (UserM.Id == 0))
                 {

                     System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();

                     message.From = new System.Net.Mail.MailAddress("noreply@hummingbirdindia.com", "HB Password " + (char)0xD8 + " Password", System.Text.Encoding.UTF8);

                     message.To.Add(new System.Net.Mail.MailAddress(UserM.Email));

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
         public DataSet Delete(string[] Hdrval, User user)
         {
             UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  UserMasterDao  Delete" + ",ProcName:'" + StoredProcedures.UserMaster_Delete;

             SqlCommand command = new SqlCommand();
             command.CommandText = StoredProcedures.UserMaster_Delete;
             command.CommandType = CommandType.StoredProcedure;
             command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(Hdrval[1].ToString());
            // command.Parameters.Add("@UserId", SqlDbType.Int).Value = 1;
             return new WrbErpConnection().ExecuteDataSet(command, UserData);
         }
     
         public DataSet Search(string[] Hdrval, User user)
         {
             UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  UserMasterDao  Search" + ",ProcName:'" + StoredProcedures.UserMaster_Select;

             SqlCommand command = new SqlCommand();
             command = new SqlCommand();
            // um.Id =Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
             command.CommandText = StoredProcedures.UserMaster_Select; 
             command.CommandType = CommandType.StoredProcedure;
             command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Hdrval[1].ToString();
             return new WrbErpConnection().ExecuteDataSet(command, UserData);
         }
         public DataSet HelpResult(string[] Hdrval, User user)
         {
             UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  UserMasterDao  Help" + ",ProcName:'" + StoredProcedures.UserMaster_Help;

             SqlCommand command = new SqlCommand();
             command.CommandText = StoredProcedures.ChangePassword_help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.NVarChar).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@Param2", SqlDbType.NVarChar).Value = Hdrval[3].ToString();
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Hdrval[4].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
         }
    }
}
