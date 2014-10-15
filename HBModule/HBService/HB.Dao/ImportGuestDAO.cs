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
    public class ImportGuestDAO
    {
        String UserData;
        public System.Data.DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            ImportGuestEntity Imp = new ImportGuestEntity();
            XmlDocument doc = new XmlDocument();
            int ClientId;
            doc.LoadXml(data[2].ToString());
            ClientId = Convert.ToInt32(doc.SelectSingleNode("//Client").Attributes["ClientId"].Value);

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1].ToString());
            
            int n;
            n = (document).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//HdrXml")[i].Attributes["EmpCode"].Value == "")
                {
                    Imp.EmpCode = "";
                }
                else
                {
                    Imp.EmpCode = document.SelectNodes("//HdrXml")[i].Attributes["EmpCode"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value == "")
                {
                    Imp.FirstName = "";
                }
                else
                {
                    Imp.FirstName = document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["LastName"].Value == "")
                {
                    Imp.LastName = "";
                }
                else
                {
                    Imp.LastName = document.SelectNodes("//HdrXml")[i].Attributes["LastName"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Grade"].Value == "")
                {
                    Imp.Grade = "";
                }
                else
                {
                    Imp.Grade = document.SelectNodes("//HdrXml")[i].Attributes["Grade"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["MobileNo"].Value == "")
                {
                    Imp.MobileNo = "";
                }
                else
                {
                    Imp.MobileNo = document.SelectNodes("//HdrXml")[i].Attributes["MobileNo"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["EmailId"].Value == "")
                {
                    Imp.Email = "";
                }
                else
                {
                    Imp.Email = document.SelectNodes("//HdrXml")[i].Attributes["EmailId"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Designation"].Value == "")
                {
                    Imp.Designation = "";
                }
                else
                {
                    Imp.Designation = document.SelectNodes("//HdrXml")[i].Attributes["Designation"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Nationality"].Value == "")
                {
                    Imp.Nationality = "";
                }
                else
                {
                    Imp.Nationality = document.SelectNodes("//HdrXml")[i].Attributes["Nationality"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column1"].Value == "")
                {
                    Imp.Column1 = "";
                }
                else
                {
                    Imp.Column1 = document.SelectNodes("//HdrXml")[i].Attributes["Column1"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column2"].Value == "")
                {
                    Imp.Column2 = "";
                }
                else
                {
                    Imp.Column2 = document.SelectNodes("//HdrXml")[i].Attributes["Column2"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column3"].Value == "")
                {
                    Imp.Column3 = "";
                }
                else
                {
                    Imp.Column3 = document.SelectNodes("//HdrXml")[i].Attributes["Column3"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column4"].Value == "")
                {
                    Imp.Column4 = "";
                }
                else
                {
                    Imp.Column4 = document.SelectNodes("//HdrXml")[i].Attributes["Column4"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column5"].Value == "")
                {
                    Imp.Column5 = "";
                }
                else
                {
                    Imp.Column5 = document.SelectNodes("//HdrXml")[i].Attributes["Column5"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column6"].Value == "")
                {
                    Imp.Column6 = "";
                }
                else
                {
                    Imp.Column6 = document.SelectNodes("//HdrXml")[i].Attributes["Column6"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column7"].Value == "")
                {
                    Imp.Column7 = "";
                }
                else
                {
                    Imp.Column7 = document.SelectNodes("//HdrXml")[i].Attributes["Column7"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column8"].Value == "")
                {
                    Imp.Column8 = "";
                }
                else
                {
                    Imp.Column8 = document.SelectNodes("//HdrXml")[i].Attributes["Column8"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column9"].Value == "")
                {
                    Imp.Column9 = "";
                }
                else
                {
                    Imp.Column9 = document.SelectNodes("//HdrXml")[i].Attributes["Column9"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Column10"].Value == "")
                {
                    Imp.Column10 = "";
                }
                else
                {
                    Imp.Column10 = document.SelectNodes("//HdrXml")[i].Attributes["Column10"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value == "")
                {
                    Imp.Id = 0;
                }
                else
                {
                    Imp.Id = Convert.ToInt32( document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value);
                }
                    command = new SqlCommand();
                if (Imp.Id != 0)
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                        "',SctId:" + user.SctId + ",Service: ImportGuestDAO  Update" + ",ProcName:'" + StoredProcedures.ImportGuest_Update;

                   command.CommandText = StoredProcedures.ImportGuest_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Imp.Id;
                }
                else
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                  "',SctId:" + user.SctId + ",Service: ImportGuestDAO  Insert" + ",ProcName:'" + StoredProcedures.ImportGuest_Insert;

                   command.CommandText = StoredProcedures.ImportGuest_Insert;
                }
             
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@EmpCode", SqlDbType.NVarChar).Value = Imp.EmpCode;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = Imp.FirstName;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = Imp.LastName;
                command.Parameters.Add("@Grade", SqlDbType.NVarChar).Value = Imp.Grade;
                command.Parameters.Add("@MobileNumber", SqlDbType.NVarChar).Value = Imp.MobileNo;
                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Imp.Email;
                command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = Imp.Designation;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = ClientId;
                command.Parameters.Add("@CompanyName", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Nationality", SqlDbType.NVarChar).Value = Imp.Nationality;
                command.Parameters.Add("C1", SqlDbType.NVarChar).Value = Imp.Column1;
                command.Parameters.Add("C2", SqlDbType.NVarChar).Value = Imp.Column2;
                command.Parameters.Add("C3", SqlDbType.NVarChar).Value = Imp.Column3;
                command.Parameters.Add("C4", SqlDbType.NVarChar).Value = Imp.Column4;
                command.Parameters.Add("C5", SqlDbType.NVarChar).Value = Imp.Column5;
                command.Parameters.Add("C6", SqlDbType.NVarChar).Value = Imp.Column6;
                command.Parameters.Add("C7", SqlDbType.NVarChar).Value = Imp.Column7;
                command.Parameters.Add("C8", SqlDbType.NVarChar).Value = Imp.Column8;
                command.Parameters.Add("C9", SqlDbType.NVarChar).Value = Imp.Column9;
                command.Parameters.Add("C10", SqlDbType.NVarChar).Value = Imp.Column10;
              
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                
            }
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
               "',SctId:" + user.SctId + ",Service: ImportGuestDAO  Select" + ",ProcName:'" + StoredProcedures.ImportGuest_Select;

            ImportGuestEntity Imp = new ImportGuestEntity();
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ImportGuest_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Imp.ClientId;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        //public DataSet Help(string[] data, User user)
        //{
        //  UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
        //     "',SctId:" + user.SctId + ",Service: ImportGuestDAO  Help" + ",ProcName:'" + StoredProcedures.ImportGuest_Help;
 
        //    SqlCommand command = new SqlCommand();
        //    command.CommandText = StoredProcedures.ImportGuest_Help;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
        //    command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
        //    command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
        //    return new WrbErpConnection().ExecuteDataSet(command, UserData);
        //}

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
             "',SctId:" + user.SctId + ",Service: ImportGuestDAO  Help" + ",ProcName:'" + StoredProcedures.ImportGuest_Help;
 
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ImportGuest_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
