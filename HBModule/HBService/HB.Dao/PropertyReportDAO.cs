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
    public class PropertyReportDAO
    {
        PropertyReport PR = new PropertyReport();
         String UserData;
         public DataSet Help(string[] data, User user)
         {
             UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:PettyCashDAO Help" + ", ProcName:'" + StoredProcedures.PettyCash_Help;

             SqlCommand command = new SqlCommand();
             command.CommandText = StoredProcedures.PropertyReport_Help;
             command.CommandType = CommandType.StoredProcedure;
             command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
             command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
             command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
             return new WrbErpConnection().ExecuteDataSet(command, UserData);
         }

         public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO Search" + ", ProcName:'" + StoredProcedures.TDS_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PropertyReport_Search;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@Id3", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            if (data[3]==null)
            {
                PR.Str1 = "";
            }
            else
            {
                PR.Str1 = data[3].ToString(); ;
            }
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = PR.Str1;
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value ="";
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
