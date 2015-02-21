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
    public class CitylocalityDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Locality Lty = new Locality();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1]);
            Lty.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (Lty.Id != 0)
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                  "', SctId:" + User.SctId + ", Service:Citylocality_Update" + ", ProcName:'" + StoredProcedures.Citylocality_Update;

                Cmd.CommandText = StoredProcedures.Citylocality_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Lty.Id;
            }
            else
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                  "', SctId:" + User.SctId + ", Service:Citylocality_Insert" + ", ProcName:'" + StoredProcedures.Citylocality_Insert;

                Cmd.CommandText = StoredProcedures.Citylocality_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            Cmd.Parameters.Add("@Locality", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["Locality"].Value;
            Cmd.Parameters.Add("@UserId", SqlDbType.BigInt).Value = User.Id;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return Value;
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                  "', SctId:" + User.SctId + ", Service:Citylocality_Help" + ", ProcName:'" + StoredProcedures.Citylocality_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.Citylocality_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            Cmd.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            Cmd.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                   "', SctId:" + User.SctId + ", Service:Citylocality_Select" + ", ProcName:'" + StoredProcedures.Citylocality_Select;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.Citylocality_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                  "', SctId:" + User.SctId + ", Service:Citylocality_Delete" + ", ProcName:'" + StoredProcedures.Citylocality_Delete;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.Citylocality_Delete;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
