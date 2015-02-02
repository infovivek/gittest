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
    public class PropertyWiseServiceDAO
    {
        string UserData;
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
       "', SctId:" + user.SctId + ", Service:PropertyWiseServiceDAO Help" + ", ProcName:'" + StoredProcedures.PropertyWiseService_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PropertyWiseService_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@PayMode", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@FromDt", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@ToDt", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@CityId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.Int).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@ChkMode", SqlDbType.Int).Value = Convert.ToInt32(data[8].ToString());
            command.Parameters.Add("@PrptyType", SqlDbType.NVarChar).Value = data[9].ToString();
            command.Parameters.Add("@MonthWise", SqlDbType.Int).Value = Convert.ToInt32(data[10].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
