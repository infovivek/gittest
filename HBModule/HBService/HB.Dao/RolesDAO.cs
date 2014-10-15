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
    public class RolesDAO
    {
        String UserData;
        public DataSet Save(string Hdrval, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
           Roles rls = new Roles();
          
           rls.RoleName = document.SelectSingleNode("HdrXml").Attributes["RoleName"].Value;
          // rls.RoleGroup =document.SelectSingleNode("HdrXml").Attributes["RoleGroup"].Value;
           rls.Statuss = document.SelectSingleNode("HdrXml").Attributes["Statuss"].Value; 
         //rls.RoleGroupId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["RoleGroupId"].Value);
           rls.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
           if (rls.Id != 0)
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:RolesDAO Update" + ", ProcName:'" + StoredProcedures.Roles_Update;

              command.CommandText = StoredProcedures.Roles_Update;
              command.Parameters.Add("@Id", SqlDbType.Int).Value = rls.Id;

           }
           else
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:RolesDAO Insert" + ", ProcName:'" + StoredProcedures.Roles_Insert;

               command.CommandText = StoredProcedures.Roles_Insert;
           }
             command.CommandType = CommandType.StoredProcedure;
             command.Parameters.Add("@Rolename", SqlDbType.NVarChar).Value = rls.RoleName;
             command.Parameters.Add("@Statuss", SqlDbType.NVarChar).Value = rls.Statuss;
             command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
          
           ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           return ds;
       }
       public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:RolesDAO Search" + ", ProcName:'" + StoredProcedures.Roles_Select;

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Roles_Select;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
           command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Delete(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:RolesDAO Delete" + ", ProcName:'" + StoredProcedures.Roles_Delete;

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Roles_Delete;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
           command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Help(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:RolesDAO Help" + ", ProcName:'" + StoredProcedures.Roles_Help;

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Roles_Help;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
           command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());        
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       
   }
}
    
