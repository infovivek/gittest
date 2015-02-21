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
    public class TRLinkDAO
    {
        String UserData;
       public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            TRLinkEntity TR = new TRLinkEntity();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1]);

            TR.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);

            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:TRLink_Insert Insert" + ", ProcName:'" + StoredProcedures.TRLink_Insert;

            command.CommandText = StoredProcedures.TRLink_Insert;

            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ClientId", SqlDbType.NVarChar).Value = TR.ClientId;
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PropertyDAO Help" + ", ProcName:'" + StoredProcedures.Property_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TRLink_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
