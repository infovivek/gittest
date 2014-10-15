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
    public class ClientWisePriceDAO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            ClientWisePriceEntity PE = new ClientWisePriceEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(data[1].ToString());
            SqlCommand command = new SqlCommand();

            PE.Id = Convert.ToInt32(doc.SelectSingleNode("//Price").Attributes["Id"].Value);
            XmlDocument document = new XmlDocument();
            //PE.PriceId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["PriceId"].Value);
            document.LoadXml(data[2].ToString());
            int n;
            n = (document).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                PE.ClientId = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["ClientId"].Value);
                PE.Date = document.SelectNodes("//HdrXml")[i].Attributes["Date"].Value;
                command = new SqlCommand();
                if (PE.Id != 0)
                {
                    command.CommandText = StoredProcedures.ClientWisePrice_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = PE.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.ClientWisePrice_Insert;
                }
                
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PricingModelId", SqlDbType.BigInt).Value = PE.Id;
                command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = PE.ClientId;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = PE.Date;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, "");
            }
            return ds;
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ClientWisePrice_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}
