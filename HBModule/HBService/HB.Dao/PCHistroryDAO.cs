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
    public class PCHistroryDAO
    {
        String UserData;
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PCHistroryDAO Help" + ", ProcName:'" + StoredProcedures.PCHistory_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PCHistory_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[5].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
