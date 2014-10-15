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
    public class KOTEntryHdrDao
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1]);
            KOTEntryHdr KOTentry = new KOTEntryHdr();
            KOTentry.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            KOTentry.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            KOTentry.BookingId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            KOTentry.CheckInId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CheckInId"].Value);
            KOTentry.PropertyName = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
            KOTentry.Date = document.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            if (KOTentry.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:KOTEntryHdrDao Update" + ", ProcName:'" + StoredProcedures.KOTEntryHdr_Update; 

                command.CommandText = StoredProcedures.KOTEntryHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = KOTentry.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:KOTEntryHdrDao Insert" + ", ProcName:'" + StoredProcedures.KOTEntryHdr_Insert; 

                command.CommandText = StoredProcedures.KOTEntryHdr_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = KOTentry.PropertyId;
            command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = KOTentry.BookingId;
            command.Parameters.Add("@CheckInId", SqlDbType.BigInt).Value = KOTentry.CheckInId;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = KOTentry.PropertyName;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = KOTentry.Date;
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:KOTEntryHdrDao Select" + ", ProcName:'" + StoredProcedures.KOTEnrty_Select;
            
            command = new SqlCommand();
            command.CommandText = StoredProcedures.KOTEnrty_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
             "', SctId:" + User.SctId + ", Service:KOTEntryHdrDao Delete" + ", ProcName:'" + StoredProcedures.KOTEntry_Delete;
            
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.KOTEntry_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:KOTEntryHdrDao Help" + ", ProcName:'" + StoredProcedures.KOT_Help;
            
            command = new SqlCommand();
            command.CommandText = StoredProcedures.KOT_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
