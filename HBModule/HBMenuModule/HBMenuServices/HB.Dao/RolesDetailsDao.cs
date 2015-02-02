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
    public class RolesDetailsDao
    {
        String UserData;
        public DataSet Save(int RolesId, string Dtlval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(Dtlval);
            RolesDetails rldl = new RolesDetails();
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {

                rldl.ScreenName = document.SelectNodes("//GridXml")[i].Attributes["ScreenName"].Value;
                rldl.scrId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["screenId"].Value);
                //rldl.ModuleName = document.SelectNodes("//GridXml")[i].Attributes["ModuleName"].Value;
                rldl.ModuleId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ModuleId"].Value);
                rldl.Rights = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Rights"].Value);
                rldl.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                command = new SqlCommand();
                if (rldl.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:RolesDetailsDao Update" + ", ProcName:'" + StoredProcedures.RolesDetails_Update;

                    command.CommandText = StoredProcedures.RolesDetails_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = rldl.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:RolesDetailsDao Insert" + ", ProcName:'" + StoredProcedures.RolesDetails_Insert;

                    command.CommandText = StoredProcedures.RolesDetails_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RolesId", SqlDbType.Int).Value = RolesId;
                command.Parameters.Add("@ScreenName", SqlDbType.NVarChar).Value = rldl.ScreenName;
                command.Parameters.Add("@scrId", SqlDbType.NVarChar).Value = rldl.scrId;
                command.Parameters.Add("@ModuleName", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@ModuleId", SqlDbType.NVarChar).Value = rldl.ModuleId;
                command.Parameters.Add("@Selected", SqlDbType.Int).Value = rldl.Rights;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
               // command.Parameters.Add("@Id", SqlDbType.Int).Value = rldl.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }
              
             
    }
}
