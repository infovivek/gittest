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
    public class ContractProductMasterDAO
    {
        string UserData;
        public DataSet Save(string Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            ContractProductMaster CPM = new ContractProductMaster();

            CPM.EffectiveFrom =document.SelectSingleNode("HdrXml").Attributes["EffectiveFrom"].Value;
            CPM.ContractRate =Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ContractRate"].Value);
            CPM.IsComplimentary = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["IsComplimentary"].Value);
            CPM.TypeService = document.SelectSingleNode("HdrXml").Attributes["TypeService"].Value;
            CPM.ProductName = document.SelectSingleNode("HdrXml").Attributes["ProductName"].Value;
            CPM.BasePrice = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["BasePrice"].Value);
            CPM.PerQuantityprice = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["PerQuantityprice"].Value);
            CPM.SubType = document.SelectSingleNode("HdrXml").Attributes["SubType"].Value;
            CPM.SubTypeId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["SubTypeId"].Value);
            CPM.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

            if (CPM.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractProductMaster_Update" +
                     ", ProcName:'" + StoredProcedures.ContractProductMaster_Update;

                command.CommandText = StoredProcedures.ContractProductMaster_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = CPM.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractProductMaster_Insert" +
                     ", ProcName:'" + StoredProcedures.ContractProductMaster_Insert;

                command.CommandText = StoredProcedures.ContractProductMaster_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@EffectiveFrom", SqlDbType.NVarChar).Value = CPM.EffectiveFrom;
            command.Parameters.Add("@ContractRate", SqlDbType.Bit).Value =  CPM.ContractRate;
            command.Parameters.Add("@IsComplimentary", SqlDbType.Bit).Value = CPM.IsComplimentary;
            command.Parameters.Add("@TypeService", SqlDbType.NVarChar).Value = CPM.TypeService;
            command.Parameters.Add("@ProductName", SqlDbType.NVarChar).Value = CPM.ProductName;
            command.Parameters.Add("@BasePrice", SqlDbType.Decimal).Value = CPM.BasePrice;
            command.Parameters.Add("@PerQuantityprice", SqlDbType.Decimal).Value = CPM.PerQuantityprice;
            command.Parameters.Add("@SubType", SqlDbType.NVarChar).Value = CPM.SubType;
            command.Parameters.Add("@SubTypeId", SqlDbType.Int).Value = CPM.SubTypeId;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            command.Parameters.Add("@Enable", SqlDbType.Bit).Value = 0;
            command.Parameters.Add("@AmountChange", SqlDbType.Bit).Value = 1;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractProductMaster_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractProductMaster_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }

        public DataSet Help(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractProductMaster_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}
