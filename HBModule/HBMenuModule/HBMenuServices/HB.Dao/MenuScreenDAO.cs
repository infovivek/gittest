using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
namespace HB.Dao
{
   public class MenuScreenDAO
    {
       String UserData;
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:MenuScreenDAO Help" + ", ProcName:'" + StoredProcedures.MenuScreen_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.MenuScreen_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.NVarChar).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Hdrval[2].ToString();
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Hdrval[3].ToString();
            command.Parameters.Add("@Pram3", SqlDbType.NVarChar).Value = Hdrval[4].ToString();
            command.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = Hdrval[5].ToString();
            command.Parameters.Add("@Password", SqlDbType.NVarChar).Value = Hdrval[6].ToString();
            command.Parameters.Add("@userIds", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
