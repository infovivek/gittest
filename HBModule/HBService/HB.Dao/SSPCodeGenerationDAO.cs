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
  public class SSPCodeGenerationDAO
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
            SSPCodeGeneration SSPC = new SSPCodeGeneration();
            SSPC.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);          
            SSPC.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);          
            SSPC.SSPCode = document.SelectSingleNode("HdrXml").Attributes["SSPCode"].Value;
            SSPC.SSPName = document.SelectSingleNode("HdrXml").Attributes["SSPName"].Value;
            SSPC.BookingLevel = document.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            if (document.SelectSingleNode("HdrXml").Attributes["SingleTariff"].Value == "")
            {
                SSPC.SingleTariff = 0;
            }
            else
            {
                SSPC.SingleTariff = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["SingleTariff"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["DoubleTariff"].Value == "")
            {
                SSPC.DoubleTariff = 0;
            }
            else
            {
                SSPC.DoubleTariff = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["DoubleTariff"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["TripleTariff"].Value == "")
            {
                SSPC.TripleTariff = 0;
            }
            else
            {
                SSPC.TripleTariff = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TripleTariff"].Value);
            }
            SSPC.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            if (SSPC.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationDAO Update" + ", ProcName:'" + StoredProcedures.SSPCodeGeneration_Update;

                command.CommandText = StoredProcedures.SSPCodeGeneration_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = SSPC.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationDAO Insert" + ", ProcName:'" + StoredProcedures.SSPCodeGeneration_Insert;

                command.CommandText = StoredProcedures.SSPCodeGeneration_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = SSPC.PropertyId;
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = SSPC.ClientId;           
            command.Parameters.Add("@SSPCode", SqlDbType.NVarChar).Value = SSPC.SSPCode;
            command.Parameters.Add("@SSPName", SqlDbType.NVarChar).Value = SSPC.SSPName;
            command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = SSPC.BookingLevel;
            command.Parameters.Add("@SingleTariff", SqlDbType.Decimal).Value = SSPC.SingleTariff;
            command.Parameters.Add("@DoubleTariff", SqlDbType.Decimal).Value = SSPC.DoubleTariff;
            command.Parameters.Add("@TripleTariff", SqlDbType.Decimal).Value = SSPC.TripleTariff;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationDAO Search" + ", ProcName:'" + StoredProcedures.SSPCodeGeneration_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.SSPCodeGeneration_Select;
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
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationDAO Delete" + ", ProcName:'" + StoredProcedures.SSPCodeGeneration_Delete;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.SSPCodeGeneration_Delete;
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
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationDAO Help" + ", ProcName:'" + StoredProcedures.SSPCodeGeneration_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.SSPCodeGeneration_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Pram1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Pram3", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
