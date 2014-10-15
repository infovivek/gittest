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
    public class ReassignClientDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
            //UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            ReassignClient Rc = new ReassignClient();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1]);
            Rc.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Rc.Category = doc.SelectSingleNode("HdrXml").Attributes["Category"].Value;
            Rc.UserRole = doc.SelectSingleNode("HdrXml").Attributes["UserRole"].Value;
            Rc.UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            Rc.ReassignId =Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ReassignId"].Value);
            Cmd = new SqlCommand();
            if (Rc.Id != 0)
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                  "', SctId:" + User.SctId + ", Service:ReassignClientDAO Update" + ", ProcName:'" + StoredProcedures.ReassignClient_Update; 

                Cmd.CommandText = StoredProcedures.ReassignClient_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Rc.Id;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = Rc.Category;
            Cmd.Parameters.Add("@UserRole", SqlDbType.NVarChar).Value = Rc.UserRole;
            Cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = Rc.UserId;
            Cmd.Parameters.Add("@ReassignId", SqlDbType.Int).Value = Rc.ReassignId;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return Value;
        }
        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:ReassignClientDAO  " + ", ProcName:'" ;
            
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
               "', SctId:" + User.SctId + ", Service:ReassignClientDAO" + ", ProcName:'"  ;
            
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.ReassignClient_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@SelectId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:ReassignClientDAO " + ", ProcName:'" ;
            
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

    }
} 

