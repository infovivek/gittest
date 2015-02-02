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
    public class BookingResendMailDAO
    {
        String UserData;
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:BookingResendMailDAO Help" + ", ProcName:'" + StoredProcedures.BookingMail_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.BookingMail_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
