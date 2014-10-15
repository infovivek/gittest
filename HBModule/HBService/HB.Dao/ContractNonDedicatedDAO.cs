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
    public class ContractNonDedicatedDAO
    {
        public DataSet Save(string data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            ContractNonDedicated ctrNonDd = new ContractNonDedicated();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data);
            ctrNonDd.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            ctrNonDd.ContractType = document.SelectSingleNode("HdrXml").Attributes["ContractType"].Value;
            ctrNonDd.ContractName = document.SelectSingleNode("HdrXml").Attributes["ContractName"].Value;
            ctrNonDd.ClientName = document.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            //ctrNonDd.Property = document.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            ctrNonDd.StartDate = document.SelectSingleNode("HdrXml").Attributes["StartDate"].Value;
            ctrNonDd.EndDate = document.SelectSingleNode("HdrXml").Attributes["EndDate"].Value;
            ctrNonDd.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            ctrNonDd.TransName = document.SelectSingleNode("HdrXml").Attributes["TransName"].Value;
            ctrNonDd.TransId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["TransId"].Value);
            ctrNonDd.Types = document.SelectSingleNode("HdrXml").Attributes["Types"].Value;
            ctrNonDd.PricingModel = document.SelectSingleNode("HdrXml").Attributes["PricingModel"].Value;
           // ctrNonDd.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            if (ctrNonDd.Id != 0)
            {
                command.CommandText = StoredProcedures.ContractNonDedicated_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ctrNonDd.Id;
            }
            else
            {
                command.CommandText = StoredProcedures.ContractNonDedicated_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ContractType", SqlDbType.NVarChar).Value = ctrNonDd.ContractType;
            command.Parameters.Add("@ContractName", SqlDbType.NVarChar).Value = ctrNonDd.ContractName;
            command.Parameters.Add("@Client", SqlDbType.NVarChar).Value = ctrNonDd.ClientName;
            command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = "";//ctrNonDd.Property;
            command.Parameters.Add("@StartDate", SqlDbType.NVarChar).Value = ctrNonDd.StartDate;
            command.Parameters.Add("@EndDate", SqlDbType.NVarChar).Value = ctrNonDd.EndDate;
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = ctrNonDd.ClientId;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = 0;//ctrNonDd.PropertyId;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            command.Parameters.Add("@TransName", SqlDbType.NVarChar).Value = ctrNonDd.TransName;
            command.Parameters.Add("@TransId", SqlDbType.BigInt).Value = ctrNonDd.TransId;
            command.Parameters.Add("@Types", SqlDbType.NVarChar).Value = ctrNonDd.Types;
            command.Parameters.Add("@PricingModel", SqlDbType.NVarChar).Value = ctrNonDd.PricingModel;
            ds = new WrbErpConnection().ExecuteDataSet(command, "");
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractNonDedicated_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@SelectId", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Delete(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractNonDedicated_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[1].ToString();
            command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[2].ToString();
            command.Parameters.Add("@DeleteId", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Help(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractNonDedicated_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@HelpId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
          //  command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Pram2", SqlDbType.NVarChar).Value =data[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}
