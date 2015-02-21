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
    public class CloneClientDAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            string UserData;
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            CloneClientEntity CC = new CloneClientEntity();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1].ToString());

            CC.FromId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["FromId"].Value);

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[2].ToString());
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {

                CC.ToId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ClientId"].Value);

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                           "', SctId:" + user.SctId + ", Service:CloneClientPref_Insert Insert" + ", ProcName:'" + StoredProcedures.CloneClientPref_Insert;
                command = new SqlCommand();
                command.CommandText = StoredProcedures.CloneClientPref_Insert;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@FromId", SqlDbType.NVarChar).Value = CC.FromId;
                command.Parameters.Add("@ToId", SqlDbType.NVarChar).Value = CC.ToId;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            String UserData;
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
      "', SctId:" + user.SctId + ", Service:PettyCashDAO Help" + ", ProcName:'" + StoredProcedures.PettyCash_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.CloneClientPref_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
