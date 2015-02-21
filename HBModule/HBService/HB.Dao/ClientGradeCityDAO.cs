using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;

namespace HB.Dao
{
    public class ClientGradeCityDAO
    {
        String UserData = "";
        public DataSet Save(string Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            ClientGradeCity ClientGrd = new ClientGradeCity();
            ClientGrd.Grade = document.SelectSingleNode("HdrXml").Attributes["Grade"].Value;
            if (document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value == "")
            {
                ClientGrd.ClientId = 0;
            }
            else
            {
                ClientGrd.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["GradeId"].Value == "")
            {
                ClientGrd.GradeId = 0;
            }
            else
            {
                ClientGrd.GradeId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["GradeId"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["MinValue"].Value == "")
            {
                ClientGrd.MinValue = 0;
            }
            else
            {
                ClientGrd.MinValue = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["MinValue"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["MaxValue"].Value == "")
            {
                ClientGrd.MaxValue = 0;
            }
            else
            {
                ClientGrd.MaxValue = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["MaxValue"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["StarRatingId"].Value == "")
            {
                ClientGrd.StarRatingId = 0;
            }
            else
            {
                ClientGrd.StarRatingId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["StarRatingId"].Value);
            }
            ClientGrd.ValueStarRatingFlag = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ValueStarRatingFlag"].Value);
            command = new SqlCommand();
            ClientGrd.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            if (ClientGrd.Id != 0)
            {

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:ClientGradeCity_Update" +
                  ", ProcName:'" + StoredProcedures.ClientGradeCity_Update;

                command.CommandText = StoredProcedures.ClientGradeCity_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ClientGrd.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:ClientGradeCity Insert" +
                 ", ProcName:'" + StoredProcedures.ClientGradeCity_Insert;

                command.CommandText = StoredProcedures.ClientGradeCity_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@GradeId", SqlDbType.BigInt).Value = ClientGrd.GradeId;
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = ClientGrd.ClientId;
            command.Parameters.Add("@MinValue", SqlDbType.Decimal).Value = ClientGrd.MinValue;
            command.Parameters.Add("@MaxValue", SqlDbType.Decimal).Value = ClientGrd.MaxValue;
            command.Parameters.Add("@Grade", SqlDbType.NVarChar).Value = ClientGrd.Grade;
            command.Parameters.Add("@StarRatingId", SqlDbType.BigInt).Value = ClientGrd.StarRatingId;
            command.Parameters.Add("@ValueStarRatingFlag", SqlDbType.Bit).Value = ClientGrd.ValueStarRatingFlag;
            command.Parameters.Add("@NeedGH", SqlDbType.BigInt).Value = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["NeedGH"].Value);
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:ClientGradeCity_Select" +
                 ", ProcName:'" + StoredProcedures.ClientGradeCity_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ClientGradeCity_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@SelectId", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Delete(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:ClientGradeCity_Delete" +
                 ", ProcName:'" + StoredProcedures.ClientGradeCity_Delete;
        
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ClientGradeCity_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[2].ToString();
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:ClientGradeCity_Help" +
                 ", ProcName:'" + StoredProcedures.ClientGradeCity_Help;

            DataSet ds = new DataSet();
            SqlCommand command = new SqlCommand();
            if (data[1].ToString() != "GradeSave")
            {
                command = new SqlCommand();
                command.CommandText = StoredProcedures.ClientGradeCity_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
                command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
                command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[4].ToString();
                command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = data[5].ToString();
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else
            {
                DataTable dTable = new DataTable("ERRORTBL");
                dTable.Columns.Add("Exception");
                XmlDocument document = new XmlDocument();
                document.LoadXml(data[3].ToString());
                int n = 0;
                n = (document).SelectNodes("//GridXml").Count;
                for (int i = 0; i < n; i++)
                {
                    command = new SqlCommand();
                    command.CommandText = StoredProcedures.ClientGradeCity_Help;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();

                    command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
                    if(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value=="")
                    {
                        command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = 0;
                    }
                    else
                    {
                        command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = document.SelectNodes("//GridXml")[i].Attributes["Id"].Value;
                    }
                    command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = document.SelectNodes("//GridXml")[i].Attributes["Grade"].Value;
                    command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = document.SelectNodes("//GridXml")[i].Attributes["Designation"].Value;
                    command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                    ds = new WrbErpConnection().ExecuteDataSet(command, "");
                }
            }
            return ds;
        }
    }
}
