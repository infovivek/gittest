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
    public class LaundryServiceHdrDAO
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
            LaundryServiceHdr LSH = new LaundryServiceHdr();
            LSH.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            LSH.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            LSH.PropertyName = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
            LSH.Date = document.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            LSH.GuestName = document.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            LSH.GuestId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            LSH.BookingId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            LSH.RoomId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            LSH.CheckInId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CheckInId"].Value);
            LSH.GetType = document.SelectSingleNode("HdrXml").Attributes["GetType"].Value;
            LSH.RoomNo = document.SelectSingleNode("HdrXml").Attributes["RoomNo"].Value;
            LSH.BookingCode = document.SelectSingleNode("HdrXml").Attributes["BookingCode"].Value;
            LSH.ClientName = document.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            LSH.TotalAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TotalAmount"].Value);
            if (LSH.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:LSHEntryHdrDAO Update" + ", ProcName:'" + StoredProcedures.LaundryServiceHdr_Update;

                command.CommandText = StoredProcedures.LaundryServiceHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = LSH.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:LSHEntryHdrDAO Insert" + ", ProcName:'" + StoredProcedures.LaundryServiceHdr_Insert;

                command.CommandText = StoredProcedures.LaundryServiceHdr_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = LSH.PropertyId;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = LSH.PropertyName;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = LSH.Date;
            command.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = LSH.GuestName;
            command.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = LSH.RoomNo;
            command.Parameters.Add("@BookingCode", SqlDbType.NVarChar).Value = LSH.BookingCode;
            command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = LSH.ClientName;
            command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = LSH.GuestId;
            command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = LSH.BookingId;
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = LSH.RoomId;
            command.Parameters.Add("@CheckInId", SqlDbType.BigInt).Value = LSH.CheckInId;
            command.Parameters.Add("@GetType", SqlDbType.NVarChar).Value = LSH.GetType;
            command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = LSH.TotalAmount;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:LSHEntryHdrDAO Select" + ", ProcName:'" + StoredProcedures.LaundryServiceHdr_Select;
            command = new SqlCommand();
            command.CommandText = StoredProcedures.LaundryServiceHdr_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
             "', SctId:" + User.SctId + ", Service:LSHEntryHdrDAO Delete" + ", ProcName:'" + StoredProcedures.LaundryServiceHdr_Delete;
            //SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures.LSHEntry_Delete;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:LSHEntryHdrDAO Help" + ", ProcName:'" + StoredProcedures.LaundryServiceHdr_Help;
            command = new SqlCommand();
            command.CommandText = StoredProcedures.LaundryServiceHdr_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@SSId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
