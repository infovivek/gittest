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
    public class NewKOTUserEntryHdrDAO
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
            NewKOTUserEntryHdr NewKOT = new NewKOTUserEntryHdr();
            NewKOT.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            NewKOT.PropertyName = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
            NewKOT.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            NewKOT.UserName = document.SelectSingleNode("HdrXml").Attributes["UserName"].Value;
            NewKOT.UserId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            NewKOT.GetType = document.SelectSingleNode("HdrXml").Attributes["GetType"].Value;
            NewKOT.Date = document.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            NewKOT.TotalAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TotalAmount"].Value);
            if (NewKOT.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:NewKOTUserEntryHdrDAO Update" + ", ProcName:'" + StoredProcedures.NewKOTUserEntryHdr_Update;

                command.CommandText = StoredProcedures.NewKOTUserEntryHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = NewKOT.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:NewKOTUserEntryHdrDAO Insert" + ", ProcName:'" + StoredProcedures.NewKOTUserEntryHdr_Insert;

                command.CommandText = StoredProcedures.NewKOTUserEntryHdr_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = NewKOT.PropertyId;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = NewKOT.PropertyName;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = NewKOT.Date;
            command.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = NewKOT.UserName;
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = NewKOT.UserId;
            command.Parameters.Add("@GetType", SqlDbType.NVarChar).Value = NewKOT.GetType;
            command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = NewKOT.TotalAmount;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:NewKOTEntryHdrDAO Select" + ", ProcName:'" + StoredProcedures.NewKOTUserEntryHdr_Select;
            command = new SqlCommand();
            command.CommandText = StoredProcedures.NewKOTUserEntryHdr_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
             "', SctId:" + User.SctId + ", Service:NewKOTEntryHdrDAO Delete" + ", ProcName:'" + StoredProcedures.NewKOTEntry_Delete;
            //SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures.NewKOTEntry_Delete;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:NewKOTEntryHdrDAO Help" + ", ProcName:'" + StoredProcedures.NewKOT_Help;
            //command = new SqlCommand();
            //command.CommandText = StoredProcedures.NewKOTUserEntry_Help;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            //command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            //command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            //command.Parameters.Add("@SSId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
