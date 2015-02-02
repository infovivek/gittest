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
    public class NewKOTVendorReportDAO
    {
        String UserData;
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:NewKOTVendorReportDAO Help" + ", ProcName:'" + StoredProcedures.NewKOTVendorReport_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.NewKOTVendorReport_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@VendorId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[5].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
