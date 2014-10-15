using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;

namespace HB.Dao
{
    public class BookingMailResendDAO
    {
        public DataSet Help(string[] data, User user)
        {
            string UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingRoomMailDAO" + ", ProcName:'" + StoredProcedures.BookingMailResend_Help;
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.BookingMailResend_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = data[5].ToString();
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = Convert.ToInt32(data[8].ToString());            
            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = Convert.ToInt32(data[9].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
