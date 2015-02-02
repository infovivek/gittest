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
    public class MarkUpDAO
    {
        String UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:MarkUpDAO Insert" + ", ProcName:'" + StoredProcedures.MarkUp_Insert;
     
            MarkUpEntity ME = new MarkUpEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(data[1].ToString());
            SqlCommand command = new SqlCommand();
            ME.Mode=doc.SelectSingleNode("//HdrXml").Attributes["Mode"].Value;

            if (ME.Mode == "MarkUp")
            {
                ME.Flag = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["Flag"].Value);
                ME.Value = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["Value"].Value);
                ME.Id = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["Id"].Value);

                command.CommandText = StoredProcedures.MarkUp_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Value", SqlDbType.BigInt).Value = ME.Value;
                command.Parameters.Add("@Flag", SqlDbType.Int).Value = ME.Flag;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ME.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            if (ME.Mode == "MMT")
            {
                ME.MMT = Convert.ToDecimal(doc.SelectSingleNode("//HdrXml").Attributes["MMT"].Value);

                command.CommandText = StoredProcedures.MMTMarkup_Insert;
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@MMT", SqlDbType.Decimal).Value = ME.MMT;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ME.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:MarkUpDAO Select" + ", ProcName:'" + StoredProcedures.MarkUp_Select;
     
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.MarkUp_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:MarkUpDAO Delete" + ", ProcName:'" + StoredProcedures.MarkUp_Delete;
     
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.MarkUp_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:MarkUpDAO Help" + ", ProcName:'" + StoredProcedures.MarkUp_Help;
     
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.MarkUp_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
