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
    public class PaymentWiseServiceDAO
    {
        string UserData;
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
       "', SctId:" + user.SctId + ", Service:PaymentWiseServiceDAO Help" + ", ProcName:'" + StoredProcedures.PaymentWiseService_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PaymentWiseService_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@FromDt", SqlDbType.NVarChar).Value =data[2].ToString();
            command.Parameters.Add("@ToDt", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@ClientId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
