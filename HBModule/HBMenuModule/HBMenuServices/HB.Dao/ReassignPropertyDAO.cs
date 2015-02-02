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
    public class ReassignPropertyDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
             ReassignProperty Rp = new ReassignProperty();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1]);
            Rp.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Rp.Category = doc.SelectSingleNode("HdrXml").Attributes["Category"].Value;
            Rp.UserRole = doc.SelectSingleNode("HdrXml").Attributes["UserRole"].Value;
            Rp.UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            Rp.ReassignId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            Cmd = new SqlCommand();
            if (Rp.Id != 0)
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:ReassignPropertyDAO Update" + ", ProcName:'" + StoredProcedures.ReassignProperty_Update; 

                Cmd.CommandText = StoredProcedures.ReassignProperty_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Rp.Id;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = Rp.Category;
            Cmd.Parameters.Add("@UserRole", SqlDbType.NVarChar).Value = Rp.UserRole;
            Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Rp.UserId;
            Cmd.Parameters.Add("@ReassignId", SqlDbType.Int).Value = Rp.ReassignId;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);

            return Value;
        }
        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                 "', SctId:" + User.SctId + ", Service:ReassignPropertyDAO " + ", Nil:'"; 
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                 "', SctId:" + User.SctId + ", Service:ReassignPropertyDAO " + ", Nil:'"; 
           return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
               "', SctId:" + User.SctId + ", Service:ReassignPropertyDAO  " + ", Nil:'"; 
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
