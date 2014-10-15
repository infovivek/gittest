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
    public class ClientManagementDAO
    {
        SqlCommand Cmd = new SqlCommand();
        string UserData;
        public DataSet Save(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            DataSet ds = new DataSet();
            Cmd = new SqlCommand();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[2]);
            if (Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value) != 0)
            {
                Cmd.CommandText = StoredProcedures.ClientManagement_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            }
            else
            {
                Cmd.CommandText = StoredProcedures.ClientManagement_Insert;
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
            Cmd.Parameters.Add("@ServiceCharge", SqlDbType.BigInt).Value =Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value);
            Cmd.Parameters.Add("@DirectPay", SqlDbType.Bit).Value = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["DirectPay"].Value);
            Cmd.Parameters.Add("@BTC", SqlDbType.Bit).Value = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["BTC"].Value);
            Cmd.Parameters.Add("@CreditLimit", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CreditLimit"].Value);
            Cmd.Parameters.Add("@CreditPeriod", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CreditPeriod"].Value;
            Cmd.Parameters.Add("@CreditPeriodNumber", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CreditPeriodNumber"].Value;
            Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            Cmd.Parameters.Add("@MasterClient", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["MasterClient"].Value;
            Cmd.Parameters.Add("@MasterClientId", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["MasterClientId"].Value);
            Cmd.Parameters.Add("@BAddress1", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BAddress1"].Value;
            Cmd.Parameters.Add("@BAddress2", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BAddress2"].Value;
            Cmd.Parameters.Add("@BCountry", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BCountry"].Value;
            Cmd.Parameters.Add("@InBCountry", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["InBCountry"].Value;
            Cmd.Parameters.Add("@BState", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BState"].Value;
            Cmd.Parameters.Add("@BCity", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BCity"].Value;
            Cmd.Parameters.Add("@BLocality", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BLocality"].Value;
            Cmd.Parameters.Add("@BPincode", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["BPincode"].Value;
            Cmd.Parameters.Add("@SalesExecutiveId", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["SalesExecutiveId"].Value);
            Cmd.Parameters.Add("@CRMId", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CRMId"].Value);
            Cmd.Parameters.Add("@KeyAccountPersonId", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["KeyAccountPersonId"].Value);
            Cmd.Parameters.Add("@DomainName", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["DomainName"].Value;
            Cmd.Parameters.Add("@IndustryType", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["IndustryType"].Value;
            Cmd.Parameters.Add("@CPhoneNo1", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo1"].Value;
            Cmd.Parameters.Add("@CPhoneNo2", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo2"].Value;
            Cmd.Parameters.Add("@CPhoneNo3", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo3"].Value;
            Cmd.Parameters.Add("@CPhoneNo4", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo4"].Value;
            Cmd.Parameters.Add("@CPhoneNo5", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CPhoneNo5"].Value;
            Cmd.Parameters.Add("@ClientLogo", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Convert.ToInt32(User.Id);
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.ClientManagement_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.ClientManagement_Delete;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User user)
        {
            if (data[1].ToString() == "IMAGEUPLOAD")
            {
                string ClientString = data[2].ToString();
                string[] Arr;
                Arr = ClientString.Split('&');
                Cmd = new SqlCommand();
                Cmd.CommandText = StoredProcedures.ClientManagement_Help;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
                Cmd.Parameters.Add("@Str", SqlDbType.VarChar).Value = Arr[0].ToString();
                Cmd.Parameters.Add("@Str1", SqlDbType.VarChar).Value = Arr[1].ToString();
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
                return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            }
            else
            {

                Cmd = new SqlCommand();
                Cmd.CommandText = StoredProcedures.ClientManagement_Help;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
                Cmd.Parameters.Add("@Str", SqlDbType.VarChar).Value = data[2].ToString();
                Cmd.Parameters.Add("@Str1", SqlDbType.VarChar).Value ="";
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
                return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            }
        }
    }
}
