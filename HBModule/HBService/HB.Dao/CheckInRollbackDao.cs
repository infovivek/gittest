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
    public class CheckInRollbackDao
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            CheckInRollback Roll = new CheckInRollback();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);
            
            Roll.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            Roll.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            Roll.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            Roll.Chkindate = doc.SelectSingleNode("HdrXml").Attributes["Chkindate"].Value;
            Roll.ChkoutDate = doc.SelectSingleNode("HdrXml").Attributes["ChkoutDate"].Value;
            Roll.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            Roll.BookingCode = doc.SelectSingleNode("HdrXml").Attributes["BookingCode"].Value;
            Roll.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Roll.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            Roll.PropertyId = Convert.ToInt64(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            Roll.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
            Roll.BedId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BedId"].Value);
            Roll.CheckInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckInHdrId"].Value);
            Roll.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
            Roll.ChangedStatus = doc.SelectSingleNode("HdrXml").Attributes["ChangedStatus"].Value;
            Roll.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            command = new SqlCommand();
            if (Roll.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckInRollback_insert;

                Mode = "Update";
                command.CommandText = StoredProcedures.CheckInHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = Roll.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckInRollback_insert;

                Mode = "Save";
                command.CommandText = StoredProcedures.CheckInRollback_insert;

            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Roll.BookingId;
            command.Parameters.Add("@GuestId", SqlDbType.Int).Value = Roll.GuestId;
            command.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = Roll.GuestName;
            command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = Roll.Property;
            command.Parameters.Add("@Chkindate", SqlDbType.NVarChar).Value = Roll.Chkindate;
            command.Parameters.Add("@ChkoutDate", SqlDbType.NVarChar).Value = Roll.ChkoutDate;
            command.Parameters.Add("@BookingCode", SqlDbType.NVarChar).Value = Roll.BookingCode;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = Roll.RoomId;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Roll.PropertyId;
            command.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = Roll.ApartmentId;
            command.Parameters.Add("@BedId", SqlDbType.Int).Value = Roll.BedId;
            command.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Roll.CheckInHdrId;
            command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = Roll.Type;
            command.Parameters.Add("@ChangedStatus", SqlDbType.NVarChar).Value = Roll.ChangedStatus;
            command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = Roll.BookingLevel;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:CheckInRollback Help" + ", ProcName:'" + StoredProcedures.CheckInRollback_help;

            command = new SqlCommand();
            command.CommandText = StoredProcedures.CheckInRollback_help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt64(data[5].ToString());
            command.Parameters.Add("@CheckInHdrId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            

            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
