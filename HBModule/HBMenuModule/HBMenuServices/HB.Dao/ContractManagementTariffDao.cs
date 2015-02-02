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
   public class ContractManagementTariffDao
    {
       public DataSet Save(string data, User user, int ContractId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(data);
           ContractManagementTariff CMT = new ContractManagementTariff();
           int n;
           n = (document).SelectNodes("//TarrifXml").Count;
           for (int i = 0; i < n; i++)
           {

               CMT.EffectiveFrom = document.SelectNodes("//TarrifXml")[i].Attributes["AgremenDate"].Value;
               CMT.EffectiveTo = document.SelectNodes("//TarrifXml")[i].Attributes["EndDate"].Value;
               CMT.TarrifPrice = Convert.ToDecimal(document.SelectNodes("//TarrifXml")[i].Attributes["TarifAmt"].Value);
               CMT.TariffChk = document.SelectNodes("//TarrifXml")[i].Attributes["TarifChk"].Value;
               CMT.BookLevel = document.SelectNodes("//TarrifXml")[i].Attributes["BookLevel"].Value;
               if (document.SelectNodes("//TarrifXml")[i].Attributes["Id"].Value == "")
                  {
                      CMT.Id = 0;
                  }
                  else
                  {
                      CMT.Id = Convert.ToInt32(document.SelectNodes("//TarrifXml")[i].Attributes["Id"].Value);
                  }
               command = new SqlCommand();
               if (CMT.Id != 0)
               {
                   command.CommandText = StoredProcedures.ContractManagementTariffAppartment_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = CMT.Id;
               }
               else
               {
                   command.CommandText = StoredProcedures.ContractManagementTariffAppartment_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ContractId", SqlDbType.BigInt).Value = ContractId;;
               command.Parameters.Add("@EffectiveFrom", SqlDbType.NVarChar).Value = CMT.EffectiveFrom;
               command.Parameters.Add("@EffectiveTo", SqlDbType.NVarChar).Value = CMT.EffectiveTo;
               command.Parameters.Add("@TariffChk", SqlDbType.Bit).Value = Convert.ToBoolean(CMT.TariffChk);
               command.Parameters.Add("@BookLevel", SqlDbType.NVarChar).Value = CMT.BookLevel;
               command.Parameters.Add("@TarrifPrice", SqlDbType.Decimal).Value = CMT.TarrifPrice;
               command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
               ds = new WrbErpConnection().ExecuteDataSet(command, "");
           }
           if (n == 0)
           {
               ds.Tables.Add(dTable);
           }
         
           return ds;
       }
    }
}
