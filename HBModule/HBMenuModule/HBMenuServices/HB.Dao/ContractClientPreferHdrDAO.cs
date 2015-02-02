using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;

namespace HB.Dao
{
    public class ContractClientPreferHdrDAO
    {
        public DataSet Save(string data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            ContractClientPreferHdr ctrclp = new ContractClientPreferHdr();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data);
            ctrclp.ClientName = document.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            ctrclp.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            ctrclp.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            
            if (ctrclp.Id != 0)
            {
                command.CommandText = StoredProcedures.ContractClientpreferHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ctrclp.Id;
            }
            else
            {
                command.CommandText = StoredProcedures.ContractClientpreferHdr_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value ="";
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = ctrclp.ClientId;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, "");
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractClientprefer_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Delete(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractClientprefer_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[1].ToString();
            //command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[2].ToString();
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Help(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractClientprefer_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}
