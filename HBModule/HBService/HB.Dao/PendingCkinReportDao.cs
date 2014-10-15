using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using HB.Dao;

namespace HB.Dao
{
   public class PendingCkinReportDao
    {
        public DataSet Help(string[] data, User user)
        {
            string UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : '" + user.ScreenName +
            "', SctId : " + user.SctId + ", Service :PendingChkinReport_Help ReportsDAO" + ", ProcName : '" + StoredProcedures.Reports_Help;
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PendingChkinReport_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@FromDt", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@ToDt", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[5].ToString(); 
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString()); 
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(user.Id);
            DataSet ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
    }
}
