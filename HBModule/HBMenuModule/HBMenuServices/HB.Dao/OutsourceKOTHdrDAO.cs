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
    public class OutsourceKOTHdrDAO
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
            OutsourceKOTHdr NewKOT = new OutsourceKOTHdr();
            NewKOT.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            NewKOT.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            NewKOT.PropertyName = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
            NewKOT.Date = document.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            NewKOT.TotalAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TotalAmount"].Value);
            if (NewKOT.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:OutsourceKOTHdrDAO Update" + ", ProcName:'" + StoredProcedures.OutsourceKOTHdr_Update;

                command.CommandText = StoredProcedures.OutsourceKOTHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = NewKOT.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:OutsourceKOTHdr Insert" + ", ProcName:'" + StoredProcedures.OutsourceKOTHdr_Insert;

                command.CommandText = StoredProcedures.OutsourceKOTHdr_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = NewKOT.PropertyId;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = NewKOT.PropertyName;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = NewKOT.Date;
            command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = NewKOT.TotalAmount;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:OutsourceKOTHdrDAO Select" + ", ProcName:'" + StoredProcedures.OutsourceKOTHdr_Select;
            command = new SqlCommand();
            command.CommandText = StoredProcedures.OutsourceKOTHdr_Select;
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
               "', SctId:" + user.SctId + ", Service:OutsourceKOTHdrDAO Help" + ", ProcName:'" + StoredProcedures.OutsourceKOTHdr_Help;
            command = new SqlCommand();
            command.CommandText = StoredProcedures.OutsourceKOTHdr_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
