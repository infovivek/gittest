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
    public class MasterClientManagementDAO
    {
        SqlCommand Cmd = new SqlCommand();
        string UserData;
        public DataSet Save(string[] data, User user) 
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:PCHistroryDAO Help" + ", ProcName:'" + StoredProcedures.PCHistory_Help;
            DataSet ds = new DataSet();
            Cmd = new SqlCommand();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[2]);
            if (Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value) != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:MasterClientManagementDAO Update" + ", ProcName:'" + StoredProcedures.MasterClientManagement_Update;
     
                Cmd.CommandText = StoredProcedures.MasterClientManagement_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:MasterClientManagementDAO Insert" + ", ProcName:'" + StoredProcedures.MasterClientManagement_Insert;
     
                Cmd.CommandText = StoredProcedures.MasterClientManagement_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            Cmd.Parameters.Add("@CAddress1", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CAddress1"].Value;
            Cmd.Parameters.Add("@CAddress2", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CAddress2"].Value;
            Cmd.Parameters.Add("@CCountry", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CCountry"].Value;
            Cmd.Parameters.Add("@InCCountry", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["InCCountry"].Value;
            Cmd.Parameters.Add("@CState", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CState"].Value;
            Cmd.Parameters.Add("@CCity", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CCity"].Value;
            Cmd.Parameters.Add("@CLocality", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CLocality"].Value;
            Cmd.Parameters.Add("@CPincode", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPincode"].Value;
            Cmd.Parameters.Add("@ContactNo", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["ContactNo"].Value;
            Cmd.Parameters.Add("@DomainName", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["DomainName"].Value;
            Cmd.Parameters.Add("@CPhoneNo1", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo1"].Value;
            Cmd.Parameters.Add("@CPhoneNo2", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo2"].Value;
            Cmd.Parameters.Add("@CPhoneNo3", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo3"].Value;
            Cmd.Parameters.Add("@CPhoneNo4", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo4"].Value;
            Cmd.Parameters.Add("@CPhoneNo5", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo5"].Value;
            Cmd.Parameters.Add("@ClientLogo", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Convert.ToInt32(user.Id);
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                "', SctId:" + User.SctId + ", Service:MasterClientManagementDAO Select" + ", ProcName:'" + StoredProcedures.MasterClientManagement_Select;
            
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.MasterClientManagement_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                   "', SctId:" + User.SctId + ", Service:MasterClientManagementDAO Delete" + ", ProcName:'" + StoredProcedures.MasterClientManagement_Delete;
            
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.MasterClientManagement_Delete;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:MasterClientManagementDAO Help" + ", ProcName:'" + StoredProcedures.MasterClientManagement_Help; 

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.MasterClientManagement_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str", SqlDbType.VarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}