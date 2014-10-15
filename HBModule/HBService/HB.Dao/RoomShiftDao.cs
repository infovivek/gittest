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
    public class RoomShiftDao
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet HelpResult(string[] data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            command = new SqlCommand();
            command.CommandText = StoredProcedures.RoomShift_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());

            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
