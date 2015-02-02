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
    public class MapVendorDAO
    {
        String UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            MapVendor MP = new MapVendor();
            XmlDocument doc = new XmlDocument();

            int VendorId;
            doc.LoadXml(data[1].ToString());
            VendorId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["VendorId"].Value);

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[2].ToString());

            int n;
            n = (document).SelectNodes("//ServiceXml").Count;

            for (int i = 0; i < n; i++)
            {
                    MP.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                    MP.Process = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Process"].Value);
                    MP.PropertyName = document.SelectNodes("//ServiceXml")[i].Attributes["PropertyName"].Value;
                    MP.PropertyId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["PropertyId"].Value);
                    command = new SqlCommand();
                    if (MP.Id != 0)
                    {
                        UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                            "', SctId:" + user.SctId + ", Service:MapVendorDAO Update" + ", ProcName:'" + StoredProcedures.MapVendor_Update;

                        command.CommandText = StoredProcedures.MapVendor_Update;
                        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = MP.Id;
                    }
                    else
                    {
                        UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                            "', SctId:" + user.SctId + ", Service:MapVendorDAO Insert" + ", ProcName:'" + StoredProcedures.MapVendor_Insert;

                        command.CommandText = StoredProcedures.MapVendor_Insert;
                    }
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@VendorId", SqlDbType.BigInt).Value = VendorId;
                    command.Parameters.Add("@Process", SqlDbType.Bit).Value = MP.Process;
                    command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = MP.PropertyName;
                    command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = MP.PropertyId;
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                    ds = new WrbErpConnection().ExecuteDataSet(command, "");
               
             }
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:MapVendorDAO Select" + ", ProcName:'";// +StoredProcedures.PCHistory_Help; 

            MapVendor MP = new MapVendor();
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures.PettyCashStatus_Select;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
            //command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
            //command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());//Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet HelpResult(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:MapVendorDAO Help" + ", ProcName:'" + StoredProcedures.MapVendor_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.MapVendor_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}
