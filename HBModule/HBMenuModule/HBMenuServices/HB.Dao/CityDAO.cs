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
    public class CityDAO
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
                Cmd.CommandText = StoredProcedures.City_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Lty.Id;
            }
            else
            {
                Cmd.CommandText = StoredProcedures.City_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            Cmd.Parameters.Add("@City", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["City"].Value;
            Cmd.Parameters.Add("@CityCode", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["CityCode"].Value;
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = User.Id;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return Value;
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.City_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.City_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.City_Delete;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
