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
    public class LocalityDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
             Locality Lty = new Locality();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1]);            
            Lty.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (Lty.Id != 0)
            {
           //     UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
           //     "', SctId:" + User.SctId + ", Service:LocalityDao Update" + ", ProcName:'" + StoredProcedures.Locality_Update; 

                //Cmd.CommandText = StoredProcedures.Locality_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Lty.Id;
            }
            else
            {
           //     UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            //    "', SctId:" + User.SctId + ", Service:LocalityDao Insert" + ", ProcName:'" + StoredProcedures.Locality_Insert; 

                //Cmd.CommandText = StoredProcedures.Locality_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            Cmd.Parameters.Add("@CityId", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            Cmd.Parameters.Add("@Locality", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["Locality"].Value;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CreatedBy"].Value;
            Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = User.Id;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return Value;
        }

        public DataSet Help(string[] data, User User)
        {
       //     UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
        //     "', SctId:" + User.SctId + ", Service:LocalityDao Help" + ", ProcName:'" + StoredProcedures.Locality_Help;
            
            Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.Locality_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            Cmd.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            Cmd.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Search(string[] data, User User)
        {
        //    UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
        //      "', SctId:" + User.SctId + ", Service:LocalityDao select" + ", ProcName:'" + StoredProcedures.Locality_Select;
            
            Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.Locality_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
         //   UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
         //     "', SctId:" + User.SctId + ", Service:LocalityDao Delete" + ", ProcName:'" + StoredProcedures.Locality_Delete;
            
            Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.Locality_Delete;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@UsrId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
