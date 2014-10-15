using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;
using HB.Entity;

namespace HB.Dao
{
    public class ClientMgntAddNewClientDAO
    {
        string UserData;
        public DataSet Save(String CltmgntRowId,Int32 CltmgntID, string Dtlval, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            document.LoadXml(Dtlval);
            ClientMgntAddNewClient NewClient = new ClientMgntAddNewClient(); 
            int n;
            n = (document).SelectNodes("//NewClientXml").Count;
            for (int i = 0; i < n; i++)
            {
                NewClient.ContactType = document.SelectNodes("//NewClientXml")[i].Attributes["EscalationLevel"].Value;
                NewClient.Title = document.SelectNodes("//NewClientXml")[i].Attributes["Title"].Value;
                NewClient.FirstName = document.SelectNodes("//NewClientXml")[i].Attributes["FirstName"].Value;
                NewClient.LastName = document.SelectNodes("//NewClientXml")[i].Attributes["LastName"].Value;
                NewClient.Gender = "";
                NewClient.Designation = document.SelectNodes("//NewClientXml")[i].Attributes["Designation"].Value;
                NewClient.MobileNo = document.SelectNodes("//NewClientXml")[i].Attributes["MobileNo"].Value;
                NewClient.Email = document.SelectNodes("//NewClientXml")[i].Attributes["Email"].Value;
                NewClient.AlternateEmail = document.SelectNodes("//NewClientXml")[i].Attributes["AlternateEmail"].Value;
                if (document.SelectNodes("//NewClientXml")[i].Attributes["Id"].Value == "")
                {
                    NewClient.Id = 0;
                }
                else
                {
                    NewClient.Id = Convert.ToInt32(document.SelectNodes("//NewClientXml")[i].Attributes["Id"].Value);
                }                
                command = new SqlCommand();
                ds = new DataSet();
                if (NewClient.Id != 0)
                {
                    command.CommandText = StoredProcedures.ClientMgntAddNewClient_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = NewClient.Id;
                }
                else
                {
                     command.CommandText = StoredProcedures.ClientMgntAddNewClient_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CltmgntId", SqlDbType.BigInt).Value = CltmgntID;
                command.Parameters.Add("@CltmgntRowId", SqlDbType.NVarChar).Value = CltmgntRowId;
                command.Parameters.Add("@ContactType", SqlDbType.NVarChar).Value = NewClient.ContactType;
                command.Parameters.Add("@Title", SqlDbType.NVarChar).Value = NewClient.Title;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = NewClient.FirstName;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = NewClient.LastName;
                command.Parameters.Add("@Gender", SqlDbType.NVarChar).Value = NewClient.Gender;
                command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = NewClient.Designation;
                command.Parameters.Add("@MobileNo", SqlDbType.NVarChar).Value = NewClient.MobileNo;
                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = NewClient.Email;
                command.Parameters.Add("@AlternateEmail", SqlDbType.NVarChar).Value = NewClient.AlternateEmail;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = User.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    return ds;
                }
            }
            if (n == 0)
            {
                DataTable ErrdT = new DataTable("DBERRORTBL");
                ds.Tables.Add(ErrdT);
            }
            return ds;
        }
    }
}
