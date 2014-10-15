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
  public class PropertyUserDAO
    {
        string UserData;
        public DataSet Save(String PropertyRowId, Int32 PropertyId, string PrtyUser, User user)
        {
             DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

             XmlDocument document = new XmlDocument();
             document.LoadXml(PrtyUser); 
            PropertyUserEntity prptyUser = new PropertyUserEntity();
            int n;
              n = (document).SelectNodes("//GridXml").Count;
              for (int i = 0; i < n; i++)
              {
                  prptyUser.UserId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["UserId"].Value);
                  prptyUser.UserName = document.SelectNodes("//GridXml")[i].Attributes["UserName"].Value;
                  prptyUser.UserType = document.SelectNodes("//GridXml")[i].Attributes["UserType"].Value;
                  prptyUser.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                  command = new SqlCommand();
                  if (prptyUser.Id != 0)
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                         "', SctId:" + user.SctId + ", Service:PropertyUserDAO Update" + ", ProcName:'" + StoredProcedures.PropertyUsers_Update; 

                      command.CommandText = StoredProcedures.PropertyUsers_Update;
                      command.Parameters.Add("@Id", SqlDbType.Int).Value = prptyUser.Id;
                  }
                  else
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                           "', SctId:" + user.SctId + ", Service:PropertyUserDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyUsers_Insert; 

                      command.CommandText = StoredProcedures.PropertyUsers_Insert;
                  }
                  command.CommandType = CommandType.StoredProcedure;
                  command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PropertyId;
                  command.Parameters.Add("@PropertyRowId", SqlDbType.NVarChar).Value = PropertyRowId;
                  command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = prptyUser.UserId;
                  command.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = prptyUser.UserName;
                  command.Parameters.Add("@UserType", SqlDbType.NVarChar).Value = prptyUser.UserType;
                  command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                  ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
              }
            return ds;
        }

    }
}
