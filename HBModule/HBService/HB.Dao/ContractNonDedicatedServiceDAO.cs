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
    public class ContractNonDedicatedServiceDAO
    {
        string UserData;
        public DataSet Save(string NonDedicatedContractServicesDtls, User user, int NonDedicatedContractId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            ContractNondedicatedService ctrNonDdSrv = new ContractNondedicatedService();
            XmlDocument document = new XmlDocument();
            document.LoadXml(NonDedicatedContractServicesDtls);
            int n;
            n = (document).SelectNodes("//ServicesXml").Count;
            for (int i = 0; i < n; i++)
            {
                ctrNonDdSrv.EffectiveFrom = document.SelectNodes("//ServicesXml")[i].Attributes["EffectiveFrom"].Value;
                ctrNonDdSrv.Complimentary = Convert.ToBoolean(document.SelectNodes("//ServicesXml")[i].Attributes["Complimentary"].Value);
                ctrNonDdSrv.ServiceName = document.SelectNodes("//ServicesXml")[i].Attributes["ServiceName"].Value;
                ctrNonDdSrv.Price = Convert.ToDecimal(document.SelectNodes("//ServicesXml")[i].Attributes["Price"].Value);
                ctrNonDdSrv.ProductId = Convert.ToInt32(document.SelectNodes("//ServicesXml")[i].Attributes["ProductId"].Value);
                ctrNonDdSrv.Enable = Convert.ToBoolean(document.SelectNodes("//ServicesXml")[i].Attributes["Enable"].Value);
                ctrNonDdSrv.AmountChange = Convert.ToBoolean(document.SelectNodes("//ServicesXml")[i].Attributes["AmountChange"].Value);
                ctrNonDdSrv.TypeService = document.SelectNodes("//ServicesXml")[i].Attributes["TypeService"].Value;
                if (document.SelectNodes("//ServicesXml")[i].Attributes["Id"].Value == "")
                {
                    ctrNonDdSrv.Id = 0;
                }
                else
                {
                    ctrNonDdSrv.Id = Convert.ToInt32(document.SelectNodes("//ServicesXml")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                if (ctrNonDdSrv.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractNonDedicatedServices_Update" +
                     ", ProcName:'" + StoredProcedures.ContractNonDedicatedServices_Update;

                    command.CommandText = StoredProcedures.ContractNonDedicatedServices_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ctrNonDdSrv.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractNonDedicatedServices_Insert" +
                     ", ProcName:'" + StoredProcedures.ContractNonDedicatedServices_Insert;

                    command.CommandText = StoredProcedures.ContractNonDedicatedServices_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                  command.Parameters.Add("@NondedContractId", SqlDbType.BigInt).Value = NonDedicatedContractId;
                  command.Parameters.Add("@EffectiveFrom", SqlDbType.NVarChar).Value = ctrNonDdSrv.EffectiveFrom;
                  command.Parameters.Add("@Complimentary", SqlDbType.Bit).Value = ctrNonDdSrv.Complimentary;
                  command.Parameters.Add("@Enable", SqlDbType.Bit).Value = ctrNonDdSrv.Enable;
                  command.Parameters.Add("@ServiceName", SqlDbType.NVarChar).Value = ctrNonDdSrv.ServiceName;//Productname
                  command.Parameters.Add("@Price", SqlDbType.Decimal).Value = Convert.ToInt32(ctrNonDdSrv.Price);
                  command.Parameters.Add("@ProductId", SqlDbType.BigInt).Value = Convert.ToInt32(ctrNonDdSrv.ProductId);
                  command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                  command.Parameters.Add("@AmountChange", SqlDbType.BigInt).Value = ctrNonDdSrv.AmountChange;
                  command.Parameters.Add("@TypeService", SqlDbType.NVarChar).Value = ctrNonDdSrv.TypeService;
                  ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }

            return ds;
        }
    }
}