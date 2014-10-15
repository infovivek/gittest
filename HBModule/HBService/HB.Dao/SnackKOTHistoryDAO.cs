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
    public class SnackKOTHistoryDAO
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:SnackKOTHistoryDAO Insert" + ", ProcName:'" + StoredProcedures.SnackKOTHistory_Help; 

            command = new SqlCommand();
            command.CommandText = StoredProcedures.SnackKOTHistory_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@GuestId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
