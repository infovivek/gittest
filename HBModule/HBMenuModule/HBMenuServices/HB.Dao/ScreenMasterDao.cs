using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Xml;
using System.Collections;
using HB.Entity;

namespace HB.Dao
{
   public class ScreenMasterDao
    {
       string UserData;
        SqlCommand cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
            ScreenMaster Scr = new ScreenMaster();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");

            doc.LoadXml(data[1].ToString());
            Scr.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Scr.ScreenName = doc.SelectSingleNode("HdrXml").Attributes["ScreenName"].Value;
            Scr.ModuleName = doc.SelectSingleNode("HdrXml").Attributes["ModuleName"].Value;
            Scr.ModuleId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ModuleId"].Value);
            //Scr.SubModuleName = doc.SelectSingleNode("HdrXml").Attributes["SubModuleName"].Value;
            Scr.SWF = doc.SelectSingleNode("HdrXml").Attributes["SWF"].Value;
           // Scr.CountId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CountId"].Value);
            // Scr.Date = doc.SelectSingleNode("HdrXml").Attributes["CreatedDate"].Value;
             Scr.OrderId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["OrderId"].Value);

            SqlCommand cmd = new SqlCommand();

            if (Scr.Id != 0)
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:ScreenMasterDao Update" + ", ProcName:'" + StoredProcedures.ScreenMaster_update; 


                cmd.CommandText = StoredProcedures.ScreenMaster_update;
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Scr.Id;
            }
            else
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:ScreenMasterDao Insert" + ", ProcName:'" + StoredProcedures.ScreenMaster_insert; 


                cmd.CommandText = StoredProcedures.ScreenMaster_insert;
            }
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@ScreenName", SqlDbType.NVarChar).Value = Scr.ScreenName;
            cmd.Parameters.Add("@ModuleName", SqlDbType.NVarChar).Value = Scr.ModuleName;
            cmd.Parameters.Add("@ModuleId", SqlDbType.Int).Value = Scr.ModuleId;
           // cmd.Parameters.Add("@SubModuleName", SqlDbType.NVarChar).Value = Scr.SubModuleName;
            cmd.Parameters.Add("@SWF", SqlDbType.NVarChar).Value = Scr.SWF;
           // cmd.Parameters.Add("@OrderNumber", SqlDbType.Int).Value = 0;
            cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = User.Id;
            cmd.Parameters.Add("@OrderNumber", SqlDbType.Int).Value = Scr.OrderId;
            return new WrbErpConnection().ExecuteDataSet(cmd, UserData);
        }
        public DataSet HelpResult(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:ScreenMasterDao Help" + ", ProcName:'" + StoredProcedures.ScreenMaster_help; 

            cmd = new SqlCommand();
            cmd.CommandText = StoredProcedures.ScreenMaster_help;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(cmd, UserData);
        }
        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:ScreenMasterDao Delete" + ", ProcName:'" + StoredProcedures.ScreenMaster_delete; 

            SqlCommand cmd = new SqlCommand(); 
            cmd.CommandText = StoredProcedures.ScreenMaster_delete;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(cmd, UserData);
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:ScreenMasterDao Search" + ", ProcName:'" + StoredProcedures.ScreenMaster_select; 

            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter();
            cmd = new SqlCommand();
            cmd.CommandText = StoredProcedures.ScreenMaster_select;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(cmd, UserData);
        }
    }
}

