using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Xml;
using System.Collections;

namespace HB.Dao
{
    public class UserRolesDao
    {
        string UserData;
       // SqlCommand Cmd = new SqlCommand();
        public DataSet Save(int UserMasterId, string Dtlval, User user)
        {
            UserMasterRolesEntity UMrole = new UserMasterRolesEntity();
            XmlDocument document = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            document.LoadXml(Dtlval);

            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                //UMrole.UserId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["CountId"].Value);
                UMrole.RoleId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["UserId"].Value);
                UMrole.Roles = document.SelectNodes("//GridXml")[i].Attributes["UserName"].Value;
                UMrole.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                //UMrole.UserGroup = document.SelectNodes("//GridXml")[i].Attributes["UserGroup"].Value;
                SqlCommand command = new SqlCommand();
                if (UMrole.Id != 0)
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                       "',SctId:" + user.SctId + ",Service:UserRolesDao Search"+",ProcName:'" + StoredProcedures.UserRoles_Update;
                    command.CommandText = StoredProcedures.UserRoles_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = UMrole.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                      "', SctId:" + user.SctId + ", Service:UserRolesDao save" + ", ProcName:'" + StoredProcedures.UserRoles_Insert;
                    command.CommandText = StoredProcedures.UserRoles_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@UserId", SqlDbType.NVarChar).Value =UserMasterId;
                command.Parameters.Add("@RolesId", SqlDbType.NVarChar).Value = UMrole.RoleId;
                command.Parameters.Add("@Roles", SqlDbType.NVarChar).Value = UMrole.Roles;

                ds = new WrbErpConnection().ExecuteDataSet(command,UserData);
            }
            return ds;
        }
    }
}
